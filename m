Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E057BC433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 00:09:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FF1F613B9
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 00:09:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232375AbhEGAKp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 20:10:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233434AbhEGAKp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 20:10:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F68B61164;
        Fri,  7 May 2021 00:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620346186;
        bh=1ayH9QEeFit6vl4UPqzUuUvGWUObs88KBIwO9Y1Pifw=;
        h=Date:From:To:Subject:From;
        b=vLnSqHENYSVhmidv+HtfB1swEsEsWmHRRvieBQ7U3NFlA2VcS46/Bf/YVcMSMIEP6
         QOG1z7Y1GbmWi2BSY8/qMSFMSRYr/JldeQSyAHEUqrtkV9kLHDdS8w7vLXlMVpm4gO
         KtAJSQf7q9naheax1MFzjSgYjWvKnFD3ffVzHHmM=
Date:   Thu, 06 May 2021 17:09:45 -0700
From:   akpm@linux-foundation.org
To:     johannes.berg@intel.com, mm-commits@vger.kernel.org,
        ndesaulniers@google.com
Subject:  [folded-merged] gcov-use-kvmalloc-fix.patch removed from
 -mm tree
Message-ID: <20210507000945.VF8pbBg-w%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gcov: clang: fix clang-11+ build
has been removed from the -mm tree.  Its filename was
     gcov-use-kvmalloc-fix.patch

This patch was dropped because it was folded into gcov-use-kvmalloc.patch

------------------------------------------------------
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

--- a/kernel/gcov/clang.c~gcov-use-kvmalloc-fix
+++ a/kernel/gcov/clang.c
@@ -368,7 +368,7 @@ static struct gcov_fn_info *gcov_fn_info
 	INIT_LIST_HEAD(&fn_dup->head);
 
 	cv_size = fn->num_counters * sizeof(fn->counters[0]);
-	fn_dup->counters = vmalloc(cv_size);
+	fn_dup->counters = kvmalloc(cv_size, GFP_KERNEL);
 	if (!fn_dup->counters) {
 		kfree(fn_dup);
 		return NULL;
_

Patches currently in -mm which might be from johannes.berg@intel.com are

gcov-combine-common-code.patch
gcov-simplify-buffer-allocation.patch
gcov-use-kvmalloc.patch
gdb-lx-symbols-store-the-abspath.patch

