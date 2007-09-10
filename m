From: akpm@linux-foundation.org
Subject: + bitmaph-remove-dead-artifacts.patch added to -mm tree
Date: Mon, 10 Sep 2007 01:42:44 -0700
Message-ID: <200709100842.l8A8gi2s015775@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41608 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755839AbXIJInH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Sep 2007 04:43:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bunk@kernel.org, neilb@suse.de


The patch titled
     bitmap.h: remove dead artifacts
has been added to the -mm tree.  Its filename is
     bitmaph-remove-dead-artifacts.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: bitmap.h: remove dead artifacts
From: Adrian Bunk <bunk@kernel.org>

bitmap_active() no longer exists and BITMAP_ACTIVE is no longer used.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/raid/bitmap.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN include/linux/raid/bitmap.h~bitmaph-remove-dead-artifacts include/linux/raid/bitmap.h
--- a/include/linux/raid/bitmap.h~bitmaph-remove-dead-artifacts
+++ a/include/linux/raid/bitmap.h
@@ -138,7 +138,6 @@ typedef __u16 bitmap_counter_t;
 
 /* use these for bitmap->flags and bitmap->sb->state bit-fields */
 enum bitmap_state {
-	BITMAP_ACTIVE = 0x001, /* the bitmap is in use */
 	BITMAP_STALE  = 0x002,  /* the bitmap file is out of date or had -EIO */
 	BITMAP_WRITE_ERROR = 0x004, /* A write error has occurred */
 	BITMAP_HOSTENDIAN = 0x8000,
@@ -258,7 +257,6 @@ struct bitmap {
 int  bitmap_create(mddev_t *mddev);
 void bitmap_flush(mddev_t *mddev);
 void bitmap_destroy(mddev_t *mddev);
-int  bitmap_active(struct bitmap *bitmap);
 
 char *file_path(struct file *file, char *buf, int count);
 void bitmap_print_sb(struct bitmap *bitmap);
_

Patches currently in -mm which might be from bunk@kernel.org are

update-gitignore.patch
arm-extern-inline-static-inline.patch
ppc-remove-apus-support.patch
git-dvb.patch
git-kbuild.patch
pass-g-to-assembler-under-config_debug_info-fix.patch
fix-ide-ide-hook-acpi-psx-method-to-ide-power-on-off.patch
fix-ide-ide-remove-ide-dma-check.patch
git-m32r.patch
drivers-mtd-mtdbdic-is-no-longer-an-own-module.patch
git-nfsd.patch
drivers-scsi-immc-fix-check-after-use.patch
git-wireless.patch
fix-x86_64-mm-unwinder.patch
i386-visws-extern-inline-static-inline.patch
fix-serial_core_console-driver-dependencies.patch
file-capabilities-clear-fcaps-on-inode-change-fix.patch
security-cleanups.patch
make-kernel-power-maincsuspend_enter-static.patch
uml-fix-inlines.patch
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
reiser4-cryptcompress-misc-fixups-make-3-functions-static.patch
