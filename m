From: akpm@linux-foundation.org
Subject: - knfsd-tidy-up-choice-of-filesystem-identifier-when-creating-a-filehandle.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:47:45 -0800
Message-ID: <200702150847.l1F8ljRe025007@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:39937 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965322AbXBOIrt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:47:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: tidy up choice of filesystem-identifier when creating a filehandle
has been removed from the -mm tree.  Its filename was
     knfsd-tidy-up-choice-of-filesystem-identifier-when-creating-a-filehandle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: tidy up choice of filesystem-identifier when creating a filehandle
From: NeilBrown <neilb@suse.de>

If we are using the same version/fsid as a current filehandle, then there is
no need to verify the the numbers are valid for this export, and they must be
(we used them to find this export).

This allows us to simplify the fsid selection code.

Also change "ref_fh_version" and "ref_fh_fsid_type" to "version" and
"fsid_type", as the important thing isn't that they are the version/type of
the reference filehandle, but they are the chosen type for the new filehandle.

And tidy up some indenting.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfsfh.c |  124 ++++++++++++++++++++++------------------------
 1 file changed, 60 insertions(+), 64 deletions(-)

diff -puN fs/nfsd/nfsfh.c~knfsd-tidy-up-choice-of-filesystem-identifier-when-creating-a-filehandle fs/nfsd/nfsfh.c
--- a/fs/nfsd/nfsfh.c~knfsd-tidy-up-choice-of-filesystem-identifier-when-creating-a-filehandle
+++ a/fs/nfsd/nfsfh.c
@@ -212,7 +212,7 @@ fh_verify(struct svc_rqst *rqstp, struct
 				fileid_type = 2;
 		} else
 			fileid_type = fh->fh_fileid_type;
