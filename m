From: akpm@linux-foundation.org
Subject: + dma-mapping-introduce-the-dma_attr_no_warn-attribute.patch
 added to -mm tree
Date: Thu, 04 Aug 2016 15:03:38 -0700
Message-ID: <57a3bbba.E51s+AlCCc3sztD/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52056 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966274AbcHDWLu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 4 Aug 2016 18:11:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mauricfo@linux.vnet.ibm.com, axboe@fb.com, benh@kernel.crashing.org, k.kozlowski@samsung.com, keith.busch@intel.com, mpe@ellerman.id.au, mm-commits@vger.kernel.org


The patch titled
     Subject: dma-mapping: introduce the DMA_ATTR_NO_WARN attribute
has been added to the -mm tree.  Its filename is
     dma-mapping-introduce-the-dma_attr_no_warn-attribute.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dma-mapping-introduce-the-dma_attr_no_warn-attribute.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dma-mapping-introduce-the-dma_attr_no_warn-attribute.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: dma-mapping: introduce the DMA_ATTR_NO_WARN attribute

Introduce the DMA_ATTR_NO_WARN attribute, and document it.

Link: http://lkml.kernel.org/r/1470092390-25451-2-git-send-email-mauricfo@linux.vnet.ibm.com
Signed-off-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Cc: Keith Busch <keith.busch@intel.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DMA-attributes.txt |   17 +++++++++++++++++
 include/linux/dma-mapping.h      |    5 +++++
 2 files changed, 22 insertions(+)

diff -puN Documentation/DMA-attributes.txt~dma-mapping-introduce-the-dma_attr_no_warn-attribute Documentation/DMA-attributes.txt
--- a/Documentation/DMA-attributes.txt~dma-mapping-introduce-the-dma_attr_no_warn-attribute
+++ a/Documentation/DMA-attributes.txt
@@ -126,3 +126,20 @@ means that we won't try quite as hard to
 
 NOTE: At the moment DMA_ATTR_ALLOC_SINGLE_PAGES is only implemented on ARM,
 though ARM64 patches will likely be posted soon.
+
+DMA_ATTR_NO_WARN
+----------------
+
+This tells the DMA-mapping subsystem to suppress allocation failure reports
+(similarly to __GFP_NOWARN).
+
+On some architectures allocation failures are reported with error messages
+to the system logs.  Although this can help to identify and debug problems,
+drivers which handle failures (eg, retry later) have no problems with them,
+and can actually flood the system logs with error messages that aren't any
+problem at all, depending on the implementation of the retry mechanism.
+
+So, this provides a way for drivers to avoid those error messages on calls
+where allocation failures are not a problem, and shouldn't bother the logs.
+
+NOTE: At the moment DMA_ATTR_NO_WARN is only implemented on PowerPC.
diff -puN include/linux/dma-mapping.h~dma-mapping-introduce-the-dma_attr_no_warn-attribute include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~dma-mapping-introduce-the-dma_attr_no_warn-attribute
+++ a/include/linux/dma-mapping.h
@@ -56,6 +56,11 @@
  * that gives better TLB efficiency.
  */
 #define DMA_ATTR_ALLOC_SINGLE_PAGES	(1UL << 7)
+/*
+ * DMA_ATTR_NO_WARN: This tells the DMA-mapping subsystem to suppress
+ * allocation failure reports (similarly to __GFP_NOWARN).
+ */
+#define DMA_ATTR_NO_WARN	(1UL << 8)
 
 /*
  * A dma_addr_t can hold any valid DMA or bus address for the platform.
_

Patches currently in -mm which might be from mauricfo@linux.vnet.ibm.com are

dma-mapping-introduce-the-dma_attr_no_warn-attribute.patch
powerpc-implement-the-dma_attr_no_warn-attribute.patch
nvme-use-the-dma_attr_no_warn-attribute.patch

