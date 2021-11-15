Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D61C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 18:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A61DB633F7
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 18:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238889AbhKOSRC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 13:17:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:56258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240797AbhKOSNr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 13:13:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2989D6120F;
        Mon, 15 Nov 2021 17:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636998511;
        bh=BAXoF+aA2GnAh3EpA+AmdBvvRj3YVEDdpYUSbaifEC4=;
        h=Date:From:To:Subject:From;
        b=dsjgXkKUSgMENPt1uzUfEPaG+hQ9jRxit6XAWCFcYKYjLVNydElM5cHgl4mVBRPTq
         +t/CeTCStwgiN1pEhxlA4GR4BksvgMBt/WDLnsKKhgdklcM2cYu4x4naycsezxAcWi
         TnAWHDY52YNGT44a9qz3bHmpzqul8lWYH048nJ6A=
Date:   Mon, 15 Nov 2021 09:48:30 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        songmuchun@bytedance.com, xhao@linux.alibaba.com
Subject:  +
 mm-damon-unified-access_check-function-naming-rules.patch added to -mm tree
Message-ID: <20211115174830.jOCnHcsTS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: unified access_check function naming rules
has been added to the -mm tree.  Its filename is
     mm-damon-unified-access_check-function-naming-rules.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-unified-access_check-function-naming-rules.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-unified-access_check-function-naming-rules.patch

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
Subject: mm/damon: unified access_check function naming rules

Patch series "mm/damon: Do some small changes", v4.


This patch (of 4):

In damon/paddr.c file, two functions names start with underscore,
	static void __damon_pa_prepare_access_check(struct damon_ctx *ctx,
			struct damon_region *r)
	static void __damon_pa_prepare_access_check(struct damon_ctx *ctx,
			struct damon_region *r)
In damon/vaddr.c file, there are also two functions with the same function,
	static void damon_va_prepare_access_check(struct damon_ctx *ctx,
			struct mm_struct *mm, struct damon_region *r)
	static void damon_va_check_access(struct damon_ctx *ctx,
			struct mm_struct *mm, struct damon_region *r)

It makes sense to keep consistent, and it is not easy to be confused with
the function that call them.

Link: https://lkml.kernel.org/r/cover.1636989871.git.xhao@linux.alibaba.com
Link: https://lkml.kernel.org/r/529054aed932a42b9c09fc9977ad4574b9e7b0bd.1636989871.git.xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-unified-access_check-function-naming-rules
+++ a/mm/damon/vaddr.c
@@ -409,7 +409,7 @@ static void damon_va_mkold(struct mm_str
  * Functions for the access checking of the regions
  */
 
-static void damon_va_prepare_access_check(struct damon_ctx *ctx,
+static void __damon_va_prepare_access_check(struct damon_ctx *ctx,
 			struct mm_struct *mm, struct damon_region *r)
 {
 	r->sampling_addr = damon_rand(r->ar.start, r->ar.end);
@@ -428,7 +428,7 @@ void damon_va_prepare_access_checks(stru
 		if (!mm)
 			continue;
 		damon_for_each_region(r, t)
-			damon_va_prepare_access_check(ctx, mm, r);
+			__damon_va_prepare_access_check(ctx, mm, r);
 		mmput(mm);
 	}
 }
@@ -514,7 +514,7 @@ static bool damon_va_young(struct mm_str
  * mm	'mm_struct' for the given virtual address space
  * r	the region to be checked
  */
-static void damon_va_check_access(struct damon_ctx *ctx,
+static void __damon_va_check_access(struct damon_ctx *ctx,
 			       struct mm_struct *mm, struct damon_region *r)
 {
 	static struct mm_struct *last_mm;
@@ -550,7 +550,7 @@ unsigned int damon_va_check_accesses(str
 		if (!mm)
 			continue;
 		damon_for_each_region(r, t) {
-			damon_va_check_access(ctx, mm, r);
+			__damon_va_check_access(ctx, mm, r);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
 		}
 		mmput(mm);
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are

mm-damon-unified-access_check-function-naming-rules.patch
mm-damon-add-age-of-region-tracepoint-support.patch
mm-damon-core-using-function-abs-instead-of-diff_of.patch
mm-damon-remove-some-no-need-func-definitions-in-damonh-file.patch

