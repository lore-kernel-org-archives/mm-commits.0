From: akpm@linux-foundation.org
Subject: + drivers-w1-slaves-w1_thermc-add-support-for-ds28ea00.patch added to -mm tree
Date: Wed, 06 Jul 2011 15:27:48 -0700
Message-ID: <201107062227.p66MRmOf003537@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38082 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751568Ab1GFW2b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jul 2011 18:28:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: christian.glindkamp@taskit.de, johnpol@2ka.mipt.ru


The patch titled
     drivers/w1/slaves/w1_therm.c: add support for DS28EA00
has been added to the -mm tree.  Its filename is
     drivers-w1-slaves-w1_thermc-add-support-for-ds28ea00.patch

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

drivers-w1-slaves-w1_thermc-add-support-for-ds28ea00.patch

