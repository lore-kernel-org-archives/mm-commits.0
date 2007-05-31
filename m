From: akpm@linux-foundation.org
Subject: + acpi-fix-section-mismatch-warning-in-asus-toshiba.patch added to -mm tree
Date: Thu, 31 May 2007 16:39:50 -0700
Message-ID: <200705312339.l4VNdop9030868@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54528 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753218AbXEaXkc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 May 2007 19:40:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, lenb@kernel.org


The patch titled
     acpi: fix section mismatch warning in asus + toshiba
has been added to the -mm tree.  Its filename is
     acpi-fix-section-mismatch-warning-in-asus-toshiba.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: acpi: fix section mismatch warning in asus + toshiba
From: Sam Ravnborg <sam@ravnborg.org>

Fix following section mismatch warnings in acpi

WARNING: drivers/acpi/asus_acpi.o(.init.text+0xb7): Section mismatch: reference to .exit.text: (after 'init_module')
WARNING: o-i386/drivers/acpi/toshiba_acpi.o(.init.text+0x13a): Section mismatch: reference to .exit.text: (after 'init_module')

The exit function is used in the init function during an error codition.
As __exit may be discarded during link-time / run-time this is no good.
Do not mark the exit function __exit.

Note: This warning is only seen by my local copy of modpost
      but the change will soon hit upstream.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/asus_acpi.c    |    2 +-
 drivers/acpi/toshiba_acpi.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/asus_acpi.c~acpi-fix-section-mismatch-warning-in-asus-toshiba drivers/acpi/asus_acpi.c
--- a/drivers/acpi/asus_acpi.c~acpi-fix-section-mismatch-warning-in-asus-toshiba
+++ a/drivers/acpi/asus_acpi.c
@@ -1357,7 +1357,7 @@ static struct backlight_ops asus_backlig
         .update_status  = set_brightness_status,
 };
 
-static void __exit asus_acpi_exit(void)
+static void asus_acpi_exit(void)
 {
 	if (asus_backlight_device)
 		backlight_device_unregister(asus_backlight_device);
diff -puN drivers/acpi/toshiba_acpi.c~acpi-fix-section-mismatch-warning-in-asus-toshiba drivers/acpi/toshiba_acpi.c
--- a/drivers/acpi/toshiba_acpi.c~acpi-fix-section-mismatch-warning-in-asus-toshiba
+++ a/drivers/acpi/toshiba_acpi.c
@@ -538,7 +538,7 @@ static struct backlight_ops toshiba_back
         .update_status  = set_lcd_status,
 };
 
-static void __exit toshiba_acpi_exit(void)
+static void toshiba_acpi_exit(void)
 {
 	if (toshiba_backlight_device)
 		backlight_device_unregister(toshiba_backlight_device);
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
git-kbuild.patch
use-posix-bre-in-headers-install-target.patch
fix-x86_64-mm-xen-core-xen-implementation.patch
x86-fix-section-mismatch-warnings-in-mtrr.patch
git-newsetup.patch
net-hp100-fix-section-mismatch-warning.patch
kvm-fix-section-mismatch-warning-in-kvm-intelo.patch
acpi-fix-section-mismatch-warning-in-asus-toshiba.patch
