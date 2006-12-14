From: akpm@osdl.org
Subject: - knfsd-svcrpc-fix-gss-krb5i-memory-leak.patch removed from -mm tree
Date: Wed, 13 Dec 2006 22:14:36 -0800
Message-ID: <200612140614.kBE6EZ7Q002154@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52420 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbWLNGPF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Dec 2006 01:15:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de, mm-commits@vger.kernel.org


The patch titled
     knfsd: svcrpc: fix gss krb5i memory leak
has been removed from the -mm tree.  Its filename was
     knfsd-svcrpc-fix-gss-krb5i-memory-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: knfsd: svcrpc: fix gss krb5i memory leak
From: J.Bruce Fields <bfields@fieldses.org>

The memory leak here is embarassingly obvious.

This fixes a problem that causes the kernel to leak a small amount of memory
every time it receives a integrity-protected request.

Thanks to Aim Le Rouzic for the bug report.

Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 net/sunrpc/auth_gss/svcauth_gss.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN net/sunrpc/auth_gss/svcauth_gss.c~knfsd-svcrpc-fix-gss-krb5i-memory-leak net/sunrpc/auth_gss/svcauth_gss.c
--- a/net/sunrpc/auth_gss/svcauth_gss.c~knfsd-svcrpc-fix-gss-krb5i-memory-leak
+++ a/net/sunrpc/auth_gss/svcauth_gss.c
@@ -804,19 +804,19 @@ unwrap_integ_data(struct xdr_buf *buf, u
 
 	integ_len = svc_getnl(&buf->head[0]);
 	if (integ_len & 3)
-		goto out;
+		return stat;
 	if (integ_len > buf->len)
-		goto out;
+		return stat;
 	if (xdr_buf_subsegment(buf, &integ_buf, 0, integ_len))
 		BUG();
 	/* copy out mic... */
 	if (read_u32_from_xdr_buf(buf, integ_len, &mic.len))
 		BUG();
 	if (mic.len > RPC_MAX_AUTH_SIZE)
-		goto out;
+		return stat;
 	mic.data = kmalloc(mic.len, GFP_KERNEL);
 	if (!mic.data)
-		goto out;
+		return stat;
 	if (read_bytes_from_xdr_buf(buf, integ_len + 4, mic.data, mic.len))
 		goto out;
 	maj_stat = gss_verify_mic(ctx, &integ_buf, &mic);
@@ -826,6 +826,7 @@ unwrap_integ_data(struct xdr_buf *buf, u
 		goto out;
 	stat = 0;
 out:
+	kfree(mic.data);
 	return stat;
 }
 
_

Patches currently in -mm which might be from bfields@fieldses.org are


