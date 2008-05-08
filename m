From: akpm@linux-foundation.org
Subject: - block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch removed from -mm tree
Date: Thu, 08 May 2008 12:11:24 -0700
Message-ID: <200805081911.m48JBOGD001081@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756546AbYEHTMY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 15:12:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, mm-commits@vger.kernel.org


The patch titled
     block/blk-merge.c: inverted likeliness in ll_back_merge_fn()
has been removed from the -mm tree.  Its filename was
     block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block/blk-merge.c: inverted likeliness in ll_back_merge_fn()
From: Roel Kluin <12o3l@tiscali.nl>

In my likely profile it appears this one is inverted.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-merge.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/blk-merge.c~block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn block/blk-merge.c
--- a/block/blk-merge.c~block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn
+++ a/block/blk-merge.c
@@ -314,7 +314,7 @@ int ll_back_merge_fn(struct request_queu
 	}
 	if (unlikely(!bio_flagged(req->biotail, BIO_SEG_VALID)))
 		blk_recount_segments(q, req->biotail);
-	if (unlikely(!bio_flagged(bio, BIO_SEG_VALID)))
+	if (likely(!bio_flagged(bio, BIO_SEG_VALID)))
 		blk_recount_segments(q, bio);
 	len = req->biotail->bi_hw_back_size + bio->bi_hw_front_size;
 	if (BIOVEC_VIRT_MERGEABLE(__BVEC_END(req->biotail), __BVEC_START(bio))
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

atmel_lcdfb-fix-pixclok-divider-calculation.patch
spi_mpc83xx-much-improved-driver.patch
ehca-ret-is-unsigned-ibmebus_request_irq-negative-return-ignored-in-hca_create_eq.patch
block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
xilinx_spi-test-below-0-on-unsigned-irq-in-xilinx_spi_probe.patch
asic3-platform_get_irq-may-return-signed-unnoticed.patch
aty128fb-test-below-0-on-unsigned-pll-post_divider.patch
amifb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
atafb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
vga16fb-test-virtual-screen-range-before-subtraction-on-unsigned.patch
likeliness-accounting-change-and-cleanup.patch
likely_prof-update-to-test_and_set_bit_lock-clear_bit_unlock.patch

