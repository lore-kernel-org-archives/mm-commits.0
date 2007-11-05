From: akpm@linux-foundation.org
Subject: + use-struct-path-in-struct-svc_export.patch added to -mm tree
Date: Mon, 05 Nov 2007 13:08:04 -0800
Message-ID: <200711052108.lA5L84Dw019812@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53078 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753932AbXKEVI2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 16:08:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jblunck@suse.de, bfields@citi.umich.edu, bfields@fieldses.org, hch@infradead.org, neilb@suse.de, viro@zeniv.linux.org.uk


The patch titled
     Use struct path in struct svc_export
has been added to the -mm tree.  Its filename is
     use-struct-path-in-struct-svc_export.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Use struct path in struct svc_export
From: Jan Blunck <jblunck@suse.de>

I'm embedding struct path into struct svc_export.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Acked-by: J. Bruce Fields <bfields@citi.umich.edu>
Acked-by: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/export.c            |   68 ++++++++++++++++------------------
 fs/nfsd/nfs3proc.c          |    2 -
 fs/nfsd/nfs3xdr.c           |    4 +-
 fs/nfsd/nfs4proc.c          |    4 +-
 fs/nfsd/nfs4xdr.c           |   12 +++---
 fs/nfsd/nfsfh.c             |   26 ++++++-------
 fs/nfsd/nfsproc.c           |    6 +--
 fs/nfsd/nfsxdr.c            |    2 -
 fs/nfsd/vfs.c               |   22 +++++------
 include/linux/nfsd/export.h |    5 +-
 10 files changed, 74 insertions(+), 77 deletions(-)

