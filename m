From: akpm@linux-foundation.org
Subject: +
 percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch
 added to -mm tree
Date: Tue, 18 Mar 2014 14:39:05 -0700
Message-ID: <5328bcf9.qWxIqK0Y8Mz9NMoM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60673 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224AbaCRVjG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Mar 2014 17:39:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, cl@linux.com, akpm@linux-foundation.org

Subject: + percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,cl@linux.com
From: akpm@linux-foundation.org
Date: Tue, 18 Mar 2014 14:39:05 -0700


The patch titled
     Subject: percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-add-dlm_recover_callback_support-in-sysfs-fix.patch
ocfs2-flock-drop-cross-node-lock-when-failed-locally-checkpatch-fixes.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount-checkpatch-fixes.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
mm-process_vm_accessc-mark-function-as-static-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
drop_caches-add-some-documentation-and-info-message.patch
mmnuma-reorganize-change_pmd_range-fix.patch
drivers-lguest-page_tablesc-rename-do_set_pte.patch
mm-add-debugfs-tunable-for-fault_around_order-checkpatch-fixes.patch
mm-per-thread-vma-caching.patch
mm-per-thread-vma-caching-fix-3.patch
mm-per-thread-vma-caching-fix-5.patch
mm-per-thread-vma-caching-fix-6-checkpatch-fixes.patch
mm-per-thread-vma-caching-fix-6-fix.patch
mm-use-macros-from-compilerh-instead-of-__attribute__-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
fs-inodec-inode_lru_isolate-use-atomic-count_vm_events.patch
zram-use-zcomp-compressing-backends-fix.patch
zram-return-error-valued-pointer-from-zcomp_create-fix.patch
zram-propagate-error-to-user-fix.patch
zram-support-req_discard-v4-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
include-linux-syscallsh-add-sys32_quotactl-prototype-fix.patch
sys_sysfs-add-config_sysfs_syscall-fix.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
befs-logging-clean-up-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix.patch
hfsplus-fix-concurrent-acess-of-alloc_blocks-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
include-linux-crash_dumph-add-vmcore_cleanup-prototype-fix.patch
kernel-panicc-display-reason-at-end-pr_emerg-fix.patch
fault-injection-set-bounds-on-what-proc-self-make-it-fail-accepts-fix.patch
initramfs-debug-detected-compression-method-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
percpu-add-preemption-checks-to-__this_cpu-ops-fix-checkpatch-fixes.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

