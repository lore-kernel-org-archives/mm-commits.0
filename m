From: akpm@linux-foundation.org
Subject: + autofs4-fix-incorect-return-in-autofs4_mount_busy.patch added to -mm tree
Date: Thu, 23 Apr 2009 00:49:39 -0700
Message-ID: <200904230749.n3N7nd0P025458@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757051AbZDWHvL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 03:51:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net


The patch titled
     autofs4: fix incorrect return in autofs4_mount_busy()
has been added to the -mm tree.  Its filename is
     autofs4-fix-incorect-return-in-autofs4_mount_busy.patch

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
Subject: autofs4: fix incorrect return in autofs4_mount_busy()
From: Ian Kent <raven@themaw.net>

Addresses ??496766.

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

autofs4-fix-incorect-return-in-autofs4_mount_busy.patch

