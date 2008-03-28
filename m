From: akpm@linux-foundation.org
Subject: - add-the-dff-desktop-form-factor-dell-optiplex-745-to-the-reboot-errata-list.patch removed from -mm tree
Date: Fri, 28 Mar 2008 15:13:57 -0700
Message-ID: <200803282213.m2SMDvae013349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752897AbYC1WOf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Mar 2008 18:14:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ckane@intellitree.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Add the DFF (Desktop Form Factor) Dell Optiplex 745 to the reboot errata list
has been removed from the -mm tree.  Its filename was
     add-the-dff-desktop-form-factor-dell-optiplex-745-to-the-reboot-errata-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add the DFF (Desktop Form Factor) Dell Optiplex 745 to the reboot errata list
From: Coleman Kane <ckane@intellitree.com>

We recently got some of the "Desktop Form Factor" Optiplex 745's in.  I
noticed that there's an entry for the SFF one's, but the BIOS model number
of the DFF differs from that of the SFF.  We have been reliably
experiencing the same (as far as I can tell) reboot bug as the SFF boxes.

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/reboot.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN arch/x86/kernel/reboot.c~add-the-dff-desktop-form-factor-dell-optiplex-745-to-the-reboot-errata-list arch/x86/kernel/reboot.c
--- a/arch/x86/kernel/reboot.c~add-the-dff-desktop-form-factor-dell-optiplex-745-to-the-reboot-errata-list
+++ a/arch/x86/kernel/reboot.c
@@ -170,6 +170,15 @@ static struct dmi_system_id __initdata r
 			DMI_MATCH(DMI_BOARD_NAME, "0KW626"),
 		},
 	},
+	{       /* Handle problems with rebooting on Dell Optiplex 745's DFF*/
+		.callback = set_bios_reboot,
+		.ident = "Dell OptiPlex 745",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 745"),
+			DMI_MATCH(DMI_BOARD_NAME, "0MM599"),
+		},
+	},
 	{	/* Handle problems with rebooting on Dell 2400's */
 		.callback = set_bios_reboot,
 		.ident = "Dell PowerEdge 2400",
_

Patches currently in -mm which might be from ckane@intellitree.com are

add-the-dff-desktop-form-factor-dell-optiplex-745-to-the-reboot-errata-list.patch

