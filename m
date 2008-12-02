From: akpm@linux-foundation.org
Subject: - x86-use-bios-reboot-on-toshiba-portege-4000.patch removed from -mm tree
Date: Mon, 01 Dec 2008 19:55:45 -0800
Message-ID: <200812020355.mB23tj1V004519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45898 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751832AbYLBD52 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 22:57:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arvidjaar@mail.ru, avi@redhat.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: use BIOS reboot on Toshiba Portege 4000
has been removed from the -mm tree.  Its filename was
     x86-use-bios-reboot-on-toshiba-portege-4000.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: use BIOS reboot on Toshiba Portege 4000
From: Andrey Borzenkov <arvidjaar@mail.ru>

After commit c7ffa6c26277b403920e2255d10df849bd613380 ("x86: default to
reboot via ACPI") which defaults to reboot via ACPI keyboard is dead on
Toshiba Portege 4000 upon reboot.  Power off is required to revive it
again.  Add DMI entry to force BIOS reboot method as it was before.

Signed-off-by: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Avi Kivity <avi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/reboot.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN arch/x86/kernel/reboot.c~x86-use-bios-reboot-on-toshiba-portege-4000 arch/x86/kernel/reboot.c
--- a/arch/x86/kernel/reboot.c~x86-use-bios-reboot-on-toshiba-portege-4000
+++ a/arch/x86/kernel/reboot.c
@@ -217,6 +217,14 @@ static struct dmi_system_id __initdata r
 			DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq"),
 		},
 	},
+	{	/* Handle problems with rebooting on Toshiba Portege 4000 */
+		.callback = set_bios_reboot,
+		.ident = "Toshiba Portege 4000",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PORTEGE 4000"),
+		},
+	},
 	{ }
 };
 
_

Patches currently in -mm which might be from arvidjaar@mail.ru are

linux-next.patch
x86-use-bios-reboot-on-toshiba-portege-4000.patch

