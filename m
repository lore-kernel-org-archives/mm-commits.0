Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14718C433FE
	for <mm-commits@archiver.kernel.org>; Wed, 24 Nov 2021 00:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240623AbhKXARB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 23 Nov 2021 19:17:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:50212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240606AbhKXARA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 23 Nov 2021 19:17:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6565261038;
        Wed, 24 Nov 2021 00:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637712831;
        bh=QhdhVxlGRoWz06yTsn40At4MtytIcIncOpYFpOw+ZDU=;
        h=Date:From:To:Subject:From;
        b=Ftsay3tboNeg9yCqgJK1D/GDp6mRlhSH/oTWNRpvnSslyHZ98BPK838kSrLrs26Ss
         WVxqElElRfyhdsBF3QwbNh1W6zu5xZEAyICn8b9st+HazxGnDXnNg8vt/IQKMA8LEn
         A46Izz8eCW9Ip663Q8YjFsUObH2lXLku5DlvLQho=
Date:   Tue, 23 Nov 2021 16:13:49 -0800
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
Subject:  +
 sysctl-use-const-for-typically-used-max-min-proc-sysctls.patch added to -mm
 tree
Message-ID: <20211124001349.dpYe4-cCH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: use const for typically used max/min proc sysctls
has been added to the -mm tree.  Its filename is
     sysctl-use-const-for-typically-used-max-min-proc-sysctls.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/sysctl-use-const-for-typically-used-max-min-proc-sysctls.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/sysctl-use-const-for-typically-used-max-min-proc-sysctls.patch

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
Subject: sysctl: use const for typically used max/min proc sysctls

When proc_dointvec_minmax() or proc_doulongvec_minmax() are used we are
using the extra1 and extra2 parameters on the sysctl table only for a min
and max boundary, these extra1 and extra2 arguments are then used for
read-only operations.  So make them const to reflect this.

[mcgrof@kernel.org: commit log love]
Link: https://lkml.kernel.org/r/20211123202347.818157-7-mcgrof@kernel.org
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

 kernel/sysctl.c |   53 ++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

--- a/kernel/sysctl.c~sysctl-use-const-for-typically-used-max-min-proc-sysctls
+++ a/kernel/sysctl.c
@@ -107,27 +107,26 @@
 
 /* Constants used for minimum and  maximum */
 
-static unsigned long zero_ul;
-static unsigned long one_ul = 1;
-static unsigned long long_max = LONG_MAX;
+static const unsigned long zero_ul;
+static const unsigned long one_ul = 1;
+static const unsigned long long_max = LONG_MAX;
 #ifdef CONFIG_PRINTK
-static int ten_thousand = 10000;
+static const int ten_thousand = 10000;
 #endif
 #ifdef CONFIG_PERF_EVENTS
-static int six_hundred_forty_kb = 640 * 1024;
+static const int six_hundred_forty_kb = 640 * 1024;
 #endif
 
 /* this is needed for the proc_doulongvec_minmax of vm_dirty_bytes */
-static unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
+static const unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
 
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
-static int maxolduid = 65535;
-static int minolduid;
+static const int maxolduid = 65535;
+static const int minolduid;
 
 static const int ngroups_max = NGROUPS_MAX;
 static const int cap_last_cap = CAP_LAST_CAP;
 
-
 #ifdef CONFIG_INOTIFY_USER
 #include <linux/inotify.h>
 #endif
@@ -171,8 +170,8 @@ int sysctl_legacy_va_layout;
 #endif
 
 #ifdef CONFIG_COMPACTION
-static int min_extfrag_threshold;
-static int max_extfrag_threshold = 1000;
+static const int min_extfrag_threshold;
+static const int max_extfrag_threshold = 1000;
 #endif
 
 #endif /* CONFIG_SYSCTL */
@@ -2176,8 +2175,8 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &minolduid,
-		.extra2		= &maxolduid,
+		.extra1		= (void *)&minolduid,
+		.extra2		= (void *)&maxolduid,
 	},
 	{
 		.procname	= "overflowgid",
@@ -2185,8 +2184,8 @@ static struct ctl_table kern_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &minolduid,
-		.extra2		= &maxolduid,
+		.extra1		= (void *)&minolduid,
+		.extra2		= (void *)&maxolduid,
 	},
 #ifdef CONFIG_S390
 	{
@@ -2260,7 +2259,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &ten_thousand,
+		.extra2		= (void *)&ten_thousand,
 	},
 	{
 		.procname	= "printk_devkmsg",
@@ -2472,7 +2471,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= perf_event_max_stack_handler,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &six_hundred_forty_kb,
+		.extra2		= (void *)&six_hundred_forty_kb,
 	},
 	{
 		.procname	= "perf_event_max_contexts_per_stack",
@@ -2628,7 +2627,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(dirty_background_bytes),
 		.mode		= 0644,
 		.proc_handler	= dirty_background_bytes_handler,
-		.extra1		= &one_ul,
+		.extra1		= (void *)&one_ul,
 	},
 	{
 		.procname	= "dirty_ratio",
@@ -2645,7 +2644,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(vm_dirty_bytes),
 		.mode		= 0644,
 		.proc_handler	= dirty_bytes_handler,
-		.extra1		= &dirty_bytes_min,
+		.extra1		= (void *)&dirty_bytes_min,
 	},
 	{
 		.procname	= "dirty_writeback_centisecs",
@@ -2759,8 +2758,8 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &min_extfrag_threshold,
-		.extra2		= &max_extfrag_threshold,
+		.extra1		= (void *)&min_extfrag_threshold,
+		.extra2		= (void *)&max_extfrag_threshold,
 	},
 	{
 		.procname	= "compact_unevictable_allowed",
@@ -3046,8 +3045,8 @@ static struct ctl_table fs_table[] = {
 		.maxlen		= sizeof(files_stat.max_files),
 		.mode		= 0644,
 		.proc_handler	= proc_doulongvec_minmax,
-		.extra1		= &zero_ul,
-		.extra2		= &long_max,
+		.extra1		= (void *)&zero_ul,
+		.extra2		= (void *)&long_max,
 	},
 	{
 		.procname	= "nr_open",
@@ -3071,8 +3070,8 @@ static struct ctl_table fs_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &minolduid,
-		.extra2		= &maxolduid,
+		.extra1		= (void *)&minolduid,
+		.extra2		= (void *)&maxolduid,
 	},
 	{
 		.procname	= "overflowgid",
@@ -3080,8 +3079,8 @@ static struct ctl_table fs_table[] = {
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &minolduid,
-		.extra2		= &maxolduid,
+		.extra1		= (void *)&minolduid,
+		.extra2		= (void *)&maxolduid,
 	},
 #ifdef CONFIG_FILE_LOCKING
 	{
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

