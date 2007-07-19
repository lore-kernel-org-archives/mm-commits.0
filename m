From: akpm@linux-foundation.org
Subject: - x86_64-mcelog-tolerant-level-cleanup.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:08:41 -0700
Message-ID: <200707192008.l6JK8fou020480@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38732 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761158AbXGSUPm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thockin@google.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: mcelog tolerant level cleanup
has been removed from the -mm tree.  Its filename was
     x86_64-mcelog-tolerant-level-cleanup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: mcelog tolerant level cleanup
From: Tim Hockin <thockin@google.com>

Background:
 The MCE handler has several paths that it can take, depending on various
 conditions of the MCE status and the value of the 'tolerant' knob.  The
 exact semantics are not well defined and the code is a bit twisty.

Description:
 This patch makes the MCE handler's behavior more clear by documenting the
 behavior for various 'tolerant' levels.  It also fixes or enhances
 several small things in the handler.  Specifically:
     * If RIPV is set it is not safe to restart, so set the 'no way out'
       flag rather than the 'kill it' flag.
     * Don't panic() on correctable MCEs.
     * If the _OVER bit is set *and* the _UC bit is set (meaning possibly
       dropped uncorrected errors), set the 'no way out' flag.
     * Use EIPV for testing whether an app can be killed (SIGBUS) rather
       than RIPV.  According to docs, EIPV indicates that the error is
       related to the IP, while RIPV simply means the IP is valid to
       restart from.
     * Don't clear the MCi_STATUS registers until after the panic() path.
       This leaves the status bits set after the panic() so clever BIOSes
       can find them (and dumb BIOSes can do nothing).

 This patch also calls nonseekable_open() in mce_open (as suggested by akpm).

Result:
 Tolerant levels behave almost identically to how they always have, but
 not it's well defined.  There's a slightly higher chance of panic()ing
 when multiple errors happen (a good thing, IMHO).  If you take an MBE and
 panic(), the error status bits are not cleared.

Alternatives:
 None.

Testing:
 I used software to inject correctable and uncorrectable errors.  With
 tolerant = 3, the system usually survives.  With tolerant = 2, the system
 usually panic()s (PCC) but not always.  With tolerant = 1, the system
 always panic()s.  When the system panic()s, the BIOS is able to detect
 that the cause of death was an MC4.  I was not able to reproduce the
 case of a non-PCC error in userspace, with EIPV, with (tolerant < 3).
 That will be rare at best.

Signed-off-by: Tim Hockin <thockin@google.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/x86_64/boot-options.txt |    8 +
 Documentation/x86_64/machinecheck     |   14 +--
 arch/x86_64/kernel/mce.c              |  101 +++++++++++++++---------
 3 files changed, 80 insertions(+), 43 deletions(-)

diff -puN Documentation/x86_64/boot-options.txt~x86_64-mcelog-tolerant-level-cleanup Documentation/x86_64/boot-options.txt
--- a/Documentation/x86_64/boot-options.txt~x86_64-mcelog-tolerant-level-cleanup
+++ a/Documentation/x86_64/boot-options.txt
@@ -14,9 +14,11 @@ Machine check
    mce=nobootlog
 		Disable boot machine check logging.
    mce=tolerancelevel (number)
-		0: always panic, 1: panic if deadlock possible,
-		2: try to avoid panic, 3: never panic or exit (for testing)
-		default is 1
+		0: always panic on uncorrected errors, log corrected errors
+		1: panic or SIGBUS on uncorrected errors, log corrected errors
+		2: SIGBUS or log uncorrected errors, log corrected errors
+		3: never panic or SIGBUS, log all errors (for testing only)
+		Default is 1
 		Can be also set using sysfs which is preferable.
 
    nomce (for compatibility with i386): same as mce=off
diff -puN Documentation/x86_64/machinecheck~x86_64-mcelog-tolerant-level-cleanup Documentation/x86_64/machinecheck
--- a/Documentation/x86_64/machinecheck~x86_64-mcelog-tolerant-level-cleanup
+++ a/Documentation/x86_64/machinecheck
@@ -49,12 +49,14 @@ tolerant
 	Since machine check exceptions can happen any time it is sometimes
 	risky for the kernel to kill a process because it defies
 	normal kernel locking rules. The tolerance level configures
