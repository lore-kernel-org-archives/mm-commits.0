From: akpm@linux-foundation.org
Subject: - mm-fix-uninitialized-variables-for-find_vma_prepare-callers.patch removed from -mm tree
Date: Wed, 06 Aug 2008 13:57:16 -0700
Message-ID: <200808062057.m76KvG2A014757@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46345 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755598AbYHFVBD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2008 17:01:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhalevy@panasas.com, hugh@veritas.com, rmh3093@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: fix uninitialized variables for find_vma_prepare callers
has been removed from the -mm tree.  Its filename was
     mm-fix-uninitialized-variables-for-find_vma_prepare-callers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix uninitialized variables for find_vma_prepare callers
From: Benny Halevy <bhalevy@panasas.com>

gcc 4.3.0 correctly emits the following warnings.
When a vma covering addr is found, find_vma_prepare indeed returns without
setting pprev, rb_link, and rb_parent.

/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c: In function `insert_vm_struct':
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2085: warning: `rb_parent' may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2085: warning: `rb_link' may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2084: warning: `prev' may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c: In function `copy_vma':
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2124: warning: `rb_parent' may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2124: warning: `rb_link' may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:2123: warning: `prev' may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c: In function `do_brk':
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1951: warning: `rb_parent' may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1951: warning: `rb_link' may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1949: warning: `prev' may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c: In function `mmap_region':
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1092: warning: `rb_parent' may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1092: warning: `rb_link' may be used uninitialized in this function
/usr0/export/dev/bhalevy/git/linux-pnfs-bh-nfs41/mm/mmap.c:1089: warning: `prev' may be used uninitialized in this function

Hugh adds: in fact, none of find_vma_prepare's callers use those values
when a vma is found to be already covering addr, it's either an error or
an occasion to munmap and repeat.  Okay, let's quieten the compiler (but I
would prefer it if pprev, rb_link and rb_parent were meaningful in that
case, rather than whatever's in them from descending the tree).

Signed-off-by: Benny Halevy <bhalevy@panasas.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: "Ryan Hope" <rmh3093@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-fix-uninitialized-variables-for-find_vma_prepare-callers mm/mmap.c
--- a/mm/mmap.c~mm-fix-uninitialized-variables-for-find_vma_prepare-callers
+++ a/mm/mmap.c
@@ -370,7 +370,7 @@ find_vma_prepare(struct mm_struct *mm, u
 		if (vma_tmp->vm_end > addr) {
 			vma = vma_tmp;
 			if (vma_tmp->vm_start <= addr)
-				return vma;
+				break;
 			__rb_link = &__rb_parent->rb_left;
 		} else {
 			rb_prev = __rb_parent;
_

Patches currently in -mm which might be from bhalevy@panasas.com are