-		
+
 		if (fileid_type == 0)
 			dentry = dget(exp->ex_dentry);
 		else {
@@ -292,7 +292,7 @@ static inline int _fh_update(struct dent
 			     __u32 *datap, int *maxsize)
 {
 	struct export_operations *nop = exp->ex_mnt->mnt_sb->s_export_op;
-	
+
 	if (dentry == exp->ex_dentry) {
 		*maxsize = 0;
 		return 0;
@@ -317,7 +317,8 @@ static inline void _fh_update_old(struct
 }
 
 __be32
-fh_compose(struct svc_fh *fhp, struct svc_export *exp, struct dentry *dentry, struct svc_fh *ref_fh)
+fh_compose(struct svc_fh *fhp, struct svc_export *exp, struct dentry *dentry,
+	   struct svc_fh *ref_fh)
 {
 	/* ref_fh is a reference file handle.
 	 * if it is non-null and for the same filesystem, then we should compose
@@ -327,8 +328,8 @@ fh_compose(struct svc_fh *fhp, struct sv
 	 *
 	 */
 
-	u8 ref_fh_version = 0;
-	u8 ref_fh_fsid_type = 0;
+	u8 version = 1;
+	u8 fsid_type = 0;
 	struct inode * inode = dentry->d_inode;
 	struct dentry *parent = dentry->d_parent;
 	__u32 *datap;
@@ -340,57 +341,52 @@ fh_compose(struct svc_fh *fhp, struct sv
 		parent->d_name.name, dentry->d_name.name,
 		(inode ? inode->i_ino : 0));
 
+	/* Choose filehandle version and fsid type based on
+	 * the reference filehandle (if it is in the same export)
+	 * or the export options.
+	 */
 	if (ref_fh && ref_fh->fh_export == exp) {
-		ref_fh_version = ref_fh->fh_handle.fh_version;
-		if (ref_fh_version == 0xca)
-			ref_fh_fsid_type = 0;
+		version = ref_fh->fh_handle.fh_version;
+		if (version == 0xca)
+			fsid_type = 0;
 		else
-			ref_fh_fsid_type = ref_fh->fh_handle.fh_fsid_type;
-		if (ref_fh_fsid_type > 3)
-			ref_fh_fsid_type = 0;
-
-		/* make sure ref_fh type works for given export */
-		if (ref_fh_fsid_type == 1 &&
-		    !(exp->ex_flags & NFSEXP_FSID)) {
-			/* if we don't have an fsid, we cannot provide one... */
-			ref_fh_fsid_type = 0;
-		}
+			fsid_type = ref_fh->fh_handle.fh_fsid_type;
+		/* We know this version/type works for this export
+		 * so there is no need for further checks.
+		 */
 	} else if (exp->ex_flags & NFSEXP_FSID)
-		ref_fh_fsid_type = 1;
-
-	if (!old_valid_dev(ex_dev) && ref_fh_fsid_type == 0) {
+		fsid_type = 1;
+	else if (!old_valid_dev(ex_dev))
 		/* for newer device numbers, we must use a newer fsid format */
-		ref_fh_version = 1;
-		ref_fh_fsid_type = 3;
-	}
-	if (old_valid_dev(ex_dev) &&
-	    (ref_fh_fsid_type == 2 || ref_fh_fsid_type == 3))
-		/* must use type1 for smaller device numbers */
-		ref_fh_fsid_type = 0;
+		fsid_type = 3;
+	else
+		fsid_type = 0;
 
 	if (ref_fh == fhp)
 		fh_put(ref_fh);
 
 	if (fhp->fh_locked || fhp->fh_dentry) {
 		printk(KERN_ERR "fh_compose: fh %s/%s not initialized!\n",
-			parent->d_name.name, dentry->d_name.name);
+		       parent->d_name.name, dentry->d_name.name);
 	}
 	if (fhp->fh_maxsize < NFS_FHSIZE)
 		printk(KERN_ERR "fh_compose: called with maxsize %d! %s/%s\n",
-		       fhp->fh_maxsize, parent->d_name.name, dentry->d_name.name);
+		       fhp->fh_maxsize,
+		       parent->d_name.name, dentry->d_name.name);
 
 	fhp->fh_dentry = dget(dentry); /* our internal copy */
 	fhp->fh_export = exp;
 	cache_get(&exp->h);
 
-	if (ref_fh_version == 0xca) {
+	if (version == 0xca) {
 		/* old style filehandle please */
 		memset(&fhp->fh_handle.fh_base, 0, NFS_FHSIZE);
 		fhp->fh_handle.fh_size = NFS_FHSIZE;
 		fhp->fh_handle.ofh_dcookie = 0xfeebbaca;
 		fhp->fh_handle.ofh_dev =  old_encode_dev(ex_dev);
 		fhp->fh_handle.ofh_xdev = fhp->fh_handle.ofh_dev;
-		fhp->fh_handle.ofh_xino = ino_t_to_u32(exp->ex_dentry->d_inode->i_ino);
+		fhp->fh_handle.ofh_xino =
+			ino_t_to_u32(exp->ex_dentry->d_inode->i_ino);
 		fhp->fh_handle.ofh_dirino = ino_t_to_u32(parent_ino(dentry));
 		if (inode)
 			_fh_update_old(dentry, exp, &fhp->fh_handle);
@@ -399,38 +395,38 @@ fh_compose(struct svc_fh *fhp, struct sv
 		fhp->fh_handle.fh_version = 1;
 		fhp->fh_handle.fh_auth_type = 0;
 		datap = fhp->fh_handle.fh_auth+0;
-		fhp->fh_handle.fh_fsid_type = ref_fh_fsid_type;
-		switch (ref_fh_fsid_type) {
-			case 0:
-				/*
-				 * fsid_type 0:
-				 * 2byte major, 2byte minor, 4byte inode
-				 */
-				mk_fsid_v0(datap, ex_dev,
-					exp->ex_dentry->d_inode->i_ino);
-				break;
-			case 1:
-				/* fsid_type 1 == 4 bytes filesystem id */
-				mk_fsid_v1(datap, exp->ex_fsid);
-				break;
-			case 2:
-				/*
-				 * fsid_type 2:
-				 * 4byte major, 4byte minor, 4byte inode
-				 */
-				mk_fsid_v2(datap, ex_dev,
-					exp->ex_dentry->d_inode->i_ino);
-				break;
-			case 3:
-				/*
-				 * fsid_type 3:
-				 * 4byte devicenumber, 4byte inode
-				 */
-				mk_fsid_v3(datap, ex_dev,
-					exp->ex_dentry->d_inode->i_ino);
-				break;
+		fhp->fh_handle.fh_fsid_type = fsid_type;
+		switch (fsid_type) {
+		case 0:
+			/*
+			 * fsid_type 0:
+			 * 2byte major, 2byte minor, 4byte inode
+			 */
+			mk_fsid_v0(datap, ex_dev,
+				   exp->ex_dentry->d_inode->i_ino);
+			break;
+		case 1:
+			/* fsid_type 1 == 4 bytes filesystem id */
+			mk_fsid_v1(datap, exp->ex_fsid);
+			break;
+		case 2:
+			/*
+			 * fsid_type 2:
+			 * 4byte major, 4byte minor, 4byte inode
+			 */
+			mk_fsid_v2(datap, ex_dev,
+				   exp->ex_dentry->d_inode->i_ino);
+			break;
+		case 3:
+			/*
+			 * fsid_type 3:
+			 * 4byte devicenumber, 4byte inode
+			 */
+			mk_fsid_v3(datap, ex_dev,
+				   exp->ex_dentry->d_inode->i_ino);
+			break;
 		}
-		len = key_len(ref_fh_fsid_type);
+		len = key_len(fsid_type);
 		datap += len/4;
 		fhp->fh_handle.fh_size = 4 + len;
 
@@ -457,7 +453,7 @@ fh_update(struct svc_fh *fhp)
 {
 	struct dentry *dentry;
 	__u32 *datap;
-	
+
 	if (!fhp->fh_dentry)
 		goto out_bad;
 
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
convert-highest_possible_processor_id-to-nr_cpu_ids.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
knfsd-nfsd4-fix-non-terminated-string.patch
knfsd-nfsd4-relax-checking-of-acl-inheritance-bits.patch
knfsd-nfsd4-simplify-nfsv4-posix-translation.patch
knfsd-nfsd4-represent-nfsv4-acl-with-array-instead-of-linked-list.patch
knfsd-nfsd4-fix-memory-leak-on-kmalloc-failure-in-savemem.patch
knfsd-nfsd4-fix-error-return-on-unsupported-acl.patch
knfsd-nfsd4-acls-dont-return-explicit-mask.patch
knfsd-nfsd4-acls-avoid-unnecessary-denies.patch
knfsd-nfsd4-fix-handling-of-directories-without-default-acls.patch
knfsd-stop-nfsd-writes-from-being-broken-into-lots-of-little-writes-to-filesystem.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
