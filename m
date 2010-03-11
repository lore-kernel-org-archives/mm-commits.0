From: akpm@linux-foundation.org
Subject: [merged] arch-x86-kernel-rebootc-add-imac91-to-pci_reboot_dmi_table.patch removed from -mm tree
Date: Thu, 11 Mar 2010 13:59:41 -0800
Message-ID: <201003112159.o2BLxfi9012860@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757330Ab0CKWAA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 11 Mar 2010 17:00:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: justinmattock@gmail.com, hpa@zytor.com, jbarnes@virtuousgeek.org, mingo@elte.hu, rjw@sisk.pl, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     arch/x86/kernel/reboot.c: add iMac9,1 to pci_reboot_dmi_table
has been removed from the -mm tree.  Its filename was
     arch-x86-kernel-rebootc-add-imac91-to-pci_reboot_dmi_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/kernel/reboot.c: add iMac9,1 to pci_reboot_dmi_table
From: "Justin P. Mattock" <justinmattock@gmail.com>

On the iMac9,1 /sbin/reboot results in a black mangled screen.  Adding
this DMI entry gets the machine to reboot cleanly as it should.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/reboot.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN arch/x86/kernel/reboot.c~arch-x86-kernel-rebootc-add-imac91-to-pci_reboot_dmi_table arch/x86/kernel/reboot.c
--- a/arch/x86/kernel/reboot.c~arch-x86-kernel-rebootc-add-imac91-to-pci_reboot_dmi_table
+++ a/arch/x86/kernel/reboot.c
@@ -467,6 +467,14 @@ static struct dmi_system_id __initdata r
 			DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
 		},
 	},
+	{	/* Handle problems with rebooting on the iMac9,1. */
+		.callback = set_pci_reboot,
+		.ident = "Apple iMac9,1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
+		},
+	},
 	{ }
 };
 
_

Patches currently in -mm which might be from justinmattock@gmail.com are

linux-next.patch
arch-x86-kernel-rebootc-add-imac91-to-pci_reboot_dmi_table.patch

