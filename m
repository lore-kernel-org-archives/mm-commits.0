Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 263D6C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240485AbiAWXzx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:55:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbiAWXzx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:55:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E8AC06173B
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 15:55:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBF57B80E4E
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370C3C340E3;
        Sun, 23 Jan 2022 23:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982150;
        bh=DUwQ/1k4ju230DnRFFh8j2yteH/WAhvNF7WamXxoeWg=;
        h=Date:From:To:Subject:From;
        b=Tdz5HrBWneioEXB7tPD6Gur3nPXqS2N3dSkPjDT0/ILbqf9HXyHdlmgBAt9p1eYaX
         4ICODLbrDh0uiC6OrKjXq8ZLnmGFPB7GlX/hNZVygwsKyEDuoI5qKfomEF5QGYc1S7
         G61ySsMqsXkesecw+JXraxyOGTuVYX7uivGAcIto=
Date:   Sun, 23 Jan 2022 15:55:48 -0800
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, amir73il@gmail.com,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, bcrl@kvack.org,
        benh@kernel.crashing.org, clemens@ladisch.de, crope@iki.fi,
        dgilbert@interlog.com, ebiederm@xmission.com,
        gregkh@linuxfoundation.org, jack@suse.cz, jani.nikula@intel.com,
        jani.nikula@linux.intel.com, jejb@linux.ibm.com,
        jlbec@evilplan.org, john.ogness@linutronix.de,
        joonas.lahtinen@linux.intel.com, joseph.qi@linux.alibaba.com,
        julia.lawall@inria.fr, keescook@chromium.org, kernel@tuxforce.de,
        mark@fasheh.com, martin.petersen@oracle.com, mcgrof@kernel.org,
        mm-commits@vger.kernel.org, nixiaoming@huawei.com,
        penguin-kernel@I-love.SAKURA.ne.jp, peterz@infradead.org,
        phil@philpotter.co.uk, pjt@google.com, pmladek@suse.com,
        rafael@kernel.org, rodrigo.vivi@intel.com, rostedt@goodmis.org,
        senozhatsky@chromium.org, sre@kernel.org, steve@sk2.org,
        surenb@google.com, tytso@mit.edu, viro@zeniv.linux.org.uk,
        wangqing@vivo.com, yzaikin@google.com
Subject:  [merged] dnotify-move-dnotify-sysctl-to-dnotifyc.patch
 removed from -mm tree
Message-ID: <20220123235548.XgwhP81ll%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dnotify: move dnotify sysctl to dnotify.c
has been removed from the -mm tree.  Its filename was
     dnotify-move-dnotify-sysctl-to-dnotifyc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xiaoming Ni <nixiaoming@huawei.com>
Subject: dnotify: move dnotify sysctl to dnotify.c

The kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we just
care about the core logic.

So move dnotify sysctls to dnotify.c and use the new
register_sysctl_init() to register the sysctl interface.

[mcgrof@kernel.org: adjust the commit log to justify the move]
Link: https://lkml.kernel.org/r/20211123202347.818157-10-mcgrof@kernel.org
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Acked-by: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Qing Wang <wangqing@vivo.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Phillip Potter <phil@philpotter.co.uk>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/notify/dnotify/dnotify.c |   21 ++++++++++++++++++++-
 include/linux/dnotify.h     |    1 -
 kernel/sysctl.c             |   10 ----------
 3 files changed, 20 insertions(+), 12 deletions(-)

--- a/fs/notify/dnotify/dnotify.c~dnotify-move-dnotify-sysctl-to-dnotifyc
+++ a/fs/notify/dnotify/dnotify.c
@@ -19,7 +19,25 @@
 #include <linux/fdtable.h>
 #include <linux/fsnotify_backend.h>
 
-int dir_notify_enable __read_mostly = 1;
+static int dir_notify_enable __read_mostly = 1;
+#ifdef CONFIG_SYSCTL
+static struct ctl_table dnotify_sysctls[] = {
+	{
+		.procname	= "dir-notify-enable",
+		.data		= &dir_notify_enable,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{}
+};
+static void __init dnotify_sysctl_init(void)
+{
+	register_sysctl_init("fs", dnotify_sysctls);
+}
+#else
+#define dnotify_sysctl_init() do { } while (0)
+#endif
 
 static struct kmem_cache *dnotify_struct_cache __read_mostly;
 static struct kmem_cache *dnotify_mark_cache __read_mostly;
@@ -386,6 +404,7 @@ static int __init dnotify_init(void)
 	dnotify_group = fsnotify_alloc_group(&dnotify_fsnotify_ops);
 	if (IS_ERR(dnotify_group))
 		panic("unable to allocate fsnotify group for dnotify\n");
+	dnotify_sysctl_init();
 	return 0;
 }
 
--- a/include/linux/dnotify.h~dnotify-move-dnotify-sysctl-to-dnotifyc
+++ a/include/linux/dnotify.h
@@ -29,7 +29,6 @@ struct dnotify_struct {
 			    FS_CREATE | FS_RENAME |\
 			    FS_MOVED_FROM | FS_MOVED_TO)
 
-extern int dir_notify_enable;
 extern void dnotify_flush(struct file *, fl_owner_t);
 extern int fcntl_dirnotify(int, struct file *, unsigned long);
 
--- a/kernel/sysctl.c~dnotify-move-dnotify-sysctl-to-dnotifyc
+++ a/kernel/sysctl.c
@@ -49,7 +49,6 @@
 #include <linux/times.h>
 #include <linux/limits.h>
 #include <linux/dcache.h>
-#include <linux/dnotify.h>
 #include <linux/syscalls.h>
 #include <linux/vmstat.h>
 #include <linux/nfs_fs.h>
@@ -3089,15 +3088,6 @@ static struct ctl_table fs_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
-	},
-#endif
-#ifdef CONFIG_DNOTIFY
-	{
-		.procname	= "dir-notify-enable",
-		.data		= &dir_notify_enable,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
 	},
 #endif
 #ifdef CONFIG_MMU
_

Patches currently in -mm which might be from nixiaoming@huawei.com are


