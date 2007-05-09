From: akpm@linux-foundation.org
Subject: - rpc-add-wrapper-for-svc_reserve-to-account-for-checksum.patch removed from -mm tree
Date: Wed, 09 May 2007 14:52:56 -0700
Message-ID: <200705092152.l49Lqudq003038@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758944AbXEIVxf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:53:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, bfields@citi.umich.edu, neilb@suse.de, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     RPC: add wrapper for svc_reserve to account for checksum
has been removed from the -mm tree.  Its filename was
     rpc-add-wrapper-for-svc_reserve-to-account-for-checksum.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: RPC: add wrapper for svc_reserve to account for checksum
From: Jeff Layton <jlayton@redhat.com>

When the kernel calls svc_reserve to downsize the expected size of an RPC
reply, it fails to account for the possibility of a checksum at the end of
the packet.  If a client mounts a NFSv2/3 with sec=krb5i/p, and does I/O
then you'll generally see messages similar to this in the server's ring
buffer:

RPC request reserved 164 but used 208

While I was never able to verify it, I suspect that this problem is also
the root cause of some oopses I've seen under these conditions:

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=227726

This is probably also a problem for other sec= types and for NFSv4.  The
large reserved size for NFSv4 compound packets seems to generally paper
over the problem, however.

This patch adds a wrapper for svc_reserve that accounts for the possibility
of a checksum.  It also fixes up the appropriate callers of svc_reserve to
call the wrapper.  For now, it just uses a hardcoded value that I
determined via testing.  That value may need to be revised upward as things
change, or we may want to eventually add a new auth_op that attempts to
calculate this somehow.

Unfortunately, there doesn't seem to be a good way to reliably determine
the expected checksum length prior to actually calculating it, particularly
with schemes like spkm3.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Acked-by: Neil Brown <neilb@suse.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Acked-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs3proc.c         |    2 +-
 fs/nfsd/nfsproc.c          |    2 +-
 include/linux/sunrpc/svc.h |   19 +++++++++++++++++++
 net/sunrpc/svc.c           |    2 +-
 4 files changed, 22 insertions(+), 3 deletions(-)

diff -puN fs/nfsd/nfs3proc.c~rpc-add-wrapper-for-svc_reserve-to-account-for-checksum fs/nfsd/nfs3proc.c
--- a/fs/nfsd/nfs3proc.c~rpc-add-wrapper-for-svc_reserve-to-account-for-checksum
+++ a/fs/nfsd/nfs3proc.c
@@ -177,7 +177,7 @@ nfsd3_proc_read(struct svc_rqst *rqstp, 
 	if (max_blocksize < resp->count)
 		resp->count = max_blocksize;
 
-	svc_reserve(rqstp, ((1 + NFS3_POST_OP_ATTR_WORDS + 3)<<2) + resp->count +4);
+	svc_reserve_auth(rqstp, ((1 + NFS3_POST_OP_ATTR_WORDS + 3)<<2) + resp->count +4);
 
 	fh_copy(&resp->fh, &argp->fh);
 	nfserr = nfsd_read(rqstp, &resp->fh, NULL,
diff -puN fs/nfsd/nfsproc.c~rpc-add-wrapper-for-svc_reserve-to-account-for-checksum fs/nfsd/nfsproc.c
--- a/fs/nfsd/nfsproc.c~rpc-add-wrapper-for-svc_reserve-to-account-for-checksum
+++ a/fs/nfsd/nfsproc.c
@@ -155,7 +155,7 @@ nfsd_proc_read(struct svc_rqst *rqstp, s
 				argp->count);
 		argp->count = NFSSVC_MAXBLKSIZE_V2;
 	}
-	svc_reserve(rqstp, (19<<2) + argp->count + 4);
+	svc_reserve_auth(rqstp, (19<<2) + argp->count + 4);
 
 	resp->count = argp->count;
 	nfserr = nfsd_read(rqstp, fh_copy(&resp->fh, &argp->fh), NULL,
diff -puN include/linux/sunrpc/svc.h~rpc-add-wrapper-for-svc_reserve-to-account-for-checksum include/linux/sunrpc/svc.h
--- a/include/linux/sunrpc/svc.h~rpc-add-wrapper-for-svc_reserve-to-account-for-checksum
+++ a/include/linux/sunrpc/svc.h
@@ -396,4 +396,23 @@ char *		   svc_print_addr(struct svc_rqs
 
 #define	RPC_MAX_ADDRBUFLEN	(63U)
 
+/*
+ * When we want to reduce the size of the reserved space in the response
+ * buffer, we need to take into account the size of any checksum data that
+ * may be at the end of the packet. This is difficult to determine exactly
+ * for all cases without actually generating the checksum, so we just use a
+ * static value.
+ */
+static inline void
+svc_reserve_auth(struct svc_rqst *rqstp, int space)
+{
+	int			added_space = 0;
+
+	switch(rqstp->rq_authop->flavour) {
+		case RPC_AUTH_GSS:
+			added_space = RPC_MAX_AUTH_SIZE;
+	}
+	return svc_reserve(rqstp, space + added_space);
+}
+
 #endif /* SUNRPC_SVC_H */
diff -puN net/sunrpc/svc.c~rpc-add-wrapper-for-svc_reserve-to-account-for-checksum net/sunrpc/svc.c
--- a/net/sunrpc/svc.c~rpc-add-wrapper-for-svc_reserve-to-account-for-checksum
+++ a/net/sunrpc/svc.c
@@ -907,7 +907,7 @@ svc_process(struct svc_rqst *rqstp)
 	 * better idea of reply size
 	 */
 	if (procp->pc_xdrressize)
-		svc_reserve(rqstp, procp->pc_xdrressize<<2);
+		svc_reserve_auth(rqstp, procp->pc_xdrressize<<2);
 
 	/* Call the function that processes the request. */
 	if (!versp->vs_dispatch) {
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
