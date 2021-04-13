Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 630AEC433ED
	for <mm-commits@archiver.kernel.org>; Tue, 13 Apr 2021 17:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A01C613B7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Apr 2021 17:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347217AbhDMRgZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:36:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347213AbhDMRgY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Apr 2021 13:36:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDA0C613B1;
        Tue, 13 Apr 2021 17:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1618335364;
        bh=ROpkVEgerKauPd84D5IIHWbCQnqEGSLGCxJA/v5vFko=;
        h=Date:From:To:Subject:From;
        b=JRT+IOdt8MyGKTFFQekCj2scmHnl825oyF+g445pOGti7Y3e2vwnn27sB29W+p/RT
         FxZ8QfGT9RiEsHADhVyosyTyhaM2sAlSrxtMR5J728uWmPDZpIvf366L1k6sDIZIVy
         yeNAGO+tfhEK0vwFSM1Te94IpDFLpkyhL9TFw8oU=
Date:   Tue, 13 Apr 2021 10:36:02 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, ndesaulniers@google.com,
        johannes.berg@intel.com
Subject:  + gcov-clang-fix-clang-11-build.patch added to -mm tree
Message-ID: <20210413173602.ICNe2%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: gcov: clang: fix clang-11+ build
has been added to the -mm tree.  Its filename is
     gcov-clang-fix-clang-11-build.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/gcov-clang-fix-clang-11-build.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/gcov-clang-fix-clang-11-build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Patches currently in -mm which might be from johannes.berg@intel.com are

gcov-clang-fix-clang-11-build.patch
gcov-combine-common-code.patch
gcov-simplify-buffer-allocation.patch
gcov-use-kvmalloc.patch
gdb-lx-symbols-store-the-abspath.patch

