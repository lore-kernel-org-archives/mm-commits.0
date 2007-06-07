From: akpm@linux-foundation.org
Subject: + isdn-diva-fix-section-mismatch.patch added to -mm tree
Date: Wed, 06 Jun 2007 18:59:30 -0700
Message-ID: <200706070159.l571xUdO018356@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53417 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764962AbXFGB7s (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 21:59:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, kkeil@suse.de


The patch titled
     isdn/diva: fix section mismatch
has been added to the -mm tree.  Its filename is
     isdn-diva-fix-section-mismatch.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: isdn/diva: fix section mismatch
From: Randy Dunlap <randy.dunlap@oracle.com>

__exit function is used by both init and exit routines, so it cannot
be marked __init.  (from allyesconfig)

WARNING: drivers/built-in.o(.text+0x9b83cf): Section mismatch: reference to .exit.text: (between 'divasfunc_exit' and 'didd_callback')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hardware/eicon/divasfunc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/isdn/hardware/eicon/divasfunc.c~isdn-diva-fix-section-mismatch drivers/isdn/hardware/eicon/divasfunc.c
--- a/drivers/isdn/hardware/eicon/divasfunc.c~isdn-diva-fix-section-mismatch
+++ a/drivers/isdn/hardware/eicon/divasfunc.c
@@ -195,7 +195,7 @@ static int DIVA_INIT_FUNCTION connect_di
 /*
  * disconnect from didd
  */
-static void DIVA_EXIT_FUNCTION disconnect_didd(void)
+static void disconnect_didd(void)
 {
 	IDI_SYNC_REQ req;
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

mount-t-tmpfs-o-mpol=-check-nodes-online.patch
isdn-diva-fix-section-mismatch.patch
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
