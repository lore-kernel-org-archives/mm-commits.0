From: akpm@osdl.org
Subject: + mmc-au1xmmc-return-errors-for-unknown-response-types.patch added to -mm tree
Date: Fri, 26 Jan 2007 12:02:31 -0800
Message-ID: <200701262002.l0QK2VPg025204@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52868 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132AbXAZUDe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 15:03:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mano@roarinelk.homelinux.net


The patch titled
     mmc: au1xmmc: return errors for unknown response types
has been added to the -mm tree.  Its filename is
     mmc-au1xmmc-return-errors-for-unknown-response-types.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

mmc-au1xmmc-return-errors-for-unknown-response-types.patch
git-sh.patch
