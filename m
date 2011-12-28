From: akpm@linux-foundation.org
Subject: [merged] nilfs2-unbreak-compat-ioctl.patch removed from -mm tree
Date: Wed, 28 Dec 2011 14:04:29 -0800
Message-ID: <20111228220429.A83701E0078@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:49863 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab1L1WEa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Dec 2011 17:04:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thomas@m3y3r.de, konishi.ryusuke@lab.ntt.co.jp, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: unbreak compat ioctl
has been removed from the -mm tree.  Its filename was
     nilfs2-unbreak-compat-ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Thomas Meyer <thomas@m3y3r.de>
Subject: nilfs2: unbreak compat ioctl

commit 828b1c50ae ("nilfs2: add compat ioctl") incidentally broke all
other NILFS compat ioctls.  Make them work again.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: <stable@vger.kernel.org> [3.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/ioctl.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN fs/nilfs2/ioctl.c~nilfs2-unbreak-compat-ioctl fs/nilfs2/ioctl.c
--- a/fs/nilfs2/ioctl.c~nilfs2-unbreak-compat-ioctl
+++ a/fs/nilfs2/ioctl.c
@@ -842,6 +842,19 @@ long nilfs_compat_ioctl(struct file *fil
 	case FS_IOC32_GETVERSION:
 		cmd = FS_IOC_GETVERSION;
 		break;
+	case NILFS_IOCTL_CHANGE_CPMODE:
+	case NILFS_IOCTL_DELETE_CHECKPOINT:
+	case NILFS_IOCTL_GET_CPINFO:
+	case NILFS_IOCTL_GET_CPSTAT:
+	case NILFS_IOCTL_GET_SUINFO:
+	case NILFS_IOCTL_GET_SUSTAT:
+	case NILFS_IOCTL_GET_VINFO:
+	case NILFS_IOCTL_GET_BDESCS:
+	case NILFS_IOCTL_CLEAN_SEGMENTS:
+	case NILFS_IOCTL_SYNC:
+	case NILFS_IOCTL_RESIZE:
+	case NILFS_IOCTL_SET_ALLOC_RANGE:
+		break;
 	default:
 		return -ENOIOCTLCMD;
 	}
_

Patches currently in -mm which might be from thomas@m3y3r.de are

linux-next.patch
drivers-memstick-use-kmemdup-rather-than-duplicating-its-implementation.patch

