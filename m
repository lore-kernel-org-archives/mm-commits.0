From: akpm@linux-foundation.org
Subject: - x96-quirk-for-reboot-stalls-on-a-dell-optiplex-330.patch removed from -mm tree
Date: Mon, 01 Dec 2008 14:07:21 -0800
Message-ID: <200812012207.mB1M7LZu005224@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55954 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751507AbYLAWIN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 17:08:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: leann.ogasawara@canonical.com, mingo@elte.hu, steve.conklin@canonical.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: quirk for reboot stalls on a Dell Optiplex 330
has been removed from the -mm tree.  Its filename was
     x96-quirk-for-reboot-stalls-on-a-dell-optiplex-330.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: quirk for reboot stalls on a Dell Optiplex 330
From: Leann Ogasawara <leann.ogasawara@canonical.com>

Dell Optiplex 330 appears to hang on reboot. This is resolved by adding
a quirk to set bios reboot.

Signed-off-by: Leann Ogasawara <leann.ogasawara@canonical.com>
Signed-off-by: Steve Conklin <steve.conklin@canonical.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/reboot.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN arch/x86/kernel/reboot.c~x96-quirk-for-reboot-stalls-on-a-dell-optiplex-330 arch/x86/kernel/reboot.c
--- a/arch/x86/kernel/reboot.c~x96-quirk-for-reboot-stalls-on-a-dell-optiplex-330
+++ a/arch/x86/kernel/reboot.c
@@ -178,6 +178,15 @@ static struct dmi_system_id __initdata r
 			DMI_MATCH(DMI_BOARD_NAME, "0KP561"),
 		},
 	},
+	{   /* Handle problems with rebooting on Dell Optiplex 330 with 0KP561 */
+		.callback = set_bios_reboot,
+		.ident = "Dell OptiPlex 330",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 330"),
+			DMI_MATCH(DMI_BOARD_NAME, "0KP561"),
+		},
+	},
 	{	/* Handle problems with rebooting on Dell 2400's */
 		.callback = set_bios_reboot,
 		.ident = "Dell PowerEdge 2400",
_

Patches currently in -mm which might be from leann.ogasawara@canonical.com are

x96-quirk-for-reboot-stalls-on-a-dell-optiplex-330.patch

