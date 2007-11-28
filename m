From: akpm@linux-foundation.org
Subject: + reiser4-make-methods-supplied-to-vfs-invariant.patch added to -mm tree
Date: Tue, 27 Nov 2007 20:16:37 -0800
Message-ID: <200711280416.lAS4GbED015287@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39987 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752308AbXK1ERc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 23:17:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: edward@namesys.com, rvalles@es.gnu.org


The patch titled
     reiser4: make methods supplied to vfs invariant
has been added to the -mm tree.  Its filename is
     reiser4-make-methods-supplied-to-vfs-invariant.patch

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to =
find
out what to do about this

------------------------------------------------------
Subject: reiser4: make methods supplied to vfs invariant
=46rom: Edward Shishkin <edward@namesys.com>

Problem:
hangs when writing to reiser4 partition exported via nfs
(found by Roc Vall=E8s Dom=E8nech <rvalles@es.gnu.org>).

Bug:
vfs (which is not aware of reiser4 plugin conversion) uses
obsolete copy of @file->f_op, whereas old methods are not
aware about new structures. It leads to memory corruption.

=46ixup:
Prevent collisions with vfs:
Make inode_ops, file_ops and a_ops supplied to vfs
invariant with respect to plugin conversion.

Signed-off-by: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/as_ops.c                         |   40=20
 fs/reiser4/inode.c                          |   20=20
 fs/reiser4/plugin/file/cryptcompress.c      |  107=20
 fs/reiser4/plugin/file/cryptcompress.c.orig | 3788 ++++++++++++++++++
 fs/reiser4/plugin/file/file.c               |   44=20
 fs/reiser4/plugin/file/file.h               |  166=20
 fs/reiser4/plugin/file/file_conversion.c    |  204=20
 fs/reiser4/plugin/file_ops.c                |   37=20
 fs/reiser4/plugin/object.c                  |  299 -
 fs/reiser4/plugin/plugin.h                  |   73=20
 10 files changed, 4378 insertions(+), 400 deletions(-)

diff -puN fs/reiser4/as_ops.c~reiser4-make-methods-supplied-to-vfs-inva=
riant fs/reiser4/as_ops.c
--- a/fs/reiser4/as_ops.c~reiser4-make-methods-supplied-to-vfs-invarian=
t
+++ a/fs/reiser4/as_ops.c
@@ -326,6 +326,46 @@ int reiser4_releasepage(struct page *pag
 	}
 }
=20
+int reiser4_readpage(struct file *file, struct page *page)
+{
+	assert("edward-1533", PageLocked(page));
+	assert("edward-1534", !PageUptodate(page));
+	assert("edward-1535", page->mapping && page->mapping->host);
+
+	return inode_file_plugin(page->mapping->host)->readpage(file, page);
+}
+
+int reiser4_readpages(struct file *file, struct address_space *mapping=
,
+		      struct list_head *pages, unsigned nr_pages)
+{
+	return inode_file_plugin(mapping->host)->readpages(file, mapping,
+							   pages, nr_pages);
+}
+
+int reiser4_writepages(struct address_space *mapping,
+		       struct writeback_control *wbc)
+{
+	return inode_file_plugin(mapping->host)->writepages(mapping, wbc);
+}
+
+int reiser4_prepare_write(struct file *file, struct page *page,
+			  unsigned from, unsigned to)
+{
+	return inode_file_plugin(file->f_dentry->d_inode)->prepare_write(file=
,
+									 page,
+									 from,
+									 to);
+}
+
+int reiser4_commit_write(struct file *file, struct page *page,
+			 unsigned from, unsigned to)
+{
+	return inode_file_plugin(file->f_dentry->d_inode)->commit_write(file,
+									page,
+									from,
+									to);
+}
+
 /* Make Linus happy.
    Local variables:
    c-indentation-style: "K&R"
diff -puN /dev/null /dev/null
diff -puN fs/reiser4/inode.c~reiser4-make-methods-supplied-to-vfs-invar=
iant fs/reiser4/inode.c
--- a/fs/reiser4/inode.c~reiser4-make-methods-supplied-to-vfs-invariant
+++ a/fs/reiser4/inode.c
@@ -151,38 +151,38 @@ int setup_inode_ops(struct inode *inode=20
 				rdev =3D data->rdev;
 			inode->i_blocks =3D 0;
 			assert("vs-42", fplug->h.id =3D=3D SPECIAL_FILE_PLUGIN_ID);
-			inode->i_op =3D &file_plugins[fplug->h.id].inode_ops;
+			inode->i_op =3D file_plugins[fplug->h.id].inode_ops;
 			/* initialize inode->i_fop and inode->i_rdev for block and char
 			   devices */
 			init_special_inode(inode, inode->i_mode, rdev);
 			/* all address space operations are null */
 			inode->i_mapping->a_ops =3D
-			    &file_plugins[fplug->h.id].as_ops;
+			    file_plugins[fplug->h.id].as_ops;
 			break;
 		}
 	case S_IFLNK:
 		assert("vs-46", fplug !=3D NULL);
 		assert("vs-42", fplug->h.id =3D=3D SYMLINK_FILE_PLUGIN_ID);
-		inode->i_op =3D &file_plugins[fplug->h.id].inode_ops;
+		inode->i_op =3D file_plugins[fplug->h.id].inode_ops;
 		inode->i_fop =3D NULL;
 		/* all address space operations are null */
-		inode->i_mapping->a_ops =3D &file_plugins[fplug->h.id].as_ops;
+		inode->i_mapping->a_ops =3D file_plugins[fplug->h.id].as_ops;
 		break;
 	case S_IFDIR:
 		assert("vs-46", dplug !=3D NULL);
 		assert("vs-43", (dplug->h.id =3D=3D HASHED_DIR_PLUGIN_ID ||
 				 dplug->h.id =3D=3D SEEKABLE_HASHED_DIR_PLUGIN_ID));
-		inode->i_op =3D &dir_plugins[dplug->h.id].inode_ops;
-		inode->i_fop =3D &dir_plugins[dplug->h.id].file_ops;
-		inode->i_mapping->a_ops =3D &dir_plugins[dplug->h.id].as_ops;
+		inode->i_op =3D dir_plugins[dplug->h.id].inode_ops;
+		inode->i_fop =3D dir_plugins[dplug->h.id].file_ops;
+		inode->i_mapping->a_ops =3D dir_plugins[dplug->h.id].as_ops;
 		break;
 	case S_IFREG:
 		assert("vs-46", fplug !=3D NULL);
 		assert("vs-43", (fplug->h.id =3D=3D UNIX_FILE_PLUGIN_ID ||
 				 fplug->h.id =3D=3D CRYPTCOMPRESS_FILE_PLUGIN_ID));
