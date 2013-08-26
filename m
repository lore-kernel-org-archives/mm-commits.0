From: akpm@linux-foundation.org
Subject: + mm-drop-actor-argument-of-do_generic_file_read-fix.patch added
 to -mm tree
Date: Mon, 26 Aug 2013 15:27:25 -0700
Message-ID: <521bd64d.cf2b8KcYPOVlS7tG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58271 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab3HZW10 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 26 Aug 2013 18:27:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willy@linux.intel.com, liwanp@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, hughd@google.com, dave.hansen@linux.intel.com, akpm@linux-foundation.org

Subject: + mm-drop-actor-argument-of-do_generic_file_read-fix.patch added to -mm tree
To: akpm@linux-foundation.org,dave.hansen@linux.intel.com,hughd@google.com,kirill.shutemov@linux.intel.com,liwanp@linux.vnet.ibm.com,willy@linux.intel.com
From: akpm@linux-foundation.org
Date: Mon, 26 Aug 2013 15:27:25 -0700


The patch titled
     Subject: mm-drop-actor-argument-of-do_generic_file_read-fix
has been added to the -mm tree.  Its filename is
     mm-drop-actor-argument-of-do_generic_file_read-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-drop-actor-argument-of-do_generic_file_read-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-drop-actor-argument-of-do_generic_file_read-fix.patch

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
Subject: mm-drop-actor-argument-of-do_generic_file_read-fix

fix mm-drop-actor-argument-of-do_generic_file_read for linux-next changes

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/filemap.c~mm-drop-actor-argument-of-do_generic_file_read-fix mm/filemap.c
--- a/mm/filemap.c~mm-drop-actor-argument-of-do_generic_file_read-fix
+++ a/mm/filemap.c
@@ -1206,7 +1206,7 @@ page_ok:
 		 * "pos" here (the actor routine has to update the user buffer
 		 * pointers and the remaining count).
 		 */
-		ret = file_read_actor(desc, page, offset, nr);
+		ret = file_read_iter_actor(desc, page, offset, nr);
 		offset += ret;
 		index += offset >> PAGE_CACHE_SHIFT;
 		offset &= ~PAGE_CACHE_MASK;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default-fix.patch
block-support-embedded-device-command-line-partition.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
swap-make-swap-discard-async-checkpatch-fixes.patch
swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch
genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages-fix.patch
mm-hotplug-verify-hotplug-memory-range-fix.patch
mm-fix-aio-performance-regression-for-database-caused-by-thp-fix.patch
mm-track-vma-changes-with-vm_softdirty-bit-fix.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
revert-selinux-do-not-handle-seclabel-as-a-special-flag.patch
memcg-trivial-cleanups.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix-fix-2.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix.patch
drivers-convert-shrinkers-to-new-count-scan-api-fix-2.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api-fix.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api-fix.patch
shrinker-kill-old-shrink-api-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

