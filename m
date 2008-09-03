From: akpm@linux-foundation.org
Subject: + x86-add-io-delay-quirk-for-presario-f700.patch added to -mm tree
Date: Wed, 03 Sep 2008 16:45:17 -0700
Message-ID: <200809032345.m83NjTuE010391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39717 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756316AbYICXpq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2008 19:45:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cebbert@redhat.com


The patch titled
     x86: add io delay quirk for Presario F700
has been added to the -mm tree.  Its filename is
     x86-add-io-delay-quirk-for-presario-f700.patch

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
x86-add-io-delay-quirk-for-presario-f700.patch

