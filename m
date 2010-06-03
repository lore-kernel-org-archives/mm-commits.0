From: akpm@linux-foundation.org
Subject: + autofs4-remove-unneeded-null-check-in-try_to_fill_dentry.patch added to -mm tree
Date: Thu, 03 Jun 2010 14:04:40 -0700
Message-ID: <201006032104.o53L4e36015423@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752101Ab0FCVEq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Jun 2010 17:04:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: error27@gmail.com, raven@themaw.net, viro@zeniv.linux.org.uk


The patch titled
     autofs4: remove unneeded null check in try_to_fill_dentry()
has been added to the -mm tree.  Its filename is
     autofs4-remove-unneeded-null-check-in-try_to_fill_dentry.patch

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
Subject: autofs4: remove unneeded null check in try_to_fill_dentry()
From: Dan Carpenter <error27@gmail.com>

After 97e7449a7ad: "autofs4: fix indirect mount pending expire race" we no
longer assumed that "ino" can be null.  The other null checks got removed
but this was one was missed.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: Ian Kent <raven@themaw.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/autofs4/root.c~autofs4-remove-unneeded-null-check-in-try_to_fill_dentry fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-remove-unneeded-null-check-in-try_to_fill_dentry
+++ a/fs/autofs4/root.c
@@ -198,8 +198,7 @@ static int try_to_fill_dentry(struct den
 	}
 
 	/* Initialize expiry counter after successful mount */
-	if (ino)
-		ino->last_used = jiffies;
+	ino->last_used = jiffies;
 
 	spin_lock(&sbi->fs_lock);
 	ino->flags &= ~AUTOFS_INF_PENDING;
_

Patches currently in -mm which might be from error27@gmail.com are

origin.patch
linux-next.patch
mtd-sst25l-check-for-null-consistently.patch
scsi-remove-superfluous-null-pointer-check-from-scsi_kill_request.patch
padata-add-parenthesis-in-max_seq_nr-macro.patch
keys-propagate-error-code-instead-of-returning-einval.patch
autofs4-remove-unneeded-null-check-in-try_to_fill_dentry.patch

