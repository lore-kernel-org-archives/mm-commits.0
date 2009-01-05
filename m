From: akpm@linux-foundation.org
Subject: - i8k-add-support-for-dell-vostro.patch removed from -mm tree
Date: Sun, 04 Jan 2009 22:41:38 -0800
Message-ID: <200901050641.n056fcwS005642@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751384AbZAEGmA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 01:42:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fheinz@vialibre.org.ar, andrew@ishiboo.com, dtor@mail.ru, dz@debian.org, mm-commits@vger.kernel.org


The patch titled
     i8k: add support for Dell Vostro
has been removed from the -mm tree.  Its filename was
     i8k-add-support-for-dell-vostro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i8k: add support for Dell Vostro
From: Federico Heinz <fheinz@vialibre.org.ar>

Add support for i8k on the Dell Vostro models.  I tested it on my Vostro
1400, and it works.  It does print a warning when loading the module:

	i8k: unable to get SMM BIOS version

But I couldn't figure out how to fix that. The module seems to work fine,
anyway.

Reported-by: Andrew Paprocki <andrew@ishiboo.com>
Cc: Massimo Dal Zotto <dz@debian.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/i8k.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/char/i8k.c~i8k-add-support-for-dell-vostro drivers/char/i8k.c
--- a/drivers/char/i8k.c~i8k-add-support-for-dell-vostro
+++ a/drivers/char/i8k.c
@@ -485,6 +485,13 @@ static struct dmi_system_id __initdata i
 			DMI_MATCH(DMI_PRODUCT_NAME, "MP061"),
 		},
 	},
+	{
+		.ident = "Dell Vostro",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro"),
+		},
+	},
 	{ }
 };
 
_

Patches currently in -mm which might be from fheinz@vialibre.org.ar are

origin.patch

