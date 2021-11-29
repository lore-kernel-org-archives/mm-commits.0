Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F249C43219
	for <mm-commits@archiver.kernel.org>; Mon, 29 Nov 2021 22:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236878AbhK2XBi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Nov 2021 18:01:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59350 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237120AbhK2XAr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Nov 2021 18:00:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D52A5B81202
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 22:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19475C53FC7;
        Mon, 29 Nov 2021 22:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638226646;
        bh=/b+WvOzSL84aBKmw355tlTNMov2dH1r7CT0VwzDdLnA=;
        h=Date:From:To:Subject:From;
        b=Ipy/2+iJz+9KuTWA5MkpfQGTfE6mQwm9OI1vUrdBVutkRtIh8B0PS7gEit69z6zJE
         r5VB1aptALp/jvwR9pxX/q0UsZhEw29yvuTSE3VViGFNud1JBvRsUwFeYi+8EPveXw
         tJ8GHG1P+t73Aqh0nLhFrSYnYRi1wnJJ9Y+Ttuqw=
Date:   Mon, 29 Nov 2021 14:57:25 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        crope@iki.fi, ebiederm@xmission.com, jlayton@kernel.org,
        keescook@chromium.org, kernel@tuxforce.de, mcgrof@kernel.org,
        mchehab@kernel.org, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, steve@sk2.org, viro@zeniv.linux.org.uk,
        yzaikin@google.com
Subject:  + fs-move-shared-sysctls-to-fs-sysctlsc.patch added to
 -mm tree
Message-ID: <20211129225725.l0jAl0vfu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: move shared sysctls to fs/sysctls.c
has been added to the -mm tree.  Its filename is
     fs-move-shared-sysctls-to-fs-sysctlsc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-move-shared-sysctls-to-fs-sysctlsc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-move-shared-sysctls-to-fs-sysctlsc.patch

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
Subject: fs: move shared sysctls to fs/sysctls.c

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we just
care about the core logic.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we just
care about the core logic.

So move sysctls which are shared between filesystems into a common file
outside of kernel/sysctl.c.

Link: https://lkml.kernel.org/r/20211129205548.605569-6-mcgrof@kernel.org
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

 fs/Makefile     |    1 +
 fs/sysctls.c    |   38 ++++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c |   18 ------------------
 3 files changed, 39 insertions(+), 18 deletions(-)

--- a/fs/Makefile~fs-move-shared-sysctls-to-fs-sysctlsc
+++ a/fs/Makefile
@@ -28,6 +28,7 @@ obj-y				+= notify/
 obj-$(CONFIG_EPOLL)		+= eventpoll.o
 obj-y				+= anon_inodes.o
 obj-$(CONFIG_SIGNALFD)		+= signalfd.o
+obj-$(CONFIG_SYSCTL)		+= sysctls.o
 obj-$(CONFIG_TIMERFD)		+= timerfd.o
 obj-$(CONFIG_EVENTFD)		+= eventfd.o
 obj-$(CONFIG_USERFAULTFD)	+= userfaultfd.o
--- /dev/null
+++ a/fs/sysctls.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * /proc/sys/fs shared sysctls
+ *
+ * These sysctls are shared between different filesystems.
+ */
+#include <linux/init.h>
+#include <linux/sysctl.h>
+
+static struct ctl_table fs_shared_sysctls[] = {
+	{
+		.procname	= "overflowuid",
+		.data		= &fs_overflowuid,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_MAXOLDUID,
+	},
+	{
+		.procname	= "overflowgid",
+		.data		= &fs_overflowgid,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_MAXOLDUID,
+	},
+	{ }
+};
+
+static int __init init_fs_shared_sysctls(void)
+{
+	register_sysctl_init("fs", fs_shared_sysctls);
+	return 0;
+}
+
+early_initcall(init_fs_shared_sysctls);
--- a/kernel/sysctl.c~fs-move-shared-sysctls-to-fs-sysctlsc
+++ a/kernel/sysctl.c
@@ -2896,24 +2896,6 @@ static struct ctl_table vm_table[] = {
 };
 
 static struct ctl_table fs_table[] = {
-	{
-		.procname	= "overflowuid",
-		.data		= &fs_overflowuid,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_MAXOLDUID,
-	},
-	{
-		.procname	= "overflowgid",
-		.data		= &fs_overflowgid,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_MAXOLDUID,
-	},
 #ifdef CONFIG_FILE_LOCKING
 	{
 		.procname	= "leases-enable",
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

