Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDA2BC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 22:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0CF9613CF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Apr 2021 22:46:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbhDPWqu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Apr 2021 18:46:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:53588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234956AbhDPWqt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Apr 2021 18:46:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC4FF6108B;
        Fri, 16 Apr 2021 22:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618613184;
        bh=Trq1W/IxIKJLj4GvxwmRlcZ9j3JvVuUBjhzOP+iLNnE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eAiGUV/eC1PzHDd2I9G1/pChPNkUgoLiAb9ZJTn/mgAXgVscpjYuuxq4VGVaxCyBr
         3tyUntINQoCd73EogVaNjwshoeqA3KYx28yvCb+4fmw8pMKogp+4GjgNPMi1OTjswj
         YYVOuWyz0Kphr3cnnyK/vt7qNM6Gaoe7T7C9KX88=
Date:   Fri, 16 Apr 2021 15:46:23 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, johannes.berg@intel.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        ndesaulniers@google.com, torvalds@linux-foundation.org
Subject:  [patch 11/12] gcov: clang: fix clang-11+ build
Message-ID: <20210416224623.nZhisHrwM%akpm@linux-foundation.org>
In-Reply-To: <20210416154523.3f9794326e8e1db549873cf8@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>
Subject: gcov: clang: fix clang-11+ build

With clang-11+, the code is broken due to my kvmalloc() conversion (which
predated the clang-11 support code) leaving one vmalloc() in place.  Fix
that.

Link: https://lkml.kernel.org/r/20210412214210.6e1ecca9cdc5.I24459763acf0591d5e6b31c7e3a59890d802f79c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/clang.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/gcov/clang.c~gcov-clang-fix-clang-11-build
+++ a/kernel/gcov/clang.c
@@ -369,7 +369,7 @@ static struct gcov_fn_info *gcov_fn_info
 	INIT_LIST_HEAD(&fn_dup->head);
 
 	cv_size = fn->num_counters * sizeof(fn->counters[0]);
-	fn_dup->counters = vmalloc(cv_size);
+	fn_dup->counters = kvmalloc(cv_size, GFP_KERNEL);
 	if (!fn_dup->counters) {
 		kfree(fn_dup);
 		return NULL;
_
