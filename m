Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C31C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235111AbiAWX5N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:57:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52242 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240506AbiAWX5N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:57:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7930611E9
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB550C340E3;
        Sun, 23 Jan 2022 23:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982232;
        bh=TQWs8ValP5TRX+jXU6fH1Oqr884Sph3k7E2JoehAMpw=;
        h=Date:From:To:Subject:From;
        b=QPb2PlpJW9OneTno6eA4iF1fC8E+J8nGdRNtNg48igTZ54AJW0CUl+WDmUBp4iAWD
         8G+UntrdVPnaXjzne+hQE86ra1EsHLAWrFY7qRo2oNJsh8jB3NQ8mSZzcGKq/4D6r0
         maspKZLfFgBgm5hVq3jySFwzZ5KsTuisF3R0Nr6E=
Date:   Sun, 23 Jan 2022 15:57:11 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        crope@iki.fi, ebiederm@xmission.com, jlayton@kernel.org,
        keescook@chromium.org, kernel@tuxforce.de, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, nixiaoming@huawei.com, steve@sk2.org,
        viro@zeniv.linux.org.uk, yzaikin@google.com
Subject:  [merged]
 fs-move-locking-sysctls-where-they-are-used.patch removed from -mm tree
Message-ID: <20220123235711.plDTxjL0d%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: move locking sysctls where they are used
has been removed from the -mm tree.  Its filename was
     fs-move-locking-sysctls-where-they-are-used.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: fs: move locking sysctls where they are used

kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we just
care about the core logic.

The locking fs sysctls are only used on fs/locks.c, so move them there.

Link: https://lkml.kernel.org/r/20211129205548.605569-7-mcgrof@kernel.org
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

 fs/locks.c         |   34 ++++++++++++++++++++++++++++++++--
 include/linux/fs.h |    4 ----
 kernel/sysctl.c    |   20 --------------------
 3 files changed, 32 insertions(+), 26 deletions(-)

--- a/fs/locks.c~fs-move-locking-sysctls-where-they-are-used
+++ a/fs/locks.c
@@ -62,6 +62,7 @@
 #include <linux/pid_namespace.h>
 #include <linux/hashtable.h>
 #include <linux/percpu.h>
+#include <linux/sysctl.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/filelock.h>
@@ -88,8 +89,37 @@ static int target_leasetype(struct file_
 	return fl->fl_type;
 }
 
-int leases_enable = 1;
-int lease_break_time = 45;
+static int leases_enable = 1;
+static int lease_break_time = 45;
+
+#ifdef CONFIG_SYSCTL
+static struct ctl_table locks_sysctls[] = {
+	{
+		.procname	= "leases-enable",
+		.data		= &leases_enable,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#ifdef CONFIG_MMU
+	{
+		.procname	= "lease-break-time",
+		.data		= &lease_break_time,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif /* CONFIG_MMU */
+	{}
+};
+
+static int __init init_fs_locks_sysctls(void)
+{
+	register_sysctl_init("fs", locks_sysctls);
+	return 0;
+}
+early_initcall(init_fs_locks_sysctls);
+#endif /* CONFIG_SYSCTL */
 
 /*
  * The global file_lock_list is only used for displaying /proc/locks, so we
--- a/include/linux/fs.h~fs-move-locking-sysctls-where-they-are-used
+++ a/include/linux/fs.h
@@ -82,10 +82,6 @@ extern void __init files_maxfiles_init(v
 extern unsigned long get_max_files(void);
 extern unsigned int sysctl_nr_open;
 extern int leases_enable, lease_break_time;
-extern int sysctl_protected_symlinks;
-extern int sysctl_protected_hardlinks;
-extern int sysctl_protected_fifos;
-extern int sysctl_protected_regular;
 
 typedef __kernel_rwf_t rwf_t;
 
--- a/kernel/sysctl.c~fs-move-locking-sysctls-where-they-are-used
+++ a/kernel/sysctl.c
@@ -2897,26 +2897,6 @@ static struct ctl_table vm_table[] = {
 };
 
 static struct ctl_table fs_table[] = {
-#ifdef CONFIG_FILE_LOCKING
-	{
-		.procname	= "leases-enable",
-		.data		= &leases_enable,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
-#ifdef CONFIG_MMU
-#ifdef CONFIG_FILE_LOCKING
-	{
-		.procname	= "lease-break-time",
-		.data		= &lease_break_time,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
-#endif
 	{
 		.procname	= "protected_symlinks",
 		.data		= &sysctl_protected_symlinks,
_

Patches currently in -mm which might be from mcgrof@kernel.org are


