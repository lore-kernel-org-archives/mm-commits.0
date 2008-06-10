From: akpm@linux-foundation.org
Subject: - acpi-video-balcklist-fujitsu-lifebook-s6410.patch removed from -mm tree
Date: Tue, 10 Jun 2008 10:37:34 -0700
Message-ID: <200806101737.m5AHbYsg021302@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbYFJRid (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jun 2008 13:38:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nokos@gmx.net, lenb@kernel.org, mjg59@srcf.ucam.org, robert.moore@intel.com, trenn@suse.de, mm-commits@vger.kernel.org


The patch titled
     acpi video: blacklist Fujitsu Lifebook S6410
has been removed from the -mm tree.  Its filename was
     acpi-video-balcklist-fujitsu-lifebook-s6410.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpi video: blacklist Fujitsu Lifebook S6410
From: Peter Gruber <nokos@gmx.net>

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=10454

On Thu, 1 May 2008 12:59:46 +0100 Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Thu, May 01, 2008 at 02:52:04AM -0700, akpm@linux-foundation.org wrote:
> 
> > Taken from http://bugzilla.kernel.org/show_bug.cgi?id=10454
> 
> Checking the bug, it seems like discussion is ongoing and a better 
> solution is possible - this seems to be a case of us differing in 
> behaviour from Vista, so we probably want to fix it up properly.
> 
> -- 
> Matthew Garrett | mjg59@srcf.ucam.org

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

