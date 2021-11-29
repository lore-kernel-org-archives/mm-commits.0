Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8F35C433EF
	for <mm-commits@archiver.kernel.org>; Mon, 29 Nov 2021 23:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbhK2XQj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Nov 2021 18:16:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232418AbhK2XQR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Nov 2021 18:16:17 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE03C0613B6
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 14:57:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 10D25CE16B9
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 22:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C170AC53FC7;
        Mon, 29 Nov 2021 22:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638226626;
        bh=V29S0V+LpC7/ntq9xYSZg5bTNDNH/Nk7ZXlrlV+gKB0=;
        h=Date:From:To:Subject:From;
        b=tiI8nFq0d7/5Aagvm2P0eQjXk1mYDiejGrCrwIU2aF4oLg7MLj6lquP1GtOm/WB4v
         Y0KGaW+3S7/NCHe9CBusYnc6vuYd/yvIb0E3aEY6K0htyFlfp7HsVt75bULxNdMPsg
         4TbUaTLDSLF2q1xX1MYNnJlAtoaxujuONJ3Azrk0=
Date:   Mon, 29 Nov 2021 14:57:04 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        crope@iki.fi, ebiederm@xmission.com, jlayton@kernel.org,
        keescook@chromium.org, kernel@tuxforce.de, mcgrof@kernel.org,
        mchehab@kernel.org, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, steve@sk2.org, viro@zeniv.linux.org.uk,
        yzaikin@google.com
Subject:  + fs-move-inode-sysctls-to-its-own-file.patch added to
 -mm tree
Message-ID: <20211129225704.f8c1172rI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: move inode sysctls to its own file
has been added to the -mm tree.  Its filename is
     fs-move-inode-sysctls-to-its-own-file.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-move-inode-sysctls-to-its-own-file.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-move-inode-sysctls-to-its-own-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Link: https://lkml.kernel.org/r/20211129205548.605569-1-mcgrof@kernel.org
Link: https://lkml.kernel.org/r/20211129205548.605569-2-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c         |   31 ++++++++++++++++++++++++++++---
 include/linux/fs.h |    3 ---
 kernel/sysctl.c    |   14 --------------
 3 files changed, 28 insertions(+), 20 deletions(-)

--- a/fs/inode.c~fs-move-inode-sysctls-to-its-own-file
+++ a/fs/inode.c
@@ -70,7 +70,7 @@ EXPORT_SYMBOL(empty_aops);
 /*
  * Statistics gathering..
  */
-struct inodes_stat_t inodes_stat;
+static struct inodes_stat_t inodes_stat;
 
 static DEFINE_PER_CPU(unsigned long, nr_inodes);
 static DEFINE_PER_CPU(unsigned long, nr_unused);
@@ -106,13 +106,38 @@ long get_nr_dirty_inodes(void)
  * Handle nr_inode sysctl
  */
 #ifdef CONFIG_SYSCTL
-int proc_nr_inodes(struct ctl_table *table, int write,
-		   void *buffer, size_t *lenp, loff_t *ppos)
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
@@ -81,7 +81,6 @@ extern void __init files_maxfiles_init(v
 extern struct files_stat_struct files_stat;
 extern unsigned long get_max_files(void);
 extern unsigned int sysctl_nr_open;
-extern struct inodes_stat_t inodes_stat;
 extern int leases_enable, lease_break_time;
 extern int sysctl_protected_symlinks;
 extern int sysctl_protected_hardlinks;
@@ -3596,8 +3595,6 @@ int proc_nr_files(struct ctl_table *tabl
 		  void *buffer, size_t *lenp, loff_t *ppos);
 int proc_nr_dentry(struct ctl_table *table, int write,
 		  void *buffer, size_t *lenp, loff_t *ppos);
-int proc_nr_inodes(struct ctl_table *table, int write,
-		   void *buffer, size_t *lenp, loff_t *ppos);
 int __init list_bdev_fs_names(char *buf, size_t size);
 
 #define __FMODE_EXEC		((__force int) FMODE_EXEC)
--- a/kernel/sysctl.c~fs-move-inode-sysctls-to-its-own-file
+++ a/kernel/sysctl.c
@@ -2901,20 +2901,6 @@ static struct ctl_table vm_table[] = {
 
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

Patches currently in -mm which might be from mcgrof@kernel.org are

zram-use-attribute_groups.patch
hpet-simplify-subdirectory-registration-with-register_sysctl.patch
i915-simplify-subdirectory-registration-with-register_sysctl.patch
macintosh-mac_hidc-simplify-subdirectory-registration-with-register_sysctl.patch
ocfs2-simplify-subdirectory-registration-with-register_sysctl.patch
test_sysctl-simplify-subdirectory-registration-with-register_sysctl.patch
inotify-simplify-subdirectory-registration-with-register_sysctl-fix.patch
cdrom-simplify-subdirectory-registration-with-register_sysctl.patch
sysctl-add-helper-to-register-a-sysctl-mount-point.patch
fs-move-binfmt_misc-sysctl-to-its-own-file.patch
sysctl-share-unsigned-long-const-values.patch
fs-move-inode-sysctls-to-its-own-file.patch
fs-move-fs-stat-sysctls-to-file_tablec.patch
fs-move-dcache-sysctls-to-its-own-file.patch
sysctl-move-maxolduid-as-a-sysctl-specific-const.patch
fs-move-shared-sysctls-to-fs-sysctlsc.patch
fs-move-locking-sysctls-where-they-are-used.patch
fs-move-namei-sysctls-to-its-own-file.patch
fs-move-fs-execc-sysctls-into-its-own-file.patch
fs-move-pipe-sysctls-to-is-own-file.patch
sysctl-add-and-use-base-directory-declarer-and-registration-helper.patch
fs-move-namespace-sysctls-and-declare-fs-base-directory.patch
kernel-sysctlc-rename-sysctl_init-to-sysctl_init_bases.patch

