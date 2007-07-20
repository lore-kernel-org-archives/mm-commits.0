From: akpm@linux-foundation.org
Subject: - dmi_match-patch-in-rebootc-for-sff-dell-optiplex-745-fixes-hang.patch removed from -mm tree
Date: Thu, 19 Jul 2007 23:57:59 -0700
Message-ID: <200707200658.l6K6vxSV012458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34169 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754288AbXGTG6W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 02:58:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: James.Jarvis@ed.ac.uk, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     DMI_MATCH patch in reboot.c for SFF Dell OptiPlex 745 - fixes hang on reboot
has been removed from the -mm tree.  Its filename was
     dmi_match-patch-in-rebootc-for-sff-dell-optiplex-745-fixes-hang.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: DMI_MATCH patch in reboot.c for SFF Dell OptiPlex 745 - fixes hang on reboot
From: James Jarvis <James.Jarvis@ed.ac.uk>

The following patch enables reboot through BIOS on the Dell Optiplex 745
Small Form Factor base, on which reboot hangs.  The larger form factor does
not require this, hence the match on DMI_BOARD_NAME.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/reboot.c |    9 +++++++++
 1 files changed, 9 insertions(+)

diff -puN arch/i386/kernel/reboot.c~dmi_match-patch-in-rebootc-for-sff-dell-optiplex-745-fixes-hang arch/i386/kernel/reboot.c
--- a/arch/i386/kernel/reboot.c~dmi_match-patch-in-rebootc-for-sff-dell-optiplex-745-fixes-hang
+++ a/arch/i386/kernel/reboot.c
@@ -113,6 +113,15 @@ static struct dmi_system_id __initdata r
 			DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 300/"),
 		},
 	},
+	{       /* Handle problems with rebooting on Dell Optiplex 745's SFF*/
+		.callback = set_bios_reboot,
+		.ident = "Dell OptiPlex 745",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 745"),
+			DMI_MATCH(DMI_BOARD_NAME, "0WF810"),
+		},
+	},
 	{	/* Handle problems with rebooting on Dell 2400's */
 		.callback = set_bios_reboot,
 		.ident = "Dell PowerEdge 2400",
_

Patches currently in -mm which might be from James.Jarvis@ed.ac.uk are

dmi_match-patch-in-rebootc-for-sff-dell-optiplex-745-fixes-hang.patch
