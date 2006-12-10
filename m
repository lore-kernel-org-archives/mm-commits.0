From: akpm@osdl.org
Subject: - sha384-hmac-is-broken.patch removed from -mm tree
Date: Sat, 09 Dec 2006 17:52:50 -0800
Message-ID: <200612100152.kBA1qoWM010606@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40613 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759383AbWLJByL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 9 Dec 2006 20:54:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: linuxbugzilla@kriptik.org, herbert@gondor.apana.org.au, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     SHA384 HMAC is broken
has been removed from the -mm tree.  Its filename was
     sha384-hmac-is-broken.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SHA384 HMAC is broken
From: Andrew Donofrio <linuxbugzilla@kriptik.org>

http://bugzilla.kernel.org/show_bug.cgi?id=7646

SHA384 and SHA512 share everything but the initial values and truncation of
the output, so their block sizes are the same.  In the file
crypto/sha512.c, the SHA384_HMAC_BLOCK_SIZE is incorrectly #defined as 96,
when it should just be SHA512_HMAC_BLOCK_SIZE (i.e., 128).  As it is now,
the kernel's SHA384 HMAC routine does not actually return "real" SHA384
HMACs.

Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 crypto/sha512.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN crypto/sha512.c~sha384-hmac-is-broken crypto/sha512.c
--- a/crypto/sha512.c~sha384-hmac-is-broken
+++ a/crypto/sha512.c
@@ -24,7 +24,7 @@
 
 #define SHA384_DIGEST_SIZE 48
 #define SHA512_DIGEST_SIZE 64
-#define SHA384_HMAC_BLOCK_SIZE  96
+#define SHA384_HMAC_BLOCK_SIZE SHA512_HMAC_BLOCK_SIZE 
 #define SHA512_HMAC_BLOCK_SIZE 128
 
 struct sha512_ctx {
_

Patches currently in -mm which might be from linuxbugzilla@kriptik.org are


