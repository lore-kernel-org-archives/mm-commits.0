Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EE23C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiJCVON (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiJCVLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E9318E20
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02755611CB
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E8BC433C1;
        Mon,  3 Oct 2022 21:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831257;
        bh=aNKJnH7FevkXlOqCvoPERsDl+qLBzSau4JZUi2fJ4WQ=;
        h=Date:To:From:Subject:From;
        b=u7pECfC6ww4RjS2iWOIgOid8yqnzABsJIKIyu7raEtLtvc9qhXYU8nDoTpxq6mLya
         sgyPaN9L0xCGvkfQS488/C1s3VHAM58Qn/up89CIeg2e0idKD130YVBOFJKhiOaXwB
         CcjKF8PJnvQQXPYucmSuCC3inNQ4coenhhr0TrCo=
Date:   Mon, 03 Oct 2022 14:07:36 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-simplify-the-parameter-passing-for-prepare_access_checks.patch removed from -mm tree
Message-Id: <20221003210737.57E8BC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon: simplify the parameter passing for 'prepare_access_checks'
has been removed from the -mm tree.  Its filename was
     mm-damon-simplify-the-parameter-passing-for-prepare_access_checks.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kaixu Xia <kaixuxia@tencent.com>
Subject: mm/damon: simplify the parameter passing for 'prepare_access_checks'
Date: Tue, 13 Sep 2022 17:11:24 +0800

Patch series "mm/damon: code simplifications and cleanups".

This patchset contains some code simplifications and cleanups for DAMON.


This patch (of 4):

The parameter 'struct damon_ctx *ctx' isn't used in the functions
__damon_{p,v}a_prepare_access_check(), so we can remove it and simplify
the parameter passing.

Link: https://lkml.kernel.org/r/1663060287-30201-1-git-send-email-kaixuxia@tencent.com
Link: https://lkml.kernel.org/r/1663060287-30201-2-git-send-email-kaixuxia@tencent.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    5 ++---
 mm/damon/vaddr.c |    6 +++---
 2 files changed, 5 insertions(+), 6 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-simplify-the-parameter-passing-for-prepare_access_checks
+++ a/mm/damon/paddr.c
@@ -63,8 +63,7 @@ out:
 	folio_put(folio);
 }
 
-static void __damon_pa_prepare_access_check(struct damon_ctx *ctx,
-					    struct damon_region *r)
+static void __damon_pa_prepare_access_check(struct damon_region *r)
 {
 	r->sampling_addr = damon_rand(r->ar.start, r->ar.end);
 
@@ -78,7 +77,7 @@ static void damon_pa_prepare_access_chec
 
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region(r, t)
-			__damon_pa_prepare_access_check(ctx, r);
+			__damon_pa_prepare_access_check(r);
 	}
 }
 
--- a/mm/damon/vaddr.c~mm-damon-simplify-the-parameter-passing-for-prepare_access_checks
+++ a/mm/damon/vaddr.c
@@ -397,8 +397,8 @@ static void damon_va_mkold(struct mm_str
  * Functions for the access checking of the regions
  */
 
-static void __damon_va_prepare_access_check(struct damon_ctx *ctx,
-			struct mm_struct *mm, struct damon_region *r)
+static void __damon_va_prepare_access_check(struct mm_struct *mm,
+					struct damon_region *r)
 {
 	r->sampling_addr = damon_rand(r->ar.start, r->ar.end);
 
@@ -416,7 +416,7 @@ static void damon_va_prepare_access_chec
 		if (!mm)
 			continue;
 		damon_for_each_region(r, t)
-			__damon_va_prepare_access_check(ctx, mm, r);
+			__damon_va_prepare_access_check(mm, r);
 		mmput(mm);
 	}
 }
_

Patches currently in -mm which might be from kaixuxia@tencent.com are


