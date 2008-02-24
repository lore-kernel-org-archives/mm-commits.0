From: akpm@linux-foundation.org
Subject: - acer-wmi-fail-gracefully-if-acpi-is-disabled.patch removed from -mm tree
Date: Sat, 23 Feb 2008 18:17:54 -0800
Message-ID: <200802240217.m1O2HsF4025386@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:35462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754887AbYBXCSZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 21:18:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: carlos@strangeworlds.co.uk, lenb@kernel.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     acer-wmi: fail gracefully if ACPI is disabled
has been removed from the -mm tree.  Its filename was
     acer-wmi-fail-gracefully-if-acpi-is-disabled.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acer-wmi: fail gracefully if ACPI is disabled
From: Carlos Corbacho <carlos@strangeworlds.co.uk>

WMI drivers, like their ACPI counterparts, should also check if ACPI is
disabled or not, and bail out if so, otherwise we cause a crash.

Spotted by Ingo Molnar.

Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>
Acked-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/acer-wmi.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/misc/acer-wmi.c~acer-wmi-fail-gracefully-if-acpi-is-disabled drivers/misc/acer-wmi.c
--- a/drivers/misc/acer-wmi.c~acer-wmi-fail-gracefully-if-acpi-is-disabled
+++ a/drivers/misc/acer-wmi.c
@@ -1038,6 +1038,9 @@ static int __init acer_wmi_init(void)
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
git-acpi.patch