-	how hard the kernel tries to recover even at some risk of deadlock.
-
-	0: always panic,
-	1: panic if deadlock possible,
-	2: try to avoid panic,
-   	3: never panic or exit (for testing only)
+	how hard the kernel tries to recover even at some risk of
+	deadlock.  Higher tolerant values trade potentially better uptime
+	with the risk of a crash or even corruption (for tolerant >= 3).
+
+	0: always panic on uncorrected errors, log corrected errors
+	1: panic or SIGBUS on uncorrected errors, log corrected errors
+	2: SIGBUS or log uncorrected errors, log corrected errors
+	3: never panic or SIGBUS, log all errors (for testing only)
 
 	Default: 1
 
diff -puN arch/x86_64/kernel/mce.c~x86_64-mcelog-tolerant-level-cleanup arch/x86_64/kernel/mce.c
--- a/arch/x86_64/kernel/mce.c~x86_64-mcelog-tolerant-level-cleanup
+++ a/arch/x86_64/kernel/mce.c
@@ -37,8 +37,13 @@ atomic_t mce_entry;
 
 static int mce_dont_init;
 
-/* 0: always panic, 1: panic if deadlock possible, 2: try to avoid panic,
-   3: never panic or exit (for testing only) */
+/*
+ * Tolerant levels:
+ *   0: always panic on uncorrected errors, log corrected errors
+ *   1: panic or SIGBUS on uncorrected errors, log corrected errors
+ *   2: SIGBUS or log uncorrected errors (if possible), log corrected errors
+ *   3: never panic or SIGBUS, log all errors (for testing only)
+ */
 static int tolerant = 1;
 static int banks;
 static unsigned long bank[NR_BANKS] = { [0 ... NR_BANKS-1] = ~0UL };
