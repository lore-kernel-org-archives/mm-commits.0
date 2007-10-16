From: akpm@linux-foundation.org
Subject: - rtc-pcf8583-check-for-i2c-adapter-functionality.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:41:25 -0700
Message-ID: <200710162041.l9GKfPp7015791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40913 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936058AbXJPVIA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:08:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     rtc-pcf8583: Check for i2c adapter functionality
has been removed from the -mm tree.  Its filename was
     rtc-pcf8583-check-for-i2c-adapter-functionality.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc-pcf8583: Check for i2c adapter functionality
From: Jean Delvare <khali@linux-fr.org>

Not all i2c adapters support I2C-level messaging.  Check that the adapter
does before probing for a PCF8583 chip, as the driver makes use of
i2c_transfer and i2c_master_send.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf8583.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/rtc/rtc-pcf8583.c~rtc-pcf8583-check-for-i2c-adapter-functionality drivers/rtc/rtc-pcf8583.c
--- a/drivers/rtc/rtc-pcf8583.c~rtc-pcf8583-check-for-i2c-adapter-functionality
+++ a/drivers/rtc/rtc-pcf8583.c
@@ -332,6 +332,9 @@ static int pcf8583_probe(struct i2c_adap
 		}
 	};
 
+	if (!i2c_check_functionality(adap, I2C_FUNC_I2C))
+		return 0;
+
 	pcf = kzalloc(sizeof(*pcf), GFP_KERNEL);
 	if (!pcf)
 		return -ENOMEM;
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
git-acpi.patch
git-hwmon.patch
applesmc-for-mac-pro-2-x-quad-core.patch
applesmc-for-mac-pro-2-x-quad-core-fix.patch
git-ieee1394.patch
make-the-pr_-family-of-macros-in-kernelh-complete.patch
i2c-pxa-rename-bit-macro-to-pxa_bit.patch
