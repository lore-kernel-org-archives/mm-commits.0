From: akpm@osdl.org
Subject: + nfsd-fix-mismatch-between-encode_dent_fn-and-filldir_t.patch added to -mm tree
Date: Tue, 23 Jan 2007 23:04:06 -0800
Message-ID: <200701240704.l0O746v5011093@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55131 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933180AbXAXHFh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 02:05:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: paubert@iram.es, neilb@suse.de, stable@kernel.org


The patch titled
     nfsd: Fix mismatch between encode_dent_fn and filldir_t
has been added to the -mm tree.  Its filename is
     nfsd-fix-mismatch-between-encode_dent_fn-and-filldir_t.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nfsd: Fix mismatch between encode_dent_fn and filldir_t
From: Gabriel Paubert <paubert@iram.es>

The 5th parameter of filldir_t function type used by vfs_readdir was
changed from ino_t to u64 in October.  Unfortunately the patch missed some
files in fs/nfsd where functions pointers of type encode_dent_fn are passed
around and finally cast to filldir_t.

The effect is only visible when an NFS server is run on a 32 bit big-endian
machine (it would have been visible on all 32 bit architectures if the 6th
parameter had been used).  The results are interesting: all files have an
inode of 0 (unique you say?) from getdents(2) and even ls(1) does not find
any files.

Signed-off-by: Gabriel Paubert <paubert@iram.es>
Cc: Neil Brown <neilb@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/nfs3xdr.c         |    4 ++--
 fs/nfsd/nfsxdr.c          |    2 +-
 include/linux/nfsd/nfsd.h |    2 +-
 include/linux/nfsd/xdr.h  |    2 +-
 include/linux/nfsd/xdr3.h |    4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/nfsd/nfs3xdr.c~nfsd-fix-mismatch-between-encode_dent_fn-and-filldir_t fs/nfsd/nfs3xdr.c
--- a/fs/nfsd/nfs3xdr.c~nfsd-fix-mismatch-between-encode_dent_fn-and-filldir_t
+++ a/fs/nfsd/nfs3xdr.c
@@ -991,14 +991,14 @@ encode_entry(struct readdir_cd *ccd, con
 
 int
 nfs3svc_encode_entry(struct readdir_cd *cd, const char *name,
-		     int namlen, loff_t offset, ino_t ino, unsigned int d_type)
+		     int namlen, loff_t offset, u64 ino, unsigned int d_type)
 {
 	return encode_entry(cd, name, namlen, offset, ino, d_type, 0);
 }
 
 int
 nfs3svc_encode_entry_plus(struct readdir_cd *cd, const char *name,
-			  int namlen, loff_t offset, ino_t ino, unsigned int d_type)
+			  int namlen, loff_t offset, u64 ino, unsigned int d_type)
 {
 	return encode_entry(cd, name, namlen, offset, ino, d_type, 1);
 }
diff -puN fs/nfsd/nfsxdr.c~nfsd-fix-mismatch-between-encode_dent_fn-and-filldir_t fs/nfsd/nfsxdr.c
--- a/fs/nfsd/nfsxdr.c~nfsd-fix-mismatch-between-encode_dent_fn-and-filldir_t
+++ a/fs/nfsd/nfsxdr.c
@@ -463,7 +463,7 @@ nfssvc_encode_statfsres(struct svc_rqst 
 
 int
 nfssvc_encode_entry(struct readdir_cd *ccd, const char *name,
-		    int namlen, loff_t offset, ino_t ino, unsigned int d_type)
+		    int namlen, loff_t offset, u64 ino, unsigned int d_type)
 {
 	struct nfsd_readdirres *cd = container_of(ccd, struct nfsd_readdirres, common);
 	__be32	*p = cd->buffer;
diff -puN include/linux/nfsd/nfsd.h~nfsd-fix-mismatch-between-encode_dent_fn-and-filldir_t include/linux/nfsd/nfsd.h
--- a/include/linux/nfsd/nfsd.h~nfsd-fix-mismatch-between-encode_dent_fn-and-filldir_t
+++ a/include/linux/nfsd/nfsd.h
@@ -53,7 +53,7 @@ struct readdir_cd {
 	__be32			err;	/* 0, nfserr, or nfserr_eof */
 };
 typedef int		(*encode_dent_fn)(struct readdir_cd *, const char *,
-						int, loff_t, ino_t, unsigned int);
+						int, loff_t, u64, unsigned int);
 typedef int (*nfsd_dirop_t)(struct inode *, struct dentry *, int, int);
 
 extern struct svc_program	nfsd_program;
diff -puN include/linux/nfsd/xdr3.h~nfsd-fix-mismatch-between-encode_dent_fn-and-filldir_t include/linux/nfsd/xdr3.h
--- a/include/linux/nfsd/xdr3.h~nfsd-fix-mismatch-between-encode_dent_fn-and-filldir_t
+++ a/include/linux/nfsd/xdr3.h
@@ -332,10 +332,10 @@ int nfs3svc_release_fhandle(struct svc_r
 int nfs3svc_release_fhandle2(struct svc_rqst *, __be32 *,
 				struct nfsd3_fhandle_pair *);
 int nfs3svc_encode_entry(struct readdir_cd *, const char *name,
-				int namlen, loff_t offset, ino_t ino,
+				int namlen, loff_t offset, u64 ino,
 				unsigned int);
 int nfs3svc_encode_entry_plus(struct readdir_cd *, const char *name,
-				int namlen, loff_t offset, ino_t ino,
+				int namlen, loff_t offset, u64 ino,
 				unsigned int);
 /* Helper functions for NFSv3 ACL code */
 __be32 *nfs3svc_encode_post_op_attr(struct svc_rqst *rqstp, __be32 *p,
diff -puN include/linux/nfsd/xdr.h~nfsd-fix-mismatch-between-encode_dent_fn-and-filldir_t include/linux/nfsd/xdr.h
--- a/include/linux/nfsd/xdr.h~nfsd-fix-mismatch-between-encode_dent_fn-and-filldir_t
+++ a/include/linux/nfsd/xdr.h
@@ -166,7 +166,7 @@ int nfssvc_encode_statfsres(struct svc_r
 int nfssvc_encode_readdirres(struct svc_rqst *, __be32 *, struct nfsd_readdirres *);
 
 int nfssvc_encode_entry(struct readdir_cd *, const char *name,
-				int namlen, loff_t offset, ino_t ino, unsigned int);
+				int namlen, loff_t offset, u64 ino, unsigned int);
 
 int nfssvc_release_fhandle(struct svc_rqst *, __be32 *, struct nfsd_fhandle *);
 
_

Patches currently in -mm which might be from paubert@iram.es are

nfsd-fix-mismatch-between-encode_dent_fn-and-filldir_t.patch
