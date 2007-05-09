From: akpm@linux-foundation.org
Subject: - the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch removed from -mm tree
Date: Wed, 09 May 2007 14:52:48 -0700
Message-ID: <200705092152.l49Lqme5003029@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44696 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759441AbXEIVxT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:53:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: staubach@redhat.com, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     The NFSv2/NFSv3 server does not handle zero length WRITE requests correctly
has been removed from the -mm tree.  Its filename was
     the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: The NFSv2/NFSv3 server does not handle zero length WRITE requests correctly
From: Peter Staubach <staubach@redhat.com>

The NFSv2 and NFSv3 servers do not handle WRITE requests for 0 bytes
correctly.  The specifications indicate that the server should accept the
request, but it should mostly turn into a no-op.  Currently, the server
will return an XDR decode error, which it should not.

Attached is a patch which addresses this issue.  It also adds some boundary
checking to ensure that the request contains as much data as was requested
to be written.  It also correctly handles an NFSv3 request which requests
to write more data than the server has stated that it is prepared to
handle.  Previously, there was some support which looked like it should
work, but wasn't quite right.

Signed-off-by: Peter Staubach <staubach@redhat.com>
Acked-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs3xdr.c |   48 ++++++++++++++++++++++++++++++++++----------
 fs/nfsd/nfsxdr.c  |   46 +++++++++++++++++++++++++++++++++++-------
 2 files changed, 77 insertions(+), 17 deletions(-)

