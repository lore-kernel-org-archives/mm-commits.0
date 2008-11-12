From: akpm@linux-foundation.org
Subject: + crypto-md4c-use-array_size.patch added to -mm tree
Date: Wed, 12 Nov 2008 15:12:41 -0800
Message-ID: <200811122312.mACNCfUT014867@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58800 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261AbYKLXNv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 18:13:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: julia@diku.dk, herbert@gondor.apana.org.au


The patch titled
     crypto/md4.c: use ARRAY_SIZE
has been added to the -mm tree.  Its filename is
     crypto-md4c-use-array_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
fs-namespacec-drop-code-after-return.patch
crypto-md4c-use-array_size.patch

