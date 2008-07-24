From: akpm@linux-foundation.org
Subject: - autofs4-revert-redo-lookup-in-ttfd.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:29:08 -0700
Message-ID: <200807242329.m6ONT8qp011349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49920 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756689AbYGXX3M (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     autofs4: revert - redo lookup in ttfd
has been removed from the -mm tree.  Its filename was
     autofs4-revert-redo-lookup-in-ttfd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: autofs4: revert - redo lookup in ttfd
From: Ian Kent <raven@themaw.net>

This patch series enables the use of a single dentry for lookups prior to
the dentry being hashed and so we no longer need to redo the lookup.  This
patch reverts the patch of commit
033790449ba9c4dcf8478a87693d33df625c23b5.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |   21 ---------------------
 1 file changed, 21 deletions(-)

diff -puN fs/autofs4/root.c~autofs4-revert-redo-lookup-in-ttfd fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-revert-redo-lookup-in-ttfd
+++ a/fs/autofs4/root.c
@@ -242,7 +242,6 @@ static int try_to_fill_dentry(struct den
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(dentry->d_sb);
 	struct autofs_info *ino = autofs4_dentry_ino(dentry);
-	struct dentry *new;
 	int status;
 
 	/* Block on any pending expiry here; invalidate the dentry
@@ -320,26 +319,6 @@ static int try_to_fill_dentry(struct den
 	dentry->d_flags &= ~DCACHE_AUTOFS_PENDING;
 	spin_unlock(&dentry->d_lock);
 
-	/*
-	 * The dentry that is passed in from lookup may not be the one
-	 * we end up using, as mkdir can create a new one.  If this
-	 * happens, and another process tries the lookup at the same time,
-	 * it will set the PENDING flag on this new dentry, but add itself
-	 * to our waitq.  Then, if after the lookup succeeds, the first
-	 * process that requested the mount performs another lookup of the
-	 * same directory, it will show up as still pending!  So, we need
-	 * to redo the lookup here and clear pending on that dentry.
-	 */
-	if (d_unhashed(dentry)) {
-		new = d_lookup(dentry->d_parent, &dentry->d_name);
-		if (new) {
-			spin_lock(&new->d_lock);
-			new->d_flags &= ~DCACHE_AUTOFS_PENDING;
-			spin_unlock(&new->d_lock);
-			dput(new);
-		}
-	}
