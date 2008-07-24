From: akpm@linux-foundation.org
Subject: - autofs4-fix-pending-mount-race-fix.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:29:27 -0700
Message-ID: <200807242329.m6ONTRIq011380@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756804AbYGXX3l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:29:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: raven@themaw.net, jmoyer@redhat.com, mm-commits@vger.kernel.org


The patch titled
     autofs4: add missing kfree
has been removed from the -mm tree.  Its filename was
     autofs4-fix-pending-mount-race-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

