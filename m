From: akpm@linux-foundation.org
Subject: - unionfs-clear-partial-read.patch removed from -mm tree
Date: Wed, 14 Nov 2007 09:41:41 -0800
Message-ID: <200711141741.lAEHffm8017257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42017 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756065AbXKNRlz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Nov 2007 12:41:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, ezk@cs.sunysb.edu, mm-commits@vger.kernel.org


The patch titled
     unionfs: clear partial read
has been removed from the -mm tree.  Its filename was
     unionfs-clear-partial-read.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: unionfs: clear partial read
From: Hugh Dickins <hugh@veritas.com>

unionfs_do_readpage forgot to clear the rest of the page when vfs_read does
not fill the page: fix that.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/unionfs/mmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/unionfs/mmap.c~unionfs-clear-partial-read fs/unionfs/mmap.c
--- a/fs/unionfs/mmap.c~unionfs-clear-partial-read
+++ a/fs/unionfs/mmap.c
@@ -176,7 +176,8 @@ static int unionfs_do_readpage(struct fi
 	err = vfs_read(lower_file, page_data, PAGE_CACHE_SIZE,
 		       &lower_file->f_pos);
 	set_fs(old_fs);
-
+	if (err >= 0 && err < PAGE_CACHE_SIZE)
+		memset(page_data + err, 0, PAGE_CACHE_SIZE - err);
 	kunmap(page);
 
 	if (err < 0)
_

Patches currently in -mm which might be from hugh@veritas.com are

git-unionfs.patch
i386-and-x86_64-randomize-brk-fix-2.patch
swapin_readahead-excise-numa-bogosity.patch
swapin_readahead-move-and-rearrange-args.patch
swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
shmem-sgp_quick-and-sgp_fault-redundant.patch
shmem_getpage-return-page-locked.patch
shmem_file_write-is-redundant.patch
swapin-fix-valid_swaphandles-defect.patch
swapoff-scan-ptes-preemptibly.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
tmpfs-fix-mounts-when-size-is-less-than-the-page-size.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
memcgroup-reinstate-swapoff-mod.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
prio_tree-debugging-patch.patch
