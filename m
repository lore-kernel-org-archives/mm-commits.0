From: akpm@linux-foundation.org
Subject: - convert-err_ptrptr_errp-instances-to-err_castp.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:07:01 -0800
Message-ID: <200802080806.m1886gTL014475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36727 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932307AbYBHIT7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Convert ERR_PTR(PTR_ERR(p)) instances to ERR_CAST(p)
has been removed from the -mm tree.  Its filename was
     convert-err_ptrptr_errp-instances-to-err_castp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Convert ERR_PTR(PTR_ERR(p)) instances to ERR_CAST(p)
From: David Howells <dhowells@redhat.com>

Convert instances of ERR_PTR(PTR_ERR(p)) to ERR_CAST(p) using:

perl -spi -e 's/ERR_PTR[(]PTR_ERR[(](.*)[)][)]/ERR_CAST(\1)/' `grep -rl 'ERR_PTR[(]*PTR_ERR' fs crypto net security`

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/cbc.c                     |    2 +-
 crypto/cryptd.c                  |    4 ++--
 crypto/ecb.c                     |    2 +-
 crypto/hmac.c                    |    2 +-
 crypto/lrw.c                     |    2 +-
 crypto/pcbc.c                    |    2 +-
 crypto/xcbc.c                    |    2 +-
 fs/9p/vfs_inode.c                |    2 +-
 fs/affs/namei.c                  |    2 +-
 fs/afs/dir.c                     |    4 ++--
 fs/afs/security.c                |    2 +-
 fs/fat/inode.c                   |    2 +-
 fs/fuse/dir.c                    |    6 +++---
 fs/gfs2/dir.c                    |    2 +-
 fs/gfs2/ops_export.c             |    2 +-
 fs/gfs2/ops_inode.c              |    2 +-
 fs/jffs2/write.c                 |    4 ++--
 fs/nfs/getroot.c                 |    4 ++--
 fs/nfsd/export.c                 |    4 ++--
 fs/quota.c                       |    4 ++--
 fs/reiserfs/inode.c              |    2 +-
 fs/reiserfs/xattr.c              |    4 ++--
 fs/vfat/namei.c                  |    2 +-
 net/rxrpc/af_rxrpc.c             |    6 +++---
 security/keys/key.c              |    2 +-
 security/keys/process_keys.c     |    2 +-
 security/keys/request_key.c      |    2 +-
 security/keys/request_key_auth.c |    2 +-
 28 files changed, 39 insertions(+), 39 deletions(-)

diff -puN crypto/cbc.c~convert-err_ptrptr_errp-instances-to-err_castp crypto/cbc.c
--- a/crypto/cbc.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/crypto/cbc.c
@@ -224,7 +224,7 @@ static struct crypto_instance *crypto_cb
 	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
-		return ERR_PTR(PTR_ERR(alg));
+		return ERR_CAST(alg);
 
 	inst = ERR_PTR(-EINVAL);
 	if (!is_power_of_2(alg->cra_blocksize))
diff -puN crypto/cryptd.c~convert-err_ptrptr_errp-instances-to-err_castp crypto/cryptd.c
--- a/crypto/cryptd.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/crypto/cryptd.c
@@ -230,7 +230,7 @@ static struct crypto_instance *cryptd_al
 	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_BLKCIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
-		return ERR_PTR(PTR_ERR(alg));
+		return ERR_CAST(alg);
 
 	inst = cryptd_alloc_instance(alg, state);
 	if (IS_ERR(inst))
@@ -267,7 +267,7 @@ static struct crypto_instance *cryptd_al
 
 	algt = crypto_get_attr_type(tb);
 	if (IS_ERR(algt))
