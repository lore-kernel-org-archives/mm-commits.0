Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A39C433FE
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377888AbiATV2Z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377891AbiATV2Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:28:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347C6C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:28:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5E1AB81E68
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877CCC340E0;
        Thu, 20 Jan 2022 21:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714101;
        bh=Eb4eRGUA8FZuteUCtEtph5YSdr+EFsE95hH5EqQ1GcU=;
        h=Date:From:To:Subject:From;
        b=rnmVPpmOW9RU0gBttCfxTPfGsjoCJWIUfJxX7CFdqLmqgPi2tYFwheTUQ6VaazqXW
         cZcLlcLvHHKn+Njdsb8UqnygJDltjDGICnLlesJQbFj8IAOGAuqYq82D4u4FSlggAx
         sISf/5FnbkdG8x870OOqPuJ1q8dMv/+cbzVGqQjQ=
Date:   Thu, 20 Jan 2022 13:28:21 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        songmuchun@bytedance.com, xhao@linux.alibaba.com
Subject:  [merged]
 mm-damon-remove-some-no-need-func-definitions-in-damonh-file.patch removed
 from -mm tree
Message-ID: <20220120212821.37sPBLODZ%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: remove some unneeded function definitions in damon.h
has been removed from the -mm tree.  Its filename was
     mm-damon-remove-some-no-need-func-definitions-in-damonh-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon: remove some unneeded function definitions in damon.h

In damon.h some func definitions about VA & PA can only be used in its own
file, so there no need to define in the header file, and the header file
will look cleaner.

If other files later need these functions, the prototypes can be added to
damon.h at that time.

[sj@kernel.org: remove unnecessary function prototype position changes]
 Link: https://lkml.kernel.org/r/20211118114827.20052-1-sj@kernel.org
Link: https://lkml.kernel.org/r/45fd5b3ef6cce8e28dbc1c92f9dc845ccfc949d7.1636989871.git.xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   21 ---------------------
 mm/damon/paddr.c      |   11 ++++++-----
 mm/damon/vaddr.c      |   18 ++++++++++--------
 3 files changed, 16 insertions(+), 34 deletions(-)

--- a/include/linux/damon.h~mm-damon-remove-some-no-need-func-definitions-in-damonh-file
+++ a/include/linux/damon.h
@@ -461,34 +461,13 @@ int damon_stop(struct damon_ctx **ctxs,
 #endif	/* CONFIG_DAMON */
 
 #ifdef CONFIG_DAMON_VADDR
-
-/* Monitoring primitives for virtual memory address spaces */
-void damon_va_init(struct damon_ctx *ctx);
-void damon_va_update(struct damon_ctx *ctx);
-void damon_va_prepare_access_checks(struct damon_ctx *ctx);
-unsigned int damon_va_check_accesses(struct damon_ctx *ctx);
 bool damon_va_target_valid(void *t);
-void damon_va_cleanup(struct damon_ctx *ctx);
-int damon_va_apply_scheme(struct damon_ctx *context, struct damon_target *t,
-		struct damon_region *r, struct damos *scheme);
-int damon_va_scheme_score(struct damon_ctx *context, struct damon_target *t,
-		struct damon_region *r, struct damos *scheme);
 void damon_va_set_primitives(struct damon_ctx *ctx);
-
 #endif	/* CONFIG_DAMON_VADDR */
 
 #ifdef CONFIG_DAMON_PADDR
-
-/* Monitoring primitives for the physical memory address space */
-void damon_pa_prepare_access_checks(struct damon_ctx *ctx);
-unsigned int damon_pa_check_accesses(struct damon_ctx *ctx);
 bool damon_pa_target_valid(void *t);
-int damon_pa_apply_scheme(struct damon_ctx *context, struct damon_target *t,
-		struct damon_region *r, struct damos *scheme);
-int damon_pa_scheme_score(struct damon_ctx *context, struct damon_target *t,
-		struct damon_region *r, struct damos *scheme);
 void damon_pa_set_primitives(struct damon_ctx *ctx);
-
 #endif	/* CONFIG_DAMON_PADDR */
 
 #endif	/* _DAMON_H */
--- a/mm/damon/paddr.c~mm-damon-remove-some-no-need-func-definitions-in-damonh-file
+++ a/mm/damon/paddr.c
@@ -73,7 +73,7 @@ static void __damon_pa_prepare_access_ch
 	damon_pa_mkold(r->sampling_addr);
 }
 
