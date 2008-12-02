From: akpm@linux-foundation.org
Subject: - ntfs-dont-fool-kernel-doc.patch removed from -mm tree
Date: Tue, 02 Dec 2008 10:39:01 -0800
Message-ID: <200812021839.mB2Id14o007255@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753564AbYLBSjJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 13:39:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, aia21@cantab.net, mm-commits@vger.kernel.org


The patch titled
     ntfs: don't fool kernel-doc
has been removed from the -mm tree.  Its filename was
     ntfs-dont-fool-kernel-doc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ntfs: don't fool kernel-doc
From: Randy Dunlap <randy.dunlap@oracle.com>

kernel-doc handles macros now (it has for quite some time), so change the
ntfs_debug() macro's kernel-doc to be just before the macro instead of
before a phony function prototype.

[akpm@linux-foundation.org: coding-style fixes]
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
+extern void __ntfs_debug(const char *file, int line, const char *function,
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
mtd-remove-excess-kernel-doc-notation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
fs-use-menuconfig-to-control-the-misc-filesystems-menu.patch
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
document-hadling-of-bad-memory.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
ldisc-n_tty-export-all-n_tty-ldisc-methods.patch
pps-serial-clients-support.patch
pps-parallel-port-clients-support.patch
pps-low-level-irq-timestamps-recording.patch
linuxpps-core-support-drivers-pps-sysfsc-make-dev_attr_name-static.patch
fix-similar-typos-to-successfull-v2.patch

