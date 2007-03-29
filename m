From: akpm@linux-foundation.org
Subject: - knfsd-nfsd4-demote-clientid-in-use-printk-to-a-dprintk.patch removed from -mm tree
Date: Thu, 29 Mar 2007 00:41:37 -0700
Message-ID: <200703290741.l2T7fbMg030243@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46047 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311AbXC2Hln (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 03:41:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: nfsd4: demote "clientid in use" printk to a dprintk
has been removed from the -mm tree.  Its filename was
     knfsd-nfsd4-demote-clientid-in-use-printk-to-a-dprintk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: nfsd4: demote "clientid in use" printk to a dprintk
From: Bruce Fields <bfields@citi.umich.edu>

The reused clientid here is a more of a problem for the client than the
server, and the client can report the problem itself if it's serious.

Signed-off-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfsd/nfs4state.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/nfsd/nfs4state.c~knfsd-nfsd4-demote-clientid-in-use-printk-to-a-dprintk fs/nfsd/nfs4state.c
--- a/fs/nfsd/nfs4state.c~knfsd-nfsd4-demote-clientid-in-use-printk-to-a-dprintk
+++ a/fs/nfsd/nfs4state.c
@@ -750,9 +750,8 @@ nfsd4_setclientid(struct svc_rqst *rqstp
 		status = nfserr_clid_inuse;
 		if (!cmp_creds(&conf->cl_cred, &rqstp->rq_cred)
 				|| conf->cl_addr != sin->sin_addr.s_addr) {
-			printk("NFSD: setclientid: string in use by client"
-			"(clientid %08x/%08x)\n",
-			conf->cl_clientid.cl_boot, conf->cl_clientid.cl_id);
+			dprintk("NFSD: setclientid: string in use by client"
+				"at %u.%u.%u.%u\n", NIPQUAD(conf->cl_addr));
 			goto out;
 		}
 	}
_

Patches currently in -mm which might be from bfields@citi.umich.edu are

origin.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
remove-nfs4_acl_add_ace.patch
