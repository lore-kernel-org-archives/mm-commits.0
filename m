Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B873C4167D
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 18:17:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 228DC633F4
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 18:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241061AbhKOSRn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 13:17:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:56280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240809AbhKOSNs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 13:13:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0D9A633CF;
        Mon, 15 Nov 2021 17:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636998518;
        bh=I7UA56AB8is49w2JUaedpkHmNjANJW57cKjPwLhpI/s=;
        h=Date:From:To:Subject:From;
        b=jyZzm84pSiLaoFBE+kNPbsvCLTVLFrri1e6pByrb6PgvKLH1xwo0QnDdZu/1ZlnSo
         s23ndT+7t858B28AbnAvMDW+3iHAb7BFcmGCLohRxMY6mMwoitsKMA0lDue25vfpD8
         1+8xwwcLPOm7ZKP8fR9B315mtr8LcybgcZTP8cAY=
Date:   Mon, 15 Nov 2021 09:48:37 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        songmuchun@bytedance.com, xhao@linux.alibaba.com
Subject:  +
 mm-damon-remove-some-no-need-func-definitions-in-damonh-file.patch added to
 -mm tree
Message-ID: <20211115174837.wvyS8FbLx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: remove some unneeded function definitions in damon.h
has been added to the -mm tree.  Its filename is
     mm-damon-remove-some-no-need-func-definitions-in-damonh-file.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-remove-some-no-need-func-definitions-in-damonh-file.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-remove-some-no-need-func-definitions-in-damonh-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon: remove some unneeded function definitions in damon.h

In the damon.h header file, some func definitions about VA & PA can only
be used in its own file, so there no need to define in the header file,
and the header file will looks cleaner.

If other files later call these functions, then put them to the header
file will not be late.

Link: https://lkml.kernel.org/r/45fd5b3ef6cce8e28dbc1c92f9dc845ccfc949d7.1636989871.git.xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   25 ++-----------------------
 mm/damon/paddr.c      |    8 ++++----
 mm/damon/vaddr.c      |   12 ++++++------
 3 files changed, 12 insertions(+), 33 deletions(-)

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
-bool damon_va_target_valid(void *t);
-void damon_va_cleanup(struct damon_ctx *ctx);
-int damon_va_apply_scheme(struct damon_ctx *context, struct damon_target *t,
-		struct damon_region *r, struct damos *scheme);
-int damon_va_scheme_score(struct damon_ctx *context, struct damon_target *t,
-		struct damon_region *r, struct damos *scheme);
 void damon_va_set_primitives(struct damon_ctx *ctx);
-
+bool damon_va_target_valid(void *t);
 #endif	/* CONFIG_DAMON_VADDR */
 
 #ifdef CONFIG_DAMON_PADDR
-
-/* Monitoring primitives for the physical memory address space */
-void damon_pa_prepare_access_checks(struct damon_ctx *ctx);
-unsigned int damon_pa_check_accesses(struct damon_ctx *ctx);
-bool damon_pa_target_valid(void *t);
-int damon_pa_apply_scheme(struct damon_ctx *context, struct damon_target *t,
-		struct damon_region *r, struct damos *scheme);
-int damon_pa_scheme_score(struct damon_ctx *context, struct damon_target *t,
-		struct damon_region *r, struct damos *scheme);
 void damon_pa_set_primitives(struct damon_ctx *ctx);
-
+bool damon_pa_target_valid(void *t);
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
@@ -246,7 +246,7 @@ int damon_pa_apply_scheme(struct damon_c
 	return 0;
 }
 
-int damon_pa_scheme_score(struct damon_ctx *context, struct damon_target *t,
+static int damon_pa_scheme_score(struct damon_ctx *context, struct damon_target *t,
 		struct damon_region *r, struct damos *scheme)
 {
 	switch (scheme->action) {
--- a/mm/damon/vaddr.c~mm-damon-remove-some-no-need-func-definitions-in-damonh-file
+++ a/mm/damon/vaddr.c
@@ -271,7 +271,7 @@ static void __damon_va_init_regions(stru
 }
 
 /* Initialize '->regions_list' of every target (task) */
-void damon_va_init(struct damon_ctx *ctx)
+static void damon_va_init(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
 
@@ -355,7 +355,7 @@ static void damon_va_apply_three_regions
 /*
  * Update regions for current memory mappings
  */
-void damon_va_update(struct damon_ctx *ctx)
+static void damon_va_update(struct damon_ctx *ctx)
 {
 	struct damon_addr_range three_regions[3];
 	struct damon_target *t;
@@ -417,7 +417,7 @@ static void __damon_va_prepare_access_ch
 	damon_va_mkold(mm, r->sampling_addr);
 }
 
-void damon_va_prepare_access_checks(struct damon_ctx *ctx)
+static void damon_va_prepare_access_checks(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
 	struct mm_struct *mm;
@@ -538,7 +538,7 @@ static void __damon_va_check_access(stru
 	last_addr = r->sampling_addr;
 }
 
-unsigned int damon_va_check_accesses(struct damon_ctx *ctx)
+static unsigned int damon_va_check_accesses(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
 	struct mm_struct *mm;
@@ -602,7 +602,7 @@ out:
 }
 #endif	/* CONFIG_ADVISE_SYSCALLS */
 
-int damon_va_apply_scheme(struct damon_ctx *ctx, struct damon_target *t,
+static int damon_va_apply_scheme(struct damon_ctx *ctx, struct damon_target *t,
 		struct damon_region *r, struct damos *scheme)
 {
 	int madv_action;
@@ -633,7 +633,7 @@ int damon_va_apply_scheme(struct damon_c
 	return damos_madvise(t, r, madv_action);
 }
 
-int damon_va_scheme_score(struct damon_ctx *context, struct damon_target *t,
+static int damon_va_scheme_score(struct damon_ctx *context, struct damon_target *t,
 		struct damon_region *r, struct damos *scheme)
 {
 
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are

mm-damon-unified-access_check-function-naming-rules.patch
mm-damon-add-age-of-region-tracepoint-support.patch
mm-damon-core-using-function-abs-instead-of-diff_of.patch
mm-damon-remove-some-no-need-func-definitions-in-damonh-file.patch

