From: akpm@linux-foundation.org
Subject: [merged] x86-add-reboot-fixup-for-compulab-sbc-fitpc2-board.patch removed from -mm tree
Date: Thu, 06 Aug 2009 16:39:12 -0700
Message-ID: <200908062339.n76NdCBO029355@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39151 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755967AbZHFXjc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Aug 2009 19:39:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: denis@compulab.co.il, hpa@zytor.com, mike@compulab.co.il, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: add reboot fixup for CompuLab SBC-fitPC2 board
has been removed from the -mm tree.  Its filename was
     x86-add-reboot-fixup-for-compulab-sbc-fitpc2-board.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: add reboot fixup for CompuLab SBC-fitPC2 board
From: Denis Turischev <denis@compulab.co.il>

The sbc-fitpc2 board hangs on reboot without this patch.  We saw fixups
for Dell and others that set BIOS reboot and that worked for us as well.

[akpm@linux-foundation.org: clean up comment]
Signed-off-by: Denis Turischev <denis@compulab.co.il>
Signed-off-by: Mike Rapoport <mike@compulab.co.il
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/reboot.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN arch/x86/kernel/reboot.c~x86-add-reboot-fixup-for-compulab-sbc-fitpc2-board arch/x86/kernel/reboot.c
--- a/arch/x86/kernel/reboot.c~x86-add-reboot-fixup-for-compulab-sbc-fitpc2-board
+++ a/arch/x86/kernel/reboot.c
@@ -257,6 +257,14 @@ static struct dmi_system_id __initdata r
 			DMI_MATCH(DMI_PRODUCT_NAME, "SBC-FITPC2"),
 		},
 	},
+	{	/* Handle problems with rebooting CompuLab SBC-FITPC2 boards */
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

