From: akpm@linux-foundation.org
Subject: + alsa-more-section-mismatches.patch added to -mm tree
Date: Mon, 25 Jun 2007 16:27:25 -0700
Message-ID: <200706252327.l5PNRPVN013773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49839 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752324AbXFYX1k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 19:27:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, perex@suse.cz, tiwai@suse.de


The patch titled
     ALSA: more section mismatches
has been added to the -mm tree.  Its filename is
     alsa-more-section-mismatches.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ALSA: more section mismatches
From: Randy Dunlap <randy.dunlap@oracle.com>

Something about __init_or_module isn't working as expected (?).
CONFIG_HOTPLUG=y
CONFIG_MODULES=n

Fix shared init/exit code helper:
WARNING: sound/built-in.o(.exit.text+0x243): Section mismatch: reference to .init.text: (between 'alsa_card_mpu401_exit' and 'ac97_bus_exit')
WARNING: sound/built-in.o(.exit.text+0x21b): Section mismatch: reference to .init.text: (between 'alsa_card_dummy_exit' and 'alsa_card_serial_exit')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/drivers/dummy.c         |    2 +-
 sound/drivers/mpu401/mpu401.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN sound/drivers/dummy.c~alsa-more-section-mismatches sound/drivers/dummy.c
--- a/sound/drivers/dummy.c~alsa-more-section-mismatches
+++ a/sound/drivers/dummy.c
@@ -659,7 +659,7 @@ static struct platform_driver snd_dummy_
 	},
 };
 
-static void __init_or_module snd_dummy_unregister_all(void)
+static void snd_dummy_unregister_all(void)
 {
 	int i;
 
diff -puN sound/drivers/mpu401/mpu401.c~alsa-more-section-mismatches sound/drivers/mpu401/mpu401.c
--- a/sound/drivers/mpu401/mpu401.c~alsa-more-section-mismatches
+++ a/sound/drivers/mpu401/mpu401.c
@@ -228,7 +228,7 @@ static struct pnp_driver snd_mpu401_pnp_
 static struct pnp_driver snd_mpu401_pnp_driver;
 #endif
 
-static void __init_or_module snd_mpu401_unregister_all(void)
+static void snd_mpu401_unregister_all(void)
 {
 	int i;
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

eventfd-clean-compile-when-config_eventfd=n.patch
mtrr-cyrix-fix-sections.patch
ioatdma-fix-section-mismatches.patch
git-acpi.patch
alsa-use-__devexit_p.patch
alsa-fix-section-mismatch.patch
alsa-more-section-mismatches.patch
romfs-printk-format-warnings.patch
mtd-use-null-for-pointer.patch
add-pci_try_set_mwi.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
kconfig-no-strange-misc-devices.patch
afs-drop-explicit-extern.patch
add-printktime-option-deprecate-time.patch
fs-clarify-dummy-member-in-struct.patch
sony-laptop-use-null-for-pointer.patch
hugetlbfs-use-lib-parser-fix-docs.patch
report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
doc-oops-tracing-add-code-decode-info.patch
schedstats-fix-printk-format.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
