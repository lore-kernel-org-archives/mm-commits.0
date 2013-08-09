From: akpm@linux-foundation.org
Subject: +
 genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch added to
 -mm tree
Date: Fri, 09 Aug 2013 16:15:44 -0700
Message-ID: <52057820.K1goI91e1Vcryf/T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38000 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031447Ab3HIXPp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Aug 2013 19:15:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jy0922.shim@samsung.com, akpm@linux-foundation.org

Subject: + genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch added to -mm tree
To: akpm@linux-foundation.org,jy0922.shim@samsung.com
From: akpm@linux-foundation.org
Date: Fri, 09 Aug 2013 16:15:44 -0700


The patch titled
     Subject: genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix
has been added to the -mm tree.  Its filename is
     genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch

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
Subject: genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix

add comment to struct gen_pool_chunk:end_addr

Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genalloc.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/genalloc.h~genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix include/linux/genalloc.h
--- a/include/linux/genalloc.h~genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix
+++ a/include/linux/genalloc.h
@@ -66,8 +66,8 @@ struct gen_pool_chunk {
 	struct list_head next_chunk;	/* next chunk in pool */
 	atomic_t avail;
 	phys_addr_t phys_addr;		/* physical starting address of memory chunk */
-	unsigned long start_addr;	/* starting address of memory chunk */
-	unsigned long end_addr;		/* ending address of memory chunk */
+	unsigned long start_addr;	/* start address of memory chunk */
+	unsigned long end_addr;		/* end address of memory chunk (inclusive) */
 	unsigned long bits[0];		/* bitmap for allocating memory chunk */
 };
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
block-support-embedded-device-command-line-partition-fix.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
swap-make-swap-discard-async-checkpatch-fixes.patch
swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
memcg-trivial-cleanups.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch
genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
linux-next.patch
revert-selinux-do-not-handle-seclabel-as-a-special-flag.patch
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

