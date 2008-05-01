From: akpm@linux-foundation.org
Subject: - reiser4-new-export-ops.patch removed from -mm tree
Date: Thu, 01 May 2008 02:23:15 -0700
Message-ID: <200805010923.m419NFOC030079@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754951AbYEAJXp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:23:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: new export ops
has been removed from the -mm tree.  Its filename was
     reiser4-new-export-ops.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: new export ops
From: Edward Shishkin <edward.shishkin@gmail.com>

Adjust reiser4 for the new export ops.

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/dscale.c                    |   20 ++++++
 fs/reiser4/dscale.h                    |    3 
 fs/reiser4/export_ops.c                |   72 +++++++++++------------
 fs/reiser4/kassign.c                   |   19 +++++-
 fs/reiser4/kassign.h                   |    1 
 fs/reiser4/plugin/file_plugin_common.c |    2 
 6 files changed, 78 insertions(+), 39 deletions(-)

diff -puN fs/reiser4/dscale.c~reiser4-new-export-ops fs/reiser4/dscale.c
--- a/fs/reiser4/dscale.c~reiser4-new-export-ops
+++ a/fs/reiser4/dscale.c
@@ -126,6 +126,24 @@ int dscale_read(unsigned char *address, 
 	return 1 << tag;
 }
 
