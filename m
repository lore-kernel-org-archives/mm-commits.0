Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 030BDC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 23 Jan 2022 23:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240481AbiAWXzk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 23 Jan 2022 18:55:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50346 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbiAWXzj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 23 Jan 2022 18:55:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55EBC611E9
        for <mm-commits@vger.kernel.org>; Sun, 23 Jan 2022 23:55:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68164C340E3;
        Sun, 23 Jan 2022 23:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642982138;
        bh=9UCMnIgkTlS/5nJHN4nLz+/s/bt+2by236EyrITZTY0=;
        h=Date:From:To:Subject:From;
        b=YRlxf9yEmTk4zunLnAmGqWoN8+Gb2JzAHFR7BieuKR7EtbRhzGgWGpMThrfXaPeqx
         uyEuJ5RtF8MXqEjfFJ/AYayYyuDaALQP7rqftcSRxZ56/ay6pBwLc90D0xb8mNEe1X
         Lc/02mYqXpvYUdSMMl7gXlhCINvgnb/nvhAzHm3s=
Date:   Sun, 23 Jan 2022 15:55:36 -0800
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
Subject:  [merged]
 sysctl-use-const-for-typically-used-max-min-proc-sysctls.patch removed from
 -mm tree
Message-ID: <20220123235536.Qe5XwIjQh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: use const for typically used max/min proc sysctls
has been removed from the -mm tree.  Its filename was
     sysctl-use-const-for-typically-used-max-min-proc-sysctls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 kernel/sysctl.c |   53 ++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

--- a/kernel/sysctl.c~sysctl-use-const-for-typically-used-max-min-proc-sysctls
+++ a/kernel/sysctl.c
@@ -108,27 +108,26 @@
 
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
@@ -172,8 +171,8 @@ int sysctl_legacy_va_layout;
 #endif
 
 #ifdef CONFIG_COMPACTION
-static int min_extfrag_threshold;
-static int max_extfrag_threshold = 1000;
+static const int min_extfrag_threshold;
+static const int max_extfrag_threshold = 1000;
 #endif
 
 #endif /* CONFIG_SYSCTL */
@@ -2177,8 +2176,8 @@ static struct ctl_table kern_table[] = {
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
@@ -2186,8 +2185,8 @@ static struct ctl_table kern_table[] = {
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
@@ -2261,7 +2260,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &ten_thousand,
+		.extra2		= (void *)&ten_thousand,
 	},
 	{
 		.procname	= "printk_devkmsg",
@@ -2473,7 +2472,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= perf_event_max_stack_handler,
 		.extra1		= SYSCTL_ZERO,
-		.extra2		= &six_hundred_forty_kb,
+		.extra2		= (void *)&six_hundred_forty_kb,
 	},
 	{
 		.procname	= "perf_event_max_contexts_per_stack",
@@ -2629,7 +2628,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(dirty_background_bytes),
 		.mode		= 0644,
 		.proc_handler	= dirty_background_bytes_handler,
-		.extra1		= &one_ul,
+		.extra1		= (void *)&one_ul,
 	},
 	{
 		.procname	= "dirty_ratio",
@@ -2646,7 +2645,7 @@ static struct ctl_table vm_table[] = {
 		.maxlen		= sizeof(vm_dirty_bytes),
 		.mode		= 0644,
 		.proc_handler	= dirty_bytes_handler,
-		.extra1		= &dirty_bytes_min,
+		.extra1		= (void *)&dirty_bytes_min,
 	},
 	{
 		.procname	= "dirty_writeback_centisecs",
@@ -2760,8 +2759,8 @@ static struct ctl_table vm_table[] = {
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
@@ -3047,8 +3046,8 @@ static struct ctl_table fs_table[] = {
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
@@ -3072,8 +3071,8 @@ static struct ctl_table fs_table[] = {
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
@@ -3081,8 +3080,8 @@ static struct ctl_table fs_table[] = {
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


