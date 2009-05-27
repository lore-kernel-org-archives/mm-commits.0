From: akpm@linux-foundation.org
Subject: [merged] zoran-fix-error.patch removed from -mm tree
Date: Wed, 27 May 2009 13:55:42 -0700
Message-ID: <200905272055.n4RKtglM025930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760711AbZE0U4f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 16:56:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, hverkuil@xs4all.nl, mchehab@redhat.com, mm-commits@vger.kernel.org


The patch titled
     zoran: fix &&/|| error
has been removed from the -mm tree.  Its filename was
     zoran-fix-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: zoran: fix &&/|| error
From: Roel Kluin <roel.kluin@gmail.com>

Fix &&/|| typo. `default_norm' can be 0 (PAL), 1 (NTSC) or 2 (SECAM),
the condition tested was impossible.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/zoran/zoran_card.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/zoran/zoran_card.c~zoran-fix-error drivers/media/video/zoran/zoran_card.c
--- a/drivers/media/video/zoran/zoran_card.c~zoran-fix-error
+++ a/drivers/media/video/zoran/zoran_card.c
@@ -1022,7 +1022,7 @@ zr36057_init (struct zoran *zr)
 	zr->vbuf_bytesperline = 0;
 
 	/* Avoid nonsense settings from user for default input/norm */
-	if (default_norm < 0 && default_norm > 2)
+	if (default_norm < 0 || default_norm > 2)
 		default_norm = 0;
 	if (default_norm == 0) {
 		zr->norm = V4L2_STD_PAL;
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

