From: akpm@osdl.org
Subject: + knfsd-fix-type-mismatch-with-filldir_t-used-by-nfsd.patch added to -mm tree
Date: Wed, 24 Jan 2007 20:37:51 -0800
Message-ID: <200701250437.l0P4bpXV005945@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46447 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933206AbXAYEiA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 23:38:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, paubert@iram.es


The patch titled
     knfsd: Fix type mismatch with filldir_t used by nfsd
has been added to the -mm tree.  Its filename is
     knfsd-fix-type-mismatch-with-filldir_t-used-by-nfsd.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: Fix type mismatch with filldir_t used by nfsd
From: NeilBrown <neilb@suse.de>

nfsd defines a type 'encode_dent_fn' which is much like 'filldir_t' except
that the first pointer is 'struct readdir_cd *' rather than 'void *'.  It
then casts encode_dent_fn points to 'filldir_t' as needed.  This hides any
other type mismatches between the two such as the fact that the 'ino' arg
recently changed from ino_t to u64.

So: get rid of 'encode_dent_fn', get rid of the cast of the function type,
change the first arg of various functions from 'struct readdir_cd *' to
'void *', and live with the fact that we have a little less type checking
on the calling of these functions now.  Less internal (to nfsd) checking
offset by more external checking, which is more important.

Thanks to Gabriel Paubert <paubert@iram.es> for discovering this and
providing an initial patch.

Signed-off-by: Gabriel Paubert <paubert@iram.es>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/nfs3xdr.c         |    9 +++++----
 fs/nfsd/nfs4xdr.c         |    5 +++--
 fs/nfsd/nfsxdr.c          |    5 +++--
 fs/nfsd/vfs.c             |    4 ++--
 include/linux/nfsd/nfsd.h |    4 +---
 include/linux/nfsd/xdr.h  |    4 ++--
 include/linux/nfsd/xdr3.h |    8 ++++----
 7 files changed, 20 insertions(+), 19 deletions(-)

diff -puN fs/nfsd/nfs3xdr.c~knfsd-fix-type-mismatch-with-filldir_t-used-by-nfsd fs/nfsd/nfs3xdr.c
--- a/fs/nfsd/nfs3xdr.c~knfsd-fix-type-mismatch-with-filldir_t-used-by-nfsd
+++ a/fs/nfsd/nfs3xdr.c
@@ -990,15 +990,16 @@ encode_entry(struct readdir_cd *ccd, con
 }
 
 int
-nfs3svc_encode_entry(struct readdir_cd *cd, const char *name,
-		     int namlen, loff_t offset, ino_t ino, unsigned int d_type)
+nfs3svc_encode_entry(void *cd, const char *name,
+		     int namlen, loff_t offset, u64 ino, unsigned int d_type)
 {
 	return encode_entry(cd, name, namlen, offset, ino, d_type, 0);
 }
 
 int
-nfs3svc_encode_entry_plus(struct readdir_cd *cd, const char *name,
-			  int namlen, loff_t offset, ino_t ino, unsigned int d_type)
+nfs3svc_encode_entry_plus(void *cd, const char *name,
+			  int namlen, loff_t offset, u64 ino,
+			  unsigned int d_type)
 {
 	return encode_entry(cd, name, namlen, offset, ino, d_type, 1);
 }
diff -puN fs/nfsd/nfs4xdr.c~knfsd-fix-type-mismatch-with-filldir_t-used-by-nfsd fs/nfsd/nfs4xdr.c
--- a/fs/nfsd/nfs4xdr.c~knfsd-fix-type-mismatch-with-filldir_t-used-by-nfsd
+++ a/fs/nfsd/nfs4xdr.c
@@ -1880,9 +1880,10 @@ nfsd4_encode_rdattr_error(__be32 *p, int
 }
 
 static int
