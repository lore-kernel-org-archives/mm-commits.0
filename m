From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-rebootc-add-imac91-to-pci_reboot_dmi_table.patch added to -mm tree
Date: Tue, 16 Feb 2010 11:24:45 -0800
Message-ID: <201002161924.o1GJOjLY032749@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757023Ab0BPT0E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Feb 2010 14:26:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: justinmattock@gmail.com, hpa@zytor.com, jbarnes@virtuousgeek.org, mingo@elte.hu, rjw@sisk.pl, tglx@linutronix.de


The patch titled
     arch/x86/kernel/reboot.c: add iMac9,1 to pci_reboot_dmi_table
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-rebootc-add-imac91-to-pci_reboot_dmi_table.patch

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
@@ -459,6 +459,14 @@ static struct dmi_system_id __initdata r
 			DMI_MATCH(DMI_PRODUCT_NAME, "Macmini3,1"),
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

