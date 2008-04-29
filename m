From: akpm@linux-foundation.org
Subject: - dma-add-dma_map_attrs-interfaces-fix.patch removed from -mm tree
Date: Mon, 28 Apr 2008 22:47:04 -0700
Message-ID: <200804290547.m3T5l4Iu003704@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159AbYD2Frg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Apr 2008 01:47:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: markn@au1.ibm.com, akepner@sgi.com, mm-commits@vger.kernel.org


The patch titled
     fix up for dma-add-dma_map_attrs-interfaces and update docs
has been removed from the -mm tree.  Its filename was
     dma-add-dma_map_attrs-interfaces-fix.patch

This patch was dropped because it was folded into dma-add-dma_map_attrs-interfaces.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fix up for dma-add-dma_map_attrs-interfaces and update docs
From: Mark Nelson <markn@au1.ibm.com>

But more importantly, dma_{set,get}_attr() have to be static inline

Signed-off-by: Mark Nelson <markn@au1.ibm.com>
Cc: Arthur Kepner <akepner@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/dma-attrs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/dma-attrs.h~dma-add-dma_map_attrs-interfaces-fix include/linux/dma-attrs.h
--- a/include/linux/dma-attrs.h~dma-add-dma_map_attrs-interfaces-fix
+++ a/include/linux/dma-attrs.h
@@ -41,7 +41,7 @@ static inline void init_dma_attrs(struct
  * @attr: attribute to set
  * @attrs: struct dma_attrs (may be NULL)
  */
-void dma_set_attr(enum dma_attr attr, struct dma_attrs *attrs)
+static inline void dma_set_attr(enum dma_attr attr, struct dma_attrs *attrs)
 {
 	if (attrs == NULL)
 		return;
@@ -54,7 +54,7 @@ void dma_set_attr(enum dma_attr attr, st
  * @attr: attribute to set
  * @attrs: struct dma_attrs (may be NULL)
  */
-int dma_get_attr(enum dma_attr attr, struct dma_attrs *attrs)
+static inline int dma_get_attr(enum dma_attr attr, struct dma_attrs *attrs)
 {
 	if (attrs == NULL)
 		return 0;
_

Patches currently in -mm which might be from markn@au1.ibm.com are

dma-add-dma_map_attrs-interfaces.patch
dma-add-dma_map_attrs-interfaces-fix.patch
dma-document-dma_map_attrs-interfaces-fix.patch

