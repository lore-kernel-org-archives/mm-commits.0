Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B0C9ECAAA1
	for <mm-commits@archiver.kernel.org>; Fri,  9 Sep 2022 22:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbiIIWBl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Sep 2022 18:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231395AbiIIWB0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Sep 2022 18:01:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D99D144807
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 15:01:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EDAE62116
        for <mm-commits@vger.kernel.org>; Fri,  9 Sep 2022 22:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6800C433D6;
        Fri,  9 Sep 2022 22:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662760883;
        bh=6YpXKGy5NSHLbot9QG8UocVZMH1wSKhzzkVCdrF/eas=;
        h=Date:To:From:Subject:From;
        b=H7O2vT/L1Ch8Hh3Owg0T6GmojSfCebTakdsBGDmu/r/NFSN8iZImUuGAcTFttMDz3
         UzbS3zxcrWA9qxHVf3+ZVTBC5c03E0yYukpHde6e1TIFEq+42XVDYED8ExwoQvZZns
         eODu59G8frqPEv28IUNmJajQmOQeSp93AxZWpEbc=
Date:   Fri, 09 Sep 2022 15:01:23 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-remove-duplicate-get_monitoring_region-definitions.patch added to mm-unstable branch
Message-Id: <20220909220123.C6800C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: remove duplicate get_monitoring_region() definitions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-remove-duplicate-get_monitoring_region-definitions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-remove-duplicate-get_monitoring_region-definitions.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon: remove duplicate get_monitoring_region() definitions
Date: Fri, 9 Sep 2022 21:36:06 +0000

In lru_sort.c and reclaim.c, they are all defining get_monitoring_region()
function, there is no need to define it separately.

As 'get_monitoring_region()' is not a 'static' function anymore, we try to
use a prefix to distinguish with other functions, so there rename it to
'damon_find_biggest_system_ram'.

Link: https://lkml.kernel.org/r/20220909213606.136221-1-sj@kernel.org
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Suggested-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 ++
 mm/damon/core.c       |   40 ++++++++++++++++++++++++++++++++++++++++
 mm/damon/lru_sort.c   |   37 ++-----------------------------------
 mm/damon/reclaim.c    |   37 ++-----------------------------------
 4 files changed, 46 insertions(+), 70 deletions(-)

--- a/include/linux/damon.h~mm-damon-remove-duplicate-get_monitoring_region-definitions
+++ a/include/linux/damon.h
@@ -549,6 +549,8 @@ static inline bool damon_target_has_pid(
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive);
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
 
+bool damon_find_biggest_system_ram(unsigned long *start, unsigned long *end);
+
 #endif	/* CONFIG_DAMON */
 
 #endif	/* _DAMON_H */
--- a/mm/damon/core.c~mm-damon-remove-duplicate-get_monitoring_region-definitions
+++ a/mm/damon/core.c
@@ -1239,4 +1239,44 @@ static int kdamond_fn(void *data)
 	return 0;
 }
 
+/*
+ * struct damon_system_ram_region - System RAM resource address region of
+ *				    [@start, @end).
+ * @start:	Start address of the region (inclusive).
+ * @end:	End address of the region (exclusive).
+ */
+struct damon_system_ram_region {
+	unsigned long start;
+	unsigned long end;
+};
+
+static int walk_system_ram(struct resource *res, void *arg)
+{
+	struct damon_system_ram_region *a = arg;
+
+	if (a->end - a->start < resource_size(res)) {
+		a->start = res->start;
+		a->end = res->end;
+	}
+	return 0;
+}
+
+/*
+ * Find biggest 'System RAM' resource and store its start and end address in
+ * @start and @end, respectively.  If no System RAM is found, returns false.
+ */
+bool damon_find_biggest_system_ram(unsigned long *start, unsigned long *end)
+
+{
+	struct damon_system_ram_region arg = {};
+
+	walk_system_ram_res(0, ULONG_MAX, &arg, walk_system_ram);
+	if (arg.end <= arg.start)
+		return false;
+
+	*start = arg.start;
+	*end = arg.end;
+	return true;
+}
+
 #include "core-test.h"
