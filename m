From: akpm@linux-foundation.org
Subject: - alsa-fix-section-mismatch.patch removed from -mm tree
Date: Tue, 26 Jun 2007 21:53:59 -0700
Message-ID: <200706270453.l5R4rxYD010143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50201 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752335AbXF0EyO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jun 2007 00:54:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, perex@suse.cz, tiwai@suse.de, mm-commits@vger.kernel.org


The patch titled
     ALSA: fix section mismatch
has been removed from the -mm tree.  Its filename was
     alsa-fix-section-mismatch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ALSA: fix section mismatch
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix shared init/exit function attributes:
WARNING: sound/built-in.o(.exit.text+0x4a1): Section mismatch: reference to .init.text: (between 'alsa_card_virmidi_exit' and 'alsa_card_serial_exit')
WARNING: sound/built-in.o(.exit.text+0x4c1): Section mismatch: reference to .init.text: (between 'alsa_card_serial_exit' and 'ac97_bus_exit')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/drivers/serial-u16550.c |    2 +-
 sound/drivers/virmidi.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN sound/drivers/serial-u16550.c~alsa-fix-section-mismatch sound/drivers/serial-u16550.c
--- a/sound/drivers/serial-u16550.c~alsa-fix-section-mismatch
+++ a/sound/drivers/serial-u16550.c
@@ -998,7 +998,7 @@ static struct platform_driver snd_serial
 	},
 };
 
-static void __init_or_module snd_serial_unregister_all(void)
+static void snd_serial_unregister_all(void)
 {
 	int i;
 
diff -puN sound/drivers/virmidi.c~alsa-fix-section-mismatch sound/drivers/virmidi.c
--- a/sound/drivers/virmidi.c~alsa-fix-section-mismatch
+++ a/sound/drivers/virmidi.c
@@ -145,7 +145,7 @@ static struct platform_driver snd_virmid
 	},
 };
 
-static void __init_or_module snd_virmidi_unregister_all(void)
+static void snd_virmidi_unregister_all(void)
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
git-alsa.patch
alsa-portman2x4-section-mismatch.patch
fix-gregkh-driver-nozomi.patch
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
schedstats-fix-printk-format.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
