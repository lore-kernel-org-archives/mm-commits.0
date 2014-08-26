From: akpm@linux-foundation.org
Subject: + autofs4-avoid-taking-fs_lock-during-rcu-walk.patch added to -mm tree
Date: Tue, 26 Aug 2014 15:17:05 -0700
Message-ID: <53fd0761.yubqEv6h0k+Rnkes%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:46731 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557AbaHZWRG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 18:17:06 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so1830645qap.0
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 15:17:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: avoid taking fs_lock during rcu-walk
has been added to the -mm tree.  Its filename is
     autofs4-avoid-taking-fs_lock-during-rcu-walk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/autofs4-avoid-taking-fs_lock-during-rcu-walk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/autofs4-avoid-taking-fs_lock-during-rcu-walk.patch

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
Subject: autofs4: avoid taking fs_lock during rcu-walk

->fs_lock protects AUTOFS_INF_EXPIRING.  We need to be sure that once the
flag is set, no new references beneath the dentry are taken.  So rcu-walk
currently needs to take fs_lock before checking the flag.  This hurts
performance.

Change the expiry to a two-stage process.  First set AUTOFS_INF_NO_RCU
which forces any path walk into ref-walk mode, then drop the lock and call
synchronize_rcu().  Once that returns we can be sure no rcu-walk is active
beneath the dentry and we can check reference counts again.

Now during an RCU-walk we can test AUTOFS_INF_EXPIRING without taking the
lock as along as we test AUTOFS_INF_NO_RCU too.  If either are set, we
must abort the RCU-walk If neither are set, we know that refcounts will be
tested again after we finish the RCU-walk so we are safe to continue.

->fs_lock is still taken in d_manage() to check for a non-trap directory. 
That will be resolved in the next patch.

Signed-off-by: NeilBrown <neilb@suse.de>
Reviewed-by: Ian Kent <raven@themaw.net>
Tested-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/autofs_i.h |    4 +++
 fs/autofs4/expire.c   |   46 +++++++++++++++++++++++++++++++++-------
 2 files changed, 42 insertions(+), 8 deletions(-)

diff -puN fs/autofs4/autofs_i.h~autofs4-avoid-taking-fs_lock-during-rcu-walk fs/autofs4/autofs_i.h
--- a/fs/autofs4/autofs_i.h~autofs4-avoid-taking-fs_lock-during-rcu-walk
+++ a/fs/autofs4/autofs_i.h
@@ -79,6 +79,10 @@ struct autofs_info {
 };
 
 #define AUTOFS_INF_EXPIRING	(1<<0) /* dentry is in the process of expiring */
+#define AUTOFS_INF_NO_RCU	(1<<1) /* the dentry is being considered
+					* for expiry, so RCU_walk is
+					* not permitted
+					*/
 #define AUTOFS_INF_PENDING	(1<<2) /* dentry pending mount */
 
 struct autofs_wait_queue {
diff -puN fs/autofs4/expire.c~autofs4-avoid-taking-fs_lock-during-rcu-walk fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs4-avoid-taking-fs_lock-during-rcu-walk
+++ a/fs/autofs4/expire.c
@@ -327,10 +327,19 @@ struct dentry *autofs4_expire_direct(str
 	if (ino->flags & AUTOFS_INF_PENDING)
 		goto out;
 	if (!autofs4_direct_busy(mnt, root, timeout, do_now)) {
-		ino->flags |= AUTOFS_INF_EXPIRING;
-		init_completion(&ino->expire_complete);
+		ino->flags |= AUTOFS_INF_NO_RCU;
 		spin_unlock(&sbi->fs_lock);
-		return root;
+		synchronize_rcu();
+		spin_lock(&sbi->fs_lock);
+		if (!autofs4_direct_busy(mnt, root, timeout, do_now)) {
+			ino->flags |= AUTOFS_INF_EXPIRING;
+			smp_mb();
+			ino->flags &= ~AUTOFS_INF_NO_RCU;
+			init_completion(&ino->expire_complete);
+			spin_unlock(&sbi->fs_lock);
+			return root;
+		}
+		ino->flags &= ~AUTOFS_INF_NO_RCU;
 	}
 out:
 	spin_unlock(&sbi->fs_lock);
@@ -448,12 +457,29 @@ struct dentry *autofs4_expire_indirect(s
 	dentry = NULL;
 	while ((dentry = get_next_positive_subdir(dentry, root))) {
 		spin_lock(&sbi->fs_lock);
-		expired = should_expire(dentry, mnt, timeout, how);
-		if (expired) {
+		ino = autofs4_dentry_ino(dentry);
+		if (ino->flags & AUTOFS_INF_NO_RCU)
+			expired = NULL;
+		else
+			expired = should_expire(dentry, mnt, timeout, how);
+		if (!expired) {
+			spin_unlock(&sbi->fs_lock);
+			continue;
+		}
+		ino = autofs4_dentry_ino(expired);
+		ino->flags |= AUTOFS_INF_NO_RCU;
+		spin_unlock(&sbi->fs_lock);
+		synchronize_rcu();
+		spin_lock(&sbi->fs_lock);
+		if (should_expire(expired, mnt, timeout, how)) {
 			if (expired != dentry)
 				dput(dentry);
 			goto found;
 		}
+
+		ino->flags &= ~AUTOFS_INF_NO_RCU;
+		if (expired != dentry)
+			dput(expired);
 		spin_unlock(&sbi->fs_lock);
 	}
 	return NULL;
@@ -461,8 +487,9 @@ struct dentry *autofs4_expire_indirect(s
 found:
 	DPRINTK("returning %p %.*s",
 		expired, (int)expired->d_name.len, expired->d_name.name);
-	ino = autofs4_dentry_ino(expired);
 	ino->flags |= AUTOFS_INF_EXPIRING;
+	smp_mb();
+	ino->flags &= ~AUTOFS_INF_NO_RCU;
 	init_completion(&ino->expire_complete);
 	spin_unlock(&sbi->fs_lock);
 	spin_lock(&sbi->lookup_lock);
@@ -482,11 +509,14 @@ int autofs4_expire_wait(struct dentry *d
 	int status;
 
 	/* Block on any pending expire */
+	if (!(ino->flags & (AUTOFS_INF_EXPIRING | AUTOFS_INF_NO_RCU)))
+		return 0;
+	if (rcu_walk)
+		return -ECHILD;
+
 	spin_lock(&sbi->fs_lock);
 	if (ino->flags & AUTOFS_INF_EXPIRING) {
 		spin_unlock(&sbi->fs_lock);
-		if (rcu_walk)
-			return -ECHILD;
 
 		DPRINTK("waiting for expire %p name=%.*s",
 			 dentry, dentry->d_name.len, dentry->d_name.name);
_

Patches currently in -mm which might be from neilb@suse.de are

autofs4-allow-rcu-walk-to-walk-through-autofs4.patch
autofs4-factor-should_expire-out-of-autofs4_expire_indirect.patch
autofs4-make-autofs4_can_expire-idempotent.patch
autofs4-avoid-taking-fs_lock-during-rcu-walk.patch
autofs4-d_manage-should-return-eisdir-when-appropriate-in-rcu-walk-mode.patch
autofs-the-documentation-i-wanted-to-read.patch
linux-next.patch

