From: akpm@linux-foundation.org
Subject: + cma-increase-cma_alignment-upper-limit-to-12.patch added to -mm tree
Date: Mon, 12 May 2014 16:27:47 -0700
Message-ID: <537158f3.zQR1QGV2PUCbs1/m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40174 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaELX1s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 May 2014 19:27:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, m.szyprowski@samsung.com, marc.ceeeee@gmail.com

Subject: + cma-increase-cma_alignment-upper-limit-to-12.patch added to -mm tree
To: marc.ceeeee@gmail.com,m.szyprowski@samsung.com
From: akpm@linux-foundation.org
Date: Mon, 12 May 2014 16:27:47 -0700


The patch titled
     Subject: cma: increase CMA_ALIGNMENT upper limit to 12
has been added to the -mm tree.  Its filename is
     cma-increase-cma_alignment-upper-limit-to-12.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cma-increase-cma_alignment-upper-limit-to-12.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cma-increase-cma_alignment-upper-limit-to-12.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marc Carino <marc.ceeeee@gmail.com>
Subject: cma: increase CMA_ALIGNMENT upper limit to 12

Some systems require a larger maximum PAGE_SIZE order for CMA allocations.
 To accommodate such systems, increase the upper-bound of the
CMA_ALIGNMENT range to 12 (which ends up being 16MB on systems with 4K
pages).

Signed-off-by: Marc Carino <marc.ceeeee@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/base/Kconfig~cma-increase-cma_alignment-upper-limit-to-12 drivers/base/Kconfig
--- a/drivers/base/Kconfig~cma-increase-cma_alignment-upper-limit-to-12
+++ a/drivers/base/Kconfig
@@ -253,7 +253,7 @@ endchoice
 
 config CMA_ALIGNMENT
 	int "Maximum PAGE_SIZE order of alignment for contiguous buffers"
-	range 4 9
+	range 4 12
 	default 8
 	help
 	  DMA mapping framework by default aligns all buffers to the smallest
_

Patches currently in -mm which might be from marc.ceeeee@gmail.com are

cma-increase-cma_alignment-upper-limit-to-12.patch