-		inode->i_op =3D &file_plugins[fplug->h.id].inode_ops;
-		inode->i_fop =3D &file_plugins[fplug->h.id].file_ops;
-		inode->i_mapping->a_ops =3D &file_plugins[fplug->h.id].as_ops;
+		inode->i_op =3D file_plugins[fplug->h.id].inode_ops;
+		inode->i_fop =3D file_plugins[fplug->h.id].file_ops;
+		inode->i_mapping->a_ops =3D file_plugins[fplug->h.id].as_ops;
 		break;
 	default:
 		warning("nikita-291", "wrong file mode: %o for %llu",
diff -puN /dev/null /dev/null
diff -puN fs/reiser4/plugin/file/cryptcompress.c~reiser4-make-methods-s=
upplied-to-vfs-invariant fs/reiser4/plugin/file/cryptcompress.c
--- a/fs/reiser4/plugin/file/cryptcompress.c~reiser4-make-methods-suppl=
ied-to-vfs-invariant
+++ a/fs/reiser4/plugin/file/cryptcompress.c
@@ -264,6 +264,7 @@ static void uninstantiate_crypto_info(st
 	info->inst =3D 0;
 }
=20
+#if 0
 static int is_crypto_info_instantiated(struct reiser4_crypto_info * in=
fo)
 {
 	return info->inst;
@@ -275,6 +276,7 @@ static int inode_has_cipher_key(struct i
 	return inode_crypto_info(inode) &&
 		is_crypto_info_instantiated(inode_crypto_info(inode));
 }
+#endif
=20
 static void free_crypto_info (struct inode * inode)
 {
@@ -465,7 +467,7 @@ static int inode_check_cluster(struct in
 	return 0;
 }
=20
-/* ->destroy_inode() method of the cryptcompress plugin */
+/* plugin->destroy_inode() */
 void destroy_inode_cryptcompress(struct inode * inode)
 {
 	assert("edward-1464", INODE_PGCOUNT(inode) =3D=3D 0);
@@ -473,15 +475,14 @@ void destroy_inode_cryptcompress(struct=20
 	return;
 }
=20
-/* ->create() method of the cryptcompress plugin
-
+/* plugin->create_object():
 . install plugins
 . attach crypto info if specified
 . attach compression info if specified
 . attach cluster info
 */
-int create_cryptcompress(struct inode *object, struct inode *parent,
-			 reiser4_object_create_data * data)
+int create_object_cryptcompress(struct inode *object, struct inode *pa=
rent,
+				reiser4_object_create_data * data)
 {
 	int result;
 	reiser4_inode *info;
@@ -521,33 +522,9 @@ int create_cryptcompress(struct inode *o
 	return result;
 }
=20
-/* ->open_object() method of the cryptcompress plugin */
-int open_object_cryptcompress(struct inode * inode, struct file * file=
)
+/* plugin->open() */
+int open_cryptcompress(struct inode * inode, struct file * file)
 {
-	int result;
-	struct inode * parent;
-
-	assert("edward-1394", inode !=3D NULL);
-	assert("edward-1395", file !=3D NULL);
-	assert("edward-1396", file !=3D NULL);
-	assert("edward-1397", file->f_dentry->d_inode =3D=3D inode);
-	assert("edward-1398", file->f_dentry->d_parent !=3D NULL);
-	assert("edward-1399", file->f_dentry->d_parent->d_inode !=3D NULL);
-	assert("edward-698",
-	       inode_file_plugin(inode) =3D=3D
-	       file_plugin_by_id(CRYPTCOMPRESS_FILE_PLUGIN_ID));
-	result =3D inode_check_cluster(inode);
-	if (result)
-		return result;
-	result =3D inode_init_compression(inode);
-	if (result)
-		return result;
-	if (!need_cipher(inode))
-		/* the file is not to be ciphered */
-		return 0;
-	parent =3D file->f_dentry->d_parent->d_inode;
-	if (!inode_has_cipher_key(inode))
-		return RETERR(-EINVAL);
 	return 0;
 }
=20
@@ -2657,6 +2634,7 @@ void reset_cluster_params(struct cluster
 	clust->tc.len =3D 0;
 }
=20
+/* the heart of write_cryptcompress */
 static loff_t do_write_cryptcompress(struct file *file, struct inode *=
inode,
 				     const char __user *buf, size_t to_write,
 				     loff_t pos, int *conv_occured)
@@ -2817,14 +2795,11 @@ static loff_t do_write_cryptcompress(str
 }
=20
 /**
- * write_cryptcompress - write of struct file_operations
+ * plugin->write()
  * @file: file to write to
  * @buf: address of user-space buffer
  * @read_amount: number of bytes to write
  * @off: position in file to write to
- *
- * This is implementation of vfs's write method of struct file_operati=
ons for
- * cryptcompress plugin.
  */
 ssize_t write_cryptcompress(struct file *file, const char __user *buf,
 			    size_t count, loff_t *off, int *conv)
@@ -2873,6 +2848,7 @@ ssize_t write_cryptcompress(struct file=20
 	return result;
 }
=20
+/* plugin->readpages */
 int readpages_cryptcompress(struct file *file, struct address_space *m=
apping,
 			    struct list_head *pages, unsigned nr_pages)
 {
@@ -2905,14 +2881,11 @@ static reiser4_block_nr cryptcompress_es
 }
=20
 /**
- * read_cryptcompress - read of struct file_operations
+ * plugin->read
  * @file: file to read from
  * @buf: address of user-space buffer
  * @read_amount: number of bytes to read
  * @off: position in file to read from
- *
- * This is implementation of vfs's read method of struct file_operatio=
ns for
- * cryptcompress plugin.
  */
 ssize_t read_cryptcompress(struct file * file, char __user *buf, size_=
t size,
 			   loff_t * off)
@@ -3046,6 +3019,8 @@ static void adjust_left_coord(coord_t *=20
 }
=20
 #define CRC_CUT_TREE_MIN_ITERATIONS 64
+
+/* plugin->cut_tree_worker */
 int cut_tree_worker_cryptcompress(tap_t * tap, const reiser4_key * fro=
m_key,
 				  const reiser4_key * to_key,
 				  reiser4_key * smallest_removed,
@@ -3405,8 +3380,10 @@ static int start_truncate_fake(struct in
 	return result;
 }
=20
-/* This is called in setattr_cryptcompress when it is used to truncate=
,
- * and in delete_cryptcompress */
+/**
+ * This is called in setattr_cryptcompress when it is used to truncate=
,
+ * and in delete_object_cryptcompress
+ */
 static int cryptcompress_truncate(struct inode *inode,	/* old size */
 				  loff_t new_size,	/* new size */
 				  int update_sd)
@@ -3569,8 +3546,7 @@ static int cryptcompress_inode_has_anon_
 	return result;
 }
=20
-/* This is implementation of vfs's writepages method of struct
-   address_space_operations */
+/* plugin->writepages */
 int writepages_cryptcompress(struct address_space *mapping,
 			     struct writeback_control *wbc)
 {
@@ -3647,7 +3623,14 @@ int writepages_cryptcompress(struct addr
 	return result;
 }
=20
-/* plugin->u.file.mmap */
+/* plugin->ioctl */
+int ioctl_cryptcompress(struct inode *inode, struct file *filp,
+			unsigned int cmd, unsigned long arg)
+{
+	return 0;
+}
+
+/* plugin->mmap */
 int mmap_cryptcompress(struct file *file, struct vm_area_struct *vma)
 {
 	int result;
@@ -3674,12 +3657,7 @@ int mmap_cryptcompress(struct file *file
 	return result;
 }
=20
-/* plugin->u.file.release */
-/* plugin->u.file.get_block */
-
-/* this is implementation of delete method of file plugin for
- * cryptcompress objects
- */
+/* plugin->delete_object */
 int delete_object_cryptcompress(struct inode *inode)
 {
 	int result;
@@ -3706,8 +3684,10 @@ int delete_object_cryptcompress(struct i
 	return reiser4_delete_object_common(inode);
 }
=20
-/* plugin->u.file.setattr method
-   This implements actual truncate (see comments in reiser4/page_cache=
=2Ec) */
+/*
+ * plugin->setattr
+ * This implements actual truncate (see comments in reiser4/page_cache=
=2Ec)
+ */
 int setattr_cryptcompress(struct dentry *dentry, struct iattr *attr)
 {
 	int result;
@@ -3751,11 +3731,7 @@ int setattr_cryptcompress(struct dentry=20
 	return result;
 }
=20
-/*
- * release_cryptcompress - release of struct file_operations
- * @inode: inode of released file
- * @file: file to release
- */
+/* plugin->release */
 int release_cryptcompress(struct inode *inode, struct file *file)
 {
 	reiser4_context *ctx =3D reiser4_init_context(inode->i_sb);
@@ -3767,14 +3743,25 @@ int release_cryptcompress(struct inode *
 	return 0;
 }
=20
-#if 0
+/* plugin->prepare_write */
 int prepare_write_cryptcompress(struct file *file, struct page *page,
 				unsigned from, unsigned to)
 {
-	return prepare_write_common(file, page, from, to);
+	return 0;
 }
-#endif  /*  0  */
=20
+/* plugin->commit_write */
+int commit_write_cryptcompress(struct file *file, struct page *page,
+			       unsigned from, unsigned to)
+{
+	return 0;
+}
+
+/* plugin->bmap */
+sector_t bmap_cryptcompress(struct address_space *mapping, sector_t lb=
lock)
+{
+	return -EINVAL;
+}
=20
 /*
   Local variables:
diff -puN /dev/null fs/reiser4/plugin/file/cryptcompress.c.orig
--- /dev/null
+++ a/fs/reiser4/plugin/file/cryptcompress.c.orig
@@ -0,0 +1,3788 @@
+/* Copyright 2001, 2002, 2003 by Hans Reiser, licensing governed by
+   reiser4/README */
+/*
+ * Written by Edward Shishkin.
+ *
+ * Implementations of inode/file/address_space operations
+ * specific for cryptcompress file plugin which manages
+ * regular files built of compressed and(or) encrypted bodies.
+ * See http://dev.namesys.com/CryptcompressPlugin for details.
+ */
+
+#include "../../inode.h"
+#include "../cluster.h"
+#include "../object.h"
+#include "../../tree_walk.h"
+#include "cryptcompress.h"
+
+#include <linux/pagevec.h>
+#include <asm/uaccess.h>
+#include <linux/swap.h>
+#include <linux/writeback.h>
+#include <linux/random.h>
+#include <linux/scatterlist.h>
+
+/*
+               Managing primary and secondary caches by Reiser4
+               cryptcompress file plugin. Synchronization scheme.
+
+
+                                             +------------------+
+                        +------------------->|    tfm stream    |
+                        |                    | (compressed data)|
+                  flush |                    +------------------+
+                        +-----------------+           |
+                        |(->)longterm lock|           V
+--+        writepages() |                 |        +-***-+  reiser4   =
     +---+
+  |                     |                 +--+     | *** |  storage tr=
ee   |   |
+  |                     |                    |     +-***-+  (primary c=
ache)|   |
+u | write()   (secondary| cache)             V    /   |   \           =
     |   |
+s | ---->  +----+ +----+ +----+ +----+     +-***** ******* **----+  --=
-->  | d |
+e |        |    | |page cluster |    |     | **disk cluster**    |    =
     | i |
+r | <----  +----+ +----+ +----+ +----+     +-***** **********----+  <-=
---  | s |
+  | read()              ^                      ^      |               =
     | k |
+  |                     |     (->)longterm lock|      |           page=
_io()|   |
+  |                     |                      +------+               =
     |   |
+--+         readpages() |                             |               =
     +---+
+                        |                             V
+                        |                    +------------------+
+                        +--------------------|    tfm stream    |
+                                             |   (plain text)   |
+                                             +------------------+
+*/
+
+/* get cryptcompress specific portion of inode */
+struct cryptcompress_info *cryptcompress_inode_data(const struct inode=
 *inode)
+{
+	return &reiser4_inode_data(inode)->file_plugin_data.cryptcompress_inf=
o;
+}
+
+/* plugin->u.file.init_inode_data */
+void init_inode_data_cryptcompress(struct inode *inode,
+				   reiser4_object_create_data * crd,
+				   int create)
+{
+	struct cryptcompress_info *data;
+
+	data =3D cryptcompress_inode_data(inode);
+	assert("edward-685", data !=3D NULL);
+
+	memset(data, 0, sizeof(*data));
+
+	mutex_init(&data->checkin_mutex);
+	data->trunc_index =3D ULONG_MAX;
+	turn_on_compression(data);
+	set_lattice_factor(data, MIN_LATTICE_FACTOR);
+	init_inode_ordering(inode, crd, create);
+}
+
+/* The following is a part of reiser4 cipher key manager
+   which is called when opening/creating a cryptcompress file */
+
+/* get/set cipher key info */
+struct reiser4_crypto_info * inode_crypto_info (struct inode * inode)
+{
+	assert("edward-90", inode !=3D NULL);
+	assert("edward-91", reiser4_inode_data(inode) !=3D NULL);
+	return cryptcompress_inode_data(inode)->crypt;
+}
+
+static void set_inode_crypto_info (struct inode * inode,
+				   struct reiser4_crypto_info * info)
+{
+	cryptcompress_inode_data(inode)->crypt =3D info;
+}
+
+/* allocate a cipher key info */
+struct reiser4_crypto_info * reiser4_alloc_crypto_info (struct inode *=
 inode)
+{
+	struct reiser4_crypto_info *info;
+	int fipsize;
+
+	info =3D kzalloc(sizeof(*info), reiser4_ctx_gfp_mask_get());
+	if (!info)
+		return ERR_PTR(-ENOMEM);
+
+	fipsize =3D inode_digest_plugin(inode)->fipsize;
+	info->keyid =3D kmalloc(fipsize, reiser4_ctx_gfp_mask_get());
+	if (!info->keyid) {
+		kfree(info);
+		return ERR_PTR(-ENOMEM);
+	}
+	info->host =3D inode;
+	return info;
+}
+
+#if 0
+/* allocate/free low-level info for cipher and digest
+   transforms */
+static int alloc_crypto_tfms(struct reiser4_crypto_info * info)
+{
+	struct crypto_blkcipher * ctfm =3D NULL;
+	struct crypto_hash      * dtfm =3D NULL;
+	cipher_plugin * cplug =3D inode_cipher_plugin(info->host);
+	digest_plugin * dplug =3D inode_digest_plugin(info->host);
+
+	if (cplug->alloc) {
+		ctfm =3D cplug->alloc();
+		if (IS_ERR(ctfm)) {
+			warning("edward-1364",
+				"Can not allocate info for %s\n",
+				cplug->h.desc);
+			return RETERR(PTR_ERR(ctfm));
+		}
+	}
+	info_set_cipher(info, ctfm);
+	if (dplug->alloc) {
+		dtfm =3D dplug->alloc();
+		if (IS_ERR(dtfm)) {
+			warning("edward-1365",
+				"Can not allocate info for %s\n",
+				dplug->h.desc);
+			goto unhappy_with_digest;
+		}
+	}
+	info_set_digest(info, dtfm);
+	return 0;
+ unhappy_with_digest:
+	if (cplug->free) {
+		cplug->free(ctfm);
+		info_set_cipher(info, NULL);
+	}
+	return RETERR(PTR_ERR(dtfm));
+}
+#endif
+
+static void
+free_crypto_tfms(struct reiser4_crypto_info * info)
+{
+	assert("edward-1366", info !=3D NULL);
+	if (!info_get_cipher(info)) {
+		assert("edward-1601", !info_get_digest(info));
+		return;
+	}
+	inode_cipher_plugin(info->host)->free(info_get_cipher(info));
+	info_set_cipher(info, NULL);
+	inode_digest_plugin(info->host)->free(info_get_digest(info));
+	info_set_digest(info, NULL);
+	return;
+}
+
+#if 0
+/* create a key fingerprint for disk stat-data */
+static int create_keyid (struct reiser4_crypto_info * info,
+			 struct reiser4_crypto_data * data)
+{
+	int ret =3D -ENOMEM;
+	size_t blk, pad;
+	__u8 * dmem;
+	__u8 * cmem;
+	struct hash_desc      ddesc;
+	struct blkcipher_desc cdesc;
+	struct scatterlist sg;
+
+	assert("edward-1367", info !=3D NULL);
+	assert("edward-1368", info->keyid !=3D NULL);
+
+	ddesc.tfm =3D info_get_digest(info);
+	ddesc.flags =3D 0;
+	cdesc.tfm =3D info_get_cipher(info);
+	cdesc.flags =3D 0;
+
+	dmem =3D kmalloc((size_t)crypto_hash_digestsize(ddesc.tfm),
+		       reiser4_ctx_gfp_mask_get());
+	if (!dmem)
+		goto exit1;
+
+	blk =3D crypto_blkcipher_blocksize(cdesc.tfm);
+
+	pad =3D data->keyid_size % blk;
+	pad =3D (pad ? blk - pad : 0);
+
+	cmem =3D kmalloc((size_t)data->keyid_size + pad,
+		       reiser4_ctx_gfp_mask_get());
+	if (!cmem)
+		goto exit2;
+	memcpy(cmem, data->keyid, data->keyid_size);
+	memset(cmem + data->keyid_size, 0, pad);
+
+	sg_init_one(&sg, cmem, data->keyid_size + pad);
+
+	ret =3D crypto_blkcipher_encrypt(&cdesc, &sg, &sg,
+				       data->keyid_size + pad);
+	if (ret) {
+		warning("edward-1369",
+			"encryption failed flags=3D%x\n", cdesc.flags);
+		goto exit3;
+	}
+	ret =3D crypto_hash_digest(&ddesc, &sg, sg.length, dmem);
+	if (ret) {
+		warning("edward-1602",
+			"digest failed flags=3D%x\n", ddesc.flags);
+		goto exit3;
+	}
+	memcpy(info->keyid, dmem, inode_digest_plugin(info->host)->fipsize);
+ exit3:
+	kfree(cmem);
+ exit2:
+	kfree(dmem);
+ exit1:
+	return ret;
+}
+#endif
+
+static void destroy_keyid(struct reiser4_crypto_info * info)
+{
+	assert("edward-1370", info !=3D NULL);
+	assert("edward-1371", info->keyid !=3D NULL);
+	kfree(info->keyid);
+	return;
+}
+
+static void __free_crypto_info (struct inode * inode)
+{
+	struct reiser4_crypto_info * info =3D inode_crypto_info(inode);
+	assert("edward-1372", info !=3D NULL);
+
+	free_crypto_tfms(info);
+	destroy_keyid(info);
+	kfree(info);
+}
+
+#if 0
+static void instantiate_crypto_info(struct reiser4_crypto_info * info)
+{
+	assert("edward-1373", info !=3D NULL);
+	assert("edward-1374", info->inst =3D=3D 0);
+	info->inst =3D 1;
+}
+#endif
+
+static void uninstantiate_crypto_info(struct reiser4_crypto_info * inf=
o)
+{
+	assert("edward-1375", info !=3D NULL);
+	info->inst =3D 0;
+}
+
+static int is_crypto_info_instantiated(struct reiser4_crypto_info * in=
fo)
+{
+	return info->inst;
+}
+
+static int inode_has_cipher_key(struct inode * inode)
+{
+	assert("edward-1376", inode !=3D NULL);
+	return inode_crypto_info(inode) &&
+		is_crypto_info_instantiated(inode_crypto_info(inode));
+}
+
+static void free_crypto_info (struct inode * inode)
+{
+	uninstantiate_crypto_info(inode_crypto_info(inode));
+	__free_crypto_info(inode);
+}
+
+static int need_cipher(struct inode * inode)
+{
+	return inode_cipher_plugin(inode) !=3D
+		cipher_plugin_by_id(NONE_CIPHER_ID);
+}
+
+/* Parse @data which contains a (uninstantiated) cipher key imported
+   from user space, create a low-level cipher info and attach it to
+   the @object. If success, then info contains an instantiated key */
+#if 0
+struct reiser4_crypto_info * create_crypto_info(struct inode * object,
+				  struct reiser4_crypto_data * data)
+{
+	int ret;
+	struct reiser4_crypto_info * info;
+
+	assert("edward-1377", data !=3D NULL);
+	assert("edward-1378", need_cipher(object));
+
+	if (inode_file_plugin(object) !=3D
+	    file_plugin_by_id(DIRECTORY_FILE_PLUGIN_ID))
+		return ERR_PTR(-EINVAL);
+
+	info =3D reiser4_alloc_crypto_info(object);
+	if (IS_ERR(info))
+		return info;
+	ret =3D alloc_crypto_tfms(info);
+	if (ret)
+		goto err;
+	/* instantiating a key */
+	ret =3D crypto_blkcipher_setkey(info_get_cipher(info),
+				      data->key,
+				      data->keysize);
+	if (ret) {
+		warning("edward-1379",
+			"setkey failed flags=3D%x",
+			crypto_blkcipher_get_flags(info_get_cipher(info)));
+		goto err;
+	}
+	info->keysize =3D data->keysize;
+	ret =3D create_keyid(info, data);
+	if (ret)
+		goto err;
+	instantiate_crypto_info(info);
+	return info;
+ err:
+	__free_crypto_info(object);
+ 	return ERR_PTR(ret);
+}
+#endif
+
+/* increment/decrement a load counter when
+   attaching/detaching the crypto-stat to any object */
+static void load_crypto_info(struct reiser4_crypto_info * info)
+{
+	assert("edward-1380", info !=3D NULL);
+	inc_keyload_count(info);
+}
+
+static void unload_crypto_info(struct inode * inode)
+{
+	struct reiser4_crypto_info * info =3D inode_crypto_info(inode);
+	assert("edward-1381", info->keyload_count > 0);
+
+	dec_keyload_count(inode_crypto_info(inode));
+	if (info->keyload_count =3D=3D 0)
+		/* final release */
+		free_crypto_info(inode);
+}
+
+/* attach/detach an existing crypto-stat */
+void reiser4_attach_crypto_info(struct inode * inode,
+				struct reiser4_crypto_info * info)
+{
+	assert("edward-1382", inode !=3D NULL);
+	assert("edward-1383", info !=3D NULL);
+	assert("edward-1384", inode_crypto_info(inode) =3D=3D NULL);
+
+	set_inode_crypto_info(inode, info);
+	load_crypto_info(info);
+}
+
+/* returns true, if crypto stat can be attached to the @host */
+#if REISER4_DEBUG
+static int host_allows_crypto_info(struct inode * host)
+{
+	int ret;
+	file_plugin * fplug =3D inode_file_plugin(host);
+
+	switch (fplug->h.id) {
+	case CRYPTCOMPRESS_FILE_PLUGIN_ID:
+		ret =3D 1;
+		break;
+	default:
+		ret =3D 0;
+	}
+	return ret;
+}
+#endif  /*  REISER4_DEBUG  */
+
+static void reiser4_detach_crypto_info(struct inode * inode)
+{
+	assert("edward-1385", inode !=3D NULL);
+	assert("edward-1386", host_allows_crypto_info(inode));
+
+	if (inode_crypto_info(inode))
+		unload_crypto_info(inode);
+	set_inode_crypto_info(inode, NULL);
+}
+
+#if 0
+
+/* compare fingerprints of @child and @parent */
+static int keyid_eq(struct reiser4_crypto_info * child,
+		    struct reiser4_crypto_info * parent)
+{
+	return !memcmp(child->keyid,
+		       parent->keyid,
+		       info_digest_plugin(parent)->fipsize);
+}
+
+/* check if a crypto-stat (which is bound to @parent) can be inherited=
 */
+int can_inherit_crypto_cryptcompress(struct inode *child, struct inode=
 *parent)
+{
+	if (!need_cipher(child))
+		return 0;
+	/* the child is created */
+	if (!inode_crypto_info(child))
+		return 1;
+	/* the child is looked up */
+	if (!inode_crypto_info(parent))
+		return 0;
+	return (inode_cipher_plugin(child) =3D=3D inode_cipher_plugin(parent)=
 &&
+		inode_digest_plugin(child) =3D=3D inode_digest_plugin(parent) &&
+		inode_crypto_info(child)->keysize =3D=3D
+		inode_crypto_info(parent)->keysize &&
+		keyid_eq(inode_crypto_info(child), inode_crypto_info(parent)));
+}
+#endif
+
+/* helper functions for ->create() method of the cryptcompress plugin =
*/
+static int inode_set_crypto(struct inode * object)
+{
+	reiser4_inode * info;
+	if (!inode_crypto_info(object)) {
+		if (need_cipher(object))
+			return RETERR(-EINVAL);
+		/* the file is not to be encrypted */
+		return 0;
+	}
+	info =3D reiser4_inode_data(object);
+	info->extmask |=3D (1 << CRYPTO_STAT);
+ 	return 0;
+}
+
+static int inode_init_compression(struct inode * object)
+{
+	int result =3D 0;
+	assert("edward-1461", object !=3D NULL);
+	if (inode_compression_plugin(object)->init)
+		result =3D inode_compression_plugin(object)->init();
+	return result;
+}
+
+static int inode_check_cluster(struct inode * object)
+{
+	assert("edward-696", object !=3D NULL);
+
+	if (unlikely(inode_cluster_size(object) < PAGE_CACHE_SIZE)) {
+		warning("edward-1320", "Can not support '%s' "
+			"logical clusters (less then page size)",
+			inode_cluster_plugin(object)->h.label);
+		return RETERR(-EINVAL);
+	}
+	if (unlikely(inode_cluster_shift(object)) >=3D BITS_PER_BYTE*sizeof(i=
nt)){
+		warning("edward-1463", "Can not support '%s' "
+			"logical clusters (too big for transform)",
+			inode_cluster_plugin(object)->h.label);
+		return RETERR(-EINVAL);
+	}
+	return 0;
+}
+
+/* ->destroy_inode() method of the cryptcompress plugin */
+void destroy_inode_cryptcompress(struct inode * inode)
+{
+	assert("edward-1464", INODE_PGCOUNT(inode) =3D=3D 0);
+	reiser4_detach_crypto_info(inode);
+	return;
+}
+
+/* ->create() method of the cryptcompress plugin
+
+. install plugins
+. attach crypto info if specified
+. attach compression info if specified
+. attach cluster info
+*/
+int create_cryptcompress(struct inode *object, struct inode *parent,
+			 reiser4_object_create_data * data)
+{
+	int result;
+	reiser4_inode *info;
+
+	assert("edward-23", object !=3D NULL);
+	assert("edward-24", parent !=3D NULL);
+	assert("edward-30", data !=3D NULL);
+	assert("edward-26", reiser4_inode_get_flag(object, REISER4_NO_SD));
+	assert("edward-27", data->id =3D=3D CRYPTCOMPRESS_FILE_PLUGIN_ID);
+
+	info =3D reiser4_inode_data(object);
+
+	assert("edward-29", info !=3D NULL);
+
+	/* set file bit */
+	info->plugin_mask |=3D (1 << PSET_FILE);
+
+	/* set crypto */
+	result =3D inode_set_crypto(object);
+	if (result)
+		goto error;
+	/* set compression */
+	result =3D inode_init_compression(object);
+	if (result)
+		goto error;
+	/* set cluster */
+	result =3D inode_check_cluster(object);
+	if (result)
+		goto error;
+
+	/* save everything in disk stat-data */
+	result =3D write_sd_by_inode_common(object);
+	if (!result)
+		return 0;
+ error:
+	reiser4_detach_crypto_info(object);
+	return result;
+}
+
+/* ->open_object() method of the cryptcompress plugin */
+int open_object_cryptcompress(struct inode * inode, struct file * file=
)
+{
+	int result;
+	struct inode * parent;
+
+	assert("edward-1394", inode !=3D NULL);
+	assert("edward-1395", file !=3D NULL);
+	assert("edward-1396", file !=3D NULL);
+	assert("edward-1397", file->f_dentry->d_inode =3D=3D inode);
+	assert("edward-1398", file->f_dentry->d_parent !=3D NULL);
+	assert("edward-1399", file->f_dentry->d_parent->d_inode !=3D NULL);
+	assert("edward-698",
+	       inode_file_plugin(inode) =3D=3D
+	       file_plugin_by_id(CRYPTCOMPRESS_FILE_PLUGIN_ID));
+	result =3D inode_check_cluster(inode);
+	if (result)
+		return result;
+	result =3D inode_init_compression(inode);
+	if (result)
+		return result;
+	if (!need_cipher(inode))
+		/* the file is not to be ciphered */
+		return 0;
+	parent =3D file->f_dentry->d_parent->d_inode;
+	if (!inode_has_cipher_key(inode))
+		return RETERR(-EINVAL);
+	return 0;
+}
+
+/* returns a blocksize, the attribute of a cipher algorithm */
+static unsigned int
+cipher_blocksize(struct inode * inode)
+{
+	assert("edward-758", need_cipher(inode));
+	assert("edward-1400", inode_crypto_info(inode) !=3D NULL);
+	return crypto_blkcipher_blocksize
+		(info_get_cipher(inode_crypto_info(inode)));
+}
+
+/* returns offset translated by scale factor of the crypto-algorithm *=
/
+static loff_t inode_scaled_offset (struct inode * inode,
+				   const loff_t src_off /* input offset */)
+{
+	assert("edward-97", inode !=3D NULL);
+
+	if (!need_cipher(inode) ||
+	    src_off =3D=3D get_key_offset(reiser4_min_key()) ||
+	    src_off =3D=3D get_key_offset(reiser4_max_key()))
+		return src_off;
+
+	return inode_cipher_plugin(inode)->scale(inode,
+						 cipher_blocksize(inode),
+						 src_off);
+}
+
+/* returns disk cluster size */
+size_t inode_scaled_cluster_size(struct inode * inode)
+{
+	assert("edward-110", inode !=3D NULL);
+
+	return inode_scaled_offset(inode, inode_cluster_size(inode));
+}
+
+/* set number of cluster pages */
+static void set_cluster_nrpages(struct cluster_handle * clust,
+				struct inode *inode)
+{
+	struct reiser4_slide * win;
+
+	assert("edward-180", clust !=3D NULL);
+	assert("edward-1040", inode !=3D NULL);
+
+	clust->old_nrpages =3D size_in_pages(lbytes(clust->index, inode));
+	win =3D clust->win;
+	if (!win) {
+		clust->nr_pages =3D size_in_pages(lbytes(clust->index, inode));
+		return;
+	}
+	assert("edward-1176", clust->op !=3D LC_INVAL);
+	assert("edward-1064", win->off + win->count + win->delta !=3D 0);
+
+	if (win->stat =3D=3D HOLE_WINDOW &&
+	    win->off =3D=3D 0 && win->count =3D=3D inode_cluster_size(inode))=
 {
+		/* special case: writing a "fake" logical cluster */
+		clust->nr_pages =3D 0;
+		return;
+	}
+	clust->nr_pages =3D size_in_pages(max(win->off + win->count + win->de=
lta,
+					    lbytes(clust->index, inode)));
+	return;
+}
+
+/* plugin->key_by_inode()
+   build key of a disk cluster */
+int key_by_inode_cryptcompress(struct inode *inode, loff_t off,
+			       reiser4_key * key)
+{
+	assert("edward-64", inode !=3D 0);
+
+	if (likely(off !=3D get_key_offset(reiser4_max_key())))
+		off =3D off_to_clust_to_off(off, inode);
+	if (inode_crypto_info(inode))
+		off =3D inode_scaled_offset(inode, off);
+
+	key_by_inode_and_offset_common(inode, 0, key);
+	set_key_offset(key, (__u64)off);
+	return 0;
+}
+
+/* plugin->flow_by_inode() */
+/* flow is used to read/write disk clusters */
+int flow_by_inode_cryptcompress(struct inode *inode, const char __user=
 * buf,
+				int user,       /* 1: @buf is of user space,
+					           0: kernel space */
+				loff_t size,    /* @buf size */
+				loff_t off,     /* offset to start io from */
+				rw_op op,       /* READ or WRITE */
+				flow_t * f      /* resulting flow */)
+{
+	assert("edward-436", f !=3D NULL);
+	assert("edward-149", inode !=3D NULL);
+	assert("edward-150", inode_file_plugin(inode) !=3D NULL);
+	assert("edward-1465", user =3D=3D 0); /* we use flow to read/write
+					    disk clusters located in
+					    kernel space */
+	f->length =3D size;
+	memcpy(&f->data, &buf, sizeof(buf));
+	f->user =3D user;
+	f->op =3D op;
+
+	return key_by_inode_cryptcompress(inode, off, &f->key);
+}
+
+static int
+cryptcompress_hint_validate(hint_t * hint, const reiser4_key * key,
+			    znode_lock_mode lock_mode)
+{
+	coord_t *coord;
+
+	assert("edward-704", hint !=3D NULL);
+	assert("edward-1089", !hint_is_valid(hint));
+	assert("edward-706", hint->lh.owner =3D=3D NULL);
+
+	coord =3D &hint->ext_coord.coord;
+
+	if (!hint || !hint_is_set(hint) || hint->mode !=3D lock_mode)
+		/* hint either not set or set by different operation */
+		return RETERR(-E_REPEAT);
+
+	if (get_key_offset(key) !=3D hint->offset)
+		/* hint is set for different key */
+		return RETERR(-E_REPEAT);
+
+	assert("edward-707", reiser4_schedulable());
+
+	return reiser4_seal_validate(&hint->seal, &hint->ext_coord.coord,
+				     key, &hint->lh, lock_mode,
+				     ZNODE_LOCK_LOPRI);
+}
+
+/* reserve disk space when writing a logical cluster */
+static int reserve4cluster(struct inode *inode, struct cluster_handle =
*clust)
+{
+	int result =3D 0;
+
+	assert("edward-965", reiser4_schedulable());
+	assert("edward-439", inode !=3D NULL);
+	assert("edward-440", clust !=3D NULL);
+	assert("edward-441", clust->pages !=3D NULL);
+
+	if (clust->nr_pages =3D=3D 0) {
+		assert("edward-1152", clust->win !=3D NULL);
+		assert("edward-1153", clust->win->stat =3D=3D HOLE_WINDOW);
+		/* don't reserve disk space for fake logical cluster */
+		return 0;
+	}
+	assert("edward-442", jprivate(clust->pages[0]) !=3D NULL);
+
+	result =3D reiser4_grab_space_force(estimate_insert_cluster(inode) +
+					  estimate_update_cluster(inode),
+ 					  BA_CAN_COMMIT);
+	if (result)
+		return result;
+	clust->reserved =3D 1;
+	grabbed2cluster_reserved(estimate_insert_cluster(inode) +
+				 estimate_update_cluster(inode));
+#if REISER4_DEBUG
+	clust->reserved_prepped =3D estimate_update_cluster(inode);
+	clust->reserved_unprepped =3D estimate_insert_cluster(inode);
+#endif
+	/* there can be space grabbed by txnmgr_force_commit_all */
+	return 0;
+}
+
+/* free reserved disk space if writing a logical cluster fails */
+static void free_reserved4cluster(struct inode *inode,
+				  struct cluster_handle *ch, int count)
+{
+	assert("edward-967", ch->reserved =3D=3D 1);
+
+	cluster_reserved2free(count);
+	ch->reserved =3D 0;
+}
+
+/* The core search procedure of the cryptcompress plugin.
+   If returned value is not cbk_errored, then current znode is locked =
*/
+static int find_cluster_item(hint_t * hint,
+			     const reiser4_key * key, /* key of the item we are
+							 looking for */
+			     znode_lock_mode lock_mode /* which lock */ ,
+			     ra_info_t * ra_info, lookup_bias bias, __u32 flags)
+{
+	int result;
+	reiser4_key ikey;
+	int went_right =3D 0;
+	coord_t *coord =3D &hint->ext_coord.coord;
+	coord_t orig =3D *coord;
+
+	assert("edward-152", hint !=3D NULL);
+
+	if (!hint_is_valid(hint)) {
+		result =3D cryptcompress_hint_validate(hint, key, lock_mode);
+		if (result =3D=3D -E_REPEAT)
+			goto traverse_tree;
+		else if (result) {
+			assert("edward-1216", 0);
+			return result;
+		}
+		hint_set_valid(hint);
+	}
+	assert("edward-709", znode_is_any_locked(coord->node));
+
+	/* In-place lookup is going here, it means we just need to
+	   check if next item of the @coord match to the @keyhint) */
+
+	if (equal_to_rdk(coord->node, key)) {
+		result =3D goto_right_neighbor(coord, &hint->lh);
+		if (result =3D=3D -E_NO_NEIGHBOR) {
+			assert("edward-1217", 0);
+			return RETERR(-EIO);
+		}
+		if (result)
+			return result;
+		assert("edward-1218", equal_to_ldk(coord->node, key));
+		went_right =3D 1;
+	} else {
+		coord->item_pos++;
+		coord->unit_pos =3D 0;
+		coord->between =3D AT_UNIT;
+	}
+	result =3D zload(coord->node);
+	if (result)
+		return result;
+	assert("edward-1219", !node_is_empty(coord->node));
+
+	if (!coord_is_existing_item(coord)) {
+		zrelse(coord->node);
+		goto not_found;
+	}
+	item_key_by_coord(coord, &ikey);
+	zrelse(coord->node);
+	if (!keyeq(key, &ikey))
+		goto not_found;
+	/* Ok, item is found, update node counts */
+	if (went_right)
+		dclust_inc_extension_ncount(hint);
+	return CBK_COORD_FOUND;
+
+ not_found:
+	assert("edward-1220", coord->item_pos > 0);
+	//coord->item_pos--;
+	/* roll back */
+	*coord =3D orig;
+	ON_DEBUG(coord_update_v(coord));
+	return CBK_COORD_NOTFOUND;
+
+ traverse_tree:
+	assert("edward-713", hint->lh.owner =3D=3D NULL);
+	assert("edward-714", reiser4_schedulable());
+
+	reiser4_unset_hint(hint);
+	dclust_init_extension(hint);
+	coord_init_zero(coord);
+	result =3D coord_by_key(current_tree, key, coord, &hint->lh,
+			      lock_mode, bias, LEAF_LEVEL, LEAF_LEVEL,
+			      CBK_UNIQUE | flags, ra_info);
+	if (cbk_errored(result))
+		return result;
+	if(result =3D=3D CBK_COORD_FOUND)
+		dclust_inc_extension_ncount(hint);
+	hint_set_valid(hint);
+	return result;
+}
+
+/* This function is called by deflate[inflate] manager when
+   creating a transformed/plain stream to check if we should
+   create/cut some overhead. If this returns true, then @oh
+   contains the size of this overhead.
+ */
+static int need_cut_or_align(struct inode * inode,
+			     struct cluster_handle * ch, rw_op rw, int * oh)
+{
+	struct tfm_cluster * tc =3D &ch->tc;
+	switch (rw) {
+	case WRITE_OP: /* estimate align */
+		*oh =3D tc->len % cipher_blocksize(inode);
+		if (*oh !=3D 0)
+			return 1;
+		break;
+	case READ_OP:  /* estimate cut */
+		*oh =3D *(tfm_output_data(ch) + tc->len - 1);
+		break;
+	default:
+		impossible("edward-1401", "bad option");
+	}
+	return (tc->len !=3D tc->lsize);
+}
+
+/* create/cut an overhead of transformed/plain stream */
+static void align_or_cut_overhead(struct inode * inode,
+				  struct cluster_handle * ch, rw_op rw)
+{
+	int oh;
+	cipher_plugin * cplug =3D inode_cipher_plugin(inode);
+
+	assert("edward-1402", need_cipher(inode));
+
+	if (!need_cut_or_align(inode, ch, rw, &oh))
+		return;
+	switch (rw) {
+	case WRITE_OP: /* do align */
+		ch->tc.len +=3D
+			cplug->align_stream(tfm_input_data(ch) +
+					    ch->tc.len, ch->tc.len,
+					    cipher_blocksize(inode));
+		*(tfm_input_data(ch) + ch->tc.len - 1) =3D
+			cipher_blocksize(inode) - oh;
+		break;
+	case READ_OP: /* do cut */
+		assert("edward-1403", oh <=3D cipher_blocksize(inode));
+		ch->tc.len -=3D oh;
+		break;
+	default:
+		impossible("edward-1404", "bad option");
+	}
+	return;
+}
+
+static unsigned max_cipher_overhead(struct inode * inode)
+{
+	if (!need_cipher(inode) || !inode_cipher_plugin(inode)->align_stream)
+		return 0;
+	return cipher_blocksize(inode);
+}
+
+static int deflate_overhead(struct inode *inode)
+{
+	return (inode_compression_plugin(inode)->
+		checksum ? DC_CHECKSUM_SIZE : 0);
+}
+
+static unsigned deflate_overrun(struct inode * inode, int ilen)
+{
+	return coa_overrun(inode_compression_plugin(inode), ilen);
+}
+
+/* Estimating compressibility of a logical cluster by various
+   policies represented by compression mode plugin.
+   If this returns false, then compressor won't be called for
+   the cluster of index @index.
+*/
+static int should_compress(struct tfm_cluster * tc, cloff_t index,
+			   struct inode *inode)
+{
+	compression_plugin *cplug =3D inode_compression_plugin(inode);
+	compression_mode_plugin *mplug =3D inode_compression_mode_plugin(inod=
e);
+
+	assert("edward-1321", tc->len !=3D 0);
+	assert("edward-1322", cplug !=3D NULL);
+	assert("edward-1323", mplug !=3D NULL);
+
+	return /* estimate by size */
+		(cplug->min_size_deflate ?
+		 tc->len >=3D cplug->min_size_deflate() :
+		 1) &&
+		/* estimate by compression mode plugin */
+		(mplug->should_deflate ?
+		 mplug->should_deflate(inode, index) :
+		 1);
+}
+
+/* Evaluating results of compression transform.
+   Returns true, if we need to accept this results */
+static int save_compressed(int size_before, int size_after, struct ino=
de *inode)
+{
+	return (size_after + deflate_overhead(inode) +
+		max_cipher_overhead(inode) < size_before);
+}
+
+/* Guess result of the evaluation above */
+static int need_inflate(struct cluster_handle * ch, struct inode * ino=
de,
+			int encrypted /* is cluster encrypted */ )
+{
+	struct tfm_cluster * tc =3D &ch->tc;
+
+	assert("edward-142", tc !=3D 0);
+	assert("edward-143", inode !=3D NULL);
+
+	return tc->len <
+	    (encrypted ?
+	     inode_scaled_offset(inode, tc->lsize) :
+	     tc->lsize);
+}
+
+/* If results of compression were accepted, then we add
+   a checksum to catch possible disk cluster corruption.
+   The following is a format of the data stored in disk clusters:
+
+		   data                   This is (transformed) logical cluster.
+		   cipher_overhead        This is created by ->align() method
+                                          of cipher plugin. May be abs=
ent.
+		   checksum          (4)  This is created by ->checksum method
+                                          of compression plugin to che=
ck
+                                          integrity. May be absent.
+
+		   Crypto overhead format:
+
+		   data
+		   control_byte      (1)   contains aligned overhead size:
+		                           1 <=3D overhead <=3D cipher_blksize
+*/
+/* Append a checksum at the end of a transformed stream */
+static void dc_set_checksum(compression_plugin * cplug, struct tfm_clu=
ster * tc)
+{
+	__u32 checksum;
+
+	assert("edward-1309", tc !=3D NULL);
+	assert("edward-1310", tc->len > 0);
+	assert("edward-1311", cplug->checksum !=3D NULL);
+
+	checksum =3D cplug->checksum(tfm_stream_data(tc, OUTPUT_STREAM), tc->=
len);
+	put_unaligned(cpu_to_le32(checksum),
+		 (d32 *)(tfm_stream_data(tc, OUTPUT_STREAM) + tc->len));
+	tc->len +=3D (int)DC_CHECKSUM_SIZE;
+}
+
+/* Check a disk cluster checksum.
+   Returns 0 if checksum is correct, otherwise returns 1 */
+static int dc_check_checksum(compression_plugin * cplug, struct tfm_cl=
uster * tc)
+{
+	assert("edward-1312", tc !=3D NULL);
+	assert("edward-1313", tc->len > (int)DC_CHECKSUM_SIZE);
+	assert("edward-1314", cplug->checksum !=3D NULL);
+
+	if (cplug->checksum(tfm_stream_data(tc, INPUT_STREAM),
+			    tc->len - (int)DC_CHECKSUM_SIZE) !=3D
+	    le32_to_cpu(get_unaligned((d32 *)
+				      (tfm_stream_data(tc, INPUT_STREAM)
+				       + tc->len - (int)DC_CHECKSUM_SIZE)))) {
+		warning("edward-156",
+			"Bad disk cluster checksum %d, (should be %d) Fsck?\n",
+			(int)le32_to_cpu
+			(get_unaligned((d32 *)
+				       (tfm_stream_data(tc, INPUT_STREAM) +
+					tc->len - (int)DC_CHECKSUM_SIZE))),
+			(int)cplug->checksum
+			(tfm_stream_data(tc, INPUT_STREAM),
+			 tc->len - (int)DC_CHECKSUM_SIZE));
+		return 1;
+	}
+	tc->len -=3D (int)DC_CHECKSUM_SIZE;
+	return 0;
+}
+
+/* get input/output stream for some transform action */
+int grab_tfm_stream(struct inode * inode, struct tfm_cluster * tc,
+		    tfm_stream_id id)
+{
+	size_t size =3D inode_scaled_cluster_size(inode);
+
+	assert("edward-901", tc !=3D NULL);
+	assert("edward-1027", inode_compression_plugin(inode) !=3D NULL);
+
+	if (cluster_get_tfm_act(tc) =3D=3D TFMA_WRITE)
+		size +=3D deflate_overrun(inode, inode_cluster_size(inode));
+
+	if (!get_tfm_stream(tc, id) && id =3D=3D INPUT_STREAM)
+		alternate_streams(tc);
+	if (!get_tfm_stream(tc, id))
+		return alloc_tfm_stream(tc, size, id);
+
+	assert("edward-902", tfm_stream_is_set(tc, id));
+
+	if (tfm_stream_size(tc, id) < size)
+		return realloc_tfm_stream(tc, size, id);
+	return 0;
+}
+
+/* Common deflate manager */
+int reiser4_deflate_cluster(struct cluster_handle * clust, struct inod=
e * inode)
+{
+	int result =3D 0;
+	int compressed =3D 0;
+	int encrypted =3D 0;
+	struct tfm_cluster * tc =3D &clust->tc;
+	compression_plugin * coplug;
+
+	assert("edward-401", inode !=3D NULL);
+	assert("edward-903", tfm_stream_is_set(tc, INPUT_STREAM));
+	assert("edward-1348", cluster_get_tfm_act(tc) =3D=3D TFMA_WRITE);
+	assert("edward-498", !tfm_cluster_is_uptodate(tc));
+
+	coplug =3D inode_compression_plugin(inode);
+	if (should_compress(tc, clust->index, inode)) {
+		/* try to compress, discard bad results */
+		__u32 dst_len;
+		compression_mode_plugin * mplug =3D
+			inode_compression_mode_plugin(inode);
+		assert("edward-602", coplug !=3D NULL);
+		assert("edward-1423", coplug->compress !=3D NULL);
+
+		result =3D grab_coa(tc, coplug);
+		if (result) {
+		    warning("edward-1424",
+			    "alloc_coa failed with ret=3D%d, skipped compression",
+			    result);
+		    goto cipher;
+		}
+		result =3D grab_tfm_stream(inode, tc, OUTPUT_STREAM);
+		if (result) {
+		    warning("edward-1425",
+			 "alloc stream failed with ret=3D%d, skipped compression",
+			    result);
+		    goto cipher;
+		}
+		dst_len =3D tfm_stream_size(tc, OUTPUT_STREAM);
+		coplug->compress(get_coa(tc, coplug->h.id, tc->act),
+				 tfm_input_data(clust), tc->len,
+				 tfm_output_data(clust), &dst_len);
+		/* make sure we didn't overwrite extra bytes */
+		assert("edward-603",
+		       dst_len <=3D tfm_stream_size(tc, OUTPUT_STREAM));
+
+		/* evaluate results of compression transform */
+		if (save_compressed(tc->len, dst_len, inode)) {
+			/* good result, accept */
+			tc->len =3D dst_len;
+			if (mplug->accept_hook !=3D NULL) {
+			       result =3D mplug->accept_hook(inode, clust->index);
+			       if (result)
+				       warning("edward-1426",
+					       "accept_hook failed with ret=3D%d",
+					       result);
+			}
+			compressed =3D 1;
+		}
+		else {
+			/* bad result, discard */
+#if 0
+			if (cluster_is_complete(clust, inode))
+			      warning("edward-1496",
+				      "incompressible cluster %lu (inode %llu)",
+				      clust->index,
+				      (unsigned long long)get_inode_oid(inode));
+#endif
+			if (mplug->discard_hook !=3D NULL &&
+			    cluster_is_complete(clust, inode)) {
+				result =3D mplug->discard_hook(inode,
+							     clust->index);
+				if (result)
+				      warning("edward-1427",
+					      "discard_hook failed with ret=3D%d",
+					      result);
+			}
+		}
+	}
+ cipher:
+	if (need_cipher(inode)) {
+		cipher_plugin * ciplug;
+		struct blkcipher_desc desc;
+		struct scatterlist src;
+		struct scatterlist dst;
+
+		ciplug =3D inode_cipher_plugin(inode);
+		desc.tfm =3D info_get_cipher(inode_crypto_info(inode));
+		desc.flags =3D 0;
+		if (compressed)
+			alternate_streams(tc);
+		result =3D grab_tfm_stream(inode, tc, OUTPUT_STREAM);
+		if (result)
+			return result;
+
+		align_or_cut_overhead(inode, clust, WRITE_OP);
+		sg_init_one(&src, tfm_input_data(clust), tc->len);
+		sg_init_one(&dst, tfm_output_data(clust), tc->len);
+
+		result =3D crypto_blkcipher_encrypt(&desc, &dst, &src, tc->len);
+		if (result) {
+			warning("edward-1405",
+				"encryption failed flags=3D%x\n", desc.flags);
+			return result;
+		}
+		encrypted =3D 1;
+	}
+	if (compressed && coplug->checksum !=3D NULL)
+		dc_set_checksum(coplug, tc);
+	if (!compressed && !encrypted)
+		alternate_streams(tc);
+	return result;
+}
+
+/* Common inflate manager. */
+int reiser4_inflate_cluster(struct cluster_handle * clust, struct inod=
e * inode)
+{
+	int result =3D 0;
+	int transformed =3D 0;
+	struct tfm_cluster * tc =3D &clust->tc;
+	compression_plugin * coplug;
+
+	assert("edward-905", inode !=3D NULL);
+	assert("edward-1178", clust->dstat =3D=3D PREP_DISK_CLUSTER);
+	assert("edward-906", tfm_stream_is_set(&clust->tc, INPUT_STREAM));
+	assert("edward-1349", tc->act =3D=3D TFMA_READ);
+	assert("edward-907", !tfm_cluster_is_uptodate(tc));
+
+	/* Handle a checksum (if any) */
+	coplug =3D inode_compression_plugin(inode);
+	if (need_inflate(clust, inode, need_cipher(inode)) &&
+	    coplug->checksum !=3D NULL) {
+		result =3D dc_check_checksum(coplug, tc);
+		if (unlikely(result)) {
+			warning("edward-1460",
+				"Inode %llu: disk cluster %lu looks corrupted",
+				(unsigned long long)get_inode_oid(inode),
+				clust->index);
+			return RETERR(-EIO);
+		}
+	}
+	if (need_cipher(inode)) {
+		cipher_plugin * ciplug;
+		struct blkcipher_desc desc;
+		struct scatterlist src;
+		struct scatterlist dst;
+
+		ciplug =3D inode_cipher_plugin(inode);
+		desc.tfm =3D info_get_cipher(inode_crypto_info(inode));
+		desc.flags =3D 0;
+		result =3D grab_tfm_stream(inode, tc, OUTPUT_STREAM);
+		if (result)
+			return result;
+		assert("edward-909", tfm_cluster_is_set(tc));
+
+		sg_init_one(&src, tfm_input_data(clust), tc->len);
+		sg_init_one(&dst, tfm_output_data(clust), tc->len);
+
+		result =3D crypto_blkcipher_decrypt(&desc, &dst, &src, tc->len);
+		if (result) {
+			warning("edward-1600", "decrypt failed flags=3D%x\n",
+				desc.flags);
+			return result;
+		}
+		align_or_cut_overhead(inode, clust, READ_OP);
+		transformed =3D 1;
+	}
+	if (need_inflate(clust, inode, 0)) {
+		unsigned dst_len =3D inode_cluster_size(inode);
+		if(transformed)
+			alternate_streams(tc);
+
+		result =3D grab_tfm_stream(inode, tc, OUTPUT_STREAM);
+		if (result)
+			return result;
+		assert("edward-1305", coplug->decompress !=3D NULL);
+		assert("edward-910", tfm_cluster_is_set(tc));
+
+		coplug->decompress(get_coa(tc, coplug->h.id, tc->act),
+				   tfm_input_data(clust), tc->len,
+				   tfm_output_data(clust), &dst_len);
+		/* check length */
+		tc->len =3D dst_len;
+		assert("edward-157", dst_len =3D=3D tc->lsize);
+		transformed =3D 1;
+	}
+	if (!transformed)
+		alternate_streams(tc);
+	return result;
+}
+
+/* This is implementation of readpage method of struct
+   address_space_operations for cryptcompress plugin. */
+int readpage_cryptcompress(struct file *file, struct page *page)
+{
+	reiser4_context *ctx;
+	struct cluster_handle clust;
+	item_plugin *iplug;
+	int result;
+
+	assert("edward-88", PageLocked(page));
+	assert("vs-976", !PageUptodate(page));
+	assert("edward-89", page->mapping && page->mapping->host);
+
+	ctx =3D reiser4_init_context(page->mapping->host->i_sb);
+	if (IS_ERR(ctx)) {
+		unlock_page(page);
+		return PTR_ERR(ctx);
+	}
+	assert("edward-113",
+	       ergo(file !=3D NULL,
+		    page->mapping =3D=3D file->f_dentry->d_inode->i_mapping));
+
+	if (PageUptodate(page)) {
+		warning("edward-1338", "page is already uptodate\n");
+		unlock_page(page);
+		reiser4_exit_context(ctx);
+		return 0;
+	}
+	cluster_init_read(&clust, NULL);
+	clust.file =3D file;
+	iplug =3D item_plugin_by_id(CTAIL_ID);
+	if (!iplug->s.file.readpage) {
+		unlock_page(page);
+		put_cluster_handle(&clust);
+		reiser4_exit_context(ctx);
+		return -EINVAL;
+	}
+	result =3D iplug->s.file.readpage(&clust, page);
+
+	put_cluster_handle(&clust);
+	reiser4_txn_restart(ctx);
+	reiser4_exit_context(ctx);
+	return result;
+}
+
+/* number of pages to check in */
+static int get_new_nrpages(struct cluster_handle * clust)
+{
+	switch (clust->op) {
+	case LC_APPOV:
+		return clust->nr_pages;
+	case LC_TRUNC:
+		assert("edward-1179", clust->win !=3D NULL);
+		return size_in_pages(clust->win->off + clust->win->count);
+	default:
+		impossible("edward-1180", "bad page cluster option");
+		return 0;
+	}
+}
+
+static void set_cluster_pages_dirty(struct cluster_handle * clust,
+				    struct inode * inode)
+{
+	int i;
+	struct page *pg;
+	int nrpages =3D get_new_nrpages(clust);
+
+	for (i =3D 0; i < nrpages; i++) {
+
+		pg =3D clust->pages[i];
+		assert("edward-968", pg !=3D NULL);
+		lock_page(pg);
+		assert("edward-1065", PageUptodate(pg));
+		reiser4_set_page_dirty_internal(pg);
+		unlock_page(pg);
+		mark_page_accessed(pg);
+	}
+}
+
+/* Grab a page cluster for read/write operations.
+   Attach a jnode for write operations (when preparing for modificatio=
ns, which
+   are supposed to be committed).
+
+   We allocate only one jnode per page cluster; this jnode is binded t=
o the
+   first page of this cluster, so we have an extra-reference that will=
 be put
+   as soon as jnode is evicted from memory), other references will be =
cleaned
+   up in flush time (assume that check in page cluster was successful)=
=2E
+*/
+int grab_page_cluster(struct inode * inode,
+		      struct cluster_handle * clust, rw_op rw)
+{
+	int i;
+	int result =3D 0;
+	jnode *node =3D NULL;
+
+	assert("edward-182", clust !=3D NULL);
+	assert("edward-183", clust->pages !=3D NULL);
+	assert("edward-1466", clust->node =3D=3D NULL);
+	assert("edward-1428", inode !=3D NULL);
+	assert("edward-1429", inode->i_mapping !=3D NULL);
+	assert("edward-184", clust->nr_pages <=3D cluster_nrpages(inode));
+
+	if (clust->nr_pages =3D=3D 0)
+		return 0;
+
+	for (i =3D 0; i < clust->nr_pages; i++) {
+
+		assert("edward-1044", clust->pages[i] =3D=3D NULL);
+
+		clust->pages[i] =3D
+		       find_or_create_page(inode->i_mapping,
+					   clust_to_pg(clust->index, inode) + i,
+					   reiser4_ctx_gfp_mask_get());
+		if (!clust->pages[i]) {
+			result =3D RETERR(-ENOMEM);
+			break;
+		}
+		if (i =3D=3D 0 && rw =3D=3D WRITE_OP) {
+			node =3D jnode_of_page(clust->pages[i]);
+			if (IS_ERR(node)) {
+				result =3D PTR_ERR(node);
+				unlock_page(clust->pages[i]);
+				break;
+			}
+			JF_SET(node, JNODE_CLUSTER_PAGE);
+			assert("edward-920", jprivate(clust->pages[0]));
+		}
+		INODE_PGCOUNT_INC(inode);
+		unlock_page(clust->pages[i]);
+	}
+	if (unlikely(result)) {
+		while (i) {
+			put_cluster_page(clust->pages[--i]);
+			INODE_PGCOUNT_DEC(inode);
+		}
+		if (node && !IS_ERR(node))
+			jput(node);
+		return result;
+	}
+	clust->node =3D node;
+	return 0;
+}
+
+static void truncate_page_cluster_range(struct inode * inode,
+					struct page ** pages,
+					cloff_t index,
+					int from, int count,
+					int even_cows)
+{
+	assert("edward-1467", count > 0);
+	reiser4_invalidate_pages(inode->i_mapping,
+				 clust_to_pg(index, inode) + from,
+				 count, even_cows);
+}
+
+/* Put @count pages starting from @from offset */
+static void __put_page_cluster(int from, int count,
+			       struct page ** pages, struct inode  * inode)
+{
+	int i;
+	assert("edward-1468", pages !=3D NULL);
+	assert("edward-1469", inode !=3D NULL);
+	assert("edward-1470", from >=3D 0 && count >=3D 0);
+
+	for (i =3D 0; i < count; i++) {
+		assert("edward-1471", pages[from + i] !=3D NULL);
+		assert("edward-1472",
+		       pages[from + i]->index =3D=3D pages[from]->index + i);
+
+		put_cluster_page(pages[from + i]);
+		INODE_PGCOUNT_DEC(inode);
+	}
+}
+
+/*
+ * This is dual to grab_page_cluster,
+ * however if @rw =3D=3D WRITE_OP, then we call this function
+ * only if something is failed before checkin page cluster.
+ */
+void put_page_cluster(struct cluster_handle * clust,
+		      struct inode * inode, rw_op rw)
+{
+	assert("edward-445", clust !=3D NULL);
+	assert("edward-922", clust->pages !=3D NULL);
+	assert("edward-446",
+	       ergo(clust->nr_pages !=3D 0, clust->pages[0] !=3D NULL));
+
+	__put_page_cluster(0, clust->nr_pages, clust->pages, inode);
+	if (rw =3D=3D WRITE_OP) {
+		if (unlikely(clust->node)) {
+			assert("edward-447",
+			       clust->node =3D=3D jprivate(clust->pages[0]));
+			jput(clust->node);
+			clust->node =3D NULL;
+		}
+	}
+}
+
+#if REISER4_DEBUG
+int cryptcompress_inode_ok(struct inode *inode)
+{
+	if (!(reiser4_inode_data(inode)->plugin_mask & (1 << PSET_FILE)))
+		return 0;
+	if (!cluster_shift_ok(inode_cluster_shift(inode)))
+		return 0;
+	return 1;
+}
+
+static int window_ok(struct reiser4_slide * win, struct inode *inode)
+{
+	assert("edward-1115", win !=3D NULL);
+	assert("edward-1116", ergo(win->delta, win->stat =3D=3D HOLE_WINDOW))=
;
+
+	return (win->off !=3D inode_cluster_size(inode)) &&
+	    (win->off + win->count + win->delta <=3D inode_cluster_size(inode=
));
+}
+
+static int cluster_ok(struct cluster_handle * clust, struct inode *ino=
de)
+{
+	assert("edward-279", clust !=3D NULL);
+
+	if (!clust->pages)
+		return 0;
+	return (clust->win ? window_ok(clust->win, inode) : 1);
+}
+#if 0
+static int pages_truncate_ok(struct inode *inode, pgoff_t start)
+{
+	int found;
+	struct page * page;
+
+	found =3D find_get_pages(inode->i_mapping, start, 1, &page);
+	if (found)
+		put_cluster_page(page);
+	return !found;
+}
+#else
+#define pages_truncate_ok(inode, start) 1
+#endif
+
+static int jnode_truncate_ok(struct inode *inode, cloff_t index)
+{
+	jnode *node;
+	node =3D jlookup(current_tree, get_inode_oid(inode),
+		       clust_to_pg(index, inode));
+	if (likely(!node))
+		return 1;
+	jput(node);
+	return 0;
+}
+
+static int find_fake_appended(struct inode *inode, cloff_t * index);
+
+static int body_truncate_ok(struct inode *inode, cloff_t aidx)
+{
+	int result;
+	cloff_t raidx;
+
+	result =3D find_fake_appended(inode, &raidx);
+	return !result && (aidx =3D=3D raidx);
+}
+#endif
+
+/* guess next window stat */
+static inline window_stat next_window_stat(struct reiser4_slide * win)
+{
+	assert("edward-1130", win !=3D NULL);
+	return ((win->stat =3D=3D HOLE_WINDOW && win->delta =3D=3D 0) ?
+		HOLE_WINDOW : DATA_WINDOW);
+}
+
+/* guess and set next cluster index and window params */
+static void move_update_window(struct inode * inode,
+			       struct cluster_handle * clust,
+			       loff_t file_off, loff_t to_file)
+{
+	struct reiser4_slide * win;
+
+	assert("edward-185", clust !=3D NULL);
+	assert("edward-438", clust->pages !=3D NULL);
+	assert("edward-281", cluster_ok(clust, inode));
+
+	win =3D clust->win;
+	if (!win)
+		return;
+
+	switch (win->stat) {
+	case DATA_WINDOW:
+		/* increment */
+		clust->index++;
+		win->stat =3D DATA_WINDOW;
+		win->off =3D 0;
+		win->count =3D min((loff_t)inode_cluster_size(inode), to_file);
+		break;
+	case HOLE_WINDOW:
+		switch (next_window_stat(win)) {
+		case HOLE_WINDOW:
+			/* skip */
+			clust->index =3D off_to_clust(file_off, inode);
+			win->stat =3D HOLE_WINDOW;
+			win->off =3D 0;
+			win->count =3D off_to_cloff(file_off, inode);
+			win->delta =3D min((loff_t)(inode_cluster_size(inode) -
+						  win->count), to_file);
+			break;
+		case DATA_WINDOW:
+			/* stay */
+			win->stat =3D DATA_WINDOW;
+			/* off+count+delta=3Dinv */
+			win->off =3D win->off + win->count;
+			win->count =3D win->delta;
+			win->delta =3D 0;
+			break;
+		default:
+			impossible("edward-282", "wrong next window state");
+		}
+		break;
+	default:
+		impossible("edward-283", "wrong current window state");
+	}
+	assert("edward-1068", cluster_ok(clust, inode));
+}
+
+static int update_sd_cryptcompress(struct inode *inode)
+{
+	int result =3D 0;
+
+	assert("edward-978", reiser4_schedulable());
+
+	result =3D reiser4_grab_space_force(/* one for stat data update */
+					  estimate_update_common(inode),
+					  BA_CAN_COMMIT);
+	if (result)
+		return result;
+	inode->i_ctime =3D inode->i_mtime =3D CURRENT_TIME;
+	result =3D reiser4_update_sd(inode);
+
+	return result;
+}
+
+static void uncapture_cluster_jnode(jnode * node)
+{
+	txn_atom *atom;
+
+	assert_spin_locked(&(node->guard));
+
+	atom =3D jnode_get_atom(node);
+	if (atom =3D=3D NULL) {
+		assert("jmacd-7111", !JF_ISSET(node, JNODE_DIRTY));
+		spin_unlock_jnode(node);
+		return;
+	}
+	reiser4_uncapture_block(node);
+	spin_unlock_atom(atom);
+	jput(node);
+}
+
+static void put_found_pages(struct page **pages, int nr)
+{
+	int i;
+	for (i =3D 0; i < nr; i++) {
+		assert("edward-1045", pages[i] !=3D NULL);
+		put_cluster_page(pages[i]);
+	}
+}
+
+/*             Lifecycle of a logical cluster in the system.
+ *
+ *
+ * Logical cluster of a cryptcompress file is represented in the syste=
m by
+ * . page cluster (in memory, primary cache, contains plain text);
+ * . disk cluster (in memory, secondary cache, contains transformed te=
xt).
+ * Primary cache is to reduce number of transform operations (compress=
ion,
+ * encryption), i.e. to implement transform-caching strategy.
+ * Secondary cache is to reduce number of I/O operations, i.e. for usu=
al
+ * write-caching strategy. Page cluster is a set of pages, i.e. mappin=
g of
+ * a logical cluster to the primary cache. Disk cluster is a set of it=
ems
+ * of the same type defined by some reiser4 item plugin id.
+ *
+ *              1. Performing modifications
+ *
+ * Every modification of a cryptcompress file is considered as a set o=
f
+ * operations performed on file's logical clusters. Every such "atomic=
"
+ * modification is truncate, append and(or) overwrite some bytes of a
+ * logical cluster performed in the primary cache with the following
+ * synchronization with the secondary cache (in flush time). Disk clus=
ters,
+ * which live in the secondary cache, are supposed to be synchronized =
with
+ * disk. The mechanism of synchronization of primary and secondary cac=
hes
+ * includes so-called checkin/checkout technique described below.
+ *
+ *              2. Submitting modifications
+ *
+ * Each page cluster has associated jnode (a special in-memory header =
to
+ * keep a track of transactions in reiser4), which is attached to its =
first
+ * page when grabbing page cluster for modifications (see grab_page_cl=
uster).
+ * Submitting modifications (see checkin_logical_cluster) is going per=
 logical
+ * cluster and includes:
+ * . checkin_cluster_size;
+ * . checkin_page_cluster.
+ * checkin_cluster_size() is resolved to file size update (which compl=
etely
+ * defines new size of logical cluster (number of file's bytes in a lo=
gical
+ * cluster).
+ * checkin_page_cluster() captures jnode of a page cluster and install=
s
+ * jnode's dirty flag (if needed) to indicate that modifications are
+ * successfully checked in.
+ *
+ *              3. Checking out modifications
+ *
+ * Is going per logical cluster in flush time (see checkout_logical_cl=
uster).
+ * This is the time of synchronizing primary and secondary caches.
+ * checkout_logical_cluster() includes:
+ * . checkout_page_cluster (retrieving checked in pages).
+ * . uncapture jnode (including clear dirty flag and unlock)
+ *
+ *              4. Committing modifications
+ *
+ * Proceeding a synchronization of primary and secondary caches. When =
checking
+ * out page cluster (the phase above) pages are locked/flushed/unlocke=
d
+ * one-by-one in ascending order of their indexes to contiguous stream=
, which
+ * is supposed to be transformed (compressed, encrypted), chopped up i=
nto items
+ * and committed to disk as a disk cluster.
+ *
+ *              5. Managing page references
+ *
+ * Every checked in page have a special additional "control" reference=
,
+ * which is dropped at checkout. We need this to avoid unexpected evic=
ting
+ * pages from memory before checkout. Control references are managed s=
o
+ * they are not accumulated with every checkin:
+ *
+ *            0
+ * checkin -> 1
+ *            0 -> checkout
+ * checkin -> 1
+ * checkin -> 1
+ * checkin -> 1
+ *            0 -> checkout
+ *           ...
+ *
+ * Every page cluster has its own unique "cluster lock". Update/drop
+ * references are serialized via this lock. Number of checked in clust=
er
+ * pages is calculated by i_size under cluster lock. File size is upda=
ted
+ * at every checkin action also under cluster lock (except cases of
+ * appending/truncating fake logical clusters).
+ *
+ * Proof of correctness:
+ *
+ * Since we update file size under cluster lock, in the case of non-fa=
ke
+ * logical cluster with its lock held we do have expected number of ch=
ecked
+ * in pages. On the other hand, append/truncate of fake logical cluste=
rs
+ * doesn't change number of checked in pages of any cluster.
+ *
+ * NOTE-EDWARD: As cluster lock we use guard (spinlock_t) of its jnode=
=2E
+ * Currently, I don't see any reason to create a special lock for thos=
e
+ * needs.
+ */
+
+static inline void lock_cluster(jnode * node)
+{
+	spin_lock_jnode(node);
+}
+
+static inline void unlock_cluster(jnode * node)
+{
+	spin_unlock_jnode(node);
+}
+
+static inline void unlock_cluster_uncapture(jnode * node)
+{
+	uncapture_cluster_jnode(node);
+}
+
+/* Set new file size by window. Cluster lock is required. */
+static void checkin_file_size(struct cluster_handle * clust,
+			      struct inode * inode)
+{
+	loff_t new_size;
+	struct reiser4_slide * win;
+
+	assert("edward-1181", clust !=3D NULL);
+	assert("edward-1182", inode !=3D NULL);
+	assert("edward-1473", clust->pages !=3D NULL);
+	assert("edward-1474", clust->pages[0] !=3D NULL);
+	assert("edward-1475", jprivate(clust->pages[0]) !=3D NULL);
+	assert_spin_locked(&(jprivate(clust->pages[0])->guard));
+
+
+	win =3D clust->win;
+	assert("edward-1183", win !=3D NULL);
+
+	new_size =3D clust_to_off(clust->index, inode) + win->off;
+
+	switch (clust->op) {
+	case LC_APPOV:
+		if (new_size + win->count <=3D i_size_read(inode))
+			/* overwrite only */
+			return;
+		new_size +=3D win->count;
+		break;
+	case LC_TRUNC:
+		break;
+	default:
+		impossible("edward-1184", "bad page cluster option");
+		break;
+	}
+	inode_check_scale_nolock(inode, i_size_read(inode), new_size);
+	i_size_write(inode, new_size);
+	return;
+}
+
+static inline void checkin_cluster_size(struct cluster_handle * clust,
+					struct inode * inode)
+{
+	if (clust->win)
+		checkin_file_size(clust, inode);
+}
+
+static int checkin_page_cluster(struct cluster_handle * clust,
+				struct inode * inode)
+{
+	int result;
+	jnode * node;
+	int old_nrpages =3D clust->old_nrpages;
+	int new_nrpages =3D get_new_nrpages(clust);
+
+	node =3D clust->node;
+
+	assert("edward-221", node !=3D NULL);
+	assert("edward-971", clust->reserved =3D=3D 1);
+	assert("edward-1263",
+	       clust->reserved_prepped =3D=3D estimate_update_cluster(inode))=
;
+	assert("edward-1264", clust->reserved_unprepped =3D=3D 0);
+
+	if (JF_ISSET(node, JNODE_DIRTY)) {
+		/*
+		 * page cluster was checked in, but not yet
+		 * checked out, so release related resources
+		 */
+		free_reserved4cluster(inode, clust,
+				      estimate_update_cluster(inode));
+		__put_page_cluster(0, clust->old_nrpages,
+				   clust->pages, inode);
+	} else {
+		result =3D capture_cluster_jnode(node);
+		if (unlikely(result)) {
+			unlock_cluster(node);
+			return result;
+		}
+		jnode_make_dirty_locked(node);
+		clust->reserved =3D 0;
+	}
+	unlock_cluster(node);
+
+	if (new_nrpages < old_nrpages) {
+		/* truncate >=3D 1 complete pages */
+		__put_page_cluster(new_nrpages,
+				   old_nrpages - new_nrpages,
+				   clust->pages, inode);
+		truncate_page_cluster_range(inode,
+					    clust->pages, clust->index,
+					    new_nrpages,
+					    old_nrpages - new_nrpages,
+					    0);
+	}
+#if REISER4_DEBUG
+	clust->reserved_prepped -=3D estimate_update_cluster(inode);
+#endif
+	return 0;
+}
+
+/* Submit modifications of a logical cluster */
+static int checkin_logical_cluster(struct cluster_handle * clust,
+				   struct inode *inode)
+{
+	int result =3D 0;
+	jnode * node;
+
+	node =3D clust->node;
+
+	assert("edward-1035", node !=3D NULL);
+	assert("edward-1029", clust !=3D NULL);
+	assert("edward-1030", clust->reserved =3D=3D 1);
+	assert("edward-1031", clust->nr_pages !=3D 0);
+	assert("edward-1032", clust->pages !=3D NULL);
+	assert("edward-1033", clust->pages[0] !=3D NULL);
+	assert("edward-1446", jnode_is_cluster_page(node));
+	assert("edward-1476", node =3D=3D jprivate(clust->pages[0]));
+
+	lock_cluster(node);
+	checkin_cluster_size(clust, inode);
+	/* this will unlock cluster */
+	result =3D checkin_page_cluster(clust, inode);
+	jput(node);
+	clust->node =3D NULL;
+	return result;
+}
+
+/*
+ * Retrieve size of logical cluster that was checked in at
+ * the latest modifying session (cluster lock is required)
+ */
+static inline void checkout_cluster_size(struct cluster_handle * clust=
,
+					 struct inode * inode)
+{
+	struct tfm_cluster *tc =3D &clust->tc;
+
+	tc->len =3D lbytes(clust->index, inode);
+	assert("edward-1478", tc->len !=3D 0);
+}
+
+/*
+ * Retrieve a page cluster with the latest submitted modifications
+ * and flush its pages to previously allocated contiguous stream.
+ */
+static void checkout_page_cluster(struct cluster_handle * clust,
+				  jnode * node, struct inode * inode)
+{
+	int i;
+	int found;
+	int to_put;
+	struct tfm_cluster *tc =3D &clust->tc;
+
+	/* find and put checked in pages: cluster is locked,
+	 * so we must get expected number (to_put) of pages
+	 */
+	to_put =3D size_in_pages(lbytes(clust->index, inode));
+	found =3D find_get_pages(inode->i_mapping,
+			       clust_to_pg(clust->index, inode),
+			       to_put, clust->pages);
+	BUG_ON(found !=3D to_put);
+
+	__put_page_cluster(0, to_put, clust->pages, inode);
+	unlock_cluster_uncapture(node);
+
+	/* Flush found pages.
+	 *
+	 * Note, that we don't disable modifications while flushing,
+	 * moreover, some found pages can be truncated, as we have
+	 * released cluster lock.
+	 */
+	for (i =3D 0; i < found; i++) {
+		int in_page;
+		char * data;
+		assert("edward-1479",
+		       clust->pages[i]->index =3D=3D clust->pages[0]->index + i);
+
+		lock_page(clust->pages[i]);
+		if (!PageUptodate(clust->pages[i])) {
+			/* page was truncated */
+			assert("edward-1480",
+			       i_size_read(inode) <=3D page_offset(clust->pages[i]));
+			assert("edward-1481",
+			       clust->pages[i]->mapping !=3D inode->i_mapping);
+			unlock_page(clust->pages[i]);
+			break;
+		}
+		/* Update the number of bytes in the logical cluster,
+		 * as it could be partially truncated. Note, that only
+		 * partial truncate is possible (complete truncate can
+		 * not go here, as it is performed via ->kill_hook()
+                 * called by cut_file_items(), and the last one must
+                 * wait for znode locked with parent coord).
+		 */
+		checkout_cluster_size(clust, inode);
+
+		/* this can be zero, as new file size is
+		   checked in before truncating pages */
+		in_page =3D __mbp(tc->len, i);
+
+		data =3D kmap(clust->pages[i]);
+		memcpy(tfm_stream_data(tc, INPUT_STREAM) + pg_to_off(i),
+		       data, in_page);
+		kunmap(clust->pages[i]);
+
+		if (PageDirty(clust->pages[i]))
+			cancel_dirty_page(clust->pages[i], PAGE_CACHE_SIZE);
+
+		unlock_page(clust->pages[i]);
+
+		if (in_page < PAGE_CACHE_SIZE)
+			/* end of the file */
+			break;
+	}
+	put_found_pages(clust->pages, found); /* find_get_pages */
+	tc->lsize =3D tc->len;
+	return;
+}
+
+/* Check out modifications of a logical cluster */
+int checkout_logical_cluster(struct cluster_handle * clust,
+			     jnode * node, struct inode *inode)
+{
+	int result;
+	struct tfm_cluster *tc =3D &clust->tc;
+
+	assert("edward-980", node !=3D NULL);
+	assert("edward-236", inode !=3D NULL);
+	assert("edward-237", clust !=3D NULL);
+	assert("edward-240", !clust->win);
+	assert("edward-241", reiser4_schedulable());
+	assert("edward-718", cryptcompress_inode_ok(inode));
+
+	result =3D grab_tfm_stream(inode, tc, INPUT_STREAM);
+	if (result) {
+		warning("edward-1430", "alloc stream failed with ret=3D%d",
+			result);
+		return RETERR(-E_REPEAT);
+	}
+	lock_cluster(node);
+
+ 	if (unlikely(!JF_ISSET(node, JNODE_DIRTY))) {
+		/* race with another flush */
+ 		warning("edward-982",
+			"checking out logical cluster %lu of inode %llu: "
+			"jnode is not dirty", clust->index,
+			(unsigned long long)get_inode_oid(inode));
+ 		unlock_cluster(node);
+ 		return RETERR(-E_REPEAT);
+ 	}
+	cluster_reserved2grabbed(estimate_update_cluster(inode));
+
+	/* this will unlock cluster */
+	checkout_page_cluster(clust, node, inode);
+	return 0;
+}
+
+/* set hint for the cluster of the index @index */
+static void set_hint_cluster(struct inode *inode, hint_t * hint,
+			     cloff_t index, znode_lock_mode mode)
+{
+	reiser4_key key;
+	assert("edward-722", cryptcompress_inode_ok(inode));
+	assert("edward-723",
+	       inode_file_plugin(inode) =3D=3D
+	       file_plugin_by_id(CRYPTCOMPRESS_FILE_PLUGIN_ID));
+
+	inode_file_plugin(inode)->key_by_inode(inode,
+					       clust_to_off(index, inode),
+					       &key);
+
+	reiser4_seal_init(&hint->seal, &hint->ext_coord.coord, &key);
+	hint->offset =3D get_key_offset(&key);
+	hint->mode =3D mode;
+}
+
+void invalidate_hint_cluster(struct cluster_handle * clust)
+{
+	assert("edward-1291", clust !=3D NULL);
+	assert("edward-1292", clust->hint !=3D NULL);
+
+	done_lh(&clust->hint->lh);
+	hint_clr_valid(clust->hint);
+}
+
+static void put_hint_cluster(struct cluster_handle * clust,
+			     struct inode *inode, znode_lock_mode mode)
+{
+	assert("edward-1286", clust !=3D NULL);
+	assert("edward-1287", clust->hint !=3D NULL);
+
+	set_hint_cluster(inode, clust->hint, clust->index + 1, mode);
+	invalidate_hint_cluster(clust);
+}
+
+static int balance_dirty_page_cluster(struct cluster_handle * clust,
+				      struct inode *inode, loff_t off,
+				      loff_t to_file)
+{
+	int result;
+	struct cryptcompress_info * info;
+
+	assert("edward-724", inode !=3D NULL);
+	assert("edward-725", cryptcompress_inode_ok(inode));
+
+	/* set next window params */
+	move_update_window(inode, clust, off, to_file);
+
+	result =3D update_sd_cryptcompress(inode);
+	if (result)
+		return result;
+	assert("edward-726", clust->hint->lh.owner =3D=3D NULL);
+	info =3D cryptcompress_inode_data(inode);
+
+	mutex_unlock(&info->checkin_mutex);
+	reiser4_throttle_write(inode);
+	mutex_lock(&info->checkin_mutex);
+	return 0;
+}
+
+/* set zeroes to the page cluster, proceed it, and maybe, try to captu=
re
+   its pages */
+static int write_hole(struct inode *inode, struct cluster_handle * clu=
st,
+		      loff_t file_off, loff_t to_file)
+{
+	int result =3D 0;
+	unsigned cl_off, cl_count =3D 0;
+	unsigned to_pg, pg_off;
+	struct reiser4_slide * win;
+
+	assert("edward-190", clust !=3D NULL);
+	assert("edward-1069", clust->win !=3D NULL);
+	assert("edward-191", inode !=3D NULL);
+	assert("edward-727", cryptcompress_inode_ok(inode));
+	assert("edward-1171", clust->dstat !=3D INVAL_DISK_CLUSTER);
+	assert("edward-1154",
+	       ergo(clust->dstat !=3D FAKE_DISK_CLUSTER, clust->reserved =3D=3D=
 1));
+
+	win =3D clust->win;
+
+	assert("edward-1070", win !=3D NULL);
+	assert("edward-201", win->stat =3D=3D HOLE_WINDOW);
+	assert("edward-192", cluster_ok(clust, inode));
+
+	if (win->off =3D=3D 0 && win->count =3D=3D inode_cluster_size(inode))=
 {
+		/* This part of the hole will be represented by "fake"
+		 * logical cluster, i.e. which doesn't have appropriate
+		 * disk cluster until someone modify this logical cluster
+		 * and make it dirty.
+		 * So go forward here..
+		 */
+		move_update_window(inode, clust, file_off, to_file);
+		return 0;
+	}
+	cl_count =3D win->count;	/* number of zeroes to write */
+	cl_off =3D win->off;
+	pg_off =3D off_to_pgoff(win->off);
+
+	while (cl_count) {
+		struct page *page;
+		page =3D clust->pages[off_to_pg(cl_off)];
+
+		assert("edward-284", page !=3D NULL);
+
+		to_pg =3D min((typeof(pg_off))PAGE_CACHE_SIZE - pg_off, cl_count);
+		lock_page(page);
+		zero_user(page, pg_off, to_pg);
+		SetPageUptodate(page);
+		reiser4_set_page_dirty_internal(page);
+		mark_page_accessed(page);
+		unlock_page(page);
+
+		cl_off +=3D to_pg;
+		cl_count -=3D to_pg;
+		pg_off =3D 0;
+	}
+	if (!win->delta) {
+		/* only zeroes in this window, try to capture
+		 */
+		result =3D checkin_logical_cluster(clust, inode);
+		if (result)
+			return result;
+		put_hint_cluster(clust, inode, ZNODE_WRITE_LOCK);
+		result =3D
+		    balance_dirty_page_cluster(clust, inode, file_off, to_file);
+	} else
+		move_update_window(inode, clust, file_off, to_file);
+	return result;
+}
+
+/*
+  The main disk search procedure for cryptcompress plugin, which
+  . scans all items of disk cluster with the lock mode @mode
+  . maybe reads each one (if @read)
+  . maybe makes its znode dirty (if write lock mode was specified)
+
+  NOTE-EDWARD: Callers should handle the case when disk cluster
+  is incomplete (-EIO)
+*/
+int find_disk_cluster(struct cluster_handle * clust,
+		      struct inode *inode, int read, znode_lock_mode mode)
+{
+	flow_t f;
+	hint_t *hint;
+	int result =3D 0;
+	int was_grabbed;
+	ra_info_t ra_info;
+	file_plugin *fplug;
+	item_plugin *iplug;
+	struct tfm_cluster *tc;
+	struct cryptcompress_info * info;
+
+	assert("edward-138", clust !=3D NULL);
+	assert("edward-728", clust->hint !=3D NULL);
+	assert("edward-226", reiser4_schedulable());
+	assert("edward-137", inode !=3D NULL);
+	assert("edward-729", cryptcompress_inode_ok(inode));
+
+	hint =3D clust->hint;
+	fplug =3D inode_file_plugin(inode);
+	was_grabbed =3D get_current_context()->grabbed_blocks;
+	info =3D cryptcompress_inode_data(inode);
+	tc =3D &clust->tc;
+
+	assert("edward-462", !tfm_cluster_is_uptodate(tc));
+	assert("edward-461", ergo(read, tfm_stream_is_set(tc, INPUT_STREAM)))=
;
+
+	dclust_init_extension(hint);
+
+	/* set key of the first disk cluster item */
+	fplug->flow_by_inode(inode,
+			     (read ? (char __user *)tfm_stream_data(tc, INPUT_STREAM) : NUL=
L),
+			     0 /* kernel space */ ,
+			     inode_scaled_cluster_size(inode),
+			     clust_to_off(clust->index, inode), READ_OP, &f);
+	if (mode =3D=3D ZNODE_WRITE_LOCK) {
+		/* reserve for flush to make dirty all the leaf nodes
+		   which contain disk cluster */
+		result =3D
+		    reiser4_grab_space_force(estimate_dirty_cluster(inode),
+					     BA_CAN_COMMIT);
+		if (result)
+			goto out;
+	}
+
+	ra_info.key_to_stop =3D f.key;
+	set_key_offset(&ra_info.key_to_stop, get_key_offset(reiser4_max_key()=
));
+
+	while (f.length) {
+		result =3D find_cluster_item(hint, &f.key, mode,
+					   NULL, FIND_EXACT,
+					   (mode =3D=3D ZNODE_WRITE_LOCK ?
+					    CBK_FOR_INSERT : 0));
+		switch (result) {
+		case CBK_COORD_NOTFOUND:
+			result =3D 0;
+			if (inode_scaled_offset
+			    (inode, clust_to_off(clust->index, inode)) =3D=3D
+			    get_key_offset(&f.key)) {
+				/* first item not found, this is treated
+				   as disk cluster is absent */
+				clust->dstat =3D FAKE_DISK_CLUSTER;
+				goto out;
+			}
+			/* we are outside the cluster, stop search here */
+			assert("edward-146",
+			       f.length !=3D inode_scaled_cluster_size(inode));
+			goto ok;
+		case CBK_COORD_FOUND:
+			assert("edward-148",
+			       hint->ext_coord.coord.between =3D=3D AT_UNIT);
+			assert("edward-460",
+			       hint->ext_coord.coord.unit_pos =3D=3D 0);
+
+			coord_clear_iplug(&hint->ext_coord.coord);
+			result =3D zload_ra(hint->ext_coord.coord.node, &ra_info);
+			if (unlikely(result))
+				goto out;
+			iplug =3D item_plugin_by_coord(&hint->ext_coord.coord);
+			assert("edward-147",
+			       item_id_by_coord(&hint->ext_coord.coord) =3D=3D
+			       CTAIL_ID);
+
+			result =3D iplug->s.file.read(NULL, &f, hint);
+			if (result) {
+				zrelse(hint->ext_coord.coord.node);
+				goto out;
+			}
+			if (mode =3D=3D ZNODE_WRITE_LOCK) {
+				/* Don't make dirty more nodes then it was
+				   estimated (see comments before
+				   estimate_dirty_cluster). Missed nodes will be
+				   read up in flush time if they are evicted from
+				   memory */
+				if (dclust_get_extension_ncount(hint) <=3D
+				    estimate_dirty_cluster(inode))
+				   znode_make_dirty(hint->ext_coord.coord.node);
+
+				znode_set_convertible(hint->ext_coord.coord.
+						      node);
+			}
+			zrelse(hint->ext_coord.coord.node);
+			break;
+		default:
+			goto out;
+		}
+	}
+ ok:
+	/* at least one item was found  */
+	/* NOTE-EDWARD: Callers should handle the case
+	   when disk cluster is incomplete (-EIO) */
+	tc->len =3D inode_scaled_cluster_size(inode) - f.length;
+	tc->lsize =3D lbytes(clust->index, inode);
+	assert("edward-1196", tc->len > 0);
+	assert("edward-1406", tc->lsize > 0);
+
+	if (hint_is_unprepped_dclust(clust->hint)) {
+		clust->dstat =3D UNPR_DISK_CLUSTER;
+	} else if (clust->index =3D=3D info->trunc_index) {
+		clust->dstat =3D TRNC_DISK_CLUSTER;
+	} else {
+		clust->dstat =3D PREP_DISK_CLUSTER;
+		dclust_set_extension_dsize(clust->hint, tc->len);
+	}
+ out:
+	assert("edward-1339",
+	       get_current_context()->grabbed_blocks >=3D was_grabbed);
+	grabbed2free(get_current_context(),
+		     get_current_super_private(),
+		     get_current_context()->grabbed_blocks - was_grabbed);
+	return result;
+}
+
+int get_disk_cluster_locked(struct cluster_handle * clust, struct inod=
e *inode,
+			    znode_lock_mode lock_mode)
+{
+	reiser4_key key;
+	ra_info_t ra_info;
+
+	assert("edward-730", reiser4_schedulable());
+	assert("edward-731", clust !=3D NULL);
+	assert("edward-732", inode !=3D NULL);
+
+	if (hint_is_valid(clust->hint)) {
+		assert("edward-1293", clust->dstat !=3D INVAL_DISK_CLUSTER);
+		assert("edward-1294",
+		       znode_is_write_locked(clust->hint->lh.node));
+		/* already have a valid locked position */
+		return (clust->dstat =3D=3D
+			FAKE_DISK_CLUSTER ? CBK_COORD_NOTFOUND :
+			CBK_COORD_FOUND);
+	}
+	key_by_inode_cryptcompress(inode, clust_to_off(clust->index, inode),
+				   &key);
+	ra_info.key_to_stop =3D key;
+	set_key_offset(&ra_info.key_to_stop, get_key_offset(reiser4_max_key()=
));
+
+	return find_cluster_item(clust->hint, &key, lock_mode, NULL, FIND_EXA=
CT,
+				 CBK_FOR_INSERT);
+}
+
+/* Read needed cluster pages before modifying.
+   If success, @clust->hint contains locked position in the tree.
+   Also:
+   . find and set disk cluster state
+   . make disk cluster dirty if its state is not FAKE_DISK_CLUSTER.
+*/
+static int read_some_cluster_pages(struct inode * inode,
+				   struct cluster_handle * clust)
+{
+	int i;
+	int result =3D 0;
+	item_plugin *iplug;
+	struct reiser4_slide * win =3D clust->win;
+	znode_lock_mode mode =3D ZNODE_WRITE_LOCK;
+
+	iplug =3D item_plugin_by_id(CTAIL_ID);
+
+	assert("edward-924", !tfm_cluster_is_uptodate(&clust->tc));
+
+#if REISER4_DEBUG
+	if (clust->nr_pages =3D=3D 0) {
+		/* start write hole from fake disk cluster */
+		assert("edward-1117", win !=3D NULL);
+		assert("edward-1118", win->stat =3D=3D HOLE_WINDOW);
+		assert("edward-1119", new_logical_cluster(clust, inode));
+	}
+#endif
+	if (new_logical_cluster(clust, inode)) {
+		/*
+		   new page cluster is about to be written, nothing to read,
+		 */
+		assert("edward-734", reiser4_schedulable());
+		assert("edward-735", clust->hint->lh.owner =3D=3D NULL);
+
+		if (clust->nr_pages) {
+			int off;
+			struct page * pg;
+			assert("edward-1419", clust->pages !=3D NULL);
+			pg =3D clust->pages[clust->nr_pages - 1];
+			assert("edward-1420", pg !=3D NULL);
+			off =3D off_to_pgoff(win->off+win->count+win->delta);
+			if (off) {
+				lock_page(pg);
+				zero_user_segment(pg, off, PAGE_CACHE_SIZE);
+				unlock_page(pg);
+			}
+		}
+		clust->dstat =3D FAKE_DISK_CLUSTER;
+		return 0;
+	}
+	/*
+	   Here we should search for disk cluster to figure out its real stat=
e.
+	   Also there is one more important reason to do disk search: we need
+	   to make disk cluster _dirty_ if it exists
+	 */
+
+	/* if windows is specified, read the only pages
+	   that will be modified partially */
+
+	for (i =3D 0; i < clust->nr_pages; i++) {
+		struct page *pg =3D clust->pages[i];
+
+		lock_page(pg);
+		if (PageUptodate(pg)) {
+			unlock_page(pg);
+			continue;
+		}
+		unlock_page(pg);
+
+		if (win &&
+		    i >=3D size_in_pages(win->off) &&
+		    i < off_to_pg(win->off + win->count + win->delta))
+			/* page will be completely overwritten */
+			continue;
+
+		if (win && (i =3D=3D clust->nr_pages - 1) &&
+		    /* the last page is
+		       partially modified,
+		       not uptodate .. */
+		    (size_in_pages(i_size_read(inode)) <=3D pg->index)) {
+			/* .. and appended,
+			   so set zeroes to the rest */
+			int offset;
+			lock_page(pg);
+			assert("edward-1260",
+			       size_in_pages(win->off + win->count +
+					     win->delta) - 1 =3D=3D i);
+
+			offset =3D
+			    off_to_pgoff(win->off + win->count + win->delta);
+			zero_user_segment(pg, offset, PAGE_CACHE_SIZE);
+			unlock_page(pg);
+			/* still not uptodate */
+			break;
+		}
+		lock_page(pg);
+		result =3D do_readpage_ctail(inode, clust, pg, mode);
+
+		assert("edward-1526", ergo(!result, PageUptodate(pg)));
+		unlock_page(pg);
+		if (result) {
+			warning("edward-219", "do_readpage_ctail failed");
+			goto out;
+		}
+	}
+	if (!tfm_cluster_is_uptodate(&clust->tc)) {
+		/* disk cluster unclaimed, but we need to make its znodes dirty
+		 * to make flush update convert its content
+		 */
+		result =3D find_disk_cluster(clust, inode,
+					   0 /* do not read items */,
+					   mode);
+	}
+ out:
+	tfm_cluster_clr_uptodate(&clust->tc);
+	return result;
+}
+
+static int should_create_unprepped_cluster(struct cluster_handle * clu=
st,
+					   struct inode * inode)
+{
+	assert("edward-737", clust !=3D NULL);
+
+	switch (clust->dstat) {
+	case PREP_DISK_CLUSTER:
+	case UNPR_DISK_CLUSTER:
+		return 0;
+	case FAKE_DISK_CLUSTER:
+		if (clust->win &&
+		    clust->win->stat =3D=3D HOLE_WINDOW && clust->nr_pages =3D=3D 0)=
 {
+			assert("edward-1172",
+			       new_logical_cluster(clust, inode));
+			return 0;
+		}
+		return 1;
+	default:
+		impossible("edward-1173", "bad disk cluster state");
+		return 0;
+	}
+}
+
+static int cryptcompress_make_unprepped_cluster(struct cluster_handle =
* clust,
+						struct inode *inode)
+{
+	int result;
+
+	assert("edward-1123", reiser4_schedulable());
+	assert("edward-737", clust !=3D NULL);
+	assert("edward-738", inode !=3D NULL);
+	assert("edward-739", cryptcompress_inode_ok(inode));
+	assert("edward-1053", clust->hint !=3D NULL);
+
+ 	if (!should_create_unprepped_cluster(clust, inode)) {
+ 		if (clust->reserved) {
+ 			cluster_reserved2free(estimate_insert_cluster(inode));
+#if REISER4_DEBUG
+ 			assert("edward-1267",
+ 			       clust->reserved_unprepped =3D=3D
+ 			       estimate_insert_cluster(inode));
+ 			clust->reserved_unprepped -=3D
+ 				estimate_insert_cluster(inode);
+#endif
+		}
+		return 0;
+	}
+ 	assert("edward-1268", clust->reserved);
+ 	cluster_reserved2grabbed(estimate_insert_cluster(inode));
+#if REISER4_DEBUG
+ 	assert("edward-1441",
+ 	       clust->reserved_unprepped =3D=3D estimate_insert_cluster(inod=
e));
+ 	clust->reserved_unprepped -=3D estimate_insert_cluster(inode);
+#endif
+	result =3D ctail_insert_unprepped_cluster(clust, inode);
+	if (result)
+		return result;
+
+	inode_add_bytes(inode, inode_cluster_size(inode));
+
+	assert("edward-743", cryptcompress_inode_ok(inode));
+	assert("edward-744", znode_is_write_locked(clust->hint->lh.node));
+
+	clust->dstat =3D UNPR_DISK_CLUSTER;
+	return 0;
+}
+
+/* . Grab page cluster for read, write, setattr, etc. operations;
+ * . Truncate its complete pages, if needed;
+ */
+int prepare_page_cluster(struct inode * inode, struct cluster_handle *=
 clust,
+			 rw_op rw)
+{
+	assert("edward-177", inode !=3D NULL);
+	assert("edward-741", cryptcompress_inode_ok(inode));
+	assert("edward-740", clust->pages !=3D NULL);
+
+	set_cluster_nrpages(clust, inode);
+	reset_cluster_pgset(clust, cluster_nrpages(inode));
+	return grab_page_cluster(inode, clust, rw);
+}
+
+/* Truncate complete page cluster of index @index.
+ * This is called by ->kill_hook() method of item
+ * plugin when deleting a disk cluster of such index.
+ */
+void truncate_complete_page_cluster(struct inode *inode, cloff_t index=
,
+				    int even_cows)
+{
+	int found;
+	int nr_pages;
+	jnode *node;
+	struct page *pages[MAX_CLUSTER_NRPAGES];
+
+	node =3D jlookup(current_tree, get_inode_oid(inode),
+		       clust_to_pg(index, inode));
+	nr_pages =3D size_in_pages(lbytes(index, inode));
+	assert("edward-1483", nr_pages !=3D 0);
+	if (!node)
+		goto truncate;
+	found =3D find_get_pages(inode->i_mapping,
+			       clust_to_pg(index, inode),
+			       cluster_nrpages(inode), pages);
+	if (!found) {
+		assert("edward-1484", jnode_truncate_ok(inode, index));
+		return;
+	}
+	lock_cluster(node);
+
+	if (reiser4_inode_get_flag(inode, REISER4_FILE_CONV_IN_PROGRESS)
+	    && index =3D=3D 0)
+		/* converting to unix_file is in progress */
+		JF_CLR(node, JNODE_CLUSTER_PAGE);
+	if (JF_ISSET(node, JNODE_DIRTY)) {
+		/*
+		 * @nr_pages were checked in, but not yet checked out -
+		 * we need to release them. (also there can be pages
+		 * attached to page cache by read(), etc. - don't take
+		 * them into account).
+		 */
+		assert("edward-1198", found >=3D nr_pages);
+
+		/* free disk space grabbed for disk cluster converting */
+		cluster_reserved2grabbed(estimate_update_cluster(inode));
+		grabbed2free(get_current_context(),
+			     get_current_super_private(),
+			     estimate_update_cluster(inode));
+		__put_page_cluster(0, nr_pages, pages, inode);
+
+		/* This will clear dirty bit, uncapture and unlock jnode */
+		unlock_cluster_uncapture(node);
+	} else
+		unlock_cluster(node);
+	jput(node);                         /* jlookup */
+	put_found_pages(pages, found); /* find_get_pages */
+ truncate:
+	if (reiser4_inode_get_flag(inode, REISER4_FILE_CONV_IN_PROGRESS) &&
+	    index =3D=3D 0)
+		return;
+	truncate_page_cluster_range(inode, pages, index, 0,
+				    cluster_nrpages(inode),
+				    even_cows);
+	assert("edward-1201",
+	       ergo(!reiser4_inode_get_flag(inode,
+					    REISER4_FILE_CONV_IN_PROGRESS),
+		    jnode_truncate_ok(inode, index)));
+	return;
+}
+
+/*
+ * Set cluster handle @clust of a logical cluster before
+ * modifications which are supposed to be committed.
+ *
+ * . grab cluster pages;
+ * . reserve disk space;
+ * . maybe read pages from disk and set the disk cluster dirty;
+ * . maybe write hole and check in (partially zeroed) logical cluster;
+ * . create 'unprepped' disk cluster for new or fake logical one.
+ */
+static int prepare_logical_cluster(struct inode *inode,
+				   loff_t file_off, /* write position
+						       in the file */
+				   loff_t to_file, /* bytes of users data
+						      to write to the file */
+				   struct cluster_handle * clust,
+				   logical_cluster_op op)
+{
+	int result =3D 0;
+	struct reiser4_slide * win =3D clust->win;
+
+	reset_cluster_params(clust);
+	cluster_set_tfm_act(&clust->tc, TFMA_READ);
+#if REISER4_DEBUG
+	clust->ctx =3D get_current_context();
+#endif
+	assert("edward-1190", op !=3D LC_INVAL);
+
+	clust->op =3D op;
+
+	result =3D prepare_page_cluster(inode, clust, WRITE_OP);
+	if (result)
+		return result;
+	assert("edward-1447",
+	       ergo(clust->nr_pages !=3D 0, jprivate(clust->pages[0])));
+	assert("edward-1448",
+	       ergo(clust->nr_pages !=3D 0,
+		    jnode_is_cluster_page(jprivate(clust->pages[0]))));
+
+	result =3D reserve4cluster(inode, clust);
+	if (result)
+		goto err1;
+	result =3D read_some_cluster_pages(inode, clust);
+	if (result) {
+		free_reserved4cluster(inode,
+				      clust,
+				      estimate_update_cluster(inode) +
+				      estimate_insert_cluster(inode));
+		goto err1;
+	}
+	assert("edward-1124", clust->dstat !=3D INVAL_DISK_CLUSTER);
+
+	result =3D cryptcompress_make_unprepped_cluster(clust, inode);
+	if (result)
+		goto err2;
+	if (win && win->stat =3D=3D HOLE_WINDOW) {
+		result =3D write_hole(inode, clust, file_off, to_file);
+		if (result)
+			goto err2;
+	}
+	return 0;
+ err2:
+	free_reserved4cluster(inode, clust,
+			      estimate_update_cluster(inode));
+ err1:
+	put_page_cluster(clust, inode, WRITE_OP);
+	assert("edward-1125", result =3D=3D -ENOSPC);
+	return result;
+}
+
+/* set window by two offsets */
+static void set_window(struct cluster_handle * clust,
+		       struct reiser4_slide * win, struct inode *inode,
+		       loff_t o1, loff_t o2)
+{
+	assert("edward-295", clust !=3D NULL);
+	assert("edward-296", inode !=3D NULL);
+	assert("edward-1071", win !=3D NULL);
+	assert("edward-297", o1 <=3D o2);
+
+	clust->index =3D off_to_clust(o1, inode);
+
+	win->off =3D off_to_cloff(o1, inode);
+	win->count =3D min((loff_t)(inode_cluster_size(inode) - win->off),
+			 o2 - o1);
+	win->delta =3D 0;
+
+	clust->win =3D win;
+}
+
+static int set_cluster_by_window(struct inode *inode,
+				 struct cluster_handle * clust,
+				 struct reiser4_slide * win, size_t length,
+				 loff_t file_off)
+{
+	int result;
+
+	assert("edward-197", clust !=3D NULL);
+	assert("edward-1072", win !=3D NULL);
+	assert("edward-198", inode !=3D NULL);
+
+	result =3D alloc_cluster_pgset(clust, cluster_nrpages(inode));
+	if (result)
+		return result;
+
+	if (file_off > i_size_read(inode)) {
+		/* Uhmm, hole in cryptcompress file... */
+		loff_t hole_size;
+		hole_size =3D file_off - inode->i_size;
+
+		set_window(clust, win, inode, inode->i_size, file_off);
+		win->stat =3D HOLE_WINDOW;
+		if (win->off + hole_size < inode_cluster_size(inode))
+			/* there is also user's data to append to the hole */
+			win->delta =3D min(inode_cluster_size(inode) -
+					 (win->off + win->count), length);
+		return 0;
+	}
+	set_window(clust, win, inode, file_off, file_off + length);
+	win->stat =3D DATA_WINDOW;
+	return 0;
+}
+
+int set_cluster_by_page(struct cluster_handle * clust, struct page * p=
age,
+			int count)
+{
+	int result =3D 0;
+	int (*setting_actor)(struct cluster_handle * clust, int count);
+
+	assert("edward-1358", clust !=3D NULL);
+	assert("edward-1359", page !=3D NULL);
+	assert("edward-1360", page->mapping !=3D NULL);
+	assert("edward-1361", page->mapping->host !=3D NULL);
+
+	setting_actor =3D
+		(clust->pages ? reset_cluster_pgset : alloc_cluster_pgset);
+	result =3D setting_actor(clust, count);
+	clust->index =3D pg_to_clust(page->index, page->mapping->host);
+	return result;
+}
+
+/* reset all the params that not get updated */
+void reset_cluster_params(struct cluster_handle * clust)
+{
+	assert("edward-197", clust !=3D NULL);
+
+	clust->dstat =3D INVAL_DISK_CLUSTER;
+	clust->tc.uptodate =3D 0;
+	clust->tc.len =3D 0;
+}
+
+static loff_t do_write_cryptcompress(struct file *file, struct inode *=
inode,
+				     const char __user *buf, size_t to_write,
+				     loff_t pos, int *conv_occured)
+{
+	int i;
+	hint_t *hint;
+	int result =3D 0;
+	size_t count;
+	struct reiser4_slide win;
+	struct cluster_handle clust;
+	struct cryptcompress_info * info;
+
+	assert("edward-161", reiser4_schedulable());
+	assert("edward-748", cryptcompress_inode_ok(inode));
+	assert("edward-159", current_blocksize =3D=3D PAGE_CACHE_SIZE);
+	assert("edward-1274", get_current_context()->grabbed_blocks =3D=3D 0)=
;
+
+	hint =3D kmalloc(sizeof(*hint), reiser4_ctx_gfp_mask_get());
+	if (hint =3D=3D NULL)
+		return RETERR(-ENOMEM);
+
+	result =3D load_file_hint(file, hint);
+	if (result) {
+		kfree(hint);
+		return result;
+	}
+	count =3D to_write;
+
+	reiser4_slide_init(&win);
+	cluster_init_read(&clust, &win);
+	clust.hint =3D hint;
+	info =3D cryptcompress_inode_data(inode);
+
+	mutex_lock(&info->checkin_mutex);
+
+	result =3D set_cluster_by_window(inode, &clust, &win, to_write, pos);
+	if (result)
+		goto out;
+
+	if (next_window_stat(&win) =3D=3D HOLE_WINDOW) {
+		/* write hole in this iteration
+		   separated from the loop below */
+		result =3D write_conversion_hook(file, inode,
+					       pos,
+					       &clust,
+					       NULL);
+		if (result)
+			goto out;
+		result =3D prepare_logical_cluster(inode, pos, count, &clust,
+						 LC_APPOV);
+		if (result)
+			goto out;
+	}
+	do {
+		const char __user * src;
+		unsigned page_off, to_page;
+
+		assert("edward-750", reiser4_schedulable());
+
+		result =3D write_conversion_hook(file, inode,
+					       pos + to_write - count,
+					       &clust,
+					       conv_occured);
+		if (result || *conv_occured)
+			goto out;
+		result =3D prepare_logical_cluster(inode, pos, count, &clust,
+						 LC_APPOV);
+		if (result)
+			goto out;
+
+		assert("edward-751", cryptcompress_inode_ok(inode));
+		assert("edward-204", win.stat =3D=3D DATA_WINDOW);
+		assert("edward-1288", hint_is_valid(clust.hint));
+		assert("edward-752",
+		       znode_is_write_locked(hint->ext_coord.coord.node));
+		put_hint_cluster(&clust, inode, ZNODE_WRITE_LOCK);
+
+		/* set write position in page */
+		page_off =3D off_to_pgoff(win.off);
+
+		/* copy user's data to cluster pages */
+		for (i =3D off_to_pg(win.off), src =3D buf;
+		     i < size_in_pages(win.off + win.count);
+		     i++, src +=3D to_page) {
+			to_page =3D __mbp(win.off + win.count, i) - page_off;
+			assert("edward-1039",
+			       page_off + to_page <=3D PAGE_CACHE_SIZE);
+			assert("edward-287", clust.pages[i] !=3D NULL);
+
+			fault_in_pages_readable(src, to_page);
+
+			lock_page(clust.pages[i]);
+			result =3D
+			    __copy_from_user((char *)kmap(clust.pages[i]) +
+					     page_off, src, to_page);
+			kunmap(clust.pages[i]);
+			if (unlikely(result)) {
+				unlock_page(clust.pages[i]);
+				result =3D -EFAULT;
+				goto err2;
+			}
+			SetPageUptodate(clust.pages[i]);
+			reiser4_set_page_dirty_internal(clust.pages[i]);
+			flush_dcache_page(clust.pages[i]);
+			mark_page_accessed(clust.pages[i]);
+			unlock_page(clust.pages[i]);
+			page_off =3D 0;
+		}
+		assert("edward-753", cryptcompress_inode_ok(inode));
+
+		result =3D checkin_logical_cluster(&clust, inode);
+		if (result)
+			goto err2;
+
+		buf   +=3D win.count;
+		count -=3D win.count;
+
+		result =3D balance_dirty_page_cluster(&clust, inode, 0, count);
+		if (result)
+			goto err1;
+		assert("edward-755", hint->lh.owner =3D=3D NULL);
+		reset_cluster_params(&clust);
+		continue;
+	err2:
+		put_page_cluster(&clust, inode, WRITE_OP);
+	err1:
+		if (clust.reserved)
+			free_reserved4cluster(inode,
+					      &clust,
+					      estimate_update_cluster(inode));
+		break;
+	} while (count);
+ out:
+	/*
+	 * NOTE: at this point file may have
+	 * another (unix-file) plugin installed
+	 */
+	done_lh(&hint->lh);
+	if (result =3D=3D -EEXIST)
+		warning("edward-1407", "write returns EEXIST!\n");
+
+	put_cluster_handle(&clust);
+	save_file_hint(file, hint);
+	kfree(hint);
+	/*
+	 * don't release cryptcompress-specific
+	 * checkin_mutex, if conversion occured
+	 */
+	if (*conv_occured =3D=3D 0)
+		mutex_unlock(&info->checkin_mutex);
+	if (buf) {
+		/* if nothing were written - there must be an error */
+		assert("edward-195", ergo((to_write =3D=3D count),
+					  (result < 0 || *conv_occured)));
+		return (to_write - count) ? (to_write - count) : result;
+	}
+	return result;
+}
+
+/**
+ * write_cryptcompress - write of struct file_operations
+ * @file: file to write to
+ * @buf: address of user-space buffer
+ * @read_amount: number of bytes to write
+ * @off: position in file to write to
+ *
+ * This is implementation of vfs's write method of struct file_operati=
ons for
+ * cryptcompress plugin.
+ */
+ssize_t write_cryptcompress(struct file *file, const char __user *buf,
+			    size_t count, loff_t *off, int *conv)
+{
+	ssize_t result;
+	struct inode *inode;
+	reiser4_context *ctx;
+  	loff_t pos =3D *off;
+  	struct cryptcompress_info *info;
+
+  	assert("edward-1449", *conv =3D=3D 0);
+
+	inode =3D file->f_dentry->d_inode;
+	assert("edward-196", cryptcompress_inode_ok(inode));
+
+	info =3D cryptcompress_inode_data(inode);
+
+	ctx =3D reiser4_init_context(inode->i_sb);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+ 	mutex_lock(&inode->i_mutex);
+
+	result =3D generic_write_checks(file, &pos, &count, 0);
+  	if (unlikely(result !=3D 0))
+		goto out;
+  	if (unlikely(count =3D=3D 0))
+		goto out;
+	result =3D remove_suid(file->f_dentry);
+	if (unlikely(result !=3D 0))
+		goto out;
+	/* remove_suid might create a transaction */
+	reiser4_txn_restart(ctx);
+
+	result =3D do_write_cryptcompress(file, inode, buf, count, pos, conv)=
;
+
+  	if (result < 0)
+		goto out;
+  	/* update position in a file */
+  	*off =3D pos + result;
+ out:
+	mutex_unlock(&inode->i_mutex);
+
+	context_set_commit_async(ctx);
+	reiser4_exit_context(ctx);
+	return result;
+}
+
+int readpages_cryptcompress(struct file *file, struct address_space *m=
apping,
+			    struct list_head *pages, unsigned nr_pages)
+{
+	reiser4_context * ctx;
+	int ret;
+
+	ctx =3D reiser4_init_context(mapping->host->i_sb);
+	if (IS_ERR(ctx)) {
+		ret =3D PTR_ERR(ctx);
+		goto err;
+	}
+	/* cryptcompress file can be built of ctail items only */
+	ret =3D readpages_ctail(file, mapping, pages);
+	reiser4_txn_restart(ctx);
+	reiser4_exit_context(ctx);
+	if (ret) {
+err:
+		put_pages_list(pages);
+	}
+	return ret;
+}
+
+static reiser4_block_nr cryptcompress_estimate_read(struct inode *inod=
e)
+{
+	/* reserve one block to update stat data item */
+	assert("edward-1193",
+	       inode_file_plugin(inode)->estimate.update =3D=3D
+	       estimate_update_common);
+	return estimate_update_common(inode);
+}
+
+/**
+ * read_cryptcompress - read of struct file_operations
+ * @file: file to read from
+ * @buf: address of user-space buffer
+ * @read_amount: number of bytes to read
+ * @off: position in file to read from
+ *
+ * This is implementation of vfs's read method of struct file_operatio=
ns for
+ * cryptcompress plugin.
+ */
+ssize_t read_cryptcompress(struct file * file, char __user *buf, size_=
t size,
+			   loff_t * off)
+{
+	ssize_t result;
+	struct inode *inode;
+	reiser4_context *ctx;
+	struct cryptcompress_info *info;
+	reiser4_block_nr needed;
+
+	inode =3D file->f_dentry->d_inode;
+	assert("edward-1194", !reiser4_inode_get_flag(inode, REISER4_NO_SD));
+
+	ctx =3D reiser4_init_context(inode->i_sb);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	info =3D cryptcompress_inode_data(inode);
+	needed =3D cryptcompress_estimate_read(inode);
+
+	result =3D reiser4_grab_space(needed, BA_CAN_COMMIT);
+	if (result !=3D 0) {
+		reiser4_exit_context(ctx);
+		return result;
+	}
+	result =3D do_sync_read(file, buf, size, off);
+
+	context_set_commit_async(ctx);
+	reiser4_exit_context(ctx);
+
+	return result;
+}
+
+/* Look for a disk cluster and keep lookup result in @found.
+ * If @index > 0, then find disk cluster of the index (@index - 1);
+ * If @index =3D=3D 0, then find the rightmost disk cluster.
+ * Keep incremented index of the found disk cluster in @found.
+ * @found =3D=3D 0 means that disk cluster was not found (in the last
+ * case (@index =3D=3D 0) it means that file doesn't have disk cluster=
s).
+ */
+static int lookup_disk_cluster(struct inode *inode, cloff_t * found,
+			       cloff_t index)
+{
+	int result;
+	reiser4_key key;
+	loff_t offset;
+	hint_t *hint;
+	lock_handle *lh;
+	lookup_bias bias;
+	coord_t *coord;
+	item_plugin *iplug;
+
+	assert("edward-1131", inode !=3D NULL);
+	assert("edward-95", cryptcompress_inode_ok(inode));
+
+	hint =3D kmalloc(sizeof(*hint), reiser4_ctx_gfp_mask_get());
+	if (hint =3D=3D NULL)
+		return RETERR(-ENOMEM);
+	hint_init_zero(hint);
+	lh =3D &hint->lh;
+
+	bias =3D (index ? FIND_EXACT : FIND_MAX_NOT_MORE_THAN);
+	offset =3D
+	    (index ? clust_to_off(index, inode) -
+	     1 : get_key_offset(reiser4_max_key()));
+
+	key_by_inode_cryptcompress(inode, offset, &key);
+
+	/* find the last item of this object */
+	result =3D
+	    find_cluster_item(hint, &key, ZNODE_READ_LOCK, NULL /* ra_info */=
,
+			      bias, 0);
+	if (cbk_errored(result)) {
+		done_lh(lh);
+		kfree(hint);
+		return result;
+	}
+	if (result =3D=3D CBK_COORD_NOTFOUND) {
+		/* no real disk clusters */
+		done_lh(lh);
+		kfree(hint);
+		*found =3D 0;
+		return 0;
+	}
+	/* disk cluster is found */
+	coord =3D &hint->ext_coord.coord;
+	coord_clear_iplug(coord);
+	result =3D zload(coord->node);
+	if (unlikely(result)) {
+		done_lh(lh);
+		kfree(hint);
+		return result;
+	}
+	iplug =3D item_plugin_by_coord(coord);
+	assert("edward-277", iplug =3D=3D item_plugin_by_id(CTAIL_ID));
+	assert("edward-1202", ctail_ok(coord));
+
+	item_key_by_coord(coord, &key);
+	*found =3D off_to_clust(get_key_offset(&key), inode) + 1;
+
+	assert("edward-1132", ergo(index, index =3D=3D *found));
+
+	zrelse(coord->node);
+	done_lh(lh);
+	kfree(hint);
+	return 0;
+}
+
+static int find_fake_appended(struct inode *inode, cloff_t * index)
+{
+	return lookup_disk_cluster(inode, index,
+				   0 /* find last real one */ );
+}
+
+/* Set left coord when unit is not found after node_lookup()
+   This takes into account that there can be holes in a sequence
+   of disk clusters */
+
+static void adjust_left_coord(coord_t * left_coord)
+{
+	switch (left_coord->between) {
+	case AFTER_UNIT:
+		left_coord->between =3D AFTER_ITEM;
+	case AFTER_ITEM:
+	case BEFORE_UNIT:
+		break;
+	default:
+		impossible("edward-1204", "bad left coord to cut");
+	}
+	return;
+}
+
+#define CRC_CUT_TREE_MIN_ITERATIONS 64
+int cut_tree_worker_cryptcompress(tap_t * tap, const reiser4_key * fro=
m_key,
+				  const reiser4_key * to_key,
+				  reiser4_key * smallest_removed,
+				  struct inode *object, int truncate,
+				  int *progress)
+{
+	lock_handle next_node_lock;
+	coord_t left_coord;
+	int result;
+
+	assert("edward-1158", tap->coord->node !=3D NULL);
+	assert("edward-1159", znode_is_write_locked(tap->coord->node));
+	assert("edward-1160", znode_get_level(tap->coord->node) =3D=3D LEAF_L=
EVEL);
+
+	*progress =3D 0;
+	init_lh(&next_node_lock);
+
+	while (1) {
+		znode *node;	/* node from which items are cut */
+		node_plugin *nplug;	/* node plugin for @node */
+
+		node =3D tap->coord->node;
+
+		/* Move next_node_lock to the next node on the left. */
+		result =3D
+		    reiser4_get_left_neighbor(&next_node_lock, node,
+					      ZNODE_WRITE_LOCK,
+					      GN_CAN_USE_UPPER_LEVELS);
+		if (result !=3D 0 && result !=3D -E_NO_NEIGHBOR)
+			break;
+		/* FIXME-EDWARD: Check can we delete the node as a whole. */
+		result =3D reiser4_tap_load(tap);
+		if (result)
+			return result;
+
+		/* Prepare the second (right) point for cut_node() */
+		if (*progress)
+			coord_init_last_unit(tap->coord, node);
+
+		else if (item_plugin_by_coord(tap->coord)->b.lookup =3D=3D NULL)
+			/* set rightmost unit for the items without lookup method */
+			tap->coord->unit_pos =3D coord_last_unit_pos(tap->coord);
+
+		nplug =3D node->nplug;
+
+		assert("edward-1161", nplug);
+		assert("edward-1162", nplug->lookup);
+
+		/* left_coord is leftmost unit cut from @node */
+		result =3D nplug->lookup(node, from_key, FIND_EXACT, &left_coord);
+
+		if (IS_CBKERR(result))
+			break;
+
+		if (result =3D=3D CBK_COORD_NOTFOUND)
+			adjust_left_coord(&left_coord);
+
+		/* adjust coordinates so that they are set to existing units */
+		if (coord_set_to_right(&left_coord)
+		    || coord_set_to_left(tap->coord)) {
+			result =3D 0;
+			break;
+		}
+
+		if (coord_compare(&left_coord, tap->coord) =3D=3D
+		    COORD_CMP_ON_RIGHT) {
+			/* keys from @from_key to @to_key are not in the tree */
+			result =3D 0;
+			break;
+		}
+
+		/* cut data from one node */
+		*smallest_removed =3D *reiser4_min_key();
+		result =3D kill_node_content(&left_coord,
+					   tap->coord,
+					   from_key,
+					   to_key,
+					   smallest_removed,
+					   next_node_lock.node,
+					   object, truncate);
+		reiser4_tap_relse(tap);
+
+		if (result)
+			break;
+
+		++(*progress);
+
+		/* Check whether all items with keys >=3D from_key were removed
+		 * from the tree. */
+		if (keyle(smallest_removed, from_key))
+			/* result =3D 0; */
+			break;
+
+		if (next_node_lock.node =3D=3D NULL)
+			break;
+
+		result =3D reiser4_tap_move(tap, &next_node_lock);
+		done_lh(&next_node_lock);
+		if (result)
+			break;
+
+		/* Break long cut_tree operation (deletion of a large file) if
+		 * atom requires commit. */
+		if (*progress > CRC_CUT_TREE_MIN_ITERATIONS
+		    && current_atom_should_commit()) {
+			result =3D -E_REPEAT;
+			break;
+		}
+	}
+	done_lh(&next_node_lock);
+	return result;
+}
+
+/* Append or expand hole in two steps:
+ * 1) set zeroes to the rightmost page of the rightmost non-fake
+ *    logical cluster;
+ * 2) expand hole via fake logical clusters (just increase i_size)
+ */
+static int cryptcompress_append_hole(struct inode *inode /* with old s=
ize */,
+				     loff_t new_size)
+{
+	int result =3D 0;
+	hint_t *hint;
+	lock_handle *lh;
+	loff_t hole_size;
+	int nr_zeroes;
+	struct reiser4_slide win;
+	struct cluster_handle clust;
+
+	assert("edward-1133", inode->i_size < new_size);
+	assert("edward-1134", reiser4_schedulable());
+	assert("edward-1135", cryptcompress_inode_ok(inode));
+	assert("edward-1136", current_blocksize =3D=3D PAGE_CACHE_SIZE);
+	assert("edward-1333", off_to_cloff(inode->i_size, inode) !=3D 0);
+
+	hint =3D kmalloc(sizeof(*hint), reiser4_ctx_gfp_mask_get());
+	if (hint =3D=3D NULL)
+		return RETERR(-ENOMEM);
+	hint_init_zero(hint);
+	lh =3D &hint->lh;
+
+	reiser4_slide_init(&win);
+	cluster_init_read(&clust, &win);
+	clust.hint =3D hint;
+
+	result =3D alloc_cluster_pgset(&clust, cluster_nrpages(inode));
+	if (result)
+		goto out;
+	if (off_to_cloff(inode->i_size, inode) =3D=3D 0)
+		goto append_fake;
+	hole_size =3D new_size - inode->i_size;
+	nr_zeroes =3D
+		inode_cluster_size(inode) - off_to_cloff(inode->i_size, inode);
+	if (hole_size < nr_zeroes)
+		nr_zeroes =3D hole_size;
+	set_window(&clust, &win, inode, inode->i_size,
+		   inode->i_size + nr_zeroes);
+	win.stat =3D HOLE_WINDOW;
+
+	assert("edward-1137",
+	       clust.index =3D=3D off_to_clust(inode->i_size, inode));
+
+	result =3D prepare_logical_cluster(inode, 0, 0, &clust, LC_APPOV);
+
+	assert("edward-1271", !result || result =3D=3D -ENOSPC);
+	if (result)
+		goto out;
+	assert("edward-1139",
+	       clust.dstat =3D=3D PREP_DISK_CLUSTER ||
+	       clust.dstat =3D=3D UNPR_DISK_CLUSTER);
+
+	assert("edward-1431", hole_size >=3D nr_zeroes);
+	if (hole_size =3D=3D nr_zeroes)
+	/* nothing to append anymore */
+		goto out;
+ append_fake:
+	INODE_SET_SIZE(inode, new_size);
+ out:
+	done_lh(lh);
+	kfree(hint);
+	put_cluster_handle(&clust);
+	return result;
+}
+
+static int
+update_cryptcompress_size(struct inode *inode, reiser4_key * key, int =
update_sd)
+{
+	return (get_key_offset(key) & ((loff_t) (inode_cluster_size(inode)) -=
 1)
+		? 0 : reiser4_update_file_size(inode, key, update_sd));
+}
+
+/* Prune cryptcompress file in two steps:
+ * 1) cut all nominated logical clusters except the leftmost one which
+ *    is to be partially truncated. Note, that there can be "holes"
+ *    represented by fake logical clusters.
+ * 2) set zeroes and capture leftmost partially truncated logical
+ *    cluster, if it is not fake; otherwise prune fake logical cluster
+ *    (just decrease i_size).
+ */
+static int prune_cryptcompress(struct inode *inode, loff_t new_size,
+			       int update_sd, cloff_t aidx)
+{
+	int result =3D 0;
+	unsigned nr_zeroes;
+	loff_t to_prune;
+	loff_t old_size;
+	cloff_t ridx;
+
+	hint_t *hint;
+	lock_handle *lh;
+	struct reiser4_slide win;
+	struct cluster_handle clust;
+
+	assert("edward-1140", inode->i_size >=3D new_size);
+	assert("edward-1141", reiser4_schedulable());
+	assert("edward-1142", cryptcompress_inode_ok(inode));
+	assert("edward-1143", current_blocksize =3D=3D PAGE_CACHE_SIZE);
+
+	old_size =3D inode->i_size;
+
+	hint =3D kmalloc(sizeof(*hint), reiser4_ctx_gfp_mask_get());
+	if (hint =3D=3D NULL)
+		return RETERR(-ENOMEM);
+	hint_init_zero(hint);
+	lh =3D &hint->lh;
+
+	reiser4_slide_init(&win);
+	cluster_init_read(&clust, &win);
+	clust.hint =3D hint;
+
+	/* calculate index of the rightmost logical cluster
+	   that will be completely truncated */
+	ridx =3D size_in_lc(new_size, inode);
+
+	/* truncate all disk clusters starting from @ridx */
+	assert("edward-1174", ridx <=3D aidx);
+	old_size =3D inode->i_size;
+	if (ridx !=3D aidx) {
+		struct cryptcompress_info * info;
+		info =3D cryptcompress_inode_data(inode);
+		result =3D cut_file_items(inode,
+					clust_to_off(ridx, inode),
+					update_sd,
+					clust_to_off(aidx, inode),
+					update_cryptcompress_size);
+		info->trunc_index =3D ULONG_MAX;
+		if (result)
+			goto out;
+	}
+	/*
+	 * there can be pages of fake logical clusters, truncate them
+	 */
+	truncate_inode_pages(inode->i_mapping, clust_to_off(ridx, inode));
+	assert("edward-1524",
+	       pages_truncate_ok(inode, clust_to_pg(ridx, inode)));
+	/*
+	 * now perform partial truncate of last logical cluster
+	 */
+	if (!off_to_cloff(new_size, inode)) {
+		/* no partial truncate is needed */
+		assert("edward-1145", inode->i_size =3D=3D new_size);
+		goto truncate_fake;
+	}
+	assert("edward-1146", new_size < inode->i_size);
+
+	to_prune =3D inode->i_size - new_size;
+
+	/* check if the last logical cluster is fake */
+	result =3D lookup_disk_cluster(inode, &aidx, ridx);
+	if (result)
+		goto out;
+	if (!aidx)
+		/* yup, this is fake one */
+		goto truncate_fake;
+
+	assert("edward-1148", aidx =3D=3D ridx);
+
+	/* do partial truncate of the last page cluster,
+	   and try to capture this one */
+	result =3D alloc_cluster_pgset(&clust, cluster_nrpages(inode));
+	if (result)
+		goto out;
+	nr_zeroes =3D (off_to_pgoff(new_size) ?
+		     PAGE_CACHE_SIZE - off_to_pgoff(new_size) : 0);
+	set_window(&clust, &win, inode, new_size, new_size + nr_zeroes);
+	win.stat =3D HOLE_WINDOW;
+
+	assert("edward-1149", clust.index =3D=3D ridx - 1);
+
+	result =3D prepare_logical_cluster(inode, 0, 0, &clust, LC_TRUNC);
+	if (result)
+		goto out;
+	assert("edward-1151",
+	       clust.dstat =3D=3D PREP_DISK_CLUSTER ||
+	       clust.dstat =3D=3D UNPR_DISK_CLUSTER);
+
+	assert("edward-1191", inode->i_size =3D=3D new_size);
+	assert("edward-1206", body_truncate_ok(inode, ridx));
+ truncate_fake:
+	/* drop all the pages that don't have jnodes (i.e. pages
+	   which can not be truncated by cut_file_items() because
+	   of holes represented by fake disk clusters) including
+	   the pages of partially truncated cluster which was
+	   released by prepare_logical_cluster() */
+	INODE_SET_SIZE(inode, new_size);
+	truncate_inode_pages(inode->i_mapping, new_size);
+ out:
+	assert("edward-1334", !result || result =3D=3D -ENOSPC);
+	assert("edward-1497",
+	       pages_truncate_ok(inode, size_in_pages(new_size)));
+
+	done_lh(lh);
+	kfree(hint);
+	put_cluster_handle(&clust);
+	return result;
+}
+
+/* Prepare cryptcompress file for truncate:
+ * prune or append rightmost fake logical clusters (if any)
+ */
+static int start_truncate_fake(struct inode *inode, cloff_t aidx,
+			       loff_t new_size, int update_sd)
+{
+	int result =3D 0;
+	int bytes;
+
+	if (new_size > inode->i_size) {
+		/* append */
+		if (inode->i_size < clust_to_off(aidx, inode))
+			/* no fake bytes */
+			return 0;
+		bytes =3D new_size - inode->i_size;
+		INODE_SET_SIZE(inode, inode->i_size + bytes);
+	} else {
+		/* prune */
+		if (inode->i_size <=3D clust_to_off(aidx, inode))
+			/* no fake bytes */
+			return 0;
+		bytes =3D inode->i_size -
+			max(new_size, clust_to_off(aidx, inode));
+		if (!bytes)
+			return 0;
+		INODE_SET_SIZE(inode, inode->i_size - bytes);
+		/* In the case of fake prune we need to drop page cluster.
+		   There are only 2 cases for partially truncated page:
+		   1. If is is dirty, therefore it is anonymous
+		   (was dirtied via mmap), and will be captured
+		   later via ->capture().
+		   2. If is clean, therefore it is filled by zeroes.
+		   In both cases we don't need to make it dirty and
+		   capture here.
+		 */
+		truncate_inode_pages(inode->i_mapping, inode->i_size);
+	}
+	if (update_sd)
+		result =3D update_sd_cryptcompress(inode);
+	return result;
+}
+
+/* This is called in setattr_cryptcompress when it is used to truncate=
,
+ * and in delete_cryptcompress */
+static int cryptcompress_truncate(struct inode *inode,	/* old size */
+				  loff_t new_size,	/* new size */
+				  int update_sd)
+{
+	int result;
+	cloff_t aidx;
+
+	result =3D find_fake_appended(inode, &aidx);
+	if (result)
+		return result;
+	assert("edward-1208",
+	       ergo(aidx > 0, inode->i_size > clust_to_off(aidx - 1, inode)))=
;
+
+	result =3D start_truncate_fake(inode, aidx, new_size, update_sd);
+	if (result)
+		return result;
+	if (inode->i_size =3D=3D new_size)
+		/* nothing to truncate anymore */
+		return 0;
+	result =3D (inode->i_size < new_size ?
+		  cryptcompress_append_hole(inode, new_size) :
+		  prune_cryptcompress(inode, new_size, update_sd, aidx));
+	if (!result && update_sd)
+		result =3D update_sd_cryptcompress(inode);
+	return result;
+}
+
+/* Capture an anonymous pager cluster. (Page cluser is
+ * anonymous if it contains at least one anonymous page
+ */
+static int capture_anon_page_cluster(struct cluster_handle * clust,
+				     struct inode * inode)
+{
+	int result;
+
+	assert("edward-1073", clust !=3D NULL);
+	assert("edward-1074", inode !=3D NULL);
+	assert("edward-1075", clust->dstat =3D=3D INVAL_DISK_CLUSTER);
+
+	result =3D prepare_logical_cluster(inode, 0, 0, clust, LC_APPOV);
+	if (result)
+		return result;
+	set_cluster_pages_dirty(clust, inode);
+	result =3D checkin_logical_cluster(clust, inode);
+	put_hint_cluster(clust, inode, ZNODE_WRITE_LOCK);
+	if (unlikely(result))
+		put_page_cluster(clust, inode, WRITE_OP);
+	return result;
+}
+
+/* Starting from @index find tagged pages of the same page cluster.
+ * Clear the tag for each of them. Return number of found pages.
+ */
+static int find_anon_page_cluster(struct address_space * mapping,
+				  pgoff_t * index, struct page ** pages)
+{
+	int i =3D 0;
+	int found;
+	write_lock_irq(&mapping->tree_lock);
+	do {
+		/* looking for one page */
+		found =3D radix_tree_gang_lookup_tag(&mapping->page_tree,
+						   (void **)&pages[i],
+						   *index, 1,
+						   PAGECACHE_TAG_REISER4_MOVED);
+		if (!found)
+			break;
+		if (!same_page_cluster(pages[0], pages[i]))
+			break;
+
+		/* found */
+		page_cache_get(pages[i]);
+		*index =3D pages[i]->index + 1;
+
+		radix_tree_tag_clear(&mapping->page_tree,
+				     pages[i]->index,
+				     PAGECACHE_TAG_REISER4_MOVED);
+		if (last_page_in_cluster(pages[i++]))
+			break;
+	} while (1);
+	write_unlock_irq(&mapping->tree_lock);
+	return i;
+}
+
+#define MAX_PAGES_TO_CAPTURE  (1024)
+
+/* Capture anonymous page clusters */
+static int capture_anon_pages(struct address_space * mapping, pgoff_t =
* index,
+			      int to_capture)
+{
+	int count =3D 0;
+	int found =3D 0;
+	int result =3D 0;
+	hint_t *hint;
+	lock_handle *lh;
+	struct inode * inode;
+	struct cluster_handle clust;
+	struct page * pages[MAX_CLUSTER_NRPAGES];
+
+	assert("edward-1127", mapping !=3D NULL);
+	assert("edward-1128", mapping->host !=3D NULL);
+	assert("edward-1440", mapping->host->i_mapping =3D=3D mapping);
+
+	inode =3D mapping->host;
+	hint =3D kmalloc(sizeof(*hint), reiser4_ctx_gfp_mask_get());
+	if (hint =3D=3D NULL)
+		return RETERR(-ENOMEM);
+	hint_init_zero(hint);
+	lh =3D &hint->lh;
+
+	cluster_init_read(&clust, NULL);
+	clust.hint =3D hint;
+
+	result =3D alloc_cluster_pgset(&clust, cluster_nrpages(inode));
+	if (result)
+		goto out;
+
+	while (to_capture > 0) {
+		found =3D find_anon_page_cluster(mapping, index, pages);
+		if (!found) {
+			*index =3D (pgoff_t) - 1;
+			break;
+		}
+		move_cluster_forward(&clust, inode, pages[0]->index);
+		result =3D capture_anon_page_cluster(&clust, inode);
+
+		put_found_pages(pages, found); /* find_anon_page_cluster */
+		if (result)
+			break;
+		to_capture -=3D clust.nr_pages;
+		count +=3D clust.nr_pages;
+	}
+	if (result) {
+		warning("edward-1077",
+			"Capture failed (inode %llu, result=3D%i, captured=3D%d)\n",
+			(unsigned long long)get_inode_oid(inode), result, count);
+	} else {
+		assert("edward-1078", ergo(found > 0, count > 0));
+		if (to_capture <=3D 0)
+			/* there may be left more pages */
+			__mark_inode_dirty(inode, I_DIRTY_PAGES);
+		result =3D count;
+	}
+      out:
+	done_lh(lh);
+	kfree(hint);
+	put_cluster_handle(&clust);
+	return result;
+}
+
+/* Returns true if inode's mapping has dirty pages
+   which do not belong to any atom */
+static int cryptcompress_inode_has_anon_pages(struct inode *inode)
+{
+	int result;
+	read_lock_irq(&inode->i_mapping->tree_lock);
+	result =3D radix_tree_tagged(&inode->i_mapping->page_tree,
+				   PAGECACHE_TAG_REISER4_MOVED);
+	read_unlock_irq(&inode->i_mapping->tree_lock);
+	return result;
+}
+
+/* This is implementation of vfs's writepages method of struct
+   address_space_operations */
+int writepages_cryptcompress(struct address_space *mapping,
+			     struct writeback_control *wbc)
+{
+	int result =3D 0;
+	long to_capture;
+	pgoff_t nrpages;
+	pgoff_t index =3D 0;
+	struct inode *inode;
+	struct cryptcompress_info *info;
+
+	inode =3D mapping->host;
+	if (!cryptcompress_inode_has_anon_pages(inode))
+		goto end;
+	info =3D cryptcompress_inode_data(inode);
+	nrpages =3D size_in_pages(i_size_read(inode));
+
+	if (wbc->sync_mode !=3D WB_SYNC_ALL)
+		to_capture =3D min(wbc->nr_to_write, (long)MAX_PAGES_TO_CAPTURE);
+	else
+		to_capture =3D MAX_PAGES_TO_CAPTURE;
+	do {
+		reiser4_context *ctx;
+
+		ctx =3D reiser4_init_context(inode->i_sb);
+		if (IS_ERR(ctx)) {
+			result =3D PTR_ERR(ctx);
+			break;
+		}
+		/* avoid recursive calls to ->sync_inodes */
+		ctx->nobalance =3D 1;
+
+		assert("edward-1079",
+		       lock_stack_isclean(get_current_lock_stack()));
+
+		reiser4_txn_restart_current();
+
+		if (get_current_context()->entd) {
+			if (mutex_trylock(&info->checkin_mutex) =3D=3D 0) {
+				/* the mutex might be occupied by
+				   entd caller */
+				result =3D RETERR(-EBUSY);
+				reiser4_exit_context(ctx);
+				break;
+			}
+		} else
+			mutex_lock(&info->checkin_mutex);
+
+		result =3D capture_anon_pages(inode->i_mapping, &index,
+					    to_capture);
+		mutex_unlock(&info->checkin_mutex);
+
+		if (result < 0) {
+			reiser4_exit_context(ctx);
+			break;
+		}
+		wbc->nr_to_write -=3D result;
+		if (wbc->sync_mode !=3D WB_SYNC_ALL) {
+			reiser4_exit_context(ctx);
+			break;
+		}
+		result =3D txnmgr_force_commit_all(inode->i_sb, 0);
+		reiser4_exit_context(ctx);
+	} while (result >=3D 0 && index < nrpages);
+
+ end:
+	if (is_in_reiser4_context()) {
+		if (get_current_context()->nr_captured >=3D CAPTURE_APAGE_BURST) {
+			/* there are already pages to flush, flush them out,
+			   do not delay until end of reiser4_sync_inodes */
+			reiser4_writeout(inode->i_sb, wbc);
+			get_current_context()->nr_captured =3D 0;
+		}
+	}
+	return result;
+}
+
+/* plugin->u.file.mmap */
+int mmap_cryptcompress(struct file *file, struct vm_area_struct *vma)
+{
+	int result;
+	struct inode *inode;
+	reiser4_context *ctx;
+
+	inode =3D file->f_dentry->d_inode;
+	ctx =3D reiser4_init_context(inode->i_sb);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+	/*
+	 * generic_file_mmap will do update_atime. Grab space for stat data
+	 * update.
+	 */
+	result =3D reiser4_grab_space_force
+		(inode_file_plugin(inode)->estimate.update(inode),
+		 BA_CAN_COMMIT);
+	if (result) {
+		reiser4_exit_context(ctx);
+		return result;
+	}
+	result =3D generic_file_mmap(file, vma);
+	reiser4_exit_context(ctx);
+	return result;
+}
+
+/* plugin->u.file.release */
+/* plugin->u.file.get_block */
+
+/* this is implementation of delete method of file plugin for
+ * cryptcompress objects
+ */
+int delete_object_cryptcompress(struct inode *inode)
+{
+	int result;
+	struct cryptcompress_info * info;
+
+	assert("edward-429", inode->i_nlink =3D=3D 0);
+
+	reiser4_txn_restart_current();
+	info =3D cryptcompress_inode_data(inode);
+
+	mutex_lock(&info->checkin_mutex);
+	result =3D cryptcompress_truncate(inode, 0, 0);
+	mutex_unlock(&info->checkin_mutex);
+
+	if (result) {
+		warning("edward-430",
+			"cannot truncate cryptcompress file  %lli: %i",
+			(unsigned long long)get_inode_oid(inode),
+			result);
+	}
+	truncate_inode_pages(inode->i_mapping, 0);
+	assert("edward-1487", pages_truncate_ok(inode, 0));
+	/* and remove stat data */
+	return reiser4_delete_object_common(inode);
+}
+
+/* plugin->u.file.setattr method
+   This implements actual truncate (see comments in reiser4/page_cache=
=2Ec) */
+int setattr_cryptcompress(struct dentry *dentry, struct iattr *attr)
+{
+	int result;
+	struct inode *inode;
+	struct cryptcompress_info * info;
+
+	inode =3D dentry->d_inode;
+	info =3D cryptcompress_inode_data(inode);
+
+	if (attr->ia_valid & ATTR_SIZE) {
+		if (i_size_read(inode) !=3D attr->ia_size) {
+			reiser4_context *ctx;
+			loff_t old_size;
+
+			ctx =3D reiser4_init_context(dentry->d_inode->i_sb);
+			if (IS_ERR(ctx))
+				return PTR_ERR(ctx);
+
+			old_size =3D i_size_read(inode);
+			inode_check_scale(inode, old_size, attr->ia_size);
+
+			mutex_lock(&info->checkin_mutex);
+			result =3D cryptcompress_truncate(inode,
+							attr->ia_size,
+							1/* update sd */);
+			mutex_unlock(&info->checkin_mutex);
+			if (result) {
+			     warning("edward-1192",
+				     "truncate_cryptcompress failed: oid %lli, "
+				     "old size %lld, new size %lld, retval %d",
+				     (unsigned long long)
+				     get_inode_oid(inode), old_size,
+				     attr->ia_size, result);
+			}
+			context_set_commit_async(ctx);
+			reiser4_exit_context(ctx);
+		} else
+			result =3D 0;
+	} else
+		result =3D reiser4_setattr_common(dentry, attr);
+	return result;
+}
+
+/*
+ * release_cryptcompress - release of struct file_operations
+ * @inode: inode of released file
+ * @file: file to release
+ */
+int release_cryptcompress(struct inode *inode, struct file *file)
+{
+	reiser4_context *ctx =3D reiser4_init_context(inode->i_sb);
+
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+	reiser4_free_file_fsdata(file);
+	reiser4_exit_context(ctx);
+	return 0;
+}
+
+#if 0
+int prepare_write_cryptcompress(struct file *file, struct page *page,
+				unsigned from, unsigned to)
+{
+	return prepare_write_common(file, page, from, to);
+}
+#endif  /*  0  */
+
+
+/*
+  Local variables:
+  c-indentation-style: "K&R"
+  mode-name: "LC"
+  c-basic-offset: 8
+  tab-width: 8
+  fill-column: 80
+  scroll-step: 1
+  End:
+*/
diff -puN fs/reiser4/plugin/file/file.c~reiser4-make-methods-supplied-t=
o-vfs-invariant fs/reiser4/plugin/file/file.c
--- a/fs/reiser4/plugin/file/file.c~reiser4-make-methods-supplied-to-vf=
s-invariant
+++ a/fs/reiser4/plugin/file/file.c
@@ -1372,42 +1372,6 @@ int writepages_unix_file(struct address_
 	return result;
 }
=20
-/*
- * ->sync() method for unix file.
- *
- * We are trying to be smart here. Instead of committing all atoms (or=
iginal
- * solution), we scan dirty pages of this file and commit all atoms th=
ey are
- * part of.
- *
- * Situation is complicated by anonymous pages: i.e., extent-less page=
s
- * dirtied through mmap. Fortunately sys_fsync() first calls
- * filemap_fdatawrite() that will ultimately call reiser4_writepages()=
, insert
- * all missing extents and capture anonymous pages.
- */
-int sync_unix_file(struct file *file, struct dentry *dentry, int datas=
ync)
-{
-	reiser4_context *ctx;
-	txn_atom *atom;
-	reiser4_block_nr reserve;
-
-	ctx =3D reiser4_init_context(dentry->d_inode->i_sb);
-	if (IS_ERR(ctx))
-		return PTR_ERR(ctx);
-
-	reserve =3D estimate_update_common(dentry->d_inode);
-	if (reiser4_grab_space(reserve, BA_CAN_COMMIT)) {
-		reiser4_exit_context(ctx);
-		return RETERR(-ENOSPC);
-	}
-	write_sd_by_inode_common(dentry->d_inode);
-
-	atom =3D get_current_atom_locked();
-	spin_lock_txnh(ctx->trans);
-	force_commit_atom(ctx->trans);
-	reiser4_exit_context(ctx);
-	return 0;
-}
-
 /**
  * readpage_unix_file_nolock - readpage of struct address_space_operat=
ions
  * @file:
@@ -2126,7 +2090,7 @@ static void drop_access(struct unix_file
  * unix file plugin.
  */
 ssize_t write_unix_file(struct file *file, const char __user *buf,
-			size_t count, loff_t *pos)
+			size_t count, loff_t *pos, int *conv)
 {
 	int result;
 	reiser4_context *ctx;
@@ -2317,8 +2281,8 @@ ssize_t write_unix_file(struct file *fil
 	if (result =3D=3D 0 && ((file->f_flags & O_SYNC) || IS_SYNC(inode))) =
{
 		reiser4_txn_restart_current();
 		grab_space_enable();
-		result =3D sync_unix_file(file, file->f_dentry,
-					0 /* data and stat data */ );
+		result =3D reiser4_sync_file_common(file, file->f_dentry,
+						  0 /* data and stat data */);
 		if (result)
 			warning("reiser4-7", "failed to sync file %llu",
 				(unsigned long long)get_inode_oid(inode));
@@ -2703,7 +2667,7 @@ init_inode_data_unix_file(struct inode *
 }
=20
 /**
- * delete_object_unix_file - delete_object of file_plugin
+ * delete_unix_file - delete_object of file_plugin
  * @inode: inode to be deleted
  *
  * Truncates file to length 0, removes stat data and safe link.
diff -puN fs/reiser4/plugin/file/file_conversion.c~reiser4-make-methods=
-supplied-to-vfs-invariant fs/reiser4/plugin/file/file_conversion.c
--- a/fs/reiser4/plugin/file/file_conversion.c~reiser4-make-methods-sup=
plied-to-vfs-invariant
+++ a/fs/reiser4/plugin/file/file_conversion.c
@@ -1,22 +1,30 @@
 /* Copyright 2001, 2002, 2003 by Hans Reiser,
    licensing governed by reiser4/README */
=20
-/* This file contains hooks that converts (*) cryptcompress files to u=
nix-files,
-   and a set of protected (**) methods of a cryptcompress file plugin =
to perform
-   such conversion.
-
-(*)
-   The conversion is performed for incompressible files to reduce cpu =
and memory
-   usage. If first logical cluster (64K by default) of a file is incom=
pressible,
-   then we make a desicion, that the whole file is incompressible.
-   The conversion can be enabled via installing a special compression =
mode
-   plugin (CONVX_COMPRESSION_MODE_ID, see plugin/compress/compress_mod=
e.c for
-   details).
-
-(**)
-   The protection means serialization of critical sections (readers an=
d writers
-   of @pset->file)
-*/
+/* *
+ * This file contains a converter cryptcompress->unix_file, and O(1)-h=
euristic,
+ * which allows to assign for a regular file the most reasonable plugi=
n to be
+ * managed by. Note, that we don't use back conversion because of comp=
atibility
+ * reasons (see http://dev.namesys.com/Version4.X.Y for details).
+ *
+ * Currently used heuristic is very simple: if first complete logical =
cluster
+ * (64K by default) of a file is incompressible, then we make a decisi=
on, that
+ * the whole file is incompressible (*). When creating a file the conv=
ersion
+ * is enabled by default via installing a special "permitting" compres=
sion mode
+ * plugin (**) (CONVX_COMPRESSION_MODE_ID, see plugin/compress/compres=
s_mode.c
+ * for details).
+ *
+ * The conversion is accompanied by rebuilding disk structures of a fi=
le, so it
+ * is important to protect them from being interacted with other plugi=
ns which
+ * don't expect them to be in such inconsistent state. For this to be =
protected
+ * we serialize readers and writers of pset. Writers are the processes=
 which can
+ * change it with conversion purposes; other ones are readers. Seriali=
zation is
+ * performed via acquiring per-inode rw-semaphore (conv_sem).
+ *
+ * (*)  This heuristic can be easily changed as soon as we have a new,
+ *      better one.
+ * (**) Such solution allows to keep enable/disable state on disk.
+ */
=20
 #include "../../inode.h"
 #include "../cluster.h"
@@ -26,26 +34,24 @@
 	 (inode_compression_mode_plugin(inode) =3D=3D		       \
 	  compression_mode_plugin_by_id(CONVX_COMPRESSION_MODE_ID))
=20
-
-/* Located sections (readers and writers of @pset->file) are not
-   permanently critical: cryptcompress file can be converted only
-   if the conversion is enabled (see the macrio above). And we don't
-   convert unix files at all.
-   The following helper macro is a sanity check to decide if we
-   need to protect a located section.
-*/
+/**
+ * Located sections (readers and writers of @pset) are not permanently
+ * critical: cryptcompress file can be converted only if the conversio=
n
+ * is enabled (see the macrio above). Also we don't perform back
+ * conversion. The following helper macro is a sanity check to decide
+ * if we need the protection (locks are always additional overheads).
+ */
 #define should_protect(inode)						\
 	(inode_file_plugin(inode) =3D=3D					\
 	 file_plugin_by_id(CRYPTCOMPRESS_FILE_PLUGIN_ID) &&		\
 	 conversion_enabled(inode))
-
-/* All protected methods have prefix "prot" in their names.
-   It is convenient to construct them by usual (unprotected) ones
-   using the following common macros:
-*/
-
+/**
+ * We'll speak about "passive" protection for readers and "active"
+ * protection for writers. All methods with active or passive protecti=
on
+ * has suffix "careful".
+ */
 /* Macro for passive protection.
-   method_cryptcompress contains only readers */
+   method_foo contains only readers */
 #define PROT_PASSIVE(type, method, args)				\
 ({							                \
 	type _result;							\
@@ -86,9 +92,11 @@
 		up_read(guard);						\
 })
=20
-/* Macro for active protection.
-   active_expr contains readers and writers; after its
-   evaluation conversion should be disabled */
+/**
+ * Macro for active protection.
+ * active_expr contains writers of pset;
+ * NOTE: after evaluating active_expr conversion should be disabled.
+ */
 #define PROT_ACTIVE(type, method, args, active_expr)			\
 ({	                 						\
 	type _result =3D 0;						\
@@ -154,13 +162,12 @@ static int __cryptcompress2unixfile(stru
 	uf->ea_owner =3D NULL;
 	atomic_set(&uf->nr_neas, 0);
 #endif
-	inode->i_op =3D
-		&file_plugin_by_id(UNIX_FILE_PLUGIN_ID)->inode_ops;
-	inode->i_fop =3D
-		&file_plugin_by_id(UNIX_FILE_PLUGIN_ID)->file_ops;
-	inode->i_mapping->a_ops =3D
-		&file_plugin_by_id(UNIX_FILE_PLUGIN_ID)->as_ops;
-	file->f_op =3D inode->i_fop;
+	/**
+	 * we was carefull for file_ops, inode_ops and as_ops
+	 * to be invariant for plugin conversion, so there is
+	 * no need to update ones already installed in the
+	 * vfs's residence.
+	 */
 	return 0;
 }
=20
@@ -278,9 +285,12 @@ static int prepped_dclust_ok(hint_t * hi
 #define data_is_compressible(osize, isize)		\
 	(osize < fifty_persent(isize))
=20
-/* This is called only once per file life.
-   Read first logical cluster (of index #0) and estimate its compressi=
bility.
-   Save estimation result in @compressible */
+/**
+ * A simple O(1)-heuristic for compressibility.
+ * This is called not more then one time per file's life.
+ * Read first logical cluster (of index #0) and estimate its compressi=
bility.
+ * Save estimation result in @compressible.
+ */
 static int read_check_compressibility(struct inode * inode,
 				      struct cluster_handle * clust,
 				      int * compressible)
@@ -443,7 +453,7 @@ static int cryptcompress2unixfile(struct
 	assert("edward-1516", clust->pages[0]->index =3D=3D 0);
 	assert("edward-1517", clust->hint !=3D NULL);
=20
-	/* release all cryptcompress-specific recources */
+	/* release all cryptcompress-specific resources */
 	cr_info =3D cryptcompress_inode_data(inode);
 	result =3D reserve_cryptcompress2unixfile(inode);
 	if (result)
@@ -523,40 +533,69 @@ static int setattr_conversion_hook(struc
 	return (attr->ia_valid & ATTR_SIZE ? disable_conversion(inode) : 0);
 }
=20
-/* Protected methods of cryptcompress file plugin constructed
-   by the macros above */
+/**
+ * Here are wrappers with "protection", aka Reiser4 "careful" methods.
+ * They are used by vfs (as methods of file_ops, inode_ops or as_ops),
+ * which is not aware of plugin conversion performed by Reiser4.
+ */
=20
-/* Wrappers with active protection for:
-   . write_cryptcompress;
-   . setattr_cryptcompress;
-*/
+/*
+ * Wrappers with active protection for:
+ *
+ * ->write();
+ * ->setattr();
+ */
=20
-ssize_t prot_write_cryptcompress(struct file *file, const char __user =
*buf,
-				 size_t count, loff_t *off)
+/*
+ * Reiser4 write "careful" method.  Write a file in 2 steps:
+ *  . start write with initial file plugin,
+ *    switch to a new (more resonable) file plugin (if any);
+ *  . finish write with the new plugin.
+ */
+ssize_t reiser4_write_careful(struct file *file, const char __user *bu=
f,
+			      size_t count, loff_t *off)
 {
 	int prot =3D 0;
 	int conv =3D 0;
-	ssize_t written_cr =3D 0;
-	ssize_t written_uf =3D 0;
+	ssize_t written_old =3D 0; /* bytes written with old plugin */
+	ssize_t written_new =3D 0; /* bytes written with new plugin */
 	struct inode * inode =3D file->f_dentry->d_inode;
 	struct rw_semaphore * guard =3D &reiser4_inode_data(inode)->conv_sem;
=20
+	/**
+	 * First step.
+	 * Sanity check: if conversion is possible,
+	 * then protect pset.
+	 */
 	if (should_protect(inode)) {
 		prot =3D 1;
 		down_write(guard);
 	}
-	written_cr =3D write_cryptcompress(file, buf, count, off, &conv);
+	written_old =3D inode_file_plugin(inode)->write(file,
+						      buf,
+						      count,
+						      off, &conv);
 	if (prot)
 		up_write(guard);
-	if (written_cr < 0)
-		return written_cr;
-	if (conv)
-		written_uf =3D write_unix_file(file, buf + written_cr,
-					     count - written_cr, off);
-	return written_cr + (written_uf < 0 ? 0 : written_uf);
+	if (written_old < 0 || conv =3D=3D 0)
+		return written_old;
+	/**
+	 * Conversion occurred.
+	 * Back conversion is impossible,
+	 * so don't protect at this step.
+	 */
+	assert("edward-1532",
+	       inode_file_plugin(inode) =3D=3D
+	       file_plugin_by_id(UNIX_FILE_PLUGIN_ID));
+
+	written_new =3D inode_file_plugin(inode)->write(file,
+						      buf + written_old,
+						      count - written_old,
+						      off, NULL);
+	return written_old + (written_new < 0 ? 0 : written_new);
 }
=20
-int prot_setattr_cryptcompress(struct dentry *dentry, struct iattr *at=
tr)
+int reiser4_setattr_careful(struct dentry *dentry, struct iattr *attr)
 {
 	struct inode * inode =3D dentry->d_inode;
 	return PROT_ACTIVE(int, setattr, (dentry, attr),
@@ -564,29 +603,50 @@ int prot_setattr_cryptcompress(struct de
 }
=20
 /* Wrappers with passive protection for:
-   . read_cryptcomperess;
-   . mmap_cryptcompress;
-   . release_cryptcompress;
-   . delete_object_cryptcompress.
-*/
-ssize_t prot_read_cryptcompress(struct file * file, char __user * buf,
-				size_t size, loff_t * off)
+ *
+ * ->open();
+ * ->read();
+ * ->ioctl();
+ * ->mmap();
+ * ->release();
+ * ->bmap().
+ */
+
+int reiser4_open_careful(struct inode *inode, struct file *file)
+{
+	return PROT_PASSIVE(int, open, (inode, file));
+}
+
+ssize_t reiser4_read_careful(struct file * file, char __user * buf,
+			     size_t size, loff_t * off)
 {
 	struct inode * inode =3D file->f_dentry->d_inode;
 	return PROT_PASSIVE(ssize_t, read, (file, buf, size, off));
 }
=20
-int prot_mmap_cryptcompress(struct file *file, struct vm_area_struct *=
vma)
+int reiser4_ioctl_careful(struct inode *inode, struct file *filp,
+			  unsigned int cmd, unsigned long arg)
+{
+	return PROT_PASSIVE(int, ioctl, (inode, filp, cmd, arg));
+}
+
+int reiser4_mmap_careful(struct file *file, struct vm_area_struct *vma=
)
 {
 	struct inode *inode =3D file->f_dentry->d_inode;
 	return PROT_PASSIVE(int, mmap, (file, vma));
 }
=20
-int prot_release_cryptcompress(struct inode *inode, struct file *file)
+int reiser4_release_careful(struct inode *inode, struct file *file)
 {
 	return PROT_PASSIVE(int, release, (inode, file));
 }
=20
+sector_t reiser4_bmap_careful(struct address_space * mapping, sector_t=
 lblock)
+{
+	struct inode *inode =3D mapping->host;
+	return PROT_PASSIVE(sector_t, bmap, (mapping, lblock));
+}
+
 /*
   Local variables:
   c-indentation-style: "K&R"
diff -puN /dev/null /dev/null
diff -puN /dev/null /dev/null
diff -puN fs/reiser4/plugin/file/file.h~reiser4-make-methods-supplied-t=
o-vfs-invariant fs/reiser4/plugin/file/file.h
--- a/fs/reiser4/plugin/file/file.h~reiser4-make-methods-supplied-to-vf=
s-invariant
+++ a/fs/reiser4/plugin/file/file.h
@@ -8,24 +8,70 @@
 #if !defined( __REISER4_FILE_H__ )
 #define __REISER4_FILE_H__
=20
-/* declarations of functions implementing UNIX_FILE_PLUGIN_ID file plu=
gin */
+/**
+ * Declarations of common/careful/generic methods.
+ * Suppose ->foo() is a vs method (of f_ops, i_ops, or a_ops);
+ * Then common reiser4 method for foo looks like reiser4_foo_common;
+ * careful method looks like reiser4_foo_careful;
+ * generic method looks like reiser4_foo.
+ *
+ * Common method is a simple instruction set eligible for more
+ * then one plugin id.
+ *
+ * Generic method looks at the plugin installed in inode's
+ * plugin set and calls its appropriate method.
+ *
+ * Careful method looks like generic method with protected pset
+ * (see plugin/file/file_conversion.c for details).
+ */
=20
 /* inode operations */
-int setattr_unix_file(struct dentry *, struct iattr *);
+int reiser4_setattr_careful(struct dentry *, struct iattr *);
=20
 /* file operations */
+ssize_t reiser4_read_careful(struct file *, char __user *buf,
+			     size_t count, loff_t *off);
+ssize_t reiser4_write_careful(struct file *, const char __user *buf,
+			      size_t count, loff_t * off);
+int reiser4_ioctl_careful(struct inode *inode, struct file *filp,
+			  unsigned int cmd, unsigned long arg);
+int reiser4_mmap_careful(struct file *, struct vm_area_struct *);
+int reiser4_open_careful(struct inode *inode, struct file *file);
+int reiser4_release_careful(struct inode *, struct file *);
+int reiser4_sync_file_common(struct file *, struct dentry *, int datas=
ync);
+
+/* address space operations */
+int reiser4_readpage(struct file *, struct page *);
+int reiser4_readpages(struct file*, struct address_space*, struct list=
_head*,
+		      unsigned);
+int reiser4_writepages(struct address_space *, struct writeback_contro=
l *);
+int reiser4_prepare_write(struct file *, struct page *, unsigned from,
+			  unsigned to);
+int reiser4_commit_write(struct file *, struct page *, unsigned from,
+			 unsigned to);
+sector_t reiser4_bmap_careful(struct address_space *, sector_t lblock)=
;
+
+/*
+ * Private methods of unix-file plugin
+ * (UNIX_FILE_PLUGIN_ID)
+ */
+
+/* private inode operations */
+int setattr_unix_file(struct dentry *, struct iattr *);
+
+/* private file operations */
+
 ssize_t read_unix_file(struct file *, char __user *buf, size_t read_am=
ount,
 		       loff_t *off);
 ssize_t write_unix_file(struct file *, const char __user *buf, size_t =
write_amount,
-			loff_t * off);
+			loff_t * off, int * conv);
 int ioctl_unix_file(struct inode *, struct file *, unsigned int cmd,
 		    unsigned long arg);
 int mmap_unix_file(struct file *, struct vm_area_struct *);
 int open_unix_file(struct inode *, struct file *);
 int release_unix_file(struct inode *, struct file *);
-int sync_unix_file(struct file *, struct dentry *, int datasync);
=20
-/* address space operations */
+/* private address space operations */
 int readpage_unix_file(struct file *, struct page *);
 int readpages_unix_file(struct file*, struct address_space*, struct li=
st_head*, unsigned);
 int writepages_unix_file(struct address_space *, struct writeback_cont=
rol *);
@@ -35,13 +81,68 @@ int commit_write_unix_file(struct file *
 			   unsigned to);
 sector_t bmap_unix_file(struct address_space *, sector_t lblock);
=20
-/* file plugin operations */
+/* other private methods */
+int delete_object_unix_file(struct inode *);
 int flow_by_inode_unix_file(struct inode *, const char __user *buf,
 			    int user, loff_t, loff_t, rw_op, flow_t *);
 int owns_item_unix_file(const struct inode *, const coord_t *);
 void init_inode_data_unix_file(struct inode *, reiser4_object_create_d=
ata *,
 			       int create);
-int delete_object_unix_file(struct inode *);
+
+/*
+ * Private methods of cryptcompress file plugin
+ * (CRYPTCOMPRESS_FILE_PLUGIN_ID)
+ */
+
+/* private inode operations */
+int setattr_cryptcompress(struct dentry *, struct iattr *);
+
+/* private file operations */
+ssize_t read_cryptcompress(struct file *, char __user *buf,
+			   size_t count, loff_t *off);
+ssize_t write_cryptcompress(struct file *, const char __user *buf,
+			    size_t count, loff_t * off, int *conv);
+int ioctl_cryptcompress(struct inode *, struct file *, unsigned int cm=
d,
+			unsigned long arg);
+int mmap_cryptcompress(struct file *, struct vm_area_struct *);
+int open_cryptcompress(struct inode *, struct file *);
+int release_cryptcompress(struct inode *, struct file *);
+
+/* private address space operations */
+int readpage_cryptcompress(struct file *, struct page *);
+int readpages_cryptcompress(struct file*, struct address_space*,
+			    struct list_head*, unsigned);
+int writepages_cryptcompress(struct address_space *,
+			     struct writeback_control *);
+int prepare_write_cryptcompress(struct file *, struct page *, unsigned=
 from,
+				unsigned to);
+int commit_write_cryptcompress(struct file *, struct page *, unsigned =
from,
+			       unsigned to);
+sector_t bmap_cryptcompress(struct address_space *, sector_t lblock);
+
+/* other private methods */
+int flow_by_inode_cryptcompress(struct inode *, const char __user *buf=
,
+				int user, loff_t, loff_t, rw_op, flow_t *);
+int key_by_inode_cryptcompress(struct inode *, loff_t off, reiser4_key=
 *);
+int create_object_cryptcompress(struct inode *, struct inode *,
+				reiser4_object_create_data *);
+int delete_object_cryptcompress(struct inode *);
+void init_inode_data_cryptcompress(struct inode *, reiser4_object_crea=
te_data *,
+				   int create);
+int cut_tree_worker_cryptcompress(tap_t *, const reiser4_key * from_ke=
y,
+				  const reiser4_key * to_key,
+				  reiser4_key * smallest_removed,
+				  struct inode *object, int truncate,
+				  int *progress);
+void destroy_inode_cryptcompress(struct inode *);
+
+/*
+ * Private methods of symlink file plugin
+ * (SYMLINK_FILE_PLUGIN_ID)
+ */
+int reiser4_create_symlink(struct inode *symlink, struct inode *dir,
+			   reiser4_object_create_data *);
+void destroy_inode_symlink(struct inode *);
=20
 /*
  * all the write into unix file is performed by item write method. Wri=
te method
@@ -183,57 +284,6 @@ static inline int ea_obtained(struct uni
=20
 #endif
=20
-/* declarations of functions implementing SYMLINK_FILE_PLUGIN_ID file =
plugin */
-int reiser4_create_symlink(struct inode *symlink, struct inode *dir,
-			   reiser4_object_create_data *);
-void destroy_inode_symlink(struct inode *);
-
-/* declarations of functions implementing CRYPTCOMPRESS_FILE_PLUGIN_ID
-   file plugin */
-
-/* inode operations */
-int setattr_cryptcompress(struct dentry *, struct iattr *);
-int prot_setattr_cryptcompress(struct dentry *, struct iattr *);
-
-/* file operations */
-ssize_t read_cryptcompress(struct file *, char __user *buf, size_t rea=
d_amount,
-			   loff_t * off);
-ssize_t prot_read_cryptcompress(struct file *, char __user *buf,
-				size_t read_amount, loff_t * off);
-
-ssize_t write_cryptcompress(struct file *, const char __user *buf, siz=
e_t write_amount,
-			    loff_t * off, int * conv);
-ssize_t prot_write_cryptcompress(struct file *, const char __user *buf=
, size_t write_amount,
-				 loff_t * off);
-int mmap_cryptcompress(struct file *, struct vm_area_struct *);
-int prot_mmap_cryptcompress(struct file *, struct vm_area_struct *);
-
-int release_cryptcompress(struct inode *, struct file *);
-int prot_release_cryptcompress(struct inode *, struct file *);
-
-/* address space operations */
-extern int readpage_cryptcompress(struct file *, struct page *);
-extern int writepages_cryptcompress(struct address_space *,
-				     struct writeback_control *);
-/* file plugin operations */
-int flow_by_inode_cryptcompress(struct inode *, const char __user *buf=
,
-				int user, loff_t, loff_t, rw_op, flow_t *);
-int key_by_inode_cryptcompress(struct inode *, loff_t off, reiser4_key=
 *);
-int create_cryptcompress(struct inode *, struct inode *,
-			 reiser4_object_create_data *);
-int delete_object_cryptcompress(struct inode *);
-void init_inode_data_cryptcompress(struct inode *, reiser4_object_crea=
te_data *,
-				   int create);
-int cut_tree_worker_cryptcompress(tap_t *, const reiser4_key * from_ke=
y,
-				  const reiser4_key * to_key,
-				  reiser4_key * smallest_removed,
-				  struct inode *object, int truncate,
-				  int *progress);
-void destroy_inode_cryptcompress(struct inode *);
-int open_object_cryptcompress(struct inode * inode, struct file * file=
);
-
-extern reiser4_plugin_ops cryptcompress_plugin_ops;
-
 #define WRITE_GRANULARITY 32
=20
 int tail2extent(struct unix_file_info *);
diff -puN /dev/null /dev/null
diff -puN fs/reiser4/plugin/file_ops.c~reiser4-make-methods-supplied-to=
-vfs-invariant fs/reiser4/plugin/file_ops.c
--- a/fs/reiser4/plugin/file_ops.c~reiser4-make-methods-supplied-to-vfs=
-invariant
+++ a/fs/reiser4/plugin/file_ops.c
@@ -58,6 +58,43 @@ int reiser4_sync_common(struct file *fil
 	return result;
 }
=20
+/*
+ * common sync method for regular files.
+ *
+ * We are trying to be smart here. Instead of committing all atoms (or=
iginal
+ * solution), we scan dirty pages of this file and commit all atoms th=
ey are
+ * part of.
+ *
+ * Situation is complicated by anonymous pages: i.e., extent-less page=
s
+ * dirtied through mmap. Fortunately sys_fsync() first calls
+ * filemap_fdatawrite() that will ultimately call reiser4_writepages()=
, insert
+ * all missing extents and capture anonymous pages.
+ */
+int reiser4_sync_file_common(struct file *file,
+			     struct dentry *dentry, int datasync)
+{
+	reiser4_context *ctx;
+	txn_atom *atom;
+	reiser4_block_nr reserve;
+
+	ctx =3D reiser4_init_context(dentry->d_inode->i_sb);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	reserve =3D estimate_update_common(dentry->d_inode);
+	if (reiser4_grab_space(reserve, BA_CAN_COMMIT)) {
+		reiser4_exit_context(ctx);
+		return RETERR(-ENOSPC);
+	}
+	write_sd_by_inode_common(dentry->d_inode);
+
+	atom =3D get_current_atom_locked();
+	spin_lock_txnh(ctx->trans);
+	force_commit_atom(ctx->trans);
+	reiser4_exit_context(ctx);
+	return 0;
+}
+
 /* this is common implementation of vfs's sendfile method of struct
    file_operations
=20
diff -puN /dev/null /dev/null
diff -puN fs/reiser4/plugin/object.c~reiser4-make-methods-supplied-to-v=
fs-invariant fs/reiser4/plugin/object.c
--- a/fs/reiser4/plugin/object.c~reiser4-make-methods-supplied-to-vfs-i=
nvariant
+++ a/fs/reiser4/plugin/object.c
@@ -84,6 +84,92 @@ static reiser4_plugin_ops file_plugin_op
 	.change =3D change_file
 };
=20
+static struct inode_operations         null_i_ops =3D {.create =3D NUL=
L};
+static struct file_operations          null_f_ops =3D {.owner =3D NULL=
};
+static struct address_space_operations null_a_ops =3D {.writepage =3D =
NULL};
+
+/* VFS methods for regular files */
+static struct inode_operations regular_file_i_ops =3D {
+	.permission =3D reiser4_permission_common,
+	.setattr =3D reiser4_setattr_careful,
+	.getattr =3D reiser4_getattr_common
+};
+static struct file_operations regular_file_f_ops =3D {
+	.llseek =3D generic_file_llseek,
+	.read =3D reiser4_read_careful,
+	.write =3D reiser4_write_careful,
+	.aio_read =3D generic_file_aio_read,
+	.ioctl =3D reiser4_ioctl_careful,
+	.mmap =3D reiser4_mmap_careful,
+	.open =3D reiser4_open_careful,
+	.release =3D reiser4_release_careful,
+	.fsync =3D reiser4_sync_file_common
+};
+static struct address_space_operations regular_file_a_ops =3D {
+	.writepage =3D reiser4_writepage,
+	.readpage =3D reiser4_readpage,
+	.sync_page =3D block_sync_page,
+	.writepages =3D reiser4_writepages,
+	.set_page_dirty =3D reiser4_set_page_dirty,
+	.readpages =3D reiser4_readpages,
+	.prepare_write =3D reiser4_prepare_write,
+	.commit_write =3D	reiser4_commit_write,
+	.bmap =3D reiser4_bmap_careful,
+	.invalidatepage =3D reiser4_invalidatepage,
+	.releasepage =3D reiser4_releasepage
+};
+
+/* VFS methods for symlink files */
+static struct inode_operations symlink_file_i_ops =3D {
+	.readlink =3D generic_readlink,
+	.follow_link =3D reiser4_follow_link_common,
+	.permission =3D reiser4_permission_common,
+	.setattr =3D reiser4_setattr_common,
+	.getattr =3D reiser4_getattr_common
+};
+
+/* VFS methods for special files */
+static struct inode_operations special_file_i_ops =3D {
+	.permission =3D reiser4_permission_common,
+	.setattr =3D reiser4_setattr_common,
+	.getattr =3D reiser4_getattr_common
+};
+
+/* VFS methods for directories */
+static struct inode_operations directory_i_ops =3D {
+	.create =3D reiser4_create_common,
+	.lookup =3D reiser4_lookup_common,
+	.link =3D reiser4_link_common,
+	.unlink =3D reiser4_unlink_common,
+	.symlink =3D reiser4_symlink_common,
+	.mkdir =3D reiser4_mkdir_common,
+	.rmdir =3D reiser4_unlink_common,
+	.mknod =3D reiser4_mknod_common,
+	.rename =3D reiser4_rename_common,
+	.permission =3D reiser4_permission_common,
+	.setattr =3D reiser4_setattr_common,
+	.getattr =3D reiser4_getattr_common
+};
+static struct file_operations directory_f_ops =3D {
+	.llseek =3D reiser4_llseek_dir_common,
+	.read =3D generic_read_dir,
+	.readdir =3D reiser4_readdir_common,
+	.release =3D reiser4_release_dir_common,
+	.fsync =3D reiser4_sync_common
+};
+static struct address_space_operations directory_a_ops =3D {
+	.writepage =3D bugop,
+	.sync_page =3D bugop,
+	.writepages =3D dummyop,
+	.set_page_dirty =3D bugop,
+	.readpages =3D bugop,
+	.prepare_write =3D bugop,
+	.commit_write =3D bugop,
+	.bmap =3D bugop,
+	.invalidatepage =3D bugop,
+	.releasepage =3D bugop
+};
+
 /*
  * Definitions of object plugins.
  */
@@ -99,35 +185,37 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 			.desc =3D "regular file",
 			.linkage =3D {NULL, NULL},
 		},
-		.inode_ops =3D {
-			.permission =3D reiser4_permission_common,
-			.setattr =3D setattr_unix_file,
-			.getattr =3D reiser4_getattr_common
-		},
-		.file_ops =3D {
-			.llseek =3D generic_file_llseek,
-			.read =3D read_unix_file,
-			.write =3D write_unix_file,
-			.aio_read =3D generic_file_aio_read,
-			.ioctl =3D ioctl_unix_file,
-			.mmap =3D mmap_unix_file,
-			.open =3D open_unix_file,
-			.release =3D release_unix_file,
-			.fsync =3D sync_unix_file,
-		},
-		.as_ops =3D {
-			.writepage =3D reiser4_writepage,
-			.readpage =3D readpage_unix_file,
-			.sync_page =3D block_sync_page,
-			.writepages =3D writepages_unix_file,
-			.set_page_dirty =3D reiser4_set_page_dirty,
-			.readpages =3D readpages_unix_file,
-			.prepare_write =3D prepare_write_unix_file,
-			.commit_write =3D	commit_write_unix_file,
-			.bmap =3D bmap_unix_file,
-			.invalidatepage =3D reiser4_invalidatepage,
-			.releasepage =3D reiser4_releasepage
-		},
+		/*
+		 * invariant vfs ops
+		 */
+		.inode_ops =3D &regular_file_i_ops,
+		.file_ops =3D &regular_file_f_ops,
+		.as_ops =3D &regular_file_a_ops,
+		/*
+		 * private i_ops
+		 */
+		.setattr =3D setattr_unix_file,
+		.open =3D open_unix_file,
+		.read =3D read_unix_file,
+		.write =3D write_unix_file,
+		.ioctl =3D ioctl_unix_file,
+		.mmap =3D mmap_unix_file,
+		.release =3D release_unix_file,
+		/*
+		 * private f_ops
+		 */
+		.readpage =3D readpage_unix_file,
+		.readpages =3D readpages_unix_file,
+		.writepages =3D writepages_unix_file,
+		.prepare_write =3D prepare_write_unix_file,
+		.commit_write =3D commit_write_unix_file,
+		/*
+		 * private a_ops
+		 */
+		.bmap =3D bmap_unix_file,
+		/*
+		 * other private methods
+		 */
 		.write_sd_by_inode =3D write_sd_by_inode_common,
 		.flow_by_inode =3D flow_by_inode_unix_file,
 		.key_by_inode =3D key_by_inode_and_offset_common,
@@ -167,9 +255,9 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 			.desc =3D "directory",
 			.linkage =3D {NULL, NULL}
 		},
-		.inode_ops =3D {.create =3D NULL},
-		.file_ops =3D {.owner =3D NULL},
-		.as_ops =3D {.writepage =3D NULL},
+		.inode_ops =3D &null_i_ops,
+		.file_ops =3D &null_f_ops,
+		.as_ops =3D &null_a_ops,
=20
 		.write_sd_by_inode =3D write_sd_by_inode_common,
 		.flow_by_inode =3D bugop,
@@ -211,16 +299,11 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 			.desc =3D "symbolic link",
 			.linkage =3D {NULL,NULL}
 		},
-		.inode_ops =3D {
-			.readlink =3D generic_readlink,
-			.follow_link =3D reiser4_follow_link_common,
-			.permission =3D reiser4_permission_common,
-			.setattr =3D reiser4_setattr_common,
-			.getattr =3D reiser4_getattr_common
-		},
-		/* inode->i_fop of symlink is initialized by NULL in setup_inode_ops=
 */
-		.file_ops =3D {.owner =3D NULL},
-		.as_ops =3D {.writepage =3D NULL},
+		.inode_ops =3D &symlink_file_i_ops,
+		/* inode->i_fop of symlink is initialized
+		   by NULL in setup_inode_ops */
+		.file_ops =3D &null_f_ops,
+		.as_ops =3D &null_a_ops,
=20
 		.write_sd_by_inode =3D write_sd_by_inode_common,
 		.set_plug_in_inode =3D set_plug_in_inode_common,
@@ -260,15 +343,11 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 			"special: fifo, device or socket",
 			.linkage =3D {NULL, NULL}
 		},
-		.inode_ops =3D {
-			.permission =3D reiser4_permission_common,
-			.setattr =3D reiser4_setattr_common,
-			.getattr =3D reiser4_getattr_common
-		},
+		.inode_ops =3D &special_file_i_ops,
 		/* file_ops of special files (sockets, block, char, fifo) are
 		   initialized by init_special_inode. */
-		.file_ops =3D {.owner =3D NULL},
-		.as_ops =3D {.writepage =3D NULL},
+		.file_ops =3D &null_f_ops,
+		.as_ops =3D &null_a_ops,
=20
 		.write_sd_by_inode =3D write_sd_by_inode_common,
 		.set_plug_in_inode =3D set_plug_in_inode_common,
@@ -307,38 +386,32 @@ file_plugin file_plugins[LAST_FILE_PLUGI
 			.desc =3D "cryptcompress file",
 			.linkage =3D {NULL, NULL}
 		},
-		.inode_ops =3D {
-			.permission =3D reiser4_permission_common,
-			.setattr =3D prot_setattr_cryptcompress,
-			.getattr =3D reiser4_getattr_common
-		},
-		.file_ops =3D {
-			.llseek =3D generic_file_llseek,
-			.read =3D prot_read_cryptcompress,
-			.write =3D prot_write_cryptcompress,
-			.aio_read =3D generic_file_aio_read,
-			.mmap =3D prot_mmap_cryptcompress,
-			.release =3D prot_release_cryptcompress,
-			.fsync =3D reiser4_sync_common,
-		},
-		.as_ops =3D {
-			.writepage =3D reiser4_writepage,
-			.readpage =3D readpage_cryptcompress,
-			.sync_page =3D block_sync_page,
-			.writepages =3D writepages_cryptcompress,
-			.set_page_dirty =3D reiser4_set_page_dirty,
-			.readpages =3D readpages_cryptcompress,
-			.prepare_write =3D prepare_write_common,
-			.invalidatepage =3D reiser4_invalidatepage,
-			.releasepage =3D reiser4_releasepage
-		},
+		.inode_ops =3D &regular_file_i_ops,
+		.file_ops =3D &regular_file_f_ops,
+		.as_ops =3D &regular_file_a_ops,
+
+		.setattr =3D setattr_cryptcompress,
+		.open =3D open_cryptcompress,
+		.read =3D read_cryptcompress,
+		.write =3D write_cryptcompress,
+		.ioctl =3D ioctl_cryptcompress,
+		.mmap =3D mmap_cryptcompress,
+		.release =3D release_cryptcompress,
+
+		.readpage =3D readpage_cryptcompress,
+		.readpages =3D readpages_cryptcompress,
+		.writepages =3D writepages_cryptcompress,
+		.prepare_write =3D prepare_write_cryptcompress,
+		.commit_write =3D commit_write_cryptcompress,
+
+		.bmap =3D bmap_cryptcompress,
+
 		.write_sd_by_inode =3D write_sd_by_inode_common,
 		.flow_by_inode =3D flow_by_inode_cryptcompress,
 		.key_by_inode =3D key_by_inode_cryptcompress,
 		.set_plug_in_inode =3D set_plug_in_inode_common,
 		.adjust_to_parent =3D adjust_to_parent_cryptcompress,
-		.create_object =3D create_cryptcompress,
-		.open_object =3D open_object_cryptcompress,
+		.create_object =3D create_object_cryptcompress,
 		.delete_object =3D delete_object_cryptcompress,
 		.add_link =3D reiser4_add_link_common,
 		.rem_link =3D reiser4_rem_link_common,
@@ -392,39 +465,10 @@ dir_plugin dir_plugins[LAST_DIR_ID] =3D {
 			.desc =3D "hashed directory",
 			.linkage =3D {NULL, NULL}
 		},
-		.inode_ops =3D {
-			.create =3D reiser4_create_common,
-			.lookup =3D reiser4_lookup_common,
-			.link =3D reiser4_link_common,
-			.unlink =3D reiser4_unlink_common,
-			.symlink =3D reiser4_symlink_common,
-			.mkdir =3D reiser4_mkdir_common,
-			.rmdir =3D reiser4_unlink_common,
-			.mknod =3D reiser4_mknod_common,
-			.rename =3D reiser4_rename_common,
-			.permission =3D reiser4_permission_common,
-			.setattr =3D reiser4_setattr_common,
-			.getattr =3D reiser4_getattr_common
-		},
-		.file_ops =3D {
-			.llseek =3D reiser4_llseek_dir_common,
-			.read =3D generic_read_dir,
-			.readdir =3D reiser4_readdir_common,
-			.release =3D reiser4_release_dir_common,
-			.fsync =3D reiser4_sync_common
-		},
-		.as_ops =3D {
-			.writepage =3D bugop,
-			.sync_page =3D bugop,
-			.writepages =3D dummyop,
-			.set_page_dirty =3D bugop,
-			.readpages =3D bugop,
-			.prepare_write =3D bugop,
-			.commit_write =3D bugop,
-			.bmap =3D bugop,
-			.invalidatepage =3D bugop,
-			.releasepage =3D bugop
-		},
+		.inode_ops =3D &directory_i_ops,
+		.file_ops =3D &directory_f_ops,
+		.as_ops =3D &directory_a_ops,
+
 		.get_parent =3D get_parent_common,
 		.is_name_acceptable =3D is_name_acceptable_common,
 		.build_entry_key =3D build_entry_key_hashed,
@@ -452,39 +496,10 @@ dir_plugin dir_plugins[LAST_DIR_ID] =3D {
 			.desc =3D "directory hashed with 31 bit hash",
 			.linkage =3D {NULL, NULL}
 		},
-		.inode_ops =3D {
-			.create =3D reiser4_create_common,
-			.lookup =3D reiser4_lookup_common,
-			.link =3D reiser4_link_common,
-			.unlink =3D reiser4_unlink_common,
-			.symlink =3D reiser4_symlink_common,
-			.mkdir =3D reiser4_mkdir_common,
-			.rmdir =3D reiser4_unlink_common,
-			.mknod =3D reiser4_mknod_common,
-			.rename =3D reiser4_rename_common,
-			.permission =3D reiser4_permission_common,
-			.setattr =3D reiser4_setattr_common,
-			.getattr =3D reiser4_getattr_common
-		},
-		.file_ops =3D {
-			.llseek =3D reiser4_llseek_dir_common,
-			.read =3D	generic_read_dir,
-			.readdir =3D reiser4_readdir_common,
-			.release =3D reiser4_release_dir_common,
-			.fsync =3D reiser4_sync_common
-		},
-		.as_ops =3D {
-			.writepage =3D bugop,
-			.sync_page =3D bugop,
-			.writepages =3D dummyop,
-			.set_page_dirty =3D bugop,
-			.readpages =3D bugop,
-			.prepare_write =3D bugop,
-			.commit_write =3D bugop,
-			.bmap =3D bugop,
-			.invalidatepage =3D bugop,
-			.releasepage =3D bugop
-		},
+		.inode_ops =3D &directory_i_ops,
+		.file_ops =3D &directory_f_ops,
+		.as_ops =3D &directory_a_ops,
+
 		.get_parent =3D get_parent_common,
 		.is_name_acceptable =3D is_name_acceptable_common,
 		.build_entry_key =3D build_entry_key_seekable,
diff -puN /dev/null /dev/null
diff -puN fs/reiser4/plugin/plugin.h~reiser4-make-methods-supplied-to-v=
fs-invariant fs/reiser4/plugin/plugin.h
--- a/fs/reiser4/plugin/plugin.h~reiser4-make-methods-supplied-to-vfs-i=
nvariant
+++ a/fs/reiser4/plugin/plugin.h
@@ -199,20 +199,61 @@ typedef struct file_plugin {
 	/* generic fields */
 	plugin_header h;
=20
-	struct inode_operations inode_ops;
-	struct file_operations file_ops;
-	struct address_space_operations as_ops;
-
+	/* VFS methods.
+	 * Must be invariant with respect to plugin conversion.
+	 * It can be achieved by using "common" methods, which
+	 * are the same for all plugins that take participation in
+	 * conversion, or by using "generic" or "careful" methods,
+	 * which provide automatic redirection to proper private
+	 * plugin methods ("careful" are the same as "generic",
+	 * but with protection of pset and other disk structures
+	 * from being rebuilt during conversion.
+	 */
+	struct inode_operations * inode_ops;
+	struct file_operations * file_ops;
+	struct address_space_operations * as_ops;
+	/**
+	 * Private methods. These are optional. If used they will allow you
+	 * to minimize the amount of code needed to implement a deviation
+	 * from some other method that also uses them.
+	 */
+	/*
+	 * private inode_ops
+	 */
+	int (*setattr)(struct dentry *, struct iattr *);
+	/*
+	 * private file_ops
+	 */
+	/* do whatever is necessary to do when object is opened */
+	int (*open) (struct inode * inode, struct file * file);
+	ssize_t (*read) (struct file *, char __user *buf, size_t read_amount,
+			loff_t *off);
+	/* write a file;
+	 * perform file plugin conversion (if needed);
+	 * set @*conv to 1, if the conversion occurred */
+	ssize_t (*write) (struct file *, const char __user *buf,
+			  size_t write_amount, loff_t * off, int * conv);
+	int (*ioctl) (struct inode *inode, struct file *filp,
+		      unsigned int cmd, unsigned long arg);
+	int (*mmap) (struct file *, struct vm_area_struct *);
+	int (*release) (struct inode *, struct file *);
+	/*
+	 * private a_ops
+	 */
+	int (*readpage) (struct file *file, struct page *page);
+	int (*readpages)(struct file *file, struct address_space *mapping,
+			  struct list_head *pages, unsigned nr_pages);
+	int (*writepages)(struct address_space *mapping,
+			  struct writeback_control *wbc);
+	int (*prepare_write)(struct file *file, struct page *page,
+			     unsigned from, unsigned to);
+	int (*commit_write)(struct file *file, struct page *page,
+			    unsigned from, unsigned to);
+	sector_t (*bmap) (struct address_space * mapping, sector_t lblock);
+	/* other private methods */
 	/* save inode cached stat-data onto disk. It was called
 	   reiserfs_update_sd() in 3.x */
 	int (*write_sd_by_inode) (struct inode *);
-
-	/*
-	 * private methods: These are optional.  If used they will allow you =
to
-	 * minimize the amount of code needed to implement a deviation from
-	 * some other method that also uses them.
-	 */
-
 	/*
 	 * Construct flow into @flow according to user-supplied data.
 	 *
@@ -242,7 +283,6 @@ typedef struct file_plugin {
 	int (*flow_by_inode) (struct inode *, const char __user *buf,
 			      int user, loff_t size,
 			      loff_t off, rw_op op, flow_t *);
-
 	/*
 	 * Return the key used to retrieve an offset of a file. It is used by
 	 * default implementation of ->flow_by_inode() method
@@ -273,9 +313,6 @@ typedef struct file_plugin {
 	 */
 	int (*create_object) (struct inode *object, struct inode *parent,
 			      reiser4_object_create_data *);
-
-	/* this does whatever is necessary to do when object is opened */
-	int (*open_object) (struct inode * inode, struct file * file);
 	/*
 	 * this method should check REISER4_NO_SD and set REISER4_NO_SD on
 	 * success. Deletion of an object usually includes removal of items
@@ -397,9 +434,9 @@ typedef struct dir_plugin {
 	/* generic fields */
 	plugin_header h;
=20
-	struct inode_operations inode_ops;
-	struct file_operations file_ops;
-	struct address_space_operations as_ops;
+	struct inode_operations * inode_ops;
+	struct file_operations * file_ops;
+	struct address_space_operations * as_ops;
=20
 	/*
 	 * private methods: These are optional.  If used they will allow you =
to
diff -puN /dev/null /dev/null
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
reiser4-make-methods-supplied-to-vfs-invariant.patch
reiser4-new-export-ops.patch
