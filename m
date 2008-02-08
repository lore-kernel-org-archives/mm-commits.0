From: akpm@linux-foundation.org
Subject: - udf-fix-3-signedness-1-unitialized-variable-warnings.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:17:48 -0800
Message-ID: <200802082017.m18KHTZU010823@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38749 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757883AbYBHVBs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:01:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marcin.slusarz@gmail.com, bfennema@falcon.csc.calpoly.edu, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     udf: fix 3 signedness & 1 unitialized variable warnings
has been removed from the -mm tree.  Its filename was
     udf-fix-3-signedness-1-unitialized-variable-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: udf: fix 3 signedness & 1 unitialized variable warnings
From: Marcin Slusarz <marcin.slusarz@gmail.com>

sparse generated:
fs/udf/inode.c:324:41: warning: incorrect type in argument 4 (different signedness)
fs/udf/inode.c:324:41:    expected long *<noident>
fs/udf/inode.c:324:41:    got unsigned long *<noident>

inode_getblk always set 4th argument to uint32_t value
3rd parameter of map_bh is sector_t (which is unsigned long or u64)
so convert phys value to sector_t

fs/udf/inode.c:1818:47: warning: incorrect type in argument 3 (different signedness)
fs/udf/inode.c:1818:47:    expected int *<noident>
fs/udf/inode.c:1818:47:    got unsigned int *<noident>
fs/udf/inode.c:1826:46: warning: incorrect type in argument 3 (different signedness)
fs/udf/inode.c:1826:46:    expected int *<noident>
fs/udf/inode.c:1826:46:    got unsigned int *<noident>

udf_get_filelongad and udf_get_shortad are called always for uint32_t
values (struct extent_position->offset), so it's safe to convert offset
parameter to uint32_t

gcc warned:
fs/udf/inode.c: In function 'udf_get_block':
fs/udf/inode.c:299: warning: 'phys' may be used uninitialized in this function
initialize it to 0 (if someday someone will break inode_getblk we will catch it immediately)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/directory.c |    8 ++++----
 fs/udf/inode.c     |    6 +++---
 fs/udf/udfdecl.h   |    4 ++--
 3 files changed, 9 insertions(+), 9 deletions(-)

diff -puN fs/udf/directory.c~udf-fix-3-signedness-1-unitialized-variable-warnings fs/udf/directory.c
--- a/fs/udf/directory.c~udf-fix-3-signedness-1-unitialized-variable-warnings
+++ a/fs/udf/directory.c
@@ -282,7 +282,7 @@ static extent_ad *udf_get_fileextent(voi
 }
 #endif
 
-short_ad *udf_get_fileshortad(uint8_t *ptr, int maxoffset, int *offset,
+short_ad *udf_get_fileshortad(uint8_t *ptr, int maxoffset, uint32_t *offset,
 			      int inc)
 {
 	short_ad *sa;
@@ -292,7 +292,7 @@ short_ad *udf_get_fileshortad(uint8_t *p
 		return NULL;
 	}
 
-	if ((*offset < 0) || ((*offset + sizeof(short_ad)) > maxoffset))
+	if ((*offset + sizeof(short_ad)) > maxoffset)
 		return NULL;
 	else {
 		sa = (short_ad *)ptr;
@@ -305,7 +305,7 @@ short_ad *udf_get_fileshortad(uint8_t *p
 	return sa;
 }
 
-long_ad *udf_get_filelongad(uint8_t *ptr, int maxoffset, int *offset, int inc)
+long_ad *udf_get_filelongad(uint8_t *ptr, int maxoffset, uint32_t *offset, int inc)
 {
 	long_ad *la;
 
@@ -314,7 +314,7 @@ long_ad *udf_get_filelongad(uint8_t *ptr
 		return NULL;
 	}
 
-	if ((*offset < 0) || ((*offset + sizeof(long_ad)) > maxoffset))
+	if ((*offset + sizeof(long_ad)) > maxoffset)
 		return NULL;
 	else {
 		la = (long_ad *)ptr;
diff -puN fs/udf/inode.c~udf-fix-3-signedness-1-unitialized-variable-warnings fs/udf/inode.c
--- a/fs/udf/inode.c~udf-fix-3-signedness-1-unitialized-variable-warnings
+++ a/fs/udf/inode.c
@@ -52,7 +52,7 @@ static int udf_update_inode(struct inode
 static void udf_fill_inode(struct inode *, struct buffer_head *);
 static int udf_alloc_i_data(struct inode *inode, size_t size);
 static struct buffer_head *inode_getblk(struct inode *, sector_t, int *,
-					long *, int *);
+					sector_t *, int *);
 static int8_t udf_insert_aext(struct inode *, struct extent_position,
 			      kernel_lb_addr, uint32_t);
 static void udf_split_extents(struct inode *, int *, int, int,
@@ -307,7 +307,7 @@ static int udf_get_block(struct inode *i
 {
 	int err, new;
 	struct buffer_head *bh;
-	unsigned long phys;
+	sector_t phys = 0;
 	struct udf_inode_info *iinfo;
 
 	if (!create) {
@@ -489,7 +489,7 @@ out:
 }
 
 static struct buffer_head *inode_getblk(struct inode *inode, sector_t block,
-					int *err, long *phys, int *new)
+					int *err, sector_t *phys, int *new)
 {
 	static sector_t last_block;
 	struct buffer_head *result = NULL;
diff -puN fs/udf/udfdecl.h~udf-fix-3-signedness-1-unitialized-variable-warnings fs/udf/udfdecl.h
--- a/fs/udf/udfdecl.h~udf-fix-3-signedness-1-unitialized-variable-warnings
+++ a/fs/udf/udfdecl.h
@@ -188,8 +188,8 @@ extern struct fileIdentDesc *udf_fileide
 						sector_t *);
 extern struct fileIdentDesc *udf_get_fileident(void *buffer, int bufsize,
 					       int *offset);
-extern long_ad *udf_get_filelongad(uint8_t *, int, int *, int);
-extern short_ad *udf_get_fileshortad(uint8_t *, int, int *, int);
+extern long_ad *udf_get_filelongad(uint8_t *, int, uint32_t *, int);
+extern short_ad *udf_get_fileshortad(uint8_t *, int, uint32_t *, int);
 
 /* crc.c */
 extern uint16_t udf_crc(uint8_t *, uint32_t, uint16_t);
_

Patches currently in -mm which might be from marcin.slusarz@gmail.com are

origin.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
