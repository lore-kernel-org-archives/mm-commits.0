From: akpm@linux-foundation.org
Subject: +
 mm-zswap-move-to-use-crypto_acomp-api-for-hardware-acceleration-fix.patch
 added to -mm tree
Date: Wed, 24 Jun 2020 15:44:06 -0700
Message-ID: <20200624224406.Iy1W5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388739AbgFXWoH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 18:44:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, song.bao.hua@hisilicon.com, colin.king@canonical.com


The patch titled
     Subject: mm/zswap: remove redundant assignment to variable dlen
has been added to the -mm tree.  Its filename is
     mm-zswap-move-to-use-crypto_acomp-api-for-hardware-acceleration-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-zswap-move-to-use-crypto_acomp-api-for-hardware-acceleration-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-zswap-move-to-use-crypto_acomp-api-for-hardware-acceleration-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-zswap-move-to-use-crypto_acomp-api-for-hardware-acceleration-fix.patch
