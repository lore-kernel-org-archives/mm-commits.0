From: akpm@linux-foundation.org
Subject: + cma-fix-calculation-of-aligned-offset.patch added to -mm tree
Date: Thu, 29 Jun 2017 13:48:54 -0700
Message-ID: <595567b6.u5YZ4R6JqXDleUcY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55580 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751532AbdF2Usz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jun 2017 16:48:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: opendmb@gmail.com, angus@angusclark.org, catalin.marinas@arm.com, gregkh@linuxfoundation.org, gregory.0xf0@gmail.com, jaewon31.kim@samsung.com, l.stach@pengutronix.de, labbott@redhat.com, shashim@codeaurora.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: cma: fix calculation of aligned offset
has been added to the -mm tree.  Its filename is
     cma-fix-calculation-of-aligned-offset.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cma-fix-calculation-of-aligned-offset.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cma-fix-calculation-of-aligned-offset.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Doug Berger <opendmb@gmail.com>
Subject: cma: fix calculation of aligned offset

The align_offset parameter is used by bitmap_find_next_zero_area_off()
to represent the offset of map's base from the previous alignment
boundary; the function ensures that the returned index, plus the
align_offset, honors the specified align_mask.

The logic introduced by commit b5be83e308f7 ("mm: cma: align to
physical address, not CMA region position") has the cma driver
calculate the offset to the *next* alignment boundary.  In most cases,
the base alignment is greater than that specified when making
allocations, resulting in a zero offset whether we align up or down.
In the example given with the commit, the base alignment (8MB) was
half the requested alignment (16MB) so the math also happened to work
since the offset is 8MB in both directions.  However, when requesting
allocations with an alignment greater than twice that of the base,
the returned index would not be correctly aligned.

Also, the align_order arguments of cma_bitmap_aligned_mask() and
cma_bitmap_aligned_offset() should not be negative so the argument
type was made unsigned.

Fixes: b5be83e308f7 ("mm: cma: align to physical address, not CMA region position")
Link: http://lkml.kernel.org/r/20170628170742.2895-1-opendmb@gmail.com
Signed-off-by: Angus Clark <angus@angusclark.org>
Signed-off-by: Doug Berger <opendmb@gmail.com>
Cc: Gregory Fong <gregory.0xf0@gmail.com>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Angus Clark <angus@angusclark.org>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Shiraz Hashim <shashim@codeaurora.org>
Cc: Jaewon Kim <jaewon31.kim@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN mm/cma.c~cma-fix-calculation-of-aligned-offset mm/cma.c
--- a/mm/cma.c~cma-fix-calculation-of-aligned-offset
+++ a/mm/cma.c
@@ -59,7 +59,7 @@ const char *cma_get_name(const struct cm
 }
 
 static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
-					     int align_order)
+					     unsigned int align_order)
 {
 	if (align_order <= cma->order_per_bit)
 		return 0;
@@ -67,17 +67,14 @@ static unsigned long cma_bitmap_aligned_
 }
 
 /*
- * Find a PFN aligned to the specified order and return an offset represented in
- * order_per_bits.
+ * Find the offset of the base PFN from the specified align_order.
+ * The value returned is represented in order_per_bits.
  */
 static unsigned long cma_bitmap_aligned_offset(const struct cma *cma,
-					       int align_order)
+					       unsigned int align_order)
 {
-	if (align_order <= cma->order_per_bit)
-		return 0;
