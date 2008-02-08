From: akpm@linux-foundation.org
Subject: - i8k-inspiron-e1705-fix.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:09:23 -0800
Message-ID: <200802080809.m18894cg014794@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47715 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760560AbYBHIT3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:19:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: frank@tuxrocks.com, bradjsmith@btinternet.com, jeff@garzik.org, mm-commits@vger.kernel.org


The patch titled
     i8k: Inspiron E1705 fix
has been removed from the -mm tree.  Its filename was
     i8k-inspiron-e1705-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -473,6 +473,13 @@ static struct dmi_system_id __initdata i
 			DMI_MATCH(DMI_PRODUCT_NAME, "MM061"),
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

origin.patch
