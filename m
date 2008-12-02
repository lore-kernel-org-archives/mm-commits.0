From: akpm@linux-foundation.org
Subject: - ansi_cprng-zero-out-key-data-on-exit.patch removed from -mm tree
Date: Mon, 01 Dec 2008 19:10:12 -0800
Message-ID: <200812020310.mB23ACdY011808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34761 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751870AbYLBDK0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 22:10:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nhorman@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     ansi_cprng: zero out key data on exit
has been removed from the -mm tree.  Its filename was
     ansi_cprng-zero-out-key-data-on-exit.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ansi_cprng: zero out key data on exit
From: Neil Horman <nhorman@tuxdriver.com>

Its been mentioned to me a few times that the ansi_cprng doesn't zero out
its data when a context is freed.  Given that we store key, and other seed
data in that structure, I think its probably a good idea that we zero it
out.  This patch does that.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/ansi_cprng.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN crypto/ansi_cprng.c~ansi_cprng-zero-out-key-data-on-exit crypto/ansi_cprng.c
--- a/crypto/ansi_cprng.c~ansi_cprng-zero-out-key-data-on-exit
+++ a/crypto/ansi_cprng.c
@@ -266,6 +266,7 @@ done:
 static void free_prng_context(struct prng_context *ctx)
 {
 	crypto_free_cipher(ctx->tfm);
+	memset(ctx, 0, sizeof(struct prng_context));
 }
 
 static int reset_prng_context(struct prng_context *ctx,
_

Patches currently in -mm which might be from nhorman@tuxdriver.com are

linux-next.patch
ansi_cprng-zero-out-key-data-on-exit.patch

