From: akpm@linux-foundation.org
Subject: [merged] mm-truncatec-fix-build-for-config_block-not-enabled.patch removed from -mm tree
Date: Mon, 25 Jul 2011 12:04:39 -0700
Message-ID: <201107251903.p6PJ3mrA022499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752510Ab1GYTE1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jul 2011 15:04:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@xenotime.net, hch@infradead.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     mm/truncate.c: fix build for CONFIG_BLOCK not enabled
has been removed from the -mm tree.  Its filename was
     mm-truncatec-fix-build-for-config_block-not-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/truncate.c: fix build for CONFIG_BLOCK not enabled
From: Randy Dunlap <rdunlap@xenotime.net>

Fix build error when CONFIG_BLOCK is not enabled by providing a stub
inode_dio_wait() function.

mm/truncate.c:612: error: implicit declaration of function 'inode_dio_wait'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN include/linux/fs.h~mm-truncatec-fix-build-for-config_block-not-enabled include/linux/fs.h
--- a/include/linux/fs.h~mm-truncatec-fix-build-for-config_block-not-enabled
+++ a/include/linux/fs.h
@@ -2418,6 +2418,10 @@ static inline ssize_t blockdev_direct_IO
 				    offset, nr_segs, get_block, NULL, NULL,
 				    DIO_LOCKING | DIO_SKIP_HOLES);
 }
+#else
+static inline void inode_dio_wait(struct inode *inode)
+{
+}
 #endif
 
 extern const struct file_operations generic_ro_fops;
_

Patches currently in -mm which might be from rdunlap@xenotime.net are

origin.patch
linux-next.patch
drivers-scsi-megaraidc-fix-sparse-warnings.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl.patch
tmpfs-expand-help-to-explain-value-of-tmpfs_posix_acl-v3.patch
um-clean-up-vm-flagsh.patch
asm-generic-iomaph-add-stubs-for-pci-iomap-iounmap.patch
kernel-configsc-include-module_-when-config_ikconfig_proc=n.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
drivers-firmware-sigmac-needs-module_license.patch
misc-eeprom-add-driver-for-microwire-93xx46-eeprom-fix.patch
ipc-introduce-shm_rmid_forced-sysctl.patch
ipc-introduce-shm_rmid_forced-sysctl-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
init-add-root=partuuid=uuid-partnroff=%d-support.patch
documentation-add-pointer-to-name_to_dev_t-for-root=-values.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-fix.patch

