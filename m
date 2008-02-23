From: akpm@linux-foundation.org
Subject: + add-the-dff-desktop-form-factor-dell-optiplex-745-to-the-reboot-errata-list.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:31:33 -0800
Message-ID: <200802230732.m1N7WMTa018076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757214AbYBWIDG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:03:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ckane@intellitree.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     Add the DFF (Desktop Form Factor) Dell Optiplex 745 to the reboot errata list
has been added to the -mm tree.  Its filename is
     add-the-dff-desktop-form-factor-dell-optiplex-745-to-the-reboot-errata-list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -152,6 +152,15 @@ static struct dmi_system_id __initdata r
 			DMI_MATCH(DMI_BOARD_NAME, "0WF810"),
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
