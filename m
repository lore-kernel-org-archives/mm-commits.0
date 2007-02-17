From: akpm@linux-foundation.org
Subject: - knfsd-nfsd4-fix-non-terminated-string.patch removed from -mm tree
Date: Fri, 16 Feb 2007 23:16:05 -0800
Message-ID: <200702170716.l1H7G5Q2021676@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51090 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946478AbXBQHQL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 02:16:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: fix non-terminated string
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-fix-non-terminated-string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd4: fix non-terminated string
From: J. Bruce Fields <bfields@citi.umich.edu>

The server name is expected to be a null-terminated string, so we can't pass
in the raw client identifier.

What's more, the client identifier is just a binary, not necessarily
printable, blob.  Let's just use the ip address instead.  The server name
appears to exist just to help debugging by making some printk's more
informative.

Note that the string is copies into the rpc client structure, so the pointer
to the local variable does not outlive the function call.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4callback.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN fs/nfsd/nfs4callback.c~knfsd-nfsd4-fix-non-terminated-string fs/nfsd/nfs4callback.c
--- a/fs/nfsd/nfs4callback.c~knfsd-nfsd4-fix-non-terminated-string
+++ a/fs/nfsd/nfs4callback.c
@@ -387,7 +387,6 @@ nfsd4_probe_callback(struct nfs4_client 
 		.address	= (struct sockaddr *)&addr,
 		.addrsize	= sizeof(addr),
 		.timeout	= &timeparms,
-		.servername	= clp->cl_name.data,
 		.program	= program,
 		.version	= nfs_cb_version[1]->number,
 		.authflavor	= RPC_AUTH_UNIX,	/* XXX: need AUTH_GSS... */
@@ -397,6 +396,7 @@ nfsd4_probe_callback(struct nfs4_client 
 		.rpc_proc       = &nfs4_cb_procedures[NFSPROC4_CLNT_CB_NULL],
 		.rpc_argp       = clp,
 	};
+	char clientname[16];
 	int status;
 
 	if (atomic_read(&cb->cb_set))
@@ -419,6 +419,11 @@ nfsd4_probe_callback(struct nfs4_client 
 	memset(program->stats, 0, sizeof(cb->cb_stat));
 	program->stats->program = program;
 
+	/* Just here to make some printk's more useful: */
+	snprintf(clientname, sizeof(clientname),
+		"%u.%u.%u.%u", NIPQUAD(addr.sin_addr));
+	args.servername = clientname;
+
 	/* Create RPC client */
 	cb->cb_client = rpc_create(&args);
 	if (IS_ERR(cb->cb_client)) {
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