@@ -132,9 +137,6 @@ static void mce_panic(char *msg, struct 
 { 
 	int i;
 
-	if (tolerant >= 3)
-		return;
-
 	oops_begin();
 	for (i = 0; i < MCE_LOG_LEN; i++) {
 		unsigned long tsc = mcelog.entry[i].tsc;
@@ -178,11 +180,19 @@ static inline void mce_get_rip(struct mc
 void do_machine_check(struct pt_regs * regs, long error_code)
 {
 	struct mce m, panicm;
-	int nowayout = (tolerant < 1); 
-	int kill_it = 0;
 	u64 mcestart = 0;
 	int i;
 	int panicm_found = 0;
+	/*
+	 * If no_way_out gets set, there is no safe way to recover from this
+	 * MCE.  If tolerant is cranked up, we'll try anyway.
+	 */
+	int no_way_out = 0;
+	/*
+	 * If kill_it gets set, there might be a way to recover from this
+	 * error.
+	 */
+	int kill_it = 0;
 
 	atomic_inc(&mce_entry);
 
@@ -194,8 +204,9 @@ void do_machine_check(struct pt_regs * r
 	memset(&m, 0, sizeof(struct mce));
 	m.cpu = smp_processor_id();
 	rdmsrl(MSR_IA32_MCG_STATUS, m.mcgstatus);
+	/* if the restart IP is not valid, we're done for */
 	if (!(m.mcgstatus & MCG_STATUS_RIPV))
-		kill_it = 1;
+		no_way_out = 1;
 	
 	rdtscll(mcestart);
 	barrier();
@@ -214,10 +225,18 @@ void do_machine_check(struct pt_regs * r
 			continue;
 
 		if (m.status & MCI_STATUS_EN) {
-			/* In theory _OVER could be a nowayout too, but
-			   assume any overflowed errors were no fatal. */
-			nowayout |= !!(m.status & MCI_STATUS_PCC);
-			kill_it |= !!(m.status & MCI_STATUS_UC);
+			/* if PCC was set, there's no way out */
+			no_way_out |= !!(m.status & MCI_STATUS_PCC);
+			/*
+			 * If this error was uncorrectable and there was
+			 * an overflow, we're in trouble.  If no overflow,
+			 * we might get away with just killing a task.
+			 */
+			if (m.status & MCI_STATUS_UC) {
+				if (tolerant < 1 || m.status & MCI_STATUS_OVER)
+					no_way_out = 1;
+				kill_it = 1;
+			}
 		}
 
 		if (m.status & MCI_STATUS_MISCV)
@@ -228,7 +247,6 @@ void do_machine_check(struct pt_regs * r
 		mce_get_rip(&m, regs);
 		if (error_code >= 0)
 			rdtscll(m.tsc);
-		wrmsrl(MSR_IA32_MC0_STATUS + i*4, 0);
 		if (error_code != -2)
 			mce_log(&m);
 
@@ -251,37 +269,52 @@ void do_machine_check(struct pt_regs * r
 	   the last one (shouldn't happen, just being safe). */
 	if (!panicm_found)
 		panicm = m;
-	if (nowayout)
+
+	/*
+	 * If we have decided that we just CAN'T continue, and the user
+	 *  has not set tolerant to an insane level, give up and die.
+	 */
+	if (no_way_out && tolerant < 3)
 		mce_panic("Machine check", &panicm, mcestart);
-	if (kill_it) {
+
+	/*
+	 * If the error seems to be unrecoverable, something should be
+	 * done.  Try to kill as little as possible.  If we can kill just
+	 * one task, do that.  If the user has set the tolerance very
+	 * high, don't try to do anything at all.
+	 */
+	if (kill_it && tolerant < 3) {
 		int user_space = 0;
 
-		if (m.mcgstatus & MCG_STATUS_RIPV)
+		/*
+		 * If the EIPV bit is set, it means the saved IP is the
+		 * instruction which caused the MCE.
+		 */
+		if (m.mcgstatus & MCG_STATUS_EIPV)
 			user_space = panicm.rip && (panicm.cs & 3);
-		
-		/* When the machine was in user space and the CPU didn't get
-		   confused it's normally not necessary to panic, unless you 
-		   are paranoid (tolerant == 0)
-
-		   RED-PEN could be more tolerant for MCEs in idle,
-		   but most likely they occur at boot anyways, where
-		   it is best to just halt the machine. */
-		if ((!user_space && (panic_on_oops || tolerant < 2)) ||
-		    (unsigned)current->pid <= 1)
-			mce_panic("Uncorrected machine check", &panicm, mcestart);
-
-		/* do_exit takes an awful lot of locks and has as
-		   slight risk of deadlocking. If you don't want that
-		   don't set tolerant >= 2 */
-		if (tolerant < 3)
+
+		/*
+		 * If we know that the error was in user space, send a
+		 * SIGBUS.  Otherwise, panic if tolerance is low.
+		 *
+		 * do_exit() takes an awful lot of locks and has a slight
+		 * risk of deadlocking.
+		 */
+		if (user_space) {
 			do_exit(SIGBUS);
+		} else if (panic_on_oops || tolerant < 2) {
+			mce_panic("Uncorrected machine check",
+				&panicm, mcestart);
+		}
 	}
 
 	/* notify userspace ASAP */
 	set_thread_flag(TIF_MCE_NOTIFY);
 
  out:
-	/* Last thing done in the machine check exception to clear state. */
+	/* the last thing we do is clear state */
+	for (i = 0; i < banks; i++)
+		wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
 	wrmsrl(MSR_IA32_MCG_STATUS, 0);
  out2:
 	atomic_dec(&mce_entry);
@@ -505,7 +538,7 @@ static int mce_open(struct inode *inode,
 
 	spin_unlock(&mce_state_lock);
 
-	return 0;
+	return nonseekable_open(inode, file);
 }
 
 static int mce_release(struct inode *inode, struct file *file)
_

Patches currently in -mm which might be from thockin@google.com are

x86_64-mce-poll-at-idle_start-and-printk-fix.patch
