From: akpm@linux-foundation.org
Subject: +
 autofs4-d_manage-should-return-eisdir-when-appropriate-in-rcu-walk-mode.patch added to -mm tree
Date: Tue, 26 Aug 2014 15:17:06 -0700
Message-ID: <53fd0762.CnmMfi7o5ZVWbxn1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:59870 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078AbaHZWRH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 18:17:07 -0400
Received: by mail-yh0-f73.google.com with SMTP id f73so1826983yha.2
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 15:17:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: d_manage() should return -EISDIR when appropriate in rcu-walk mode.
has been added to the -mm tree.  Its filename is
     autofs4-d_manage-should-return-eisdir-when-appropriate-in-rcu-walk-mode.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs4-d_manage-should-return-eisdir-when-appropriate-in-rcu-walk-mode.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs4-d_manage-should-return-eisdir-when-appropriate-in-rcu-walk-mode.patch

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
Subject: autofs4: d_manage() should return -EISDIR when appropriate in rcu-walk mode.

If rcu-walk mode we don't *have* to return -EISDIR for non-mount-traps as
we will simply drop into REF-walk and handling DCACHE_NEED_AUTOMOUNT
dentrys the slow way.  But it is better if we do when possible.

In 'oz_mode', use the same condition as ref-walk: if not a mountpoint,
then it must be -EISDIR.

In regular mode there are most tests needed.  Most of them can be
performed without taking any spinlocks.  If we find a directory that isn't
obviously empty, and isn't mounted on, we need to call 'simple_empty()'
which does take a spinlock.  If this turned out to hurt performance, some
other approach could be found to signal when a directory is known to be
empty.

Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Ian Kent <raven@themaw.net>
Tested-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff -puN fs/autofs4/root.c~autofs4-d_manage-should-return-eisdir-when-appropriate-in-rcu-walk-mode fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-d_manage-should-return-eisdir-when-appropriate-in-rcu-walk-mode
+++ a/fs/autofs4/root.c
@@ -433,8 +433,6 @@ static int autofs4_d_manage(struct dentr
 
 	/* The daemon never waits. */
 	if (autofs4_oz_mode(sbi)) {
-		if (rcu_walk)
-			return 0;
 		if (!d_mountpoint(dentry))
 			return -EISDIR;
 		return 0;
@@ -452,12 +450,28 @@ static int autofs4_d_manage(struct dentr
 	if (status)
 		return status;
 
-	if (rcu_walk)
-		/* it is always safe to return 0 as the worst that
-		 * will happen is we retry in REF-walk mode.
-		 * Better than always taking a lock.
+	if (rcu_walk) {
+		/* We don't need fs_lock in rcu_walk mode,
+		 * just testing 'AUTOFS_INFO_NO_RCU' is enough.
+		 * simple_empty() takes a spinlock, so leave it
+		 * to last.
+		 * We only return -EISDIR when certain this isn't
+		 * a mount-trap.
 		 */
+		struct inode *inode;
+		if (ino->flags & (AUTOFS_INF_EXPIRING | AUTOFS_INF_NO_RCU))
+			return 0;
+		if (d_mountpoint(dentry))
+			return 0;
+		inode = rcu_dereference(dentry->d_inode);
+		if (inode && S_ISLNK(inode->i_mode))
+			return -EISDIR;
+		if (list_empty(&dentry->d_subdirs))
+			return 0;
+		if (!simple_empty(dentry))
+			return -EISDIR;
 		return 0;
+	}
 
 	spin_lock(&sbi->fs_lock);
 	/*
_

Patches currently in -mm which might be from neilb@suse.de are

autofs4-allow-rcu-walk-to-walk-through-autofs4.patch
autofs4-factor-should_expire-out-of-autofs4_expire_indirect.patch
autofs4-make-autofs4_can_expire-idempotent.patch
autofs4-avoid-taking-fs_lock-during-rcu-walk.patch
autofs4-d_manage-should-return-eisdir-when-appropriate-in-rcu-walk-mode.patch
autofs-the-documentation-i-wanted-to-read.patch
linux-next.patch

