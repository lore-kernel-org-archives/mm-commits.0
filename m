Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF07DC25B08
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 15:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234196AbiHQPy3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 11:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237310AbiHQPyX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 11:54:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219809BB69
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 08:54:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAC79B81E1E
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 15:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FACC433C1;
        Wed, 17 Aug 2022 15:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660751659;
        bh=Q7QOra4FWMnQQxcxvcF2R6twSJcZfAaphMPCr4arzq0=;
        h=Date:To:From:Subject:From;
        b=EDtCtyTQrZVnYnV0TTw5vJcE/3fv+8mcFRV5QdHAVry2j3UD+5Bv6JRp0VRQiAaCj
         +P1j3QYizu+/yVmvDsklh858AkvxcEktrChbe/cH8D/MdQq2XN+9yypSUCZAyYjraH
         4UzpvbojFdnnS2Lt3uvyy7EmyA9RjNYyEcJ70wqc=
Date:   Wed, 17 Aug 2022 08:54:18 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, peterz@infradead.org,
        ojeda@kernel.org, ndesaulniers@google.com, nathan@kernel.org,
        linux@rasmusvillemoes.dk, keescook@chromium.org,
        jpoimboe@kernel.org, isabbasso@riseup.net,
        dan.j.williams@intel.com, akinobu.mita@gmail.com,
        weiyongjun1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fault-injection-skip-stacktrace-filtering-by-default.patch added to mm-nonmm-unstable branch
Message-Id: <20220817155419.71FACC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fault-injection: skip stacktrace filtering by default
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fault-injection-skip-stacktrace-filtering-by-default.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fault-injection-skip-stacktrace-filtering-by-default.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: fault-injection: skip stacktrace filtering by default
Date: Wed, 17 Aug 2022 08:03:30 +0000

If FAULT_INJECTION_STACKTRACE_FILTER is enabled, the depth is default to
32.  This means fail_stacktrace() will iter each entry's stacktrace, even
if filter is not configured.

This patch changes to quick return from fail_stacktrace() if stacktrace
filter is not set.

Link: https://lkml.kernel.org/r/20220817080332.1052710-3-weiyongjun1@huawei.com
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Isabella Basso <isabbasso@riseup.net>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/fault-inject.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/fault-inject.c~fault-injection-skip-stacktrace-filtering-by-default
+++ a/lib/fault-inject.c
@@ -74,7 +74,7 @@ static bool fail_stacktrace(struct fault
 	int n, nr_entries;
 	bool found = (attr->require_start == 0 && attr->require_end == ULONG_MAX);
 
-	if (depth == 0)
+	if (depth == 0 || (found && !attr->reject_start && !attr->reject_end))
 		return found;
 
 	nr_entries = stack_trace_save(entries, depth, 1);
_

Patches currently in -mm which might be from weiyongjun1@huawei.com are

fault-injection-allow-stacktrace-filter-for-x86-64.patch
fault-injection-skip-stacktrace-filtering-by-default.patch
fault-injection-make-some-stack-filter-attrs-more-readable.patch
fault-injection-make-stacktrace-filter-works-as-expected.patch

