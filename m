From: akpm@linux-foundation.org
Subject: + alsa-more-section-mismatches.patch added to -mm tree
Date: Thu, 28 Jun 2007 15:40:10 -0700
Message-ID: <200706282240.l5SMeAqH003142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41820 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932237AbXF1WkY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Jun 2007 18:40:24 -0400
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

Fix section mismatch warnings:

WARNING: sound/built-in.o(.exit.text+0x3ad): Section mismatch: reference to .init.text: (between 'sb_exit' and 'unload_uart6850')
WARNING: sound/built-in.o(.exit.text+0x753): Section mismatch: reference to .init.text: (between 'snd_mts64_module_exit' and 'snd_portman_module_exit')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/drivers/mts64.c |    2 +-
 sound/oss/sb_card.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN sound/drivers/mts64.c~alsa-more-section-mismatches sound/drivers/mts64.c
--- a/sound/drivers/mts64.c~alsa-more-section-mismatches
+++ a/sound/drivers/mts64.c
@@ -1048,7 +1048,7 @@ static struct platform_driver snd_mts64_
 /*********************************************************************
  * module init stuff
  *********************************************************************/
-static void __init_or_module snd_mts64_unregister_all(void)
+static void snd_mts64_unregister_all(void)
 {
 	int i;
 
diff -puN sound/oss/sb_card.c~alsa-more-section-mismatches sound/oss/sb_card.c
--- a/sound/oss/sb_card.c~alsa-more-section-mismatches
+++ a/sound/oss/sb_card.c
@@ -290,7 +290,7 @@ static struct pnp_card_driver sb_pnp_dri
 MODULE_DEVICE_TABLE(pnp_card, sb_pnp_card_table);
 #endif /* CONFIG_PNP */
 
-static void __init_or_module sb_unregister_all(void)
+static void sb_unregister_all(void)
 {
 #ifdef CONFIG_PNP
 	if (pnp_registered)
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

eventfd-clean-compile-when-config_eventfd=n.patch
mtrr-cyrix-fix-sections.patch
ioatdma-fix-section-mismatches.patch
alsa-fix-ice1712-section-mismatch.patch
alsa-use-__devexit_p.patch
alsa-more-section-mismatches.patch
git-acpi.patch
git-alsa.patch
fix-gregkh-driver-nozomi.patch
git-libata-all.patch
romfs-printk-format-warnings.patch
mtd-use-null-for-pointer.patch
ubi-one-less-bug-usage.patch
add-pci_try_set_mwi.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
irda-fix-printk-format.patch
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
doc-oops-tracing-add-code-decode-info-fix.patch
schedstats-fix-printk-format.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
