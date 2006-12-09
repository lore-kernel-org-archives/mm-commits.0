From: akpm@osdl.org
Subject: + knfsd-svcrpc-fix-gss-krb5i-memory-leak.patch added to -mm tree
Date: Fri, 08 Dec 2006 16:09:22 -0800
Message-ID: <200612090009.kB909M1o010373@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:55532 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947549AbWLIAJf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 19:09:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bfields@fieldses.org, bfields@citi.umich.edu, neilb@suse.de


The patch titled
     knfsd: svcrpc: fix gss krb5i memory leak
has been added to the -mm tree.  Its filename is
     knfsd-svcrpc-fix-gss-krb5i-memory-leak.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 1 files changed, 5 insertions(+), 4 deletions(-)

diff -puN net/sunrpc/auth_gss/svcauth_gss.c~knfsd-svcrpc-fix-gss-krb5i-memory-leak net/sunrpc/auth_gss/svcauth_gss.c
--- a/net/sunrpc/auth_gss/svcauth_gss.c~knfsd-svcrpc-fix-gss-krb5i-memory-leak
+++ a/net/sunrpc/auth_gss/svcauth_gss.c
@@ -818,19 +818,19 @@ unwrap_integ_data(struct xdr_buf *buf, u
 
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
@@ -840,6 +840,7 @@ unwrap_integ_data(struct xdr_buf *buf, u
 		goto out;
 	stat = 0;
 out:
+	kfree(mic.data);
 	return stat;
 }
 
_

Patches currently in -mm which might be from bfields@fieldses.org are

origin.patch
knfsd-nfsd4-remove-a-dprink-from-nfsd4_lock.patch
knfsd-svcrpc-fix-gss-krb5i-memory-leak.patch
knfsd-nfsd4-clarify-units-of-compound_slack_space.patch
knfsd-nfsd-make-exp_rootfh-handle-exp_parent-errors.patch
knfsd-nfsd-simplify-exp_pseudoroot.patch
knfsd-nfsd4-handling-more-nfsd_cross_mnt-errors-in-nfsd4-readdir.patch
knfsd-nfsd-dont-drop-silently-on-upcall-deferral.patch
knfsd-svcrpc-remove-another-silent-drop-from-deferral-code.patch
knfsd-nfsd4-pass-saved-and-current-fh-together-into-nfsd4-operations.patch
knfsd-nfsd4-remove-spurious-replay_owner-check.patch
knfsd-nfsd4-move-replay_owner-to-cstate.patch
knfsd-nfsd4-dont-inline-nfsd4-compound-op-functions.patch
knfsd-nfsd4-make-verify-and-nverify-wrappers.patch
knfsd-nfsd4-reorganize-compound-ops.patch
knfsd-nfsd4-simplify-migration-op-check.patch
knfsd-nfsd4-simplify-filehandle-check.patch

