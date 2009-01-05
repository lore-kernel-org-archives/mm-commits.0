From: akpm@linux-foundation.org
Subject: - i8k-add-support-for-dell-xps-m1530.patch removed from -mm tree
Date: Sun, 04 Jan 2009 22:41:46 -0800
Message-ID: <200901050641.n056fkQX005774@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751362AbZAEGl7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Jan 2009 01:41:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrew@ishiboo.com, dtor@mail.ru, dz@debian.org, mm-commits@vger.kernel.org


The patch titled
     i8k: add support for Dell XPS M1530
has been removed from the -mm tree.  Its filename was
     i8k-add-support-for-dell-xps-m1530.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: i8k: add support for Dell XPS M1530
From: "Andrew Paprocki" <andrew@ishiboo.com>

I see two problems with the i8k module and the Dell XPS M1530.  First, the
laptop is not detected.  Second, even if it is detected, the module prints
that it is unable to get the SMM BIOS version even though the module
appears to be working:

# modprobe i8k force=1
# dmesg | grep i8k
[  547.007217] i8k: not running on a supported Dell system.
[  547.007234] i8k: vendor=Dell Inc., model=XPS M1530
     , version=A08
[  547.007629] i8k: unable to get SMM BIOS version
# cat /proc/i8k
1.0 A08 5D26YF1 53 0 0 0 0 -1 -22

Information from DMI:

BIOS Information
        Vendor: Dell Inc.
        Version: A08
        Release Date: 03/19/2008

System Information
        Manufacturer: Dell Inc.
        Product Name: XPS M1530

It seems straightforward to add a record for the auto-detection, but I'm
not sure how generic it should be.  From looking online, it appears the
M1330, M1530, and M1730 all need to be detected.  Perhaps it should just
be "Dell XPS M Series" and only match on "XPS M"?

Cc: Massimo Dal Zotto <dz@debian.org>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/i8k.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/char/i8k.c~i8k-add-support-for-dell-xps-m1530 drivers/char/i8k.c
--- a/drivers/char/i8k.c~i8k-add-support-for-dell-xps-m1530
+++ a/drivers/char/i8k.c
@@ -499,6 +499,13 @@ static struct dmi_system_id __initdata i
 			DMI_MATCH(DMI_PRODUCT_NAME, "Precision"),
 		},
 	},
+	{
+		.ident = "Dell XPS M1530",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "XPS M1530"),
+		},
+	},
 	{ }
 };
 
_

Patches currently in -mm which might be from andrew@ishiboo.com are


