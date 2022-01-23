Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B425C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240484AbiAWXzu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbiAWXzt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:55:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E22C06173B
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 15:55:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6763B80E4E
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D13C340E3;
        Sun, 23 Jan 2022 23:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982146;
        bh=W+IBMz41CC/vFX2dORKRN22XXsNPC/qMAppaHPNyZ1g=;
        h=Date:From:To:Subject:From;
        b=VxWvZ++VXXET2GY2/GC9EMypx9skeoShrf5WQyfDzs9jrvQuYCGPh300Hx0oGVzji
         0TH4I1erzSvKOvtOTT4YUwgOG5PTuIr9TMUy8tjIS2ce8H0+2lyI2uCho/zF65qMSd
         KIzKLHbv2lVfw4h1Vwm4AbjXt2U48tjmP64JYm3c=
Date:   Sun, 23 Jan 2022 15:55:44 -0800
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
Subject:  [merged] aio-move-aio-sysctl-to-aioc.patch removed from
 -mm tree
Message-ID: <20220123235544.0SRi8eoRG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: aio: move aio sysctl to aio.c
has been removed from the -mm tree.  Its filename was
     aio-move-aio-sysctl-to-aioc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: Jan Kara <jack@suse.cz>
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

 fs/aio.c            |   31 +++++++++++++++++++++++++++++--
 include/linux/aio.h |    4 ----
 kernel/sysctl.c     |   17 -----------------
 3 files changed, 29 insertions(+), 23 deletions(-)

--- a/fs/aio.c~aio-move-aio-sysctl-to-aioc
+++ a/fs/aio.c
@@ -220,9 +220,35 @@ struct aio_kiocb {
 
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
@@ -275,6 +301,7 @@ static int __init aio_setup(void)
 
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
@@ -3111,22 +3110,6 @@ static struct ctl_table fs_table[] = {
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


