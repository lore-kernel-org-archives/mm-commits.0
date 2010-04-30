From: akpm@linux-foundation.org
Subject: + acpi-sleep-init_set_sci_en_on_resume-for-dell-studio-155x.patch added to -mm tree
Date: Fri, 30 Apr 2010 14:05:22 -0700
Message-ID: <201004302105.o3UL5Mt4013457@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756650Ab0D3VF2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Apr 2010 17:05:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamal@canonical.com, achiang@canonical.com, lenb@kernel.org, stable@kernel.org


The patch titled
     acpi: sleep: init_set_sci_en_on_resume for Dell Studio 155x
has been added to the -mm tree.  Its filename is
     acpi-sleep-init_set_sci_en_on_resume-for-dell-studio-155x.patch

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
Subject: acpi: sleep: init_set_sci_en_on_resume for Dell Studio 155x
From: Kamal Mostafa <kamal@canonical.com>

Add Dell Studio models (1558, 1557, 1555) to the 'set_sci_en_on_resume'
list to fix hang on resume.

Addresses http://bugs.launchpad.net/bugs/553498

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Acked-by: Alex Chiang <achiang@canonical.com>
Cc: Len Brown <lenb@kernel.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/sleep.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN drivers/acpi/sleep.c~acpi-sleep-init_set_sci_en_on_resume-for-dell-studio-155x drivers/acpi/sleep.c
--- a/drivers/acpi/sleep.c~acpi-sleep-init_set_sci_en_on_resume-for-dell-studio-155x
+++ a/drivers/acpi/sleep.c
@@ -468,6 +468,30 @@ static struct dmi_system_id __initdata a
 		DMI_MATCH(DMI_BOARD_NAME, "CF51-2L"),
 		},
 	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Dell Studio 1558",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Studio 1558"),
+		},
+	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Dell Studio 1557",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Studio 1557"),
+		},
+	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Dell Studio 1555",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Studio 1555"),
+		},
+	},
 	{},
 };
 #endif /* CONFIG_SUSPEND */
_

Patches currently in -mm which might be from kamal@canonical.com are

acpi-sleep-init_set_sci_en_on_resume-for-dell-studio-155x.patch

