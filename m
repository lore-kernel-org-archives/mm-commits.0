From: akpm@linux-foundation.org
Subject: - acpi-thinkpad-acpi-fix-hotkey_get_tablet_mode.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:46:00 -0800
Message-ID: <200803050746.m257k098021638@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54008 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764916AbYCEHqk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:46:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hmh@hmh.eng.br, lenb@kernel.org, rjw@sisk.pl, xhejtman@ics.muni.cz, zdenek.kabelac@gmail.com, mm-commits@vger.kernel.org


The patch titled
     ACPI: thinkpad-acpi: fix hotkey_get_tablet_mode
has been removed from the -mm tree.  Its filename was
     acpi-thinkpad-acpi-fix-hotkey_get_tablet_mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

