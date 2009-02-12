From: akpm@linux-foundation.org
Subject: [merged] mm-fix-mlocked-page-counter-mismatch.patch removed from -mm tree
Date: Thu, 12 Feb 2009 12:25:22 -0800
Message-ID: <200902122025.n1CKPMUV014506@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757290AbZBLU0F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Feb 2009 15:26:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan.kim@gmail.com, hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com, lee.schermerhorn@hp.com, mm-commits@vger.kernel.org


The patch titled
     mm: fix mlocked page counter mismatch
has been removed from the -mm tree.  Its filename was
     mm-fix-mlocked-page-counter-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix mlocked page counter mismatch
From: MinChan Kim <minchan.kim@gmail.com>

When I tested following program, I found that the mlocked counter
is strange.  It cannot free some mlocked pages.

It is because try_to_unmap_file() doesn't check real
page mappings in vmas.

That is because the goal of an address_space for a file is to find all
processes into which the file's specific interval is mapped.  It is
related to the file's interval, not to pages.

Even if the page isn't really mapped by the vma, it returns SWAP_MLOCK
since the vma has VM_LOCKED, then calls try_to_mlock_page.  After this the
mlocked counter is increased again.

COWed anon page in a file-backed vma could be a such case.  This patch
resolves it.

-- my test program --

int main()
{
       mlockall(MCL_CURRENT);
       return 0;
}

-- before --

root@barrios-target-linux:~# cat /proc/meminfo | egrep 'Mlo|Unev'
Unevictable:           0 kB
Mlocked:               0 kB

-- after --

root@barrios-target-linux:~# cat /proc/meminfo | egrep 'Mlo|Unev'
Unevictable:           8 kB
Mlocked:               8 kB

Signed-off-by: MinChan Kim <minchan.kim@gmail.com>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Tested-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/rmap.c~mm-fix-mlocked-page-counter-mismatch mm/rmap.c
--- a/mm/rmap.c~mm-fix-mlocked-page-counter-mismatch
+++ a/mm/rmap.c
@@ -1072,7 +1072,8 @@ static int try_to_unmap_file(struct page
 	spin_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
 		if (MLOCK_PAGES && unlikely(unlock)) {
-			if (!(vma->vm_flags & VM_LOCKED))
+			if (!((vma->vm_flags & VM_LOCKED) &&
+						page_mapped_in_vma(page, vma)))
 				continue;	/* must visit all vmas */
 			ret = SWAP_MLOCK;
 		} else {
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

origin.patch
vmap-remove-needless-lock-and-list-in-vmap.patch
vmscan-rename-scmay_swap-to-may_unmap.patch

