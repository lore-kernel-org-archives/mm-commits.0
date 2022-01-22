Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF815C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:13:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbiAVGNQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:13:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43700 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbiAVGNP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:13:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19D8E60FB6
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B00C004E1;
        Sat, 22 Jan 2022 06:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642831994;
        bh=bhmavIWJ7wWBLtitN0KDh7eI3pwcfzNMzaKBHvK4W84=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bnt/h+7p9jOhibbP9sqeFY1Ts1CdPcS6Oqac+5IxHZFTeYukuCioU2u1QGLBTn/X9
         bW8y2Uz+grkU67ioOWJy7i1pjzcGf/DZZs3eQXrWTtaKJ7VRqEjaOosclBoi7WcRQa
         NmQiVUH8MWYwZ0vqR3QBH5EQ48KIy8+qW34kVmE4=
Date:   Fri, 21 Jan 2022 22:13:13 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        bfields@fieldses.org, crope@iki.fi, ebiederm@xmission.com,
        jlayton@kernel.org, keescook@chromium.org, kernel@tuxforce.de,
        linux-mm@kvack.org, mcgrof@kernel.org, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, steve@sk2.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        yzaikin@google.com
Subject:  [patch 33/69] fs: move namei sysctls to its own file
Message-ID: <20220122061313.NbzBORrQ4%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>
Subject: fs: move namei sysctls to its own file

kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we just
care about the core logic.

So move namei's own sysctl knobs to its own file.

Other than the move we also avoid initializing two static variables to 0
as this is not needed:

  * sysctl_protected_symlinks
  * sysctl_protected_hardlinks

Link: https://lkml.kernel.org/r/20211129205548.605569-8-mcgrof@kernel.org
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

 fs/namei.c         |   58 ++++++++++++++++++++++++++++++++++++++++---
 include/linux/fs.h |    1 
 kernel/sysctl.c    |   36 --------------------------
 3 files changed, 54 insertions(+), 41 deletions(-)

--- a/fs/namei.c~fs-move-namei-sysctls-to-its-own-file
+++ a/fs/namei.c
@@ -1020,10 +1020,60 @@ static inline void put_link(struct namei
 		path_put(&last->link);
 }
 
-int sysctl_protected_symlinks __read_mostly = 0;
-int sysctl_protected_hardlinks __read_mostly = 0;
-int sysctl_protected_fifos __read_mostly;
-int sysctl_protected_regular __read_mostly;
+static int sysctl_protected_symlinks __read_mostly;
+static int sysctl_protected_hardlinks __read_mostly;
+static int sysctl_protected_fifos __read_mostly;
+static int sysctl_protected_regular __read_mostly;
+
+#ifdef CONFIG_SYSCTL
+static struct ctl_table namei_sysctls[] = {
+	{
+		.procname	= "protected_symlinks",
+		.data		= &sysctl_protected_symlinks,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "protected_hardlinks",
+		.data		= &sysctl_protected_hardlinks,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "protected_fifos",
+		.data		= &sysctl_protected_fifos,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_TWO,
+	},
+	{
+		.procname	= "protected_regular",
+		.data		= &sysctl_protected_regular,
+		.maxlen		= sizeof(int),
+		.mode		= 0600,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_TWO,
+	},
+	{ }
+};
+
+static int __init init_fs_namei_sysctls(void)
+{
+	register_sysctl_init("fs", namei_sysctls);
+	return 0;
+}
+fs_initcall(init_fs_namei_sysctls);
+
+#endif /* CONFIG_SYSCTL */
 
 /**
  * may_follow_link - Check symlink following for unsafe situations
--- a/include/linux/fs.h~fs-move-namei-sysctls-to-its-own-file
+++ a/include/linux/fs.h
@@ -81,7 +81,6 @@ extern void __init files_maxfiles_init(v
 
 extern unsigned long get_max_files(void);
 extern unsigned int sysctl_nr_open;
-extern int leases_enable, lease_break_time;
 
 typedef __kernel_rwf_t rwf_t;
 
--- a/kernel/sysctl.c~fs-move-namei-sysctls-to-its-own-file
+++ a/kernel/sysctl.c
@@ -2898,42 +2898,6 @@ static struct ctl_table vm_table[] = {
 
 static struct ctl_table fs_table[] = {
 	{
-		.procname	= "protected_symlinks",
-		.data		= &sysctl_protected_symlinks,
-		.maxlen		= sizeof(int),
-		.mode		= 0600,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-	{
-		.procname	= "protected_hardlinks",
-		.data		= &sysctl_protected_hardlinks,
-		.maxlen		= sizeof(int),
-		.mode		= 0600,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-	{
-		.procname	= "protected_fifos",
-		.data		= &sysctl_protected_fifos,
-		.maxlen		= sizeof(int),
-		.mode		= 0600,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_TWO,
-	},
-	{
-		.procname	= "protected_regular",
-		.data		= &sysctl_protected_regular,
-		.maxlen		= sizeof(int),
-		.mode		= 0600,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_TWO,
-	},
-	{
 		.procname	= "suid_dumpable",
 		.data		= &suid_dumpable,
 		.maxlen		= sizeof(int),
_
