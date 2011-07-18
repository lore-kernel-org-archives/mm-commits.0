From: akpm@linux-foundation.org
Subject: [merged] compat_ioctl-fix-warning-caused-by-qemu.patch removed from -mm tree
Date: Mon, 18 Jul 2011 11:32:57 -0700
Message-ID: <201107181832.p6IIWMn9019824@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751096Ab1GRSck (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Jul 2011 14:32:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js@sig21.net, arnd@arndb.de, axboe@kernel.dk, kwolf@redhat.com, mm-commits@vger.kernel.org


The patch titled
     compat_ioctl: fix warning caused by qemu
has been removed from the -mm tree.  Its filename was
     compat_ioctl-fix-warning-caused-by-qemu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: compat_ioctl: fix warning caused by qemu
From: Johannes Stezenbach <js@sig21.net>

On Linux x86_64 host with 32bit userspace, running qemu or even just
"qemu-img create -f qcow2 some.img 1G" causes a kernel warning:

ioctl32(qemu-img:5296): Unknown cmd fd(3) cmd(00005326){t:'S';sz:0} arg(7fffffff) on some.img
ioctl32(qemu-img:5296): Unknown cmd fd(3) cmd(801c0204){t:02;sz:28} arg(fff77350) on some.img

ioctl 00005326 is CDROM_DRIVE_STATUS,
ioctl 801c0204 is FDGETPRM.

The warning appears because the Linux compat-ioctl handler for these
ioctls only applies to block devices, while qemu also uses the ioctls on
plain files.

Discussed in http://lkml.kernel.org/r/20110617090424.GA19345@sig21.net

Signed-off-by: Johannes Stezenbach <js@sig21.net>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Kevin Wolf <kwolf@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/compat_ioctl.c |   14 --------------
 fs/compat_ioctl.c    |    5 +++++
 include/linux/fd.h   |   18 ++++++++++++++++++
 3 files changed, 23 insertions(+), 14 deletions(-)

diff -puN block/compat_ioctl.c~compat_ioctl-fix-warning-caused-by-qemu block/compat_ioctl.c
--- a/block/compat_ioctl.c~compat_ioctl-fix-warning-caused-by-qemu
+++ a/block/compat_ioctl.c
@@ -208,19 +208,6 @@ static int compat_blkpg_ioctl(struct blo
 #define BLKBSZSET_32		_IOW(0x12, 113, int)
 #define BLKGETSIZE64_32		_IOR(0x12, 114, int)
 
-struct compat_floppy_struct {
-	compat_uint_t	size;
-	compat_uint_t	sect;
-	compat_uint_t	head;
-	compat_uint_t	track;
-	compat_uint_t	stretch;
-	unsigned char	gap;
-	unsigned char	rate;
-	unsigned char	spec1;
-	unsigned char	fmt_gap;
-	const compat_caddr_t name;
-};
-
 struct compat_floppy_drive_params {
 	char		cmos;
 	compat_ulong_t	max_dtr;
@@ -288,7 +275,6 @@ struct compat_floppy_write_errors {
 
 #define FDSETPRM32 _IOW(2, 0x42, struct compat_floppy_struct)
 #define FDDEFPRM32 _IOW(2, 0x43, struct compat_floppy_struct)
-#define FDGETPRM32 _IOR(2, 0x04, struct compat_floppy_struct)
 #define FDSETDRVPRM32 _IOW(2, 0x90, struct compat_floppy_drive_params)
 #define FDGETDRVPRM32 _IOR(2, 0x11, struct compat_floppy_drive_params)
 #define FDGETDRVSTAT32 _IOR(2, 0x12, struct compat_floppy_drive_struct)
diff -puN fs/compat_ioctl.c~compat_ioctl-fix-warning-caused-by-qemu fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~compat_ioctl-fix-warning-caused-by-qemu
+++ a/fs/compat_ioctl.c
@@ -68,6 +68,8 @@
 
 #ifdef CONFIG_BLOCK
 #include <linux/loop.h>
+#include <linux/cdrom.h>
+#include <linux/fd.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_ioctl.h>
 #include <scsi/sg.h>
@@ -944,6 +946,9 @@ COMPATIBLE_IOCTL(FIOQSIZE)
 IGNORE_IOCTL(LOOP_CLR_FD)
 /* md calls this on random blockdevs */
 IGNORE_IOCTL(RAID_VERSION)
+/* qemu/qemu-img might call these two on plain files for probing */
+IGNORE_IOCTL(CDROM_DRIVE_STATUS)
+IGNORE_IOCTL(FDGETPRM32)
 /* SG stuff */
 COMPATIBLE_IOCTL(SG_SET_TIMEOUT)
 COMPATIBLE_IOCTL(SG_GET_TIMEOUT)
diff -puN include/linux/fd.h~compat_ioctl-fix-warning-caused-by-qemu include/linux/fd.h
--- a/include/linux/fd.h~compat_ioctl-fix-warning-caused-by-qemu
+++ a/include/linux/fd.h
@@ -3,6 +3,7 @@
 
 #include <linux/ioctl.h>
 #include <linux/compiler.h>
+#include <linux/compat.h>
 
 /* New file layout: Now the ioctl definitions immediately follow the
  * definitions of the structures that they use */
@@ -377,4 +378,21 @@ struct floppy_raw_cmd {
 #define FDEJECT _IO(2, 0x5a)
 /* eject the disk */
 
+#ifdef CONFIG_COMPAT
+struct compat_floppy_struct {
+	compat_uint_t	size;
+	compat_uint_t	sect;
+	compat_uint_t	head;
+	compat_uint_t	track;
+	compat_uint_t	stretch;
+	unsigned char	gap;
+	unsigned char	rate;
+	unsigned char	spec1;
+	unsigned char	fmt_gap;
+	const compat_caddr_t name;
+};
+
+#define FDGETPRM32 _IOR(2, 0x04, struct compat_floppy_struct)
+#endif
+
 #endif
_

Patches currently in -mm which might be from js@sig21.net are

linux-next.patch