-void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
+static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
 	struct damon_region *r;
@@ -192,7 +192,7 @@ static void __damon_pa_check_access(stru
 	last_addr = r->sampling_addr;
 }
 
-unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
+static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
 	struct damon_region *r;
@@ -213,7 +213,7 @@ bool damon_pa_target_valid(void *t)
 	return true;
 }
 
-int damon_pa_apply_scheme(struct damon_ctx *ctx, struct damon_target *t,
+static int damon_pa_apply_scheme(struct damon_ctx *ctx, struct damon_target *t,
 		struct damon_region *r, struct damos *scheme)
 {
 	unsigned long addr;
@@ -246,8 +246,9 @@ int damon_pa_apply_scheme(struct damon_c
 	return 0;
 }
 
-int damon_pa_scheme_score(struct damon_ctx *context, struct damon_target *t,
-		struct damon_region *r, struct damos *scheme)
+static int damon_pa_scheme_score(struct damon_ctx *context,
+		struct damon_target *t, struct damon_region *r,
+		struct damos *scheme)
 {
 	switch (scheme->action) {
 	case DAMOS_PAGEOUT:
--- a/mm/damon/vaddr.c~mm-damon-remove-some-no-need-func-definitions-in-damonh-file
+++ a/mm/damon/vaddr.c
@@ -272,7 +272,7 @@ static void __damon_va_init_regions(stru
 }
 
 /* Initialize '->regions_list' of every target (task) */
-void damon_va_init(struct damon_ctx *ctx)
+static void damon_va_init(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
 
@@ -292,7 +292,8 @@ void damon_va_init(struct damon_ctx *ctx
  *
  * Returns true if it is.
  */
-static bool damon_intersect(struct damon_region *r, struct damon_addr_range *re)
+static bool damon_intersect(struct damon_region *r,
+		struct damon_addr_range *re)
 {
 	return !(r->ar.end <= re->start || re->end <= r->ar.start);
 }
@@ -356,7 +357,7 @@ static void damon_va_apply_three_regions
 /*
  * Update regions for current memory mappings
  */
-void damon_va_update(struct damon_ctx *ctx)
+static void damon_va_update(struct damon_ctx *ctx)
 {
 	struct damon_addr_range three_regions[3];
 	struct damon_target *t;
@@ -418,7 +419,7 @@ static void __damon_va_prepare_access_ch
 	damon_va_mkold(mm, r->sampling_addr);
 }
 
-void damon_va_prepare_access_checks(struct damon_ctx *ctx)
+static void damon_va_prepare_access_checks(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
 	struct mm_struct *mm;
@@ -539,7 +540,7 @@ static void __damon_va_check_access(stru
 	last_addr = r->sampling_addr;
 }
 
-unsigned int damon_va_check_accesses(struct damon_ctx *ctx)
+static unsigned int damon_va_check_accesses(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
 	struct mm_struct *mm;
@@ -603,7 +604,7 @@ out:
 }
 #endif	/* CONFIG_ADVISE_SYSCALLS */
 
-int damon_va_apply_scheme(struct damon_ctx *ctx, struct damon_target *t,
+static int damon_va_apply_scheme(struct damon_ctx *ctx, struct damon_target *t,
 		struct damon_region *r, struct damos *scheme)
 {
 	int madv_action;
@@ -633,8 +634,9 @@ int damon_va_apply_scheme(struct damon_c
 	return damos_madvise(t, r, madv_action);
 }
 
-int damon_va_scheme_score(struct damon_ctx *context, struct damon_target *t,
-		struct damon_region *r, struct damos *scheme)
+static int damon_va_scheme_score(struct damon_ctx *context,
+		struct damon_target *t, struct damon_region *r,
+		struct damos *scheme)
 {
 
 	switch (scheme->action) {
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are


