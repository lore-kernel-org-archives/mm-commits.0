From: akpm@linux-foundation.org
Subject: + autofs4-rename-dentry-to-expiring-in-autofs4_lookup_expiring.patch added to -mm tree
Date: Tue, 06 Oct 2009 13:50:39 -0700
Message-ID: <200910062050.n96Kodol010027@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757423AbZJFVA2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 17:00:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net, adilger@sun.com, hch@infradead.org, sage@newdream.net, viro@ZenIV.linux.org.uk, yehuda@newdream.net


The patch titled
     autofs4: rename dentry to expiring in autofs4_lookup_expiring()
has been added to the -mm tree.  Its filename is
     autofs4-rename-dentry-to-expiring-in-autofs4_lookup_expiring.patch

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
Subject: autofs4: rename dentry to expiring in autofs4_lookup_expiring()
From: Ian Kent <raven@themaw.net>

In autofs4_lookup_expiring() a declaration within the list traversal loop
uses a declaration that has the same name as the function parameter.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Sage Weil <sage@newdream.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Yehuda Saheh <yehuda@newdream.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff -puN fs/autofs4/root.c~autofs4-rename-dentry-to-expiring-in-autofs4_lookup_expiring fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-rename-dentry-to-expiring-in-autofs4_lookup_expiring
+++ a/fs/autofs4/root.c
@@ -474,23 +474,23 @@ static struct dentry *autofs4_lookup_exp
 	head = &sbi->expiring_list;
 	list_for_each(p, head) {
 		struct autofs_info *ino;
-		struct dentry *dentry;
+		struct dentry *expiring;
 		struct qstr *qstr;
 
 		ino = list_entry(p, struct autofs_info, expiring);
-		dentry = ino->dentry;
+		expiring = ino->dentry;
 
-		spin_lock(&dentry->d_lock);
+		spin_lock(&expiring->d_lock);
 
 		/* Bad luck, we've already been dentry_iput */
-		if (!dentry->d_inode)
+		if (!expiring->d_inode)
 			goto next;
 
-		qstr = &dentry->d_name;
+		qstr = &expiring->d_name;
 
-		if (dentry->d_name.hash != hash)
+		if (expiring->d_name.hash != hash)
 			goto next;
-		if (dentry->d_parent != parent)
+		if (expiring->d_parent != parent)
 			goto next;
 
 		if (qstr->len != len)
@@ -498,15 +498,15 @@ static struct dentry *autofs4_lookup_exp
 		if (memcmp(qstr->name, str, len))
 			goto next;
 
-		if (d_unhashed(dentry)) {
-			dget(dentry);
-			spin_unlock(&dentry->d_lock);
+		if (d_unhashed(expiring)) {
+			dget(expiring);
+			spin_unlock(&expiring->d_lock);
 			spin_unlock(&sbi->lookup_lock);
 			spin_unlock(&dcache_lock);
-			return dentry;
+			return expiring;
 		}
 next:
-		spin_unlock(&dentry->d_lock);
+		spin_unlock(&expiring->d_lock);
 	}
 	spin_unlock(&sbi->lookup_lock);
 	spin_unlock(&dcache_lock);
_

Patches currently in -mm which might be from raven@themaw.net are

vfs-make-real_lookup-do-dentry-revalidation-with-i_mutex-held.patch
vfs-clean-up-real_lookup.patch
autofs4-use-helper-functions-for-active-list-handling.patch
autofs4-use-helper-functions-for-expiring-list.patch
autofs4-use-helper-function-for-need-mount-check.patch
autofs4-use-autofs_info-for-pending-flag.patch
autofs4-renamer-unhashed-to-active-in-autofs4_lookup.patch
autofs4-cleanup-active-and-expire-lookup.patch
autofs4-eliminate-d_unhashed-in-path-walk-checks.patch
autofs4-rename-dentry-to-active-in-autofs4_lookup_active.patch
autofs4-rename-dentry-to-expiring-in-autofs4_lookup_expiring.patch
autofs4-always-use-lookup-for-lookup.patch

