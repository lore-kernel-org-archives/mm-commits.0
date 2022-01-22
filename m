Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B926BC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:13:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbiAVGNY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:13:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54570 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbiAVGNX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:13:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFA9FB81FD1
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE137C340E0;
        Sat, 22 Jan 2022 06:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642832001;
        bh=18MdwRSTrPGpfsY5dZxrhgLaaC0bbvoLQDoXZgFE2sA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=M4ncYt07KZP848QzMAqC+4V60hE/AuIQHtri+OXOV4FI819yl/TUYaw+LFzJu3Uwk
         TLhkEFBDNW0g/QOVrB5eM5D7jnJY1sRorD67rFLgBQVFJFrqloNbgXY1IxzyETObyA
         fCVZ1IjYt1jftpCpMq4VjY8kE6MbwKwOxZJwoMPc=
Date:   Fri, 21 Jan 2022 22:13:20 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        bfields@fieldses.org, crope@iki.fi, ebiederm@xmission.com,
        jlayton@kernel.org, keescook@chromium.org, kernel@tuxforce.de,
        linux-mm@kvack.org, mcgrof@kernel.org, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, steve@sk2.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        yzaikin@google.com
Subject:  [patch 35/69] fs: move pipe sysctls to is own file
Message-ID: <20220122061320.NGMi47vlv%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>
Subject: fs: move pipe sysctls to is own file

kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we just
care about the core logic.

So move the pipe sysctls to its own file.

Link: https://lkml.kernel.org/r/20211129205548.605569-10-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/pipe.c                 |   64 ++++++++++++++++++++++++++++++++++--
 include/linux/pipe_fs_i.h |    4 --
 include/linux/sysctl.h    |    6 +++
 kernel/sysctl.c           |   61 +++-------------------------------
 4 files changed, 73 insertions(+), 62 deletions(-)

--- a/fs/pipe.c~fs-move-pipe-sysctls-to-is-own-file
+++ a/fs/pipe.c
@@ -25,6 +25,7 @@
 #include <linux/fcntl.h>
 #include <linux/memcontrol.h>
 #include <linux/watch_queue.h>
+#include <linux/sysctl.h>
 
 #include <linux/uaccess.h>
 #include <asm/ioctls.h>
@@ -50,13 +51,13 @@
  * The max size that a non-root user is allowed to grow the pipe. Can
  * be set by root in /proc/sys/fs/pipe-max-size
  */
-unsigned int pipe_max_size = 1048576;
+static unsigned int pipe_max_size = 1048576;
 
 /* Maximum allocatable pages per user. Hard limit is unset by default, soft
  * matches default values.
  */
-unsigned long pipe_user_pages_hard;
-unsigned long pipe_user_pages_soft = PIPE_DEF_BUFFERS * INR_OPEN_CUR;
+static unsigned long pipe_user_pages_hard;
+static unsigned long pipe_user_pages_soft = PIPE_DEF_BUFFERS * INR_OPEN_CUR;
 
 /*
  * We use head and tail indices that aren't masked off, except at the point of
@@ -1428,6 +1429,60 @@ static struct file_system_type pipe_fs_t
 	.kill_sb	= kill_anon_super,
 };
 
+#ifdef CONFIG_SYSCTL
+static int do_proc_dopipe_max_size_conv(unsigned long *lvalp,
+					unsigned int *valp,
+					int write, void *data)
+{
+	if (write) {
+		unsigned int val;
+
+		val = round_pipe_size(*lvalp);
+		if (val == 0)
+			return -EINVAL;
+
+		*valp = val;
+	} else {
+		unsigned int val = *valp;
+		*lvalp = (unsigned long) val;
+	}
+
+	return 0;
+}
+
+static int proc_dopipe_max_size(struct ctl_table *table, int write,
+				void *buffer, size_t *lenp, loff_t *ppos)
+{
+	return do_proc_douintvec(table, write, buffer, lenp, ppos,
+				 do_proc_dopipe_max_size_conv, NULL);
+}
+
+static struct ctl_table fs_pipe_sysctls[] = {
+	{
+		.procname	= "pipe-max-size",
+		.data		= &pipe_max_size,
+		.maxlen		= sizeof(pipe_max_size),
+		.mode		= 0644,
+		.proc_handler	= proc_dopipe_max_size,
+	},
+	{
+		.procname	= "pipe-user-pages-hard",
+		.data		= &pipe_user_pages_hard,
+		.maxlen		= sizeof(pipe_user_pages_hard),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+	{
+		.procname	= "pipe-user-pages-soft",
+		.data		= &pipe_user_pages_soft,
+		.maxlen		= sizeof(pipe_user_pages_soft),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+	{ }
+};
+#endif
+
 static int __init init_pipe_fs(void)
 {
 	int err = register_filesystem(&pipe_fs_type);
@@ -1439,6 +1494,9 @@ static int __init init_pipe_fs(void)
 			unregister_filesystem(&pipe_fs_type);
 		}
 	}
+#ifdef CONFIG_SYSCTL
+	register_sysctl_init("fs", fs_pipe_sysctls);
+#endif
 	return err;
 }
 
--- a/include/linux/pipe_fs_i.h~fs-move-pipe-sysctls-to-is-own-file
+++ a/include/linux/pipe_fs_i.h
@@ -238,10 +238,6 @@ void pipe_lock(struct pipe_inode_info *)
 void pipe_unlock(struct pipe_inode_info *);
 void pipe_double_lock(struct pipe_inode_info *, struct pipe_inode_info *);
 
-extern unsigned int pipe_max_size;
-extern unsigned long pipe_user_pages_hard;
-extern unsigned long pipe_user_pages_soft;
-
 /* Wait for a pipe to be readable/writable while dropping the pipe lock */
 void pipe_wait_readable(struct pipe_inode_info *);
 void pipe_wait_writable(struct pipe_inode_info *);
