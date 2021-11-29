Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF80AC433FE
	for <mm-commits@archiver.kernel.org>; Mon, 29 Nov 2021 22:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236775AbhK2XDC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 29 Nov 2021 18:03:02 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41204 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236599AbhK2XBQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Nov 2021 18:01:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 72EC0CE13DF
        for <mm-commits@vger.kernel.org>; Mon, 29 Nov 2021 22:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4CCC8D101;
        Mon, 29 Nov 2021 22:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638226674;
        bh=GEng91li0dLHK8JRgKn3eEDpBJWhe2vBM862uHKEb14=;
        h=Date:From:To:Subject:From;
        b=zTAQ3Kz2lmFITasv/F+RCFfHXsZX0VgcfH9QoO7OujpQEvsAj8jt7K2yHEsacwetE
         g4MJtCLkvQqLz8RDa6LF2GHM9GfEPtwaTMMqc8k3dKaqb4NzlPP+JBcCBt9m5y+vRz
         wlhXsKFVE3XxdaDDOsikRi6MwlTKp4/6J187RetU=
Date:   Mon, 29 Nov 2021 14:57:53 -0800
From:   akpm@linux-foundation.org
To:     anil.s.keshavamurthy@intel.com, christian.brauner@ubuntu.com,
        crope@iki.fi, davem@davemloft.net, ebiederm@xmission.com,
        ebiggers@google.com, keescook@chromium.org, kernel@tuxforce.de,
        mcgrof@kernel.org, mchehab@kernel.org, mhiramat@kernel.org,
        mm-commits@vger.kernel.org, naveen.n.rao@linux.ibm.com,
        nixiaoming@huawei.com, steve@sk2.org, viro@zeniv.linux.org.uk,
        yzaikin@google.com
Subject:  + printk-fix-build-warning-when-config_printk=n.patch
 added to -mm tree
Message-ID: <20211129225753.26B2sCSKY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: printk: fix build warning when CONFIG_PRINTK=n
has been added to the -mm tree.  Its filename is
     printk-fix-build-warning-when-config_printk=n.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/printk-fix-build-warning-when-config_printk%3Dn.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/printk-fix-build-warning-when-config_printk%3Dn.patch

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
Subject: printk: fix build warning when CONFIG_PRINTK=n

build warning when CONFIG_PRINTK=n
	kernel/printk/printk.c:175:5: warning: no previous prototype for
	 'devkmsg_sysctl_set_loglvl' [-Wmissing-prototypes]

devkmsg_sysctl_set_loglvl() is only used in sysctl.c when CONFIG_PRINTK=y,
but it participates in the build when CONFIG_PRINTK=n.  So add compile
dependency CONFIG_PRINTK=y && CONFIG_SYSCTL=y to fix the build warning.

Link: https://lkml.kernel.org/r/20211129211943.640266-5-mcgrof@kernel.org
Signed-off-by: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Antti Palosaari <crope@iki.fi>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Lukas Middendorf <kernel@tuxforce.de>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>
Cc: Stephen Kitt <steve@sk2.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/printk.h   |    4 ----
 kernel/printk/internal.h |    2 ++
 kernel/printk/printk.c   |    3 ++-
 3 files changed, 4 insertions(+), 5 deletions(-)

--- a/include/linux/printk.h~printk-fix-build-warning-when-config_printk=n
+++ a/include/linux/printk.h
@@ -183,10 +183,6 @@ extern bool printk_timed_ratelimit(unsig
 extern int printk_delay_msec;
 extern int dmesg_restrict;
 
-extern int
-devkmsg_sysctl_set_loglvl(struct ctl_table *table, int write, void *buf,
-			  size_t *lenp, loff_t *ppos);
-
 extern void wake_up_klogd(void);
 
 char *log_buf_addr_get(void);
--- a/kernel/printk/internal.h~printk-fix-build-warning-when-config_printk=n
+++ a/kernel/printk/internal.h
@@ -6,6 +6,8 @@
 
 #if defined(CONFIG_PRINTK) && defined(CONFIG_SYSCTL)
 void __init printk_sysctl_init(void);
+int devkmsg_sysctl_set_loglvl(struct ctl_table *table, int write,
+			      void *buffer, size_t *lenp, loff_t *ppos);
 #else
 #define printk_sysctl_init() do { } while (0)
 #endif
--- a/kernel/printk/printk.c~printk-fix-build-warning-when-config_printk=n
+++ a/kernel/printk/printk.c
@@ -171,7 +171,7 @@ static int __init control_devkmsg(char *
 __setup("printk.devkmsg=", control_devkmsg);
 
 char devkmsg_log_str[DEVKMSG_STR_MAX_SIZE] = "ratelimit";
-
+#if defined(CONFIG_PRINTK) && defined(CONFIG_SYSCTL)
 int devkmsg_sysctl_set_loglvl(struct ctl_table *table, int write,
 			      void *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -210,6 +210,7 @@ int devkmsg_sysctl_set_loglvl(struct ctl
 
 	return 0;
 }
+#endif /* CONFIG_PRINTK && CONFIG_SYSCTL */
 
 /* Number of registered extended console drivers. */
 static int nr_ext_console_drivers;
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
printk-fix-build-warning-when-config_printk=n.patch
fs-coredump-move-coredump-sysctls-into-its-own-file.patch
kprobe-move-sysctl_kprobes_optimization-to-kprobesc.patch

