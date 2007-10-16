From: akpm@linux-foundation.org
Subject: - softlockup-improve-debug-output-fix.patch removed from -mm tree
Date: Tue, 16 Oct 2007 14:53:59 -0700
Message-ID: <200710162153.l9GLrxhr019452@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56406 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761809AbXJPVzI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:55:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: satyam@infradead.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     softlockup-improve-debug-output fix
has been removed from the -mm tree.  Its filename was
     softlockup-improve-debug-output-fix.patch

This patch was dropped because it was folded into softlockup-improve-debug-output.patch

------------------------------------------------------
Subject: softlockup-improve-debug-output fix
From: Satyam Sharma <satyam@infradead.org>

On Sun, 2 Sep 2007, Satyam Sharma wrote:
>
> --- kernel/softlockup.c~fix	2007-09-02 04:23:49.000000000 +0530
> +++ kernel/softlockup.c	2007-09-02 04:34:45.000000000 +0530
  ^^^^^^^^^^

Ick, I botched a trivial patch, it doesn't even apply. Updated one below
(with indentation fix as added bonus :-)

[PATCH -mm] softlockup-improve-debug-output.patch fix (v2)

kernel/softlockup.c: In function 'softlockup_tick':
kernel/softlockup.c:125: warning: 'regs' is used uninitialized in this function

is a genuine bug (will cause an oops in all probability,
or cause wrong info to be printed, if we're lucky). So let's fix the
softlockup-improve-debug-output.patch to actually work as intended.

Signed-off-by: Satyam Sharma <satyam@infradead.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/softlockup.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN kernel/softlockup.c~softlockup-improve-debug-output-fix kernel/softlockup.c
--- a/kernel/softlockup.c~softlockup-improve-debug-output-fix
+++ a/kernel/softlockup.c
@@ -74,6 +74,7 @@ void softlockup_tick(void)
 	int this_cpu = smp_processor_id();
 	unsigned long touch_timestamp = per_cpu(touch_timestamp, this_cpu);
 	unsigned long print_timestamp;
+	struct pt_regs *regs = get_irq_regs();
 	unsigned long now;
 
 	if (touch_timestamp == 0) {
@@ -110,7 +111,10 @@ void softlockup_tick(void)
 
 	spin_lock(&print_lock);
 	printk(KERN_ERR "BUG: soft lockup detected on CPU#%d!\n", this_cpu);
-	dump_stack();
+	if (regs)
+		show_regs(regs);
+	else
+		dump_stack();
 	spin_unlock(&print_lock);
 }
 
_

Patches currently in -mm which might be from satyam@infradead.org are

origin.patch
softlockup-improve-debug-output.patch
softlockup-improve-debug-output-fix.patch
argv_split-allow-argv_split-to-handle-null-pointer-in-argcp-parameter-gracefully.patch
ufs-fix-sun-state-fix-mount-check-in-ufs_fill_super.patch
i2o-fix-defined-but-not-used-build-warnings.patch
i2o-fix-defined-but-not-used-build-warnings-fix.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
unify-dma_bit_mask-definitions-v31.patch
redefine-unregister_hotcpu_notifier-hotplug_cpu-stubs.patch
x86-msr-driver-misc-cpuinit-annotations.patch
