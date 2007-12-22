From: akpm@linux-foundation.org
Subject: + udf-fix-3-signedness-1-unitialized-variable-warnings.patch added to -mm tree
Date: Fri, 21 Dec 2007 16:18:36 -0800
Message-ID: <200712220018.lBM0IaA3006283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49865 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754551AbXLVASr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 19:18:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcin.slusarz@gmail.com, bfennema@falcon.csc.calpoly.edu, jack@suse.cz


The patch titled
     udf: fix 3 signedness & 1 unitialized variable warnings
has been added to the -mm tree.  Its filename is
     udf-fix-3-signedness-1-unitialized-variable-warnings.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -271,7 +271,7 @@ static extent_ad *udf_get_fileextent(voi
 }
 #endif
 
-short_ad *udf_get_fileshortad(uint8_t *ptr, int maxoffset, int *offset,
+short_ad *udf_get_fileshortad(uint8_t *ptr, int maxoffset, uint32_t *offset,
 			      int inc)
 {
 	short_ad *sa;
@@ -281,7 +281,7 @@ short_ad *udf_get_fileshortad(uint8_t *p
 		return NULL;
 	}
 
-	if ((*offset < 0) || ((*offset + sizeof(short_ad)) > maxoffset))
+	if ((*offset + sizeof(short_ad)) > maxoffset)
 		return NULL;
 	else if ((sa = (short_ad *)ptr)->extLength == 0)
 		return NULL;
@@ -291,7 +291,7 @@ short_ad *udf_get_fileshortad(uint8_t *p
 	return sa;
 }
 
-long_ad *udf_get_filelongad(uint8_t *ptr, int maxoffset, int *offset, int inc)
+long_ad *udf_get_filelongad(uint8_t *ptr, int maxoffset, uint32_t *offset, int inc)
 {
 	long_ad *la;
 
@@ -300,7 +300,7 @@ long_ad *udf_get_filelongad(uint8_t *ptr
 		return NULL;
 	}
 
-	if ((*offset < 0) || ((*offset + sizeof(long_ad)) > maxoffset))
+	if ((*offset + sizeof(long_ad)) > maxoffset)
 		return NULL;
 	else if ((la = (long_ad *)ptr)->extLength == 0)
 		return NULL;
diff -puN fs/udf/inode.c~udf-fix-3-signedness-1-unitialized-variable-warnings fs/udf/inode.c
--- a/fs/udf/inode.c~udf-fix-3-signedness-1-unitialized-variable-warnings
+++ a/fs/udf/inode.c
@@ -51,7 +51,7 @@ static int udf_update_inode(struct inode
 static void udf_fill_inode(struct inode *, struct buffer_head *);
 static int udf_alloc_i_data(struct inode *inode, size_t size);
 static struct buffer_head *inode_getblk(struct inode *, sector_t, int *,
-					long *, int *);
+					sector_t *, int *);
 static int8_t udf_insert_aext(struct inode *, struct extent_position,
 			      kernel_lb_addr, uint32_t);
 static void udf_split_extents(struct inode *, int *, int, int,
@@ -296,7 +296,7 @@ static int udf_get_block(struct inode *i
 {
 	int err, new;
 	struct buffer_head *bh;
-	unsigned long phys;
+	sector_t phys = 0;
 
 	if (!create) {
 		phys = udf_block_map(inode, block);
@@ -469,7 +469,7 @@ out:
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
@@ -185,8 +185,8 @@ extern struct fileIdentDesc *udf_fileide
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

git-alsa.patch
ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fixes.patch
vgacon-fix-sparse-warning-about-shadowing-i-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-p-symbol.patch
fbcon-fix-sparse-warning-about-shadowing-rotate-symbol.patch
logo-move-declarations-of-logos-to-linux_logoh.patch
logo-move-declarations-of-logos-to-linux_logoh-fix.patch
udf-remove-wrong-prototype-of-udf_readdir.patch
udf-remove-wrong-prototype-of-udf_readdir-checkpatch-fixes.patch
udf-improve-readability-of-do_udf_readdir.patch
udf-fix-coding-style-of-dirc.patch
udf-fix-3-signedness-1-unitialized-variable-warnings.patch
udf-fix-signedness-issue.patch
udf-fix-sparse-warnings-shadowing-mismatch-between-declaration-and-definition.patch
