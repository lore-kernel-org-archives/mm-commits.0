From: akpm@linux-foundation.org
Subject: + mm-cma-fix-cma-aligned-offset-calculation.patch added to -mm
 tree
Date: Fri, 27 Feb 2015 13:25:24 -0800
Message-ID: <54f0e0c4.B+zl0ol9FhWnkbTk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47793 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbbB0VZZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 Feb 2015 16:25:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dpetigara@broadcom.com, gregory.0xf0@gmail.com, mina86@mina86.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: cma: fix CMA aligned offset calculation
has been added to the -mm tree.  Its filename is
     mm-cma-fix-cma-aligned-offset-calculation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-fix-cma-aligned-offset-calculation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-fix-cma-aligned-offset-calculation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Danesh Petigara <dpetigara@broadcom.com>
Subject: mm: cma: fix CMA aligned offset calculation

The CMA aligned offset calculation is incorrect for non-zero order_per_bit
values.

For example, if cma->order_per_bit=1, cma->base_pfn= 0x2f800000 and
align_order=12, the function returns a value of 0x17c00 instead of 0x400.

This patch fixes the CMA aligned offset calculation.

Signed-off-by: Danesh Petigara <dpetigara@broadcom.com>
Reviewed-by: Gregory Fong <gregory.0xf0@gmail.com>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff -puN mm/cma.c~mm-cma-fix-cma-aligned-offset-calculation mm/cma.c
--- a/mm/cma.c~mm-cma-fix-cma-aligned-offset-calculation
+++ a/mm/cma.c
@@ -64,15 +64,17 @@ static unsigned long cma_bitmap_aligned_
 	return (1UL << (align_order - cma->order_per_bit)) - 1;
 }
 
+/*
+ * Find a PFN aligned to the specified order and return an offset represented in
+ * order_per_bits.
+ */
 static unsigned long cma_bitmap_aligned_offset(struct cma *cma, int align_order)
 {
-	unsigned int alignment;
