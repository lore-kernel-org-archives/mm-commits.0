From: akpm@linux-foundation.org
Subject: - usb-net2280-cant-have-a-function-called.patch removed from -mm tree
Date: Thu, 15 Nov 2007 15:31:29 -0800
Message-ID: <200711152331.lAFNVTdo021526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48609 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762326AbXKOXbn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 18:31:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     USB: net2280 can't have a function called show_registers()
has been removed from the -mm tree.  Its filename was
     usb-net2280-cant-have-a-function-called.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: USB: net2280 can't have a function called show_registers()
From: David Howells <dhowells@redhat.com>

net2280 can't have a function called show_registers() because this can produce
a namespace clash with an arch function of the same name.

All this driver's functions and variables should really be prefixed with
"net2280_" to avoid such a problem in future.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/gadget/net2280.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/usb/gadget/net2280.c~usb-net2280-cant-have-a-function-called drivers/usb/gadget/net2280.c
--- a/drivers/usb/gadget/net2280.c~usb-net2280-cant-have-a-function-called
+++ a/drivers/usb/gadget/net2280.c
@@ -1419,7 +1419,7 @@ show_function (struct device *_dev, stru
 static DEVICE_ATTR (function, S_IRUGO, show_function, NULL);
 
 static ssize_t
-show_registers (struct device *_dev, struct device_attribute *attr, char *buf)
+net2280_show_registers (struct device *_dev, struct device_attribute *attr, char *buf)
 {
 	struct net2280		*dev;
 	char			*next;
@@ -1571,7 +1571,7 @@ show_registers (struct device *_dev, str
 
 	return PAGE_SIZE - size;
 }
-static DEVICE_ATTR (registers, S_IRUGO, show_registers, NULL);
+static DEVICE_ATTR (registers, S_IRUGO, net2280_show_registers, NULL);
 
 static ssize_t
 show_queues (struct device *_dev, struct device_attribute *attr, char *buf)
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
git-mtd.patch
frv-fix-the-extern-declaration-of-kallsyms_num_syms.patch
frv-arrange-things-such-that-bra-can-reach-from-the-trap.patch
frv-permit-the-memory-to-be-located-elsewhere-in-nommu-mode.patch
frv-move-dma-macros-to-scatterlisth-for-consistency.patch
frv-remove-dead-config-symbol-from-frv-code.patch
64-bit-i_version-afs-fixes.patch
add-an-err_cast-function-to-complement-err_ptr-and-co.patch
convert-err_ptrptr_errp-instances-to-err_castp.patch
iget-introduce-a-function-to-register-iget-failure.patch
iget-use-iget_failed-in-afs.patch
iget-use-iget_failed-in-gfs2.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-autofs-from-using-iget-and-read_inode.patch
iget-stop-befs-from-using-iget-and-read_inode-try.patch
iget-stop-bfs-from-using-iget-and-read_inode-try.patch
iget-stop-cifs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext4-from-using-iget-and-read_inode-try.patch
iget-stop-fat-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-fix.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-fuse-from-using-iget-and-read_inode-try.patch
iget-stop-hfsplus-from-using-iget-and-read_inode.patch
iget-stop-isofs-from-using-read_inode.patch
iget-stop-jffs2-from-using-iget-and-read_inode.patch
iget-stop-jfs-from-using-iget-and-read_inode-try.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-openpromfs-from-using-iget-and.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-hppfs-from-using-iget-and-read_inode.patch
iget-remove-iget-and-the-read_inode-super-op-as.patch
iget-stop-unionfs-from-using-iget-and-read_inode.patch
unexport-asm-pageh.patch
add-cmpxchg_local-to-frv.patch
use-path_put-in-a-few-places-instead-of-mntdput.patch
suppress-aout-library-support-if-config_binfmt_aout-checkpatch-fixes.patch
usb-net2280-cant-have-a-function-called.patch
usb-net2280-cant-have-a-function-called-checkpatch-fixes.patch
mn10300-allocate-serial-port-uart-ids-for-on-chip-serial.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-ia64-fix.patch
mutex-subsystem-synchro-test-module.patch
