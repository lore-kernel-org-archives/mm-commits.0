From: akpm@linux-foundation.org
Subject: + fs-ioctlc-remove-unnecessary-variable.patch added to -mm tree
Date: Wed, 19 Jan 2011 15:12:32 -0800
Message-ID: <201101192312.p0JNCWa9009232@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753106Ab1ASXMx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Jan 2011 18:12:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com


The patch titled
     fs/ioctl.c: remove unnecessary variable
has been added to the -mm tree.  Its filename is
     fs-ioctlc-remove-unnecessary-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

fs-ioctlc-remove-unnecessary-variable.patch

