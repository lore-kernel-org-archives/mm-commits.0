From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-setupcl-phoenix-bios-fixup-is-needed-on-dell-inspiron-mini-1012.patch added to -mm tree
Date: Thu, 01 Apr 2010 16:17:15 -0700
Message-ID: <201004012317.o31NHFDp014965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498Ab0DAXRW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Apr 2010 19:17:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gombasg@digikabel.hu


The patch titled
     arch/x86/kernel/setup.cL: Phoenix BIOS fixup is needed on Dell Inspiron Mini 1012
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-setupcl-phoenix-bios-fixup-is-needed-on-dell-inspiron-mini-1012.patch

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
Subject: arch/x86/kernel/setup.cL: Phoenix BIOS fixup is needed on Dell Inspiron Mini 1012
From: Gabor Gombas <gombasg@digikabel.hu>

The low-memory corruption checker triggers during suspend/resume, so we
need to reserve the low 64k.  Don't be fooled that the BIOS identifies
itself as "Dell Inc.", it's still Phoenix BIOS.

Signed-off-by: Gabor Gombas <gombasg@digikabel.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/setup.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN arch/x86/kernel/setup.c~arch-x86-kernel-setupcl-phoenix-bios-fixup-is-needed-on-dell-inspiron-mini-1012 arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~arch-x86-kernel-setupcl-phoenix-bios-fixup-is-needed-on-dell-inspiron-mini-1012
+++ a/arch/x86/kernel/setup.c
@@ -666,6 +666,17 @@ static struct dmi_system_id __initdata b
 			DMI_MATCH(DMI_BOARD_NAME, "DG45FC"),
 		},
 	},
+	/*
+	 * The Dell Inspiron Mini 1012 has DMI_BIOS_VENDOR = "Dell Inc.", so
+	 * match on the product name.
+	 */
+	{
+		.callback = dmi_low_memory_corruption,
+		.ident = "Phoenix BIOS",
+		.matches = {
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1012"),
+		},
+	},
 #endif
 	{}
 };
_

Patches currently in -mm which might be from gombasg@digikabel.hu are

arch-x86-kernel-setupcl-phoenix-bios-fixup-is-needed-on-dell-inspiron-mini-1012.patch

