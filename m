From: akpm@linux-foundation.org
Subject: [folded-merged]
 kernel-panicc-display-reason-at-end-pr_emerg-fix.patch removed from -mm
 tree
Date: Mon, 07 Apr 2014 15:16:50 -0700
Message-ID: <534323d2.21mgFW6BAGRSh2LE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbaDGWQv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:16:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be, akpm@linux-foundation.org

Subject: [folded-merged] kernel-panicc-display-reason-at-end-pr_emerg-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,fabf@skynet.be,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:16:50 -0700


The patch titled
     Subject: kernel-panicc-display-reason-at-end-pr_emerg-fix
has been removed from the -mm tree.  Its filename was
     kernel-panicc-display-reason-at-end-pr_emerg-fix.patch

This patch was dropped because it was folded into kernel-panicc-display-reason-at-end-pr_emerg.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel-panicc-display-reason-at-end-pr_emerg-fix

missed a couple of pr_ conversions

Cc: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/panic.c~kernel-panicc-display-reason-at-end-pr_emerg-fix kernel/panic.c
--- a/kernel/panic.c~kernel-panicc-display-reason-at-end-pr_emerg-fix
+++ a/kernel/panic.c
@@ -275,8 +275,7 @@ unsigned long get_taint(void)
 void add_taint(unsigned flag, enum lockdep_ok lockdep_ok)
 {
 	if (lockdep_ok == LOCKDEP_NOW_UNRELIABLE && __debug_locks_off())
-		printk(KERN_WARNING
-		       "Disabling lock debugging due to kernel taint\n");
+		pr_warn("Disabling lock debugging due to kernel taint\n");
 
 	set_bit(flag, &tainted_mask);
 }
@@ -381,8 +380,7 @@ late_initcall(init_oops_id);
 void print_oops_end_marker(void)
 {
 	init_oops_id();
-	printk(KERN_WARNING "---[ end trace %016llx ]---\n",
-		(unsigned long long)oops_id);
+	pr_warn("---[ end trace %016llx ]---\n", (unsigned long long)oops_id);
 }
 
 /*
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mmnuma-reorganize-change_pmd_range.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order.patch
mm-per-thread-vma-caching.patch
mm-use-macros-from-compilerh-instead-of-__attribute__.patch
mm-vmallocc-enhance-vm_map_ram-comment.patch
mm-readaheadc-inline-ra_submit.patch
zram-use-zcomp-compressing-backends.patch
zram-return-error-valued-pointer-from-zcomp_create.patch
zram-propagate-error-to-user.patch
zram-support-req_discard.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype.patch
kernel-panicc-display-reason-at-end-pr_emerg.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
slub-use-raw_cpu_inc-for-incrementing-statistics-fix.patch
vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks-fix.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch

