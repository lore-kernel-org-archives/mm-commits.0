Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 480FAC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 28 Nov 2021 01:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245022AbhK1BKD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Nov 2021 20:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356756AbhK1BIC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Nov 2021 20:08:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B917AC061757
        for <mm-commits@vger.kernel.org>; Sat, 27 Nov 2021 17:04:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29C49B80B2F
        for <mm-commits@vger.kernel.org>; Sun, 28 Nov 2021 01:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9ECC53FBF;
        Sun, 28 Nov 2021 01:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638061478;
        bh=wTExu1wYrbLeLeXceQ4IqFawdAZi4z+tQmC/7k9lEJ8=;
        h=Date:From:To:Subject:From;
        b=DN0+c7EWVjTlaY0ffm3szGhbtIilz0tfkdsUVl6Tw+OJDBU59MvHvml1nXXYaRg9/
         3kC4tXu5iGPxjhkpxmU+LqCK1XpUKDYvp6Ur1DNlYmqwjYkjL8xXXykIN5nS9G4hPs
         ZDDPMh67AVULH1wSj1x3th8uN4p0rqAbTEIzgNvg=
Date:   Sat, 27 Nov 2021 17:04:37 -0800
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
 random-move-the-random-sysctl-declarations-to-its-own-file.patch added to
 -mm tree
Message-ID: <20211128010437.r_u1dimvB%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: random: move the random sysctl declarations to its own file
has been added to the -mm tree.  Its filename is
     random-move-the-random-sysctl-declarations-to-its-own-file.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/random-move-the-random-sysctl-declarations-to-its-own-file.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/random-move-the-random-sysctl-declarations-to-its-own-file.patch

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
Subject: random: move the random sysctl declarations to its own file

kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we just
care about the core logic.

So move the random sysctls to their own file and use register_sysctl_init().

[mcgrof@kernel.org: commit log update to justify the move]
Link: https://lkml.kernel.org/r/20211124231435.1445213-3-mcgrof@kernel.org
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

 drivers/char/random.c  |   14 ++++++++++++--
 include/linux/sysctl.h |    1 -
 kernel/sysctl.c        |    5 -----
 3 files changed, 12 insertions(+), 8 deletions(-)

--- a/drivers/char/random.c~random-move-the-random-sysctl-declarations-to-its-own-file
+++ a/drivers/char/random.c
@@ -2077,8 +2077,7 @@ static int proc_do_entropy(struct ctl_ta
 }
 
 static int sysctl_poolsize = INPUT_POOL_WORDS * 32;
-extern struct ctl_table random_table[];
-struct ctl_table random_table[] = {
+static struct ctl_table random_table[] = {
 	{
 		.procname	= "poolsize",
 		.data		= &sysctl_poolsize,
@@ -2140,6 +2139,17 @@ struct ctl_table random_table[] = {
 #endif
 	{ }
 };
+
+/*
+ * rand_initialize() is called before sysctl_init(),
+ * so we cannot call register_sysctl_init() in rand_initialize()
+ */
+static int __init random_sysctls_init(void)
+{
+	register_sysctl_init("kernel/random", random_table);
+	return 0;
+}
+device_initcall(random_sysctls_init);
 #endif 	/* CONFIG_SYSCTL */
 
 struct batched_entropy {
--- a/include/linux/sysctl.h~random-move-the-random-sysctl-declarations-to-its-own-file
+++ a/include/linux/sysctl.h
@@ -217,7 +217,6 @@ extern int unaligned_dump_stack;
 extern int no_unaligned_warning;
 
 extern struct ctl_table sysctl_mount_point[];
-extern struct ctl_table random_table[];
 
 #else /* CONFIG_SYSCTL */
 static inline struct ctl_table_header *register_sysctl_table(struct ctl_table * table)
--- a/kernel/sysctl.c~random-move-the-random-sysctl-declarations-to-its-own-file
+++ a/kernel/sysctl.c
@@ -2144,11 +2144,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= sysctl_max_threads,
 	},
 	{
-		.procname	= "random",
-		.mode		= 0555,
-		.child		= random_table,
-	},
-	{
 		.procname	= "usermodehelper",
 		.mode		= 0555,
 		.child		= usermodehelper_table,
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

