From: akpm@linux-foundation.org
Subject: + mtd-use-null-for-pointer.patch added to -mm tree
Date: Wed, 06 Jun 2007 00:00:31 -0700
Message-ID: <200706060700.l5670VAI011415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43472 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757569AbXFFHAk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 03:00:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     MTD: use NULL for pointer
has been added to the -mm tree.  Its filename is
     mtd-use-null-for-pointer.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: MTD: use NULL for pointer
From: Randy Dunlap <randy.dunlap@oracle.com>

Use NULL instead of 0 for pointer:
drivers/mtd/chips/cfi_cmdset_0001.c:2258:43: warning: Using plain integer as NULL pointer

Other changes by inspection.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/chips/cfi_cmdset_0001.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/mtd/chips/cfi_cmdset_0001.c~mtd-use-null-for-pointer drivers/mtd/chips/cfi_cmdset_0001.c
--- a/drivers/mtd/chips/cfi_cmdset_0001.c~mtd-use-null-for-pointer
+++ a/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -1930,7 +1930,7 @@ static int cfi_intelext_lock(struct mtd_
 	printk(KERN_DEBUG "%s: lock status before, ofs=0x%08llx, len=0x%08X\n",
 	       __FUNCTION__, ofs, len);
 	cfi_varsize_frob(mtd, do_printlockstatus_oneblock,
-		ofs, len, 0);
+		ofs, len, NULL);
 #endif
 
 	ret = cfi_varsize_frob(mtd, do_xxlock_oneblock,
@@ -1940,7 +1940,7 @@ static int cfi_intelext_lock(struct mtd_
 	printk(KERN_DEBUG "%s: lock status after, ret=%d\n",
 	       __FUNCTION__, ret);
 	cfi_varsize_frob(mtd, do_printlockstatus_oneblock,
-		ofs, len, 0);
+		ofs, len, NULL);
 #endif
 
 	return ret;
@@ -1954,7 +1954,7 @@ static int cfi_intelext_unlock(struct mt
 	printk(KERN_DEBUG "%s: lock status before, ofs=0x%08llx, len=0x%08X\n",
 	       __FUNCTION__, ofs, len);
 	cfi_varsize_frob(mtd, do_printlockstatus_oneblock,
-		ofs, len, 0);
+		ofs, len, NULL);
 #endif
 
 	ret = cfi_varsize_frob(mtd, do_xxlock_oneblock,
@@ -1964,7 +1964,7 @@ static int cfi_intelext_unlock(struct mt
 	printk(KERN_DEBUG "%s: lock status after, ret=%d\n",
 	       __FUNCTION__, ret);
 	cfi_varsize_frob(mtd, do_printlockstatus_oneblock,
-		ofs, len, 0);
+		ofs, len, NULL);
 #endif
 
 	return ret;
@@ -2255,7 +2255,7 @@ static void cfi_intelext_save_locks(stru
 			adr = region->offset + block * len;
 
 			status = cfi_varsize_frob(mtd,
-					do_getlockstatus_oneblock, adr, len, 0);
+				do_getlockstatus_oneblock, adr, len, NULL);
 			if (status)
 				set_bit(block, region->lockmap);
 			else
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

mount-t-tmpfs-o-mpol=-check-nodes-online.patch
git-acpi.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
add-pci_try_set_mwi-prism54pci.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
hexdump-more-output-formatting.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
kconfig-no-strange-misc-devices.patch
afs-drop-explicit-extern.patch
add-printktime-option-deprecate-time.patch
fs-clarify-dummy-member-in-struct.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
x86_64-use-null-for-pointer.patch
sony-laptop-use-null-for-pointer.patch
mtd-use-null-for-pointer.patch
