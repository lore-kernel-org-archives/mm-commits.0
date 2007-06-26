From: akpm@linux-foundation.org
Subject: + alsa-portman2x4-section-mismatch.patch added to -mm tree
Date: Tue, 26 Jun 2007 15:37:16 -0700
Message-ID: <200706262237.l5QMbGhK003832@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53691 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751433AbXFZWhc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 18:37:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, perex@suse.cz, tiwai@suse.de


The patch titled
     ALSA portman2x4 section mismatch
has been added to the -mm tree.  Its filename is
     alsa-portman2x4-section-mismatch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ALSA portman2x4 section mismatch
From: Randy Dunlap <randy.dunlap@oracle.com>

FIx section mismatch when CONFIG_HOTPLUG=n:

WARNING: sound/built-in.o(.exit.text+0x271): Section mismatch: reference to .init.text:snd_p
ortman_unregister_all (between 'snd_portman_module_exit' and 'alsa_mpu401_uart_exit')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/drivers/portman2x4.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN sound/drivers/portman2x4.c~alsa-portman2x4-section-mismatch sound/drivers/portman2x4.c
--- a/sound/drivers/portman2x4.c~alsa-portman2x4-section-mismatch
+++ a/sound/drivers/portman2x4.c
@@ -833,7 +833,7 @@ static struct platform_driver snd_portma
 /*********************************************************************
  * module init stuff
  *********************************************************************/
-static void __init_or_module snd_portman_unregister_all(void)
+static void snd_portman_unregister_all(void)
 {
 	int i;
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

eventfd-clean-compile-when-config_eventfd=n.patch
mtrr-cyrix-fix-sections.patch
ioatdma-fix-section-mismatches.patch
alsa-fix-ice1712-section-mismatch.patch
alsa-use-__devexit_p.patch
git-acpi.patch
alsa-fix-section-mismatch.patch
alsa-more-section-mismatches.patch
alsa-portman2x4-section-mismatch.patch
fix-gregkh-driver-nozomi.patch
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
