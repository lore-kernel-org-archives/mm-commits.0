From: akpm@linux-foundation.org
Subject: - hwmon-fix-loading-of-abituguru3-on-abit-ip35-pro-with-bios-17.patch removed from -mm tree
Date: Mon, 04 Aug 2008 18:31:25 -0700
Message-ID: <200808050131.m751VPdC010227@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753280AbYHEBbg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 21:31:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alistair@devzero.co.uk, j.w.r.degoede@hhs.nl, mhoffman@lightlink.com, mm-commits@vger.kernel.org


The patch titled
     hwmon: fix loading of abituguru3 on Abit IP35 Pro with BIOS 17
has been removed from the -mm tree.  Its filename was
     hwmon-fix-loading-of-abituguru3-on-abit-ip35-pro-with-bios-17.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hwmon: fix loading of abituguru3 on Abit IP35 Pro with BIOS 17
From: Alistair John Strachan <alistair@devzero.co.uk>

Fix loading of abituguru3 on Abit IP35 Pro with BIOS 17.  The magic
bytes have changed value (again).

Signed-off-by: Alistair John Strachan <alistair@devzero.co.uk>
Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/abituguru3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hwmon/abituguru3.c~hwmon-fix-loading-of-abituguru3-on-abit-ip35-pro-with-bios-17 drivers/hwmon/abituguru3.c
--- a/drivers/hwmon/abituguru3.c~hwmon-fix-loading-of-abituguru3-on-abit-ip35-pro-with-bios-17
+++ a/drivers/hwmon/abituguru3.c
@@ -1170,7 +1170,7 @@ static int __init abituguru3_detect(void
 	u8 cmd_val = inb_p(ABIT_UGURU3_BASE + ABIT_UGURU3_CMD);
 	if (((data_val == 0x00) || (data_val == 0x08)) &&
 			((cmd_val == 0xAC) || (cmd_val == 0x05) ||
-			 (cmd_val == 0x55)))
+			 (cmd_val == 0x55) || (cmd_val == 0xFF)))
 		return 0;
 
 	ABIT_UGURU3_DEBUG("no Abit uGuru3 found, data = 0x%02X, cmd = "
_

Patches currently in -mm which might be from alistair@devzero.co.uk are

abituguru3-update-maintainers.patch
abituguru3-prefer-dmi-probing-to-manual-probing.patch
hwmon-fix-loading-of-abituguru3-on-abit-ip35-pro-with-bios-17.patch

