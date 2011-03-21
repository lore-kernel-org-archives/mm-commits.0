From: akpm@linux-foundation.org
Subject: [merged] fs-ioctlc-remove-unnecessary-variable.patch removed from -mm tree
Date: Mon, 21 Mar 2011 12:16:31 -0700
Message-ID: <201103211919.p2LJJjE1020222@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468Ab1CUTUQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Mar 2011 15:20:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, mm-commits@vger.kernel.org


The patch titled
     fs/ioctl.c: remove unnecessary variable
has been removed from the -mm tree.  Its filename was
     fs-ioctlc-remove-unnecessary-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/ioctl.c: remove unnecessary variable
From: Shaohua Li <shaohua.li@intel.com>

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ioctl.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/ioctl.c~fs-ioctlc-remove-unnecessary-variable fs/ioctl.c
--- a/fs/ioctl.c~fs-ioctlc-remove-unnecessary-variable
+++ a/fs/ioctl.c
@@ -592,8 +592,7 @@ int do_vfs_ioctl(struct file *filp, unsi
 	case FIGETBSZ:
 	{
 		struct inode *inode = filp->f_path.dentry->d_inode;
-		int __user *p = (int __user *)arg;
-		return put_user(inode->i_sb->s_blocksize, p);
+		return put_user(inode->i_sb->s_blocksize, argp);
 	}
 
 	default:
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch
linux-next.patch
mm-vmscan-kswapd-should-not-free-an-excessive-number-of-pages-when-balancing-small-zones.patch
mm-simplify-code-of-swapc.patch
mm-batch-activate_page-to-reduce-lock-contention.patch

