From: akpm@linux-foundation.org
Subject: - acpi-add-dmi-info-to-enable-osilinux-on-primequest.patch removed from -mm tree
Date: Tue, 27 May 2008 18:28:14 -0700
Message-ID: <200805280128.m4S1SEQp022836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759687AbYE1B3A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 May 2008 21:29:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: izumi.taku@jp.fujitsu.com, lenb@kernel.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     acpi: add DMI info to enable OSI(Linux) on PRIMEQUEST
has been removed from the -mm tree.  Its filename was
     acpi-add-dmi-info-to-enable-osilinux-on-primequest.patch

This patch was dropped because it was withdrawn

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi: add DMI info to enable OSI(Linux) on PRIMEQUEST
From: Taku Izumi <izumi.taku@jp.fujitsu.com>

Add DMI info to enable OSI(Linux) on PRIMEQUEST.  (PRIMEQUEST is ia64
machine.)

Signed-off-by: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/blacklist.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN drivers/acpi/blacklist.c~acpi-add-dmi-info-to-enable-osilinux-on-primequest drivers/acpi/blacklist.c
--- a/drivers/acpi/blacklist.c~acpi-add-dmi-info-to-enable-osilinux-on-primequest
+++ a/drivers/acpi/blacklist.c
@@ -634,6 +634,20 @@ static struct dmi_system_id acpi_osi_dmi
 		     DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
 		},
 	},
+	/*
+	 * Enable OSI(Linux) on Fujitsu PRIMEQUEST
+	 *
+	 * DMI_MATCH(DMI_BIOS_VERSION, "PRIMEQUEST"),
+	 *
+	 */
+	{
+	.callback = dmi_enable_osi_linux,
+	.ident = "Fujitsu PRIMEQUEST",
+	.matches = {
+		     DMI_MATCH(DMI_BIOS_VENDOR, "FUJITSU LIMITED"),
+		     DMI_MATCH(DMI_BIOS_VERSION, "PRIMEQUEST"),
+		},
+	},
 	{}
 };
 
_

Patches currently in -mm which might be from izumi.taku@jp.fujitsu.com are

acpi-add-dmi-info-to-enable-osilinux-on-primequest.patch

