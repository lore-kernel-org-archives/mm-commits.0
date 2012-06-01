From: akpm@linux-foundation.org
Subject: [merged] pipe-return-enoioctlcmd-instead-of-einval-on-unknown-ioctl-command.patch removed from -mm tree
Date: Fri, 01 Jun 2012 12:33:16 -0700
Message-ID: <20120601193316.59608A013D@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:52540 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759028Ab2FATdR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2012 15:33:17 -0400
Received: by mail-ey0-f202.google.com with SMTP id o13so111891eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 01 Jun 2012 12:33:17 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.deacon@arm.com, alan@linux.intel.com, axboe@kernel.dk, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: pipe: return -ENOIOCTLCMD instead of -EINVAL on unknown ioctl command
has been removed from the -mm tree.  Its filename was
     pipe-return-enoioctlcmd-instead-of-einval-on-unknown-ioctl-command.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: pipe: return -ENOIOCTLCMD instead of -EINVAL on unknown ioctl command

As described in commit 07d106d0a ("vfs: fix up ENOIOCTLCMD error
handling"), drivers should return -ENOIOCTLCMD if they receive an ioctl
command which they don't understand.  Doing so will result in -ENOTTY
being returned to userspace, which matches the behaviour of the compat
layer if it fails to translate an ioctl command.

This patch fixes the pipe ioctl to return -ENOIOCTLCMD instead of -EINVAL
when passed an unknown ioctl command.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: Alan Cox <alan@linux.intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/pipe.c~pipe-return-enoioctlcmd-instead-of-einval-on-unknown-ioctl-command fs/pipe.c
--- a/fs/pipe.c~pipe-return-enoioctlcmd-instead-of-einval-on-unknown-ioctl-command
+++ a/fs/pipe.c
@@ -693,7 +693,7 @@ static long pipe_ioctl(struct file *filp
 
 			return put_user(count, (int __user *)arg);
 		default:
-			return -EINVAL;
+			return -ENOIOCTLCMD;
 	}
 }
 
_

Patches currently in -mm which might be from will.deacon@arm.com are

origin.patch
linux-next.patch

