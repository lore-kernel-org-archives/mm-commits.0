Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABDE8C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 00:14:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240627AbhKXARM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:17:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:50494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240606AbhKXARM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 19:17:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CB2061055;
        Wed, 24 Nov 2021 00:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637712843;
        bh=r5RRcv8nGsV0dL0qCRFJraPddzpnsIdcPKm9s6u/9RY=;
        h=Date:From:To:Subject:From;
        b=UJ59foCOSXG5w4uus/ANjKVWw7V6ZtrQu7RFssIR8HDCBpbEA5+6y4/mA8PvPi2XP
         TeCdtijOMt08i6iSWVcKfa/VF4o/lJv5qb7fh9VsMtL8nBXNol2bAytsSN8ZPwuq4e
         GvxWYBryP2bawXmdSnxQy/Ad57+XIhFr0CIHJaFw=
Date:   Tue, 23 Nov 2021 16:14:01 -0800
From:   akpm@linux-foundation.org
To:     airlied@linux.ie, amir73il@gmail.com,
        andriy.shevchenko@linux.intel.com, arnd@arndb.de, bcrl@kvack.org,
        benh@kernel.crashing.org, clemens@ladisch.de, crope@iki.fi,
        ebiederm@xmission.com, gregkh@linuxfoundation.org, jack@suse.cz,
        jani.nikula@linux.intel.com, jlbec@evilplan.org,
        joonas.lahtinen@linux.intel.com, joseph.qi@linux.alibaba.com,
        julia.lawall@inria.fr, keescook@chromium.org, kernel@tuxforce.de,
        liu.hailong6@zte.com.cn, mark@fasheh.com, mcgrof@kernel.org,
        mchehab@kernel.org, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, penguin-kernel@I-love.SAKURA.ne.jp,
        peterz@infradead.org, phil@philpotter.co.uk, pjt@google.com,
        pmladek@suse.com, rodrigo.vivi@intel.com, senozhatsky@chromium.org,
        sre@kernel.org, steve@sk2.org, viro@zeniv.linux.org.uk,
        wangqing@vivo.com, yzaikin@google.com
Subject:  + dnotify-move-dnotify-sysctl-to-dnotifyc.patch added to
 -mm tree
Message-ID: <20211124001401.a358NgLmh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: dnotify: move dnotify sysctl to dnotify.c
has been added to the -mm tree.  Its filename is
     dnotify-move-dnotify-sysctl-to-dnotifyc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/dnotify-move-dnotify-sysctl-to-dnotifyc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/dnotify-move-dnotify-sysctl-to-dnotifyc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hailong Liu <liu.hailong6@zte.com.cn>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Jan Kara <jack@suse.cz>
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
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Phillip Potter <phil@philpotter.co.uk>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
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
 			    FS_CREATE | FS_DN_RENAME |\
 			    FS_MOVED_FROM | FS_MOVED_TO)
 
-extern int dir_notify_enable;
 extern void dnotify_flush(struct file *, fl_owner_t);
 extern int fcntl_dirnotify(int, struct file *, unsigned long);
 
--- a/kernel/sysctl.c~dnotify-move-dnotify-sysctl-to-dnotifyc
+++ a/kernel/sysctl.c
@@ -48,7 +48,6 @@
 #include <linux/times.h>
 #include <linux/limits.h>
 #include <linux/dcache.h>
-#include <linux/dnotify.h>
 #include <linux/syscalls.h>
 #include <linux/vmstat.h>
 #include <linux/nfs_fs.h>
@@ -3088,15 +3087,6 @@ static struct ctl_table fs_table[] = {
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

sysctl-add-a-new-register_sysctl_init-interface.patch
sysctl-move-some-boundary-constants-from-sysctlc-to-sysctl_vals.patch
hung_task-move-hung_task-sysctl-interface-to-hung_taskc.patch
watchdog-move-watchdog-sysctl-interface-to-watchdogc.patch
sysctl-use-const-for-typically-used-max-min-proc-sysctls.patch
sysctl-use-sysctl_zero-to-replace-some-static-int-zero-uses.patch
aio-move-aio-sysctl-to-aioc.patch
dnotify-move-dnotify-sysctl-to-dnotifyc.patch
inotify-simplify-subdirectory-registration-with-register_sysctl.patch
eventpoll-simplify-sysctl-declaration-with-register_sysctl.patch

