From: akpm@linux-foundation.org
Subject: + ntfs-dont-fool-kernel-doc.patch added to -mm tree
Date: Mon, 24 Nov 2008 13:25:29 -0800
Message-ID: <200811242125.mAOLPTnh024637@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44697 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362AbYKXVZo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 24 Nov 2008 16:25:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, aia21@cantab.net


The patch titled
     ntfs: don't fool kernel-doc
has been added to the -mm tree.  Its filename is
     ntfs-dont-fool-kernel-doc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntfs: don't fool kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

kernel-doc handles macros now (it has for quite some time), so change the
ntfs_debug() macro's kernel-doc to be just before the macro instead of
before a phony function prototype.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Anton Altaparmakov <aia21@cantab.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs/debug.h |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff -puN fs/ntfs/debug.h~ntfs-dont-fool-kernel-doc fs/ntfs/debug.h
--- a/fs/ntfs/debug.h~ntfs-dont-fool-kernel-doc
+++ a/fs/ntfs/debug.h
@@ -30,7 +30,8 @@
 
 extern int debug_msgs;
 
-#if 0 /* Fool kernel-doc since it doesn't do macros yet */
+extern void __ntfs_debug (const char *file, int line, const char *function,
+	const char *format, ...) __attribute__ ((format (printf, 4, 5)));
 /**
  * ntfs_debug - write a debug level message to syslog
  * @f:		a printf format string containing the message
@@ -39,11 +40,6 @@ extern int debug_msgs;
  * ntfs_debug() writes a DEBUG level message to the syslog but only if the
  * driver was compiled with -DDEBUG. Otherwise, the call turns into a NOP.
  */
-static void ntfs_debug(const char *f, ...);
-#endif
-
-extern void __ntfs_debug (const char *file, int line, const char *function,
-	const char *format, ...) __attribute__ ((format (printf, 4, 5)));
 #define ntfs_debug(f, a...)						\
 	__ntfs_debug(__FILE__, __LINE__, __func__, f, ##a)
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
kgdb-fix-kernel-doc-error.patch
arm-fix-kernel-doc-syntax.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
scripts-extract-ikconfig-remove-bashisms.patch
drivers-ata-pata_radisysc-cleanup-kernel-doc.patch
drivers-ata-libata-corec-cleanup-kernel-doc.patch
drivers-ata-pata_oldpiixc-cleanup-kernel-doc.patch
drivers-ata-pata_pdc2027xc-cleanup-kernel-doc.patch
drivers-ata-pata_legacyc-cleanup-kernel-doc.patch
drivers-ata-pata_sisc-cleanup-kernel-doc.patch
drivers-ata-pata_c-the-rest-remove-redundant-comments.patch
mtd-remove-excess-kernel-doc-notation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
fusion-remove-excess-kernel-doc-notation.patch
block-remove-excess-kernel-doc.patch
kernel-doc-handle-varargs-cleanly.patch
ntfs-dont-fool-kernel-doc.patch
irqh-fix-missing-extra-kernel-doc.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
i2o-remove-extraneous-kernel-doc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
profile-likely-unlikely-macros.patch

