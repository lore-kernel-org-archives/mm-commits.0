From: akpm@linux-foundation.org
Subject: [merged] scsi-ncr53c8xx-div-reaches-1.patch removed from -mm tree
Date: Tue, 16 Jun 2009 11:27:49 -0700
Message-ID: <200906161827.n5GIRnab028218@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755070AbZFPS1u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 14:27:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, James.Bottomley@HansenPartnership.com, matthew@wil.cx, mm-commits@vger.kernel.org


The patch titled
     scsi: ncr53c8xx: div reaches -1
has been removed from the -mm tree.  Its filename was
     scsi-ncr53c8xx-div-reaches-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: scsi: ncr53c8xx: div reaches -1
From: Roel Kluin <roel.kluin@gmail.com>

With while(--div >= 0) { ... } div reaches -1.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ncr53c8xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ncr53c8xx.c~scsi-ncr53c8xx-div-reaches-1 drivers/scsi/ncr53c8xx.c
--- a/drivers/scsi/ncr53c8xx.c~scsi-ncr53c8xx-div-reaches-1
+++ a/drivers/scsi/ncr53c8xx.c
@@ -5444,7 +5444,7 @@ static void ncr_getsync(struct ncb *np, 
 	**	input speed faster than the period.
 	*/
 	kpc = per * clk;
-	while (--div >= 0)
+	while (--div > 0)
 		if (kpc >= (div_10M[div] << 2)) break;
 
 	/*
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
serial-fix-off-by-one-errors.patch
usb-mutually-exclusive-port_status.patch
spi-size-of-a-pointer-to-determine-the-size-of-the-pointed-to-type.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-bad-macro-expansion-parameter-is-member.patch
m68k-count-can-reach-51-not-50.patch
m68k-cnt-reaches-1-not-0.patch
uml-bad-macro-expansion-parameter-is-member.patch
spi_bfin5xx-limit-reaches-1.patch
carminefb-fix-possible-access-beyond-end-of-carmine_modedb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb.patch
radeon-p2g2clk_always_onb-tested-twice-should-2nd-be-p2g2clk_dac_always_onb-fix.patch
platinumfb-misplaced-parenthesis.patch
ufs-sector_t-cannot-be-negative.patch
dtlk-off-by-one-in-readwrite_tts.patch

