Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD8B2C433F5
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiAVGMn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:12:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiAVGMn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:12:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC10CC06173B
        for <mm-commits@vger.kernel.org>; Fri, 21 Jan 2022 22:12:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 822FCB81FCF
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD5BAC340E0;
        Sat, 22 Jan 2022 06:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642831960;
        bh=MxNA7iCwRUEDVD8lKTlt9oYMLmDAA/eBONX1AifgnkA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UYvQawnk05KA5a6DdzpIxh5O4qyFCjh4nX4ktwv+WxCGA4ApyZIt5+YTtKyQ6OJCp
         wZlImW68hb0INIAedin6TLQMWzEc7l/aY7Mv1QowgNRHYCRZvgWIH11l0b3k5TExPo
         soxpOBLvDvHI/eoeSaB/4ayCdZwuj3SYx7DSV4zg=
Date:   Fri, 21 Jan 2022 22:12:38 -0800
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
Subject:  [patch 24/69] scsi/sg: move sg-big-buff sysctl to
 scsi/sg.c
Message-ID: <20220122061238.89wj5c10t%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Xiaoming Ni <nixiaoming@huawei.com>
Subject: scsi/sg: move sg-big-buff sysctl to scsi/sg.c

kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we just
care about the core logic.

So move the sg-big-buff sysctl from kernel/sysctl.c to drivers/scsi/sg.c
and use register_sysctl() to register the sysctl interface.

[mcgrof@kernel.org: commit log update]
Link: https://lkml.kernel.org/r/20211124231435.1445213-7-mcgrof@kernel.org
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
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Phillip Potter <phil@philpotter.co.uk>
Cc: Qing Wang <wangqing@vivo.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sg.c |   35 ++++++++++++++++++++++++++++++++++-
 include/scsi/sg.h |    4 ----
 kernel/sysctl.c   |   12 ------------
 3 files changed, 34 insertions(+), 17 deletions(-)

--- a/drivers/scsi/sg.c~scsi-sg-move-sg-big-buff-sysctl-to-scsi-sgc
+++ a/drivers/scsi/sg.c
@@ -77,7 +77,7 @@ static int sg_proc_init(void);
 
 #define SG_DEFAULT_TIMEOUT mult_frac(SG_DEFAULT_TIMEOUT_USER, HZ, USER_HZ)
 
-int sg_big_buff = SG_DEF_RESERVED_SIZE;
+static int sg_big_buff = SG_DEF_RESERVED_SIZE;
 /* N.B. This variable is readable and writeable via
    /proc/scsi/sg/def_reserved_size . Each time sg_open() is called a buffer
    of this size (or less if there is not enough memory) will be reserved
@@ -1634,6 +1634,37 @@ MODULE_PARM_DESC(scatter_elem_sz, "scatt
 MODULE_PARM_DESC(def_reserved_size, "size of buffer reserved for each fd");
 MODULE_PARM_DESC(allow_dio, "allow direct I/O (default: 0 (disallow))");
 
+#ifdef CONFIG_SYSCTL
+#include <linux/sysctl.h>
+
+static struct ctl_table sg_sysctls[] = {
+	{
+		.procname	= "sg-big-buff",
+		.data		= &sg_big_buff,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
+	{}
+};
+
+static struct ctl_table_header *hdr;
+static void register_sg_sysctls(void)
+{
+	if (!hdr)
+		hdr = register_sysctl("kernel", sg_sysctls);
+}
+
+static void unregister_sg_sysctls(void)
+{
+	if (hdr)
+		unregister_sysctl_table(hdr);
+}
+#else
+#define register_sg_sysctls() do { } while (0)
+#define unregister_sg_sysctls() do { } while (0)
+#endif /* CONFIG_SYSCTL */
+
 static int __init
 init_sg(void)
 {
@@ -1666,6 +1697,7 @@ init_sg(void)
 		return 0;
 	}
 	class_destroy(sg_sysfs_class);
+	register_sg_sysctls();
 err_out:
 	unregister_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0), SG_MAX_DEVS);
 	return rc;
@@ -1674,6 +1706,7 @@ err_out:
 static void __exit
 exit_sg(void)
 {
+	unregister_sg_sysctls();
 #ifdef CONFIG_SCSI_PROC_FS
 	remove_proc_subtree("scsi/sg", NULL);
 #endif				/* CONFIG_SCSI_PROC_FS */
--- a/include/scsi/sg.h~scsi-sg-move-sg-big-buff-sysctl-to-scsi-sgc
+++ a/include/scsi/sg.h
@@ -29,10 +29,6 @@
  * For utility and test programs see: http://sg.danny.cz/sg/sg3_utils.html
  */
 
-#ifdef __KERNEL__
-extern int sg_big_buff; /* for sysctl */
-#endif
-
 
 typedef struct sg_iovec /* same structure as used by readv() Linux system */
 {                       /* call. It defines one scatter-gather element. */
--- a/kernel/sysctl.c~scsi-sg-move-sg-big-buff-sysctl-to-scsi-sgc
+++ a/kernel/sysctl.c
@@ -95,9 +95,6 @@
 #if defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_LOCK_STAT)
 #include <linux/lockdep.h>
 #endif
-#ifdef CONFIG_CHR_DEV_SG
-#include <scsi/sg.h>
-#endif
 #ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
 #include <linux/stackleak.h>
 #endif
@@ -2090,15 +2087,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dostring,
 	},
 #endif
-#ifdef CONFIG_CHR_DEV_SG
-	{
-		.procname	= "sg-big-buff",
-		.data		= &sg_big_buff,
-		.maxlen		= sizeof (int),
-		.mode		= 0444,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	{
 		.procname	= "acct",
_
