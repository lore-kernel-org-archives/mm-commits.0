From: akpm@linux-foundation.org
Subject: + fix-gregkh-driver-nozomi.patch added to -mm tree
Date: Tue, 26 Jun 2007 15:36:30 -0700
Message-ID: <200706262236.l5QMaUqM003802@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58340 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375AbXFZWgo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 18:36:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, greg@kroah.com


The patch titled
     nozomi: fix section when HOTPLUG=n
has been added to the -mm tree.  Its filename is
     fix-gregkh-driver-nozomi.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nozomi: fix section when HOTPLUG=n
From: Randy Dunlap <randy.dunlap@oracle.com>

When CONFIG_HOTPLUG=n, this function needs to be present instead of
discarded.

WARNING: drivers/built-in.o(.text+0x2045f): Section mismatch: reference to .exit.text:tty_exit (between 'nozomi_card_exit' and 'card_type_show')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/nozomi.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/nozomi.c~fix-gregkh-driver-nozomi drivers/char/nozomi.c
--- a/drivers/char/nozomi.c~fix-gregkh-driver-nozomi
+++ a/drivers/char/nozomi.c
@@ -1636,7 +1636,7 @@ exit:
 	up(&port->tty_sem);
 }
 
-static void __devexit tty_exit(void)
+static void tty_exit(void)
 {
 	struct nozomi *dc = my_dev;
 	int i, ret;
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
