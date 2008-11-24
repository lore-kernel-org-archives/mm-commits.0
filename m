From: akpm@linux-foundation.org
Subject: - slub-add-might_sleep_if.patch removed from -mm tree
Date: Mon, 24 Nov 2008 11:29:47 -0800
Message-ID: <200811241929.mAOJTlcZ027927@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752419AbYKXTaZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 14:30:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, cl@linux-foundation.org, penberg@cs.helsinki.fi, mm-commits@vger.kernel.org


The patch titled
     slub: add might_sleep_if()
has been removed from the -mm tree.  Its filename was
     slub-add-might_sleep_if.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slub: add might_sleep_if()
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Currently SLUB doesn't warn about __GFP_WAIT. Add it into slab_alloc().

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/slub.c~slub-add-might_sleep_if mm/slub.c
--- a/mm/slub.c~slub-add-might_sleep_if
+++ a/mm/slub.c
@@ -1616,6 +1616,7 @@ static __always_inline void *slab_alloc(
 	unsigned long flags;
 	unsigned int objsize;
 
+	might_sleep_if(gfpflags & __GFP_WAIT);
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
 	objsize = c->objsize;
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

linux-next.patch

