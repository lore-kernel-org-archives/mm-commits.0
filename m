Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8CBAC433F5
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiAVGMF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:12:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42472 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233426AbiAVGMC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:12:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7A2C60FB6
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B09F8C004E1;
        Sat, 22 Jan 2022 06:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642831921;
        bh=KAbol6CwkpHq3SReQGkx6StkkSm0AR7xibBJjsnBZ88=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=PcoirAJQbqZIFJDXbDFReYuRC6nVN8/C3errq1Qm2CxKBoYASBEMsas5QYiF5ccZQ
         PBwxD1Q3mW9npGBwulc79ZdvMDUu3spT2kQfuCAz9F1Tl/rCbQbQYbl5DVbyp7ZvuM
         Kd/DOhqxWs43QZTp2vFERTCOOQtxlRg5nIPS7dyY=
Date:   Fri, 21 Jan 2022 22:11:59 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     airlied@linux.ie, akpm@linux-foundation.org, amir73il@gmail.com,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, bcrl@kvack.org,
        benh@kernel.crashing.org, clemens@ladisch.de, crope@iki.fi,
        dgilbert@interlog.com, ebiederm@xmission.com,
        gregkh@linuxfoundation.org, jack@suse.cz, jani.nikula@intel.com,
        jani.nikula@linux.intel.com, jejb@linux.ibm.com,
        jlbec@evilplan.org, john.ogness@linutronix.de,
        joonas.lahtinen@linux.intel.com, joseph.qi@linux.alibaba.com,
        julia.lawall@inria.fr, keescook@chromium.org, kernel@tuxforce.de,
        linux-mm@kvack.org, mark@fasheh.com, martin.petersen@oracle.com,
        mcgrof@kernel.org, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, penguin-kernel@I-love.SAKURA.ne.jp,
        peterz@infradead.org, phil@philpotter.co.uk, pjt@google.com,
        pmladek@suse.com, rafael@kernel.org, rodrigo.vivi@intel.com,
        rostedt@goodmis.org, senozhatsky@chromium.org, sre@kernel.org,
        steve@sk2.org, surenb@google.com, torvalds@linux-foundation.org,
        tytso@mit.edu, viro@zeniv.linux.org.uk, wangqing@vivo.com,
        yzaikin@google.com
Subject:  [patch 16/69] inotify: simplify subdirectory registration
 with register_sysctl()
Message-ID: <20220122061159.A8247zs4x%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xiaoming Ni <nixiaoming@huawei.com>
Subject: inotify: simplify subdirectory registration with register_sysctl()

There is no need to user boiler plate code to specify a set of base
directories we're going to stuff sysctls under.  Simplify this by using
register_sysctl() and specifying the directory path directly.

Move inotify_user sysctl to inotify_user.c while at it to remove clutter
from kernel/sysctl.c.

[mcgrof@kernel.org: remember to register fanotify_table]
  Link: https://lkml.kernel.org/r/YZ5A6iWLb0h3N3RC@bombadil.infradead.org
[mcgrof@kernel.org: update commit log to reflect new path we decided to take]
Link: https://lkml.kernel.org/r/20211123202422.819032-7-mcgrof@kernel.org
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: David Airlie <airlied@linux.ie>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Phillip Potter <phil@philpotter.co.uk>
Cc: Qing Wang <wangqing@vivo.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
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

 fs/notify/fanotify/fanotify_user.c |   10 +++++++++-
 fs/notify/inotify/inotify_user.c   |   11 ++++++++++-
 include/linux/fanotify.h           |    2 --
 include/linux/inotify.h            |    3 ---
 kernel/sysctl.c                    |   21 ---------------------
 5 files changed, 19 insertions(+), 28 deletions(-)

--- a/fs/notify/fanotify/fanotify_user.c~inotify-simplify-subdirectory-registration-with-register_sysctl
+++ a/fs/notify/fanotify/fanotify_user.c
@@ -59,7 +59,7 @@ static int fanotify_max_queued_events __
 static long ft_zero = 0;
 static long ft_int_max = INT_MAX;
 
