From: akpm@linux-foundation.org
Subject: + knfsd-nfsd4-fix-non-terminated-string.patch added to -mm tree
Date: Wed, 14 Feb 2007 13:14:23 -0800
Message-ID: <200702142114.l1ELENnL009264@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46067 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932605AbXBNVO3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 14 Feb 2007 16:14:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: nfsd4: fix non-terminated string
has been added to the -mm tree.  Its filename is
     knfsd-nfsd4-fix-non-terminated-string.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 6 insertions(+), 1 deletion(-)

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

auth_gss-unregister-gss_domain-when-unloading-module.patch
knfsd-nfsd4-fix-non-terminated-string.patch
knfsd-nfsd4-relax-checking-of-acl-inheritance-bits.patch
knfsd-nfsd4-simplify-nfsv4-posix-translation.patch
knfsd-nfsd4-represent-nfsv4-acl-with-array-instead-of-linked-list.patch
knfsd-nfsd4-fix-memory-leak-on-kmalloc-failure-in-savemem.patch
knfsd-nfsd4-fix-error-return-on-unsupported-acl.patch
knfsd-nfsd4-acls-dont-return-explicit-mask.patch
knfsd-nfsd4-acls-avoid-unnecessary-denies.patch
knfsd-nfsd4-fix-handling-of-directories-without-default-acls.patch
