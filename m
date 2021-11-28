Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6322C433EF
	for <mm-commits@archiver.kernel.org>; Sun, 28 Nov 2021 01:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245259AbhK1BKP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Nov 2021 20:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344682AbhK1BIO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Nov 2021 20:08:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98D9C061746
        for <mm-commits@vger.kernel.org>; Sat, 27 Nov 2021 17:04:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F4D4B80B36
        for <mm-commits@vger.kernel.org>; Sun, 28 Nov 2021 01:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B47EC53FBF;
        Sun, 28 Nov 2021 01:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638061496;
        bh=xkkIETr5UY6cXklPO8KuKXVh7ICgpBzFzXPhg2GMCcg=;
        h=Date:From:To:Subject:From;
        b=LHk9POBOtKSjW58L0SqfuvKOPnuwEikQNkIkJtvowtJG/X3iMXheUBp+TJYXMqxY4
         VPuoKd81yt4KrqF/ae46/UtF9wYKIC0am8QwytV97Py5gn7JofdfuvLRCbaTw7iaze
         a458ZS/6lwtcqFzYDNkMYrJDhDntmB64gGSFfxq4=
Date:   Sat, 27 Nov 2021 17:04:55 -0800
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
        mchehab@kernel.org, mm-commits@vger.kernel.org,
        nixiaoming@huawei.com, penguin-kernel@I-love.SAKURA.ne.jp,
        peterz@infradead.org, phil@philpotter.co.uk, pjt@google.com,
        pmladek@suse.com, rafael@kernel.org, rodrigo.vivi@intel.com,
        rostedt@goodmis.org, senozhatsky@chromium.org, sre@kernel.org,
        steve@sk2.org, surenb@google.com, tytso@mit.edu,
        viro@zeniv.linux.org.uk, wangqing@vivo.com, yzaikin@google.com
Subject:  + scsi-sg-move-sg-big-buff-sysctl-to-scsi-sgc.patch added
 to -mm tree
Message-ID: <20211128010455.7XHyM_JXM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scsi/sg: move sg-big-buff sysctl to scsi/sg.c
has been added to the -mm tree.  Its filename is
     scsi-sg-move-sg-big-buff-sysctl-to-scsi-sgc.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/scsi-sg-move-sg-big-buff-sysctl-to-scsi-sgc.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/scsi-sg-move-sg-big-buff-sysctl-to-scsi-sgc.patch

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
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
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
@@ -94,9 +94,6 @@
 #if defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_LOCK_STAT)
 #include <linux/lockdep.h>
 #endif
-#ifdef CONFIG_CHR_DEV_SG
-#include <scsi/sg.h>
-#endif
 #ifdef CONFIG_STACKLEAK_RUNTIME_DISABLE
 #include <linux/stackleak.h>
 #endif
@@ -2089,15 +2086,6 @@ static struct ctl_table kern_table[] = {
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
firmware_loader-move-firmware-sysctl-to-its-own-files.patch
random-move-the-random-sysctl-declarations-to-its-own-file.patch
printk-move-printk-sysctl-to-printk-sysctlc.patch
scsi-sg-move-sg-big-buff-sysctl-to-scsi-sgc.patch
stackleak-move-stack_erasing-sysctl-to-stackleakc.patch

