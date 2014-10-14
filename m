From: akpm@linux-foundation.org
Subject: [merged] autofs4-make-autofs4_can_expire-idempotent.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:20:09 -0700
Message-ID: <543d6959.V55qTDPvOr09R7U3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbaJNSUI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:20:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: make "autofs4_can_expire" idempotent.
has been removed from the -mm tree.  Its filename was
     autofs4-make-autofs4_can_expire-idempotent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: autofs4: make "autofs4_can_expire" idempotent.

Have a "test" function change the value it is testing can be confusing,
particularly as a future patch will be calling this function twice.

So move the update for 'last_used' to avoid repeat expiry to the place
where the final determination on what to expire is known.

Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Ian Kent <raven@themaw.net>
Tested-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/expire.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN fs/autofs4/expire.c~autofs4-make-autofs4_can_expire-idempotent fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs4-make-autofs4_can_expire-idempotent
+++ a/fs/autofs4/expire.c
@@ -30,12 +30,6 @@ static inline int autofs4_can_expire(str
 		/* Too young to die */
 		if (!timeout || time_after(ino->last_used + timeout, now))
 			return 0;
-
-		/* update last_used here :-
-		   - obviously makes sense if it is in use now
-		   - less obviously, prevents rapid-fire expire
-		     attempts if expire fails the first time */
-		ino->last_used = now;
 	}
 	return 1;
 }
@@ -535,6 +529,8 @@ int autofs4_expire_run(struct super_bloc
 
 	spin_lock(&sbi->fs_lock);
 	ino = autofs4_dentry_ino(dentry);
+	/* avoid rapid-fire expire attempts if expiry fails */
+	ino->last_used = now;
 	ino->flags &= ~AUTOFS_INF_EXPIRING;
 	complete_all(&ino->expire_complete);
 	spin_unlock(&sbi->fs_lock);
@@ -561,6 +557,8 @@ int autofs4_do_expire_multi(struct super
 		ret = autofs4_wait(sbi, dentry, NFY_EXPIRE);
 
 		spin_lock(&sbi->fs_lock);
+		/* avoid rapid-fire expire attempts if expiry fails */
+		ino->last_used = now;
 		ino->flags &= ~AUTOFS_INF_EXPIRING;
 		complete_all(&ino->expire_complete);
 		spin_unlock(&sbi->fs_lock);
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
linux-next.patch

