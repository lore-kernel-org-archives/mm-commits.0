From: akpm@linux-foundation.org
Subject: - autofs4-fix-direct-mount-pending-expire-race-correction.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:29:49 -0700
Message-ID: <200807242329.m6ONTnN0011416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34084 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756527AbYGXXaK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:30:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     autofs4: fix direct mount pending expire race - correction
has been removed from the -mm tree.  Its filename was
     autofs4-fix-direct-mount-pending-expire-race-correction.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: fix direct mount pending expire race - correction
From: Ian Kent <raven@themaw.net>

Appologies, somehow I seem to have sent an out dated version of this
patch. Here is an additional patch that brings the patch up to date.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN fs/autofs4/root.c~autofs4-fix-direct-mount-pending-expire-race-correction fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-fix-direct-mount-pending-expire-race-correction
+++ a/fs/autofs4/root.c
@@ -241,13 +241,7 @@ static void *autofs4_follow_link(struct 
 			/* Follow down to our covering mount. */
 			if (!follow_down(&nd->path.mnt, &nd->path.dentry))
 				goto done;
-			/*
-			 * We shouldn't need to do this but we have no way
-			 * of knowing what may have been done so try a follow
-			 * just in case.
-			 */
-			autofs4_follow_mount(&nd->path.mnt, &nd->path.dentry);
-			goto done;
+			goto follow;
 		}
 		spin_unlock(&sbi->fs_lock);
 		goto done;
@@ -273,7 +267,7 @@ cont:
 	/* We trigger a mount for almost all flags */
 	lookup_type = nd->flags & (TRIGGER_FLAGS | TRIGGER_INTENTS);
 	if (!(lookup_type || dentry->d_flags & DCACHE_AUTOFS_PENDING))
-		goto done;
+		goto follow;
 
 	/*
 	 * If the dentry contains directories then it is an autofs
_

Patches currently in -mm which might be from raven@themaw.net are

origin.patch

