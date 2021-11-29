Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 298ADC43217
	for <mm-commits@archiver.kernel.org>; Mon, 29 Nov 2021 22:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbhK2XBs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Nov 2021 18:01:48 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:40800 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236256AbhK2XA4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Nov 2021 18:00:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 62625CE16B9
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 22:57:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5DCC53FAD;
        Mon, 29 Nov 2021 22:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638226653;
        bh=oHmTFw9UQ7gIb5ezB8btLjNraN9m/TfBgdiVVaXfhbY=;
        h=Date:From:To:Subject:From;
        b=pglqyHoO6FIKFiyJvZz0TqX0h/6SXjRScsd/1BdDHys/21A3fiA//8D4Xj52yNpBb
         YoD8UaKBylvTmNN5BCXTKpIDY/BCPvAXgPlDBKXJ5OjmGneBQZhOXkX1AZeXpPPXEZ
         1jyLFBuWzuSMYPHUB+mgA6MrLW1mBnhpO8aMQOt8=
Date:   Mon, 29 Nov 2021 14:57:32 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        crope@iki.fi, ebiederm@xmission.com, jlayton@kernel.org,
        keescook@chromium.org, kernel@tuxforce.de, mcgrof@kernel.org,
        mchehab@kernel.org, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, steve@sk2.org, viro@zeniv.linux.org.uk,
        yzaikin@google.com
Subject:  + fs-move-namei-sysctls-to-its-own-file.patch added to
 -mm tree
Message-ID: <20211129225732.7GMShzPtT%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: move namei sysctls to its own file
has been added to the -mm tree.  Its filename is
     fs-move-namei-sysctls-to-its-own-file.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-move-namei-sysctls-to-its-own-file.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-move-namei-sysctls-to-its-own-file.patch

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
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
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
@@ -80,7 +80,6 @@ extern void __init files_maxfiles_init(v
 
 extern unsigned long get_max_files(void);
 extern unsigned int sysctl_nr_open;
-extern int leases_enable, lease_break_time;
 
 typedef __kernel_rwf_t rwf_t;
 
--- a/kernel/sysctl.c~fs-move-namei-sysctls-to-its-own-file
+++ a/kernel/sysctl.c
@@ -2897,42 +2897,6 @@ static struct ctl_table vm_table[] = {
 
 static struct ctl_table fs_table[] = {
 	{
-		.procname	= "protected_symlinks",
-		.data		= &sysctl_protected_symlinks,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-	{
-		.procname	= "protected_hardlinks",
-		.data		= &sysctl_protected_hardlinks,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-	{
-		.procname	= "protected_fifos",
-		.data		= &sysctl_protected_fifos,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_TWO,
-	},
-	{
-		.procname	= "protected_regular",
-		.data		= &sysctl_protected_regular,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
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

