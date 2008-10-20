From: akpm@linux-foundation.org
Subject: + panasonic-laptop-depends-on-acpi.patch added to -mm tree
Date: Mon, 20 Oct 2008 16:24:23 -0700
Message-ID: <200810202324.m9KNONr2009525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47402 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751873AbYJTXYq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 19:24:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, laforge@gnumonks.org, lenb@kernel.org


The patch titled
     panasonic-laptop: depends on ACPI
has been added to the -mm tree.  Its filename is
     panasonic-laptop-depends-on-acpi.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: panasonic-laptop: depends on ACPI
From: Randy Dunlap <randy.dunlap@oracle.com>

panasonic-laptop uses many acpi_*() functions so it should depend on ACPI;
otherwise there are approximately 70 warnings/errors generated.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Harald Welte <laforge@gnumonks.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/misc/Kconfig~panasonic-laptop-depends-on-acpi drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~panasonic-laptop-depends-on-acpi
+++ a/drivers/misc/Kconfig
@@ -249,7 +249,7 @@ config MSI_LAPTOP
 
 config PANASONIC_LAPTOP
 	tristate "Panasonic Laptop Extras"
-	depends on X86 && INPUT
+	depends on X86 && INPUT && ACPI
         depends on BACKLIGHT_CLASS_DEVICE
 	---help---
 	  This driver adds support for access to backlight control and hotkeys
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
fujitsu-laptop-fix-section-mismatch-warning.patch
acpi-compal-laptop-use-rfkill-switch-subsystem-fix.patch
panasonic-laptop-depends-on-acpi.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
profile-likely-unlikely-macros.patch

