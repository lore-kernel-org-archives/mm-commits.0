From: akpm@linux-foundation.org
Subject: + autofs4-make-autofs4_can_expire-idempotent.patch added to -mm
 tree
Date: Tue, 26 Aug 2014 15:17:04 -0700
Message-ID: <53fd0760.1RaQWYeYAJusSoKx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:64711 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076AbaHZWRF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 18:17:05 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so4029433pdj.4
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 15:17:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: make "autofs4_can_expire" idempotent.
has been added to the -mm tree.  Its filename is
     autofs4-make-autofs4_can_expire-idempotent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs4-make-autofs4_can_expire-idempotent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs4-make-autofs4_can_expire-idempotent.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -541,6 +535,8 @@ int autofs4_expire_run(struct super_bloc
 
 	spin_lock(&sbi->fs_lock);
 	ino = autofs4_dentry_ino(dentry);
+	/* avoid rapid-fire expire attempts if expiry fails */
+	ino->last_used = now;
 	ino->flags &= ~AUTOFS_INF_EXPIRING;
 	complete_all(&ino->expire_complete);
 	spin_unlock(&sbi->fs_lock);
@@ -567,6 +563,8 @@ int autofs4_do_expire_multi(struct super
 		ret = autofs4_wait(sbi, dentry, NFY_EXPIRE);
 
 		spin_lock(&sbi->fs_lock);
+		/* avoid rapid-fire expire attempts if expiry fails */
+		ino->last_used = now;
 		ino->flags &= ~AUTOFS_INF_EXPIRING;
 		complete_all(&ino->expire_complete);
 		spin_unlock(&sbi->fs_lock);
_

Patches currently in -mm which might be from neilb@suse.de are

autofs4-allow-rcu-walk-to-walk-through-autofs4.patch
autofs4-factor-should_expire-out-of-autofs4_expire_indirect.patch
autofs4-make-autofs4_can_expire-idempotent.patch
autofs4-avoid-taking-fs_lock-during-rcu-walk.patch
autofs4-d_manage-should-return-eisdir-when-appropriate-in-rcu-walk-mode.patch
autofs-the-documentation-i-wanted-to-read.patch
linux-next.patch

