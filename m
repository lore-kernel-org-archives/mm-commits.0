From: akpm@linux-foundation.org
Subject: + acpi-video-balcklist-fujitsu-lifebook-s6410.patch added to -mm tree
Date: Mon, 14 Apr 2008 14:52:01 -0700
Message-ID: <200804142152.m3ELq1KD028624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49998 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752373AbYDNVww (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Apr 2008 17:52:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nokos@gmx.net, lenb@kernel.org, robert.moore@intel.com, trenn@suse.de


The patch titled
     acpi video: balcklist Fujitsu Lifebook S6410
has been added to the -mm tree.  Its filename is
     acpi-video-balcklist-fujitsu-lifebook-s6410.patch

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
Subject: acpi video: balcklist Fujitsu Lifebook S6410
From: Peter Gruber <nokos@gmx.net>

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=10454

Cc: Len Brown <lenb@kernel.org>
Cc: "Moore, Robert" <robert.moore@intel.com>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/blacklist.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN drivers/acpi/blacklist.c~acpi-video-balcklist-fujitsu-lifebook-s6410 drivers/acpi/blacklist.c
--- a/drivers/acpi/blacklist.c~acpi-video-balcklist-fujitsu-lifebook-s6410
+++ a/drivers/acpi/blacklist.c
@@ -448,6 +448,14 @@ static struct dmi_system_id acpi_osi_dmi
 	 	     DMI_MATCH(DMI_PRODUCT_NAME, "ESPRIMO Mobile V5505"),
 		},
 	},
+	{
+	.callback = dmi_disable_osi_vista,
+	.ident = "Fujitsu Siemens",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU SIEMENS"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "LIFEBOOK S6410"),
+		},
+	},
 	/*
 	 * Disable OSI(Linux) warnings on all "Hewlett-Packard"
 	 *
_

Patches currently in -mm which might be from nokos@gmx.net are

acpi-video-balcklist-fujitsu-lifebook-s6410.patch

