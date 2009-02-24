From: akpm@linux-foundation.org
Subject: [merged] smsc-timeout-reaches-1.patch removed from -mm tree
Date: Tue, 24 Feb 2009 11:32:50 -0800
Message-ID: <200902241932.n1OJWotO004460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753780AbZBXTd2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 14:33:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roel.kluin@gmail.com, steve.glendinning@smsc.com, mm-commits@vger.kernel.org


The patch titled
     drivers/net/smsc: timeout reaches -1
has been removed from the -mm tree.  Its filename was
     smsc-timeout-reaches-1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/smsc: timeout reaches -1
From: Roel Kluin <roel.kluin@gmail.com>

With a postfix decrement timeouts will reach -1 rather than 0, so the
error path is not taken.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: <steve.glendinning@smsc.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/smsc911x.c |    2 +-
 drivers/net/smsc9420.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/net/smsc911x.c~smsc-timeout-reaches-1 drivers/net/smsc911x.c
--- a/drivers/net/smsc911x.c~smsc-timeout-reaches-1
+++ a/drivers/net/smsc911x.c
@@ -1624,7 +1624,7 @@ static int smsc911x_eeprom_send_cmd(stru
 	do {
 		msleep(1);
 		e2cmd = smsc911x_reg_read(pdata, E2P_CMD);
-	} while ((e2cmd & E2P_CMD_EPC_BUSY_) && (timeout--));
+	} while ((e2cmd & E2P_CMD_EPC_BUSY_) && (--timeout));
 
 	if (!timeout) {
 		SMSC_TRACE(DRV, "TIMED OUT");
diff -puN drivers/net/smsc9420.c~smsc-timeout-reaches-1 drivers/net/smsc9420.c
--- a/drivers/net/smsc9420.c~smsc-timeout-reaches-1
+++ a/drivers/net/smsc9420.c
@@ -341,7 +341,7 @@ static int smsc9420_eeprom_send_cmd(stru
 	do {
 		msleep(1);
 		e2cmd = smsc9420_reg_read(pd, E2P_CMD);
-	} while ((e2cmd & E2P_CMD_EPC_BUSY_) && (timeout--));
+	} while ((e2cmd & E2P_CMD_EPC_BUSY_) && (--timeout));
 
 	if (!timeout) {
 		smsc_info(HW, "TIMED OUT");
_

Patches currently in -mm which might be from roel.kluin@gmail.com are

origin.patch
linux-next.patch
acpi-get_throttling_state-cannot-be-larger-state_count.patch
drm-fix-lock_test_with_return-macro.patch
dvb-negative-internal-sub_range-wont-get-noticed.patch
scsi-ncr53c8xx-div-reaches-1.patch
drivers-scsi-pcmcia-nsp_csc-time_out-reaches-1.patch
mm-get_nid_for_pfn-returns-int.patch
frv-duplicate-output_buffer-of-e03.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
alpha-fix-macros.patch
m68k-count-can-reach-51-not-50.patch
m68k-count-can-reach-51-not-50-checkpatch-fixes.patch
spi-limit-reaches-1-tested-0.patch
rtc-wm8350-retries-will-reach-1.patch
fbdev-newport-newport_wait-return-0-on-timeout.patch
drivers-video-omap-hwa742c-div-reaches-max_clk_div.patch
arkfb-fix-misplaced-parentheses.patch
uvesafb-bitwise-or-has-higher-precedence-than.patch
vesafb-bitwise-or-has-higher-precedence-than.patch
ufs-sector_t-cannot-be-negative.patch
rio-addition-has-higher-precedence-than.patch

