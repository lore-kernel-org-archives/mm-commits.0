From: akpm@linux-foundation.org
Subject: + fs-use-menuconfig-to-control-the-misc-filesystems-menu.patch added to -mm tree
Date: Wed, 26 Nov 2008 13:49:59 -0800
Message-ID: <200811262149.mAQLnxOJ012250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46729 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752723AbYKZVue (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Nov 2008 16:50:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     fs: use menuconfig to control the Misc. filesystems menu
has been added to the -mm tree.  Its filename is
     fs-use-menuconfig-to-control-the-misc-filesystems-menu.patch

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
Subject: fs: use menuconfig to control the Misc. filesystems menu
From: Randy Dunlap <randy.dunlap@oracle.com>

Have one option to control Miscellaneous filesystems.  This makes it easy
to disable all of them at one time.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff -puN fs/Kconfig~fs-use-menuconfig-to-control-the-misc-filesystems-menu fs/Kconfig
--- a/fs/Kconfig~fs-use-menuconfig-to-control-the-misc-filesystems-menu
+++ a/fs/Kconfig
@@ -752,7 +752,20 @@ config CONFIGFS_FS
 
 endmenu
 
-menu "Miscellaneous filesystems"
+menuconfig MISC_FILESYSTEMS
+	bool "Miscellaneous filesystems"
+	default y
+	---help---
+	  Say Y here to get to see options for various miscellaneous
+	  filesystems, such as filesystems that came from other
+	  operating systems.
+
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and
+	  disabled; if unsure, say Y here.
+
+if MISC_FILESYSTEMS
 
 config ADFS_FS
 	tristate "ADFS file system support (EXPERIMENTAL)"
@@ -1122,7 +1135,7 @@ config UFS_DEBUG
 	  Y here.  This will result in _many_ additional debugging messages to be
 	  written to the system log.
 
-endmenu
+endif # MISC_FILESYSTEMS
 
 menuconfig NETWORK_FILESYSTEMS
 	bool "Network File Systems"
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
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
kernel-doc-handle-varargs-cleanly.patch
ntfs-dont-fool-kernel-doc.patch
ntfs-dont-fool-kernel-doc-checkpatch-fixes.patch
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
fix-similar-typos-to-successfull-v2.patch

