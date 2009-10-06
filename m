From: akpm@linux-foundation.org
Subject: + autofs4-renamer-unhashed-to-active-in-autofs4_lookup.patch added to -mm tree
Date: Tue, 06 Oct 2009 13:50:31 -0700
Message-ID: <200910062050.n96KoVZu009707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933304AbZJFUvh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Oct 2009 16:51:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net, adilger@sun.com, hch@infradead.org, sage@newdream.net, viro@ZenIV.linux.org.uk, yehuda@newdream.net


The patch titled
     autofs4: renamer unhashed to active in autofs4_lookup()
has been added to the -mm tree.  Its filename is
     autofs4-renamer-unhashed-to-active-in-autofs4_lookup.patch

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
Subject: autofs4: renamer unhashed to active in autofs4_lookup()
From: Ian Kent <raven@themaw.net>

Rename the variable unhashed to active in autofs4_lookup() to better
reflect its usage.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Sage Weil <sage@newdream.net>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andreas Dilger <adilger@sun.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Yehuda Saheh <yehuda@newdream.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN fs/autofs4/root.c~autofs4-renamer-unhashed-to-active-in-autofs4_lookup fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-renamer-unhashed-to-active-in-autofs4_lookup
+++ a/fs/autofs4/root.c
@@ -514,7 +514,7 @@ static struct dentry *autofs4_lookup(str
 {
 	struct autofs_sb_info *sbi;
 	struct autofs_info *ino;
-	struct dentry *expiring, *unhashed;
+	struct dentry *expiring, *active;
 	int oz_mode;
 
 	DPRINTK("name = %.*s",
@@ -530,9 +530,9 @@ static struct dentry *autofs4_lookup(str
 	DPRINTK("pid = %u, pgrp = %u, catatonic = %d, oz_mode = %d",
 		 current->pid, task_pgrp_nr(current), sbi->catatonic, oz_mode);
 
-	unhashed = autofs4_lookup_active(sbi, dentry->d_parent, &dentry->d_name);
-	if (unhashed) {
-		dentry = unhashed;
+	active = autofs4_lookup_active(sbi, dentry->d_parent, &dentry->d_name);
+	if (active) {
+		dentry = active;
 		ino = autofs4_dentry_ino(dentry);
 	} else {
 		/*
@@ -600,8 +600,8 @@ static struct dentry *autofs4_lookup(str
 			if (sigismember (sigset, SIGKILL) ||
 			    sigismember (sigset, SIGQUIT) ||
 			    sigismember (sigset, SIGINT)) {
-			    if (unhashed)
-				dput(unhashed);
+			    if (active)
+				dput(active);
 			    return ERR_PTR(-ERESTARTNOINTR);
 			}
 		}
@@ -633,14 +633,14 @@ static struct dentry *autofs4_lookup(str
 		else
 			dentry = ERR_PTR(-ENOENT);
 
-		if (unhashed)
-			dput(unhashed);
+		if (active)
+			dput(active);
 
 		return dentry;
 	}
 
-	if (unhashed)
-		return unhashed;
+	if (active)
+		return active;
 
 	return NULL;
 }
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

