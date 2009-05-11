From: akpm@linux-foundation.org
Subject: + dma-mapping-mark-dma_nbits_mask-as-deprecated-fix.patch added to -mm tree
Date: Mon, 11 May 2009 13:43:49 -0700
Message-ID: <200905112043.n4BKhnFH006233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57090 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754845AbZEKUqw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 16:46:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu, yanghy@cn.fujitsu.com


The patch titled
     dma-mapping: mark DMA_nBITS_MASK as deprecated fix
has been added to the -mm tree.  Its filename is
     dma-mapping-mark-dma_nbits_mask-as-deprecated-fix.patch

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
Subject: dma-mapping: mark DMA_nBITS_MASK as deprecated fix
From: Jiri Slaby <jirislaby@gmail.com>

As Fujita correctly demurs, use more meaningful typedef name, so that we
now see:

warning: DMA_nnBIT_MASK is deprecated

instead of

warning: DMA_DEPRECATED is deprecated

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Yang Hongyang <yanghy@cn.fujitsu.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-mapping.h |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN include/linux/dma-mapping.h~dma-mapping-mark-dma_nbits_mask-as-deprecated-fix include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mapping-mark-dma_nbits_mask-as-deprecated-fix
+++ a/include/linux/dma-mapping.h
@@ -63,7 +63,7 @@ struct dma_map_ops {
 
 #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
 
-typedef u64 DMA_DEPRECATED __deprecated;
+typedef u64 DMA_nnBIT_MASK __deprecated;
 
 /*
  * NOTE: do not use the below macros in new code and do not add new definitions
@@ -71,18 +71,18 @@ typedef u64 DMA_DEPRECATED __deprecated;
  *
  * Instead, just open-code DMA_BIT_MASK(n) within your driver
  */
-#define DMA_64BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(64)
-#define DMA_48BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(48)
-#define DMA_47BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(47)
-#define DMA_40BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(40)
-#define DMA_39BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(39)
-#define DMA_35BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(35)
-#define DMA_32BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(32)
-#define DMA_31BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(31)
-#define DMA_30BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(30)
-#define DMA_29BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(29)
-#define DMA_28BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(28)
-#define DMA_24BIT_MASK	(DMA_DEPRECATED)DMA_BIT_MASK(24)
+#define DMA_64BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(64)
+#define DMA_48BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(48)
+#define DMA_47BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(47)
+#define DMA_40BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(40)
+#define DMA_39BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(39)
+#define DMA_35BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(35)
+#define DMA_32BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(32)
+#define DMA_31BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(31)
+#define DMA_30BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(30)
+#define DMA_29BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(29)
+#define DMA_28BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(28)
+#define DMA_24BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(24)
 
 #define DMA_MASK_NONE	0x0ULL
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
linux-next.patch
icom-converting-space-to-tabs.patch
char-isicom-fix-build-warning.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated-fix.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

