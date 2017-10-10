From: akpm@linux-foundation.org
Subject: + mm-slob-remove-an-unnecessary-check-for-__gfp_zero.patch added
 to -mm tree
Date: Tue, 10 Oct 2017 15:56:07 -0700
Message-ID: <59dd5007.HsSRzjUoMjiat8dW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39188 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755376AbdJJW4I (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Oct 2017 18:56:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miles.chen@mediatek.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slob.c: remove an unnecessary check for __GFP_ZERO
has been added to the -mm tree.  Its filename is
     mm-slob-remove-an-unnecessary-check-for-__gfp_zero.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slob-remove-an-unnecessary-check-for-__gfp_zero.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slob-remove-an-unnecessary-check-for-__gfp_zero.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -329,7 +329,7 @@ static void *slob_alloc(size_t size, gfp
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
mm-slob-remove-an-unnecessary-check-for-__gfp_zero.patch
checkpatch-support-function-pointers-for-unnamed-function-definition-arguments.patch

