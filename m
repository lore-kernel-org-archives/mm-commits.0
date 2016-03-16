From: akpm@linux-foundation.org
Subject: [merged]
 autofs4-fix-invalid-ioctl-return-in-autofs4_root_ioctl_unlocked.patch
 removed from -mm tree
Date: Wed, 16 Mar 2016 12:57:53 -0700
Message-ID: <56e9bac1.l9ed2ZW3XA5zCUm0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbcCPT5y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:57:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: fix invalid ioctl return in autofs4_root_ioctl_unlocked()
has been removed from the -mm tree.  Its filename was
     autofs4-fix-invalid-ioctl-return-in-autofs4_root_ioctl_unlocked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ian Kent <raven@themaw.net>
Subject: autofs4: fix invalid ioctl return in autofs4_root_ioctl_unlocked()

The return from an ioctl if an invalid ioctl is passed in should be EINVAL
not ENOSYS.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/autofs4/root.c~autofs4-fix-invalid-ioctl-return-in-autofs4_root_ioctl_unlocked fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-fix-invalid-ioctl-return-in-autofs4_root_ioctl_unlocked
+++ a/fs/autofs4/root.c
@@ -914,7 +914,7 @@ static int autofs4_root_ioctl_unlocked(s
 					    filp->f_path.mnt, sbi, p);
 
 	default:
-		return -ENOSYS;
+		return -EINVAL;
 	}
 }
 
_

Patches currently in -mm which might be from raven@themaw.net are


