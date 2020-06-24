From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-zswap-move-to-use-crypto_acomp-api-for-hardware-acceleration-fix.patch
 removed from -mm tree
Date: Wed, 24 Jun 2020 15:45:27 -0700
Message-ID: <20200624224527.l-_DZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732832AbgFXWp3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 18:45:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, song.bao.hua@hisilicon.com, colin.king@canonical.com


The patch titled
     Subject: mm/zswap: remove redundant assignment to variable dlen
has been removed from the -mm tree.  Its filename was
     mm-zswap-move-to-use-crypto_acomp-api-for-hardware-acceleration-fix.patch

This patch was dropped because it was folded into mm-zswap-move-to-use-crypto_acomp-api-for-hardware-acceleration.patch

------------------------------------------------------
From: Colin Ian King <colin.king@canonical.com>
Subject: mm/zswap: remove redundant assignment to variable dlen

The variable dlen is being assigned a value that is never read, the
assignment is redundant and can be removed.

Link: http://lkml.kernel.org/r/20200622154432.50133-1-colin.king@canonical.com
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: Barry Song <song.bao.hua@hisilicon.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-move-to-use-crypto_acomp-api-for-hardware-acceleration-fix
+++ a/mm/zswap.c
@@ -1243,7 +1243,6 @@ static int zswap_frontswap_load(unsigned
 	sg_init_one(&output, dst, dlen);
 	acomp_request_set_params(acomp_ctx->req, &input, &output, entry->length, dlen);
 	ret = crypto_wait_req(crypto_acomp_decompress(acomp_ctx->req), &acomp_ctx->wait);
-	dlen = acomp_ctx->req->dlen;
 	mutex_unlock(&acomp_ctx->mutex);
 
 	kunmap(page);
_

Patches currently in -mm which might be from colin.king@canonical.com are

mm-zswap-move-to-use-crypto_acomp-api-for-hardware-acceleration.patch
