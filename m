Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5B36C10F1E
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 00:41:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbiLPAlY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 19:41:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiLPAlS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 19:41:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A6736D7C
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 16:41:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10CC2B81CF8
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 00:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC151C433D2;
        Fri, 16 Dec 2022 00:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671151274;
        bh=cioIBytVk7rP+7SWHhVDw76BxwsDXkeofouKZwWzsBg=;
        h=Date:To:From:Subject:From;
        b=OPSIRO511uZRNrfDCoDI18JO2l4lV9OH+RV8oyXTAgVWvWE3ANpVvd6yKmGhne4eZ
         be3Wpm72c0DAvTAVc0C/JLRR/qkWCLTiMME15Y5Hx/Wqeeaa9IjiRiecmC0Tvu/xNM
         suIfMqjUrn+6S/RIOu2FernUcZb5WlFpiSPWZMJM=
Date:   Thu, 15 Dec 2022 16:41:14 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, peterz@infradead.org,
        ojeda@kernel.org, ndesaulniers@google.com, nathan@kernel.org,
        linux@rasmusvillemoes.dk, keescook@chromium.org,
        jpoimboe@kernel.org, isabbasso@riseup.net,
        dan.j.williams@intel.com, akinobu.mita@gmail.com,
        weiyongjun1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fault-injection-skip-stacktrace-filtering-by-default.patch removed from -mm tree
Message-Id: <20221216004114.BC151C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fault-injection: skip stacktrace filtering by default
has been removed from the -mm tree.  Its filename was
     fault-injection-skip-stacktrace-filtering-by-default.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -71,7 +71,7 @@ static bool fail_stacktrace(struct fault
 	int n, nr_entries;
 	bool found = (attr->require_start == 0 && attr->require_end == ULONG_MAX);
 
-	if (depth == 0)
+	if (depth == 0 || (found && !attr->reject_start && !attr->reject_end))
 		return found;
 
 	nr_entries = stack_trace_save(entries, depth, 1);
_

Patches currently in -mm which might be from weiyongjun1@huawei.com are


