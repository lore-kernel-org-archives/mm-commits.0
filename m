From: akpm@linux-foundation.org
Subject: + autofs4-detect-invalid-direct-mount-requests.patch added to -mm tree
Date: Tue, 01 Jul 2008 14:17:21 -0700
Message-ID: <200807012117.m61LHLoP015125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751668AbYGAVSb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 17:18:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net, jmoyer@redhat.com


The patch titled
     autofs4: detect invalid direct mount requests
has been added to the -mm tree.  Its filename is
     autofs4-detect-invalid-direct-mount-requests.patch

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
Subject: autofs4: detect invalid direct mount requests
From: Ian Kent <raven@themaw.net>

autofs v5 direct and offset mounts within an autofs filesystem are
triggered by existing autofs triger mounts so the mount point dentry must
be positive.  If the mount point dentry is negative then the trigger
doesn't exist so we can return fail immediately.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/waitq.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN fs/autofs4/waitq.c~autofs4-detect-invalid-direct-mount-requests fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-detect-invalid-direct-mount-requests
+++ a/fs/autofs4/waitq.c
@@ -328,6 +328,10 @@ int autofs4_wait(struct autofs_sb_info *
 	if (sbi->catatonic)
 		return -ENOENT;
 
+	if (!dentry->d_inode &&
+	    (sbi->type & (AUTOFS_TYPE_DIRECT | AUTOFS_TYPE_OFFSET)))
+		return -ENOENT;
+
 	name = kmalloc(NAME_MAX + 1, GFP_KERNEL);
 	if (!name)
 		return -ENOMEM;
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