--- a/mm/damon/lru_sort.c~mm-damon-remove-duplicate-get_monitoring_region-definitions
+++ a/mm/damon/lru_sort.c
@@ -257,39 +257,6 @@ module_param(nr_cold_quota_exceeds, ulon
 static struct damon_ctx *ctx;
 static struct damon_target *target;
 
-struct damon_lru_sort_ram_walk_arg {
-	unsigned long start;
-	unsigned long end;
-};
-
-static int walk_system_ram(struct resource *res, void *arg)
-{
-	struct damon_lru_sort_ram_walk_arg *a = arg;
-
-	if (a->end - a->start < resource_size(res)) {
-		a->start = res->start;
-		a->end = res->end;
-	}
-	return 0;
-}
-
-/*
- * Find biggest 'System RAM' resource and store its start and end address in
- * @start and @end, respectively.  If no System RAM is found, returns false.
- */
-static bool get_monitoring_region(unsigned long *start, unsigned long *end)
-{
-	struct damon_lru_sort_ram_walk_arg arg = {};
-
-	walk_system_ram_res(0, ULONG_MAX, &arg, walk_system_ram);
-	if (arg.end <= arg.start)
-		return false;
-
-	*start = arg.start;
-	*end = arg.end;
-	return true;
-}
-
 /* Create a DAMON-based operation scheme for hot memory regions */
 static struct damos *damon_lru_sort_new_hot_scheme(unsigned int hot_thres)
 {
@@ -414,8 +381,8 @@ static int damon_lru_sort_apply_paramete
 	if (monitor_region_start > monitor_region_end)
 		return -EINVAL;
 	if (!monitor_region_start && !monitor_region_end &&
-			!get_monitoring_region(&monitor_region_start,
-				&monitor_region_end))
+	    !damon_find_biggest_system_ram(&monitor_region_start,
+					   &monitor_region_end))
 		return -EINVAL;
 	addr_range.start = monitor_region_start;
 	addr_range.end = monitor_region_end;
--- a/mm/damon/reclaim.c~mm-damon-remove-duplicate-get_monitoring_region-definitions
+++ a/mm/damon/reclaim.c
@@ -229,39 +229,6 @@ module_param(nr_quota_exceeds, ulong, 04
 static struct damon_ctx *ctx;
 static struct damon_target *target;
 
-struct damon_reclaim_ram_walk_arg {
-	unsigned long start;
-	unsigned long end;
-};
-
-static int walk_system_ram(struct resource *res, void *arg)
-{
-	struct damon_reclaim_ram_walk_arg *a = arg;
-
-	if (a->end - a->start < resource_size(res)) {
-		a->start = res->start;
-		a->end = res->end;
-	}
-	return 0;
-}
-
-/*
- * Find biggest 'System RAM' resource and store its start and end address in
- * @start and @end, respectively.  If no System RAM is found, returns false.
- */
-static bool get_monitoring_region(unsigned long *start, unsigned long *end)
-{
-	struct damon_reclaim_ram_walk_arg arg = {};
-
-	walk_system_ram_res(0, ULONG_MAX, &arg, walk_system_ram);
-	if (arg.end <= arg.start)
-		return false;
-
-	*start = arg.start;
-	*end = arg.end;
-	return true;
-}
-
 static struct damos *damon_reclaim_new_scheme(void)
 {
 	struct damos_access_pattern pattern = {
@@ -328,8 +295,8 @@ static int damon_reclaim_apply_parameter
 	if (monitor_region_start > monitor_region_end)
 		return -EINVAL;
 	if (!monitor_region_start && !monitor_region_end &&
-			!get_monitoring_region(&monitor_region_start,
-				&monitor_region_end))
+	    !damon_find_biggest_system_ram(&monitor_region_start,
+					   &monitor_region_end))
 		return -EINVAL;
 	addr_range.start = monitor_region_start;
 	addr_range.end = monitor_region_end;
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are

mm-damon-simply-damon_ctx-check-in-damon_sysfs_before_terminate.patch
mm-damon-remove-duplicate-get_monitoring_region-definitions.patch

