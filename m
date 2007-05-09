From: akpm@linux-foundation.org
Subject: - devpts-add-fsnotify-create-event.patch removed from -mm tree
Date: Tue, 08 May 2007 19:44:39 -0700
Message-ID: <200705090244.l492idQg008611@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51211 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970012AbXEICoo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:44:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fmalita@gmail.com, hpa@zytor.com, mm-commits@vger.kernel.org


The patch titled
     devpts: add fsnotify create event
has been removed from the -mm tree.  Its filename was
     devpts-add-fsnotify-create-event.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: devpts: add fsnotify create event
From: Florin Malita <fmalita@gmail.com>

Currently, devpts doesn't generate an fsnotify event upon pts creation
because the regular vfs paths aren't involved.  Deallocation, on the other
hand, correctly generates a nameremove event thanks to the d_delete()
invocation in devpts_pty_kill().

This patch adds the missing fsnotify_create() trigger in devpts_pty_new().

Signed-off-by: Florin Malita <fmalita@gmail.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/devpts/inode.c~devpts-add-fsnotify-create-event fs/devpts/inode.c
--- a/fs/devpts/inode.c~devpts-add-fsnotify-create-event
+++ a/fs/devpts/inode.c
@@ -19,6 +19,7 @@
 #include <linux/tty.h>
 #include <linux/devpts_fs.h>
 #include <linux/parser.h>
+#include <linux/fsnotify.h>
 
 #define DEVPTS_SUPER_MAGIC 0x1cd1
 
@@ -178,8 +179,10 @@ int devpts_pty_new(struct tty_struct *tt
 	inode->i_private = tty;
 
 	dentry = get_node(number);
-	if (!IS_ERR(dentry) && !dentry->d_inode)
+	if (!IS_ERR(dentry) && !dentry->d_inode) {
 		d_instantiate(dentry, inode);
+		fsnotify_create(devpts_root->d_inode, dentry);
+	}
 
 	mutex_unlock(&devpts_root->d_inode->i_mutex);
 
_

Patches currently in -mm which might be from fmalita@gmail.com are

origin.patch
git-ubi.patch
