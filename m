From: akpm@linux-foundation.org
Subject: + hwmon-fix-loading-of-abituguru3-on-abit-ip35-pro-with-bios-17.patch added to -mm tree
Date: Thu, 31 Jul 2008 09:48:45 -0700
Message-ID: <200807311648.m6VGmjgb001057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755084AbYGaQsz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jul 2008 12:48:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alistair@devzero.co.uk, j.w.r.degoede@hhs.nl, mhoffman@lightlink.com


The patch titled
     hwmon: fix loading of abituguru3 on Abit IP35 Pro with BIOS 17
has been added to the -mm tree.  Its filename is
     hwmon-fix-loading-of-abituguru3-on-abit-ip35-pro-with-bios-17.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1118,7 +1118,7 @@ static int __init abituguru3_detect(void
 	u8 cmd_val = inb_p(ABIT_UGURU3_BASE + ABIT_UGURU3_CMD);
 	if (((data_val == 0x00) || (data_val == 0x08)) &&
 			((cmd_val == 0xAC) || (cmd_val == 0x05) ||
-			 (cmd_val == 0x55)))
+			 (cmd_val == 0x55) || (cmd_val == 0xFF)))
 		return ABIT_UGURU3_BASE;
 
 	ABIT_UGURU3_DEBUG("no Abit uGuru3 found, data = 0x%02X, cmd = "
_

Patches currently in -mm which might be from alistair@devzero.co.uk are

hwmon-fix-loading-of-abituguru3-on-abit-ip35-pro-with-bios-17.patch

