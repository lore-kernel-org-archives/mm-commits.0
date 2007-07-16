From: akpm@linux-foundation.org
Subject: - fix-xfs_ioc_fsgeometry_v1-in-compat-mode.patch removed from -mm tree
Date: Mon, 16 Jul 2007 14:00:33 -0700
Message-ID: <200707162100.l6GL0XiP002635@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55700 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763382AbXGPVR1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:17:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mmarek@suse.cz, dgc@sgi.com, tes@sgi.com, mm-commits@vger.kernel.org


The patch titled
     xfs: fix XFS_IOC_FSGEOMETRY_V1 in compat mode
has been removed from the -mm tree.  Its filename was
     fix-xfs_ioc_fsgeometry_v1-in-compat-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: xfs: fix XFS_IOC_FSGEOMETRY_V1 in compat mode
From: Michal Marek <mmarek@suse.cz>

i386 struct xfs_fsop_geom_v1 has no padding after the last member, so the size
is different.

Signed-off-by: Michal Marek <mmarek@suse.cz>
Cc: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_ioctl32.c |   42 ++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff -puN fs/xfs/linux-2.6/xfs_ioctl32.c~fix-xfs_ioc_fsgeometry_v1-in-compat-mode fs/xfs/linux-2.6/xfs_ioctl32.c
--- a/fs/xfs/linux-2.6/xfs_ioctl32.c~fix-xfs_ioc_fsgeometry_v1-in-compat-mode
+++ a/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -75,6 +75,42 @@ xfs_ioctl32_flock(
 	return (unsigned long)p;
 }
 
+typedef struct compat_xfs_fsop_geom_v1 {
+	__u32		blocksize;	/* filesystem (data) block size */
+	__u32		rtextsize;	/* realtime extent size		*/
+	__u32		agblocks;	/* fsblocks in an AG		*/
+	__u32		agcount;	/* number of allocation groups	*/
+	__u32		logblocks;	/* fsblocks in the log		*/
+	__u32		sectsize;	/* (data) sector size, bytes	*/
+	__u32		inodesize;	/* inode size in bytes		*/
+	__u32		imaxpct;	/* max allowed inode space(%)	*/
+	__u64		datablocks;	/* fsblocks in data subvolume	*/
+	__u64		rtblocks;	/* fsblocks in realtime subvol	*/
+	__u64		rtextents;	/* rt extents in realtime subvol*/
+	__u64		logstart;	/* starting fsblock of the log	*/
+	unsigned char	uuid[16];	/* unique id of the filesystem	*/
+	__u32		sunit;		/* stripe unit, fsblocks	*/
+	__u32		swidth;		/* stripe width, fsblocks	*/
+	__s32		version;	/* structure version		*/
+	__u32		flags;		/* superblock version flags	*/
+	__u32		logsectsize;	/* log sector size, bytes	*/
+	__u32		rtsectsize;	/* realtime sector size, bytes	*/
+	__u32		dirblocksize;	/* directory block size, bytes	*/
+} __attribute__((packed)) compat_xfs_fsop_geom_v1_t;
+
+#define XFS_IOC_FSGEOMETRY_V1_32  \
+	_IOR ('X', 100, struct compat_xfs_fsop_geom_v1)
+
+STATIC unsigned long xfs_ioctl32_geom_v1(unsigned long arg)
+{
+	compat_xfs_fsop_geom_v1_t __user *p32 = (void __user *)arg;
+	xfs_fsop_geom_v1_t __user *p = compat_alloc_user_space(sizeof(*p));
+
+	if (copy_in_user(p, p32, sizeof(*p32)))
+		return -EFAULT;
+	return (unsigned long)p;
+}
+
 #else
 
 typedef struct xfs_fsop_bulkreq32 {
@@ -118,7 +154,6 @@ xfs_compat_ioctl(
 
 	switch (cmd) {
 	case XFS_IOC_DIOINFO:
-	case XFS_IOC_FSGEOMETRY_V1:
 	case XFS_IOC_FSGEOMETRY:
 	case XFS_IOC_GETVERSION:
 	case XFS_IOC_GETXFLAGS:
@@ -166,6 +201,10 @@ xfs_compat_ioctl(
 		arg = xfs_ioctl32_flock(arg);
 		cmd = _NATIVE_IOC(cmd, struct xfs_flock64);
 		break;
+	case XFS_IOC_FSGEOMETRY_V1_32:
+		arg = xfs_ioctl32_geom_v1(arg);
+		cmd = _NATIVE_IOC(cmd, struct xfs_fsop_geom_v1);
+		break;
 
 #else /* These are handled fine if no alignment issues */
 	case XFS_IOC_ALLOCSP:
@@ -176,6 +215,7 @@ xfs_compat_ioctl(
 	case XFS_IOC_FREESP64:
 	case XFS_IOC_RESVSP64:
 	case XFS_IOC_UNRESVSP64:
+	case XFS_IOC_FSGEOMETRY_V1:
 		break;
 
 	/* xfs_bstat_t still has wrong u32 vs u64 alignment */
_

Patches currently in -mm which might be from mmarek@suse.cz are

origin.patch
git-xfs.patch
