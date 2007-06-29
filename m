From: akpm@linux-foundation.org
Subject: - fix-gregkh-driver-nozomi.patch removed from -mm tree
Date: Fri, 29 Jun 2007 13:41:20 -0700
Message-ID: <200706292041.l5TKfKfL022569@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42436 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754973AbXF2Uuf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jun 2007 16:50:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     nozomi: fix section when HOTPLUG=n
has been removed from the -mm tree.  Its filename was
     fix-gregkh-driver-nozomi.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
alsa-more-section-mismatches.patch
pcih-stubs-for-edd-build-error.patch
git-acpi.patch
git-alsa.patch
git-mtd.patch
romfs-printk-format-warnings.patch
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
