From: akpm@linux-foundation.org
Subject: + i8k-add-support-for-dell-vostro.patch added to -mm tree
Date: Wed, 17 Dec 2008 22:22:27 -0800
Message-ID: <200812180622.mBI6MRgD005469@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752500AbYLRGWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Dec 2008 01:22:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fheinz@vialibre.org.ar, andrew@ishiboo.com, dtor@mail.ru, dz@debian.org


The patch titled
     i8k: add support for Dell Vostro
has been added to the -mm tree.  Its filename is
     i8k-add-support-for-dell-vostro.patch

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

i8k-add-support-for-dell-vostro.patch

