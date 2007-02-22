From: akpm@linux-foundation.org
Subject: + devpts-add-fsnotify-create-event.patch added to -mm tree
Date: Wed, 21 Feb 2007 16:53:02 -0800
Message-ID: <200702220053.l1M0r2BY032000@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60268 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbXBVAxE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 19:53:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fmalita@gmail.com


The patch titled
     devpts: add fsnotify create event
has been added to the -mm tree.  Its filename is
     devpts-add-fsnotify-create-event.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: devpts: add fsnotify create event
From: Florin Malita <fmalita@gmail.com>

Currently, devpts doesn't generate an fsnotify event upon pts creation
because the regular vfs paths aren't involved.  Deallocation, on the other
hand, correctly generates a nameremove event thanks to the d_delete()
invocation in devpts_pty_kill().

This patch adds the missing fsnotify_create() trigger in devpts_pty_new().

Signed-off-by: Florin Malita <fmalita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletion(-)

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

devpts-add-fsnotify-create-event.patch
