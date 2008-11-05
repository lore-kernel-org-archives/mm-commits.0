From: akpm@linux-foundation.org
Subject: + x86-use-bios-reboot-on-toshiba-portege-4000.patch added to -mm tree
Date: Tue, 04 Nov 2008 16:44:37 -0800
Message-ID: <200811050044.mA50ibx1029328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55543 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754028AbYKEApp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2008 19:45:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arvidjaar@mail.ru, avi@redhat.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: use BIOS reboot on Toshiba Portege 4000
has been added to the -mm tree.  Its filename is
     x86-use-bios-reboot-on-toshiba-portege-4000.patch

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
@@ -197,6 +197,14 @@ static struct dmi_system_id __initdata r
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

cpqarry-fix-return-value-of-cpqarray_init.patch
linux-next.patch
acpi-toshiba-only-register-rfkill-if-bt-is-enabled.patch
x86-use-bios-reboot-on-toshiba-portege-4000.patch

