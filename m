Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16452C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbiAVGND (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:13:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbiAVGND (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:13:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B048C06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 22:13:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C605DB8215F
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:13:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01565C004E1;
        Sat, 22 Jan 2022 06:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642831980;
        bh=SbyuF6qNTcautbI5FXf6fjhDRgkTddAZP1P63TzlDnw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=yy09YaRAUIDFNGkwU33TovdK4LL0OcvfD9rePdRAWdKLMmq76yNq5Pgt5Vv1rQRDA
         QxSDFki6exc1kqHwiFnKhQBQihXSlOInwFPHhhgOiXGj8inkKvW0ii8flP7AydTdVY
         xJH9oEpjyT9ToilPUadLh7vlBtFct9eEcsloEH50=
Date:   Fri, 21 Jan 2022 22:12:59 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bfields@fieldses.org, crope@iki.fi,
        ebiederm@xmission.com, jlayton@kernel.org, keescook@chromium.org,
        kernel@tuxforce.de, linux-mm@kvack.org, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, nixiaoming@huawei.com, steve@sk2.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        yzaikin@google.com
Subject:  [patch 29/69] fs: move dcache sysctls to its own file
Message-ID: <20220122061259.xZLRERL73%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

[arnd@arndb.de: avoid unused-function warning]
  Link: https://lkml.kernel.org/r/20211203190123.874239-2-arnd@kernel.org
Link: https://lkml.kernel.org/r/20211129205548.605569-4-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
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

 fs/dcache.c            |   37 +++++++++++++++++++++++++++++++------
 include/linux/dcache.h |   10 ----------
 include/linux/fs.h     |    2 --
 kernel/sysctl.c        |    7 -------
 4 files changed, 31 insertions(+), 25 deletions(-)

--- a/fs/dcache.c~fs-move-dcache-sysctls-to-its-own-file
+++ a/fs/dcache.c
@@ -115,10 +115,13 @@ static inline struct hlist_bl_head *in_l
 	return in_lookup_hashtable + hash_32(hash, IN_LOOKUP_SHIFT);
 }
 
-
-/* Statistics gathering. */
-struct dentry_stat_t dentry_stat = {
-	.age_limit = 45,
+struct dentry_stat_t {
+	long nr_dentry;
+	long nr_unused;
+	long age_limit;		/* age in seconds */
+	long want_pages;	/* pages requested by system */
+	long nr_negative;	/* # of unused negative dentries */
+	long dummy;		/* Reserved for future use */
 };
 
 static DEFINE_PER_CPU(long, nr_dentry);
@@ -126,6 +129,10 @@ static DEFINE_PER_CPU(long, nr_dentry_un
 static DEFINE_PER_CPU(long, nr_dentry_negative);
 
 #if defined(CONFIG_SYSCTL) && defined(CONFIG_PROC_FS)
+/* Statistics gathering. */
+static struct dentry_stat_t dentry_stat = {
+	.age_limit = 45,
+};
 
 /*
  * Here we resort to our own counters instead of using generic per-cpu counters
@@ -167,14 +174,32 @@ static long get_nr_dentry_negative(void)
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
@@ -3531,8 +3531,6 @@ ssize_t simple_attr_write(struct file *f
 			  size_t len, loff_t *ppos);
 
 struct ctl_table;
-int proc_nr_dentry(struct ctl_table *table, int write,
-		  void *buffer, size_t *lenp, loff_t *ppos);
 int __init list_bdev_fs_names(char *buf, size_t size);
 
 #define __FMODE_EXEC		((__force int) FMODE_EXEC)
--- a/kernel/sysctl.c~fs-move-dcache-sysctls-to-its-own-file
+++ a/kernel/sysctl.c
@@ -2902,13 +2902,6 @@ static struct ctl_table vm_table[] = {
 
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
