Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FFF0C4321E
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:46:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A3B56135A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbhKEUtH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:49:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233780AbhKEUtH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:49:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 489FE61357;
        Fri,  5 Nov 2021 20:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636145186;
        bh=6J4MTwLxORuqJZBB6UwiJPJwGRtEupa/QMnQOxGNzxQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zbr0Nxi65yEl5M+kX0lGvPeddFtdDzZ9VdHlKMR+XRX6uE6OxLykQj8qa6m6/FK9U
         /6b98ijik+ulUqmGGsARkmjw2gzOjmfoSHDM1mIeLcUS2DJtkXf40y5WAH8jDub3Xu
         43N3JGikE1SK+yj7msLLCfCdmJdw5qDX/7SHilro=
Date:   Fri, 05 Nov 2021 13:46:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, amit@kernel.org,
        benh@kernel.crashing.org, corbet@lwn.net, david@redhat.com,
        dwmw@amazon.com, elver@google.com, foersleo@amazon.de,
        gthelen@google.com, Jonathan.Cameron@huawei.com,
        linux-mm@kvack.org, markubo@amazon.de, mm-commits@vger.kernel.org,
        rientjes@google.com, shakeelb@google.com, shuah@kernel.org,
        sj@kernel.org, torvalds@linux-foundation.org
Subject:  [patch 225/262] mm/damon/vaddr: support DAMON-based
 Operation Schemes
Message-ID: <20211105204625.Q_yfBYv9Z%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: support DAMON-based Operation Schemes

This commit makes DAMON's default primitives for virtual address spaces to
support DAMON-based Operation Schemes (DAMOS) by implementing actions
application functions and registering it to the monitoring context.  The
implementation simply links 'madvise()' for related DAMOS actions.  That
is, 'madvise(MADV_WILLNEED)' is called for 'WILLNEED' DAMOS action and
similar for other actions ('COLD', 'PAGEOUT', 'HUGEPAGE', 'NOHUGEPAGE').

So, the kernel space DAMON users can now use the DAMON-based optimizations
with only small amount of code.

Link: https://lkml.kernel.org/r/20211001125604.29660-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Amit Shah <amit@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rienjes <rientjes@google.com>
Cc: David Woodhouse <dwmw@amazon.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Leonard Foerster <foersleo@amazon.de>
Cc: Marco Elver <elver@google.com>
Cc: Markus Boehme <markubo@amazon.de>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 +
 mm/damon/vaddr.c      |   56 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

--- a/include/linux/damon.h~mm-damon-vaddr-support-damon-based-operation-schemes
+++ a/include/linux/damon.h
@@ -337,6 +337,8 @@ void damon_va_prepare_access_checks(stru
 unsigned int damon_va_check_accesses(struct damon_ctx *ctx);
 bool damon_va_target_valid(void *t);
 void damon_va_cleanup(struct damon_ctx *ctx);
+int damon_va_apply_scheme(struct damon_ctx *context, struct damon_target *t,
+		struct damon_region *r, struct damos *scheme);
 void damon_va_set_primitives(struct damon_ctx *ctx);
 
 #endif	/* CONFIG_DAMON_VADDR */
--- a/mm/damon/vaddr.c~mm-damon-vaddr-support-damon-based-operation-schemes
+++ a/mm/damon/vaddr.c
@@ -7,6 +7,7 @@
 
 #define pr_fmt(fmt) "damon-va: " fmt
 
+#include <asm-generic/mman-common.h>
 #include <linux/damon.h>
 #include <linux/hugetlb.h>
 #include <linux/mm.h>
@@ -658,6 +659,60 @@ bool damon_va_target_valid(void *target)
 	return false;
 }
 
+#ifndef CONFIG_ADVISE_SYSCALLS
+static int damos_madvise(struct damon_target *target, struct damon_region *r,
+			int behavior)
+{
+	return -EINVAL;
+}
+#else
+static int damos_madvise(struct damon_target *target, struct damon_region *r,
+			int behavior)
+{
+	struct mm_struct *mm;
+	int ret = -ENOMEM;
+
+	mm = damon_get_mm(target);
+	if (!mm)
+		goto out;
+
+	ret = do_madvise(mm, PAGE_ALIGN(r->ar.start),
+			PAGE_ALIGN(r->ar.end - r->ar.start), behavior);
+	mmput(mm);
+out:
+	return ret;
+}
+#endif	/* CONFIG_ADVISE_SYSCALLS */
+
+int damon_va_apply_scheme(struct damon_ctx *ctx, struct damon_target *t,
+		struct damon_region *r, struct damos *scheme)
+{
+	int madv_action;
+
+	switch (scheme->action) {
+	case DAMOS_WILLNEED:
+		madv_action = MADV_WILLNEED;
+		break;
+	case DAMOS_COLD:
+		madv_action = MADV_COLD;
+		break;
+	case DAMOS_PAGEOUT:
+		madv_action = MADV_PAGEOUT;
+		break;
+	case DAMOS_HUGEPAGE:
+		madv_action = MADV_HUGEPAGE;
+		break;
+	case DAMOS_NOHUGEPAGE:
+		madv_action = MADV_NOHUGEPAGE;
+		break;
+	default:
+		pr_warn("Wrong action %d\n", scheme->action);
+		return -EINVAL;
+	}
+
+	return damos_madvise(t, r, madv_action);
+}
+
 void damon_va_set_primitives(struct damon_ctx *ctx)
 {
 	ctx->primitive.init = damon_va_init;
@@ -667,6 +722,7 @@ void damon_va_set_primitives(struct damo
 	ctx->primitive.reset_aggregated = NULL;
 	ctx->primitive.target_valid = damon_va_target_valid;
 	ctx->primitive.cleanup = NULL;
+	ctx->primitive.apply_scheme = damon_va_apply_scheme;
 }
 
 #include "vaddr-test.h"
_
