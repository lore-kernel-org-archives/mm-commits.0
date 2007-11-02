From: akpm@linux-foundation.org
Subject: + i8k-inspiron-e1705-fix.patch added to -mm tree
Date: Fri, 02 Nov 2007 14:18:02 -0700
Message-ID: <200711022118.lA2LI2YS011411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56728 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754092AbXKBVSK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 17:18:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: frank@tuxrocks.com, bradjsmith@btinternet.com, jeff@garzik.org


The patch titled
     i8k: Inspiron E1705 fix
has been added to the -mm tree.  Its filename is
     i8k-inspiron-e1705-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i8k: Inspiron E1705 fix
From: Frank Sorenson <frank@tuxrocks.com>

Needs the following in order to work correctly on my Inspiron E1705:

Add DMI Product name to i8k for Dell MP061 hardware (Inspiron 9400/E1705)

Signed-off-by: Frank Sorenson <frank@tuxrocks.com>
Cc: Bradley Smith <bradjsmith@btinternet.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/i8k.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/char/i8k.c~i8k-inspiron-e1705-fix drivers/char/i8k.c
--- a/drivers/char/i8k.c~i8k-inspiron-e1705-fix
+++ a/drivers/char/i8k.c
@@ -466,6 +466,13 @@ static struct dmi_system_id __initdata i
 			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude"),
 		},
 	},
+	{
+		.ident = "Dell Inspiron 3",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MP061"),
+		},
+	},
 	{ }
 };
 
_

Patches currently in -mm which might be from frank@tuxrocks.com are

i8k-allow-i8k-driver-to-be-built-on-x86_64-systems.patch
i8k-adds-i8k-driver-to-the-x86_64-kconfig.patch
i8k-inspiron-e1705-fix.patch
