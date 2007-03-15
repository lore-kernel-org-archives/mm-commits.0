From: akpm@linux-foundation.org
Subject: + shmem-dont-release-lock-for-hole-punching.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:48:13 -0800
Message-ID: <200703151848.l2FImF7i023231@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35265 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbXCOSsX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:48:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hugh@veritas.com, pbadari@us.ibm.com


The patch titled
     shmem: don't release lock for hole punching
has been added to the -mm tree.  Its filename is
     shmem-dont-release-lock-for-hole-punching.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: shmem: don't release lock for hole punching
From: Miklos Szeredi <mszeredi@suse.cz>

During truncation of shmem page directories, info->lock is released to
improve latency.  But this is wrong for hole punching, because the memory
areas being operated on are still in use by shmem_unuse, shmem_getpage and
shmem_writepage.

So for hole punching don't release the lock.  Users of MADV_REMOVE likely
don't care about latency anyway.  But this function really wants a cleanup,
and with that latency could also be taken care of.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff -puN mm/shmem.c~shmem-dont-release-lock-for-hole-punching mm/shmem.c
--- a/mm/shmem.c~shmem-dont-release-lock-for-hole-punching
+++ a/mm/shmem.c
@@ -421,7 +421,7 @@ static int shmem_free_swp(swp_entry_t *d
 }
 
 static int shmem_map_and_free_swp(struct page *subdir,
-		int offset, int limit, struct page ***dir)
+		int offset, int limit, struct page ***dir, int punch_hole)
 {
 	swp_entry_t *ptr;
 	int freed = 0;
@@ -429,10 +429,10 @@ static int shmem_map_and_free_swp(struct
 	ptr = shmem_swp_map(subdir);
 	for (; offset < limit; offset += LATENCY_LIMIT) {
 		int size = limit - offset;
-		if (size > LATENCY_LIMIT)
+		if (!punch_hole && size > LATENCY_LIMIT)
 			size = LATENCY_LIMIT;
 		freed += shmem_free_swp(ptr+offset, ptr+offset+size);
-		if (need_resched()) {
+		if (!punch_hole && need_resched()) {
 			shmem_swp_unmap(ptr);
 			if (*dir) {
 				shmem_dir_unmap(*dir);
@@ -506,7 +506,8 @@ static void shmem_truncate_range(struct 
 		nr_pages_to_free++;
 		list_add(&topdir->lru, &pages_to_free);
 	}
-	spin_unlock(&info->lock);
+	if (!punch_hole)
+		spin_unlock(&info->lock);
 
 	if (info->swapped && idx < SHMEM_NR_DIRECT) {
 		ptr = info->i_direct;
@@ -589,14 +590,14 @@ static void shmem_truncate_range(struct 
 			if (size > ENTRIES_PER_PAGE)
 				size = ENTRIES_PER_PAGE;
 			freed = shmem_map_and_free_swp(subdir,
-						offset, size, &dir);
+					offset, size, &dir, punch_hole);
 			if (!dir)
 				dir = shmem_dir_map(middir);
 			nr_swaps_freed += freed;
-			if (offset)
+			if (offset && !punch_hole)
 				spin_lock(&info->lock);
 			set_page_private(subdir, page_private(subdir) - freed);
-			if (offset)
+			if (offset && !punch_hole)
 				spin_unlock(&info->lock);
 			if (!punch_hole)
 				BUG_ON(page_private(subdir) > offset);
@@ -613,6 +614,8 @@ static void shmem_truncate_range(struct 
 done1:
 	shmem_dir_unmap(dir);
 done2:
+	if (punch_hole)
+		spin_unlock(&info->lock);
 	if (inode->i_mapping->nrpages && (info->flags & SHMEM_PAGEIN)) {
 		/*
 		 * Call truncate_inode_pages again: racing shmem_unuse_inode
_

Patches currently in -mm which might be from mszeredi@suse.cz are

shmem-fix-bug-in-shmem_writepage.patch
shmem-dont-release-lock-for-hole-punching.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-filesystem-subtype-support.patch
consolidate-generic_writepages-and-mpage_writepages.patch
