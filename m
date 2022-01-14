Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD3D5C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiANWJk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:09:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:60856 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiANWJh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:09:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1AD3B8262E
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E875C36AE9;
        Fri, 14 Jan 2022 22:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198175;
        bh=3gYqyKxjvDZrzDNDzCvo30JEP86e0uaxOGrSIHxv/6E=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=c9hIlN+SYOon7MRBwUs8K5jbFM/VAXEy2hf7PazAknI0AG8JyoKtKuSB387u4PgzH
         zidhb5orBBsa8AE8JvcILv0jfFmIDYBB7C7rOCWZT1tDQehKfnftzGjqeTii5hANdA
         ZOh1mbHKf5qc2Qx27wU0hUwOmK4E2uMuPzXaRPDo=
Date:   Fri, 14 Jan 2022 14:09:34 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        xhao@linux.alibaba.com
Subject:  [patch 121/146] mm/damon: unified access_check function
 naming rules
Message-ID: <20220114220934.ZfuKoQEI5%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
@@ -410,7 +410,7 @@ static void damon_va_mkold(struct mm_str
  * Functions for the access checking of the regions
  */
 
-static void damon_va_prepare_access_check(struct damon_ctx *ctx,
+static void __damon_va_prepare_access_check(struct damon_ctx *ctx,
 			struct mm_struct *mm, struct damon_region *r)
 {
 	r->sampling_addr = damon_rand(r->ar.start, r->ar.end);
@@ -429,7 +429,7 @@ void damon_va_prepare_access_checks(stru
 		if (!mm)
 			continue;
 		damon_for_each_region(r, t)
-			damon_va_prepare_access_check(ctx, mm, r);
+			__damon_va_prepare_access_check(ctx, mm, r);
 		mmput(mm);
 	}
 }
@@ -515,7 +515,7 @@ static bool damon_va_young(struct mm_str
  * mm	'mm_struct' for the given virtual address space
  * r	the region to be checked
  */
-static void damon_va_check_access(struct damon_ctx *ctx,
+static void __damon_va_check_access(struct damon_ctx *ctx,
 			       struct mm_struct *mm, struct damon_region *r)
 {
 	static struct mm_struct *last_mm;
@@ -551,7 +551,7 @@ unsigned int damon_va_check_accesses(str
 		if (!mm)
 			continue;
 		damon_for_each_region(r, t) {
-			damon_va_check_access(ctx, mm, r);
+			__damon_va_check_access(ctx, mm, r);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
 		}
 		mmput(mm);
_
