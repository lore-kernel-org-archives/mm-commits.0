From: akpm@linux-foundation.org
Subject: + toshica_acpi-fix-section-mismatch-in-allyesconfig.patch added to -mm tree
Date: Wed, 06 Jun 2007 18:58:26 -0700
Message-ID: <200706070158.l571wQro018351@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53727 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764962AbXFGB6w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 21:58:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     toshica_acpi: fix section mismatch in allyesconfig
has been added to the -mm tree.  Its filename is
     toshica_acpi-fix-section-mismatch-in-allyesconfig.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: toshica_acpi: fix section mismatch in allyesconfig
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section error (allyesconfig).  The exit function is called from init,
so functions that are called by the exit function cannot be marked __exit.

WARNING: drivers/built-in.o(.text+0xe5bc6): Section mismatch: reference to .exit.
text: (between 'toshiba_acpi_exit' and 'hci_raw')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/toshiba_acpi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/acpi/toshiba_acpi.c~toshica_acpi-fix-section-mismatch-in-allyesconfig drivers/acpi/toshiba_acpi.c
--- a/drivers/acpi/toshiba_acpi.c~toshica_acpi-fix-section-mismatch-in-allyesconfig
+++ a/drivers/acpi/toshiba_acpi.c
@@ -524,7 +524,7 @@ static acpi_status __init add_device(voi
 	return AE_OK;
 }
 
-static acpi_status __exit remove_device(void)
+static acpi_status remove_device(void)
 {
 	ProcItem *item;
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

mount-t-tmpfs-o-mpol=-check-nodes-online.patch
git-acpi.patch
toshica_acpi-fix-section-mismatch-in-allyesconfig.patch
romfs-printk-format-warnings.patch
mtd-use-null-for-pointer.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
add-pci_try_set_mwi-prism54pci.patch
git-ipwireless_cs.patch
x86_64-use-null-for-pointer.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
hexdump-more-output-formatting.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
kconfig-no-strange-misc-devices.patch
afs-drop-explicit-extern.patch
add-printktime-option-deprecate-time.patch
fs-clarify-dummy-member-in-struct.patch
sony-laptop-use-null-for-pointer.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
