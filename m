From: akpm@osdl.org
Subject: + uml-make-time-data-per-cpu.patch added to -mm tree
Date: Tue, 09 Jan 2007 12:57:45 -0800
Message-ID: <200701092057.l09KvjGa015069@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43438 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932436AbXAIU5x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 15:57:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, blaisorblade@yahoo.it


The patch titled
     uml: make time data per-cpu
has been added to the -mm tree.  Its filename is
     uml-make-time-data-per-cpu.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: make time data per-cpu
From: Jeff Dike <jdike@addtoit.com>

prev_nsecs and delta need to be arrays, and indexed by CPU number.

Signed-off-by: Jeff Dike <jdike@addtoit.com>
Cc: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/um/kernel/time.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff -puN arch/um/kernel/time.c~uml-make-time-data-per-cpu arch/um/kernel/time.c
--- a/arch/um/kernel/time.c~uml-make-time-data-per-cpu
+++ a/arch/um/kernel/time.c
@@ -35,31 +35,31 @@ unsigned long long sched_clock(void)
 	return (unsigned long long)jiffies_64 * (1000000000 / HZ);
 }
 
-static unsigned long long prev_nsecs;
+static unsigned long long prev_nsecs[NR_CPUS];
 #ifdef CONFIG_UML_REAL_TIME_CLOCK
-static long long delta;   		/* Deviation per interval */
+static long long delta[NR_CPUS];		/* Deviation per interval */
 #endif
 
 void timer_irq(union uml_pt_regs *regs)
 {
 	unsigned long long ticks = 0;
-
 #ifdef CONFIG_UML_REAL_TIME_CLOCK
-	if(prev_nsecs){
+	int c = cpu();
+	if(prev_nsecs[c]){
 		/* We've had 1 tick */
 		unsigned long long nsecs = os_nsecs();
 
-		delta += nsecs - prev_nsecs;
-		prev_nsecs = nsecs;
+		delta[c] += nsecs - prev_nsecs[c];
+		prev_nsecs[c] = nsecs;
 
 		/* Protect against the host clock being set backwards */
-		if(delta < 0)
-			delta = 0;
+		if(delta[c] < 0)
+			delta[c] = 0;
 
-		ticks += (delta * HZ) / BILLION;
-		delta -= (ticks * BILLION) / HZ;
+		ticks += (delta[c] * HZ) / BILLION;
+		delta[c] -= (ticks * BILLION) / HZ;
 	}
-	else prev_nsecs = os_nsecs();
+	else prev_nsecs[c] = os_nsecs();
 #else
 	ticks = 1;
 #endif
@@ -69,8 +69,8 @@ void timer_irq(union uml_pt_regs *regs)
 	}
 }
 
+/* Protects local_offset */
 static DEFINE_SPINLOCK(timer_spinlock);
-
 static unsigned long long local_offset = 0;
 
 static inline unsigned long long get_time(void)
_

Patches currently in -mm which might be from jdike@addtoit.com are

x86_64-i386-kernel-mode-faults-pollute-current-thead.patch
uml-console-locking-fixes.patch
uml-return-hotplug-errors-to-host.patch
uml-console-whitespace-and-comment-tidying.patch
uml-lock-the-irqs_to_free-list.patch
uml-add-locking-to-network-transport-registration.patch
uml-network-driver-whitespace-and-style-fixes.patch
uml-watchdog-driver-locking.patch
uml-watchdog-driver-formatting.patch
uml-audio-driver-locking.patch
uml-audio-driver-formatting.patch
uml-mconsole-locking.patch
uml-make-two-variables-static.patch
uml-port-driver-formatting.patch
uml-kill-a-compilation-warning.patch
uml-network-driver-locking-and-code-cleanup.patch
uml-use-list_head-where-possible.patch
uml-locking-commentary-in-the-random-driver.patch
uml-mostly-const-a-structure.patch
uml-chan_userh-formatting-fices.patch
uml-console-locking-commentary-and-code-cleanup.patch
uml-fix-previous-console-locking.patch
uml-locking-comments-in-iomem-driver.patch
uml-memc-and-physmemc-formatting-fixes.patch
uml-initialize-a-list-head.patch
uml-make-time-data-per-cpu.patch
uml-delete-unused-file.patch
uml-remove-unused-variable-and-function.patch
uml-make-signal-handlers-static.patch
uml-const-a-variable.patch
uml-remove-code-controlled-by-non-existent-config-option.patch
uml-fix-prototypes.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
proc-remove-useless-and-buggy-nlink-settings.patch
