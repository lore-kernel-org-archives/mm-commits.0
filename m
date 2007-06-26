From: akpm@linux-foundation.org
Subject: + ubi-one-less-bug-usage.patch added to -mm tree
Date: Tue, 26 Jun 2007 15:38:16 -0700
Message-ID: <200706262238.l5QMcGER003854@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54305 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114AbXFZWiZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Jun 2007 18:38:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     UBI: one less BUG usage
has been added to the -mm tree.  Its filename is
     ubi-one-less-bug-usage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: UBI: one less BUG usage
From: Randy Dunlap <randy.dunlap@oracle.com>

Eliminate one BUG() usage.  The callers of major_to_device() already handle
and report errors.  This is just another error to return.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/ubi/cdev.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/mtd/ubi/cdev.c~ubi-one-less-bug-usage drivers/mtd/ubi/cdev.c
--- a/drivers/mtd/ubi/cdev.c~ubi-one-less-bug-usage
+++ a/drivers/mtd/ubi/cdev.c
@@ -63,7 +63,7 @@ static struct ubi_device *major_to_devic
 	for (i = 0; i < ubi_devices_cnt; i++)
 		if (ubi_devices[i] && ubi_devices[i]->major == major)
 			return ubi_devices[i];
-	BUG();
+	return ERR_PTR(-ENODEV);
 }
 
 /**
@@ -127,6 +127,9 @@ static int vol_cdev_open(struct inode *i
 	int vol_id = iminor(inode) - 1;
 	int mode;
 
+	if (IS_ERR(ubi))
+		return PTR_ERR(ubi);
+
 	if (file->f_mode & FMODE_WRITE)
 		mode = UBI_READWRITE;
 	else
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
ubi-one-less-bug-usage.patch
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
