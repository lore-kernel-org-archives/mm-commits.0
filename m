From: akpm@linux-foundation.org
Subject: + acpi-compal-laptop-use-rfkill-switch-subsystem-fix.patch added to -mm tree
Date: Thu, 16 Oct 2008 15:32:42 -0700
Message-ID: <200810162232.m9GMWgBm031309@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755071AbYJPWdY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 18:33:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, cezary.jackiewicz@gmail.com


The patch titled
     compal-laptop: depends on RKFILL
has been added to the -mm tree.  Its filename is
     acpi-compal-laptop-use-rfkill-switch-subsystem-fix.patch

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
eeepc-laptop-use-standard-interfaces-fix.patch
dontdiff-more-updates-to-be-closer-to-gitignore.patch
documentation-explain-memory-barriers.patch
taint-fix-kernel-doc.patch
framebuffer-fix-carminefb-section-mismatch.patch
docbook-update-procfs-credits.patch
w1-documentation-w1-masters-ds2490-update.patch
configure-out-aio-support.patch
git-acpi.patch
mfd-ucb1400-sound-driver-uses-depends-on-ac97_bus.patch
fujitsu-laptop-fix-section-mismatch-warning.patch
acpi-compal-laptop-use-rfkill-switch-subsystem-fix.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
lkdtm-fix-for-config_scsi=n.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
memory_probe-fix-wrong-sysfs-file-attribute.patch
memory_probe-fix-wrong-sysfs-file-attribute-fix.patch
profile-likely-unlikely-macros.patch

