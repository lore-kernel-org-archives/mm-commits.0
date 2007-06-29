From: akpm@linux-foundation.org
Subject: - mtd-use-null-for-pointer.patch removed from -mm tree
Date: Fri, 29 Jun 2007 13:41:33 -0700
Message-ID: <200706292041.l5TKfXFB022584@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56578 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754848AbXF2UtU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jun 2007 16:49:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     MTD: use NULL for pointer
has been removed from the -mm tree.  Its filename was
     mtd-use-null-for-pointer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