+/* number of bytes consumed */
+int dscale_bytes_to_read(unsigned char *address)
+{
+	int tag;
+
+	tag = gettag(address);
+	switch (tag) {
+	case 0:
+	case 1:
+	case 2:
+		return 1 << tag;
+	case 3:
+		return 9;
+	default:
+		return RETERR(-EIO);
+	}
+}
+
 /* store @value at @address and return number of bytes consumed */
 int dscale_write(unsigned char *address, __u64 value)
 {
@@ -144,7 +162,7 @@ int dscale_write(unsigned char *address,
 }
 
 /* number of bytes required to store @value */
-int dscale_bytes(__u64 value)
+int dscale_bytes_to_write(__u64 value)
 {
 	int bytes;
 
diff -puN fs/reiser4/dscale.h~reiser4-new-export-ops fs/reiser4/dscale.h
--- a/fs/reiser4/dscale.h~reiser4-new-export-ops
+++ a/fs/reiser4/dscale.h
@@ -10,7 +10,8 @@
 
 extern int dscale_read(unsigned char *address, __u64 * value);
 extern int dscale_write(unsigned char *address, __u64 value);
-extern int dscale_bytes(__u64 value);
+extern int dscale_bytes_to_read(unsigned char *address);
+extern int dscale_bytes_to_write(__u64 value);
 extern int dscale_fit(__u64 value, __u64 other);
 
 /* __FS_REISER4_DSCALE_H__ */
diff -puN fs/reiser4/export_ops.c~reiser4-new-export-ops fs/reiser4/export_ops.c
--- a/fs/reiser4/export_ops.c~reiser4-new-export-ops
+++ a/fs/reiser4/export_ops.c
@@ -29,7 +29,8 @@ static void object_on_wire_done(reiser4_
 
 /*
  * read serialized object identity from @addr and store information about
- * object in @obj. This is dual to encode_inode().
+ * object in @obj. If @obj == NULL, then don't read, just skip the encoded
+ * object (only return updated position).
  */
 static char *decode_inode(struct super_block *s, char *addr,
 			  reiser4_object_on_wire * obj)
@@ -41,7 +42,8 @@ static char *decode_inode(struct super_b
 	fplug = file_plugin_by_disk_id(reiser4_get_tree(s), (d16 *) addr);
 	if (fplug != NULL) {
 		addr += sizeof(d16);
-		obj->plugin = fplug;
+		if (obj)
+			obj->plugin = fplug;
 		assert("nikita-3520", fplug->wire.read != NULL);
 		/* plugin specific encoding of object identity. */
 		addr = fplug->wire.read(addr, obj);
@@ -50,28 +52,23 @@ static char *decode_inode(struct super_b
 	return addr;
 }
 
+static struct dentry *reiser4_get_dentry(struct super_block *super,
+					 void *data);
 /**
- * reiser4_decode_fh - decode_fh of export operations
- * @super: super block
- * @fh: nfsd file handle
- * @len: length of file handle
- * @fhtype: type of file handle
- * @acceptable: acceptability testing function
- * @context: argument for @acceptable
+ * reiser4_decode_fh: decode onwire object - helper function
+ * for fh_to_dentry, fh_to_parent export operations;
+ * @super: super block;
+ * @fh: here are onwire objects to be extracted for decoding;
+ * @parent: skip first onwire object and decode parent.
  *
- * Returns dentry referring to the same file as @fh.
+ * Returns dentry referring to the object being decoded.
  */
 static struct dentry *reiser4_decode_fh(struct super_block *super, __u32 *fh,
-					int len, int fhtype,
-					int (*acceptable) (void *context,
-							   struct dentry *de),
-					void *context)
+					int len, int fhtype, int parent)
 {
 	reiser4_context *ctx;
 	reiser4_object_on_wire object;
-	reiser4_object_on_wire parent;
 	char *addr;
-	int with_parent;
 
 	ctx = reiser4_init_context(super);
 	if (IS_ERR(ctx))
@@ -80,25 +77,19 @@ static struct dentry *reiser4_decode_fh(
 	assert("vs-1482",
 	       fhtype == FH_WITH_PARENT || fhtype == FH_WITHOUT_PARENT);
 
-	with_parent = (fhtype == FH_WITH_PARENT);
-
 	addr = (char *)fh;
 
 	object_on_wire_init(&object);
-	object_on_wire_init(&parent);
-#if 0
-	addr = decode_inode(super, addr, &object);
+
+	if (parent)
+		/* skip first onwire object */
+		addr = decode_inode(super, addr, NULL);
 	if (!IS_ERR(addr)) {
-		if (with_parent)
-			addr = decode_inode(super, addr, &parent);
+		addr = decode_inode(super, addr, &object);
 		if (!IS_ERR(addr)) {
 			struct dentry *d;
-			typeof(super->s_export_op->find_exported_dentry) fn;
 
-			fn = super->s_export_op->find_exported_dentry;
-			assert("nikita-3521", fn != NULL);
-			d = fn(super, &object, with_parent ? &parent : NULL,
-			       acceptable, context);
+			d = reiser4_get_dentry(super, &object);
 			if (d != NULL && !IS_ERR(d))
 				/* FIXME check for -ENOMEM */
 			  	reiser4_get_dentry_fsdata(d)->stateless = 1;
@@ -106,13 +97,24 @@ static struct dentry *reiser4_decode_fh(
 		}
 	}
 	object_on_wire_done(&object);
-	object_on_wire_done(&parent);
-
 	reiser4_exit_context(ctx);
 	return (void *)addr;
-#else
-	return ERR_PTR(-EINVAL);
-#endif
+}
+
+static struct dentry *reiser4_fh_to_dentry(struct super_block *sb,
+					   struct fid *fid,
+					   int fh_len, int fh_type)
+{
+	return reiser4_decode_fh(sb, fid->raw, fh_len, fh_type, 0);
+}
+
+static struct dentry *reiser4_fh_to_parent(struct super_block *sb,
+					   struct fid *fid,
+					   int fh_len, int fh_type)
+{
+	if (fh_type == FH_WITHOUT_PARENT)
+		return NULL;
+	return reiser4_decode_fh(sb, fid->raw, fh_len, fh_type, 1);
 }
 
 /*
@@ -281,9 +283,9 @@ static struct dentry *reiser4_get_dentry
 
 struct export_operations reiser4_export_operations = {
 	.encode_fh = reiser4_encode_fh,
-//	.decode_fh = reiser4_decode_fh,
+	.fh_to_dentry = reiser4_fh_to_dentry,
+	.fh_to_parent = reiser4_fh_to_parent,
 	.get_parent = reiser4_get_dentry_parent,
-//	.get_dentry = reiser4_get_dentry
 };
 
 /*
diff -puN fs/reiser4/kassign.c~reiser4-new-export-ops fs/reiser4/kassign.c
--- a/fs/reiser4/kassign.c~reiser4-new-export-ops
+++ a/fs/reiser4/kassign.c
@@ -604,8 +604,8 @@ int inode_onwire_size(const struct inode
 {
 	int result;
 
-	result = dscale_bytes(get_inode_oid(inode));
-	result += dscale_bytes(get_inode_locality(inode));
+	result = dscale_bytes_to_write(get_inode_oid(inode));
+	result += dscale_bytes_to_write(get_inode_locality(inode));
 
 	/*
 	 * ordering is large (it usually has highest bits set), so it makes
@@ -650,6 +650,21 @@ char *extract_obj_key_id_from_onwire(cha
 	return addr;
 }
 
+/*
+ * skip a key that was previously encoded by build_inode_onwire() at @addr
+ */
+char * locate_obj_key_id_onwire(char * addr)
+{
+	/* locality */
+	addr += dscale_bytes_to_read(addr);
+	/* objectid */
+	addr += dscale_bytes_to_read(addr);
+#if REISER4_LARGE_KEY
+	addr += sizeof ((obj_key_id *)0)->ordering;
+#endif
+	return addr;
+}
+
 /* Make Linus happy.
    Local variables:
    c-indentation-style: "K&R"
diff -puN fs/reiser4/kassign.h~reiser4-new-export-ops fs/reiser4/kassign.h
--- a/fs/reiser4/kassign.h~reiser4-new-export-ops
+++ a/fs/reiser4/kassign.h
@@ -64,6 +64,7 @@ de_id;
 
 extern int inode_onwire_size(const struct inode *obj);
 extern char *build_inode_onwire(const struct inode *obj, char *area);
+extern char *locate_obj_key_id_onwire(char *area);
 extern char *extract_obj_key_id_from_onwire(char *area, obj_key_id * key_id);
 
 extern int build_inode_key_id(const struct inode *obj, obj_key_id * id);
diff -puN fs/reiser4/plugin/file_plugin_common.c~reiser4-new-export-ops fs/reiser4/plugin/file_plugin_common.c
--- a/fs/reiser4/plugin/file_plugin_common.c~reiser4-new-export-ops
+++ a/fs/reiser4/plugin/file_plugin_common.c
@@ -459,6 +459,8 @@ char *wire_write_common(struct inode *in
 
 char *wire_read_common(char *addr, reiser4_object_on_wire * obj)
 {
+	if (!obj)
+		return locate_obj_key_id_onwire(addr);
 	return extract_obj_key_id_from_onwire(addr, &obj->u.std.key_id);
 }
 
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

origin.patch
reiser4.patch
reiser4-new-export-ops.patch
reiser4-new-export-ops-update.patch
reiser4-new-export_ops-fixup.patch
reiser4-specify-splice-file-operations.patch
reiser4-fix-dummy-ioctl_cryptcompress.patch
reiser4-granulate-rw-serialization-when-accessing-file-conversion-set.patch
reiser4-fix-disk-cluster-synchronization.patch
reiser4-use-balance_dirty_pages_ratelimited_nr.patch
reiser4-correct-references-to-filemap_nopage.patch
reiser4-fix-null-pointer-dereference-in-reiser4_write_extent.patch
reiser4-code-cleanups.patch

