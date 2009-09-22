From: akpm@linux-foundation.org
Subject: [merged] ksm-mremap-use-err-from-ksm_madvise.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:40:28 -0700
Message-ID: <200909222040.n8MKeS54005633@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606AbZIVUlJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:41:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, aarcange@redhat.com, ieidus@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm: mremap use err from ksm_madvise
has been removed from the -mm tree.  Its filename was
     ksm-mremap-use-err-from-ksm_madvise.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: mremap use err from ksm_madvise
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

mremap move's use of ksm_madvise() was assuming -ENOMEM on failure,
because ksm_madvise used to say -EAGAIN for that; but ksm_madvise now says
-ENOMEM (letting madvise convert that to -EAGAIN), and can also say
-ERESTARTSYS when signalled: so pass the error from ksm_madvise.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Acked-by: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/mremap.c~ksm-mremap-use-err-from-ksm_madvise mm/mremap.c
--- a/mm/mremap.c~ksm-mremap-use-err-from-ksm_madvise
+++ a/mm/mremap.c
@@ -175,6 +175,7 @@ static unsigned long move_vma(struct vm_
 	unsigned long excess = 0;
 	unsigned long hiwater_vm;
 	int split = 0;
+	int err;
 
 	/*
 	 * We'd prefer to avoid failure later on in do_munmap:
@@ -190,9 +191,10 @@ static unsigned long move_vma(struct vm_
 	 * pages recently unmapped.  But leave vma->vm_flags as it was,
 	 * so KSM can come around to merge on vma and new_vma afterwards.
 	 */
-	if (ksm_madvise(vma, old_addr, old_addr + old_len,
-						MADV_UNMERGEABLE, &vm_flags))
-		return -ENOMEM;
+	err = ksm_madvise(vma, old_addr, old_addr + old_len,
+						MADV_UNMERGEABLE, &vm_flags);
+	if (err)
+		return err;
 
 	new_pgoff = vma->vm_pgoff + ((old_addr - vma->vm_start) >> PAGE_SHIFT);
 	new_vma = copy_vma(&vma, new_addr, new_len, new_pgoff);
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-optimize-touch_time-too.patch
vfs-seq_file-add-helpers-for-data-filling.patch
fs-new-truncate-helpers.patch
fs-use-new-truncate-helpers.patch
fs-introduce-new-truncate-sequence.patch
fs-convert-simple-fs-to-new-truncate.patch
tmpfs-convert-to-use-the-new-truncate-convention.patch
ext2-convert-to-use-the-new-truncate-convention.patch
fat-convert-to-use-the-new-truncate-convention.patch
btrfs-convert-to-use-the-new-truncate-convention.patch
jfs-convert-to-use-the-new-truncate-convention.patch
udf-convert-to-use-the-new-truncate-convention.patch
minix-convert-to-use-the-new-truncate-convention.patch
getrusage-fill-ru_maxrss-value.patch
walk-system-ram-range-fix.patch
ramfs-move-ramfs_magic-to-include-linux-magich.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
prio_tree-debugging-patch.patch

