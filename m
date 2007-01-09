From: akpm@osdl.org
Subject: - x86_64-ioapic-improve-the-heuristics-for-when-check_timer-fails.patch removed from -mm tree
Date: Tue, 09 Jan 2007 12:11:46 -0800
Message-ID: <200701092011.l09KBkcv013959@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39888 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932372AbXAIUMA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 9 Jan 2007 15:12:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, ak@suse.de, yinghai.lu@amd.com, mm-commits@vger.kernel.org


The patch titled
     x86_64 ioapic: Improve the heuristics for when check_timer fails.
has been removed from the -mm tree.  Its filename was
     x86_64-ioapic-improve-the-heuristics-for-when-check_timer-fails.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: x86_64 ioapic: Improve the heuristics for when check_timer fails.
From: Eric W. Biederman <ebiederm@xmission.com>

To a large extent this reverts b026872601976f666bae77b609dc490d1834bf77 while
still keeping to the spirits of it's goal, the ability to make smart guesses
about how the timer irq is routed when the BIOS gets it wrong.

The code for testing timer routing of a normal apic pin and and an ExtINT pin
has been moved into functions to make the code easier to read.

I have assumed that we don't want to enable anything with the i8259 unless we
are in ExtINT mode.  Reading the patch log indicates that this seems to be
most if not all of the time.

Compared to the pre b026872601976f666bae77b609dc490d1834bf77 state
two heuristic guess have been added:
-  If we cannot make the BIOS supplied timer on an apic pin work we
   guess apic 0 pin 2. As that is the architectural default.
-  When that fails and the BIOS does not provided us with an ExtINT
   mapping we try apic 0 pin 0 as an ExtINT.

Compared to Andi's previous version:
- I do not turn on irq0 in the i8259 and see if the io_apic
  works.  It is not clear that is ever needed.
- I do not guess that irq0 is connected as an ordinary interrupt
  to ioapic 0 pin 0.  I can't see how misprogramming that pin will buy
  us anything especially as it worked as an ExtINT in my testing, on
  one of the Nvidia boards.
- I guess that ExtINT mode and thus irq0 trough the i8259 works
  through apic 0 pin 0.  As this is the architectural default.

By using the architectural defaults our guesses are as safe as they can be and
are likely to work in most of the cases.  If this still leaves some people out
in the cold we can look at adding some more smart guesses, but my hunch is
that anything more needs to be chipset specific.

Yinghai Lu thanks for your contributions on the infrastructure support.  While
I did not use it directly I did look at your code when double checking mine to
see if looked correct.

Tobias.  I don't have a box with the problem yours does, and this doesn't
quite try any of the cases you have been asked to test so could you please
test this one?

I have tested this on an Nvidia board that reports that apic 0 pin 2 works
when it does not and this code successfully programs apic 0 pin 0 into ExtINT
mode.

I have not addressed the fact the code for local apic ExtINT guesses are a
mess and appear to be broken.  That code appears to have been that way for a
long time and no one has seemed to care.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: "Yinghai Lu" <yinghai.lu@amd.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/io_apic.c |  164 ++++++++++++++++++++++++---------
 1 files changed, 123 insertions(+), 41 deletions(-)

