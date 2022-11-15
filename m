Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A23BC4332F
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232555AbiKOWcW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbiKOWbw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:31:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0345E3896
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:31:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9767061A4D
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF61DC433D7;
        Tue, 15 Nov 2022 22:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551511;
        bh=e/E3v5jquUnTXeTa5Lk9o1/m7ZrNzawVqA3JGJQNU48=;
        h=Date:To:From:Subject:From;
        b=RVvOrGgBi3FoHP5QteDZeG5M1g+PbUm32YVD9KYxsVrp0LSrN/rs7UcRX0J0XLwEP
         QVusfPWVgrW7xxir01YUbI0bSXHS57Mu68t/5D1tkVL2KcuTipenRGgRtqvcWOmXBY
         AwHhv9LeAy2ETjBMOetWf+xAa1KVsonheMTQCbto=
Date:   Tue, 15 Nov 2022 14:31:50 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, peterz@infradead.org,
        ojeda@kernel.org, ndesaulniers@google.com, nathan@kernel.org,
        linux@rasmusvillemoes.dk, keescook@chromium.org,
        jpoimboe@kernel.org, isabbasso@riseup.net,
        dan.j.williams@intel.com, akinobu.mita@gmail.com,
        weiyongjun1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fault-injection-skip-stacktrace-filtering-by-default.patch removed from -mm tree
Message-Id: <20221115223150.EF61DC433D7@smtp.kernel.org>
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
@@ -74,7 +74,7 @@ static bool fail_stacktrace(struct fault
 	int n, nr_entries;
 	bool found = (attr->require_start == 0 && attr->require_end == ULONG_MAX);
 
-	if (depth == 0)
+	if (depth == 0 || (found && !attr->reject_start && !attr->reject_end))
 		return found;
 
 	nr_entries = stack_trace_save(entries, depth, 1);
_

Patches currently in -mm which might be from weiyongjun1@huawei.com are


