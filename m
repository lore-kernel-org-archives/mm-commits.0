From: akpm@linux-foundation.org
Subject: - fix-xfs_ioc__to_handle-and-xfs_ioc_openreadlink_by_handle-in-compat-mode.patch removed from -mm tree
Date: Mon, 16 Jul 2007 14:00:35 -0700
Message-ID: <200707162100.l6GL0ZBn002639@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55663 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763408AbXGPVRa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:17:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mmarek@suse.cz, dgc@sgi.com, tes@sgi.com, mm-commits@vger.kernel.org


The patch titled
     xfs: fix XFS_IOC_*_TO_HANDLE and XFS_IOC_{OPEN,READLINK}_BY_HANDLE in compat mode
has been removed from the -mm tree.  Its filename was
     fix-xfs_ioc__to_handle-and-xfs_ioc_openreadlink_by_handle-in-compat-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: xfs: fix XFS_IOC_*_TO_HANDLE and XFS_IOC_{OPEN,READLINK}_BY_HANDLE in compat mode
From: Michal Marek <mmarek@suse.cz>

32bit struct xfs_fsop_handlereq has different size and offsets (due to
pointers).  TODO: case XFS_IOC_{FSSETDM,ATTRLIST,ATTRMULTI}_BY_HANDLE still
not handled.

Signed-off-by: Michal Marek <mmarek@suse.cz>
Cc: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_ioctl32.c |   57 ++++++++++++++++++++++++++++---
 1 file changed, 52 insertions(+), 5 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_ioctl32.c~fix-xfs_ioc__to_handle-and-xfs_ioc_openreadlink_by_handle-in-compat-mode fs/xfs/linux-2.6/xfs_ioctl32.c
--- a/fs/xfs/linux-2.6/xfs_ioctl32.c~fix-xfs_ioc__to_handle-and-xfs_ioc_openreadlink_by_handle-in-compat-mode
+++ a/fs/xfs/linux-2.6/xfs_ioctl32.c
@@ -141,6 +141,50 @@ xfs_ioctl32_bulkstat(
 }
 #endif
 
+typedef struct compat_xfs_fsop_handlereq {
+	__u32		fd;		/* fd for FD_TO_HANDLE		*/
+	compat_uptr_t	path;		/* user pathname		*/
+	__u32		oflags;		/* open flags			*/
+	compat_uptr_t	ihandle;	/* user supplied handle		*/
+	__u32		ihandlen;	/* user supplied length		*/
+	compat_uptr_t	ohandle;	/* user buffer for handle	*/
+	compat_uptr_t	ohandlen;	/* user buffer length		*/
+} compat_xfs_fsop_handlereq_t;
+
+#define XFS_IOC_PATH_TO_FSHANDLE_32 \
+	_IOWR('X', 104, struct compat_xfs_fsop_handlereq)
+#define XFS_IOC_PATH_TO_HANDLE_32 \
+	_IOWR('X', 105, struct compat_xfs_fsop_handlereq)
+#define XFS_IOC_FD_TO_HANDLE_32 \
+	_IOWR('X', 106, struct compat_xfs_fsop_handlereq)
+#define XFS_IOC_OPEN_BY_HANDLE_32 \
+	_IOWR('X', 107, struct compat_xfs_fsop_handlereq)
+#define XFS_IOC_READLINK_BY_HANDLE_32 \
+	_IOWR('X', 108, struct compat_xfs_fsop_handlereq)
+
+STATIC unsigned long xfs_ioctl32_fshandle(unsigned long arg)
+{
+	compat_xfs_fsop_handlereq_t __user *p32 = (void __user *)arg;
+	xfs_fsop_handlereq_t __user *p = compat_alloc_user_space(sizeof(*p));
+	u32 addr;
+
+	if (copy_in_user(&p->fd, &p32->fd, sizeof(__u32)) ||
+	    get_user(addr, &p32->path) ||
+	    put_user(compat_ptr(addr), &p->path) ||
+	    copy_in_user(&p->oflags, &p32->oflags, sizeof(__u32)) ||
+	    get_user(addr, &p32->ihandle) ||
+	    put_user(compat_ptr(addr), &p->ihandle) ||
+	    copy_in_user(&p->ihandlen, &p32->ihandlen, sizeof(__u32)) ||
+	    get_user(addr, &p32->ohandle) ||
+	    put_user(compat_ptr(addr), &p->ohandle) ||
+	    get_user(addr, &p32->ohandlen) ||
+	    put_user(compat_ptr(addr), &p->ohandlen))
+		return -EFAULT;
+
+	return (unsigned long)p;
+}
+
+
 STATIC long
 xfs_compat_ioctl(
 	int		mode,
@@ -166,12 +210,7 @@ xfs_compat_ioctl(
 	case XFS_IOC_GETBMAPA:
 	case XFS_IOC_GETBMAPX:
 /* not handled
-	case XFS_IOC_FD_TO_HANDLE:
-	case XFS_IOC_PATH_TO_HANDLE:
-	case XFS_IOC_PATH_TO_FSHANDLE:
-	case XFS_IOC_OPEN_BY_HANDLE:
 	case XFS_IOC_FSSETDM_BY_HANDLE:
-	case XFS_IOC_READLINK_BY_HANDLE:
 	case XFS_IOC_ATTRLIST_BY_HANDLE:
 	case XFS_IOC_ATTRMULTI_BY_HANDLE:
 */
@@ -228,6 +267,14 @@ xfs_compat_ioctl(
 		arg = xfs_ioctl32_bulkstat(arg);
 		break;
 #endif
+	case XFS_IOC_FD_TO_HANDLE_32:
+	case XFS_IOC_PATH_TO_HANDLE_32:
+	case XFS_IOC_PATH_TO_FSHANDLE_32:
+	case XFS_IOC_OPEN_BY_HANDLE_32:
+	case XFS_IOC_READLINK_BY_HANDLE_32:
+		arg = xfs_ioctl32_fshandle(arg);
+		cmd = _NATIVE_IOC(cmd, struct xfs_fsop_handlereq);
+		break;
 	default:
 		return -ENOIOCTLCMD;
 	}
_

Patches currently in -mm which might be from mmarek@suse.cz are

origin.patch
git-xfs.patch
