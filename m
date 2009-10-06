From: akpm@linux-foundation.org
Subject: + autofs4-rename-dentry-to-active-in-autofs4_lookup_active.patch added to -mm tree
Date: Tue, 06 Oct 2009 13:50:37 -0700
Message-ID: <200910062050.n96KobEQ009861@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933344AbZJFUvv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 16:51:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net, adilger@sun.com, hch@infradead.org, sage@newdream.net, viro@ZenIV.linux.org.uk, yehuda@newdream.net


The patch titled
     autofs4: rename dentry to active in autofs4_lookup_active()
has been added to the -mm tree.  Its filename is
     autofs4-rename-dentry-to-active-in-autofs4_lookup_active.patch

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
Subject: autofs4: rename dentry to active in autofs4_lookup_active()
From: Ian Kent <raven@themaw.net>

In autofs4_lookup_active() a declaration within the list traversal loop
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

diff -puN fs/autofs4/root.c~autofs4-rename-dentry-to-active-in-autofs4_lookup_active fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-rename-dentry-to-active-in-autofs4_lookup_active
+++ a/fs/autofs4/root.c
@@ -419,23 +419,23 @@ static struct dentry *autofs4_lookup_act
 	head = &sbi->active_list;
 	list_for_each(p, head) {
 		struct autofs_info *ino;
-		struct dentry *dentry;
+		struct dentry *active;
 		struct qstr *qstr;
 
 		ino = list_entry(p, struct autofs_info, active);
-		dentry = ino->dentry;
+		active = ino->dentry;
 
-		spin_lock(&dentry->d_lock);
+		spin_lock(&active->d_lock);
 
 		/* Already gone? */
-		if (atomic_read(&dentry->d_count) == 0)
+		if (atomic_read(&active->d_count) == 0)
 			goto next;
 
-		qstr = &dentry->d_name;
+		qstr = &active->d_name;
 
-		if (dentry->d_name.hash != hash)
+		if (active->d_name.hash != hash)
 			goto next;
-		if (dentry->d_parent != parent)
+		if (active->d_parent != parent)
 			goto next;
 
 		if (qstr->len != len)
@@ -443,15 +443,15 @@ static struct dentry *autofs4_lookup_act
 		if (memcmp(qstr->name, str, len))
 			goto next;
 
-		if (d_unhashed(dentry)) {
-			dget(dentry);
-			spin_unlock(&dentry->d_lock);
+		if (d_unhashed(active)) {
+			dget(active);
+			spin_unlock(&active->d_lock);
 			spin_unlock(&sbi->lookup_lock);
 			spin_unlock(&dcache_lock);
-			return dentry;
+			return active;
 		}
 next:
-		spin_unlock(&dentry->d_lock);
+		spin_unlock(&active->d_lock);
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

