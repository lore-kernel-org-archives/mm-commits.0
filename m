From: akpm@linux-foundation.org
Subject: + slubs-ksize-fails-for-size-2048.patch added to -mm tree
Date: Mon, 03 Dec 2007 15:40:22 -0800
Message-ID: <200712032340.lB3NeMMH023445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50915 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751116AbXLCXl1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Dec 2007 18:41:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vegard.nossum@gmail.com, clameter@sgi.com, mpm@selenic.com, penberg@cs.helsinki.fi, penguin-kernel@I-love.SAKURA.ne.jp


The patch titled
     SLUB's ksize() fails for size > 2048
has been added to the -mm tree.  Its filename is
     slubs-ksize-fails-for-size-2048.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB's ksize() fails for size > 2048
From: "Vegard Nossum" <vegard.nossum@gmail.com>

I can't pass memory allocated by kmalloc() to ksize() if it is allocated by
SLUB allocator and size is larger than (I guess) PAGE_SIZE / 2.

The error of ksize() seems to be that it does not check if the allocation
was made by SLUB or the page allocator.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Christoph Lameter <clameter@sgi.com>, Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~slubs-ksize-fails-for-size-2048 mm/slub.c
--- a/mm/slub.c~slubs-ksize-fails-for-size-2048
+++ a/mm/slub.c
@@ -2724,8 +2724,12 @@ size_t ksize(const void *object)
 	if (unlikely(object == ZERO_SIZE_PTR))
 		return 0;
 
-	page = get_object_page(object);
+	page = virt_to_head_page(object);
 	BUG_ON(!page);
+
+	if (unlikely(!PageSlab(page)))
+		return PAGE_SIZE << compound_order(page);
+
 	s = page->slab;
 	BUG_ON(!s);
 
_

Patches currently in -mm which might be from vegard.nossum@gmail.com are

slubs-ksize-fails-for-size-2048.patch
fat-fix-printk-format-strings.patch