-		return ERR_PTR(PTR_ERR(algt));
+		return ERR_CAST(algt);
 
 	switch (algt->type & algt->mask & CRYPTO_ALG_TYPE_MASK) {
 	case CRYPTO_ALG_TYPE_BLKCIPHER:
diff -puN crypto/ecb.c~convert-err_ptrptr_errp-instances-to-err_castp crypto/ecb.c
--- a/crypto/ecb.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/crypto/ecb.c
@@ -128,7 +128,7 @@ static struct crypto_instance *crypto_ec
 	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
-		return ERR_PTR(PTR_ERR(alg));
+		return ERR_CAST(alg);
 
 	inst = crypto_alloc_instance("ecb", alg);
 	if (IS_ERR(inst))
diff -puN crypto/hmac.c~convert-err_ptrptr_errp-instances-to-err_castp crypto/hmac.c
--- a/crypto/hmac.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/crypto/hmac.c
@@ -213,7 +213,7 @@ static struct crypto_instance *hmac_allo
 	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_HASH,
 				  CRYPTO_ALG_TYPE_HASH_MASK);
 	if (IS_ERR(alg))
-		return ERR_PTR(PTR_ERR(alg));
+		return ERR_CAST(alg);
 
 	inst = crypto_alloc_instance("hmac", alg);
 	if (IS_ERR(inst))
