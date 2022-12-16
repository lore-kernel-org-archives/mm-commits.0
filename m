Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 930B3C4167B
	for <mm-commits@archiver.kernel.org>; Fri, 16 Dec 2022 00:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiLPAlZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Dec 2022 19:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiLPAlV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2022 19:41:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AAC8419B9
        for <mm-commits@vger.kernel.org>; Thu, 15 Dec 2022 16:41:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9A23B81B58
        for <mm-commits@vger.kernel.org>; Fri, 16 Dec 2022 00:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73EDCC433F2;
        Fri, 16 Dec 2022 00:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671151277;
        bh=xaalK+iFRkLz++ZGQXk1lG7FMDcXoXxxDMhfZqeGRrw=;
        h=Date:To:From:Subject:From;
        b=k+omBtxkqMzYpS6Sdoxp/BCURtlerT8/0k9kqtSAfbMLYjkkO6Eq1NzyW3kgdA6sp
         F3ZRJN83yNbIR+kMP1ajRScH1zm4mMvw4Udl5kO5Q0LviqiNfxi32SYWRDqcLa+nig
         NZYIAXns9vsA0CJpvVpEvKX6FwMTyd+DDo8M1jho=
Date:   Thu, 15 Dec 2022 16:41:16 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, peterz@infradead.org,
        ojeda@kernel.org, ndesaulniers@google.com, nathan@kernel.org,
        linux@rasmusvillemoes.dk, keescook@chromium.org,
        jpoimboe@kernel.org, isabbasso@riseup.net,
        dan.j.williams@intel.com, akinobu.mita@gmail.com,
        weiyongjun1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fault-injection-make-stacktrace-filter-works-as-expected.patch removed from -mm tree
Message-Id: <20221216004117.73EDCC433F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fault-injection: make stacktrace filter works as expected
has been removed from the -mm tree.  Its filename was
     fault-injection-make-stacktrace-filter-works-as-expected.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yongjun <weiyongjun1@huawei.com>
Subject: fault-injection: make stacktrace filter works as expected
Date: Wed, 17 Aug 2022 08:03:32 +0000

stacktrace filter is checked after others, such as fail-nth, interval and
probability.  This make it doesn't work well as expected.

Fix to running stacktrace filter before other filters.  It will speed up
fault inject testing for driver modules.

Link: https://lkml.kernel.org/r/20220817080332.1052710-5-weiyongjun1@huawei.com
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

 lib/fault-inject.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/lib/fault-inject.c~fault-injection-make-stacktrace-filter-works-as-expected
+++ a/lib/fault-inject.c
@@ -102,10 +102,16 @@ static inline bool fail_stacktrace(struc
 
 bool should_fail_ex(struct fault_attr *attr, ssize_t size, int flags)
 {
+	bool stack_checked = false;
+
 	if (in_task()) {
 		unsigned int fail_nth = READ_ONCE(current->fail_nth);
 
 		if (fail_nth) {
+			if (!fail_stacktrace(attr))
+				return false;
+
+			stack_checked = true;
 			fail_nth--;
 			WRITE_ONCE(current->fail_nth, fail_nth);
 			if (!fail_nth)
@@ -125,6 +131,9 @@ bool should_fail_ex(struct fault_attr *a
 	if (atomic_read(&attr->times) == 0)
 		return false;
 
+	if (!stack_checked && !fail_stacktrace(attr))
+		return false;
+
 	if (atomic_read(&attr->space) > size) {
 		atomic_sub(size, &attr->space);
 		return false;
@@ -139,9 +148,6 @@ bool should_fail_ex(struct fault_attr *a
 	if (attr->probability <= get_random_u32_below(100))
 		return false;
 
-	if (!fail_stacktrace(attr))
-		return false;
-
 fail:
 	if (!(flags & FAULT_NOWARN))
 		fail_dump(attr);
_

Patches currently in -mm which might be from weiyongjun1@huawei.com are


