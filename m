From: akpm@linux-foundation.org
Subject: + autofs4-dont-release-directory-mutex-if-called-in-oz_mode.patch added to -mm tree
Date: Tue, 01 Jul 2008 00:05:32 -0700
Message-ID: <200807010705.m6175WMP014111@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753148AbYGAHFg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 03:05:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net


The patch titled
     autofs4: don't release directory mutex if called in oz_mode
has been added to the -mm tree.  Its filename is
     autofs4-dont-release-directory-mutex-if-called-in-oz_mode.patch

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
Subject: autofs4: don't release directory mutex if called in oz_mode
From: Ian Kent <raven@themaw.net>

Since we now delay hashing of dentrys until the ->mkdir() call, droping
and re-taking the directory mutex within the ->lookup() function when we
are being called by user space is not needed.  This can lead to a race
when other processes are attempting to access the same directory during
mount point directory creation.

In this case we need to hang onto the mutex to ensure we don't get user
processes trying to create a mount request for a newly created dentry
after the mount point entry has already been created.  This ensures that
when we need to check a dentry passed to autofs4_wait(), if it is hashed,
it is always the mount point dentry and not a new dentry created by
another lookup during directory creation.

Signed-off-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff -puN fs/autofs4/root.c~autofs4-dont-release-directory-mutex-if-called-in-oz_mode fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-dont-release-directory-mutex-if-called-in-oz_mode
+++ a/fs/autofs4/root.c
@@ -683,12 +683,11 @@ static struct dentry *autofs4_lookup(str
 		spin_lock(&dentry->d_lock);
 		dentry->d_flags |= DCACHE_AUTOFS_PENDING;
 		spin_unlock(&dentry->d_lock);
-	}
