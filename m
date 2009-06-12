From: akpm@linux-foundation.org
Subject: [merged] tvp514x-try_count-off-by-one.patch removed from -mm tree
Date: Fri, 12 Jun 2009 11:22:09 -0700
Message-ID: <200906121822.n5CIM9FQ030952@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54915 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758684AbZFLS0B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Jun 2009 14:26:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, mchehab@infradead.org, mm-commits@vger.kernel.org


The patch titled
     tvp514x: try_count off by one
has been removed from the -mm tree.  Its filename was
     tvp514x-try_count-off-by-one.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tvp514x: try_count off by one
From: Roel Kluin <roel.kluin@gmail.com>

With `while (try_count-- > 0)' try_count reaches -1 after the loop.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/video/tvp514x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/media/video/tvp514x.c~tvp514x-try_count-off-by-one drivers/media/video/tvp514x.c
--- a/drivers/media/video/tvp514x.c~tvp514x-try_count-off-by-one
+++ a/drivers/media/video/tvp514x.c
@@ -692,7 +692,7 @@ static int ioctl_s_routing(struct v4l2_i
 			break;	/* Input detected */
 	}
 
-	if ((current_std == STD_INVALID) || (try_count <= 0))
+	if ((current_std == STD_INVALID) || (try_count < 0))
 		return -EINVAL;
 
 	decoder->current_std = current_std;
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
s3c-fix-check-of-index-into-s3c_gpios.patch
drm-fix-lock_test_with_return-macro.patch
drivers-isdn-i4l-isdn_ttyc-fix-check-for-array-overindexing.patch
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

