From: akpm@linux-foundation.org
Subject: [folded-merged]
 autofs4-d_manage-should-return-eisdir-when-appropriate-in-rcu-walk-mode-fix.patch removed from -mm tree
Date: Mon, 13 Oct 2014 15:36:54 -0700
Message-ID: <543c5406.rBle8DswbWJPIpZY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34653 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbaJMWgz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 18:36:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: neilb@suse.de, raven@themaw.net, mm-commits@vger.kernel.org


The patch titled
     Subject: autofs4: use ACCESS_ONCE rather than rcu_dereference for dentry->d_inode
has been removed from the -mm tree.  Its filename was
     autofs4-d_manage-should-return-eisdir-when-appropriate-in-rcu-walk-mode-fix.patch

This patch was dropped because it was folded into autofs4-d_manage-should-return-eisdir-when-appropriate-in-rcu-walk-mode.patch

------------------------------------------------------
From: NeilBrown <neilb@suse.de>
Subject: autofs4: use ACCESS_ONCE rather than rcu_dereference for dentry->d_inode

As the kbuild test robot reports, rcu_dereference() isn't really
appropriate here - we don't need a memory barrier, just a guard
against accidentally dereferencing NULL.

This can be merged into
 autofs4: d_manage() should return -EISDIR when appropriate in rcu-walk mod=
e.
in 'mm'.

Signed-off-by: NeilBrown <neilb@suse.de>
Cc: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/root.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/autofs4/root.c~autofs4-d_manage-should-return-eisdir-when-appropriate-in-rcu-walk-mode-fix fs/autofs4/root.c
--- a/fs/autofs4/root.c~autofs4-d_manage-should-return-eisdir-when-appropriate-in-rcu-walk-mode-fix
+++ a/fs/autofs4/root.c
@@ -463,7 +463,7 @@ static int autofs4_d_manage(struct dentr
 			return 0;
 		if (d_mountpoint(dentry))
 			return 0;
-		inode = rcu_dereference(dentry->d_inode);
+		inode = ACCESS_ONCE(dentry->d_inode);
 		if (inode && S_ISLNK(inode->i_mode))
 			return -EISDIR;
 		if (list_empty(&dentry->d_subdirs))
_

Patches currently in -mm which might be from neilb@suse.de are

origin.patch
autofs4-allow-rcu-walk-to-walk-through-autofs4.patch
autofs4-factor-should_expire-out-of-autofs4_expire_indirect.patch
autofs4-make-autofs4_can_expire-idempotent.patch
autofs4-avoid-taking-fs_lock-during-rcu-walk.patch
autofs4-d_manage-should-return-eisdir-when-appropriate-in-rcu-walk-mode.patch
autofs-the-documentation-i-wanted-to-read.patch

