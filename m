From: akpm@osdl.org
Subject: - gss_spkm3-fix-error-handling-in-module-init.patch removed from -mm tree
Date: Fri, 22 Dec 2006 23:54:24 -0800
Message-ID: <200612230754.kBN7sO1e010209@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49722 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149AbWLWHy3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Dec 2006 02:54:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, Trond.Myklebust@netapp.com, andros@citi.umich.edu, bfields@citi.umich.edu, mm-commits@vger.kernel.org


The patch titled
     gss_spkm3: fix error handling in module init
has been removed from the -mm tree.  Its filename was
     gss_spkm3-fix-error-handling-in-module-init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: gss_spkm3: fix error handling in module init
From: Akinobu Mita <akinobu.mita@gmail.com>

Return error and prevent from loading module when gss_mech_register()
failed.

Cc: Andy Adamson <andros@citi.umich.edu>
Cc: J. Bruce Fields <bfields@citi.umich.edu>
Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/sunrpc/auth_gss/gss_spkm3_mech.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN net/sunrpc/auth_gss/gss_spkm3_mech.c~gss_spkm3-fix-error-handling-in-module-init net/sunrpc/auth_gss/gss_spkm3_mech.c
--- a/net/sunrpc/auth_gss/gss_spkm3_mech.c~gss_spkm3-fix-error-handling-in-module-init
+++ a/net/sunrpc/auth_gss/gss_spkm3_mech.c
@@ -228,7 +228,7 @@ static int __init init_spkm3_module(void
 	status = gss_mech_register(&gss_spkm3_mech);
 	if (status)
 		printk("Failed to register spkm3 gss mechanism!\n");
-	return 0;
+	return status;
 }
 
 static void __exit cleanup_spkm3_module(void)
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
powerpc-use-is_init.patch
git-dvb.patch
ehca-fix-kthread_create-error-check.patch
ehca-fix-do_mmap-error-check.patch
git-input.patch
git-mtd.patch
net-use-bitrev8.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
iscsi-fix-crypto_alloc_hash-error-check.patch
git-watchdog.patch

