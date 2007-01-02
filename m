From: akpm@osdl.org
Subject: + factor-outstanding-i-o-error-handling.patch added to -mm tree
Date: Tue, 02 Jan 2007 13:15:30 -0800
Message-ID: <200701022115.l02LFUvC029927@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:32864 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755414AbXABVPo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 2 Jan 2007 16:15:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: guichaz@yahoo.fr, swhiteho@redhat.com


The patch titled
     Factor outstanding I/O error handling
has been added to the -mm tree.  Its filename is
     factor-outstanding-i-o-error-handling.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Factor outstanding I/O error handling
From: Guillaume Chazarain <guichaz@yahoo.fr>

Cleanup: setting an outstanding error on a mapping was open coded too many
times.  Factor it out in mapping_set_error().

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/gfs2/glops.c         |    5 +----
 fs/mpage.c              |   16 ++--------------
 include/linux/pagemap.h |   10 ++++++++++
 mm/page-writeback.c     |    7 +------
 mm/vmscan.c             |    8 ++------
 5 files changed, 16 insertions(+), 30 deletions(-)

diff -puN fs/gfs2/glops.c~factor-outstanding-i-o-error-handling fs/gfs2/glops.c
--- a/fs/gfs2/glops.c~factor-outstanding-i-o-error-handling
+++ a/fs/gfs2/glops.c
@@ -213,10 +213,7 @@ static void inode_go_sync(struct gfs2_gl
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
@@ -19,6 +19,16 @@
 #define	AS_EIO		(__GFP_BITS_SHIFT + 0)	/* IO error on async write */
 #define AS_ENOSPC	(__GFP_BITS_SHIFT + 1)	/* ENOSPC on async write */
 
+static inline void mapping_set_error(struct address_space * mapping, int error)
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
@@ -651,12 +651,7 @@ retry:
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
@@ -286,12 +286,8 @@ static void handle_write_error(struct ad
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

git-acpi.patch
factor-outstanding-i-o-error-handling.patch
