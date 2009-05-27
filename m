From: akpm@linux-foundation.org
Subject: [merged] sh-fix-access-beyond-array_size-of-onchip_ops.patch removed from -mm tree
Date: Wed, 27 May 2009 13:55:50 -0700
Message-ID: <200905272055.n4RKtoaQ026054@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751171AbZE0VDD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 17:03:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     sh: fix access beyond ARRAY_SIZE of onchip_ops[]
has been removed from the -mm tree.  Its filename was
     sh-fix-access-beyond-array_size-of-onchip_ops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sh: fix access beyond ARRAY_SIZE of onchip_ops[]
From: Roel Kluin <roel.kluin@gmail.com>

Do not go beyond ARRAY_SIZE of onchip_ops

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/kernel/cpu/sh4a/clock-sh7722.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/sh/kernel/cpu/sh4a/clock-sh7722.c~sh-fix-access-beyond-array_size-of-onchip_ops arch/sh/kernel/cpu/sh4a/clock-sh7722.c
--- a/arch/sh/kernel/cpu/sh4a/clock-sh7722.c~sh-fix-access-beyond-array_size-of-onchip_ops
+++ a/arch/sh/kernel/cpu/sh4a/clock-sh7722.c
@@ -897,7 +897,7 @@ struct clk_ops *onchip_ops[] = {
 void __init
 arch_init_clk_ops(struct clk_ops **ops, int type)
 {
-	BUG_ON(type < 0 || type > ARRAY_SIZE(onchip_ops));
+	BUG_ON(type < 0 || type >= ARRAY_SIZE(onchip_ops));
 	*ops = onchip_ops[type];
 }
 
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
fsldma-fix-check-on-potential-fdev-chan-overflow.patch
drm-fix-lock_test_with_return-macro.patch
uwb-event_size-should-be-signed.patch
irda-count-reaches-1.patch
drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
wis-sony-tunerc-typo.patch
otus-80211core-coidc-fix-array-range-check.patch
lguest-fix-array-indexing-check.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
serial-z85c30-bcm1480-loops-reach-1.patch
drivers-serial-mpc52xx_uartc-fix-array-overindexing-check.patch
spi_bfin5xx-limit-reaches-1.patch
carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch

