From: akpm@linux-foundation.org
Subject: + smsc-timeout-reaches-1.patch added to -mm tree
Date: Wed, 18 Feb 2009 14:42:36 -0800
Message-ID: <200902182242.n1IMga4Y005230@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758623AbZBRWnA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Feb 2009 17:43:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: roel.kluin@gmail.com, steve.glendinning@smsc.com


The patch titled
     drivers/net/smsc: timeout reaches -1
has been added to the -mm tree.  Its filename is
     smsc-timeout-reaches-1.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
atm-bitwise-or-has-higher-precedence-than.patch
drivers-net-tg3c-fix-confusion.patch
smsc-timeout-reaches-1.patch
scsi-ncr53c8xx-div-reaches-1.patch
paride-pgc-xs-confusion.patch
b43-bitwise-or-has-higher-precedence-than.patch
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

