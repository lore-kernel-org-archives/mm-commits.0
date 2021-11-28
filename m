Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 292B3C433F5
	for <mm-commits@archiver.kernel.org>; Sun, 28 Nov 2021 01:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356798AbhK1BJu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Nov 2021 20:09:50 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55124 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbhK1BHu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Nov 2021 20:07:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAAA360F5A
        for <mm-commits@vger.kernel.org>; Sun, 28 Nov 2021 01:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF670C53FAD;
        Sun, 28 Nov 2021 01:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638061474;
        bh=Jl38zijJU1nr4Xb/fDUy8Kf2H+SRS/fE5xnv0FID+4M=;
        h=Date:From:To:Subject:From;
        b=pYIx4Q4CzBnVPatIva5l4oMkvR9QfYbQxhzaCzFuv52f063UjyEZgytZ9gZGcGner
         Sv5rpCo68u35AoBfAAJrWBTbpbcgW2e4I6ReL2M52fo5NUVOZ+ff1rDFsZJMoYZICX
         8cyvi3e/Aw//J5oWNuZfvgU3up9kVNIPBPNtiiTQ=
Date:   Sat, 27 Nov 2021 17:04:32 -0800
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
Subject:  +
 firmware_loader-move-firmware-sysctl-to-its-own-files.patch added to -mm
 tree
Message-ID: <20211128010432.ExP_4sOpG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: firmware_loader: move firmware sysctl to its own files
has been added to the -mm tree.  Its filename is
     firmware_loader-move-firmware-sysctl-to-its-own-files.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/firmware_loader-move-firmware-sysctl-to-its-own-files.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/firmware_loader-move-firmware-sysctl-to-its-own-files.patch

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
Subject: firmware_loader: move firmware sysctl to its own files

Patch series "sysctl: 3rd set of kernel/sysctl cleanups", v2.

This is the third set of patches to help address cleaning the kitchen
seink in kernel/sysctl.c and to move sysctls away to where they are
actually implemented / used.


This patch (of 8):

kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we just
care about the core logic.

So move the firmware configuration sysctl table to the only place where it
is used, and make it clear that if sysctls are disabled this is not used.

[mcgrof@kernel.org: major commit log update to justify the move]
Link: https://lkml.kernel.org/r/20211124231435.1445213-1-mcgrof@kernel.org
Link: https://lkml.kernel.org/r/20211124231435.1445213-2-mcgrof@kernel.org
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Stephen Kitt <steve@sk2.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: James E.J. Bottomley <jejb@linux.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: David Airlie <airlied@linux.ie>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Julia Lawall <julia.lawall@inria.fr>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Phillip Potter <phil@philpotter.co.uk>
Cc: Qing Wang <wangqing@vivo.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/firmware_loader/fallback.c       |    7 ++++-
 drivers/base/firmware_loader/fallback.h       |   11 ++++++++
 drivers/base/firmware_loader/fallback_table.c |   21 ++++++++++++++--
 include/linux/sysctl.h                        |    1 
 kernel/sysctl.c                               |    7 -----
 5 files changed, 36 insertions(+), 11 deletions(-)

--- a/drivers/base/firmware_loader/fallback.c~firmware_loader-move-firmware-sysctl-to-its-own-files
+++ a/drivers/base/firmware_loader/fallback.c
@@ -199,11 +199,16 @@ static struct class firmware_class = {
 
 int register_sysfs_loader(void)
 {
-	return class_register(&firmware_class);
+	int ret = class_register(&firmware_class);
+
+	if (ret != 0)
+		return ret;
+	return register_firmware_config_sysctl();
 }
 
 void unregister_sysfs_loader(void)
 {
+	unregister_firmware_config_sysctl();
 	class_unregister(&firmware_class);
 }
 
--- a/drivers/base/firmware_loader/fallback.h~firmware_loader-move-firmware-sysctl-to-its-own-files
+++ a/drivers/base/firmware_loader/fallback.h
@@ -42,6 +42,17 @@ void fw_fallback_set_default_timeout(voi
 
 int register_sysfs_loader(void);
 void unregister_sysfs_loader(void);
+#ifdef CONFIG_SYSCTL
+extern int register_firmware_config_sysctl(void);
+extern void unregister_firmware_config_sysctl(void);
+#else
+static inline int register_firmware_config_sysctl(void)
+{
+	return 0;
+}
+static inline void unregister_firmware_config_sysctl(void) { }
+#endif /* CONFIG_SYSCTL */
+
 #else /* CONFIG_FW_LOADER_USER_HELPER */
 static inline int firmware_fallback_sysfs(struct firmware *fw, const char *name,
 					  struct device *device,
--- a/drivers/base/firmware_loader/fallback_table.c~firmware_loader-move-firmware-sysctl-to-its-own-files
+++ a/drivers/base/firmware_loader/fallback_table.c
@@ -24,7 +24,7 @@ struct firmware_fallback_config fw_fallb
 EXPORT_SYMBOL_NS_GPL(fw_fallback_config, FIRMWARE_LOADER_PRIVATE);
 
 #ifdef CONFIG_SYSCTL
-struct ctl_table firmware_config_table[] = {
+static struct ctl_table firmware_config_table[] = {
 	{
 		.procname	= "force_sysfs_fallback",
 		.data		= &fw_fallback_config.force_sysfs_fallback,
@@ -45,4 +45,21 @@ struct ctl_table firmware_config_table[]
 	},
 	{ }
 };
-#endif
+
+static struct ctl_table_header *firmware_config_sysct_table_header;
+int register_firmware_config_sysctl(void)
+{
+	firmware_config_sysct_table_header =
+		register_sysctl("kernel/firmware_config",
+				firmware_config_table);
+	if (!firmware_config_sysct_table_header)
+		return -ENOMEM;
+	return 0;
+}
+
+void unregister_firmware_config_sysctl(void)
+{
+	unregister_sysctl_table(firmware_config_sysct_table_header);
+	firmware_config_sysct_table_header = NULL;
+}
+#endif /* CONFIG_SYSCTL */
--- a/include/linux/sysctl.h~firmware_loader-move-firmware-sysctl-to-its-own-files
+++ a/include/linux/sysctl.h
@@ -218,7 +218,6 @@ extern int no_unaligned_warning;
 
 extern struct ctl_table sysctl_mount_point[];
 extern struct ctl_table random_table[];
-extern struct ctl_table firmware_config_table[];
 
 #else /* CONFIG_SYSCTL */
 static inline struct ctl_table_header *register_sysctl_table(struct ctl_table * table)
--- a/kernel/sysctl.c~firmware_loader-move-firmware-sysctl-to-its-own-files
+++ a/kernel/sysctl.c
@@ -2153,13 +2153,6 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0555,
 		.child		= usermodehelper_table,
 	},
-#ifdef CONFIG_FW_LOADER_USER_HELPER
-	{
-		.procname	= "firmware_config",
-		.mode		= 0555,
-		.child		= firmware_config_table,
-	},
-#endif
 	{
 		.procname	= "overflowuid",
 		.data		= &overflowuid,
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

