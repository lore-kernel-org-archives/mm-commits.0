From: akpm@linux-foundation.org
Subject: - crypto-md4c-use-array_size.patch removed from -mm tree
Date: Fri, 14 Nov 2008 11:23:08 -0800
Message-ID: <200811141923.mAEJN8A3031070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60730 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755156AbYKNTXq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 14:23:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, herbert@gondor.apana.org.au, mm-commits@vger.kernel.org


The patch titled
     crypto/md4.c: use ARRAY_SIZE
has been removed from the -mm tree.  Its filename was
     crypto-md4c-use-array_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: crypto/md4.c: use ARRAY_SIZE
From: Julia Lawall <julia@diku.dk>

ARRAY_SIZE is more concise to use when the size of an array is divided by
the size of its type or the size of its first element.

The semantic patch that makes this change is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@i@
@@

#include <linux/kernel.h>

@depends on i using "paren.iso"@
type T;
T[] E;
@@

- (sizeof(E)/sizeof(T))
+ ARRAY_SIZE(E)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 crypto/md4.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN crypto/md4.c~crypto-md4c-use-array_size crypto/md4.c
--- a/crypto/md4.c~crypto-md4c-use-array_size
+++ a/crypto/md4.c
@@ -148,7 +148,7 @@ static void md4_transform(u32 *hash, u32
 
 static inline void md4_transform_helper(struct md4_ctx *ctx)
 {
-	le32_to_cpu_array(ctx->block, sizeof(ctx->block) / sizeof(u32));
+	le32_to_cpu_array(ctx->block, ARRAY_SIZE(ctx->block));
 	md4_transform(ctx->hash, ctx->block);
 }
 
@@ -214,7 +214,7 @@ static void md4_final(struct crypto_tfm 
 	le32_to_cpu_array(mctx->block, (sizeof(mctx->block) -
 	                  sizeof(u64)) / sizeof(u32));
 	md4_transform(mctx->hash, mctx->block);
-	cpu_to_le32_array(mctx->hash, sizeof(mctx->hash) / sizeof(u32));
+	cpu_to_le32_array(mctx->hash, ARRAY_SIZE(mctx->hash));
 	memcpy(out, mctx->hash, sizeof(mctx->hash));
 	memset(mctx, 0, sizeof(*mctx));
 }
_

Patches currently in -mm which might be from julia@diku.dk are

drivers-video-bad-error-test-before-a-dereference.patch
linux-next.patch
drivers-media-use-array_size.patch
drivers-mtd-maps-nettelc-use-array_size.patch
net-tipc-bcasth-use-array_size.patch
drivers-isdn-misdn-use-array_size.patch
drivers-message-fusion-use-array_size.patch
fs-namespacec-drop-code-after-return.patch
drivers-net-wireless-ath9k-rcc-use-array_size.patch

