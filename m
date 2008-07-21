From: akpm@linux-foundation.org
Subject: + autofs4-indirect-dentry-must-almost-always-be-positive.patch added to -mm tree
Date: Sun, 20 Jul 2008 23:35:21 -0700
Message-ID: <200807210635.m6L6ZL9f021560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35119 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755270AbYGUGfq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 02:35:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net, jmoyer@redhat.com


The patch titled
     autofs4: indirect dentry must almost always be positive
has been added to the -mm tree.  Its filename is
     autofs4-indirect-dentry-must-almost-always-be-positive.patch

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
Subject: autofs4: indirect dentry must almost always be positive
From: Ian Kent <raven@themaw.net>

We have been seeing mount requests comming to the automount daemon for
keys of the form "<map key>/<non key directory>" which are lookups for
invalid map keys.  But we can check for this in the kernel module and
return a fail immediately, without having to send a request to the daemon.

It is possible to recognise these requests are invalid based on whether
the request dentry is negative and its relation to the autofs file system
root.

For example, given the indirect multi-mount map entry:

idm1  \
    /mm1  <server>:/<path1>
    /mm2  <server>:/<path2>

For a request to mount idm1, IS_ROOT((idm1)->d_parent) will be always be
true and the dentry may be negative.  But directories idm1/mm1 and
idm1/mm2 will always be created as part of the mount request for idm1.  So
any mount request within idm1 itself must have a positive dentry otherwise
the map key is invalid.

In version 4 these multi-mount entries are all mounted and umounted as a
single request and in version 5 the directories idm1/mm1 and idm1/mm2 are
created and an autofs fs mounted on them to act as a mount trigger so the
above is also true.

This also holds true for the autofs version 4 pseudo direct mount feature.
 When this feature is used without the "--ghost" option automount(8) will
create internal submounts as we go down the map key paths which are
essentially normal indirect mounts for which the above holds.  If the
"--ghost" option is given the directories for map keys are created at
daemon startup so valid map entries correspond to postive dentries in the
autofs fs.

autofs version 5 direct mount maps are similar except that the IS_ROOT
check is not needed.  This has been addressed in a previous patch tittled
"autofs4 - detect invalid direct mount requests".

For example, given the direct multi-mount map entry:

/test/dm1  \
    /mm1  <server>:/<path1>
    /mm2  <server>:/<path2>

An autofs fs is mounted on /test/dm1 as a trigger mount and when a mount
is triggered for /test/dm1, the multi-mount offset directories
/test/dm1/mm1 and /test/dm1/mm2 are created and an autofs fs is mounted on
them to act as mount triggers.  So valid direct mount requests must always
have a positive dentry if they correspond to a valid map entry.

Signed-off-by: Ian Kent <raven@themaw.net>
Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/waitq.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN fs/autofs4/waitq.c~autofs4-indirect-dentry-must-almost-always-be-positive fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-indirect-dentry-must-almost-always-be-positive
+++ a/fs/autofs4/waitq.c
@@ -328,9 +328,20 @@ int autofs4_wait(struct autofs_sb_info *
 	if (sbi->catatonic)
 		return -ENOENT;
 
-	if (!dentry->d_inode &&
-	    (sbi->type & (AUTOFS_TYPE_DIRECT | AUTOFS_TYPE_OFFSET)))
-		return -ENOENT;
+	if (!dentry->d_inode) {
+		/*
+		 * A wait for a negative dentry is invalid for certain
+		 * cases. A direct or offset mount "always" has its mount
+		 * point directory created and so the request dentry must
+		 * be positive or the map key doesn't exist. The situation
+		 * is very similar for indirect mounts except only dentrys
+		 * in the root of the autofs file system may be negative.
+		 */
+		if (sbi->type & (AUTOFS_TYPE_DIRECT|AUTOFS_TYPE_OFFSET))
+			return -ENOENT;
+		else if (!IS_ROOT(dentry->d_parent))
+			return -ENOENT;
+	}
 
 	name = kmalloc(NAME_MAX + 1, GFP_KERNEL);
 	if (!name)
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

