From: akpm@linux-foundation.org
Subject: [merged] move-magic-numbers-into-magich.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:52:18 -0700
Message-ID: <200909231952.n8NJqIXM028863@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57264 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751674AbZIWTxA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:53:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dank@qemfd.net, casey@schaufler-ca.com, davem@davemloft.net, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Move magic numbers into magic.h
has been removed from the -mm tree.  Its filename was
     move-magic-numbers-into-magich.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Move magic numbers into magic.h
From: Nick Black <dank@qemfd.net>

Move various magic-number definitions into magic.h.

Signed-off-by: Nick Black <dank@qemfd.net>
Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/devpts/inode.c          |    3 +--
 fs/hugetlbfs/inode.c       |    4 +---
 include/linux/magic.h      |    5 +++++
 net/socket.c               |    3 +--
 security/smack/smack_lsm.c |    8 +-------
 5 files changed, 9 insertions(+), 14 deletions(-)

diff -puN fs/devpts/inode.c~move-magic-numbers-into-magich fs/devpts/inode.c
--- a/fs/devpts/inode.c~move-magic-numbers-into-magich
+++ a/fs/devpts/inode.c
@@ -18,14 +18,13 @@
 #include <linux/mount.h>
 #include <linux/tty.h>
 #include <linux/mutex.h>
+#include <linux/magic.h>
 #include <linux/idr.h>
 #include <linux/devpts_fs.h>
 #include <linux/parser.h>
 #include <linux/fsnotify.h>
 #include <linux/seq_file.h>
 
-#define DEVPTS_SUPER_MAGIC 0x1cd1
-
 #define DEVPTS_DEFAULT_MODE 0600
 /*
  * ptmx is a new node in /dev/pts and will be unused in legacy (single-
diff -puN fs/hugetlbfs/inode.c~move-magic-numbers-into-magich fs/hugetlbfs/inode.c
--- a/fs/hugetlbfs/inode.c~move-magic-numbers-into-magich
+++ a/fs/hugetlbfs/inode.c
@@ -31,12 +31,10 @@
 #include <linux/statfs.h>
 #include <linux/security.h>
 #include <linux/ima.h>
+#include <linux/magic.h>
 
 #include <asm/uaccess.h>
 
-/* some random number */
-#define HUGETLBFS_MAGIC	0x958458f6
-
 static const struct super_operations hugetlbfs_ops;
 static const struct address_space_operations hugetlbfs_aops;
 const struct file_operations hugetlbfs_file_operations;
diff -puN include/linux/magic.h~move-magic-numbers-into-magich include/linux/magic.h
--- a/include/linux/magic.h~move-magic-numbers-into-magich
+++ a/include/linux/magic.h
@@ -13,6 +13,7 @@
 #define SECURITYFS_MAGIC	0x73636673
 #define SELINUX_MAGIC		0xf97cff8c
 #define TMPFS_MAGIC		0x01021994
+#define HUGETLBFS_MAGIC 	0x958458f6	/* some random number */
 #define SQUASHFS_MAGIC		0x73717368
 #define EFS_SUPER_MAGIC		0x414A53
 #define EXT2_SUPER_MAGIC	0xEF53
@@ -53,4 +54,8 @@
 #define INOTIFYFS_SUPER_MAGIC	0x2BAD1DEA
 
 #define STACK_END_MAGIC		0x57AC6E9D
+
+#define DEVPTS_SUPER_MAGIC	0x1cd1
+#define SOCKFS_MAGIC		0x534F434B
+
 #endif /* __LINUX_MAGIC_H__ */
diff -puN net/socket.c~move-magic-numbers-into-magich net/socket.c
--- a/net/socket.c~move-magic-numbers-into-magich
+++ a/net/socket.c
@@ -86,6 +86,7 @@
 #include <linux/audit.h>
 #include <linux/wireless.h>
 #include <linux/nsproxy.h>
+#include <linux/magic.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -235,8 +236,6 @@ int move_addr_to_user(struct sockaddr *k
 	return __put_user(klen, ulen);
 }
 
-#define SOCKFS_MAGIC 0x534F434B
-
 static struct kmem_cache *sock_inode_cachep __read_mostly;
 
 static struct inode *sock_alloc_inode(struct super_block *sb)
diff -puN security/smack/smack_lsm.c~move-magic-numbers-into-magich security/smack/smack_lsm.c
--- a/security/smack/smack_lsm.c~move-magic-numbers-into-magich
+++ a/security/smack/smack_lsm.c
@@ -30,17 +30,11 @@
 #include <net/netlabel.h>
 #include <net/cipso_ipv4.h>
 #include <linux/audit.h>
+#include <linux/magic.h>
 #include "smack.h"
 
 #define task_security(task)	(task_cred_xxx((task), security))
 
-/*
- * I hope these are the hokeyist lines of code in the module. Casey.
- */
-#define DEVPTS_SUPER_MAGIC	0x1cd1
-#define SOCKFS_MAGIC		0x534F434B
-#define TMPFS_MAGIC		0x01021994