diff -puN crypto/lrw.c~convert-err_ptrptr_errp-instances-to-err_castp crypto/lrw.c
--- a/crypto/lrw.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/crypto/lrw.c
@@ -241,7 +241,7 @@ static struct crypto_instance *alloc(str
 	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
-		return ERR_PTR(PTR_ERR(alg));
+		return ERR_CAST(alg);
 
 	inst = crypto_alloc_instance("lrw", alg);
 	if (IS_ERR(inst))
diff -puN crypto/pcbc.c~convert-err_ptrptr_errp-instances-to-err_castp crypto/pcbc.c
--- a/crypto/pcbc.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/crypto/pcbc.c
@@ -234,7 +234,7 @@ static struct crypto_instance *crypto_pc
 	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
-		return ERR_PTR(PTR_ERR(alg));
+		return ERR_CAST(alg);
 
 	inst = crypto_alloc_instance("pcbc", alg);
 	if (IS_ERR(inst))
diff -puN crypto/xcbc.c~convert-err_ptrptr_errp-instances-to-err_castp crypto/xcbc.c
--- a/crypto/xcbc.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/crypto/xcbc.c
@@ -301,7 +301,7 @@ static struct crypto_instance *xcbc_allo
 	alg = crypto_get_attr_alg(tb, CRYPTO_ALG_TYPE_CIPHER,
 				  CRYPTO_ALG_TYPE_MASK);
 	if (IS_ERR(alg))
-		return ERR_PTR(PTR_ERR(alg));
+		return ERR_CAST(alg);
 
 	switch(alg->cra_blocksize) {
 	case 16:
diff -puN fs/9p/vfs_inode.c~convert-err_ptrptr_errp-instances-to-err_castp fs/9p/vfs_inode.c
--- a/fs/9p/vfs_inode.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/fs/9p/vfs_inode.c
@@ -568,7 +568,7 @@ static struct dentry *v9fs_vfs_lookup(st
 	v9ses = v9fs_inode2v9ses(dir);
 	dfid = v9fs_fid_lookup(dentry->d_parent);
 	if (IS_ERR(dfid))
-		return ERR_PTR(PTR_ERR(dfid));
+		return ERR_CAST(dfid);
 
 	name = (char *) dentry->d_name.name;
 	fid = p9_client_walk(dfid, 1, &name, 1);
diff -puN fs/affs/namei.c~convert-err_ptrptr_errp-instances-to-err_castp fs/affs/namei.c
--- a/fs/affs/namei.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/fs/affs/namei.c
@@ -209,7 +209,7 @@ affs_lookup(struct inode *dir, struct de
 	bh = affs_find_entry(dir, dentry);
 	affs_unlock_dir(dir);
 	if (IS_ERR(bh)) {
-		return ERR_PTR(PTR_ERR(bh));
+		return ERR_CAST(bh);
 	}
 	if (bh) {
 		u32 ino = bh->b_blocknr;
diff -puN fs/afs/dir.c~convert-err_ptrptr_errp-instances-to-err_castp fs/afs/dir.c
--- a/fs/afs/dir.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/fs/afs/dir.c
@@ -512,7 +512,7 @@ static struct dentry *afs_lookup(struct 
 	key = afs_request_key(vnode->volume->cell);
 	if (IS_ERR(key)) {
 		_leave(" = %ld [key]", PTR_ERR(key));
-		return ERR_PTR(PTR_ERR(key));
+		return ERR_CAST(key);
 	}
 
 	ret = afs_validate(vnode, key);
@@ -540,7 +540,7 @@ static struct dentry *afs_lookup(struct 
 	key_put(key);
 	if (IS_ERR(inode)) {
 		_leave(" = %ld", PTR_ERR(inode));
-		return ERR_PTR(PTR_ERR(inode));
+		return ERR_CAST(inode);
 	}
 
 	dentry->d_op = &afs_fs_dentry_operations;
diff -puN fs/afs/security.c~convert-err_ptrptr_errp-instances-to-err_castp fs/afs/security.c
--- a/fs/afs/security.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/fs/afs/security.c
@@ -95,7 +95,7 @@ static struct afs_vnode *afs_get_auth_in
 		auth_inode = afs_iget(vnode->vfs_inode.i_sb, key,
 				      &vnode->status.parent, NULL, NULL);
 		if (IS_ERR(auth_inode))
-			return ERR_PTR(PTR_ERR(auth_inode));
+			return ERR_CAST(auth_inode);
 	}
 
 	auth_vnode = AFS_FS_I(auth_inode);
diff -puN fs/fat/inode.c~convert-err_ptrptr_errp-instances-to-err_castp fs/fat/inode.c
--- a/fs/fat/inode.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/fs/fat/inode.c
@@ -760,7 +760,7 @@ static struct dentry *fat_get_parent(str
 	inode = fat_build_inode(child->d_sb, de, i_pos);
 	brelse(bh);
 	if (IS_ERR(inode)) {
-		parent = ERR_PTR(PTR_ERR(inode));
+		parent = ERR_CAST(inode);
 		goto out;
 	}
 	parent = d_alloc_anon(inode);
diff -puN fs/fuse/dir.c~convert-err_ptrptr_errp-instances-to-err_castp fs/fuse/dir.c
--- a/fs/fuse/dir.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/fs/fuse/dir.c
@@ -269,12 +269,12 @@ static struct dentry *fuse_lookup(struct
 
 	req = fuse_get_req(fc);
 	if (IS_ERR(req))
-		return ERR_PTR(PTR_ERR(req));
+		return ERR_CAST(req);
 
 	forget_req = fuse_get_req(fc);
 	if (IS_ERR(forget_req)) {
 		fuse_put_request(fc, req);
-		return ERR_PTR(PTR_ERR(forget_req));
+		return ERR_CAST(forget_req);
 	}
 
 	attr_version = fuse_get_attr_version(fc);
@@ -1006,7 +1006,7 @@ static char *read_link(struct dentry *de
 	char *link;
 
 	if (IS_ERR(req))
-		return ERR_PTR(PTR_ERR(req));
+		return ERR_CAST(req);
 
 	link = (char *) __get_free_page(GFP_KERNEL);
 	if (!link) {
diff -puN fs/gfs2/dir.c~convert-err_ptrptr_errp-instances-to-err_castp fs/gfs2/dir.c
--- a/fs/gfs2/dir.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/fs/gfs2/dir.c
@@ -1498,7 +1498,7 @@ struct inode *gfs2_dir_search(struct ino
 	dent = gfs2_dirent_search(dir, name, gfs2_dirent_find, &bh);
 	if (dent) {
 		if (IS_ERR(dent))
-			return ERR_PTR(PTR_ERR(dent));
+			return ERR_CAST(dent);
 		inode = gfs2_inode_lookup(dir->i_sb, 
 				be16_to_cpu(dent->de_type),
 				be64_to_cpu(dent->de_inum.no_addr),
diff -puN fs/gfs2/ops_export.c~convert-err_ptrptr_errp-instances-to-err_castp fs/gfs2/ops_export.c
--- a/fs/gfs2/ops_export.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/fs/gfs2/ops_export.c
@@ -143,7 +143,7 @@ static struct dentry *gfs2_get_parent(st
 	 * have to return that as a(n invalid) pointer to dentry.
 	 */
 	if (IS_ERR(inode))
-		return ERR_PTR(PTR_ERR(inode));
+		return ERR_CAST(inode);
 
 	dentry = d_alloc_anon(inode);
 	if (!dentry) {
diff -puN fs/gfs2/ops_inode.c~convert-err_ptrptr_errp-instances-to-err_castp fs/gfs2/ops_inode.c
--- a/fs/gfs2/ops_inode.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/fs/gfs2/ops_inode.c
@@ -111,7 +111,7 @@ static struct dentry *gfs2_lookup(struct
 
 	inode = gfs2_lookupi(dir, &dentry->d_name, 0, nd);
 	if (inode && IS_ERR(inode))
-		return ERR_PTR(PTR_ERR(inode));
+		return ERR_CAST(inode);
 
 	if (inode) {
 		struct gfs2_glock *gl = GFS2_I(inode)->i_gl;
diff -puN fs/jffs2/write.c~convert-err_ptrptr_errp-instances-to-err_castp fs/jffs2/write.c
--- a/fs/jffs2/write.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/fs/jffs2/write.c
@@ -177,7 +177,7 @@ struct jffs2_full_dnode *jffs2_write_dno
 		void *hold_err = fn->raw;
 		/* Release the full_dnode which is now useless, and return */
 		jffs2_free_full_dnode(fn);
-		return ERR_PTR(PTR_ERR(hold_err));
+		return ERR_CAST(hold_err);
 	}
 	fn->ofs = je32_to_cpu(ri->offset);
 	fn->size = je32_to_cpu(ri->dsize);
@@ -313,7 +313,7 @@ struct jffs2_full_dirent *jffs2_write_di
 		void *hold_err = fd->raw;
 		/* Release the full_dirent which is now useless, and return */
 		jffs2_free_full_dirent(fd);
-		return ERR_PTR(PTR_ERR(hold_err));
+		return ERR_CAST(hold_err);
 	}
 
 	if (retried) {
diff -puN fs/nfs/getroot.c~convert-err_ptrptr_errp-instances-to-err_castp fs/nfs/getroot.c
--- a/fs/nfs/getroot.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/fs/nfs/getroot.c
@@ -96,7 +96,7 @@ struct dentry *nfs_get_root(struct super
 	inode = nfs_fhget(sb, mntfh, fsinfo.fattr);
 	if (IS_ERR(inode)) {
 		dprintk("nfs_get_root: get root inode failed\n");
-		return ERR_PTR(PTR_ERR(inode));
+		return ERR_CAST(inode);
 	}
 
 	error = nfs_superblock_set_dummy_root(sb, inode);
@@ -266,7 +266,7 @@ struct dentry *nfs4_get_root(struct supe
 	inode = nfs_fhget(sb, mntfh, &fattr);
 	if (IS_ERR(inode)) {
 		dprintk("nfs_get_root: get root inode failed\n");
-		return ERR_PTR(PTR_ERR(inode));
+		return ERR_CAST(inode);
 	}
 
 	error = nfs_superblock_set_dummy_root(sb, inode);
diff -puN fs/nfsd/export.c~convert-err_ptrptr_errp-instances-to-err_castp fs/nfsd/export.c
--- a/fs/nfsd/export.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/fs/nfsd/export.c
@@ -1218,13 +1218,13 @@ static struct svc_export *exp_find(struc
 	struct svc_export *exp;
 	struct svc_expkey *ek = exp_find_key(clp, fsid_type, fsidv, reqp);
 	if (IS_ERR(ek))
-		return ERR_PTR(PTR_ERR(ek));
+		return ERR_CAST(ek);
 
 	exp = exp_get_by_name(clp, ek->ek_mnt, ek->ek_dentry, reqp);
 	cache_put(&ek->h, &svc_expkey_cache);
 
 	if (IS_ERR(exp))
-		return ERR_PTR(PTR_ERR(exp));
+		return ERR_CAST(exp);
 	return exp;
 }
 
diff -puN fs/quota.c~convert-err_ptrptr_errp-instances-to-err_castp fs/quota.c
--- a/fs/quota.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/fs/quota.c
@@ -341,11 +341,11 @@ static inline struct super_block *quotac
 	char *tmp = getname(special);
 
 	if (IS_ERR(tmp))
-		return ERR_PTR(PTR_ERR(tmp));
+		return ERR_CAST(tmp);
 	bdev = lookup_bdev(tmp);
 	putname(tmp);
 	if (IS_ERR(bdev))
-		return ERR_PTR(PTR_ERR(bdev));
+		return ERR_CAST(bdev);
 	sb = get_super(bdev);
 	bdput(bdev);
 	if (!sb)
diff -puN fs/reiserfs/inode.c~convert-err_ptrptr_errp-instances-to-err_castp fs/reiserfs/inode.c
--- a/fs/reiserfs/inode.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/fs/reiserfs/inode.c
@@ -1536,7 +1536,7 @@ static struct dentry *reiserfs_get_dentr
 	if (!inode)
 		inode = ERR_PTR(-ESTALE);
 	if (IS_ERR(inode))
-		return ERR_PTR(PTR_ERR(inode));
+		return ERR_CAST(inode);
 	result = d_alloc_anon(inode);
 	if (!result) {
 		iput(inode);
diff -puN fs/reiserfs/xattr.c~convert-err_ptrptr_errp-instances-to-err_castp fs/reiserfs/xattr.c
--- a/fs/reiserfs/xattr.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/fs/reiserfs/xattr.c
@@ -155,7 +155,7 @@ static struct dentry *get_xa_file_dentry
 
 	xadir = open_xa_dir(inode, flags);
 	if (IS_ERR(xadir)) {
-		return ERR_PTR(PTR_ERR(xadir));
+		return ERR_CAST(xadir);
 	} else if (xadir && !xadir->d_inode) {
 		dput(xadir);
 		return ERR_PTR(-ENODATA);
@@ -164,7 +164,7 @@ static struct dentry *get_xa_file_dentry
 	xafile = lookup_one_len(name, xadir, strlen(name));
 	if (IS_ERR(xafile)) {
 		dput(xadir);
-		return ERR_PTR(PTR_ERR(xafile));
+		return ERR_CAST(xafile);
 	}
 
 	if (xafile->d_inode) {	/* file exists */
diff -puN fs/vfat/namei.c~convert-err_ptrptr_errp-instances-to-err_castp fs/vfat/namei.c
--- a/fs/vfat/namei.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/fs/vfat/namei.c
@@ -705,7 +705,7 @@ static struct dentry *vfat_lookup(struct
 	brelse(sinfo.bh);
 	if (IS_ERR(inode)) {
 		unlock_kernel();
-		return ERR_PTR(PTR_ERR(inode));
+		return ERR_CAST(inode);
 	}
 	alias = d_find_alias(inode);
 	if (alias) {
diff -puN net/rxrpc/af_rxrpc.c~convert-err_ptrptr_errp-instances-to-err_castp net/rxrpc/af_rxrpc.c
--- a/net/rxrpc/af_rxrpc.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/net/rxrpc/af_rxrpc.c
@@ -239,7 +239,7 @@ static struct rxrpc_transport *rxrpc_nam
 	/* find a remote transport endpoint from the local one */
 	peer = rxrpc_get_peer(srx, gfp);
 	if (IS_ERR(peer))
-		return ERR_PTR(PTR_ERR(peer));
+		return ERR_CAST(peer);
 
 	/* find a transport */
 	trans = rxrpc_get_transport(rx->local, peer, gfp);
@@ -282,7 +282,7 @@ struct rxrpc_call *rxrpc_kernel_begin_ca
 		trans = rxrpc_name_to_transport(sock, (struct sockaddr *) srx,
 						sizeof(*srx), 0, gfp);
 		if (IS_ERR(trans)) {
-			call = ERR_PTR(PTR_ERR(trans));
+			call = ERR_CAST(trans);
 			trans = NULL;
 			goto out;
 		}
@@ -306,7 +306,7 @@ struct rxrpc_call *rxrpc_kernel_begin_ca
 
 	bundle = rxrpc_get_bundle(rx, trans, key, service_id, gfp);
 	if (IS_ERR(bundle)) {
-		call = ERR_PTR(PTR_ERR(bundle));
+		call = ERR_CAST(bundle);
 		goto out;
 	}
 
diff -puN security/keys/key.c~convert-err_ptrptr_errp-instances-to-err_castp security/keys/key.c
--- a/security/keys/key.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/security/keys/key.c
@@ -820,7 +820,7 @@ key_ref_t key_create_or_update(key_ref_t
 	key = key_alloc(ktype, description, current->fsuid, current->fsgid,
 			current, perm, flags);
 	if (IS_ERR(key)) {
-		key_ref = ERR_PTR(PTR_ERR(key));
+		key_ref = ERR_CAST(key);
 		goto error_3;
 	}
 
diff -puN security/keys/process_keys.c~convert-err_ptrptr_errp-instances-to-err_castp security/keys/process_keys.c
--- a/security/keys/process_keys.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/security/keys/process_keys.c
@@ -660,7 +660,7 @@ key_ref_t lookup_user_key(struct task_st
 
 		key = key_lookup(id);
 		if (IS_ERR(key)) {
-			key_ref = ERR_PTR(PTR_ERR(key));
+			key_ref = ERR_CAST(key);
 			goto error;
 		}
 
diff -puN security/keys/request_key.c~convert-err_ptrptr_errp-instances-to-err_castp security/keys/request_key.c
--- a/security/keys/request_key.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/security/keys/request_key.c
@@ -389,7 +389,7 @@ struct key *request_key_and_link(struct 
 	if (!IS_ERR(key_ref)) {
 		key = key_ref_to_ptr(key_ref);
 	} else if (PTR_ERR(key_ref) != -EAGAIN) {
-		key = ERR_PTR(PTR_ERR(key_ref));
+		key = ERR_CAST(key_ref);
 	} else  {
 		/* the search failed, but the keyrings were searchable, so we
 		 * should consult userspace if we can */
diff -puN security/keys/request_key_auth.c~convert-err_ptrptr_errp-instances-to-err_castp security/keys/request_key_auth.c
--- a/security/keys/request_key_auth.c~convert-err_ptrptr_errp-instances-to-err_castp
+++ a/security/keys/request_key_auth.c
@@ -261,7 +261,7 @@ struct key *key_get_instantiation_authke
 		current);
 
 	if (IS_ERR(authkey_ref)) {
-		authkey = ERR_PTR(PTR_ERR(authkey_ref));
+		authkey = ERR_CAST(authkey_ref);
 		goto error;
 	}
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
tty-let-architectures-override-the-user-kernel-macros.patch
aout-move-stack_top-to-asm-processorh.patch
aout-mark-arches-that-support-aout-format.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
usb-net2280-cant-have-a-function-called-show_registers.patch
mn10300-allocate-serial-port-uart-ids-for-on-chip-serial-ports.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
mn10300-add-platform-mtd-support-for-the-asb2303-board.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
procfs-constify-function-pointer-tables.patch
avoid-overflows-in-kernel-timec.patch
mount-options-fix-afs.patch
remove-aout-interpreter-support-in-elf-loader.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
mutex-subsystem-synchro-test-module.patch
