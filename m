From: akpm@linux-foundation.org
Subject: - x86-fix-reboot-problem-with-dell-optiplex-745.patch removed from -mm tree
Date: Fri, 21 Mar 2008 13:31:27 -0700
Message-ID: <200803212031.m2LKVR27009073@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761331AbYCUUby (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Mar 2008 16:31:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnolds@MPA-Garching.MPG.DE, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: fix reboot problem with Dell Optiplex 745
has been removed from the -mm tree.  Its filename was
     x86-fix-reboot-problem-with-dell-optiplex-745.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: fix reboot problem with Dell Optiplex 745
From: Heinz-Ado Arnolds <arnolds@MPA-Garching.MPG.DE>

We have seen a little problem in rebooting Dell Optiplex 745 with the 0KW626
board.  A small patch enabling reboot with this board is attached.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/reboot.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN arch/x86/kernel/reboot.c~x86-fix-reboot-problem-with-dell-optiplex-745 arch/x86/kernel/reboot.c
--- a/arch/x86/kernel/reboot.c~x86-fix-reboot-problem-with-dell-optiplex-745
+++ a/arch/x86/kernel/reboot.c
@@ -179,6 +179,15 @@ static struct dmi_system_id __initdata r
 			DMI_MATCH(DMI_BOARD_NAME, "0MM599"),
 		},
 	},
+	{       /* Handle problems with rebooting on Dell Optiplex 745 with 0KW626 */
+		.callback = set_bios_reboot,
+		.ident = "Dell OptiPlex 745",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 745"),
+			DMI_MATCH(DMI_BOARD_NAME, "0KW626"),
+		},
+	},
 	{	/* Handle problems with rebooting on Dell 2400's */
 		.callback = set_bios_reboot,
 		.ident = "Dell PowerEdge 2400",
_

Patches currently in -mm which might be from arnolds@MPA-Garching.MPG.DE are

origin.patch

