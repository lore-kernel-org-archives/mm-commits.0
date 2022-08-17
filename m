Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E5CEC28B2B
	for <mm-commits@archiver.kernel.org>; Wed, 17 Aug 2022 15:54:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237992AbiHQPya (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Aug 2022 11:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237999AbiHQPy2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 17 Aug 2022 11:54:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99A29C1EB
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 08:54:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C6A661599
        for <mm-commits@vger.kernel.org>; Wed, 17 Aug 2022 15:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9209C43145;
        Wed, 17 Aug 2022 15:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660751663;
        bh=8WgsLx/+krgH+2ozqD9RCpVyUP7O8OExuQivxBFePmo=;
        h=Date:To:From:Subject:From;
        b=1tMQUHDPPCQkXfxGB673u1l6pQYc8mlOxi7mnrsynyv4AS4ik5N6+K2Fh/YuRp8HZ
         twQLVQl/ABsg5Ro4QxvHWz5XcWajcxmIIAiGEOhj0hRpIuAciuS+Y5WMPzme8MNob5
         hIPxRD3+PMpNW5b/DGfur9ciqCXPjE3vQ5jQI8sY=
Date:   Wed, 17 Aug 2022 08:54:23 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, peterz@infradead.org,
        ojeda@kernel.org, ndesaulniers@google.com, nathan@kernel.org,
        linux@rasmusvillemoes.dk, keescook@chromium.org,
        jpoimboe@kernel.org, isabbasso@riseup.net,
        dan.j.williams@intel.com, akinobu.mita@gmail.com,
        weiyongjun1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fault-injection-make-stacktrace-filter-works-as-expected.patch added to mm-nonmm-unstable branch
Message-Id: <20220817155423.A9209C43145@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fault-injection: make stacktrace filter works as expected
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fault-injection-make-stacktrace-filter-works-as-expected.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fault-injection-make-stacktrace-filter-works-as-expected.patch

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
@@ -105,10 +105,16 @@ static inline bool fail_stacktrace(struc
 
 bool should_fail(struct fault_attr *attr, ssize_t size)
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
@@ -128,6 +134,9 @@ bool should_fail(struct fault_attr *attr
 	if (atomic_read(&attr->times) == 0)
 		return false;
 
+	if (!stack_checked && !fail_stacktrace(attr))
+		return false;
+
 	if (atomic_read(&attr->space) > size) {
 		atomic_sub(size, &attr->space);
 		return false;
@@ -142,9 +151,6 @@ bool should_fail(struct fault_attr *attr
 	if (attr->probability <= prandom_u32() % 100)
 		return false;
 
-	if (!fail_stacktrace(attr))
-		return false;
-
 fail:
 	fail_dump(attr);
 
_

Patches currently in -mm which might be from weiyongjun1@huawei.com are

fault-injection-allow-stacktrace-filter-for-x86-64.patch
fault-injection-skip-stacktrace-filtering-by-default.patch
fault-injection-make-some-stack-filter-attrs-more-readable.patch
fault-injection-make-stacktrace-filter-works-as-expected.patch

