Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC10CECAAD8
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 22:14:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiIMWOy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 18:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiIMWOx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 18:14:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBC45FB3
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 15:14:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F411B810EA
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 22:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF75C433C1;
        Tue, 13 Sep 2022 22:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663107288;
        bh=2F0tQCBGcU7cIvmcVXaNyirmIk1clpBsgb5jc/rLlE4=;
        h=Date:To:From:Subject:From;
        b=YqjTzsS2nJsGZhPmgrCUZFVJZl0BDrAZ9AI9l8swbWN97zvxcL3la3TQNlIRTrgvx
         eEZ2nvt7bfXSrtYI/7oOPjILd4orLwMP3KemZ1tc/oG8Y6p4SF9WgzQaEORJ4kw3lP
         kVQxXBiBpzjvYFqdlC8ECFBKh20mLHl0nuJ4Dnco=
Date:   Tue, 13 Sep 2022 15:14:47 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, kaixuxia@tencent.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-simplify-the-parameter-passing-for-prepare_access_checks.patch added to mm-unstable branch
Message-Id: <20220913221448.BBF75C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: simplify the parameter passing for 'prepare_access_checks'
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-simplify-the-parameter-passing-for-prepare_access_checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-simplify-the-parameter-passing-for-prepare_access_checks.patch

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

mm-damon-sysfs-simplify-the-judgement-whether-kdamonds-are-busy.patch
mm-damon-core-iterate-the-regions-list-from-current-point-in-damon_set_regions.patch
mm-damon-vaddr-add-a-comment-for-default-case-in-damon_va_apply_scheme.patch
mm-damon-sysfs-use-the-wrapper-directly-to-check-if-the-kdamond-is-running.patch
mm-damon-simplify-the-parameter-passing-for-prepare_access_checks.patch
mm-damon-sysfs-simplify-the-variable-pid-assignment-operation.patch
mm-damon-core-simplify-the-kdamond-stop-mechanism-by-removing-done.patch
mm-damon-vaddr-indicate-the-target-is-invalid-when-nr_regions-is-zero.patch

