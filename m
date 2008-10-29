From: akpm@linux-foundation.org
Subject: - acpi-compal-laptop-use-rfkill-switch-subsystem-fix.patch removed from -mm tree
Date: Wed, 29 Oct 2008 14:12:40 -0700
Message-ID: <200810292112.m9TLCeDB016356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751119AbYJ2VMr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Oct 2008 17:12:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, cezary.jackiewicz@gmail.com, mm-commits@vger.kernel.org


The patch titled
     compal-laptop: depends on RKFILL
has been removed from the -mm tree.  Its filename was
     acpi-compal-laptop-use-rfkill-switch-subsystem-fix.patch

This patch was dropped because it was folded into acpi-compal-laptop-use-rfkill-switch-subsystem.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: compal-laptop: depends on RKFILL
From: Randy Dunlap <randy.dunlap@oracle.com>

compal-laptop uses rfkill_*() so needs to depend on RFKILL
(or select it).

drivers/built-in.o: In function `compal_rfkill':
compal-laptop.c:(.init.text+0x9ac3): undefined reference to `rfkill_allocate'
compal-laptop.c:(.init.text+0x9afa): undefined reference to `rfkill_register'
compal-laptop.c:(.init.text+0x9b17): undefined reference to `rfkill_free'
drivers/built-in.o: In function `compal_cleanup':
compal-laptop.c:(.exit.text+0x912): undefined reference to `rfkill_unregister'
compal-laptop.c:(.exit.text+0x92a): undefined reference to `rfkill_unregister'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/misc/Kconfig~acpi-compal-laptop-use-rfkill-switch-subsystem-fix drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~acpi-compal-laptop-use-rfkill-switch-subsystem-fix
+++ a/drivers/misc/Kconfig
@@ -263,6 +263,7 @@ config COMPAL_LAPTOP
 	depends on X86
 	depends on ACPI_EC
 	depends on BACKLIGHT_CLASS_DEVICE
+	depends on RFKILL
 	---help---
 	  This is a driver for laptops built by Compal:
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
docbook-fix-command-spacing.patch
docs-fix-managementstyle-book-name.patch
i2o-fix-kernel-doc-warnings.patch
mm-fix-kernel-doc-function-notation.patch
fs-remove-excess-kernel-doc.patch
kernelh-fix-might_sleep-kernel-doc.patch
linux-next.patch
fujitsu-laptop-fix-section-mismatch-warning.patch
acpi-compal-laptop-use-rfkill-switch-subsystem.patch
acpi-compal-laptop-use-rfkill-switch-subsystem-fix.patch
kgdb-fix-kernel-doc-error.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
scsi-ioctl-fix-kernel-doc-warning.patch
block-remove-excess-kernel-doc.patch
fs-fix-inodec-kernel-doc-warnings.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
profile-likely-unlikely-macros.patch

