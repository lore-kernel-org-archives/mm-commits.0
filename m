From: akpm@linux-foundation.org
Subject: + sunrpc-convert-rpc_pipefs-to-use-the-generic-filesystem-notification-hooks.patch added to -mm tree
Date: Wed, 18 Jul 2007 22:33:20 -0700
Message-ID: <200707190533.l6J5XK72015803@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50817 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936281AbXGSFdd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 01:33:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Trond.Myklebust@netapp.com, davem@davemloft.net, dwmw2@infradead.org


The patch titled
     SUNRPC: convert rpc_pipefs to use the generic filesystem notification hooks
has been added to the -mm tree.  Its filename is
     sunrpc-convert-rpc_pipefs-to-use-the-generic-filesystem-notification-hooks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1540,6 +1540,7 @@ add_names:
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
@@ -586,6 +586,7 @@ rpc_populate(struct dentry *parent,
 		if (S_ISDIR(mode))
 			inc_nlink(dir);
 		d_add(dentry, inode);
+		fsnotify_create(dir, dentry);
 	}
 	mutex_unlock(&dir->i_mutex);
 	return 0;
@@ -607,7 +608,7 @@ __rpc_mkdir(struct inode *dir, struct de
 	inode->i_ino = iunique(dir->i_sb, 100);
 	d_instantiate(dentry, inode);
 	inc_nlink(dir);
-	inode_dir_notify(dir, DN_CREATE);
+	fsnotify_mkdir(dir, dentry);
 	return 0;
 out_err:
 	printk(KERN_WARNING "%s: %s failed to allocate inode for dentry %s\n",
@@ -749,7 +750,7 @@ rpc_mkpipe(struct dentry *parent, const 
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

origin.patch
sunrpc-use-vfs_path_lookup.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
git-vfs-lease-api.patch
nfs-convert-to-new-aops.patch
sunrpc-convert-rpc_pipefs-to-use-the-generic-filesystem-notification-hooks.patch
