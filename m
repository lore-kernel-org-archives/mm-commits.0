From: akpm@linux-foundation.org
Subject: [merged]
 mm-slob-remove-an-unnecessary-check-for-__gfp_zero.patch removed from -mm
 tree
Date: Thu, 16 Nov 2017 11:59:23 -0800
Message-ID: <20171116195923.fr0Loyyx5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45854 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758772AbdKPT7Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 14:59:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, iamjoonsoo.kim@lge.com, miles.chen@mediatek.com, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com


The patch titled
     Subject: mm/slob.c: remove an unnecessary check for __GFP_ZERO
has been removed from the -mm tree.  Its filename was
     mm-slob-remove-an-unnecessary-check-for-__gfp_zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from miles.chen@mediatek.com are

dma-debug-fix-incorrect-pfn-calculation.patch
checkpatch-support-function-pointers-for-unnamed-function-definition-arguments.patch

