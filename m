Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97EE1ECAAD1
	for <mm-commits@archiver.kernel.org>; Sat, 27 Aug 2022 22:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiH0Wkc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 27 Aug 2022 18:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiH0Wkc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 27 Aug 2022 18:40:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C7352DED
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 15:40:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B58E260EC7
        for <mm-commits@vger.kernel.org>; Sat, 27 Aug 2022 22:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4BEC433C1;
        Sat, 27 Aug 2022 22:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1661640030;
        bh=1rzpZlwSUthTSYdMt5NN7jzwk8Zj8Or73TQ1ozMQJKE=;
        h=Date:To:From:Subject:From;
        b=ZA99fsbJ5wtfkymZ0dcThsyeVcBaf4BjsJ84hy9zBOQvCJuWTT+bRsJhQuAkKZy9l
         vde/WnMp8wyX5vy9OR7GrAeCJCNyxefZuirfSuT6S+WF/mhCniWYu4NQT8ruu8VE9O
         wMM4or4RnWsljD9b0K+Svsw3sdofkH7wkK7o35AU=
Date:   Sat, 27 Aug 2022 15:40:29 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-simplify-the-parameter-passing-for-check_accesses.patch added to mm-unstable branch
Message-Id: <20220827224030.0E4BEC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: simplify the parameter passing for 'check_accesses'
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-simplify-the-parameter-passing-for-check_accesses.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-simplify-the-parameter-passing-for-check_accesses.patch

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
From: Kaixu Xia <kaixuxia@tencent.com>
Subject: mm/damon: simplify the parameter passing for 'check_accesses'
Date: Sat, 27 Aug 2022 17:02:50 +0800

Patch series "mm/damon: Simplify the damon regions access check", v2.

This patchset simplifies the operations when checking the damon regions
accesses.


This patch (of 2):

The parameter 'struct damon_ctx *ctx' isn't used in the functions
__damon_{p,v}a_check_access(), so we can remove it and simplify the
parameter passing.

Link: https://lkml.kernel.org/r/1661590971-20893-1-git-send-email-kaixuxia@tencent.com
Link: https://lkml.kernel.org/r/1661590971-20893-2-git-send-email-kaixuxia@tencent.com
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    5 ++---
 mm/damon/vaddr.c |    6 +++---
 2 files changed, 5 insertions(+), 6 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-simplify-the-parameter-passing-for-check_accesses
+++ a/mm/damon/paddr.c
@@ -166,8 +166,7 @@ out:
 	return result.accessed;
 }
 
-static void __damon_pa_check_access(struct damon_ctx *ctx,
-				    struct damon_region *r)
+static void __damon_pa_check_access(struct damon_region *r)
 {
 	static unsigned long last_addr;
 	static unsigned long last_page_sz = PAGE_SIZE;
@@ -196,7 +195,7 @@ static unsigned int damon_pa_check_acces
 
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region(r, t) {
-			__damon_pa_check_access(ctx, r);
+			__damon_pa_check_access(r);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
 		}
 	}
--- a/mm/damon/vaddr.c~mm-damon-simplify-the-parameter-passing-for-check_accesses
+++ a/mm/damon/vaddr.c
@@ -543,8 +543,8 @@ static bool damon_va_young(struct mm_str
  * mm	'mm_struct' for the given virtual address space
  * r	the region to be checked
  */
-static void __damon_va_check_access(struct damon_ctx *ctx,
-			       struct mm_struct *mm, struct damon_region *r)
+static void __damon_va_check_access(struct mm_struct *mm,
+				struct damon_region *r)
 {
 	static struct mm_struct *last_mm;
 	static unsigned long last_addr;
@@ -579,7 +579,7 @@ static unsigned int damon_va_check_acces
 		if (!mm)
 			continue;
 		damon_for_each_region(r, t) {
-			__damon_va_check_access(ctx, mm, r);
+			__damon_va_check_access(mm, r);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
 		}
 		mmput(mm);
_

Patches currently in -mm which might be from kaixuxia@tencent.com are

mm-damon-core-simplify-the-parameter-passing-for-region-split-operation.patch
mm-damon-simplify-the-parameter-passing-for-check_accesses.patch
mm-damon-vaddr-remove-comparison-between-mm-and-last_mm-when-checking-region-accesses.patch

