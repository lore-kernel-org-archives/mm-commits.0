Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 169F5C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 18 Nov 2022 19:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiKRT4a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Nov 2022 14:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234955AbiKRT4N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Nov 2022 14:56:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43C9B973C
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2022 11:56:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FD3762609
        for <mm-commits@vger.kernel.org>; Fri, 18 Nov 2022 19:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F36C433C1;
        Fri, 18 Nov 2022 19:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668801371;
        bh=wxvMkQy9JxdOIxpialikRbL4RlasB7cfdCRZ/S1znCg=;
        h=Date:To:From:Subject:From;
        b=OEodewNxY3acgVRnSyCfUVMSbFPEVy+H8WQi5KcLHfpPylm+LHWFrAjg/8v0vOOb9
         j4xrQmvVSZrDjmHD3ogRE53AY5gDk7tBcCErajMV7opiitL8Awp6wx41xEFaTFgO5m
         rZUeFRm8snSBFbaHuq8AQA1+J8m7FYqpbm4qolX0=
Date:   Fri, 18 Nov 2022 11:56:10 -0800
To:     mm-commits@vger.kernel.org, glider@google.com, feng.tang@intel.com,
        42.hyeyoo@gmail.com, elver@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kfence-fix-stack-trace-pruning.patch added to mm-hotfixes-unstable branch
Message-Id: <20221118195611.A6F36C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kfence: fix stack trace pruning
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kfence-fix-stack-trace-pruning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kfence-fix-stack-trace-pruning.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Marco Elver <elver@google.com>
Subject: kfence: fix stack trace pruning
Date: Fri, 18 Nov 2022 16:22:16 +0100

Commit b14051352465 ("mm/sl[au]b: generalize kmalloc subsystem")
refactored large parts of the kmalloc subsystem, resulting in the stack
trace pruning logic done by KFENCE to no longer work.

While b14051352465 attempted to fix the situation by including
'__kmem_cache_free' in the list of functions KFENCE should skip through,
this only works when the compiler actually optimized the tail call from
kfree() to __kmem_cache_free() into a jump (and thus kfree() _not_
appearing in the full stack trace to begin with).

In some configurations, the compiler no longer optimizes the tail call
into a jump, and __kmem_cache_free() appears in the stack trace.  This
means that the pruned stack trace shown by KFENCE would include kfree()
which is not intended - for example:

 | BUG: KFENCE: invalid free in kfree+0x7c/0x120
 |
 | Invalid free of 0xffff8883ed8fefe0 (in kfence-#126):
 |  kfree+0x7c/0x120
 |  test_double_free+0x116/0x1a9
 |  kunit_try_run_case+0x90/0xd0
 | [...]

Fix it by moving __kmem_cache_free() to the list of functions that may be
tail called by an allocator entry function, making the pruning logic work
in both the optimized and unoptimized tail call cases.

Link: https://lkml.kernel.org/r/20221118152216.3914899-1-elver@google.com
Fixes: b14051352465 ("mm/sl[au]b: generalize kmalloc subsystem")
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Feng Tang <feng.tang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/report.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/kfence/report.c~kfence-fix-stack-trace-pruning
+++ a/mm/kfence/report.c
@@ -75,18 +75,23 @@ static int get_stack_skipnr(const unsign
 
 		if (str_has_prefix(buf, ARCH_FUNC_PREFIX "kfence_") ||
 		    str_has_prefix(buf, ARCH_FUNC_PREFIX "__kfence_") ||
+		    str_has_prefix(buf, ARCH_FUNC_PREFIX "__kmem_cache_free") ||
 		    !strncmp(buf, ARCH_FUNC_PREFIX "__slab_free", len)) {
 			/*
-			 * In case of tail calls from any of the below
-			 * to any of the above.
+			 * In case of tail calls from any of the below to any of
+			 * the above, optimized by the compiler such that the
+			 * stack trace would omit the initial entry point below.
 			 */
 			fallback = skipnr + 1;
 		}
 
-		/* Also the *_bulk() variants by only checking prefixes. */
+		/*
+		 * The below list should only include the initial entry points
+		 * into the slab allocators. Includes the *_bulk() variants by
+		 * checking prefixes.
+		 */
 		if (str_has_prefix(buf, ARCH_FUNC_PREFIX "kfree") ||
 		    str_has_prefix(buf, ARCH_FUNC_PREFIX "kmem_cache_free") ||
-		    str_has_prefix(buf, ARCH_FUNC_PREFIX "__kmem_cache_free") ||
 		    str_has_prefix(buf, ARCH_FUNC_PREFIX "__kmalloc") ||
 		    str_has_prefix(buf, ARCH_FUNC_PREFIX "kmem_cache_alloc"))
 			goto found;
_

Patches currently in -mm which might be from elver@google.com are

kfence-fix-stack-trace-pruning.patch

