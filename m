Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46877C433FE
	for <mm-commits@archiver.kernel.org>; Mon, 29 Nov 2021 22:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236684AbhK2XBh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Nov 2021 18:01:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59258 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237002AbhK2XAk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Nov 2021 18:00:40 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3452B80D1E
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 22:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E35B6C53FC7;
        Mon, 29 Nov 2021 22:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638226640;
        bh=OHaL9QZwc+Yp3L2TGrl7rO40jXb2xw8xt2nHMBo05jE=;
        h=Date:From:To:Subject:From;
        b=iWB5tO8KBTYS+By9oTgTM9JFKb1Sj0CU0CfZQ5OHUo5qenxY0mQgRG/cZwVzEzuOi
         3YTKI7RqEloZxwX9dGUAkVqe2ObgmBJQOP1H6P0E+jhEl2gDoMFhKUZndyvYwN1nuY
         PF4SCZeiqsNnO3Kzh7lYyhZh+TejWjnjtdYTUoxw=
Date:   Mon, 29 Nov 2021 14:57:19 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        crope@iki.fi, ebiederm@xmission.com, jlayton@kernel.org,
        keescook@chromium.org, kernel@tuxforce.de, mcgrof@kernel.org,
        mchehab@kernel.org, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, steve@sk2.org, viro@zeniv.linux.org.uk,
        yzaikin@google.com
Subject:  + fs-move-dcache-sysctls-to-its-own-file.patch added to
 -mm tree
Message-ID: <20211129225719.lAwfgrj45%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: move dcache sysctls to its own file
has been added to the -mm tree.  Its filename is
     fs-move-dcache-sysctls-to-its-own-file.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-move-dcache-sysctls-to-its-own-file.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-move-dcache-sysctls-to-its-own-file.patch

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
Subject: fs: move dcache sysctls to its own file

kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we just
care about the core logic.

So move the dcache sysctl clutter out of kernel/sysctl.c.  This is a small
one-off entry, perhaps later we can simplify this representation, but for
now we use the helpers we have.  We won't know how we can simplify this
further untl we're fully done with the cleanup.

Link: https://lkml.kernel.org/r/20211129205548.605569-4-mcgrof@kernel.org
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
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dcache.c            |   32 +++++++++++++++++++++++++++++---
 include/linux/dcache.h |   10 ----------
 include/linux/fs.h     |    2 --
 kernel/sysctl.c        |    7 -------
 4 files changed, 29 insertions(+), 22 deletions(-)

--- a/fs/dcache.c~fs-move-dcache-sysctls-to-its-own-file
+++ a/fs/dcache.c
@@ -115,9 +115,17 @@ static inline struct hlist_bl_head *in_l
 	return in_lookup_hashtable + hash_32(hash, IN_LOOKUP_SHIFT);
 }
 
+struct dentry_stat_t {
+	long nr_dentry;
+	long nr_unused;
+	long age_limit;		/* age in seconds */
+	long want_pages;	/* pages requested by system */
+	long nr_negative;	/* # of unused negative dentries */
+	long dummy;		/* Reserved for future use */
+};
 
 /* Statistics gathering. */
-struct dentry_stat_t dentry_stat = {
+static struct dentry_stat_t dentry_stat = {
 	.age_limit = 45,
 };
 
@@ -167,14 +175,32 @@ static long get_nr_dentry_negative(void)
 	return sum < 0 ? 0 : sum;
 }
 
-int proc_nr_dentry(struct ctl_table *table, int write, void *buffer,
-		   size_t *lenp, loff_t *ppos)
+static int proc_nr_dentry(struct ctl_table *table, int write, void *buffer,
+			  size_t *lenp, loff_t *ppos)
 {
 	dentry_stat.nr_dentry = get_nr_dentry();
 	dentry_stat.nr_unused = get_nr_dentry_unused();
 	dentry_stat.nr_negative = get_nr_dentry_negative();
 	return proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 }
+
+static struct ctl_table fs_dcache_sysctls[] = {
+	{
+		.procname	= "dentry-state",
+		.data		= &dentry_stat,
+		.maxlen		= 6*sizeof(long),
+		.mode		= 0444,
+		.proc_handler	= proc_nr_dentry,
+	},
+	{ }
+};
+
+static int __init init_fs_dcache_sysctls(void)
+{
+	register_sysctl_init("fs", fs_dcache_sysctls);
+	return 0;
+}
+fs_initcall(init_fs_dcache_sysctls);
 #endif
 
 /*
--- a/include/linux/dcache.h~fs-move-dcache-sysctls-to-its-own-file
+++ a/include/linux/dcache.h
@@ -61,16 +61,6 @@ extern const struct qstr empty_name;
 extern const struct qstr slash_name;
 extern const struct qstr dotdot_name;
 
-struct dentry_stat_t {
-	long nr_dentry;
-	long nr_unused;
-	long age_limit;		/* age in seconds */
-	long want_pages;	/* pages requested by system */
-	long nr_negative;	/* # of unused negative dentries */
-	long dummy;		/* Reserved for future use */
-};
-extern struct dentry_stat_t dentry_stat;
-
 /*
  * Try to keep struct dentry aligned on 64 byte cachelines (this will
  * give reasonable cacheline footprint with larger lines without the
--- a/include/linux/fs.h~fs-move-dcache-sysctls-to-its-own-file
+++ a/include/linux/fs.h
@@ -3590,8 +3590,6 @@ ssize_t simple_attr_write(struct file *f
 			  size_t len, loff_t *ppos);
 
 struct ctl_table;
-int proc_nr_dentry(struct ctl_table *table, int write,
-		  void *buffer, size_t *lenp, loff_t *ppos);
 int __init list_bdev_fs_names(char *buf, size_t size);
 
 #define __FMODE_EXEC		((__force int) FMODE_EXEC)
--- a/kernel/sysctl.c~fs-move-dcache-sysctls-to-its-own-file
+++ a/kernel/sysctl.c
@@ -2901,13 +2901,6 @@ static struct ctl_table vm_table[] = {
 
 static struct ctl_table fs_table[] = {
 	{
-		.procname	= "dentry-state",
-		.data		= &dentry_stat,
-		.maxlen		= 6*sizeof(long),
-		.mode		= 0444,
-		.proc_handler	= proc_nr_dentry,
-	},
-	{
 		.procname	= "overflowuid",
 		.data		= &fs_overflowuid,
 		.maxlen		= sizeof(int),
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

