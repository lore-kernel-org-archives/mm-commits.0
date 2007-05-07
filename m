From: akpm@linux-foundation.org
Subject: + knfsd-rpc-fix-server-side-wrapping-of-krb5i-replies.patch added to -mm tree
Date: Mon, 07 May 2007 16:08:26 -0700
Message-ID: <200705072308.l47N8QwA007825@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:59403 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754907AbXEGXJo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 19:09:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: neilb@suse.de, bfields@citi.umich.edu, stable@kernel.org


The patch titled
     knfsd: rpc: fix server-side wrapping of krb5i replies
has been added to the -mm tree.  Its filename is
     knfsd-rpc-fix-server-side-wrapping-of-krb5i-replies.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: knfsd: rpc: fix server-side wrapping of krb5i replies
From: NeilBrown <neilb@suse.de>

It's not necessarily correct to assume that the xdr_buf used to hold the
server's reply must have page data whenever it has tail data.

And there's no need for us to deal with that case separately anyway.

Acked-by: "J. Bruce Fields" <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sunrpc/auth_gss/svcauth_gss.c |    8 +-------
 1 files changed, 1 insertion(+), 7 deletions(-)

diff -puN net/sunrpc/auth_gss/svcauth_gss.c~knfsd-rpc-fix-server-side-wrapping-of-krb5i-replies net/sunrpc/auth_gss/svcauth_gss.c
--- a/net/sunrpc/auth_gss/svcauth_gss.c~knfsd-rpc-fix-server-side-wrapping-of-krb5i-replies
+++ a/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1210,13 +1210,7 @@ svcauth_gss_wrap_resp_integ(struct svc_r
 	if (xdr_buf_subsegment(resbuf, &integ_buf, integ_offset,
 				integ_len))
 		BUG();
-	if (resbuf->page_len == 0
-			&& resbuf->head[0].iov_len + RPC_MAX_AUTH_SIZE
-			< PAGE_SIZE) {
-		BUG_ON(resbuf->tail[0].iov_len);
-		/* Use head for everything */
-		resv = &resbuf->head[0];
-	} else if (resbuf->tail[0].iov_base == NULL) {
+	if (resbuf->tail[0].iov_base == NULL) {
 		if (resbuf->head[0].iov_len + RPC_MAX_AUTH_SIZE > PAGE_SIZE)
 			goto out_err;
 		resbuf->tail[0].iov_base = resbuf->head[0].iov_base
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
fix-quadratic-behavior-of-shrink_dcache_parent.patch
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
introduce-freezer-flags-rev-2.patch
the-nfsv2-nfsv3-server-does-not-handle-zero-length-write.patch
knfsd-rename-sk_defer_lock-to-sk_lock.patch
nfsd-nfs4state-remove-unnecessary-daemonize-call.patch
rpc-add-wrapper-for-svc_reserve-to-account-for-checksum.patch
rpc-add-wrapper-for-svc_reserve-to-account-for-checksum-fix.patch
sunrpc-fix-error-path-in-module_init.patch
knfsd-avoid-use-of-unitialised-variables-on-error-path-when-nfs-exports.patch
knfsd-rpc-fix-server-side-wrapping-of-krb5i-replies.patch
knfsd-fix-resource-leak-resulting-in-module-refcount-leak-for-rpcsec_gss_krb5ko.patch
knfsd-rpcgss-rpc_gss_proc_-destroy-request-will-get-a-bad-rpc.patch
knfsd-simplify-a-while-condition-in-svcsockc.patch
knfsd-trivial-makefile-cleanup.patch
knfsd-various-nfsd-xdr-cleanups.patch
knfsd-avoid-oops-if-buggy-userspace-performs-confusing-filehandle-dentry-mapping.patch
readahead-nfsd-case.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
md-cleanup-use-seq_release_private-where-appropriate.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
