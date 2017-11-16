From: akpm@linux-foundation.org
Subject: [patch 016/131] mm/slob.c: remove an unnecessary check for
 __GFP_ZERO
Date: Wed, 15 Nov 2017 17:32:10 -0800
Message-ID: <20171116013210.WegHot8D7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38442 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933442AbdKPBcM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 20:32:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, cl@linux.com, iamjoonsoo.kim@lge.com, miles.chen@mediatek.com, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, torvalds@linux-foundation.org

From: Miles Chen <miles.chen@mediatek.com>
Subject: mm/slob.c: remove an unnecessary check for __GFP_ZERO

Current flow guarantees a valid pointer when handling the __GFP_ZERO case.
So remove the unnecessary NULL pointer check.

Link: http://lkml.kernel.org/r/1507203141-11959-1-git-send-email-miles.chen@mediatek.com
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slob.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slob.c~mm-slob-remove-an-unnecessary-check-for-__gfp_zero mm/slob.c
--- a/mm/slob.c~mm-slob-remove-an-unnecessary-check-for-__gfp_zero
+++ a/mm/slob.c
@@ -330,7 +330,7 @@ static void *slob_alloc(size_t size, gfp
 		BUG_ON(!b);
 		spin_unlock_irqrestore(&slob_lock, flags);
 	}
-	if (unlikely((gfp & __GFP_ZERO) && b))
+	if (unlikely(gfp & __GFP_ZERO))
 		memset(b, 0, size);
 	return b;
 }
_