diff -puN arch/x86_64/kernel/io_apic.c~x86_64-ioapic-improve-the-heuristics-for-when-check_timer-fails arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~x86_64-ioapic-improve-the-heuristics-for-when-check_timer-fails
+++ a/arch/x86_64/kernel/io_apic.c
@@ -1631,23 +1631,16 @@ static inline void unlock_ExtINT_logic(v
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 
-/*
- * This code may look a bit paranoid, but it's supposed to cooperate with
- * a wide range of boards and BIOS bugs.  Fortunately only the timer IRQ
- * is so screwy.  Thanks to Brian Perkins for testing/hacking this beast
- * fanatically on his truly buggy board.
- */
-
-static int try_apic_pin(int apic, int pin, char *msg)
+static int do_check_timer_pin(int apic, int pin)
 {
-	apic_printk(APIC_VERBOSE, KERN_INFO
-		    "..TIMER: trying IO-APIC=%d PIN=%d %s",
-		    apic, pin, msg);
-
+	apic_printk(APIC_VERBOSE,KERN_INFO "..TIMER trying IO-APIC=%d PIN=%d",
+			apic, pin);
 	/*
 	 * Ok, does IRQ0 through the IOAPIC work?
 	 */
+	unmask_IO_APIC_irq(0);
 	if (!no_timer_check && timer_irq_works()) {
+		apic_printk(APIC_VERBOSE, " .. success\n");
 		if (nmi_watchdog == NMI_IO_APIC) {
 			disable_8259A_irq(0);
 			setup_nmi();
@@ -1656,11 +1649,87 @@ static int try_apic_pin(int apic, int pi
 		return 1;
 	}
 	clear_IO_APIC_pin(apic, pin);
-	apic_printk(APIC_QUIET, KERN_ERR " .. failed\n");
+	remove_pin_to_irq(0, apic, pin);
+	apic_printk(APIC_VERBOSE, KERN_ERR " .. failed\n");
+	return 0;
+}
+
+static int check_bios_timer_pin(int apic, int pin)
+{
+	/*
+	 * Test the BIOS supplied ioapic pin for the i8254
+	 */
+	if (pin == -1)
+		return 0;
+
+	return do_check_timer_pin(apic, pin);
+}
+
+static int check_timer_pin(int apic, int pin)
+{
+	int irq, idx;
+	/*
+	 * Test the architecture default i8254 timer pin
+	 * of apic 0 pin 2.
+	 */
+
+
+	/* If the apic pin pair is in use by another irq fail */
+	irq = irq_from_pin(apic, pin);
+	if ((irq != -1) && (irq != 0)) {
+		apic_printk(APIC_VERBOSE,KERN_INFO "...apic %d pin % in use by irq %d\n",
+			apic, pin, irq);
+		return 0;
+	}
+
+	/* Add an entry in mp_irqs for irq 0 */
+	idx = update_irq0_entry(apic, pin);
+
+	/* Add an entry in irq_to_pin */
+	add_pin_to_irq(0, apic, pin);
+
+	/* Now setup the irq */
+	setup_IO_APIC_irq(apic, pin, idx, 0);
+
+	/* And finally check to see if the irq works */
+	return do_check_timer_pin(apic, pin);
+}
+
+static int check_ExtINT_pin(int apic, int pin, int vector)
+{
+	if (pin == -1)
+		return 0;
+
+	apic_printk(APIC_VERBOSE,KERN_INFO "..ExtINT trying IO-APIC=%d PIN=%d",
+			apic, pin);
+	/*
+	 * legacy devices should be connected to IO APIC #0
+	 */
+	setup_ExtINT_IRQ0_pin(apic, pin, vector);
+	if (timer_irq_works()) {
+		apic_printk(APIC_VERBOSE, " .. success\n");
+		nmi_watchdog_default();
+		if (nmi_watchdog == NMI_IO_APIC) {
+			setup_nmi();
+		}
+		return 1;
+	}
+	/*
+	 * Cleanup, just in case ...
+	 */
+	clear_IO_APIC_pin(apic, pin);
+	apic_printk(APIC_VERBOSE, " .. failed\n");
 	return 0;
+
 }
 
-/* The function from hell */
+/*
+ * This code may look a bit paranoid, but it's supposed to cooperate with
+ * a wide range of boards and BIOS bugs.  Fortunately only the timer IRQ
+ * is so screwy.  Thanks to Brian Perkins for testing/hacking this beast
+ * fanatically on his truly buggy board.
+ */
+
 static void check_timer(void)
 {
 	int apic1, pin1, apic2, pin2;
@@ -1688,37 +1757,50 @@ static void check_timer(void)
 	pin2  = ioapic_i8259.pin;
 	apic2 = ioapic_i8259.apic;
 
-	/* Do this first, otherwise we get double interrupts on ATI boards */
-	if ((pin1 != -1) && try_apic_pin(apic1, pin1,"with 8259 IRQ0 disabled"))
-		return;
+	apic_printk(APIC_VERBOSE,KERN_INFO "..TIMER: vector=0x%02X apic1=%d pin1=%d apic2=%d pin2=%d\n",
+		vector, apic1, pin1, apic2, pin2);
 
-	/* Now try again with IRQ0 8259A enabled.
-	   Assumes timer is on IO-APIC 0 ?!? */
-	enable_8259A_irq(0);
-	unmask_IO_APIC_irq(0);
-	if (try_apic_pin(apic1, pin1, "with 8259 IRQ0 enabled"))
-		return;
-	disable_8259A_irq(0);
 
-	/* Always try pin0 and pin2 on APIC 0 to handle buggy timer overrides
-	   on Nvidia boards */
-	if (!(apic1 == 0 && pin1 == 0) &&
-	    try_apic_pin(0, 0, "fallback with 8259 IRQ0 disabled"))
-		return;
-	if (!(apic1 == 0 && pin1 == 2) &&
-	    try_apic_pin(0, 2, "fallback with 8259 IRQ0 disabled"))
-		return;
+	/*
+	 * If the BIOS has supplied an ioapic pin for the 8254 try that.
+	 */
+	if (check_bios_timer_pin(apic1, pin1))
+ 		return;
 
-	/* Then try pure 8259A routing on the 8259 as reported by BIOS*/
-	enable_8259A_irq(0);
-	if (pin2 != -1) {
-		setup_ExtINT_IRQ0_pin(apic2, pin2, vector);
-		if (try_apic_pin(apic2,pin2,"8259A broadcast ExtINT from BIOS"))
-			return;
-	}
+	/*
+	 * If the BIOS has not properly supplied the ioapic pin for the 8254
+	 * try the architectural default.  It is a common BIOS implementation
+	 * mistake to forget the ACPI source override for irq 0.
+	 */
+	if (check_timer_pin(0, 2))
+ 		return;
+
+	apic_printk(APIC_QUIET,KERN_ERR "..MP-BIOS bug: 8254 timer not "
+				"connected to IO-APIC\n");
 
-	/* Tried all possibilities to go through the IO-APIC. Now come the
-	   really cheesy fallbacks. */
+	/*
+	 * Ok there are no more good canidates for an apic pin.
+	 * Start testing diffeernt ways of enable ExtINT.
+	 */
+	apic_printk(APIC_VERBOSE,KERN_INFO "...trying to set up timer (IRQ0) "
+				"through the 8259A ...\n");
+
+	/*
+	 * If the BIOS has supplied programming information for ExtINT
+	 * or we have derived by looking at the ioapics try that.
+	 */
+	if (check_ExtINT_pin(apic2, pin2, vector))
+ 		return;
+
+	/*
+	 * If the BIOS has not supplied the ExtINT pin to the i8259
+	 * or the BIOS supplied value does not work guess the
+	 * architectural default of apic 0 pin 0.
+	 */
+	if (check_ExtINT_pin(0, 0, vector))
+		return;
+
+	apic_printk(APIC_VERBOSE," failed.\n");
 
 	if (nmi_watchdog == NMI_IO_APIC) {
 		printk(KERN_WARNING "timer doesn't work through the IO-APIC - disabling NMI Watchdog!\n");
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
kthread-api-conversion-for-dvb_frontend-and-av7110.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
i386-make-apic-probe-function-non-init.patch
modpost-add-more-symbols-to-whitelist-pattern2.patch
modpost-whitelist-reference-to-more-symbols-pattern-3.patch
x86_64-ioapic-improve-the-heuristics-for-when-check_timer-fails.patch
x86_64-ioapic-improve-the-heuristics-for-when-check_timer-fails-fix.patch
vt-refactor-console-sak-processing.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
kill_pid_info-kill-acquired_tasklist_lock.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
i386-apic-clean-up-the-apic-code.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
dynticks-i386-prepare-nmi-watchdog.patch
edac-e752x-bit-mask-fix.patch
edac-e752x-byte-access-fix.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user-namespace-add-the-framework-fix.patch
user-ns-add-user_namespace-ptr-to-vfsmount.patch
user-ns-hook-permission.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-shared-mounts.patch
user_ns-handle-file-sigio.patch
user-ns-implement-user-ns-unshare.patch
user-ns-implement-user-ns-unshare-tidy.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
