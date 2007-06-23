From: akpm@linux-foundation.org
Subject: - ocfs2-zero_user_page-conversion.patch removed from -mm tree
Date: Sat, 23 Jun 2007 12:28:17 -0700
Message-ID: <200706231928.l5NJSHTg022132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34926 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752890AbXFWTfN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Jun 2007 15:35:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sandeen@redhat.com, mark.fasheh@oracle.com, mm-commits@vger.kernel.org


The patch titled
     ocfs2: zero_user_page() conversions
has been removed from the -mm tree.  Its filename was
     ocfs2-zero_user_page-conversion.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ocfs2: zero_user_page() conversions
From: Eric Sandeen <sandeen@redhat.com>

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-zero_user_page-conversion fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-zero_user_page-conversion
+++ a/fs/ocfs2/aops.c
@@ -739,18 +739,13 @@ int ocfs2_map_page_blocks(struct page *p
 	bh = head;
 	block_start = 0;
 	do {
-		void *kaddr;
-
 		block_end = block_start + bsize;
 		if (block_end <= from)
 			goto next_bh;
 		if (block_start >= to)
 			break;
 
-		kaddr = kmap_atomic(page, KM_USER0);
-		memset(kaddr+block_start, 0, bh->b_size);
-		flush_dcache_page(page);
-		kunmap_atomic(kaddr, KM_USER0);
+		zero_user_page(page, block_start, bh->b_size, KM_USER0);
 		set_buffer_uptodate(bh);
 		mark_buffer_dirty(bh);
 
@@ -895,15 +890,11 @@ static void ocfs2_zero_new_buffers(struc
 			if (block_end > from && block_start < to) {
 				if (!PageUptodate(page)) {
 					unsigned start, end;
-					void *kaddr;
 
 					start = max(from, block_start);
 					end = min(to, block_end);
 
-					kaddr = kmap_atomic(page, KM_USER0);
-					memset(kaddr+start, 0, end - start);
-					flush_dcache_page(page);
-					kunmap_atomic(kaddr, KM_USER0);
+					zero_user_page(page, start, end - start, KM_USER0);
 					set_buffer_uptodate(bh);
 				}
 
_

Patches currently in -mm which might be from sandeen@redhat.com are

cifs-zero_user_page-conversion.patch
git-ocfs2.patch
ext4-zero_user_page-conversion.patch
