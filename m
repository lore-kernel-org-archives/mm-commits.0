From: akpm@linux-foundation.org
Subject: + x86-fix-reboot-problem-with-dell-optiplex-745.patch added to -mm tree
Date: Thu, 13 Mar 2008 12:55:52 -0700
Message-ID: <200803131955.m2DJtqPS030146@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754085AbYCMT4p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Mar 2008 15:56:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arnolds@MPA-Garching.MPG.DE, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: fix reboot problem with Dell Optiplex 745
has been added to the -mm tree.  Its filename is
     x86-fix-reboot-problem-with-dell-optiplex-745.patch

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
@@ -161,6 +161,15 @@ static struct dmi_system_id __initdata r
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

x86-fix-reboot-problem-with-dell-optiplex-745.patch

