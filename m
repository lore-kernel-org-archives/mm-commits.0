Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A4EEC433F5
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 00:14:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240626AbhKXARI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:17:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240606AbhKXARH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 19:17:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 209F761050;
        Wed, 24 Nov 2021 00:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637712839;
        bh=62t13iIBvPbrB9cGWu46la817esgIt5FXjn3Jnx7Nh8=;
        h=Date:From:To:Subject:From;
        b=lSD+v8LfVZ7UFuCVy3C5vafdYp5Ek0QiZBNovRrYJVkmVJPUrd8hwt+owcwtnSBD+
         PUkqD4kFGc/qOUmpqjzxwA8eU3ktOzQ0zXmsT30b2WSLVUUVLiN5LlLGzhvxJ9o2rq
         t8VheCWUK+g9vwMsktHeUeEWzB+K7KUJ6Lkx0+jM=
Date:   Tue, 23 Nov 2021 16:13:57 -0800
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
Subject:  + aio-move-aio-sysctl-to-aioc.patch added to -mm tree
Message-ID: <20211124001357.tfJqqmXQi%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: aio: move aio sysctl to aio.c
has been added to the -mm tree.  Its filename is
     aio-move-aio-sysctl-to-aioc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/aio-move-aio-sysctl-to-aioc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/aio-move-aio-sysctl-to-aioc.patch

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
Subject: aio: move aio sysctl to aio.c

The kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we just
care about the core logic.

Move aio sysctl to aio.c and use the new register_sysctl_init() to
register the sysctl interface for aio.

[mcgrof@kernel.org: adjust commit log to justify the move]
Link: https://lkml.kernel.org/r/20211123202347.818157-9-mcgrof@kernel.org
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

 fs/aio.c            |   31 +++++++++++++++++++++++++++++--
 include/linux/aio.h |    4 ----
 kernel/sysctl.c     |   17 -----------------
 3 files changed, 29 insertions(+), 23 deletions(-)

--- a/fs/aio.c~aio-move-aio-sysctl-to-aioc
+++ a/fs/aio.c
@@ -219,9 +219,35 @@ struct aio_kiocb {
 
 /*------ sysctl variables----*/
 static DEFINE_SPINLOCK(aio_nr_lock);
-unsigned long aio_nr;		/* current system wide number of aio requests */
-unsigned long aio_max_nr = 0x10000; /* system wide maximum number of aio requests */
+static unsigned long aio_nr;		/* current system wide number of aio requests */
+static unsigned long aio_max_nr = 0x10000; /* system wide maximum number of aio requests */
 /*----end sysctl variables---*/
+#ifdef CONFIG_SYSCTL
+static struct ctl_table aio_sysctls[] = {
+	{
+		.procname	= "aio-nr",
+		.data		= &aio_nr,
+		.maxlen		= sizeof(aio_nr),
+		.mode		= 0444,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+	{
+		.procname	= "aio-max-nr",
+		.data		= &aio_max_nr,
+		.maxlen		= sizeof(aio_max_nr),
+		.mode		= 0644,
+		.proc_handler	= proc_doulongvec_minmax,
+	},
+	{}
+};
+
+static void __init aio_sysctl_init(void)
+{
+	register_sysctl_init("fs", aio_sysctls);
+}
+#else
+#define aio_sysctl_init() do { } while (0)
+#endif
 
 static struct kmem_cache	*kiocb_cachep;
 static struct kmem_cache	*kioctx_cachep;
@@ -274,6 +300,7 @@ static int __init aio_setup(void)
 
 	kiocb_cachep = KMEM_CACHE(aio_kiocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 	kioctx_cachep = KMEM_CACHE(kioctx,SLAB_HWCACHE_ALIGN|SLAB_PANIC);
+	aio_sysctl_init();
 	return 0;
 }
 __initcall(aio_setup);
--- a/include/linux/aio.h~aio-move-aio-sysctl-to-aioc
+++ a/include/linux/aio.h
@@ -20,8 +20,4 @@ static inline void kiocb_set_cancel_fn(s
 				       kiocb_cancel_fn *cancel) { }
 #endif /* CONFIG_AIO */
 
-/* for sysctl: */
-extern unsigned long aio_nr;
-extern unsigned long aio_max_nr;
-
 #endif /* __LINUX__AIO_H */
--- a/kernel/sysctl.c~aio-move-aio-sysctl-to-aioc
+++ a/kernel/sysctl.c
@@ -20,7 +20,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/aio.h>
 #include <linux/mm.h>
 #include <linux/swap.h>
 #include <linux/slab.h>
@@ -3110,22 +3109,6 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
-#ifdef CONFIG_AIO
-	{
-		.procname	= "aio-nr",
-		.data		= &aio_nr,
-		.maxlen		= sizeof(aio_nr),
-		.mode		= 0444,
-		.proc_handler	= proc_doulongvec_minmax,
-	},
-	{
-		.procname	= "aio-max-nr",
-		.data		= &aio_max_nr,
-		.maxlen		= sizeof(aio_max_nr),
-		.mode		= 0644,
-		.proc_handler	= proc_doulongvec_minmax,
-	},
-#endif /* CONFIG_AIO */
 #ifdef CONFIG_INOTIFY_USER
 	{
 		.procname	= "inotify",
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