diff -puN fs/nfsd/nfs3xdr.c~the-nfsv2-nfsv3-server-does-not-handle-zero-length-write fs/nfsd/nfs3xdr.c
--- a/fs/nfsd/nfs3xdr.c~the-nfsv2-nfsv3-server-does-not-handle-zero-length-write
+++ a/fs/nfsd/nfs3xdr.c
@@ -369,7 +369,7 @@ int
 nfs3svc_decode_writeargs(struct svc_rqst *rqstp, __be32 *p,
 					struct nfsd3_writeargs *args)
 {
-	unsigned int len, v, hdr;
+	unsigned int len, v, hdr, dlen;
 	u32 max_blocksize = svc_max_payload(rqstp);
 
 	if (!(p = decode_fh(p, &args->fh))
@@ -379,18 +379,47 @@ nfs3svc_decode_writeargs(struct svc_rqst
 	args->count = ntohl(*p++);
 	args->stable = ntohl(*p++);
 	len = args->len = ntohl(*p++);
+	/*
+	 * The count must equal the amount of data passed.
+	 */
+	if (args->count != args->len)
+		return 0;
 
+	/*
+	 * Check to make sure that we got the right number of
+	 * bytes.
+	 *
+	 * If more than one page was used, then compute the length
+	 * of the data in the request as the total size of the
+	 * request minus the transport protocol headers minus the
+	 * RPC protocol headers minus the NFS protocol fields
+	 * already consumed.  If the request fits into a single
+	 * page, then compete the length of the data as the size
+	 * of the NFS portion of the request minus the NFS
+	 * protocol fields already consumed.
+	 */
 	hdr = (void*)p - rqstp->rq_arg.head[0].iov_base;
-	if (rqstp->rq_arg.len < hdr ||
-	    rqstp->rq_arg.len - hdr < len)
+	if (rqstp->rq_respages != rqstp->rq_pages + 1) {
+		dlen = rqstp->rq_arg.len -
+			(PAGE_SIZE - rqstp->rq_arg.head[0].iov_len) - hdr;
+	} else {
+		dlen = rqstp->rq_arg.head[0].iov_len - hdr;
+	}
+	/*
+	 * Round the length of the data which was specified up to
+	 * the next multiple of XDR units and then compare that
+	 * against the length which was actually received.
+	 */
+	if (dlen != ((len + 3) & ~0x3))
 		return 0;
 
+	if (args->count > max_blocksize) {
+		args->count = max_blocksize;
+		len = args->len = max_blocksize;
+	}
 	rqstp->rq_vec[0].iov_base = (void*)p;
 	rqstp->rq_vec[0].iov_len = rqstp->rq_arg.head[0].iov_len - hdr;
-
-	if (len > max_blocksize)
-		len = max_blocksize;
-	v=  0;
+	v = 0;
 	while (len > rqstp->rq_vec[v].iov_len) {
 		len -= rqstp->rq_vec[v].iov_len;
 		v++;
@@ -398,9 +427,8 @@ nfs3svc_decode_writeargs(struct svc_rqst
 		rqstp->rq_vec[v].iov_len = PAGE_SIZE;
 	}
 	rqstp->rq_vec[v].iov_len = len;
-	args->vlen = v+1;
-
-	return args->count == args->len && rqstp->rq_vec[0].iov_len > 0;
+	args->vlen = v + 1;
+	return 1;
 }
 
 int
diff -puN fs/nfsd/nfsxdr.c~the-nfsv2-nfsv3-server-does-not-handle-zero-length-write fs/nfsd/nfsxdr.c
--- a/fs/nfsd/nfsxdr.c~the-nfsv2-nfsv3-server-does-not-handle-zero-length-write
+++ a/fs/nfsd/nfsxdr.c
@@ -284,8 +284,9 @@ int
 nfssvc_decode_writeargs(struct svc_rqst *rqstp, __be32 *p,
 					struct nfsd_writeargs *args)
 {
-	unsigned int len;
+	unsigned int len, hdr, dlen;
 	int v;
+
 	if (!(p = decode_fh(p, &args->fh)))
 		return 0;
 
@@ -293,11 +294,42 @@ nfssvc_decode_writeargs(struct svc_rqst 
 	args->offset = ntohl(*p++);	/* offset */
 	p++;				/* totalcount */
 	len = args->len = ntohl(*p++);
-	rqstp->rq_vec[0].iov_base = (void*)p;
-	rqstp->rq_vec[0].iov_len = rqstp->rq_arg.head[0].iov_len -
-				(((void*)p) - rqstp->rq_arg.head[0].iov_base);
+	/*
+	 * The protocol specifies a maximum of 8192 bytes.
+	 */
 	if (len > NFSSVC_MAXBLKSIZE_V2)
-		len = NFSSVC_MAXBLKSIZE_V2;
+		return 0;
+
+	/*
+	 * Check to make sure that we got the right number of
+	 * bytes.
+	 *
+	 * If more than one page was used, then compute the length
+	 * of the data in the request as the total size of the
+	 * request minus the transport protocol headers minus the
+	 * RPC protocol headers minus the NFS protocol fields
+	 * already consumed.  If the request fits into a single
+	 * page, then compete the length of the data as the size
+	 * of the NFS portion of the request minus the NFS
+	 * protocol fields already consumed.
+	 */
+	hdr = (void*)p - rqstp->rq_arg.head[0].iov_base;
+	if (rqstp->rq_respages != rqstp->rq_pages + 1) {
+		dlen = rqstp->rq_arg.len -
+			(PAGE_SIZE - rqstp->rq_arg.head[0].iov_len) - hdr;
+	} else {
+		dlen = rqstp->rq_arg.head[0].iov_len - hdr;
+	}
+	/*
+	 * Round the length of the data which was specified up to
+	 * the next multiple of XDR units and then compare that
+	 * against the length which was actually received.
+	 */
+	if (dlen != ((len + 3) & ~0x3))
+		return 0;
+
+	rqstp->rq_vec[0].iov_base = (void*)p;
+	rqstp->rq_vec[0].iov_len = rqstp->rq_arg.head[0].iov_len - hdr;
 	v = 0;
 	while (len > rqstp->rq_vec[v].iov_len) {
 		len -= rqstp->rq_vec[v].iov_len;
@@ -306,8 +338,8 @@ nfssvc_decode_writeargs(struct svc_rqst 
 		rqstp->rq_vec[v].iov_len = PAGE_SIZE;
 	}
 	rqstp->rq_vec[v].iov_len = len;
-	args->vlen = v+1;
-	return rqstp->rq_vec[0].iov_len > 0;
+	args->vlen = v + 1;
+	return 1;
 }
 
 int
_

Patches currently in -mm which might be from staubach@redhat.com are

origin.patch