diff -puN fs/nfsd/export.c~use-struct-path-in-struct-svc_export fs/nfsd/export.c
--- a/fs/nfsd/export.c~use-struct-path-in-struct-svc_export
+++ a/fs/nfsd/export.c
@@ -332,10 +332,9 @@ static void nfsd4_fslocs_free(struct nfs
 static void svc_export_put(struct kref *ref)
 {
 	struct svc_export *exp = container_of(ref, struct svc_export, h.ref);
-	dput(exp->ex_dentry);
-	mntput(exp->ex_mnt);
+	path_put(&exp->ex_path);
 	auth_domain_put(exp->ex_client);
-	kfree(exp->ex_path);
+	kfree(exp->ex_pathname);
 	nfsd4_fslocs_free(&exp->ex_fslocs);
 	kfree(exp);
 }
@@ -349,7 +348,7 @@ static void svc_export_request(struct ca
 	char *pth;
 
 	qword_add(bpp, blen, exp->ex_client->name);
-	pth = d_path(exp->ex_dentry, exp->ex_mnt, *bpp, *blen);
+	pth = d_path(exp->ex_path.dentry, exp->ex_path.mnt, *bpp, *blen);
 	if (IS_ERR(pth)) {
 		/* is this correct? */
 		(*bpp)[0] = '\n';
@@ -508,7 +507,7 @@ static int svc_export_parse(struct cache
 	int an_int;
 
 	nd.path.dentry = NULL;
-	exp.ex_path = NULL;
+	exp.ex_pathname = NULL;
 
 	/* fs locations */
 	exp.ex_fslocs.locations = NULL;
@@ -547,11 +546,11 @@ static int svc_export_parse(struct cache
 
 	exp.h.flags = 0;
 	exp.ex_client = dom;
-	exp.ex_mnt = nd.path.mnt;
-	exp.ex_dentry = nd.path.dentry;
-	exp.ex_path = kstrdup(buf, GFP_KERNEL);
+	exp.ex_path.mnt = nd.path.mnt;
+	exp.ex_path.dentry = nd.path.dentry;
+	exp.ex_pathname = kstrdup(buf, GFP_KERNEL);
 	err = -ENOMEM;
-	if (!exp.ex_path)
+	if (!exp.ex_pathname)
 		goto out;
 
 	/* expiry */
@@ -628,7 +627,7 @@ static int svc_export_parse(struct cache
  out:
 	nfsd4_fslocs_free(&exp.ex_fslocs);
 	kfree(exp.ex_uuid);
- 	kfree(exp.ex_path);
+ 	kfree(exp.ex_pathname);
 	if (nd.path.dentry)
 		path_put(&nd.path);
  out_no_path:
@@ -653,7 +652,7 @@ static int svc_export_show(struct seq_fi
 		return 0;
 	}
 	exp = container_of(h, struct svc_export, h);
-	seq_path(m, exp->ex_mnt, exp->ex_dentry, " \t\n\\");
+	seq_path(m, exp->ex_path.mnt, exp->ex_path.dentry, " \t\n\\");
 	seq_putc(m, '\t');
 	seq_escape(m, exp->ex_client->name, " \t\n\\");
 	seq_putc(m, '(');
@@ -680,8 +679,8 @@ static int svc_export_match(struct cache
 	struct svc_export *orig = container_of(a, struct svc_export, h);
 	struct svc_export *new = container_of(b, struct svc_export, h);
 	return orig->ex_client == new->ex_client &&
-		orig->ex_dentry == new->ex_dentry &&
-		orig->ex_mnt == new->ex_mnt;
+		orig->ex_path.dentry == new->ex_path.dentry &&
+		orig->ex_path.mnt == new->ex_path.mnt;
 }
 
 static void svc_export_init(struct cache_head *cnew, struct cache_head *citem)
@@ -691,9 +690,9 @@ static void svc_export_init(struct cache
 
 	kref_get(&item->ex_client->ref);
 	new->ex_client = item->ex_client;
-	new->ex_dentry = dget(item->ex_dentry);
-	new->ex_mnt = mntget(item->ex_mnt);
-	new->ex_path = NULL;
+	new->ex_path.dentry = dget(item->ex_path.dentry);
+	new->ex_path.mnt = mntget(item->ex_path.mnt);
+	new->ex_pathname = NULL;
 	new->ex_fslocs.locations = NULL;
 	new->ex_fslocs.locations_count = 0;
 	new->ex_fslocs.migrated = 0;
@@ -711,8 +710,8 @@ static void export_update(struct cache_h
 	new->ex_fsid = item->ex_fsid;
 	new->ex_uuid = item->ex_uuid;
 	item->ex_uuid = NULL;
-	new->ex_path = item->ex_path;
-	item->ex_path = NULL;
+	new->ex_pathname = item->ex_pathname;
+	item->ex_pathname = NULL;
 	new->ex_fslocs.locations = item->ex_fslocs.locations;
 	item->ex_fslocs.locations = NULL;
 	new->ex_fslocs.locations_count = item->ex_fslocs.locations_count;
@@ -755,8 +754,8 @@ svc_export_lookup(struct svc_export *exp
 	struct cache_head *ch;
 	int hash;
 	hash = hash_ptr(exp->ex_client, EXPORT_HASHBITS);
-	hash ^= hash_ptr(exp->ex_dentry, EXPORT_HASHBITS);
-	hash ^= hash_ptr(exp->ex_mnt, EXPORT_HASHBITS);
+	hash ^= hash_ptr(exp->ex_path.dentry, EXPORT_HASHBITS);
+	hash ^= hash_ptr(exp->ex_path.mnt, EXPORT_HASHBITS);
 
 	ch = sunrpc_cache_lookup(&svc_export_cache, &exp->h,
 				 hash);
@@ -772,8 +771,8 @@ svc_export_update(struct svc_export *new
 	struct cache_head *ch;
 	int hash;
 	hash = hash_ptr(old->ex_client, EXPORT_HASHBITS);
-	hash ^= hash_ptr(old->ex_dentry, EXPORT_HASHBITS);
-	hash ^= hash_ptr(old->ex_mnt, EXPORT_HASHBITS);
+	hash ^= hash_ptr(old->ex_path.dentry, EXPORT_HASHBITS);
+	hash ^= hash_ptr(old->ex_path.mnt, EXPORT_HASHBITS);
 
 	ch = sunrpc_cache_update(&svc_export_cache, &new->h,
 				 &old->h,
@@ -815,8 +814,8 @@ static int exp_set_key(svc_client *clp, 
 	key.ek_client = clp;
 	key.ek_fsidtype = fsid_type;
 	memcpy(key.ek_fsid, fsidv, key_len(fsid_type));
-	key.ek_mnt = exp->ex_mnt;
-	key.ek_dentry = exp->ex_dentry;
+	key.ek_mnt = exp->ex_path.mnt;
+	key.ek_dentry = exp->ex_path.dentry;
 	key.h.expiry_time = NEVER;
 	key.h.flags = 0;
 
@@ -870,8 +869,8 @@ static svc_export *exp_get_by_name(svc_c
 		return ERR_PTR(-ENOENT);
 
 	key.ex_client = clp;
-	key.ex_mnt = mnt;
-	key.ex_dentry = dentry;
+	key.ex_path.mnt = mnt;
+	key.ex_path.dentry = dentry;
 
 	exp = svc_export_lookup(&key);
 	if (exp == NULL)
@@ -968,7 +967,7 @@ static int exp_fsid_hash(svc_client *clp
 static int exp_hash(struct auth_domain *clp, struct svc_export *exp)
 {
 	u32 fsid[2];
-	struct inode *inode = exp->ex_dentry->d_inode;
+	struct inode *inode = exp->ex_path.dentry->d_inode;
 	dev_t dev = inode->i_sb->s_dev;
 
 	if (old_valid_dev(dev)) {
@@ -982,7 +981,7 @@ static int exp_hash(struct auth_domain *
 static void exp_unhash(struct svc_export *exp)
 {
 	struct svc_expkey *ek;
-	struct inode *inode = exp->ex_dentry->d_inode;
+	struct inode *inode = exp->ex_path.dentry->d_inode;
 
 	ek = exp_get_key(exp->ex_client, inode->i_sb->s_dev, inode->i_ino);
 	if (!IS_ERR(ek)) {
@@ -1064,12 +1063,11 @@ exp_export(struct nfsctl_export *nxp)
 
 	new.h.expiry_time = NEVER;
 	new.h.flags = 0;
-	new.ex_path = kstrdup(nxp->ex_path, GFP_KERNEL);
-	if (!new.ex_path)
+	new.ex_pathname = kstrdup(nxp->ex_path, GFP_KERNEL);
+	if (!new.ex_pathname)
 		goto finish;
 	new.ex_client = clp;
-	new.ex_mnt = nd.path.mnt;
-	new.ex_dentry = nd.path.dentry;
+	new.ex_path = nd.path;
 	new.ex_flags = nxp->ex_flags;
 	new.ex_anon_uid = nxp->ex_anon_uid;
 	new.ex_anon_gid = nxp->ex_anon_gid;
@@ -1090,8 +1088,8 @@ exp_export(struct nfsctl_export *nxp)
 	} else
 		err = 0;
 finish:
-	if (new.ex_path)
-		kfree(new.ex_path);
+	if (new.ex_pathname)
+		kfree(new.ex_pathname);
 	if (exp)
 		exp_put(exp);
 	if (fsid_key && !IS_ERR(fsid_key))
@@ -1362,7 +1360,7 @@ exp_pseudoroot(struct svc_rqst *rqstp, s
 		return nfserr_perm;
 	if (IS_ERR(exp))
 		return nfserrno(PTR_ERR(exp));
-	rv = fh_compose(fhp, exp, exp->ex_dentry, NULL);
+	rv = fh_compose(fhp, exp, exp->ex_path.dentry, NULL);
 	if (rv)
 		goto out;
 	rv = check_nfsd_access(exp, rqstp);
diff -puN fs/nfsd/nfs3proc.c~use-struct-path-in-struct-svc_export fs/nfsd/nfs3proc.c
--- a/fs/nfsd/nfs3proc.c~use-struct-path-in-struct-svc_export
+++ a/fs/nfsd/nfs3proc.c
@@ -67,7 +67,7 @@ nfsd3_proc_getattr(struct svc_rqst *rqst
 	if (nfserr)
 		RETURN_STATUS(nfserr);
 
-	err = vfs_getattr(resp->fh.fh_export->ex_mnt,
+	err = vfs_getattr(resp->fh.fh_export->ex_path.mnt,
 			  resp->fh.fh_dentry, &resp->stat);
 	nfserr = nfserrno(err);
 
diff -puN fs/nfsd/nfs3xdr.c~use-struct-path-in-struct-svc_export fs/nfsd/nfs3xdr.c
--- a/fs/nfsd/nfs3xdr.c~use-struct-path-in-struct-svc_export
+++ a/fs/nfsd/nfs3xdr.c
@@ -217,7 +217,7 @@ encode_post_op_attr(struct svc_rqst *rqs
 	        int err;
 		struct kstat stat;
 
-		err = vfs_getattr(fhp->fh_export->ex_mnt, dentry, &stat);
+		err = vfs_getattr(fhp->fh_export->ex_path.mnt, dentry, &stat);
 		if (!err) {
 			*p++ = xdr_one;		/* attributes follow */
 			lease_get_mtime(dentry->d_inode, &stat.mtime);
@@ -269,7 +269,7 @@ void fill_post_wcc(struct svc_fh *fhp)
 	if (fhp->fh_post_saved)
 		printk("nfsd: inode locked twice during operation.\n");
 
-	err = vfs_getattr(fhp->fh_export->ex_mnt, fhp->fh_dentry,
+	err = vfs_getattr(fhp->fh_export->ex_path.mnt, fhp->fh_dentry,
 			&fhp->fh_post_attr);
 	if (err)
 		fhp->fh_post_saved = 0;
diff -puN fs/nfsd/nfs4proc.c~use-struct-path-in-struct-svc_export fs/nfsd/nfs4proc.c
--- a/fs/nfsd/nfs4proc.c~use-struct-path-in-struct-svc_export
+++ a/fs/nfsd/nfs4proc.c
@@ -658,7 +658,7 @@ nfsd4_setattr(struct svc_rqst *rqstp, st
 			return status;
 		}
 	}
-	status = mnt_want_write(cstate->current_fh.fh_export->ex_mnt);
+	status = mnt_want_write(cstate->current_fh.fh_export->ex_path.mnt);
 	if (status)
 		return status;
 	status = nfs_ok;
@@ -670,7 +670,7 @@ nfsd4_setattr(struct svc_rqst *rqstp, st
 	status = nfsd_setattr(rqstp, &cstate->current_fh, &setattr->sa_iattr,
 				0, (time_t)0);
 out:
-	mnt_drop_write(cstate->current_fh.fh_export->ex_mnt);
+	mnt_drop_write(cstate->current_fh.fh_export->ex_path.mnt);
 	return status;
 }
 
diff -puN fs/nfsd/nfs4xdr.c~use-struct-path-in-struct-svc_export fs/nfsd/nfs4xdr.c
--- a/fs/nfsd/nfs4xdr.c~use-struct-path-in-struct-svc_export
+++ a/fs/nfsd/nfs4xdr.c
@@ -1325,9 +1325,9 @@ static char *nfsd4_path(struct svc_rqst 
 	*stat = exp_pseudoroot(rqstp, &tmp_fh);
 	if (*stat)
 		return NULL;
-	rootpath = tmp_fh.fh_export->ex_path;
+	rootpath = tmp_fh.fh_export->ex_pathname;
 
-	path = exp->ex_path;
+	path = exp->ex_pathname;
 
 	if (strncmp(path, rootpath, strlen(rootpath))) {
 		dprintk("nfsd: fs_locations failed;"
@@ -1476,7 +1476,7 @@ nfsd4_encode_fattr(struct svc_fh *fhp, s
 			goto out;
 	}
 
-	err = vfs_getattr(exp->ex_mnt, dentry, &stat);
+	err = vfs_getattr(exp->ex_path.mnt, dentry, &stat);
 	if (err)
 		goto out_nfserr;
 	if ((bmval0 & (FATTR4_WORD0_FILES_FREE | FATTR4_WORD0_FILES_TOTAL |
@@ -1828,9 +1828,9 @@ out_acl:
 	if (bmval1 & FATTR4_WORD1_MOUNTED_ON_FILEID) {
 		if ((buflen -= 8) < 0)
                 	goto out_resource;
-		if (exp->ex_mnt->mnt_root->d_inode == dentry->d_inode) {
-			err = vfs_getattr(exp->ex_mnt->mnt_parent,
-				exp->ex_mnt->mnt_mountpoint, &stat);
+		if (exp->ex_path.mnt->mnt_root->d_inode == dentry->d_inode) {
+			err = vfs_getattr(exp->ex_path.mnt->mnt_parent,
+				exp->ex_path.mnt->mnt_mountpoint, &stat);
 			if (err)
 				goto out_nfserr;
 		}
diff -puN fs/nfsd/nfsfh.c~use-struct-path-in-struct-svc_export fs/nfsd/nfsfh.c
--- a/fs/nfsd/nfsfh.c~use-struct-path-in-struct-svc_export
+++ a/fs/nfsd/nfsfh.c
@@ -46,7 +46,7 @@ static int nfsd_acceptable(void *expv, s
 		return 1;
 
 	tdentry = dget(dentry);
-	while (tdentry != exp->ex_dentry && ! IS_ROOT(tdentry)) {
+	while (tdentry != exp->ex_path.dentry && ! IS_ROOT(tdentry)) {
 		/* make sure parents give x permission to user */
 		int err;
 		parent = dget_parent(tdentry);
@@ -58,9 +58,9 @@ static int nfsd_acceptable(void *expv, s
 		dput(tdentry);
 		tdentry = parent;
 	}
-	if (tdentry != exp->ex_dentry)
+	if (tdentry != exp->ex_path.dentry)
 		dprintk("nfsd_acceptable failed at %p %s\n", tdentry, tdentry->d_name.name);
-	rv = (tdentry == exp->ex_dentry);
+	rv = (tdentry == exp->ex_path.dentry);
 	dput(tdentry);
 	return rv;
 }
@@ -203,9 +203,9 @@ fh_verify(struct svc_rqst *rqstp, struct
 			fileid_type = fh->fh_fileid_type;
 
 		if (fileid_type == FILEID_ROOT)
-			dentry = dget(exp->ex_dentry);
+			dentry = dget(exp->ex_path.dentry);
 		else {
-			dentry = exportfs_decode_fh(exp->ex_mnt, fid,
+			dentry = exportfs_decode_fh(exp->ex_path.mnt, fid,
 					data_left, fileid_type,
 					nfsd_acceptable, exp);
 		}
@@ -289,7 +289,7 @@ out:
 static void _fh_update(struct svc_fh *fhp, struct svc_export *exp,
 		struct dentry *dentry)
 {
-	if (dentry != exp->ex_dentry) {
+	if (dentry != exp->ex_path.dentry) {
 		struct fid *fid = (struct fid *)
 			(fhp->fh_handle.fh_auth + fhp->fh_handle.fh_size/4 - 1);
 		int maxsize = (fhp->fh_maxsize - fhp->fh_handle.fh_size)/4;
@@ -334,12 +334,12 @@ fh_compose(struct svc_fh *fhp, struct sv
 	struct inode * inode = dentry->d_inode;
 	struct dentry *parent = dentry->d_parent;
 	__u32 *datap;
-	dev_t ex_dev = exp->ex_dentry->d_inode->i_sb->s_dev;
-	int root_export = (exp->ex_dentry == exp->ex_dentry->d_sb->s_root);
+	dev_t ex_dev = exp->ex_path.dentry->d_inode->i_sb->s_dev;
+	int root_export = (exp->ex_path.dentry == exp->ex_path.dentry->d_sb->s_root);
 
 	dprintk("nfsd: fh_compose(exp %02x:%02x/%ld %s/%s, ino=%ld)\n",
 		MAJOR(ex_dev), MINOR(ex_dev),
-		(long) exp->ex_dentry->d_inode->i_ino,
+		(long) exp->ex_path.dentry->d_inode->i_ino,
 		parent->d_name.name, dentry->d_name.name,
 		(inode ? inode->i_ino : 0));
 
@@ -381,7 +381,7 @@ fh_compose(struct svc_fh *fhp, struct sv
 			/* FALL THROUGH */
 		case FSID_MAJOR_MINOR:
 		case FSID_ENCODE_DEV:
-			if (!(exp->ex_dentry->d_inode->i_sb->s_type->fs_flags
+			if (!(exp->ex_path.dentry->d_inode->i_sb->s_type->fs_flags
 			      & FS_REQUIRES_DEV))
 				goto retry;
 			break;
@@ -444,7 +444,7 @@ fh_compose(struct svc_fh *fhp, struct sv
 		fhp->fh_handle.ofh_dev =  old_encode_dev(ex_dev);
 		fhp->fh_handle.ofh_xdev = fhp->fh_handle.ofh_dev;
 		fhp->fh_handle.ofh_xino =
-			ino_t_to_u32(exp->ex_dentry->d_inode->i_ino);
+			ino_t_to_u32(exp->ex_path.dentry->d_inode->i_ino);
 		fhp->fh_handle.ofh_dirino = ino_t_to_u32(parent_ino(dentry));
 		if (inode)
 			_fh_update_old(dentry, exp, &fhp->fh_handle);
@@ -455,7 +455,7 @@ fh_compose(struct svc_fh *fhp, struct sv
 		datap = fhp->fh_handle.fh_auth+0;
 		fhp->fh_handle.fh_fsid_type = fsid_type;
 		mk_fsid(fsid_type, datap, ex_dev,
-			exp->ex_dentry->d_inode->i_ino,
+			exp->ex_path.dentry->d_inode->i_ino,
 			exp->ex_fsid, exp->ex_uuid);
 
 		len = key_len(fsid_type);
@@ -561,7 +561,7 @@ enum fsid_source fsid_source(struct svc_
 	case FSID_DEV:
 	case FSID_ENCODE_DEV:
 	case FSID_MAJOR_MINOR:
-		if (fhp->fh_export->ex_dentry->d_inode->i_sb->s_type->fs_flags
+		if (fhp->fh_export->ex_path.dentry->d_inode->i_sb->s_type->fs_flags
 		    & FS_REQUIRES_DEV)
 			return FSIDSOURCE_DEV;
 		break;
diff -puN fs/nfsd/nfsproc.c~use-struct-path-in-struct-svc_export fs/nfsd/nfsproc.c
--- a/fs/nfsd/nfsproc.c~use-struct-path-in-struct-svc_export
+++ a/fs/nfsd/nfsproc.c
@@ -41,7 +41,7 @@ static __be32
 nfsd_return_attrs(__be32 err, struct nfsd_attrstat *resp)
 {
 	if (err) return err;
-	return nfserrno(vfs_getattr(resp->fh.fh_export->ex_mnt,
+	return nfserrno(vfs_getattr(resp->fh.fh_export->ex_path.mnt,
 				    resp->fh.fh_dentry,
 				    &resp->stat));
 }
@@ -49,7 +49,7 @@ static __be32
 nfsd_return_dirop(__be32 err, struct nfsd_diropres *resp)
 {
 	if (err) return err;
-	return nfserrno(vfs_getattr(resp->fh.fh_export->ex_mnt,
+	return nfserrno(vfs_getattr(resp->fh.fh_export->ex_path.mnt,
 				    resp->fh.fh_dentry,
 				    &resp->stat));
 }
@@ -164,7 +164,7 @@ nfsd_proc_read(struct svc_rqst *rqstp, s
 				  &resp->count);
 
 	if (nfserr) return nfserr;
-	return nfserrno(vfs_getattr(resp->fh.fh_export->ex_mnt,
+	return nfserrno(vfs_getattr(resp->fh.fh_export->ex_path.mnt,
 				    resp->fh.fh_dentry,
 				    &resp->stat));
 }
diff -puN fs/nfsd/nfsxdr.c~use-struct-path-in-struct-svc_export fs/nfsd/nfsxdr.c
--- a/fs/nfsd/nfsxdr.c~use-struct-path-in-struct-svc_export
+++ a/fs/nfsd/nfsxdr.c
@@ -206,7 +206,7 @@ encode_fattr(struct svc_rqst *rqstp, __b
 __be32 *nfs2svc_encode_fattr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp)
 {
 	struct kstat stat;
-	vfs_getattr(fhp->fh_export->ex_mnt, fhp->fh_dentry, &stat);
+	vfs_getattr(fhp->fh_export->ex_path.mnt, fhp->fh_dentry, &stat);
 	return encode_fattr(rqstp, p, fhp, &stat);
 }
 
diff -puN fs/nfsd/vfs.c~use-struct-path-in-struct-svc_export fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~use-struct-path-in-struct-svc_export
+++ a/fs/nfsd/vfs.c
@@ -101,7 +101,7 @@ nfsd_cross_mnt(struct svc_rqst *rqstp, s
 {
 	struct svc_export *exp = *expp, *exp2 = NULL;
 	struct dentry *dentry = *dpp;
-	struct vfsmount *mnt = mntget(exp->ex_mnt);
+	struct vfsmount *mnt = mntget(exp->ex_path.mnt);
 	struct dentry *mounts = dget(dentry);
 	int err = 0;
 
@@ -156,7 +156,7 @@ nfsd_lookup_dentry(struct svc_rqst *rqst
 	if (isdotent(name, len)) {
 		if (len==1)
 			dentry = dget(dparent);
-		else if (dparent != exp->ex_dentry) {
+		else if (dparent != exp->ex_path.dentry) {
 			dentry = dget_parent(dparent);
 		} else  if (!EX_NOHIDE(exp))
 			dentry = dget(dparent); /* .. == . just like at / */
@@ -164,7 +164,7 @@ nfsd_lookup_dentry(struct svc_rqst *rqst
 			/* checking mountpoint crossing is very different when stepping up */
 			struct svc_export *exp2 = NULL;
 			struct dentry *dp;
-			struct vfsmount *mnt = mntget(exp->ex_mnt);
+			struct vfsmount *mnt = mntget(exp->ex_path.mnt);
 			dentry = dget(dparent);
 			while(dentry == mnt->mnt_root && follow_up(&mnt, &dentry))
 				;
@@ -721,7 +721,7 @@ nfsd_open(struct svc_rqst *rqstp, struct
 
 		DQUOT_INIT(inode);
 	}
-	*filp = dentry_open(dget(dentry), mntget(fhp->fh_export->ex_mnt), flags);
+	*filp = dentry_open(dget(dentry), mntget(fhp->fh_export->ex_path.mnt), flags);
 	if (IS_ERR(*filp))
 		host_err = PTR_ERR(*filp);
 out_nfserr:
@@ -1242,11 +1242,11 @@ nfsd_create(struct svc_rqst *rqstp, stru
 	case S_IFBLK:
 	case S_IFIFO:
 	case S_IFSOCK:
-		host_err = mnt_want_write(fhp->fh_export->ex_mnt);
+		host_err = mnt_want_write(fhp->fh_export->ex_path.mnt);
 		if (host_err)
 			break;
 		host_err = vfs_mknod(dirp, dchild, iap->ia_mode, rdev);
-		mnt_drop_write(fhp->fh_export->ex_mnt);
+		mnt_drop_write(fhp->fh_export->ex_path.mnt);
 		break;
 	default:
 	        printk("nfsd: bad file type %o in nfsd_create\n", type);
@@ -1457,7 +1457,7 @@ nfsd_readlink(struct svc_rqst *rqstp, st
 	if (!inode->i_op || !inode->i_op->readlink)
 		goto out;
 
-	touch_atime(fhp->fh_export->ex_mnt, dentry);
+	touch_atime(fhp->fh_export->ex_path.mnt, dentry);
 	/* N.B. Why does this call need a get_fs()??
 	 * Remove the set_fs and watch the fireworks:-) --okir
 	 */
@@ -1680,9 +1680,9 @@ nfsd_rename(struct svc_rqst *rqstp, stru
 	}
 
 	host_err = -EXDEV;
-	if (ffhp->fh_export->ex_mnt != tfhp->fh_export->ex_mnt)
+	if (ffhp->fh_export->ex_path.mnt != tfhp->fh_export->ex_path.mnt)
 		goto out_dput_new;
-	host_err = mnt_want_write(ffhp->fh_export->ex_mnt);
+	host_err = mnt_want_write(ffhp->fh_export->ex_path.mnt);
 	if (host_err)
 		goto out_dput_new;
 
@@ -1866,7 +1866,7 @@ nfsd_permission(struct svc_rqst *rqstp, 
 		inode->i_mode,
 		IS_IMMUTABLE(inode)?	" immut" : "",
 		IS_APPEND(inode)?	" append" : "",
-		__mnt_is_readonly(exp->ex_mnt)?	" ro" : "");
+		__mnt_is_readonly(exp->ex_path.mnt)?	" ro" : "");
 	dprintk("      owner %d/%d user %d/%d\n",
 		inode->i_uid, inode->i_gid, current->fsuid, current->fsgid);
 #endif
@@ -1877,7 +1877,7 @@ nfsd_permission(struct svc_rqst *rqstp, 
 	 */
 	if (!(acc & MAY_LOCAL_ACCESS))
 		if (acc & (MAY_WRITE | MAY_SATTR | MAY_TRUNC)) {
-			if (exp_rdonly(rqstp, exp) || __mnt_is_readonly(exp->ex_mnt))
+			if (exp_rdonly(rqstp, exp) || __mnt_is_readonly(exp->ex_path.mnt))
 				return nfserr_rofs;
 			if (/* (acc & MAY_WRITE) && */ IS_IMMUTABLE(inode))
 				return nfserr_perm;
diff -puN include/linux/nfsd/export.h~use-struct-path-in-struct-svc_export include/linux/nfsd/export.h
--- a/include/linux/nfsd/export.h~use-struct-path-in-struct-svc_export
+++ a/include/linux/nfsd/export.h
@@ -84,9 +84,8 @@ struct svc_export {
 	struct cache_head	h;
 	struct auth_domain *	ex_client;
 	int			ex_flags;
-	struct vfsmount *	ex_mnt;
-	struct dentry *		ex_dentry;
-	char *			ex_path;
+	struct path		ex_path;
+	char *			ex_pathname;
 	uid_t			ex_anon_uid;
 	gid_t			ex_anon_gid;
 	int			ex_fsid;
_

Patches currently in -mm which might be from jblunck@suse.de are

r-o-bind-mounts-unix_find_other-elevate-write-count-for-touch_atime-fix.patch
r-o-bind-mounts-track-number-of-mount-writers-fix.patch
dont-touch-fs_struct-in-drivers.patch
dont-touch-fs_struct-in-usermodehelper.patch
remove-path_release_on_umount.patch
move-struct-path-into-its-own-header.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
introduce-path_put.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
introduce-path_get.patch
use-struct-path-in-fs_struct.patch
make-set_fs_rootpwd-take-a-struct-path.patch
introduce-path_get-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-unionfs.patch
one-less-parameter-to-__d_path.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-kerneldoc-cleanup.patch
d_path-use-struct-path-in-struct-avc_audit_data.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-proc_get_link-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export.patch
use-struct-path-in-struct-svc_expkey.patch
d_path-make-seq_path-use-a-struct-path-argument.patch
d_path-make-d_path-use-a-struct-path.patch
