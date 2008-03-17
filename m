From: akpm@linux-foundation.org
Subject: - mmc-data_carry-is-not-boolean-in-tifm_sd_transfer_data.patch removed from -mm tree
Date: Mon, 17 Mar 2008 14:00:17 -0700
Message-ID: <200803172100.m2HL0HpY030844@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34152 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753816AbYCQVAl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Mar 2008 17:00:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: 12o3l@tiscali.nl, mm-commits@vger.kernel.org


The patch titled
     MMC: DATA_CARRY is not boolean in tifm_sd_transfer_data()
has been removed from the -mm tree.  Its filename was
     mmc-data_carry-is-not-boolean-in-tifm_sd_transfer_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: MMC: DATA_CARRY is not boolean in tifm_sd_transfer_data()
From: Roel Kluin <12o3l@tiscali.nl>

DATA_CARRY is not boolean

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/tifm_sd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/mmc/host/tifm_sd.c~mmc-data_carry-is-not-boolean-in-tifm_sd_transfer_data drivers/mmc/host/tifm_sd.c
--- a/drivers/mmc/host/tifm_sd.c~mmc-data_carry-is-not-boolean-in-tifm_sd_transfer_data
+++ a/drivers/mmc/host/tifm_sd.c
@@ -180,7 +180,7 @@ static void tifm_sd_transfer_data(struct
 			host->sg_pos++;
 			if (host->sg_pos == host->sg_len) {
 				if ((r_data->flags & MMC_DATA_WRITE)
-				    && DATA_CARRY)
+				    && (host->cmd_flags & DATA_CARRY))
 					writel(host->bounce_buf_data[0],
 					       host->dev->addr
 					       + SOCK_MMCSD_DATA);
_

Patches currently in -mm which might be from 12o3l@tiscali.nl are

git-dvb.patch
adt746x-logical-bitwise-confusion-in-set_max_duty_at_crit.patch
block-blk-mergec-inverted-likeliness-in-ll_back_merge_fn.patch
free-when-fb-cant-be-registered-in-video-aty-atyfb_basec.patch
drivers-video-aty-aty128fbc-fix-incorrect-usage-of-strncat-in-aty128_init.patch
drivers-video-imsttfbc-add-missing-curly-brackets.patch

