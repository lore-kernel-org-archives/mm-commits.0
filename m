Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC39C433F5
	for <mm-commits@archiver.kernel.org>; Mon, 31 Jan 2022 23:24:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiAaXYD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 Jan 2022 18:24:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33084 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiAaXYC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 31 Jan 2022 18:24:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 321D7B82B29
        for <mm-commits@vger.kernel.org>; Mon, 31 Jan 2022 23:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00B1C340E8;
        Mon, 31 Jan 2022 23:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643671440;
        bh=8OsP1Piz0/9ZGGUBih1kVnN+sn+D6KExE20Wh/oedy4=;
        h=Date:To:From:Subject:From;
        b=vbESe8geYnu583LQQWhRgCJLE6PSndRwER6A0bz4EtjPSxaEWKEiDEaovvDwHJApB
         iMk43mv0dsvbvFkK/dtj1EDPlEOUH5knGMXjNmb6VP2sXmEtQHnzR7tyDzAAQeCnTl
         idib8MzwkWk3qMqQrg44OZ5NgaAaMth1Mvd0QV0E=
Received: by hp1 (sSMTP sendmail emulation); Mon, 31 Jan 2022 15:23:58 -0800
Date:   Mon, 31 Jan 2022 15:23:58 -0800
To:     mm-commits@vger.kernel.org, yzaikin@google.com, mcgrof@kernel.org,
        keescook@chromium.org, zhanglianjie@uniontech.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-page-writeback-sysctls-to-is-own-file.patch added to -mm tree
Message-Id: <20220131232358.D00B1C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move page-writeback sysctls to their own file
has been added to the -mm tree.  Its filename is
     mm-move-page-writeback-sysctls-to-is-own-file.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-move-page-writeback-sysctls-to-is-own-file.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-move-page-writeback-sysctls-to-is-own-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: zhanglianjie <zhanglianjie@uniontech.com>
Subject: mm: move page-writeback sysctls to their own file

kernel/sysctl.c is a kitchen sink where everyone leaves their dirty
dishes, this makes it very difficult to maintain.

To help with this maintenance let's start by moving sysctls to places
where they actually belong.  The proc sysctl maintainers do not want to
know what sysctl knobs you wish to add for your own piece of code, we just
care about the core logic.

So move the page-writeback sysctls to its own file.

Link: https://lkml.kernel.org/r/20220129012955.26594-1-zhanglianjie@uniontech.com
Signed-off-by: zhanglianjie <zhanglianjie@uniontech.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/writeback.h |   15 -----
 kernel/sysctl.c           |   69 -------------------------
 mm/page-writeback.c       |   99 ++++++++++++++++++++++++++++++++----
 3 files changed, 89 insertions(+), 94 deletions(-)

