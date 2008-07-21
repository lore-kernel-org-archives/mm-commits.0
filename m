From: akpm@linux-foundation.org
Subject: + autofs4-fix-pending-checks.patch added to -mm tree
Date: Sun, 20 Jul 2008 23:35:25 -0700
Message-ID: <200807210635.m6L6ZPbd021568@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755472AbYGUGfr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 02:35:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net, jmoyer@redhat.com


The patch titled
     autofs4: fix pending checks
has been added to the -mm tree.  Its filename is
     autofs4-fix-pending-checks.patch

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
Subject: autofs4: fix pending checks
From: Ian Kent <raven@themaw.net>

There are two cases for which a dentry that has a pending mount request
does not wait for completion.  One is via autofs4_revalidate() and the
other via autofs4_follow_link().

In revalidate, after the mount point directory is created, but before the
mount is done, the check in try_to_fill_dentry() can can fail to send the
dentry to the wait queue since the dentry is positive and the lookup flags
may contain only LOOKUP_FOLLOW.  Although we don't trigger a mount for the
LOOKUP_FOLLOW flag, if ther's one pending we might as well wait and use
the mounted dentry for the lookup.

In autofs4_follow_link() the dentry is not checked to see if it is pending
so it may fail to call try_to_fill_dentry() and not wait for mount
completion.

A dentry that is pending must always be sent to the wait queue.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN fs/autofs4/root.c~autofs4-fix-pending-checks fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-fix-pending-checks
+++ a/fs/autofs4/root.c
@@ -177,7 +177,8 @@ static int try_to_fill_dentry(struct den
 			return status;
 		}
 	/* Trigger mount for path component or follow link */
-	} else if (flags & (TRIGGER_FLAGS | TRIGGER_INTENTS) ||
+	} else if (dentry->d_flags & DCACHE_AUTOFS_PENDING ||
+			flags & (TRIGGER_FLAGS | TRIGGER_INTENTS) ||
 			current->link_count) {
 		DPRINTK("waiting for mount name=%.*s",
 			dentry->d_name.len, dentry->d_name.name);
@@ -223,7 +224,8 @@ static void *autofs4_follow_link(struct 
 
 	/* If it's our master or we shouldn't trigger a mount we're done */
 	lookup_type = nd->flags & (TRIGGER_FLAGS | TRIGGER_INTENTS);
-	if (oz_mode || !lookup_type)
+	if (oz_mode ||
+	    !(lookup_type || dentry->d_flags & DCACHE_AUTOFS_PENDING))
 		goto done;
 
 	/* If an expire request is pending wait for it. */
@@ -242,7 +244,8 @@ static void *autofs4_follow_link(struct 
 	 * don't try to mount it again.
 	 */
 	spin_lock(&dcache_lock);
-	if (!d_mountpoint(dentry) && __simple_empty(dentry)) {
+	if (dentry->d_flags & DCACHE_AUTOFS_PENDING ||
+	    (!d_mountpoint(dentry) && __simple_empty(dentry))) {
 		spin_unlock(&dcache_lock);
 
 		status = try_to_fill_dentry(dentry, 0);
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
autofs4-fix-waitq-locking.patch
autofs4-fix-pending-mount-race.patch
autofs4-fix-pending-mount-race-fix.patch
autofs4-check-kernel-communication-pipe-is-valid-for-write.patch
autofs4-fix-waitq-memory-leak.patch
autofs4-detect-invalid-direct-mount-requests.patch
autofs4-indirect-dentry-must-almost-always-be-positive.patch
autofs4-cleanup-redundant-readir-code.patch
autofs4-fix-pending-checks.patch
autofs4-fix-indirect-mount-pending-expire-race.patch
autofs4-fix-direct-mount-pending-expire-race.patch
autofs4-reorganize-expire-pending-wait-function-calls.patch
autofs4-remove-unused-ioctls.patch

