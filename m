From: akpm@linux-foundation.org
Subject: + acer-wmi-fail-gracefully-if-acpi-is-disabled.patch added to -mm tree
Date: Mon, 11 Feb 2008 12:13:08 -0800
Message-ID: <200802112013.m1BKD853030882@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41457 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247AbYBKUmc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Feb 2008 15:42:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: carlos@strangeworlds.co.uk, akpm@linux-foundation.org, lenb@kernel.org, mingo@elte.hu, torvalds@linux-foundation.org


The patch titled
     acer-wmi: fail gracefully if ACPI is disabled
has been added to the -mm tree.  Its filename is
     acer-wmi-fail-gracefully-if-acpi-is-disabled.patch

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
Subject: acer-wmi: fail gracefully if ACPI is disabled
From: Carlos Corbacho <carlos@strangeworlds.co.uk>

WMI drivers, like their ACPI counterparts, should also check if ACPI is
disabled or not, and bail out if so, otherwise we cause a crash.

Spotted by Ingo Molnar.

Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/acer-wmi.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/misc/acer-wmi.c~acer-wmi-fail-gracefully-if-acpi-is-disabled drivers/misc/acer-wmi.c
--- a/drivers/misc/acer-wmi.c~acer-wmi-fail-gracefully-if-acpi-is-disabled
+++ a/drivers/misc/acer-wmi.c
@@ -1031,6 +1031,9 @@ static int __init acer_wmi_init(void)
 {
 	int err;
 
+	if (acpi_disabled)
+		return -ENODEV;
+
 	printk(ACER_INFO "Acer Laptop ACPI-WMI Extras version %s\n",
 			ACER_WMI_VERSION);
 
_

Patches currently in -mm which might be from carlos@strangeworlds.co.uk are

origin.patch
acer-wmi-fail-gracefully-if-acpi-is-disabled.patch
