From: akpm@linux-foundation.org
Subject: - knfsd-various-nfsd-xdr-cleanups.patch removed from -mm tree
Date: Wed, 09 May 2007 14:53:19 -0700
Message-ID: <200705092153.l49LrJ5u003078@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759487AbXEIVxl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:53:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: various nfsd xdr cleanups
has been removed from the -mm tree.  Its filename was
     knfsd-various-nfsd-xdr-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: various nfsd xdr cleanups
From: NeilBrown <neilb@suse.de>

1/ decode_sattr and decode_sattr3 never return NULL, so remove
   several checks for that. ditto for xdr_decode_hyper.

2/ replace some open coded XDR_QUADLEN calls with calls to
   XDR_QUADLEN

3/ in decode_writeargs, simply an 'if' to use a single
   calculation.
   .page_len is the length of that part of the packet that did
   not fit in the first page (the head).
   So the length of the data part is the remainder of the
   head, plus page_len.

3/ other minor cleanups.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs3xdr.c |   55 ++++++++++++++++----------------------------
 fs/nfsd/nfsxdr.c  |   39 +++++++++++--------------------
 2 files changed, 34 insertions(+), 60 deletions(-)

diff -puN fs/nfsd/nfs3xdr.c~knfsd-various-nfsd-xdr-cleanups fs/nfsd/nfs3xdr.c
--- a/fs/nfsd/nfs3xdr.c~knfsd-various-nfsd-xdr-cleanups
+++ a/fs/nfsd/nfs3xdr.c
@@ -239,7 +239,7 @@ static __be32 *
 encode_post_op_attr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp)
 {
 	struct dentry *dentry = fhp->fh_dentry;
-	if (dentry && dentry->d_inode != NULL) {
+	if (dentry && dentry->d_inode) {
 	        int err;
 		struct kstat stat;
 
@@ -300,9 +300,9 @@ int
 nfs3svc_decode_sattrargs(struct svc_rqst *rqstp, __be32 *p,
 					struct nfsd3_sattrargs *args)
 {
-	if (!(p = decode_fh(p, &args->fh))
-	 || !(p = decode_sattr3(p, &args->attrs)))
+	if (!(p = decode_fh(p, &args->fh)))
 		return 0;
+	p = decode_sattr3(p, &args->attrs);
 
 	if ((args->check_guard = ntohl(*p++)) != 0) { 
 		struct timespec time; 
@@ -343,9 +343,9 @@ nfs3svc_decode_readargs(struct svc_rqst 
 	int v,pn;
 	u32 max_blocksize = svc_max_payload(rqstp);
 
-	if (!(p = decode_fh(p, &args->fh))
-	 || !(p = xdr_decode_hyper(p, &args->offset)))
+	if (!(p = decode_fh(p, &args->fh)))
 		return 0;
+	p = xdr_decode_hyper(p, &args->offset);
 
 	len = args->count = ntohl(*p++);
 
@@ -372,9 +372,9 @@ nfs3svc_decode_writeargs(struct svc_rqst
 	unsigned int len, v, hdr, dlen;
 	u32 max_blocksize = svc_max_payload(rqstp);
 
-	if (!(p = decode_fh(p, &args->fh))
-	 || !(p = xdr_decode_hyper(p, &args->offset)))
+	if (!(p = decode_fh(p, &args->fh)))
 		return 0;
+	p = xdr_decode_hyper(p, &args->offset);
 
 	args->count = ntohl(*p++);
 	args->stable = ntohl(*p++);
@@ -388,29 +388,16 @@ nfs3svc_decode_writeargs(struct svc_rqst
 	/*
 	 * Check to make sure that we got the right number of
 	 * bytes.
-	 *
-	 * If more than one page was used, then compute the length
-	 * of the data in the request as the total size of the
-	 * request minus the transport protocol headers minus the
-	 * RPC protocol headers minus the NFS protocol fields
-	 * already consumed.  If the request fits into a single
-	 * page, then compete the length of the data as the size
-	 * of the NFS portion of the request minus the NFS
-	 * protocol fields already consumed.
 	 */
 	hdr = (void*)p - rqstp->rq_arg.head[0].iov_base;
-	if (rqstp->rq_respages != rqstp->rq_pages + 1) {
-		dlen = rqstp->rq_arg.len -
-			(PAGE_SIZE - rqstp->rq_arg.head[0].iov_len) - hdr;
-	} else {
-		dlen = rqstp->rq_arg.head[0].iov_len - hdr;
-	}
+	dlen = rqstp->rq_arg.head[0].iov_len + rqstp->rq_arg.page_len
+		- hdr;
 	/*
 	 * Round the length of the data which was specified up to
 	 * the next multiple of XDR units and then compare that
 	 * against the length which was actually received.
 	 */
-	if (dlen != ((len + 3) & ~0x3))
+	if (dlen != XDR_QUADLEN(len)*4)
 		return 0;
 
 	if (args->count > max_blocksize) {
@@ -442,8 +429,7 @@ nfs3svc_decode_createargs(struct svc_rqs
 	switch (args->createmode = ntohl(*p++)) {
 	case NFS3_CREATE_UNCHECKED:
 	case NFS3_CREATE_GUARDED:
-		if (!(p = decode_sattr3(p, &args->attrs)))
-			return 0;
+		p = decode_sattr3(p, &args->attrs);
 		break;
 	case NFS3_CREATE_EXCLUSIVE:
 		args->verf = p;
@@ -459,10 +445,10 @@ int
 nfs3svc_decode_mkdirargs(struct svc_rqst *rqstp, __be32 *p,
 					struct nfsd3_createargs *args)
 {
-	if (!(p = decode_fh(p, &args->fh))
-	 || !(p = decode_filename(p, &args->name, &args->len))
-	 || !(p = decode_sattr3(p, &args->attrs)))
+	if (!(p = decode_fh(p, &args->fh)) ||
+	    !(p = decode_filename(p, &args->name, &args->len)))
 		return 0;
+	p = decode_sattr3(p, &args->attrs);
 
 	return xdr_argsize_check(rqstp, p);
 }
@@ -476,11 +462,12 @@ nfs3svc_decode_symlinkargs(struct svc_rq
 	char *old, *new;
 	struct kvec *vec;
 
-	if (!(p = decode_fh(p, &args->ffh))
-	 || !(p = decode_filename(p, &args->fname, &args->flen))
-	 || !(p = decode_sattr3(p, &args->attrs))
+	if (!(p = decode_fh(p, &args->ffh)) ||
+	    !(p = decode_filename(p, &args->fname, &args->flen))
 		)
 		return 0;
+	p = decode_sattr3(p, &args->attrs);
+
 	/* now decode the pathname, which might be larger than the first page.
 	 * As we have to check for nul's anyway, we copy it into a new page
 	 * This page appears in the rq_res.pages list, but as pages_len is always
@@ -530,10 +517,8 @@ nfs3svc_decode_mknodargs(struct svc_rqst
 	args->ftype = ntohl(*p++);
 
 	if (args->ftype == NF3BLK  || args->ftype == NF3CHR
-	 || args->ftype == NF3SOCK || args->ftype == NF3FIFO) {
-		if (!(p = decode_sattr3(p, &args->attrs)))
-			return 0;
-	}
+	 || args->ftype == NF3SOCK || args->ftype == NF3FIFO)
+		p = decode_sattr3(p, &args->attrs);
 
 	if (args->ftype == NF3BLK || args->ftype == NF3CHR) {
 		args->major = ntohl(*p++);
diff -puN fs/nfsd/nfsxdr.c~knfsd-various-nfsd-xdr-cleanups fs/nfsd/nfsxdr.c
--- a/fs/nfsd/nfsxdr.c~knfsd-various-nfsd-xdr-cleanups
+++ a/fs/nfsd/nfsxdr.c
@@ -231,9 +231,10 @@ int
 nfssvc_decode_sattrargs(struct svc_rqst *rqstp, __be32 *p,
 					struct nfsd_sattrargs *args)
 {
-	if (!(p = decode_fh(p, &args->fh))
-	 || !(p = decode_sattr(p, &args->attrs)))
+	p = decode_fh(p, &args->fh);
+	if (!p)
 		return 0;
+	p = decode_sattr(p, &args->attrs);
 
 	return xdr_argsize_check(rqstp, p);
 }
@@ -303,29 +304,17 @@ nfssvc_decode_writeargs(struct svc_rqst 
 	/*
 	 * Check to make sure that we got the right number of
 	 * bytes.
-	 *
-	 * If more than one page was used, then compute the length
-	 * of the data in the request as the total size of the
-	 * request minus the transport protocol headers minus the
-	 * RPC protocol headers minus the NFS protocol fields
-	 * already consumed.  If the request fits into a single
-	 * page, then compete the length of the data as the size
-	 * of the NFS portion of the request minus the NFS
-	 * protocol fields already consumed.
 	 */
 	hdr = (void*)p - rqstp->rq_arg.head[0].iov_base;
-	if (rqstp->rq_respages != rqstp->rq_pages + 1) {
-		dlen = rqstp->rq_arg.len -
-			(PAGE_SIZE - rqstp->rq_arg.head[0].iov_len) - hdr;
-	} else {
-		dlen = rqstp->rq_arg.head[0].iov_len - hdr;
-	}
+	dlen = rqstp->rq_arg.head[0].iov_len + rqstp->rq_arg.page_len
+		- hdr;
+
 	/*
 	 * Round the length of the data which was specified up to
 	 * the next multiple of XDR units and then compare that
 	 * against the length which was actually received.
 	 */
-	if (dlen != ((len + 3) & ~0x3))
+	if (dlen != XDR_QUADLEN(len)*4)
 		return 0;
 
 	rqstp->rq_vec[0].iov_base = (void*)p;
@@ -346,10 +335,10 @@ int
 nfssvc_decode_createargs(struct svc_rqst *rqstp, __be32 *p,
 					struct nfsd_createargs *args)
 {
-	if (!(p = decode_fh(p, &args->fh))
-	 || !(p = decode_filename(p, &args->name, &args->len))
-	 || !(p = decode_sattr(p, &args->attrs)))
+	if (   !(p = decode_fh(p, &args->fh))
+	    || !(p = decode_filename(p, &args->name, &args->len)))
 		return 0;
+	p = decode_sattr(p, &args->attrs);
 
 	return xdr_argsize_check(rqstp, p);
 }
@@ -393,11 +382,11 @@ int
 nfssvc_decode_symlinkargs(struct svc_rqst *rqstp, __be32 *p,
 					struct nfsd_symlinkargs *args)
 {
-	if (!(p = decode_fh(p, &args->ffh))
-	 || !(p = decode_filename(p, &args->fname, &args->flen))
-	 || !(p = decode_pathname(p, &args->tname, &args->tlen))
-	 || !(p = decode_sattr(p, &args->attrs)))
+	if (   !(p = decode_fh(p, &args->ffh))
+	    || !(p = decode_filename(p, &args->fname, &args->flen))
+	    || !(p = decode_pathname(p, &args->tname, &args->tlen)))
 		return 0;
+	p = decode_sattr(p, &args->attrs);
 
 	return xdr_argsize_check(rqstp, p);
 }
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
introduce-freezer-flags-rev-2.patch
git-md-accel.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
