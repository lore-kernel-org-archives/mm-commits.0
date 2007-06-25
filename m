From: akpm@linux-foundation.org
Subject: + alsa-use-__devexit_p.patch added to -mm tree
Date: Mon, 25 Jun 2007 16:27:21 -0700
Message-ID: <200706252327.l5PNRLIZ013767@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53351 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751987AbXFYX1g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 19:27:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, perex@suse.cz, tiwai@suse.de


The patch titled
     ALSA: use __devexit_p
has been added to the -mm tree.  Its filename is
     alsa-use-__devexit_p.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ALSA: use __devexit_p
From: Randy Dunlap <randy.dunlap@oracle.com>

Change __devexit to __devexit_p:
sound/isa/opl3sa2.c:956: error: expected expression before '__attribute__'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jaroslav Kysela <perex@suse.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 sound/isa/opl3sa2.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN sound/isa/opl3sa2.c~alsa-use-__devexit_p sound/isa/opl3sa2.c
--- a/sound/isa/opl3sa2.c~alsa-use-__devexit_p
+++ a/sound/isa/opl3sa2.c
@@ -953,7 +953,7 @@ static int snd_opl3sa2_isa_resume(struct
 static struct isa_driver snd_opl3sa2_isa_driver = {
 	.match		= snd_opl3sa2_isa_match,
 	.probe		= snd_opl3sa2_isa_probe,
-	.remove		= __devexit( snd_opl3sa2_isa_remove),
+	.remove		= __devexit_p(snd_opl3sa2_isa_remove),
 #ifdef CONFIG_PM
 	.suspend	= snd_opl3sa2_isa_suspend,
 	.resume		= snd_opl3sa2_isa_resume,
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
