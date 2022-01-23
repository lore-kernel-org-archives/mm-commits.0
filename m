Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6592AC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:57:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240508AbiAWX5M (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:57:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46014 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235111AbiAWX5L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:57:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7402DB80E46
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC023C340E3;
        Sun, 23 Jan 2022 23:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982229;
        bh=OSjqeWwvC5YKZK1AualfS5SUAjrZftZDEZCOw8CyIUc=;
        h=Date:From:To:Subject:From;
        b=cxwAPEcl2xAFx8WxAy2vupDjtEAPAVlb8FjNpeqLFjxWskWvmJ5+mUPcOsd/x+JkW
         i4clQ0Afx8hot1f5hqX76hHaNBp89733bIw8wfaz7Y/F6Pl8dlVDWX6LjKelB2JPjM
         ivlqbDAjPS3BwxErpV/j6dsKBzydCH6y2XZoOi+8=
Date:   Sun, 23 Jan 2022 15:57:08 -0800
From:   akpm@linux-foundation.org
To:     andriy.shevchenko@linux.intel.com, bfields@fieldses.org,
        crope@iki.fi, ebiederm@xmission.com, jlayton@kernel.org,
        keescook@chromium.org, kernel@tuxforce.de, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, nixiaoming@huawei.com, steve@sk2.org,
        viro@zeniv.linux.org.uk, yzaikin@google.com
Subject:  [merged] fs-move-shared-sysctls-to-fs-sysctlsc.patch
 removed from -mm tree
Message-ID: <20220123235708.Me28pTHQS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: move shared sysctls to fs/sysctls.c
has been removed from the -mm tree.  Its filename was
     fs-move-shared-sysctls-to-fs-sysctlsc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -2897,24 +2897,6 @@ static struct ctl_table vm_table[] = {
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


