From: akpm@linux-foundation.org
Subject: - shmem-fix-bug-in-shmem_writepage.patch removed from -mm tree
Date: Wed, 28 Mar 2007 16:58:52 -0700
Message-ID: <200703282358.l2SNwqxB023229@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36112 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965865AbXC2AAj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Mar 2007 20:00:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mszeredi@suse.cz, hugh@veritas.com, pbadari@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     shmem: fix BUG in shmem_writepage
has been removed from the -mm tree.  Its filename was
     shmem-fix-bug-in-shmem_writepage.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: shmem: fix BUG in shmem_writepage
From: Miklos Szeredi <mszeredi@suse.cz>

BUG_ON(!entry) in shmem_writepage() is triggered in rare circumstances.

The cause is that shmem_truncate_range() erroneously removes partially
truncated directory pages at the end of the range.  A later reclaim on
pages pointing to these removed directories triggers the BUG.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff -puN mm/shmem.c~shmem-fix-bug-in-shmem_writepage mm/shmem.c
--- a/mm/shmem.c~shmem-fix-bug-in-shmem_writepage
+++ a/mm/shmem.c
@@ -543,7 +543,9 @@ static void shmem_truncate_range(struct 
 		if (*dir) {
 			diroff = ((idx - ENTRIES_PER_PAGEPAGE/2) %
 				ENTRIES_PER_PAGEPAGE) / ENTRIES_PER_PAGE;
-			if (!diroff && !offset) {
+			if (!diroff && !offset &&
+			    (!punch_hole ||
+			     limit - idx >= ENTRIES_PER_PAGEPAGE)) {
 				*dir = NULL;
 				nr_pages_to_free++;
 				list_add(&middir->lru, &pages_to_free);
@@ -570,9 +572,12 @@ static void shmem_truncate_range(struct 
 			}
 			stage = idx + ENTRIES_PER_PAGEPAGE;
 			middir = *dir;
-			*dir = NULL;
-			nr_pages_to_free++;
-			list_add(&middir->lru, &pages_to_free);
+			if (!punch_hole ||
+			    limit - idx >= ENTRIES_PER_PAGEPAGE) {
+				*dir = NULL;
+				nr_pages_to_free++;
+				list_add(&middir->lru, &pages_to_free);
+			}
 			shmem_dir_unmap(dir);
 			cond_resched();
 			dir = shmem_dir_map(middir);
@@ -598,7 +603,8 @@ static void shmem_truncate_range(struct 
 		}
 		if (offset)
 			offset = 0;
-		else if (subdir && !page_private(subdir)) {
+		else if (subdir &&
+			 (!punch_hole || limit - idx >= ENTRIES_PER_PAGE)) {
 			dir[diroff] = NULL;
 			nr_pages_to_free++;
 			list_add(&subdir->lru, &pages_to_free);
_

Patches currently in -mm which might be from mszeredi@suse.cz are

uml-fix-pte-bit-collision.patch
shmem-fix-bug-in-shmem_writepage.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-filesystem-subtype-support.patch
add-file-position-info-to-proc.patch
consolidate-generic_writepages-and-mpage_writepages.patch
