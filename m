From: akpm@linux-foundation.org
Subject: +
 mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes.patch added to -mm tree
Date: Mon, 23 Jun 2014 15:06:29 -0700
Message-ID: <53a8a4e5.1FHpOlp0RV9M6+qo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbaFWWGa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jun 2014 18:06:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ddstreet@ieee.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes.patch

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
Subject: mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes

WARNING: Missing a blank line after declarations
#76: FILE: mm/zpool.c:79:
+			bool got = try_module_get(driver->owner);
+			spin_unlock(&drivers_lock);

total: 0 errors, 1 warnings, 94 lines checked

./patches/mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Dan Streetman <ddstreet@ieee.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zpool.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/zpool.c~mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes mm/zpool.c
--- a/mm/zpool.c~mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes
+++ a/mm/zpool.c
@@ -76,6 +76,7 @@ static struct zpool_driver *zpool_get_dr
 	list_for_each_entry(driver, &drivers_head, list) {
 		if (!strcmp(driver->type, type)) {
 			bool got = try_module_get(driver->owner);
+
 			spin_unlock(&drivers_lock);
 			return got ? driver : NULL;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
cpu-hotplug-smp-flush-any-pending-ipi-callbacks-before-cpu-offline.patch
hugetlb-fix-copy_hugetlb_page_range-to-handle-migration-hwpoisoned-entry.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection.patch
mm-thp-fix-debug_pagealloc-oops-in-copy_page_rep.patch
shmem-fix-faulting-into-a-hole-while-its-punched.patch
ia64-arch-ia64-include-uapi-asm-fcntlh-needs-personalityh.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-zpool-implement-common-zpool-api-to-zbud-zsmalloc-fix.patch
mm-zpool-prevent-zbud-zsmalloc-from-unloading-when-used-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
lib-test-kstrtoxc-use-array_size-instead-of-sizeof-sizeof.patch

