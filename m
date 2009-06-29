From: akpm@linux-foundation.org
Subject: + move-magic-numbers-into-magich.patch added to -mm tree
Date: Mon, 29 Jun 2009 12:28:20 -0700
Message-ID: <200906291928.n5TJSKds005109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755162AbZF2T25 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Jun 2009 15:28:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dank@qemfd.net, casey@schaufler-ca.com, davem@davemloft.net, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk


The patch titled
     Move magic numbers into magic.h
has been added to the -mm tree.  Its filename is
     move-magic-numbers-into-magich.patch

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
 include/linux/magic.h      |    4 ++++
 net/socket.c               |    3 +--
 security/smack/smack_lsm.c |    8 +-------
 4 files changed, 7 insertions(+), 11 deletions(-)

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
diff -puN include/linux/magic.h~move-magic-numbers-into-magich include/linux/magic.h
--- a/include/linux/magic.h~move-magic-numbers-into-magich
+++ a/include/linux/magic.h
@@ -53,4 +53,8 @@
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
