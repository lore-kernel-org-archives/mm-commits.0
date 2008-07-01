From: akpm@linux-foundation.org
Subject: + autofs4-fix-pending-mount-race-fix.patch added to -mm tree
Date: Tue, 01 Jul 2008 14:12:33 -0700
Message-ID: <200807012112.m61LCXbx014942@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753416AbYGAVMz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 17:12:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: raven@themaw.net, jmoyer@redhat.com


The patch titled
     autofs4: add missing kfree
has been added to the -mm tree.  Its filename is
     autofs4-fix-pending-mount-race-fix.patch

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
Subject: autofs4: add missing kfree
From: Ian Kent <raven@themaw.net>

It see that the patch tittled "autofs4 - fix pending mount race" is
missing a change that I had recently made.

It's missing a kfree for the case mutex_lock_interruptible() fails
to aquire the wait queue mutex.

Signed-off-by: Ian Kent <raven@themaw.net>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/waitq.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/autofs4/waitq.c~autofs4-fix-pending-mount-race-fix fs/autofs4/waitq.c
--- a/fs/autofs4/waitq.c~autofs4-fix-pending-mount-race-fix
+++ a/fs/autofs4/waitq.c
@@ -332,8 +332,10 @@ int autofs4_wait(struct autofs_sb_info *
 	qstr.name = name;
 	qstr.hash = full_name_hash(name, qstr.len);
 
-	if (mutex_lock_interruptible(&sbi->wq_mutex))
+	if (mutex_lock_interruptible(&sbi->wq_mutex)) {
+		kfree(qstr.name);
 		return -EINTR;
+	}
 
 	ret = validate_request(&wq, sbi, &qstr, dentry, notify);
 	if (ret <= 0) {
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

