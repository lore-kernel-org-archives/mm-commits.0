From: akpm@linux-foundation.org
Subject: - mmc-au1xmmc-return-errors-for-unknown-response-types.patch removed from -mm tree
Date: Mon, 05 Feb 2007 12:41:24 -0800
Message-ID: <200702052041.l15KfOwZ030570@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60806 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933438AbXBEUmo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Feb 2007 15:42:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mano@roarinelk.homelinux.net, mm-commits@vger.kernel.org


The patch titled
     mmc: au1xmmc: return errors for unknown response types
has been removed from the -mm tree.  Its filename was
     mmc-au1xmmc-return-errors-for-unknown-response-types.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mmc: au1xmmc: return errors for unknown response types
From: Manuel Lauss <mano@roarinelk.homelinux.net>

au1xmmc: return error when encountering unhandled/unknown response type.

Signed-off-by: Manuel Lauss <mano@roarinelk.homelinux.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/mmc/au1xmmc.c |    6 ++++++
 1 files changed, 6 insertions(+)

diff -puN drivers/mmc/au1xmmc.c~mmc-au1xmmc-return-errors-for-unknown-response-types drivers/mmc/au1xmmc.c
--- a/drivers/mmc/au1xmmc.c~mmc-au1xmmc-return-errors-for-unknown-response-types
+++ a/drivers/mmc/au1xmmc.c
@@ -193,6 +193,8 @@ static int au1xmmc_send_command(struct a
 	u32 mmccmd = (cmd->opcode << SD_CMD_CI_SHIFT);
 
 	switch (mmc_resp_type(cmd)) {
+	case MMC_RSP_NONE:
+		break;
 	case MMC_RSP_R1:
 		mmccmd |= SD_CMD_RT_1;
 		break;
@@ -205,6 +207,10 @@ static int au1xmmc_send_command(struct a
 	case MMC_RSP_R3:
 		mmccmd |= SD_CMD_RT_3;
 		break;
+	default:
+		printk(KERN_INFO "au1xmmc: unhandled response type %02x\n",
+			mmc_resp_type(cmd));
+		return MMC_ERR_INVALID;
 	}
 
 	switch(cmd->opcode) {
_

Patches currently in -mm which might be from mano@roarinelk.homelinux.net are

git-mmc.patch
git-sh.patch
