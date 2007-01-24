From: akpm@osdl.org
Subject: + knfsd-fix-setting-of-acl-server-versions.patch added to -mm tree
Date: Tue, 23 Jan 2007 22:52:38 -0800
Message-ID: <200701240652.l0O6qc6F010841@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:54779 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932968AbXAXGwr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Jan 2007 01:52:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de


The patch titled
     knfsd: fix setting of ACL server versions
has been added to the -mm tree.  Its filename is
     knfsd-fix-setting-of-acl-server-versions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: fix setting of ACL server versions
From: NeilBrown <neilb@suse.de>

Due to silly typos, if the nfs versions are explicitly set, no NFSACL versions
get enabled.

Also improve an error message that would have made this bug a little easier to
find.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/nfsd/nfssvc.c |    8 ++++----
 net/sunrpc/svc.c |    3 ++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/nfsd/nfssvc.c~knfsd-fix-setting-of-acl-server-versions fs/nfsd/nfssvc.c
--- a/fs/nfsd/nfssvc.c~knfsd-fix-setting-of-acl-server-versions
+++ a/fs/nfsd/nfssvc.c
@@ -72,7 +72,7 @@ static struct svc_program	nfsd_acl_progr
 	.pg_prog		= NFS_ACL_PROGRAM,
 	.pg_nvers		= NFSD_ACL_NRVERS,
 	.pg_vers		= nfsd_acl_versions,
-	.pg_name		= "nfsd",
+	.pg_name		= "nfsacl",
 	.pg_class		= "nfsd",
 	.pg_stats		= &nfsd_acl_svcstats,
 	.pg_authenticate	= &svc_set_client,
@@ -118,16 +118,16 @@ int nfsd_vers(int vers, enum vers_op cha
 	switch(change) {
 	case NFSD_SET:
 		nfsd_versions[vers] = nfsd_version[vers];
-		break;
 #if defined(CONFIG_NFSD_V2_ACL) || defined(CONFIG_NFSD_V3_ACL)
 		if (vers < NFSD_ACL_NRVERS)
-			nfsd_acl_version[vers] = nfsd_acl_version[vers];
+			nfsd_acl_versions[vers] = nfsd_acl_version[vers];
 #endif
+		break;
 	case NFSD_CLEAR:
 		nfsd_versions[vers] = NULL;
 #if defined(CONFIG_NFSD_V2_ACL) || defined(CONFIG_NFSD_V3_ACL)
 		if (vers < NFSD_ACL_NRVERS)
-			nfsd_acl_version[vers] = NULL;
+			nfsd_acl_versions[vers] = NULL;
 #endif
 		break;
 	case NFSD_TEST:
diff -puN net/sunrpc/svc.c~knfsd-fix-setting-of-acl-server-versions net/sunrpc/svc.c
--- a/net/sunrpc/svc.c~knfsd-fix-setting-of-acl-server-versions
+++ a/net/sunrpc/svc.c
@@ -910,7 +910,8 @@ err_bad_prog:
 
 err_bad_vers:
 #ifdef RPC_PARANOIA
-	printk("svc: unknown version (%d)\n", vers);
+	printk("svc: unknown version (%d for prog %d, %s)\n",
+	       vers, prog, progp->pg_name);
 #endif
 	serv->sv_stats->rpcbadfmt++;
 	svc_putnl(resv, RPC_PROG_MISMATCH);
_

Patches currently in -mm which might be from neilb@suse.de are

knfsd-update-email-address-and-status-for-nfsd-in-maintainers.patch
knfsd-fix-setting-of-acl-server-versions.patch
knfsd-fix-an-nfsd-bug-with-full-sized-non-page-aligned-reads.patch
knfsd-replace-some-warning-ins-nfsfhh-with-bug_on-or-warn_on.patch
knfsd-dont-mess-with-the-mode-when-storing-a-exclusive-create-cookie.patch
use-correct-macros-in-raid-code-not-raw-asm.patch
use-correct-macros-in-raid-code-not-raw-asm-include.patch
igrab-should-check-for-i_clear.patch
knfsd-sunrpc-update-internal-api-separate-pmap-register-and-temp-sockets.patch
knfsd-sunrpc-allow-creating-an-rpc-service-without-registering-with-portmapper.patch
knfsd-sunrpc-cache-remote-peers-address-in-svc_sock.patch
knfsd-sunrpc-use-sockaddr_storage-to-store-address-in-svc_deferred_req.patch
knfsd-sunrpc-add-a-function-to-format-the-address-in-an-svc_rqst-for-printing.patch
include-linux-nfsd-consth-remove-nfs_super_magic.patch
readahead-nfsd-case.patch
readahead-nfsd-case-fix.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
