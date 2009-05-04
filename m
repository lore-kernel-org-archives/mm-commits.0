From: akpm@linux-foundation.org
Subject: [merged] autofs4-fix-incorect-return-in-autofs4_mount_busy.patch removed from -mm tree
Date: Mon, 04 May 2009 13:12:27 -0700
Message-ID: <200905042012.n44KCRtX021865@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753555AbZEDUOG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 May 2009 16:14:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     autofs4: fix incorrect return in autofs4_mount_busy()
has been removed from the -mm tree.  Its filename was
     autofs4-fix-incorect-return-in-autofs4_mount_busy.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: fix incorrect return in autofs4_mount_busy()
From: Ian Kent <raven@themaw.net>

Fix an obvious incorrect return status in autofs4_mount_busy().

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/expire.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/autofs4/expire.c~autofs4-fix-incorect-return-in-autofs4_mount_busy fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs4-fix-incorect-return-in-autofs4_mount_busy
+++ a/fs/autofs4/expire.c
@@ -70,8 +70,10 @@ static int autofs4_mount_busy(struct vfs
 		 * Otherwise it's an offset mount and we need to check
 		 * if we can umount its mount, if there is one.
 		 */
-		if (!d_mountpoint(dentry))
+		if (!d_mountpoint(dentry)) {
+			status = 0;
 			goto done;
+		}
 	}
 
 	/* Update the expiry counter if fs is busy */
_

Patches currently in -mm which might be from raven@themaw.net are

origin.patch

