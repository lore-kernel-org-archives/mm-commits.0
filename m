Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 342C9C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiAVGMy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:12:54 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43430 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiAVGMy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:12:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EDD560FB6
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2E6C004E1;
        Sat, 22 Jan 2022 06:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642831973;
        bh=4YfANcJSfNBF2qVZSQaNBFOj9Rm0b4YFpJUtBAeh2cs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=HfqYuAGWq5n7qhyr+lCOv6NVDnMA9woASsA6bdKIV1/OoXxf3cbXwgasAbFocsBWh
         oFfxigHsjGhmYC2tVPBU/A8V+RQPiQXM/YNDNsFFZJ7aeb7xMoGtC0lCoTxXzuUvg9
         /mNQEANhEZkDrSmORlNwNDgPq2Y43zl7gyBRRFmY=
Date:   Fri, 21 Jan 2022 22:12:52 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bfields@fieldses.org, crope@iki.fi,
        ebiederm@xmission.com, jlayton@kernel.org, keescook@chromium.org,
        kernel@tuxforce.de, linux-mm@kvack.org, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, nixiaoming@huawei.com, steve@sk2.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        yzaikin@google.com
Subject:  [patch 27/69] fs: move inode sysctls to its own file
Message-ID: <20220122061252.bFlFprkVs%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>
Subject: fs: move inode sysctls to its own file

Patch series "sysctl: 4th set of kernel/sysctl cleanups".

This is slimming down the fs uses of kernel/sysctl.c to the point that the
next step is to just get rid of the fs base directory for it and move that
elsehwere, so that next patch series starts dealing with that to demo how
we can end up cleaning up a full base directory from kernel/sysctl.c, one
at a time.


This patch (of 9):

kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we just
care about the core logic.

So move the inode sysctls to its own file.  Since we are no longer using
this outside of fs/ remove the extern declaration of its respective proc
helper.

We use early_initcall() as it is the earliest we can use.

[arnd@arndb.de: avoid unused-variable warning]
  Link: https://lkml.kernel.org/r/20211203190123.874239-1-arnd@kernel.org
Link: https://lkml.kernel.org/r/20211129205548.605569-1-mcgrof@kernel.org
Link: https://lkml.kernel.org/r/20211129205548.605569-2-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c         |   39 ++++++++++++++++++++++++++++++++-------
 include/linux/fs.h |    3 ---
 kernel/sysctl.c    |   14 --------------
 3 files changed, 32 insertions(+), 24 deletions(-)

--- a/fs/inode.c~fs-move-inode-sysctls-to-its-own-file
+++ a/fs/inode.c
@@ -67,11 +67,6 @@ const struct address_space_operations em
 };
 EXPORT_SYMBOL(empty_aops);
 
-/*
- * Statistics gathering..
- */
-struct inodes_stat_t inodes_stat;
-
 static DEFINE_PER_CPU(unsigned long, nr_inodes);
 static DEFINE_PER_CPU(unsigned long, nr_unused);
 
@@ -106,13 +101,43 @@ long get_nr_dirty_inodes(void)
  * Handle nr_inode sysctl
  */
 #ifdef CONFIG_SYSCTL
-int proc_nr_inodes(struct ctl_table *table, int write,
-		   void *buffer, size_t *lenp, loff_t *ppos)
+/*
+ * Statistics gathering..
+ */
+static struct inodes_stat_t inodes_stat;
+
+static int proc_nr_inodes(struct ctl_table *table, int write, void *buffer,
+			  size_t *lenp, loff_t *ppos)
 {
 	inodes_stat.nr_inodes = get_nr_inodes();
 	inodes_stat.nr_unused = get_nr_inodes_unused();
 	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 }
+
+static struct ctl_table inodes_sysctls[] = {
+	{
+		.procname	= "inode-nr",
+		.data		= &inodes_stat,
+		.maxlen		= 2*sizeof(long),
+		.mode		= 0444,
+		.proc_handler	= proc_nr_inodes,
+	},
+	{
+		.procname	= "inode-state",
+		.data		= &inodes_stat,
+		.maxlen		= 7*sizeof(long),
+		.mode		= 0444,
+		.proc_handler	= proc_nr_inodes,
+	},
+	{ }
+};
+
+static int __init init_fs_inode_sysctls(void)
+{
+	register_sysctl_init("fs", inodes_sysctls);
+	return 0;
+}
+early_initcall(init_fs_inode_sysctls);
 #endif
 
 static int no_open(struct inode *inode, struct file *file)
--- a/include/linux/fs.h~fs-move-inode-sysctls-to-its-own-file
+++ a/include/linux/fs.h
@@ -82,7 +82,6 @@ extern void __init files_maxfiles_init(v
 extern struct files_stat_struct files_stat;
 extern unsigned long get_max_files(void);
 extern unsigned int sysctl_nr_open;
-extern struct inodes_stat_t inodes_stat;
 extern int leases_enable, lease_break_time;
 extern int sysctl_protected_symlinks;
 extern int sysctl_protected_hardlinks;
@@ -3537,8 +3536,6 @@ int proc_nr_files(struct ctl_table *tabl
 		  void *buffer, size_t *lenp, loff_t *ppos);
 int proc_nr_dentry(struct ctl_table *table, int write,
 		  void *buffer, size_t *lenp, loff_t *ppos);
-int proc_nr_inodes(struct ctl_table *table, int write,
-		   void *buffer, size_t *lenp, loff_t *ppos);
 int __init list_bdev_fs_names(char *buf, size_t size);
 
 #define __FMODE_EXEC		((__force int) FMODE_EXEC)
--- a/kernel/sysctl.c~fs-move-inode-sysctls-to-its-own-file
+++ a/kernel/sysctl.c
@@ -2902,20 +2902,6 @@ static struct ctl_table vm_table[] = {
 
 static struct ctl_table fs_table[] = {
 	{
-		.procname	= "inode-nr",
-		.data		= &inodes_stat,
-		.maxlen		= 2*sizeof(long),
-		.mode		= 0444,
-		.proc_handler	= proc_nr_inodes,
-	},
-	{
-		.procname	= "inode-state",
-		.data		= &inodes_stat,
-		.maxlen		= 7*sizeof(long),
-		.mode		= 0444,
-		.proc_handler	= proc_nr_inodes,
-	},
-	{
 		.procname	= "file-nr",
 		.data		= &files_stat,
 		.maxlen		= sizeof(files_stat),
_