--- a/include/linux/writeback.h~mm-move-page-writeback-sysctls-to-is-own-file
+++ a/include/linux/writeback.h
@@ -345,28 +345,13 @@ void wb_domain_exit(struct wb_domain *do
 extern struct wb_domain global_wb_domain;
 
 /* These are exported to sysctl. */
-extern int dirty_background_ratio;
-extern unsigned long dirty_background_bytes;
-extern int vm_dirty_ratio;
-extern unsigned long vm_dirty_bytes;
 extern unsigned int dirty_writeback_interval;
 extern unsigned int dirty_expire_interval;
 extern unsigned int dirtytime_expire_interval;
-extern int vm_highmem_is_dirtyable;
 extern int laptop_mode;
 
-int dirty_background_ratio_handler(struct ctl_table *table, int write,
-		void *buffer, size_t *lenp, loff_t *ppos);
-int dirty_background_bytes_handler(struct ctl_table *table, int write,
-		void *buffer, size_t *lenp, loff_t *ppos);
-int dirty_ratio_handler(struct ctl_table *table, int write,
-		void *buffer, size_t *lenp, loff_t *ppos);
-int dirty_bytes_handler(struct ctl_table *table, int write,
-		void *buffer, size_t *lenp, loff_t *ppos);
 int dirtytime_interval_handler(struct ctl_table *table, int write,
 		void *buffer, size_t *lenp, loff_t *ppos);
-int dirty_writeback_centisecs_handler(struct ctl_table *table, int write,
-		void *buffer, size_t *lenp, loff_t *ppos);
 
 void global_dirty_limits(unsigned long *pbackground, unsigned long *pdirty);
 unsigned long wb_calc_thresh(struct bdi_writeback *wb, unsigned long thresh);
--- a/kernel/sysctl.c~mm-move-page-writeback-sysctls-to-is-own-file
+++ a/kernel/sysctl.c
@@ -100,8 +100,6 @@
 static const int six_hundred_forty_kb = 640 * 1024;
 #endif
 
-/* this is needed for the proc_doulongvec_minmax of vm_dirty_bytes */
-static const unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
 
 static const int ngroups_max = NGROUPS_MAX;
 static const int cap_last_cap = CAP_LAST_CAP;
@@ -2402,55 +2400,6 @@ static struct ctl_table vm_table[] = {
 		.extra1		= SYSCTL_ZERO,
 	},
 	{
-		.procname	= "dirty_background_ratio",
-		.data		= &dirty_background_ratio,
-		.maxlen		= sizeof(dirty_background_ratio),
-		.mode		= 0644,
-		.proc_handler	= dirty_background_ratio_handler,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE_HUNDRED,
-	},
-	{
-		.procname	= "dirty_background_bytes",
-		.data		= &dirty_background_bytes,
-		.maxlen		= sizeof(dirty_background_bytes),
-		.mode		= 0644,
-		.proc_handler	= dirty_background_bytes_handler,
-		.extra1		= SYSCTL_LONG_ONE,
-	},
-	{
-		.procname	= "dirty_ratio",
-		.data		= &vm_dirty_ratio,
-		.maxlen		= sizeof(vm_dirty_ratio),
-		.mode		= 0644,
-		.proc_handler	= dirty_ratio_handler,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE_HUNDRED,
-	},
-	{
-		.procname	= "dirty_bytes",
-		.data		= &vm_dirty_bytes,
-		.maxlen		= sizeof(vm_dirty_bytes),
-		.mode		= 0644,
-		.proc_handler	= dirty_bytes_handler,
-		.extra1		= (void *)&dirty_bytes_min,
-	},
-	{
-		.procname	= "dirty_writeback_centisecs",
-		.data		= &dirty_writeback_interval,
-		.maxlen		= sizeof(dirty_writeback_interval),
-		.mode		= 0644,
-		.proc_handler	= dirty_writeback_centisecs_handler,
-	},
-	{
-		.procname	= "dirty_expire_centisecs",
-		.data		= &dirty_expire_interval,
-		.maxlen		= sizeof(dirty_expire_interval),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-	},
-	{
 		.procname	= "dirtytime_expire_seconds",
 		.data		= &dirtytime_expire_interval,
 		.maxlen		= sizeof(dirtytime_expire_interval),
@@ -2622,13 +2571,6 @@ static struct ctl_table vm_table[] = {
 	},
 #endif
 	{
-		.procname	= "laptop_mode",
-		.data		= &laptop_mode,
-		.maxlen		= sizeof(laptop_mode),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_jiffies,
-	},
-	{
 		.procname	= "vfs_cache_pressure",
 		.data		= &sysctl_vfs_cache_pressure,
 		.maxlen		= sizeof(sysctl_vfs_cache_pressure),
@@ -2725,17 +2667,6 @@ static struct ctl_table vm_table[] = {
 		.extra1		= SYSCTL_ZERO,
 	},
 #endif
-#ifdef CONFIG_HIGHMEM
-	{
-		.procname	= "highmem_is_dirtyable",
-		.data		= &vm_highmem_is_dirtyable,
-		.maxlen		= sizeof(vm_highmem_is_dirtyable),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= SYSCTL_ONE,
-	},
-#endif
 #ifdef CONFIG_MEMORY_FAILURE
 	{
 		.procname	= "memory_failure_early_kill",
--- a/mm/page-writeback.c~mm-move-page-writeback-sysctls-to-is-own-file
+++ a/mm/page-writeback.c
@@ -70,30 +70,33 @@ static long ratelimit_pages = 32;
 /*
  * Start background writeback (via writeback threads) at this percentage
  */
-int dirty_background_ratio = 10;
+static int dirty_background_ratio = 10;
 
 /*
  * dirty_background_bytes starts at 0 (disabled) so that it is a function of
  * dirty_background_ratio * the amount of dirtyable memory
  */
-unsigned long dirty_background_bytes;
+static unsigned long dirty_background_bytes;
 
 /*
  * free highmem will not be subtracted from the total free memory
  * for calculating free ratios if vm_highmem_is_dirtyable is true
  */
-int vm_highmem_is_dirtyable;
+static int vm_highmem_is_dirtyable;
 
 /*
  * The generator of dirty data starts writeback at this percentage
  */
-int vm_dirty_ratio = 20;
+static int vm_dirty_ratio = 20;
+
+/* this is needed for the proc_doulongvec_minmax of vm_dirty_bytes */
+static const unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
 
 /*
  * vm_dirty_bytes starts at 0 (disabled) so that it is a function of
  * vm_dirty_ratio * the amount of dirtyable memory
  */
-unsigned long vm_dirty_bytes;
+static unsigned long vm_dirty_bytes;
 
 /*
  * The interval between `kupdate'-style writebacks
@@ -503,7 +506,7 @@ bool node_dirty_ok(struct pglist_data *p
 	return nr_pages <= limit;
 }
 
-int dirty_background_ratio_handler(struct ctl_table *table, int write,
+static int dirty_background_ratio_handler(struct ctl_table *table, int write,
 		void *buffer, size_t *lenp, loff_t *ppos)
 {
 	int ret;
@@ -514,7 +517,7 @@ int dirty_background_ratio_handler(struc
 	return ret;
 }
 
-int dirty_background_bytes_handler(struct ctl_table *table, int write,
+static int dirty_background_bytes_handler(struct ctl_table *table, int write,
 		void *buffer, size_t *lenp, loff_t *ppos)
 {
 	int ret;
@@ -525,7 +528,7 @@ int dirty_background_bytes_handler(struc
 	return ret;
 }
 
-int dirty_ratio_handler(struct ctl_table *table, int write, void *buffer,
+static int dirty_ratio_handler(struct ctl_table *table, int write, void *buffer,
 		size_t *lenp, loff_t *ppos)
 {
 	int old_ratio = vm_dirty_ratio;
@@ -539,7 +542,7 @@ int dirty_ratio_handler(struct ctl_table
 	return ret;
 }
 
-int dirty_bytes_handler(struct ctl_table *table, int write,
+static int dirty_bytes_handler(struct ctl_table *table, int write,
 		void *buffer, size_t *lenp, loff_t *ppos)
 {
 	unsigned long old_bytes = vm_dirty_bytes;
@@ -1996,7 +1999,7 @@ bool wb_over_bg_thresh(struct bdi_writeb
 /*
  * sysctl handler for /proc/sys/vm/dirty_writeback_centisecs
  */
-int dirty_writeback_centisecs_handler(struct ctl_table *table, int write,
+static int dirty_writeback_centisecs_handler(struct ctl_table *table, int write,
 		void *buffer, size_t *length, loff_t *ppos)
 {
 	unsigned int old_interval = dirty_writeback_interval;
@@ -2081,6 +2084,79 @@ static int page_writeback_cpu_online(uns
 	return 0;
 }
 
+#ifdef CONFIG_SYSCTL
+static struct ctl_table vm_page_writeback_sysctls[] = {
+    {
+        .procname   = "dirty_background_ratio",
+        .data       = &dirty_background_ratio,
+        .maxlen     = sizeof(dirty_background_ratio),
+        .mode       = 0644,
+        .proc_handler   = dirty_background_ratio_handler,
+        .extra1     = SYSCTL_ZERO,
+        .extra2     = SYSCTL_ONE_HUNDRED,
+    },
+    {
+        .procname   = "dirty_background_bytes",
+        .data       = &dirty_background_bytes,
+        .maxlen     = sizeof(dirty_background_bytes),
+        .mode       = 0644,
+        .proc_handler   = dirty_background_bytes_handler,
+        .extra1     = SYSCTL_LONG_ONE,
+    },
+    {
+        .procname   = "dirty_ratio",
+        .data       = &vm_dirty_ratio,
+        .maxlen     = sizeof(vm_dirty_ratio),
+        .mode       = 0644,
+        .proc_handler   = dirty_ratio_handler,
+        .extra1     = SYSCTL_ZERO,
+        .extra2     = SYSCTL_ONE_HUNDRED,
+    },
+    {
+        .procname   = "dirty_bytes",
+        .data       = &vm_dirty_bytes,
+        .maxlen     = sizeof(vm_dirty_bytes),
+        .mode       = 0644,
+        .proc_handler   = dirty_bytes_handler,
+        .extra1     = (void *)&dirty_bytes_min,
+    },
+    {
+        .procname   = "dirty_writeback_centisecs",
+        .data       = &dirty_writeback_interval,
+        .maxlen     = sizeof(dirty_writeback_interval),
+        .mode       = 0644,
+        .proc_handler   = dirty_writeback_centisecs_handler,
+    },
+    {
+        .procname   = "dirty_expire_centisecs",
+        .data       = &dirty_expire_interval,
+        .maxlen     = sizeof(dirty_expire_interval),
+        .mode       = 0644,
+        .proc_handler   = proc_dointvec_minmax,
+        .extra1     = SYSCTL_ZERO,
+    },
+#ifdef CONFIG_HIGHMEM
+	{
+		.procname	= "highmem_is_dirtyable",
+		.data		= &vm_highmem_is_dirtyable,
+		.maxlen		= sizeof(vm_highmem_is_dirtyable),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
+#endif
+	{
+		.procname	= "laptop_mode",
+		.data		= &laptop_mode,
+		.maxlen		= sizeof(laptop_mode),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_jiffies,
+	},
+	{}
+};
+#endif
+
 /*
  * Called early on to tune the page writeback dirty limits.
  *
@@ -2105,6 +2181,9 @@ void __init page_writeback_init(void)
 			  page_writeback_cpu_online, NULL);
 	cpuhp_setup_state(CPUHP_MM_WRITEBACK_DEAD, "mm/writeback:dead", NULL,
 			  page_writeback_cpu_online);
+#ifdef CONFIG_SYSCTL
+	register_sysctl_init("vm", vm_page_writeback_sysctls);
+#endif
 }
 
 /**
_

Patches currently in -mm which might be from zhanglianjie@uniontech.com are

mm-move-page-writeback-sysctls-to-is-own-file.patch