-nfsd4_encode_dirent(struct readdir_cd *ccd, const char *name, int namlen,
-		    loff_t offset, ino_t ino, unsigned int d_type)
+nfsd4_encode_dirent(void *ccdv, const char *name, int namlen,
+		    loff_t offset, u64 ino, unsigned int d_type)
 {
+	struct readdir_cd *ccd = ccdv;
 	struct nfsd4_readdir *cd = container_of(ccd, struct nfsd4_readdir, common);
 	int buflen;
 	__be32 *p = cd->buffer;
diff -puN fs/nfsd/nfsxdr.c~knfsd-fix-type-mismatch-with-filldir_t-used-by-nfsd fs/nfsd/nfsxdr.c
--- a/fs/nfsd/nfsxdr.c~knfsd-fix-type-mismatch-with-filldir_t-used-by-nfsd
+++ a/fs/nfsd/nfsxdr.c
@@ -462,9 +462,10 @@ nfssvc_encode_statfsres(struct svc_rqst 
 }
 
 int
-nfssvc_encode_entry(struct readdir_cd *ccd, const char *name,
-		    int namlen, loff_t offset, ino_t ino, unsigned int d_type)
+nfssvc_encode_entry(void *ccdv, const char *name,
+		    int namlen, loff_t offset, u64 ino, unsigned int d_type)
 {
+	struct readdir_cd *ccd = ccdv;
 	struct nfsd_readdirres *cd = container_of(ccd, struct nfsd_readdirres, common);
 	__be32	*p = cd->buffer;
 	int	buflen, slen;
diff -puN fs/nfsd/vfs.c~knfsd-fix-type-mismatch-with-filldir_t-used-by-nfsd fs/nfsd/vfs.c
--- a/fs/nfsd/vfs.c~knfsd-fix-type-mismatch-with-filldir_t-used-by-nfsd
+++ a/fs/nfsd/vfs.c
@@ -1716,7 +1716,7 @@ out:
  */
 __be32
 nfsd_readdir(struct svc_rqst *rqstp, struct svc_fh *fhp, loff_t *offsetp, 
-	     struct readdir_cd *cdp, encode_dent_fn func)
+	     struct readdir_cd *cdp, filldir_t func)
 {
 	__be32		err;
 	int 		host_err;
@@ -1741,7 +1741,7 @@ nfsd_readdir(struct svc_rqst *rqstp, str
 
 	do {
 		cdp->err = nfserr_eof; /* will be cleared on successful read */
-		host_err = vfs_readdir(file, (filldir_t) func, cdp);
+		host_err = vfs_readdir(file, func, cdp);
 	} while (host_err >=0 && cdp->err == nfs_ok);
 	if (host_err)
 		err = nfserrno(host_err);
diff -puN include/linux/nfsd/nfsd.h~knfsd-fix-type-mismatch-with-filldir_t-used-by-nfsd include/linux/nfsd/nfsd.h
--- a/include/linux/nfsd/nfsd.h~knfsd-fix-type-mismatch-with-filldir_t-used-by-nfsd
+++ a/include/linux/nfsd/nfsd.h
@@ -52,8 +52,6 @@
 struct readdir_cd {
 	__be32			err;	/* 0, nfserr, or nfserr_eof */
 };
-typedef int		(*encode_dent_fn)(struct readdir_cd *, const char *,
-						int, loff_t, ino_t, unsigned int);
 typedef int (*nfsd_dirop_t)(struct inode *, struct dentry *, int, int);
 
 extern struct svc_program	nfsd_program;
@@ -117,7 +115,7 @@ __be32		nfsd_unlink(struct svc_rqst *, s
 int		nfsd_truncate(struct svc_rqst *, struct svc_fh *,
 				unsigned long size);
 __be32		nfsd_readdir(struct svc_rqst *, struct svc_fh *,
-			     loff_t *, struct readdir_cd *, encode_dent_fn);
+			     loff_t *, struct readdir_cd *, filldir_t);
 __be32		nfsd_statfs(struct svc_rqst *, struct svc_fh *,
 				struct kstatfs *);
 
diff -puN include/linux/nfsd/xdr3.h~knfsd-fix-type-mismatch-with-filldir_t-used-by-nfsd include/linux/nfsd/xdr3.h
--- a/include/linux/nfsd/xdr3.h~knfsd-fix-type-mismatch-with-filldir_t-used-by-nfsd
+++ a/include/linux/nfsd/xdr3.h
@@ -331,11 +331,11 @@ int nfs3svc_release_fhandle(struct svc_r
 				struct nfsd3_attrstat *);
 int nfs3svc_release_fhandle2(struct svc_rqst *, __be32 *,
 				struct nfsd3_fhandle_pair *);
-int nfs3svc_encode_entry(struct readdir_cd *, const char *name,
-				int namlen, loff_t offset, ino_t ino,
+int nfs3svc_encode_entry(void *, const char *name,
+				int namlen, loff_t offset, u64 ino,
 				unsigned int);
-int nfs3svc_encode_entry_plus(struct readdir_cd *, const char *name,
-				int namlen, loff_t offset, ino_t ino,
+int nfs3svc_encode_entry_plus(void *, const char *name,
+				int namlen, loff_t offset, u64 ino,
 				unsigned int);
 /* Helper functions for NFSv3 ACL code */
 __be32 *nfs3svc_encode_post_op_attr(struct svc_rqst *rqstp, __be32 *p,
diff -puN include/linux/nfsd/xdr.h~knfsd-fix-type-mismatch-with-filldir_t-used-by-nfsd include/linux/nfsd/xdr.h
--- a/include/linux/nfsd/xdr.h~knfsd-fix-type-mismatch-with-filldir_t-used-by-nfsd
+++ a/include/linux/nfsd/xdr.h
@@ -165,8 +165,8 @@ int nfssvc_encode_readres(struct svc_rqs
 int nfssvc_encode_statfsres(struct svc_rqst *, __be32 *, struct nfsd_statfsres *);
 int nfssvc_encode_readdirres(struct svc_rqst *, __be32 *, struct nfsd_readdirres *);
 
-int nfssvc_encode_entry(struct readdir_cd *, const char *name,
-				int namlen, loff_t offset, ino_t ino, unsigned int);
+int nfssvc_encode_entry(void *, const char *name,
+			int namlen, loff_t offset, u64 ino, unsigned int);
 
 int nfssvc_release_fhandle(struct svc_rqst *, __be32 *, struct nfsd_fhandle *);
 
_

Patches currently in -mm which might be from neilb@suse.de are

knfsd-update-email-address-and-status-for-nfsd-in-maintainers.patch
knfsd-fix-setting-of-acl-server-versions.patch
knfsd-fix-an-nfsd-bug-with-full-sized-non-page-aligned-reads.patch
knfsd-replace-some-warning-ins-nfsfhh-with-bug_on-or-warn_on.patch
knfsd-dont-mess-with-the-mode-when-storing-a-exclusive-create-cookie.patch
md-update-email-address-and-status-for-md-in-maintainers.patch
md-make-repair-actually-work-for-raid1.patch
md-make-sure-the-events-count-in-an-md-array-never-returns-to-zero.patch
md-avoid-reading-past-the-end-of-a-bitmap-file.patch
knfsd-fix-type-mismatch-with-filldir_t-used-by-nfsd.patch
md-fix-potential-memalloc-deadlock-in-md.patch
nfsd-fix-mismatch-between-encode_dent_fn-and-filldir_t.patch
use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
igrab-should-check-for-i_clear.patch
replace-highest_possible_node_id-with-nr_node_ids.patch
knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch
knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch
knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch
knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch
knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
