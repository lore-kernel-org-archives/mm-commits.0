From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch added to -mm tree
Date: Mon, 29 Jul 2013 15:08:01 -0700
Message-ID: <51f6e7c1.0R5vNA7APMhlIxiF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab3G2WIC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jul 2013 18:08:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org

Subject: + mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch added to -mm tree
To: akpm@linux-foundation.org,iamjoonsoo.kim@lge.com
From: akpm@linux-foundation.org
Date: Mon, 29 Jul 2013 15:08:01 -0700


The patch titled
     Subject: mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix
has been added to the -mm tree.  Its filename is
     mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch

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
Subject: mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix

fix spelling in comment

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix
+++ a/mm/hugetlb.c
@@ -448,12 +448,12 @@ static int vma_has_reserves(struct vm_ar
 	if (vma->vm_flags & VM_NORESERVE) {
 		/*
 		 * This address is already reserved by other process(chg == 0),
-		 * so, we should decreament reserved count. Without
-		 * decreamenting, reserve count is remained after releasing
-		 * inode, because this allocated page will go into page cache
-		 * and is regarded as coming from reserved pool in releasing
-		 * step. Currently, we don't have any other solution to deal
-		 * with this situation properly, so add work-around here.
+		 * so, we should decrement reserved count. Without decrementing,
+		 * reserve count remains after releasing inode, because this
+		 * allocated page will go into page cache and is regarded as
+		 * coming from reserved pool in releasing step.  Currently, we
+		 * don't have any other solution to deal with this situation
+		 * properly, so add work-around here.
 		 */
 		if (vma->vm_flags & VM_MAYSHARE && chg == 0)
 			return 1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
ocfs2-refcounttree-add-the-missing-null-check-of-the-return-value-of-find_or_create_page-fix.patch
arch-x86-platform-ce4100-ce4100c-include-rebooth.patch
linux-next.patch
vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined-checkpatch-fixes.patch
mm.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size-fix.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too-fix.patch
swap-make-swap-discard-async-checkpatch-fixes.patch
swap-make-cluster-allocation-per-cpu-checkpatch-fixes.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
shrinker-convert-superblock-shrinkers-to-new-api-fix.patch
xfs-convert-buftarg-lru-to-generic-code-fix.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix.patch
fs-convert-fs-shrinkers-to-new-scan-count-api-fix.patch
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

