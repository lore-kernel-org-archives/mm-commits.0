Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33607C433F5
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377886AbiATV2R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377882AbiATV2R (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:28:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629D0C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:28:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D1C6B81E69
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:28:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43B2C340E0;
        Thu, 20 Jan 2022 21:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714093;
        bh=fK3RDnBDDZqh3XJ3cpKFQvEB7ZgkORbfuaCPpryRuDQ=;
        h=Date:From:To:Subject:From;
        b=JSheUd7FFqZPP1c8MR+iCPhEH9TTkhJFh0+qVha0Adq10/oJhGWqoBujbmO/ZgOsq
         MYIPhOiKUFoQHv6f206T0zhotFE1O0+7lwSXW+wnlApGMgdlJqTJVe8PYbVBwo/IiY
         j5n37+V0cvf4kTWhRd7mdaiKT/Q6KNsMjtqLKSKI=
Date:   Thu, 20 Jan 2022 13:28:13 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        songmuchun@bytedance.com, xhao@linux.alibaba.com
Subject:  [merged]
 mm-damon-unified-access_check-function-naming-rules.patch removed from -mm
 tree
Message-ID: <20220120212813.wfGY5Gr_a%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: unified access_check function naming rules
has been removed from the -mm tree.  Its filename was
     mm-damon-unified-access_check-function-naming-rules.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from xhao@linux.alibaba.com are


