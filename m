From: akpm@linux-foundation.org
Subject: [merged] autofs4-remove-a-redundant-assignment.patch removed from -mm tree
Date: Tue, 12 Aug 2014 12:38:24 -0700
Message-ID: <53ea6d30.auZOaG5qB8RULNp3%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:61215 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885AbaHLTiZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:38:25 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so1309430qgd.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:38:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: remove a redundant assignment
has been removed from the -mm tree.  Its filename was
     autofs4-remove-a-redundant-assignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: autofs4: remove a redundant assignment

The variable 'ino' already exists and already has the correct value.  The
d_fsdata of a dentry is never changed after the d_fsdata is instantiated,
so this new assignment cannot be necessary.

It was introduced in b5b801779d59 ("autofs4: Add d_manage() dentry
operation").

Signed-off-by: NeilBrown <neilb@suse.de>
Acked-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/expire.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN fs/autofs4/expire.c~autofs4-remove-a-redundant-assignment fs/autofs4/expire.c
--- a/fs/autofs4/expire.c~autofs4-remove-a-redundant-assignment
+++ a/fs/autofs4/expire.c
@@ -333,7 +333,6 @@ struct dentry *autofs4_expire_direct(str
 	if (ino->flags & AUTOFS_INF_PENDING)
 		goto out;
 	if (!autofs4_direct_busy(mnt, root, timeout, do_now)) {
-		struct autofs_info *ino = autofs4_dentry_ino(root);
 		ino->flags |= AUTOFS_INF_EXPIRING;
 		init_completion(&ino->expire_complete);
 		spin_unlock(&sbi->fs_lock);
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
linux-next.patch

