From: akpm@linux-foundation.org
Subject: - romfs-printk-format-warnings.patch removed from -mm tree
Date: Wed, 11 Jul 2007 10:17:07 -0700
Message-ID: <200707111717.l6BHH78w003089@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34475 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765529AbXGKRRg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Jul 2007 13:17:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ROMFS: printk format warnings
has been removed from the -mm tree.  Its filename was
     romfs-printk-format-warnings.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: ROMFS: printk format warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Field width and precision must be of type int.
fs/romfs/super.c:513: warning: field width should have type 'int', but argument 2 has type 'size_t'
fs/romfs/super.c:513: warning: field precision should have type 'int', but argument 3 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/super.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/romfs/super.c~romfs-printk-format-warnings fs/romfs/super.c
--- a/fs/romfs/super.c~romfs-printk-format-warnings
+++ a/fs/romfs/super.c
@@ -510,7 +510,7 @@ static int romfs_fill_super(struct super
 	len = strnlen(rsb->name, ROMFS_MAXFN);
 	if (!silent)
 		printk("ROMFS: Mounting image '%*.*s' through %s\n",
-		       len, len, rsb->name, storage);
+		       (int)len, (int)len, rsb->name, storage);
 
 	kfree(rsb);
 	rsb = NULL;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

git-acpi.patch
git-alsa.patch
git-mtd.patch
romfs-printk-format-warnings.patch
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
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
profile-likely-unlikely-macros.patch