--- a/include/linux/sysctl.h~fs-move-pipe-sysctls-to-is-own-file
+++ a/include/linux/sysctl.h
@@ -221,6 +221,12 @@ extern void __register_sysctl_init(const
 extern struct ctl_table_header *register_sysctl_mount_point(const char *path);
 
 void do_sysctl_args(void);
+int do_proc_douintvec(struct ctl_table *table, int write,
+		      void *buffer, size_t *lenp, loff_t *ppos,
+		      int (*conv)(unsigned long *lvalp,
+				  unsigned int *valp,
+				  int write, void *data),
+		      void *data);
 
 extern int pwrsw_enabled;
 extern int unaligned_enabled;
--- a/kernel/sysctl.c~fs-move-pipe-sysctls-to-is-own-file
+++ a/kernel/sysctl.c
@@ -57,7 +57,6 @@
 #include <linux/ftrace.h>
 #include <linux/perf_event.h>
 #include <linux/kprobes.h>
-#include <linux/pipe_fs_i.h>
 #include <linux/oom.h>
 #include <linux/kmod.h>
 #include <linux/capability.h>
@@ -761,12 +760,12 @@ static int __do_proc_douintvec(void *tbl
 	return do_proc_douintvec_r(i, buffer, lenp, ppos, conv, data);
 }
 
-static int do_proc_douintvec(struct ctl_table *table, int write,
-			     void *buffer, size_t *lenp, loff_t *ppos,
-			     int (*conv)(unsigned long *lvalp,
-					 unsigned int *valp,
-					 int write, void *data),
-			     void *data)
+int do_proc_douintvec(struct ctl_table *table, int write,
+		      void *buffer, size_t *lenp, loff_t *ppos,
+		      int (*conv)(unsigned long *lvalp,
+				  unsigned int *valp,
+				  int write, void *data),
+		      void *data)
 {
 	return __do_proc_douintvec(table->data, table, write,
 				   buffer, lenp, ppos, conv, data);
@@ -1090,33 +1089,6 @@ int proc_dou8vec_minmax(struct ctl_table
 }
 EXPORT_SYMBOL_GPL(proc_dou8vec_minmax);
 
-static int do_proc_dopipe_max_size_conv(unsigned long *lvalp,
-					unsigned int *valp,
-					int write, void *data)
-{
-	if (write) {
-		unsigned int val;
-
-		val = round_pipe_size(*lvalp);
-		if (val == 0)
-			return -EINVAL;
-
-		*valp = val;
-	} else {
-		unsigned int val = *valp;
-		*lvalp = (unsigned long) val;
-	}
-
-	return 0;
-}
-
-static int proc_dopipe_max_size(struct ctl_table *table, int write,
-				void *buffer, size_t *lenp, loff_t *ppos)
-{
-	return do_proc_douintvec(table, write, buffer, lenp, ppos,
-				 do_proc_dopipe_max_size_conv, NULL);
-}
-
 #ifdef CONFIG_MAGIC_SYSRQ
 static int sysrq_sysctl_handler(struct ctl_table *table, int write,
 				void *buffer, size_t *lenp, loff_t *ppos)
@@ -2841,27 +2813,6 @@ static struct ctl_table vm_table[] = {
 
 static struct ctl_table fs_table[] = {
 	{
-		.procname	= "pipe-max-size",
-		.data		= &pipe_max_size,
-		.maxlen		= sizeof(pipe_max_size),
-		.mode		= 0644,
-		.proc_handler	= proc_dopipe_max_size,
-	},
-	{
-		.procname	= "pipe-user-pages-hard",
-		.data		= &pipe_user_pages_hard,
-		.maxlen		= sizeof(pipe_user_pages_hard),
-		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax,
-	},
-	{
-		.procname	= "pipe-user-pages-soft",
-		.data		= &pipe_user_pages_soft,
-		.maxlen		= sizeof(pipe_user_pages_soft),
-		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax,
-	},
-	{
 		.procname	= "mount-max",
 		.data		= &sysctl_mount_max,
 		.maxlen		= sizeof(unsigned int),
_
