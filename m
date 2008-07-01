From: akpm@linux-foundation.org
Subject: + autofs4-revert-redo-lookup-in-ttfd.patch added to -mm tree
Date: Tue, 01 Jul 2008 00:05:28 -0700
Message-ID: <200807010705.m6175SLw014103@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57585 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752805AbYGAHFc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 03:05:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net


The patch titled
     autofs4: revert - redo lookup in ttfd
has been added to the -mm tree.  Its filename is
     autofs4-revert-redo-lookup-in-ttfd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
