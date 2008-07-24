From: akpm@linux-foundation.org
Subject: - autofs4-fix-pending-checks.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:29:41 -0700
Message-ID: <200807242329.m6ONTf0C011403@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756205AbYGXXaB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:30:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     autofs4: fix pending checks
has been removed from the -mm tree.  Its filename was
     autofs4-fix-pending-checks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

