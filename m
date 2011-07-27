From: akpm@linux-foundation.org
Subject: [merged] drivers-w1-slaves-w1_thermc-add-support-for-ds28ea00.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:29:20 -0700
Message-ID: <201107271928.p6RJS6fa003279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754981Ab1G0T2f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:28:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: christian.glindkamp@taskit.de, johnpol@2ka.mipt.ru, mm-commits@vger.kernel.org


The patch titled
     drivers/w1/slaves/w1_therm.c: add support for DS28EA00
has been removed from the -mm tree.  Its filename was
     drivers-w1-slaves-w1_thermc-add-support-for-ds28ea00.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/w1/slaves/w1_therm.c: add support for DS28EA00
From: Christian Glindkamp <christian.glindkamp@taskit.de>

Signed-off-by: Christian Glindkamp <christian.glindkamp@taskit.de>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_therm.c |    9 +++++++++
 drivers/w1/w1_family.h       |    1 +
 2 files changed, 10 insertions(+)

diff -puN drivers/w1/slaves/w1_therm.c~drivers-w1-slaves-w1_thermc-add-support-for-ds28ea00 drivers/w1/slaves/w1_therm.c
--- a/drivers/w1/slaves/w1_therm.c~drivers-w1-slaves-w1_thermc-add-support-for-ds28ea00
+++ a/drivers/w1/slaves/w1_therm.c
@@ -86,6 +86,11 @@ static struct w1_family w1_therm_family_
 	.fops = &w1_therm_fops,
 };
 
+static struct w1_family w1_therm_family_DS28EA00 = {
+	.fid = W1_THERM_DS28EA00,
+	.fops = &w1_therm_fops,
+};
+
 struct w1_therm_family_converter
 {
 	u8			broken;
@@ -111,6 +116,10 @@ static struct w1_therm_family_converter 
 		.f		= &w1_therm_family_DS18B20,
 		.convert 	= w1_DS18B20_convert_temp
 	},
+	{
+		.f		= &w1_therm_family_DS28EA00,
+		.convert	= w1_DS18B20_convert_temp
+	},
 };
 
 static inline int w1_DS18B20_convert_temp(u8 rom[9])
diff -puN drivers/w1/w1_family.h~drivers-w1-slaves-w1_thermc-add-support-for-ds28ea00 drivers/w1/w1_family.h
--- a/drivers/w1/w1_family.h~drivers-w1-slaves-w1_thermc-add-support-for-ds28ea00
+++ a/drivers/w1/w1_family.h
@@ -38,6 +38,7 @@
 #define W1_EEPROM_DS2431	0x2D
 #define W1_FAMILY_DS2760	0x30
 #define W1_FAMILY_DS2780	0x32
+#define W1_THERM_DS28EA00	0x42
 
 #define MAXNAMELEN		32
 
_

Patches currently in -mm which might be from christian.glindkamp@taskit.de are

origin.patch

