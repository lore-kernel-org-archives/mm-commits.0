From: akpm@linux-foundation.org
Subject: + x86-add-reboot-fixup-for-compulab-sbc-fitpc2-board.patch added to -mm tree
Date: Wed, 22 Jul 2009 17:39:46 -0700
Message-ID: <200907230039.n6N0dkxF008737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37894 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751821AbZGWAkH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Jul 2009 20:40:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: denis@compulab.co.il, hpa@zytor.com, mike@compulab.co.il, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: add reboot fixup for CompuLab SBC-fitPC2 board
has been added to the -mm tree.  Its filename is
     x86-add-reboot-fixup-for-compulab-sbc-fitpc2-board.patch

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
Subject: x86: add reboot fixup for CompuLab SBC-fitPC2 board
From: Denis Turischev <denis@compulab.co.il>

Singned-off-by: Denis Turischev <denis@compulab.co.il>
Signed-off-by: Mike Rapoport <mike@compulab.co.il
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/reboot.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN arch/x86/kernel/reboot.c~x86-add-reboot-fixup-for-compulab-sbc-fitpc2-board arch/x86/kernel/reboot.c
--- a/arch/x86/kernel/reboot.c~x86-add-reboot-fixup-for-compulab-sbc-fitpc2-board
+++ a/arch/x86/kernel/reboot.c
@@ -249,6 +249,15 @@ static struct dmi_system_id __initdata r
 			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-Z540N"),
 		},
 	},
+	{	/* Handle problems with rebooting on
+				CompuLab SBC-FITPC2 board */
+		.callback = set_bios_reboot,
+		.ident = "CompuLab SBC-FITPC2",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "CompuLab"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "SBC-FITPC2"),
+		},
+	},
 	{ }
 };
 
_

Patches currently in -mm which might be from denis@compulab.co.il are

x86-add-reboot-fixup-for-compulab-sbc-fitpc2-board.patch
x86-add-reboot-fixup-for-compulab-sbc-fitpc2-board-cleanup.patch

