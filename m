From: akpm@linux-foundation.org
Subject: + make-struct-v9fs_cached_file_operations-static.patch added to -mm tree
Date: Sun, 25 Mar 2007 01:26:34 -0800
Message-ID: <200703250926.l2P9QY70024654@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37375 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933297AbXCYJ0m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 05:26:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@stusta.de


The patch titled
     make struct v9fs_cached_file_operations static
has been added to the -mm tree.  Its filename is
     make-struct-v9fs_cached_file_operations-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make struct v9fs_cached_file_operations static
From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/v9fs_vfs.h |    1 -
 fs/9p/vfs_file.c |    4 +++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/9p/v9fs_vfs.h~make-struct-v9fs_cached_file_operations-static fs/9p/v9fs_vfs.h
--- a/fs/9p/v9fs_vfs.h~make-struct-v9fs_cached_file_operations-static
+++ a/fs/9p/v9fs_vfs.h
@@ -40,7 +40,6 @@
 extern struct file_system_type v9fs_fs_type;
 extern const struct address_space_operations v9fs_addr_operations;
 extern const struct file_operations v9fs_file_operations;
-extern const struct file_operations v9fs_cached_file_operations;
 extern const struct file_operations v9fs_dir_operations;
 extern struct dentry_operations v9fs_dentry_operations;
 extern struct dentry_operations v9fs_cached_dentry_operations;
diff -puN fs/9p/vfs_file.c~make-struct-v9fs_cached_file_operations-static fs/9p/vfs_file.c
--- a/fs/9p/vfs_file.c~make-struct-v9fs_cached_file_operations-static
+++ a/fs/9p/vfs_file.c
@@ -42,6 +42,8 @@
 #include "v9fs_vfs.h"
 #include "fid.h"
 
+static const struct file_operations v9fs_cached_file_operations;
+
 /**
  * v9fs_file_open - open a file (or directory)
  * @inode: inode to be opened
@@ -245,7 +247,7 @@ v9fs_file_write(struct file *filp, const
 	return total;
 }
 
-const struct file_operations v9fs_cached_file_operations = {
+static const struct file_operations v9fs_cached_file_operations = {
 	.llseek = generic_file_llseek,
 	.read = do_sync_read,
 	.aio_read = generic_file_aio_read,
_

Patches currently in -mm which might be from bunk@stusta.de are

origin.patch
net-sunrpc-svcsockc-fix-a-check.patch
git-acpi.patch
git-powerpc.patch
git-drm.patch
git-dvb.patch
git-ieee1394.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
remove-mmc_deselect_cards.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
git-ubi.patch
git-netdev-all.patch
drivers-net-vioc-possible-cleanups.patch
git-net.patch
drivers-net-bonding-bond_maincmake-3-functions-static.patch
drivers-scsi-small-cleanups.patch
drivers-scsi-advansysc-cleanups.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
drivers-scsi-dpt_i2oc-remove-dead-code.patch
drivers-scsi-aic7xxx-make-functions-static.patch
drivers-scsi-wd33c93c-cleanups.patch
drivers-scsi-qla4xxx-possible-cleanups.patch
make-seagate_st0x_detect-static.patch
drivers-scsi-aacraid-cleanups.patch
remove-the-broken-scsi_acornscsi_3-driver.patch
git-unionfs.patch
make-struct-v9fs_cached_file_operations-static.patch
git-wireless.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-should-include-asm-bugsh.patch
make-struct-vmi_ops-static.patch
i386-asm-offsetsc-workaround-for-a-wmissing-prototypes-warning.patch
i386-x86_64-early_printkc-make-simnow_init-static.patch
make-arch-i386-kernel-vmicvmi_pmd_clear-static.patch
lguest-kconfig-and-headers.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
drivers-mfd-sm501c-fix-an-off-by-one.patch
proper-prototype-for-hugetlb_get_unmapped_area.patch
mm-slabc-proper-prototypes.patch
lumpy-reclaim-v4.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
kill-net-rxrpc-rxrpc_symsc.patch
drivers-char-hvc_consolec-cleanups.patch
init-do_mountsc-proper-prepare_namespace-prototype.patch
the-scheduled-removal-of-obsolete_oss-options.patch
drivers-macintosh-mac_hidc-make-code-static.patch
more-scheduled-oss-driver-removal.patch
schedule-obsolete-oss-drivers-for-removal-4th-round.patch
ext2-reservations.patch
drivers-edac-make-code-static.patch
make-drivers-isdn-capi-capiutilccdebbuf_alloc-static.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-i386-optimization.patch
revoke-core-code-fs-revokec-cleanups-and-bugfix-for-64bit-systems.patch
readahead-events-accounting.patch
reiser4-export-remove_from_page_cache.patch
reiser4.patch
fbdev-display-class-fix.patch
fbdev-mm-deferred-io-support-fix.patch
fbdev-hecuba-framebuffer-driver-fix.patch
slim-main-patch.patch
slim-debug-output.patch
i386-enable-4k-stacks-by-default.patch
mutex-subsystem-synchro-test-module.patch
