From: akpm@linux-foundation.org
Subject: [patch 061/111] nilfs2: add nilfs_msg() message interface
Date: Tue, 02 Aug 2016 14:05:02 -0700
Message-ID: <57a10afe.K8KAHx+9Sigai2jU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60619 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756198AbcHBVRQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:17:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: add nilfs_msg() message interface

Define an own output routine to replace bare use of printk() function. 
The output routine is implemented with a macro and a helper function,
which are named nilfs_msg() and __nilfs_msg(), respectively.

__nilfs_msg() formats a message like "NILFS (<device-name>): <message>",
prefixing it with a given log level, and terminates the statement with a
newline.  The "device-name" is optional to make it available in early
stages; it will be omitted if a NULL pointer is passed to super block
instance argument.  nilfs_msg() wraps __nilfs_msg() and is removed if
CONFIG_PRINTK is not set.

Link: http://lkml.kernel.org/r/1464875891-5443-3-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/nilfs.h |    7 +++++++
 fs/nilfs2/super.c |   16 ++++++++++++++++
 2 files changed, 23 insertions(+)

diff -puN fs/nilfs2/nilfs.h~nilfs2-add-nilfs_msg-message-interface fs/nilfs2/nilfs.h
--- a/fs/nilfs2/nilfs.h~nilfs2-add-nilfs_msg-message-interface
+++ a/fs/nilfs2/nilfs.h
@@ -301,6 +301,9 @@ extern struct inode *nilfs_alloc_inode(s
 extern void nilfs_destroy_inode(struct inode *);
 
 extern __printf(3, 4)
+void __nilfs_msg(struct super_block *sb, const char *level,
+		 const char *fmt, ...);
+extern __printf(3, 4)
 void __nilfs_error(struct super_block *sb, const char *function,
 		   const char *fmt, ...);
 extern __printf(3, 4)
@@ -308,11 +311,15 @@ void nilfs_warning(struct super_block *,
 
 #ifdef CONFIG_PRINTK
 
+#define nilfs_msg(sb, level, fmt, ...)					\
+	__nilfs_msg(sb, level, fmt, ##__VA_ARGS__)
 #define nilfs_error(sb, fmt, ...)					\
 	__nilfs_error(sb, __func__, fmt, ##__VA_ARGS__)
 
 #else
 
+#define nilfs_msg(sb, level, fmt, ...)					\
+	no_printk(fmt, ##__VA_ARGS__)
 #define nilfs_error(sb, fmt, ...)					\
 	do {								\
 		no_printk(fmt, ##__VA_ARGS__);				\
diff -puN fs/nilfs2/super.c~nilfs2-add-nilfs_msg-message-interface fs/nilfs2/super.c
--- a/fs/nilfs2/super.c~nilfs2-add-nilfs_msg-message-interface
+++ a/fs/nilfs2/super.c
@@ -71,6 +71,22 @@ struct kmem_cache *nilfs_btree_path_cach
 static int nilfs_setup_super(struct super_block *sb, int is_mount);
 static int nilfs_remount(struct super_block *sb, int *flags, char *data);
 
+void __nilfs_msg(struct super_block *sb, const char *level, const char *fmt,
+		 ...)
+{
+	struct va_format vaf;
+	va_list args;
+
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	if (sb)
+		printk("%sNILFS (%s): %pV\n", level, sb->s_id, &vaf);
+	else
+		printk("%sNILFS: %pV\n", level, &vaf);
+	va_end(args);
+}
+
 static void nilfs_set_error(struct super_block *sb)
 {
 	struct the_nilfs *nilfs = sb->s_fs_info;
_
