From: akpm@linux-foundation.org
Subject: - sunrpc-convert-rpc_pipefs-to-use-the-generic-filesystem-notification-hooks.patch removed from -mm tree
Date: Tue, 14 Aug 2007 12:15:16 -0700
Message-ID: <200708141915.l7EJFGtR016774@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42096 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932518AbXHNTVi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 15:21:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Trond.Myklebust@netapp.com, davem@davemloft.net, dwmw2@infradead.org, mm-commits@vger.kernel.org


The patch titled
     SUNRPC: convert rpc_pipefs to use the generic filesystem notification hooks
has been removed from the -mm tree.  Its filename was
     sunrpc-convert-rpc_pipefs-to-use-the-generic-filesystem-notification-hooks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SUNRPC: convert rpc_pipefs to use the generic filesystem notification hooks
From: Trond Myklebust <Trond.Myklebust@netapp.com>

This will allow rpc.gssd to use inotify instead of dnotify in order to
locate new rpc upcall pipes.

This also requires the exporting of __audit_inode_child(), which is used by
fsnotify_create() and fsnotify_mkdir().  Ccing David Woodhouse.

Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/auditsc.c      |    1 +
 net/sunrpc/rpc_pipe.c |    7 ++++---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff -puN kernel/auditsc.c~sunrpc-convert-rpc_pipefs-to-use-the-generic-filesystem-notification-hooks kernel/auditsc.c
--- a/kernel/auditsc.c~sunrpc-convert-rpc_pipefs-to-use-the-generic-filesystem-notification-hooks
+++ a/kernel/auditsc.c
@@ -1736,6 +1736,7 @@ add_names:
 			context->names[idx].ino = (unsigned long)-1;
 	}
 }
+EXPORT_SYMBOL_GPL(__audit_inode_child);
 
 /**
  * auditsc_get_stamp - get local copies of audit_context values
diff -puN net/sunrpc/rpc_pipe.c~sunrpc-convert-rpc_pipefs-to-use-the-generic-filesystem-notification-hooks net/sunrpc/rpc_pipe.c
--- a/net/sunrpc/rpc_pipe.c~sunrpc-convert-rpc_pipefs-to-use-the-generic-filesystem-notification-hooks
+++ a/net/sunrpc/rpc_pipe.c
@@ -14,7 +14,7 @@
 #include <linux/pagemap.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
-#include <linux/dnotify.h>
+#include <linux/fsnotify.h>
 #include <linux/kernel.h>
 
 #include <asm/ioctls.h>
@@ -585,6 +585,7 @@ rpc_populate(struct dentry *parent,
 		if (S_ISDIR(mode))
 			inc_nlink(dir);
 		d_add(dentry, inode);
+		fsnotify_create(dir, dentry);
 	}
 	mutex_unlock(&dir->i_mutex);
 	return 0;
@@ -606,7 +607,7 @@ __rpc_mkdir(struct inode *dir, struct de
 	inode->i_ino = iunique(dir->i_sb, 100);
 	d_instantiate(dentry, inode);
 	inc_nlink(dir);
-	inode_dir_notify(dir, DN_CREATE);
+	fsnotify_mkdir(dir, dentry);
 	return 0;
 out_err:
 	printk(KERN_WARNING "%s: %s failed to allocate inode for dentry %s\n",
@@ -748,7 +749,7 @@ rpc_mkpipe(struct dentry *parent, const 
 	rpci->flags = flags;
 	rpci->ops = ops;
 	rpci->nkern_readwriters = 1;
-	inode_dir_notify(dir, DN_CREATE);
+	fsnotify_create(dir, dentry);
 	dget(dentry);
 out:
 	mutex_unlock(&dir->i_mutex);
_

Patches currently in -mm which might be from Trond.Myklebust@netapp.com are

git-nfs.patch
nfs-convert-to-new-aops.patch
