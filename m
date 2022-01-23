Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71A0BC433F5
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbiAWX5R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:57:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46078 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240506AbiAWX5R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:57:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7989FB80E44
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:57:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C040CC340E3;
        Sun, 23 Jan 2022 23:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982235;
        bh=4Q/Ecvf5UvNITUdwf6ONZl8XFLYGB8bZD0D+WNt61XI=;
        h=Date:From:To:Subject:From;
        b=v8ZTGQlhcd+E6lXmjeuKY1D+rEG5lJmN51vvvaCDKvCF/qBrD89tcHjrG5pstHAgb
         aN8i5NtAiJ+SeL7bc1gx/dpxOBoIGMuriSQaDUD1/BBYbmQJ7cZV74lQy4aZYCRnRR
         tLSGKw6ONVfLywMZWmdum/cG3xNRJiSOeNyT6tfk=
Date:   Sun, 23 Jan 2022 15:57:14 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        crope@iki.fi, ebiederm@xmission.com, jlayton@kernel.org,
        keescook@chromium.org, kernel@tuxforce.de, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, nixiaoming@huawei.com, steve@sk2.org,
        viro@zeniv.linux.org.uk, yzaikin@google.com
Subject:  [merged] fs-move-namei-sysctls-to-its-own-file.patch
 removed from -mm tree
Message-ID: <20220123235714.gk5--9mgc%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: move namei sysctls to its own file
has been removed from the -mm tree.  Its filename was
     fs-move-namei-sysctls-to-its-own-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from mcgrof@kernel.org are


