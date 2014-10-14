From: akpm@linux-foundation.org
Subject: [merged]
 autofs4-d_manage-should-return-eisdir-when-appropriate-in-rcu-walk-mode.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:20:13 -0700
Message-ID: <543d695d.33IXM1m/5Itki1rn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44207 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbaJNSUM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:20:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: d_manage() should return -EISDIR when appropriate in rcu-walk mode.
has been removed from the -mm tree.  Its filename was
     autofs4-d_manage-should-return-eisdir-when-appropriate-in-rcu-walk-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
+		inode = ACCESS_ONCE(dentry->d_inode);
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

origin.patch
linux-next.patch

