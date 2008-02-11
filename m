From: akpm@linux-foundation.org
Subject: + tc1100-wmi-fail-gracefully-if-acpi-is-disabled.patch added to -mm tree
Date: Mon, 11 Feb 2008 12:14:04 -0800
Message-ID: <200802112014.m1BKE4cd030966@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43615 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751615AbYBKUtp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 15:49:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: carlos@strangeworlds.co.uk, lenb@kernel.org, mingo@elte.hu


The patch titled
     tc1100-wmi: fail gracefully if ACPI is disabled
has been added to the -mm tree.  Its filename is
     tc1100-wmi-fail-gracefully-if-acpi-is-disabled.patch

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
Subject: tc1100-wmi: fail gracefully if ACPI is disabled
From: Carlos Corbacho <carlos@strangeworlds.co.uk>

WMI drivers, like their ACPI counterparts, should also check if ACPI is
disabled or not, and bail out if so, otherwise we cause a crash.

Spotted by Ingo Molnar.

Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/tc1100-wmi.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/misc/tc1100-wmi.c~tc1100-wmi-fail-gracefully-if-acpi-is-disabled drivers/misc/tc1100-wmi.c
--- a/drivers/misc/tc1100-wmi.c~tc1100-wmi-fail-gracefully-if-acpi-is-disabled
+++ a/drivers/misc/tc1100-wmi.c
@@ -263,6 +263,9 @@ static int __init tc1100_init(void)
 {
 	int result = 0;
 
+	if (acpi_disabled)
+		return -ENODEV;
+
 	if (!wmi_has_guid(GUID))
 		return -ENODEV;
 
_

Patches currently in -mm which might be from carlos@strangeworlds.co.uk are

origin.patch
acer-wmi-fail-gracefully-if-acpi-is-disabled.patch
tc1100-wmi-fail-gracefully-if-acpi-is-disabled.patch
