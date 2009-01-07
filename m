From: akpm@linux-foundation.org
Subject: - fs-use-menuconfig-to-control-the-misc-filesystems-menu.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:15:44 -0800
Message-ID: <200901072215.n07MFiM2015520@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761983AbZAGWPt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:15:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     fs: use menuconfig to control the Misc. filesystems menu
has been removed from the -mm tree.  Its filename was
     fs-use-menuconfig-to-control-the-misc-filesystems-menu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -721,7 +721,20 @@ config CONFIGFS_FS
 
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
@@ -1091,7 +1104,7 @@ config UFS_DEBUG
 	  Y here.  This will result in _many_ additional debugging messages to be
 	  written to the system log.
 
-endmenu
+endif # MISC_FILESYSTEMS
 
 menuconfig NETWORK_FILESYSTEMS
 	bool "Network File Systems"
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
leds-add-a-dac124s085-spi-led-driver-fix.patch
mtd-fix-nettel-printk-formats.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
sunrpc-fix-rdma-dependency.patch
proc-move-inode-comment-text-file-to-source-file.patch
esp-fix-section-mismatch-warning.patch
max3100-spi-uart-driver-select-serial_core.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
jbd-remove-excess-kernel-doc-notation.patch
w1-add-list-masters-w1-command.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch
fix-similar-typos-to-successfull-v2.patch
kmemleak-add-documentation-on-the-memory-leak-detector.patch

