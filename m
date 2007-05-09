From: akpm@linux-foundation.org
Subject: - factor-outstanding-i-o-error-handling.patch removed from -mm tree
Date: Tue, 08 May 2007 19:43:51 -0700
Message-ID: <200705090243.l492hpcO008516@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45760 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754981AbXEICoA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:44:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guichaz@yahoo.fr, swhiteho@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Factor outstanding I/O error handling
has been removed from the -mm tree.  Its filename was
     factor-outstanding-i-o-error-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Factor outstanding I/O error handling
From: Guillaume Chazarain <guichaz@yahoo.fr>

Cleanup: setting an outstanding error on a mapping was open coded too many
times.  Factor it out in mapping_set_error().

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/glops.c         |    5 +----
 fs/mpage.c              |   16 ++--------------
 include/linux/pagemap.h |   11 +++++++++++
 mm/page-writeback.c     |    7 +------
 mm/vmscan.c             |    8 ++------
 5 files changed, 17 insertions(+), 30 deletions(-)

diff -puN fs/gfs2/glops.c~factor-outstanding-i-o-error-handling fs/gfs2/glops.c
--- a/fs/gfs2/glops.c~factor-outstanding-i-o-error-handling
+++ a/fs/gfs2/glops.c
@@ -163,10 +163,7 @@ static void inode_go_sync(struct gfs2_gl
 		if (ip) {
 			struct address_space *mapping = ip->i_inode.i_mapping;
 			int error = filemap_fdatawait(mapping);
-			if (error == -ENOSPC)
-				set_bit(AS_ENOSPC, &mapping->flags);
-			else if (error)
-				set_bit(AS_EIO, &mapping->flags);
+			mapping_set_error(mapping, error);
 		}
 		clear_bit(GLF_DIRTY, &gl->gl_flags);
 		gfs2_ail_empty_gl(gl);
diff -puN fs/mpage.c~factor-outstanding-i-o-error-handling fs/mpage.c
--- a/fs/mpage.c~factor-outstanding-i-o-error-handling
+++ a/fs/mpage.c
@@ -663,12 +663,7 @@ confused:
 	/*
 	 * The caller has a ref on the inode, so *mapping is stable
 	 */
-	if (*ret) {
-		if (*ret == -ENOSPC)
-			set_bit(AS_ENOSPC, &mapping->flags);
-		else
-			set_bit(AS_EIO, &mapping->flags);
-	}
+	mapping_set_error(mapping, *ret);
 out:
 	return bio;
 }
@@ -776,14 +771,7 @@ retry:
 
 			if (writepage) {
 				ret = (*writepage)(page, wbc);
-				if (ret) {
-					if (ret == -ENOSPC)
-						set_bit(AS_ENOSPC,
-							&mapping->flags);
-					else
-						set_bit(AS_EIO,
-							&mapping->flags);
-				}
+				mapping_set_error(mapping, ret);
 			} else {
 				bio = __mpage_writepage(bio, page, get_block,
 						&last_block_in_bio, &ret, wbc,
diff -puN include/linux/pagemap.h~factor-outstanding-i-o-error-handling include/linux/pagemap.h
--- a/include/linux/pagemap.h~factor-outstanding-i-o-error-handling
+++ a/include/linux/pagemap.h
@@ -11,6 +11,7 @@
 #include <linux/compiler.h>
 #include <asm/uaccess.h>
 #include <linux/gfp.h>
+#include <linux/bitops.h>
 
 /*
  * Bits in mapping->flags.  The lower __GFP_BITS_SHIFT bits are the page
@@ -19,6 +20,16 @@
 #define	AS_EIO		(__GFP_BITS_SHIFT + 0)	/* IO error on async write */
 #define AS_ENOSPC	(__GFP_BITS_SHIFT + 1)	/* ENOSPC on async write */
 
+static inline void mapping_set_error(struct address_space *mapping, int error)
+{
+	if (error) {
+		if (error == -ENOSPC)
+			set_bit(AS_ENOSPC, &mapping->flags);
+		else
+			set_bit(AS_EIO, &mapping->flags);
+	}
+}
+
 static inline gfp_t mapping_gfp_mask(struct address_space * mapping)
 {
 	return (__force gfp_t)mapping->flags & __GFP_BITS_MASK;
diff -puN mm/page-writeback.c~factor-outstanding-i-o-error-handling mm/page-writeback.c
--- a/mm/page-writeback.c~factor-outstanding-i-o-error-handling
+++ a/mm/page-writeback.c
@@ -683,12 +683,7 @@ retry:
 			}
 
 			ret = (*writepage)(page, wbc);
-			if (ret) {
-				if (ret == -ENOSPC)
-					set_bit(AS_ENOSPC, &mapping->flags);
-				else
-					set_bit(AS_EIO, &mapping->flags);
-			}
+			mapping_set_error(mapping, ret);
 
 			if (unlikely(ret == AOP_WRITEPAGE_ACTIVATE))
 				unlock_page(page);
diff -puN mm/vmscan.c~factor-outstanding-i-o-error-handling mm/vmscan.c
--- a/mm/vmscan.c~factor-outstanding-i-o-error-handling
+++ a/mm/vmscan.c
@@ -284,12 +284,8 @@ static void handle_write_error(struct ad
 				struct page *page, int error)
 {
 	lock_page(page);
-	if (page_mapping(page) == mapping) {
-		if (error == -ENOSPC)
-			set_bit(AS_ENOSPC, &mapping->flags);
-		else
-			set_bit(AS_EIO, &mapping->flags);
-	}
+	if (page_mapping(page) == mapping)
+		mapping_set_error(mapping, error);
 	unlock_page(page);
 }
 
_

Patches currently in -mm which might be from guichaz@yahoo.fr are

origin.patch
sync_sb_inodes-propagate-errors.patch
