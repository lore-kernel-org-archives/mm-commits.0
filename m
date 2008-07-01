From: akpm@linux-foundation.org
Subject: + autofs4-dont-make-expiring-dentry-negative-fix.patch added to -mm tree
Date: Tue, 01 Jul 2008 11:01:46 -0700
Message-ID: <200807011801.m61I1kfH007252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60258 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752608AbYGASCS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 14:02:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net


The patch titled
     autofs4: don't make expiring dentry negative fix
has been added to the -mm tree.  Its filename is
     autofs4-dont-make-expiring-dentry-negative-fix.patch

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
Subject: autofs4: don't make expiring dentry negative fix
From: Ian Kent <raven@themaw.net>

The correction to not make a dentry negative has an error.  Currently
->lookup() checks if an expire is in progress and removes the entry from
the list, before the expire is complete so if more than one process is
performing a lookup at this time only one will wait for expire completion.
 We need to not remove the list entry until after waiting for expire
completion.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/autofs4/root.c~autofs4-dont-make-expiring-dentry-negative-fix fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-dont-make-expiring-dentry-negative-fix
+++ a/fs/autofs4/root.c
@@ -555,7 +555,6 @@ static struct dentry *autofs4_lookup_exp
 			goto next;
 
 		if (d_unhashed(dentry)) {
-			list_del_init(&ino->expiring);
 			dget(dentry);
 			spin_unlock(&dentry->d_lock);
 			spin_unlock(&sbi->lookup_lock);
@@ -606,6 +605,10 @@ static struct dentry *autofs4_lookup(str
 			autofs4_wait(sbi, expiring, NFY_NONE);
 			DPRINTK("request completed");
 		}
+		spin_lock(&sbi->lookup_lock);
+		if (!list_empty(&ino->expiring))
+			list_del_init(&ino->expiring);
+		spin_unlock(&sbi->lookup_lock);
 		dput(expiring);
 	}
 
_

Patches currently in -mm which might be from raven@themaw.net are

autofs4-dont-make-expiring-dentry-negative.patch
autofs4-dont-make-expiring-dentry-negative-fix.patch
autofs4-revert-redo-lookup-in-ttfd.patch
autofs4-use-look-aside-list-for-lookups.patch
autofs4-use-look-aside-list-for-lookups-autofs4-fix-symlink-name-allocation.patch
autofs4-dont-release-directory-mutex-if-called-in-oz_mode.patch
autofs4-use-lookup-intent-flags-to-trigger-mounts.patch
autofs4-use-struct-qstr-in-waitqc.patch
autofs4-fix-pending-mount-race.patch

