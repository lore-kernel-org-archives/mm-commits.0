Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8401DC43217
	for <mm-commits@archiver.kernel.org>; Tue, 15 Nov 2022 22:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232713AbiKOWcX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Nov 2022 17:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238116AbiKOWb4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2022 17:31:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CE4C19
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 14:31:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D08D961A5F
        for <mm-commits@vger.kernel.org>; Tue, 15 Nov 2022 22:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FA2C433D6;
        Tue, 15 Nov 2022 22:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668551514;
        bh=Y6/C9j5CshlQjLTpHxLzk0SEKt5X35rvJXwykf392QY=;
        h=Date:To:From:Subject:From;
        b=0JX08Zl0kLTycxPEfMJFZqYODYN40Ie6whkge/sPRXNtiG7EuxhzOW25Naxto8AHT
         C+HbdWfCxMGe79rsBfdqWw179vKKuJ5RxIDcG8wIkRy9lGqF9SGo6MB54D/lSAcIF0
         GfQnuIDHBLib/yrJ7Z8i0Q61CduKwe14GDuiOJGU=
Date:   Tue, 15 Nov 2022 14:31:53 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, peterz@infradead.org,
        ojeda@kernel.org, ndesaulniers@google.com, nathan@kernel.org,
        linux@rasmusvillemoes.dk, keescook@chromium.org,
        jpoimboe@kernel.org, isabbasso@riseup.net,
        dan.j.williams@intel.com, akinobu.mita@gmail.com,
        weiyongjun1@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] fault-injection-make-stacktrace-filter-works-as-expected.patch removed from -mm tree
Message-Id: <20221115223154.31FA2C433D6@smtp.kernel.org>
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
 	if (attr->probability <= prandom_u32_max(100))
 		return false;
 
-	if (!fail_stacktrace(attr))
-		return false;
-
 fail:
 	fail_dump(attr);
 
_

Patches currently in -mm which might be from weiyongjun1@huawei.com are


