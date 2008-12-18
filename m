From: akpm@linux-foundation.org
Subject: + i8k-add-support-for-dell-precisions.patch added to -mm tree
Date: Wed, 17 Dec 2008 22:22:31 -0800
Message-ID: <200812180622.mBI6MVWh005472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752545AbYLRGWq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Dec 2008 01:22:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: spenceal@rose-hulman.edu, andrew@ishiboo.com, dtor@mail.ru, dz@debian.org


The patch titled
     i8k: add support for Dell Precisions
has been added to the -mm tree.  Its filename is
     i8k-add-support-for-dell-precisions.patch

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
Subject: i8k: add support for Dell Precisions
From: Andy Spencer <spenceal@rose-hulman.edu>

Make i8k work on Dell Precisions.  I have been using this on my Dell
Precision M70 for a while and haven't noticed any problems.

Reported-by: Andrew Paprocki <andrew@ishiboo.com>
Cc: Massimo Dal Zotto <dz@debian.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/i8k.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/char/i8k.c~i8k-add-support-for-dell-precisions drivers/char/i8k.c
--- a/drivers/char/i8k.c~i8k-add-support-for-dell-precisions
+++ a/drivers/char/i8k.c
@@ -492,6 +492,13 @@ static struct dmi_system_id __initdata i
 			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro"),
 		},
 	},
+	{
+		.ident = "Dell Precision",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Precision"),
+		},
+	},
 	{ }
 };
 
_

Patches currently in -mm which might be from spenceal@rose-hulman.edu are

i8k-add-support-for-dell-precisions.patch

