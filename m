From: akpm@linux-foundation.org
Subject: [merged] drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing.patch removed from -mm tree
Date: Mon, 15 Jun 2009 12:01:42 -0700
Message-ID: <200906151901.n5FJ1guH023033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48547 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757130AbZFOTBn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Jun 2009 15:01:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, isdn@linux-pingi.de, mm-commits@vger.kernel.org


The patch titled
     drivers/isdn/i4l/isdn_tty.c: fix check for array overindexing
has been removed from the -mm tree.  Its filename was
     drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/isdn/i4l/isdn_tty.c: fix check for array overindexing
From: Roel Kluin <roel.kluin@gmail.com>

The check for overindexing of dev->mdm.info[] has an off-by-one.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Karsten Keil <isdn@linux-pingi.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/i4l/isdn_tty.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/i4l/isdn_tty.c~drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing drivers/isdn/i4l/isdn_tty.c
--- a/drivers/isdn/i4l/isdn_tty.c~drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing
+++ a/drivers/isdn/i4l/isdn_tty.c
@@ -1592,7 +1592,7 @@ isdn_tty_open(struct tty_struct *tty, st
 	int retval, line;
 
 	line = tty->index;
-	if (line < 0 || line > ISDN_MAX_CHANNELS)
+	if (line < 0 || line >= ISDN_MAX_CHANNELS)
 		return -ENODEV;
 	info = &dev->mdm.info[line];
 	if (isdn_tty_paranoia_check(info, tty->name, "isdn_tty_open"))
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
serial-fix-off-by-one-errors.patch
scsi-ncr53c8xx-div-reaches-1.patch
scsi-pcmcia-nsp_cs-time_out-reaches-1.patch
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

