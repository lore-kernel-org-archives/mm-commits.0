From: akpm@linux-foundation.org
Subject: - x86-add-io-delay-quirk-for-presario-f700.patch removed from -mm tree
Date: Mon, 22 Sep 2008 14:27:04 -0700
Message-ID: <200809222127.m8MLR4MA030583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752112AbYIVV1j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Sep 2008 17:27:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cebbert@redhat.com, mm-commits@vger.kernel.org


The patch titled
     x86: add io delay quirk for Presario F700
has been removed from the -mm tree.  Its filename was
     x86-add-io-delay-quirk-for-presario-f700.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: add io delay quirk for Presario F700
From: Chuck Ebbert <cebbert@redhat.com>

Manually adding "io_delay=0xed" fixes system lockups in ioapic
mode on this machine.

System Information
	Manufacturer: Hewlett-Packard
	Product Name: Presario F700 (KA695EA#ABF)

Base Board Information
	Manufacturer: Quanta
	Product Name: 30D3

Reference:
https://bugzilla.redhat.com/show_bug.cgi?id=459546

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/io_delay.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN arch/x86/kernel/io_delay.c~x86-add-io-delay-quirk-for-presario-f700 arch/x86/kernel/io_delay.c
--- a/arch/x86/kernel/io_delay.c~x86-add-io-delay-quirk-for-presario-f700
+++ a/arch/x86/kernel/io_delay.c
@@ -92,6 +92,14 @@ static struct dmi_system_id __initdata i
 			DMI_MATCH(DMI_BOARD_NAME, "30BF")
 		}
 	},
+	{
+		.callback	= dmi_io_delay_0xed_port,
+		.ident		= "Presario F700",
+		.matches	= {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Quanta"),
+			DMI_MATCH(DMI_BOARD_NAME, "30D3")
+		}
+	},
 	{ }
 };
 
_

Patches currently in -mm which might be from cebbert@redhat.com are

linux-next.patch
acpi-cope-with-pnpacpi-tables-missing-an-rtc-entry.patch
x86-add-io-delay-quirk-for-presario-f700.patch

