From: akpm@linux-foundation.org
Subject: + acpi-thinkpad-acpi-fix-hotkey_get_tablet_mode.patch added to -mm tree
Date: Thu, 28 Feb 2008 01:55:11 -0800
Message-ID: <200802280955.m1S9tBSK026786@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755235AbYB1Jzk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 04:55:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hmh@hmh.eng.br, lenb@kernel.org, rjw@sisk.pl, xhejtman@ics.muni.cz, zdenek.kabelac@gmail.com


The patch titled
     ACPI: thinkpad-acpi: fix hotkey_get_tablet_mode
has been added to the -mm tree.  Its filename is
     acpi-thinkpad-acpi-fix-hotkey_get_tablet_mode.patch

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
Subject: ACPI: thinkpad-acpi: fix hotkey_get_tablet_mode
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

I used the wrong return convention on hotkey_get_tablet_mode(), breaking a lot
of stuff.  Bad Henrique!

Fix it to return the status in the parameter-by-reference, and IO status on
the function return value.  Duh.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/thinkpad_acpi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/misc/thinkpad_acpi.c~acpi-thinkpad-acpi-fix-hotkey_get_tablet_mode drivers/misc/thinkpad_acpi.c
--- a/drivers/misc/thinkpad_acpi.c~acpi-thinkpad-acpi-fix-hotkey_get_tablet_mode
+++ a/drivers/misc/thinkpad_acpi.c
@@ -1078,7 +1078,8 @@ static int hotkey_get_tablet_mode(int *s
 	if (!acpi_evalf(hkey_handle, &s, "MHKG", "d"))
 		return -EIO;
 
-	return ((s & TP_HOTKEY_TABLET_MASK) != 0);
+	*status = ((s & TP_HOTKEY_TABLET_MASK) != 0);
+	return 0;
 }
 
 /*
_

Patches currently in -mm which might be from hmh@hmh.eng.br are

miscacpibacklight-compal-laptop-extras-3rd-try.patch
acpi-thinkpad-acpi-fix-hotkey_get_tablet_mode.patch
