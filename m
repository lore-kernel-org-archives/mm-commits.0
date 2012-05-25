From: akpm@linux-foundation.org
Subject: + pipe-return-enoioctlcmd-instead-of-einval-on-unknown-ioctl-command.patch added to -mm tree
Date: Fri, 25 May 2012 14:14:22 -0700
Message-ID: <20120525211422.D210EA0353@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:36374 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932227Ab2EYVOZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 May 2012 17:14:25 -0400
Received: by lagr15 with SMTP id r15so71113lag.1
        for <mm-commits@vger.kernel.org>; Fri, 25 May 2012 14:14:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.deacon@arm.com, alan@linux.intel.com, axboe@kernel.dk, viro@zeniv.linux.org.uk


The patch titled
     Subject: pipe: return -ENOIOCTLCMD instead of -EINVAL on unknown ioctl command
has been added to the -mm tree.  Its filename is
     pipe-return-enoioctlcmd-instead-of-einval-on-unknown-ioctl-command.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: pipe: return -ENOIOCTLCMD instead of -EINVAL on unknown ioctl command

Patches currently in -mm which might be from will.deacon@arm.com are

origin.patch
linux-next.patch
pipe-return-enoioctlcmd-instead-of-einval-on-unknown-ioctl-command.patch

