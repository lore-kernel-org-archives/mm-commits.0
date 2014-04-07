From: akpm@linux-foundation.org
Subject: [folded-merged]
 percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch
 removed from -mm tree
Date: Mon, 07 Apr 2014 15:20:13 -0700
Message-ID: <5343249d.nZOGixpibqSRs7FG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755727AbaDGWUO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 18:20:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, cl@linux.com, akpm@linux-foundation.org

Subject: [folded-merged] percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,cl@linux.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 15:20:13 -0700


The patch titled
     Subject: percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch

This patch was dropped because it was folded into percpu-add-preemption-checks-to-__this_cpu-ops.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes

WARNING: storage class should be at the beginning of the declaration
#25: FILE: lib/smp_processor_id.c:10:
+notrace static unsigned int check_preemption_disabled(const char *what1,

WARNING: Prefer [subsystem eg: netdev]_err([subsystem]dev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
#36: FILE: lib/smp_processor_id.c:42:
+	printk(KERN_ERR "BUG: using %s%s() in preemptible [%08x] code: %s/%d\n",

ERROR: space required after that ',' (ctx:VxV)
#46: FILE: lib/smp_processor_id.c:56:
+	return check_preemption_disabled("smp_processor_id","");
 	                                                   ^

total: 1 errors, 2 warnings, 36 lines checked

./patches/percpu-add-preemption-checks-to-__this_cpu-ops-fix.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Christoph Lameter <cl@linux.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/smp_processor_id.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/smp_processor_id.c~percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes lib/smp_processor_id.c
--- a/lib/smp_processor_id.c~percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes
+++ a/lib/smp_processor_id.c
@@ -53,7 +53,7 @@ out:
 
 notrace unsigned int debug_smp_processor_id(void)
 {
-	return check_preemption_disabled("smp_processor_id","");
+	return check_preemption_disabled("smp_processor_id", "");
 }
 EXPORT_SYMBOL(debug_smp_processor_id);
 
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
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts.patch
initramfs-debug-detected-compression-method.patch
slub-use-raw_cpu_inc-for-incrementing-statistics.patch
vmstat-use-raw_cpu_ops-to-avoid-false-positives-on-preemption-checks.patch
percpu-add-preemption-checks-to-__this_cpu-ops.patch