-struct ctl_table fanotify_table[] = {
+static struct ctl_table fanotify_table[] = {
 	{
 		.procname	= "max_user_groups",
 		.data	= &init_user_ns.ucount_max[UCOUNT_FANOTIFY_GROUPS],
@@ -88,6 +88,13 @@ struct ctl_table fanotify_table[] = {
 	},
 	{ }
 };
+
+static void __init fanotify_sysctls_init(void)
+{
+	register_sysctl("fs/fanotify", fanotify_table);
+}
+#else
+#define fanotify_sysctls_init() do { } while (0)
 #endif /* CONFIG_SYSCTL */
 
 /*
@@ -1743,6 +1750,7 @@ static int __init fanotify_user_setup(vo
 	init_user_ns.ucount_max[UCOUNT_FANOTIFY_GROUPS] =
 					FANOTIFY_DEFAULT_MAX_GROUPS;
 	init_user_ns.ucount_max[UCOUNT_FANOTIFY_MARKS] = max_marks;
+	fanotify_sysctls_init();
 
 	return 0;
 }
--- a/fs/notify/inotify/inotify_user.c~inotify-simplify-subdirectory-registration-with-register_sysctl
+++ a/fs/notify/inotify/inotify_user.c
@@ -58,7 +58,7 @@ struct kmem_cache *inotify_inode_mark_ca
 static long it_zero = 0;
 static long it_int_max = INT_MAX;
 
-struct ctl_table inotify_table[] = {
+static struct ctl_table inotify_table[] = {
 	{
 		.procname	= "max_user_instances",
 		.data		= &init_user_ns.ucount_max[UCOUNT_INOTIFY_INSTANCES],
@@ -87,6 +87,14 @@ struct ctl_table inotify_table[] = {
 	},
 	{ }
 };
+
+static void __init inotify_sysctls_init(void)
+{
+	register_sysctl("fs/inotify", inotify_table);
+}
+
+#else
+#define inotify_sysctls_init() do { } while (0)
 #endif /* CONFIG_SYSCTL */
 
 static inline __u32 inotify_arg_to_mask(struct inode *inode, u32 arg)
@@ -849,6 +857,7 @@ static int __init inotify_user_setup(voi
 	inotify_max_queued_events = 16384;
 	init_user_ns.ucount_max[UCOUNT_INOTIFY_INSTANCES] = 128;
 	init_user_ns.ucount_max[UCOUNT_INOTIFY_WATCHES] = watches_max;
+	inotify_sysctls_init();
 
 	return 0;
 }
--- a/include/linux/fanotify.h~inotify-simplify-subdirectory-registration-with-register_sysctl
+++ a/include/linux/fanotify.h
@@ -5,8 +5,6 @@
 #include <linux/sysctl.h>
 #include <uapi/linux/fanotify.h>
 
-extern struct ctl_table fanotify_table[]; /* for sysctl */
-
 #define FAN_GROUP_FLAG(group, flag) \
 	((group)->fanotify_data.flags & (flag))
 
--- a/include/linux/inotify.h~inotify-simplify-subdirectory-registration-with-register_sysctl
+++ a/include/linux/inotify.h
@@ -7,11 +7,8 @@
 #ifndef _LINUX_INOTIFY_H
 #define _LINUX_INOTIFY_H
 
-#include <linux/sysctl.h>
 #include <uapi/linux/inotify.h>
 
-extern struct ctl_table inotify_table[]; /* for sysctl */
-
 #define ALL_INOTIFY_BITS (IN_ACCESS | IN_MODIFY | IN_ATTRIB | IN_CLOSE_WRITE | \
 			  IN_CLOSE_NOWRITE | IN_OPEN | IN_MOVED_FROM | \
 			  IN_MOVED_TO | IN_CREATE | IN_DELETE | \
--- a/kernel/sysctl.c~inotify-simplify-subdirectory-registration-with-register_sysctl
+++ a/kernel/sysctl.c
@@ -126,13 +126,6 @@ static const int maxolduid = 65535;
 static const int ngroups_max = NGROUPS_MAX;
 static const int cap_last_cap = CAP_LAST_CAP;
 
-#ifdef CONFIG_INOTIFY_USER
-#include <linux/inotify.h>
-#endif
-#ifdef CONFIG_FANOTIFY
-#include <linux/fanotify.h>
-#endif
-
 #ifdef CONFIG_PROC_SYSCTL
 
 /**
@@ -3100,20 +3093,6 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
-#ifdef CONFIG_INOTIFY_USER
-	{
-		.procname	= "inotify",
-		.mode		= 0555,
-		.child		= inotify_table,
-	},
-#endif
-#ifdef CONFIG_FANOTIFY
-	{
-		.procname	= "fanotify",
-		.mode		= 0555,
-		.child		= fanotify_table,
-	},
-#endif
 #ifdef CONFIG_EPOLL
 	{
 		.procname	= "epoll",
_
