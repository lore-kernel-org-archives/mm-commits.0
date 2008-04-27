From: akpm@linux-foundation.org
Subject: + dma-add-dma_map_attrs-interfaces-fix.patch added to -mm tree
Date: Sun, 27 Apr 2008 12:22:45 -0700
Message-ID: <200804271922.m3RJMjVa020964@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753120AbYD0TWw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 15:22:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: markn@au1.ibm.com, akepner@sgi.com


The patch titled
     fix up for dma-add-dma_map_attrs-interfaces and update docs
has been added to the -mm tree.  Its filename is
     dma-add-dma_map_attrs-interfaces-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

dma-add-dma_map_attrs-interfaces-fix.patch
dma-document-dma_map_attrs-interfaces-fix.patch

