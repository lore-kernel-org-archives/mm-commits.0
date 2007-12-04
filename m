From: akpm@linux-foundation.org
Subject: + cramfs-make-cramfs-little-endian-only-update.patch added to -mm tree
Date: Tue, 04 Dec 2007 12:47:51 -0800
Message-ID: <200712042047.lB4KlpTC004358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44471 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751688AbXLDUtF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 15:49:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lists-receive@programmierforen.de, andi@programmierforen.de, joern@logfs.org


The patch titled
     Make cramfs little endian only (update)
has been added to the -mm tree.  Its filename is
     cramfs-make-cramfs-little-endian-only-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Make cramfs little endian only (update)
From: Andi Drebes <lists-receive@programmierforen.de>

> > +#ifdef __BIG_ENDIAN
> > +/* Converts a cramfs_info from little endian to big endian. */
> > +static inline void cramfs_convert_info_letobe(struct cramfs_info* info)
> > +{
> > +	 info->crc = swab32(info->crc);
> > +	 info->edition = swab32(info->edition);
> > +	 info->blocks = swab32(info->blocks);
> > +	 info->files = swab32(info->files);
> > +}
>
> Can you remove the #ifdef and use le32_to_cpu() directly?
Sure. This saves some definitions (and lines of code)...
Here's the new patch (tested on the same machines mentioned in the first message).
I tried to move as many lines as possible out of the endian dependent section.

Signed-off-by: Andi Drebes <andi@programmierforen.de>
Cc: Joern Engel <joern@logfs.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cramfs/inode.c |   78 ++++++++++++++------------------------------
 1 file changed, 25 insertions(+), 53 deletions(-)

diff -puN fs/cramfs/inode.c~cramfs-make-cramfs-little-endian-only-update fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~cramfs-make-cramfs-little-endian-only-update
+++ a/fs/cramfs/inode.c
@@ -44,17 +44,23 @@ static DEFINE_MUTEX(read_mutex);
 #define CRAMINO(x)	(((x)->offset && (x)->size)?(x)->offset<<2:1)
 #define OFFSET(x)	((x)->i_ino)
 
-#ifdef __BIG_ENDIAN
-/* Converts a cramfs_info from little endian to big endian. */
-static inline void cramfs_convert_info_letobe(struct cramfs_info* info)
+/* Converts a cramfs_info from little endian to host endian. */
+static inline void cramfs_info_to_host(struct cramfs_info* info)
+{
+	 info->crc = le32_to_cpu(info->crc);
+	 info->edition = le32_to_cpu(info->edition);
+	 info->blocks = le32_to_cpu(info->blocks);
+	 info->files = le32_to_cpu(info->files);
+}
+
+/* Converts a 32 bit integer from little endian to host endian */
+static inline u32 cramfs_u32_to_host(u32 val)
 {
-	 info->crc = swab32(info->crc);
-	 info->edition = swab32(info->edition);
-	 info->blocks = swab32(info->blocks);
-	 info->files = swab32(info->files);
+	return le32_to_cpu(val);
 }
 
-/* Converts a cramfs_info from little endian to big endian. */
+#ifdef __BIG_ENDIAN
+/* Converts a cramfs_inode from little endian to big endian. */
 static inline void cramfs_convert_inode_letobe(struct cramfs_inode* inode)
 {
 	u8* inode_bytes = (u8*)inode;
@@ -74,66 +80,32 @@ static inline void cramfs_convert_inode_
 	inode_bytes[11] = ((old_nloffs[1] & 0x3f) << 2) | ((old_nloffs[0] & 0xc0) >> 6);
 }
 
-/* Converts a cramfs superblock from little endian to big endian. */
-static inline void cramfs_convert_super_letobe(struct cramfs_super* super)
-{
-	super->magic = swab32(super->magic);
-	super->size = swab32(super->size);
-	super->flags = swab32(super->flags);
-	super->future = swab32(super->future);
-	cramfs_convert_info_letobe(&super->fsid);
-	cramfs_convert_inode_letobe(&super->root);
-}
-
-/* Converts a 32 bit integer from little endian to big endian */
-static inline u32 cramfs_convert_u32_letobe(u32 val)
-{
-	return swab32(val);
-}
-
-static inline void cramfs_info_to_host(struct cramfs_info *info)
-{
-	cramfs_convert_info_letobe(info);
-}
-
 static inline void cramfs_inode_to_host(struct cramfs_inode *inode)
 {
 	cramfs_convert_inode_letobe(inode);
 }
 
-static inline void cramfs_super_to_host(struct cramfs_super *super)
-{
-	cramfs_convert_super_letobe(super);
-}
-
-static inline u32 cramfs_u32_to_host(u32 val)
-{
-	return cramfs_convert_u32_letobe(val);
-}
-
 #elif defined(__LITTLE_ENDIAN)
 
-static inline void cramfs_info_to_host(struct cramfs_info *info)
-{
-}
-
 static inline void cramfs_inode_to_host(struct cramfs_inode *inode)
 {
 }
 
-static inline void cramfs_super_to_host(struct cramfs_super *super)
-{
-}
-
-static inline u32 cramfs_u32_to_host(u32 val)
-{
-	return val;
-}
-
 #else
 #error "Neither __BIG_ENDIAN nor __LITTLE_ENDIAN defined."
 #endif
 
+/* Converts a cramfs superblock from little endian to host endian. */
+static inline void cramfs_super_to_host(struct cramfs_super* super)
+{
+	super->magic = le32_to_cpu(super->magic);
+	super->size = le32_to_cpu(super->size);
+	super->flags = le32_to_cpu(super->flags);
+	super->future = le32_to_cpu(super->future);
+	cramfs_info_to_host(&super->fsid);
+	cramfs_inode_to_host(&super->root);
+}
+
 static int cramfs_iget5_test(struct inode *inode, void *opaque)
 {
 	struct cramfs_inode *cramfs_inode = opaque;
_

Patches currently in -mm which might be from lists-receive@programmierforen.de are

cramfs-make-cramfs-little-endian-only.patch
cramfs-make-cramfs-little-endian-only-update.patch
cramfs-make-cramfs-little-endian-only-fix.patch
cramfs-update-documentation.patch
