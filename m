From: akpm@linux-foundation.org
Subject: + iommu-inline-iommu_num_pages.patch added to -mm tree
Date: Tue, 03 Aug 2010 16:54:30 -0700
Message-ID: <201008032354.o73NsUcw018528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42190 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756841Ab0HCXzF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Aug 2010 19:55:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anton@samba.org, akinobu.mita@gmail.com


The patch titled
     iommu: inline iommu_num_pages
has been added to the -mm tree.  Its filename is
     iommu-inline-iommu_num_pages.patch

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
Subject: iommu: inline iommu_num_pages
From: Anton Blanchard <anton@samba.org>

A profile of a network benchmark showed iommu_num_pages rather high up:

     0.52%  iommu_num_pages

Looking at the profile, an integer divide is taking almost all of the time:

      %
         :      c000000000376ea4 <.iommu_num_pages>:
    1.93 :      c000000000376ea4:       fb e1 ff f8     std     r31,-8(r1)
    0.00 :      c000000000376ea8:       f8 21 ff c1     stdu    r1,-64(r1)
    0.00 :      c000000000376eac:       7c 3f 0b 78     mr      r31,r1
    3.86 :      c000000000376eb0:       38 84 ff ff     addi    r4,r4,-1
    0.00 :      c000000000376eb4:       38 05 ff ff     addi    r0,r5,-1
    0.00 :      c000000000376eb8:       7c 84 2a 14     add     r4,r4,r5
   46.95 :      c000000000376ebc:       7c 00 18 38     and     r0,r0,r3
   45.66 :      c000000000376ec0:       7c 84 02 14     add     r4,r4,r0
    0.00 :      c000000000376ec4:       7c 64 2b 92     divdu   r3,r4,r5
    0.00 :      c000000000376ec8:       38 3f 00 40     addi    r1,r31,64
    0.00 :      c000000000376ecc:       eb e1 ff f8     ld      r31,-8(r1)
    1.61 :      c000000000376ed0:       4e 80 00 20     blr

Since every caller of iommu_num_pages passes in a constant power of two
we can inline this such that the divide is replaced by a shift. The
entire function is only a few instructions once optimised, so it is
a good candidate for inlining overall.

Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/iommu-helper.h |   12 ++++++++++--
 lib/iommu-helper.c           |    9 ---------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff -puN include/linux/iommu-helper.h~iommu-inline-iommu_num_pages include/linux/iommu-helper.h
--- a/include/linux/iommu-helper.h~iommu-inline-iommu_num_pages
+++ a/include/linux/iommu-helper.h
@@ -1,6 +1,8 @@
 #ifndef _LINUX_IOMMU_HELPER_H
 #define _LINUX_IOMMU_HELPER_H
 
+#include <linux/kernel.h>
+
 static inline unsigned long iommu_device_max_index(unsigned long size,
 						   unsigned long offset,
 						   u64 dma_mask)
@@ -20,7 +22,13 @@ extern unsigned long iommu_area_alloc(un
 				      unsigned long boundary_size,
 				      unsigned long align_mask);
 
-extern unsigned long iommu_num_pages(unsigned long addr, unsigned long len,
-				     unsigned long io_page_size);
+static inline unsigned long iommu_num_pages(unsigned long addr,
+					    unsigned long len,
+					    unsigned long io_page_size)
+{
+	unsigned long size = (addr & (io_page_size - 1)) + len;
+
+	return DIV_ROUND_UP(size, io_page_size);
+}
 
 #endif
diff -puN lib/iommu-helper.c~iommu-inline-iommu_num_pages lib/iommu-helper.c
--- a/lib/iommu-helper.c~iommu-inline-iommu_num_pages
+++ a/lib/iommu-helper.c
@@ -38,12 +38,3 @@ again:
 	return -1;
 }
 EXPORT_SYMBOL(iommu_area_alloc);
-
-unsigned long iommu_num_pages(unsigned long addr, unsigned long len,
-			      unsigned long io_page_size)
-{
-	unsigned long size = (addr & (io_page_size - 1)) + len;
