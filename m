From: akpm@linux-foundation.org
Subject: [merged] include-linux-dma-mappingh-remove-dma_xxbit_mask-macros.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:29:11 -0700
Message-ID: <201107271927.p6RJRvsY003257@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754553Ab1G0T2X (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:28:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, fujita.tomonori@lab.ntt.co.jp, jslaby@suse.cz, vinod.koul@intel.com, mm-commits@vger.kernel.org


The patch titled
     include/linux/dma-mapping.h: remove DMA_xxBIT_MASK macros
has been removed from the -mm tree.  Its filename was
     include-linux-dma-mappingh-remove-dma_xxbit_mask-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux/dma-mapping.h: remove DMA_xxBIT_MASK macros
From: WANG Cong <xiyou.wangcong@gmail.com>

git grep shows there are no users in tree, so we can remove them safely.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Acked-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |    7 ------
 include/linux/dma-mapping.h                |   21 -------------------
 2 files changed, 28 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~include-linux-dma-mappingh-remove-dma_xxbit_mask-macros Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~include-linux-dma-mappingh-remove-dma_xxbit_mask-macros
+++ a/Documentation/feature-removal-schedule.txt
@@ -460,13 +460,6 @@ Who:	FUJITA Tomonori <fujita.tomonori@la
 
 ----------------------------
 
-What: 	DMA_xxBIT_MASK macros
-When:	Jun 2011
-Why:	DMA_xxBIT_MASK macros were replaced with DMA_BIT_MASK() macros.
-Who:	FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
-
-----------------------------
-
 What:	iwlwifi disable_hw_scan module parameters
 When:	3.0
 Why:	Hareware scan is the prefer method for iwlwifi devices for
diff -puN include/linux/dma-mapping.h~include-linux-dma-mappingh-remove-dma_xxbit_mask-macros include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~include-linux-dma-mappingh-remove-dma_xxbit_mask-macros
+++ a/include/linux/dma-mapping.h
@@ -46,27 +46,6 @@ struct dma_map_ops {
 
 #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
 
-typedef u64 DMA_nnBIT_MASK __deprecated;
-
-/*
- * NOTE: do not use the below macros in new code and do not add new definitions
- * here.
- *
- * Instead, just open-code DMA_BIT_MASK(n) within your driver
- */
-#define DMA_64BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(64)
-#define DMA_48BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(48)
-#define DMA_47BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(47)
-#define DMA_40BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(40)
-#define DMA_39BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(39)
-#define DMA_35BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(35)
-#define DMA_32BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(32)
-#define DMA_31BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(31)
-#define DMA_30BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(30)
-#define DMA_29BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(29)
-#define DMA_28BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(28)
-#define DMA_24BIT_MASK	(DMA_nnBIT_MASK)DMA_BIT_MASK(24)
