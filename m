From: akpm@linux-foundation.org
Subject: + git-nfs-make-nfs_wb_page_priority-static.patch added to -mm tree
Date: Thu, 13 Sep 2007 17:53:39 -0700
Message-ID: <200709140053.l8E0rdEE014184@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46699 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764140AbXINAy3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 20:54:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, bfields@fieldses.org, trond.myklebust@fys.uio.no


The patch titled
     git-nfs: make nfs_wb_page_priority() static
has been added to the -mm tree.  Its filename is
     git-nfs-make-nfs_wb_page_priority-static.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-nfs: make nfs_wb_page_priority() static
From: Adrian Bunk <bunk@kernel.org>

nfs_wb_page_priority() can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/write.c         |    3 ++-
 include/linux/nfs_fs.h |    1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/nfs/write.c~git-nfs-make-nfs_wb_page_priority-static fs/nfs/write.c
--- a/fs/nfs/write.c~git-nfs-make-nfs_wb_page_priority-static
+++ a/fs/nfs/write.c
@@ -1424,7 +1424,8 @@ out:
 	return ret;
 }
 
-int nfs_wb_page_priority(struct inode *inode, struct page *page, int how)
+static int nfs_wb_page_priority(struct inode *inode, struct page *page,
+				int how)
 {
 	loff_t range_start = page_offset(page);
 	loff_t range_end = range_start + (loff_t)(PAGE_CACHE_SIZE - 1);
diff -puN include/linux/nfs_fs.h~git-nfs-make-nfs_wb_page_priority-static include/linux/nfs_fs.h
--- a/include/linux/nfs_fs.h~git-nfs-make-nfs_wb_page_priority-static
+++ a/include/linux/nfs_fs.h
@@ -430,7 +430,6 @@ extern long nfs_sync_mapping_wait(struct
 extern int nfs_wb_all(struct inode *inode);
 extern int nfs_wb_nocommit(struct inode *inode);
 extern int nfs_wb_page(struct inode *inode, struct page* page);
-extern int nfs_wb_page_priority(struct inode *inode, struct page* page, int how);
 extern int nfs_wb_page_cancel(struct inode *inode, struct page* page);
 #if defined(CONFIG_NFS_V3) || defined(CONFIG_NFS_V4)
 extern int  nfs_commit_inode(struct inode *, int);
_

Patches currently in -mm which might be from bunk@kernel.org are

fix-serial_core_console-driver-dependencies.patch
git-alsa.patch
arm-extern-inline-static-inline.patch
omap1-leds-innovatorc-remove-dead-code.patch
ppc-remove-apus-support.patch
git-dvb.patch
git-kbuild.patch
pass-g-to-assembler-under-config_debug_info-fix.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
git-nfs-make-nfs_wb_page_priority-static.patch
git-nfsd.patch
drivers-scsi-immc-fix-check-after-use.patch
git-wireless.patch
fix-x86_64-mm-unwinder.patch
i386-visws-extern-inline-static-inline.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
make-kernel-power-maincsuspend_enter-static.patch
uml-fix-inlines.patch
i-oat-add-support-for-msi-and-msi-x-fix.patch
kconfig-syntax-cleanups.patch
kernel-time-timekeepingc-cleanups.patch
make-fs-libfscsimple_commit_write-static.patch
allow-disabling-dnotify-without-embedded.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal-fix.patch
remove-include-asm-ipch.patch
n_hdlcc-fix-check-after-use.patch
kernel-sys_nic-add-dummy-sys_ni_syscall-prototype.patch
make-kernel-profilectime_hook-static.patch
drivers-block-ccissc-fix-check-after-use.patch
remove-fs-ext2-balloccreserve_blocks.patch
pm3fb-mtrr-support-and-noaccel-option-make-pm3fb_init-static-again.patch
bitmaph-remove-dead-artifacts.patch
sysctl-parport-remove-binary-paths-fix.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
remove-asm-bitopsh-includes.patch
forbid-asm-bitopsh-direct-inclusion.patch
alpha-lock-bitops-fix.patch
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
remove-asm-bitopsh-includes-reiser4.patch
