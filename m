From: akpm@linux-foundation.org
Subject: - knfsd-rpc-fix-server-side-wrapping-of-krb5i-replies.patch removed from -mm tree
Date: Wed, 09 May 2007 14:53:05 -0700
Message-ID: <200705092153.l49Lr55B003047@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759286AbXEIVym (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:54:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, bfields@citi.umich.edu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     knfsd: rpc: fix server-side wrapping of krb5i replies
has been removed from the -mm tree.  Its filename was
     knfsd-rpc-fix-server-side-wrapping-of-krb5i-replies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN net/sunrpc/auth_gss/svcauth_gss.c~knfsd-rpc-fix-server-side-wrapping-of-krb5i-replies net/sunrpc/auth_gss/svcauth_gss.c
--- a/net/sunrpc/auth_gss/svcauth_gss.c~knfsd-rpc-fix-server-side-wrapping-of-krb5i-replies
+++ a/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1196,13 +1196,7 @@ svcauth_gss_wrap_resp_integ(struct svc_r
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
freezer-add-try_to_freeze-calls-to-all-kernel-threads.patch
nlmclnt_recovery-dont-use-clone_sighand.patch
introduce-freezer-flags-rev-2.patch
git-md-accel.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
