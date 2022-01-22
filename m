Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CDDFC433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiAVGNL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:13:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbiAVGNK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:13:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11407C06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 22:13:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCDE8B82100
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:13:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1149FC340E0;
        Sat, 22 Jan 2022 06:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642831987;
        bh=BIQK3dWwLkOgSuF+GfSs7qYzMFx1pIri52Ypwa3ILBE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=SPXASiT30qI0gcPQFnosjHHJH4laB072UBIIN+NQ3sLQgKHdWGqY7zAwZje7WknIO
         oy+GHYVFRspR+SPnmS8bT+TvFYaUkGlcM713uHBNTsxyCsh/lopd9x8BRlsdx33zde
         2uC8Pr1cl3hlUPdJY52Av8f277Y1WPK2CIYSgocc=
Date:   Fri, 21 Jan 2022 22:13:06 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        bfields@fieldses.org, crope@iki.fi, ebiederm@xmission.com,
        jlayton@kernel.org, keescook@chromium.org, kernel@tuxforce.de,
        linux-mm@kvack.org, mcgrof@kernel.org, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, steve@sk2.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        yzaikin@google.com
Subject:  [patch 31/69] fs: move shared sysctls to fs/sysctls.c
Message-ID: <20220122061306.9ayN3FnrG%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
