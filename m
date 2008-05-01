From: akpm@linux-foundation.org
Subject: - reiser4-new-export-ops-update.patch removed from -mm tree
Date: Thu, 01 May 2008 02:23:17 -0700
Message-ID: <200805010923.m419NHoT030082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755140AbYEAJXs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:23:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward.shishkin@gmail.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: new export ops (update)
has been removed from the -mm tree.  Its filename was
     reiser4-new-export-ops-update.patch

This patch was dropped because it was folded into reiser4.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: reiser4: new export ops (update)
From: Edward Shishkin <edward.shishkin@gmail.com>

Signed-off-by: Edward Shishkin <edward.shishkin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiser4/export_ops.c |   92 +++++++++++++++++++++++---------------
 fs/reiser4/kassign.c    |    1 
 2 files changed, 57 insertions(+), 36 deletions(-)

diff -puN fs/reiser4/export_ops.c~reiser4-new-export-ops-update fs/reiser4/export_ops.c
--- a/fs/reiser4/export_ops.c~reiser4-new-export-ops-update
+++ a/fs/reiser4/export_ops.c
@@ -29,8 +29,7 @@ static void object_on_wire_done(reiser4_
 
 /*
  * read serialized object identity from @addr and store information about
- * object in @obj. If @obj == NULL, then don't read, just skip the encoded
- * object (only return updated position).
+ * object in @obj. This is dual to encode_inode().
  */
 static char *decode_inode(struct super_block *s, char *addr,
 			  reiser4_object_on_wire * obj)
@@ -42,8 +41,7 @@ static char *decode_inode(struct super_b
 	fplug = file_plugin_by_disk_id(reiser4_get_tree(s), (d16 *) addr);
 	if (fplug != NULL) {
 		addr += sizeof(d16);
-		if (obj)
-			obj->plugin = fplug;
+		obj->plugin = fplug;
 		assert("nikita-3520", fplug->wire.read != NULL);
 		/* plugin specific encoding of object identity. */
 		addr = fplug->wire.read(addr, obj);
@@ -55,49 +53,30 @@ static char *decode_inode(struct super_b
 static struct dentry *reiser4_get_dentry(struct super_block *super,
 					 void *data);
 /**
- * reiser4_decode_fh: decode onwire object - helper function
+ * reiser4_decode_fh: decode on-wire object - helper function
  * for fh_to_dentry, fh_to_parent export operations;
  * @super: super block;
- * @fh: here are onwire objects to be extracted for decoding;
- * @parent: skip first onwire object and decode parent.
+ * @addr: onwire object to be decoded;
  *
  * Returns dentry referring to the object being decoded.
  */
-static struct dentry *reiser4_decode_fh(struct super_block *super, __u32 *fh,
-					int len, int fhtype, int parent)
+static struct dentry *reiser4_decode_fh(struct super_block * super,
+					char * addr)
 {
-	reiser4_context *ctx;
 	reiser4_object_on_wire object;
-	char *addr;
-
-	ctx = reiser4_init_context(super);
-	if (IS_ERR(ctx))
-		return (struct dentry *)ctx;
-
-	assert("vs-1482",
-	       fhtype == FH_WITH_PARENT || fhtype == FH_WITHOUT_PARENT);
-
-	addr = (char *)fh;
 
 	object_on_wire_init(&object);
 
-	if (parent)
-		/* skip first onwire object */
-		addr = decode_inode(super, addr, NULL);
+	addr = decode_inode(super, addr, &object);
 	if (!IS_ERR(addr)) {
-		addr = decode_inode(super, addr, &object);
-		if (!IS_ERR(addr)) {
-			struct dentry *d;
-
-			d = reiser4_get_dentry(super, &object);
-			if (d != NULL && !IS_ERR(d))
-				/* FIXME check for -ENOMEM */
-			  	reiser4_get_dentry_fsdata(d)->stateless = 1;
-			addr = (char *)d;
-		}
+		struct dentry *d;
+		d = reiser4_get_dentry(super, &object);
+		if (d != NULL && !IS_ERR(d))
+			/* FIXME check for -ENOMEM */
+			reiser4_get_dentry_fsdata(d)->stateless = 1;
+		addr = (char *)d;
 	}
 	object_on_wire_done(&object);
-	reiser4_exit_context(ctx);
 	return (void *)addr;
 }
 
@@ -105,16 +84,57 @@ static struct dentry *reiser4_fh_to_dent
 					   struct fid *fid,
 					   int fh_len, int fh_type)
 {
-	return reiser4_decode_fh(sb, fid->raw, fh_len, fh_type, 0);
+	reiser4_context *ctx;
+	struct dentry *d;
+
+	assert("edward-1536",
+	       fh_type == FH_WITH_PARENT || fh_type == FH_WITHOUT_PARENT);
+
+	ctx = reiser4_init_context(sb);
+	if (IS_ERR(ctx))
+		return (struct dentry *)ctx;
+
+	d = reiser4_decode_fh(sb, (char *)fid->raw);
+
+	reiser4_exit_context(ctx);
+	return d;
 }
 
 static struct dentry *reiser4_fh_to_parent(struct super_block *sb,
 					   struct fid *fid,
 					   int fh_len, int fh_type)
 {
+	char * addr;
+	struct dentry * d;
+	reiser4_context *ctx;
+	file_plugin *fplug;
+
 	if (fh_type == FH_WITHOUT_PARENT)
 		return NULL;
-	return reiser4_decode_fh(sb, fid->raw, fh_len, fh_type, 1);
+	assert("edward-1537", fh_type == FH_WITH_PARENT);
+
+	ctx = reiser4_init_context(sb);
+	if (IS_ERR(ctx))
+		return (struct dentry *)ctx;
+	addr = (char *)fid->raw;
+	/* extract 2-bytes file plugin id */
+	fplug = file_plugin_by_disk_id(reiser4_get_tree(sb), (d16 *)addr);
+	if (fplug == NULL) {
+		d = ERR_PTR(RETERR(-EINVAL));
+		goto exit;
+	}
+	addr += sizeof(d16);
+	/* skip previously encoded object */
+	addr = fplug->wire.read(addr, NULL /* skip */);
+	if (IS_ERR(addr)) {
+		d = (struct dentry *)addr;
+		goto exit;
+	}
+	/* @extract and decode parent object */
+	d = reiser4_decode_fh(sb, addr);
+ exit:
+	reiser4_exit_context(ctx);
+	return d;
 }
 
 /*
diff -puN fs/reiser4/kassign.c~reiser4-new-export-ops-update fs/reiser4/kassign.c
--- a/fs/reiser4/kassign.c~reiser4-new-export-ops-update
+++ a/fs/reiser4/kassign.c
@@ -652,6 +652,7 @@ char *extract_obj_key_id_from_onwire(cha
 
 /*
  * skip a key that was previously encoded by build_inode_onwire() at @addr
+ * FIXME: handle IO errors.
  */
 char * locate_obj_key_id_onwire(char * addr)
 {
_

Patches currently in -mm which might be from edward.shishkin@gmail.com are

origin.patch
reiser4.patch
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

