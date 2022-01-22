Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF9EC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiAVGM7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiAVGM6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:12:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03418C06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 22:12:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9490060ED1
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:12:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C086C004E1;
        Sat, 22 Jan 2022 06:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642831977;
        bh=tfDkqcwbMhy0YzW8zs1QqZkmQryXIARdLyPa9zShlFA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AvXXm0RydfToxXPXH2QuC6viTaDtZF/GzP72OjW8Q7OUmrpWjtZtYQCBjbUIci5dW
         St8qCOYnT2MBFoXW4z7deaW40k6Afb/IP5z2GIulTiKy0rxFSpTy41mpvyayg2mC42
         NygWA6UmPHfSDuOvA1PzTAODsQchqWZqKG1xf3zo=
Date:   Fri, 21 Jan 2022 22:12:56 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        bfields@fieldses.org, crope@iki.fi, ebiederm@xmission.com,
        jlayton@kernel.org, keescook@chromium.org, kernel@tuxforce.de,
        linux-mm@kvack.org, mcgrof@kernel.org, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, steve@sk2.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        yzaikin@google.com
Subject:  [patch 28/69] fs: move fs stat sysctls to file_table.c
Message-ID: <20220122061256.hX9cGxdpN%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>
Subject: fs: move fs stat sysctls to file_table.c

kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we just
care about the core logic.

We can create the sysctl dynamically on early init for fs stat to help
with this clutter.  This dusts off the fs stat syctls knobs and puts them
into where they are declared.

Link: https://lkml.kernel.org/r/20211129205548.605569-3-mcgrof@kernel.org
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

 fs/file_table.c    |   47 +++++++++++++++++++++++++++++++++++--------
 include/linux/fs.h |    3 --
 kernel/sysctl.c    |   25 ----------------------
 3 files changed, 39 insertions(+), 36 deletions(-)

--- a/fs/file_table.c~fs-move-fs-stat-sysctls-to-file_tablec
+++ a/fs/file_table.c
@@ -33,7 +33,7 @@
 #include "internal.h"
 
 /* sysctl tunables... */
-struct files_stat_struct files_stat = {
+static struct files_stat_struct files_stat = {
 	.max_files = NR_FILE
 };
 
@@ -75,22 +75,53 @@ unsigned long get_max_files(void)
 }
 EXPORT_SYMBOL_GPL(get_max_files);
 
+#if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
+
 /*
  * Handle nr_files sysctl
  */
-#if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
-int proc_nr_files(struct ctl_table *table, int write,
-                     void *buffer, size_t *lenp, loff_t *ppos)
+static int proc_nr_files(struct ctl_table *table, int write, void *buffer,
+			 size_t *lenp, loff_t *ppos)
 {
 	files_stat.nr_files = get_nr_files();
 	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 }
-#else
-int proc_nr_files(struct ctl_table *table, int write,
-                     void *buffer, size_t *lenp, loff_t *ppos)
+
+static struct ctl_table fs_stat_sysctls[] = {
+	{
+		.procname	= "file-nr",
+		.data		= &files_stat,
+		.maxlen		= sizeof(files_stat),
+		.mode		= 0444,
+		.proc_handler	= proc_nr_files,
+	},
+	{
+		.procname	= "file-max",
+		.data		= &files_stat.max_files,
+		.maxlen		= sizeof(files_stat.max_files),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+		.extra1		= SYSCTL_LONG_ZERO,
+		.extra2		= SYSCTL_LONG_MAX,
+	},
+	{
+		.procname	= "nr_open",
+		.data		= &sysctl_nr_open,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &sysctl_nr_open_min,
+		.extra2		= &sysctl_nr_open_max,
+	},
+	{ }
+};
+
+static int __init init_fs_stat_sysctls(void)
 {
-	return -ENOSYS;
+	register_sysctl_init("fs", fs_stat_sysctls);
+	return 0;
 }
+fs_initcall(init_fs_stat_sysctls);
 #endif
 
 static struct file *__alloc_file(int flags, const struct cred *cred)
--- a/include/linux/fs.h~fs-move-fs-stat-sysctls-to-file_tablec
+++ a/include/linux/fs.h
@@ -79,7 +79,6 @@ extern void __init inode_init_early(void
 extern void __init files_init(void);
 extern void __init files_maxfiles_init(void);
 
-extern struct files_stat_struct files_stat;
 extern unsigned long get_max_files(void);
 extern unsigned int sysctl_nr_open;
 extern int leases_enable, lease_break_time;
@@ -3532,8 +3531,6 @@ ssize_t simple_attr_write(struct file *f
 			  size_t len, loff_t *ppos);
 
 struct ctl_table;
-int proc_nr_files(struct ctl_table *table, int write,
-		  void *buffer, size_t *lenp, loff_t *ppos);
 int proc_nr_dentry(struct ctl_table *table, int write,
 		  void *buffer, size_t *lenp, loff_t *ppos);
 int __init list_bdev_fs_names(char *buf, size_t size);
--- a/kernel/sysctl.c~fs-move-fs-stat-sysctls-to-file_tablec
+++ a/kernel/sysctl.c
@@ -2902,31 +2902,6 @@ static struct ctl_table vm_table[] = {
 
 static struct ctl_table fs_table[] = {
 	{
-		.procname	= "file-nr",
-		.data		= &files_stat,
-		.maxlen		= sizeof(files_stat),
-		.mode		= 0444,
-		.proc_handler	= proc_nr_files,
-	},
-	{
-		.procname	= "file-max",
-		.data		= &files_stat.max_files,
-		.maxlen		= sizeof(files_stat.max_files),
-		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax,
-		.extra1		= SYSCTL_LONG_ZERO,
-		.extra2		= SYSCTL_LONG_MAX,
-	},
-	{
-		.procname	= "nr_open",
-		.data		= &sysctl_nr_open,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &sysctl_nr_open_min,
-		.extra2		= &sysctl_nr_open_max,
-	},
-	{
 		.procname	= "dentry-state",
 		.data		= &dentry_stat,
 		.maxlen		= 6*sizeof(long),
_
