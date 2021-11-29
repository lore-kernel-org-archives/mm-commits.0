Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B8F1C4167B
	for <mm-commits@archiver.kernel.org>; Mon, 29 Nov 2021 22:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237091AbhK2XBj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Nov 2021 18:01:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59400 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235736AbhK2XAv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Nov 2021 18:00:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E495BB80D1E
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 22:57:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26861C53FC7;
        Mon, 29 Nov 2021 22:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638226650;
        bh=JZbZ/CEQRmUYjB4TW7AAV8OLI3o17+Jp+R7dlBQNThI=;
        h=Date:From:To:Subject:From;
        b=oarViCT4crC9INhgdGwSApvqTwOf/xtyK44il4oYwao2kGlmMrdtVPbRm/rIuNef3
         VdsbBY4PN4yj3kPoQ+1kpxdk2AR39d4FF/3tPYExHHCEUxpCdMZ2sp031ERIoSr1gv
         5NEcDOK/Lpyh9iddIZX4Gx/3KcYxadHu7LnYXExU=
Date:   Mon, 29 Nov 2021 14:57:29 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        crope@iki.fi, ebiederm@xmission.com, jlayton@kernel.org,
        keescook@chromium.org, kernel@tuxforce.de, mcgrof@kernel.org,
        mchehab@kernel.org, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, steve@sk2.org, viro@zeniv.linux.org.uk,
        yzaikin@google.com
Subject:  + fs-move-locking-sysctls-where-they-are-used.patch added
 to -mm tree
Message-ID: <20211129225729.eNroROqwR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: move locking sysctls where they are used
has been added to the -mm tree.  Its filename is
     fs-move-locking-sysctls-where-they-are-used.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-move-locking-sysctls-where-they-are-used.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-move-locking-sysctls-where-they-are-used.patch

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
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
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
@@ -81,10 +81,6 @@ extern void __init files_maxfiles_init(v
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
@@ -2896,26 +2896,6 @@ static struct ctl_table vm_table[] = {
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

