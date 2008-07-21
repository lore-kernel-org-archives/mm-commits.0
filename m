From: akpm@linux-foundation.org
Subject: + autofs4-fix-direct-mount-pending-expire-race-correction.patch added to -mm tree
Date: Sun, 20 Jul 2008 23:36:12 -0700
Message-ID: <200807210636.m6L6aCct021597@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753198AbYGUGg5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 02:36:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net, jmoyer@redhat.com


The patch titled
     autofs4: fix direct mount pending expire race - correction
has been added to the -mm tree.  Its filename is
     autofs4-fix-direct-mount-pending-expire-race-correction.patch

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
Subject: autofs4: fix direct mount pending expire race - correction
From: Ian Kent <raven@themaw.net>

Appologies, somehow I seem to have sent an out dated version of this
patch. Here is an additional patch that brings the patch up to date.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN fs/autofs4/root.c~autofs4-fix-direct-mount-pending-expire-race-correction fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-fix-direct-mount-pending-expire-race-correction
+++ a/fs/autofs4/root.c
@@ -241,13 +241,7 @@ static void *autofs4_follow_link(struct 
 			/* Follow down to our covering mount. */
 			if (!follow_down(&nd->path.mnt, &nd->path.dentry))
 				goto done;
-			/*
-			 * We shouldn't need to do this but we have no way
-			 * of knowing what may have been done so try a follow
-			 * just in case.
-			 */
-			autofs4_follow_mount(&nd->path.mnt, &nd->path.dentry);
-			goto done;
+			goto follow;
 		}
 		spin_unlock(&sbi->fs_lock);
 		goto done;
@@ -273,7 +267,7 @@ cont:
 	/* We trigger a mount for almost all flags */
 	lookup_type = nd->flags & (TRIGGER_FLAGS | TRIGGER_INTENTS);
 	if (!(lookup_type || dentry->d_flags & DCACHE_AUTOFS_PENDING))
-		goto done;
+		goto follow;
 
 	/*
 	 * If the dentry contains directories then it is an autofs
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
autofs4-fix-direct-mount-pending-expire-race-correction.patch
autofs4-reorganize-expire-pending-wait-function-calls.patch
autofs4-remove-unused-ioctls.patch

