Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E0FC433EF
	for <mm-commits@archiver.kernel.org>; Tue, 15 Feb 2022 21:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241580AbiBOVDu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Feb 2022 16:03:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235440AbiBOVDs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Feb 2022 16:03:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F177027FFF
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 13:03:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0BFBB81CFD
        for <mm-commits@vger.kernel.org>; Tue, 15 Feb 2022 21:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2127EC340EB;
        Tue, 15 Feb 2022 21:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1644959014;
        bh=sqrUU0Hp5GH2B+WT1jw047BWDODH5siAePoVIwLrpvc=;
        h=Date:To:From:Subject:From;
        b=ctaSHLn1C/eYFkF4KUU4v8HYwmwBlrajqjwZ2Z5u8pnv4AycCms2tuIi9hcjggM2S
         vKFXvjvMaRwUGbZP4roSi1BboXN1nQoMz/8KyshppqpMzgaDuaF0ipEyrvZ7wctG4V
         x+nAbsHb3CE4I+HOnD15fh8+eQUJMP79b+jAeJuI=
Date:   Tue, 15 Feb 2022 13:03:32 -0800
To:     mm-commits@vger.kernel.org, peterz@infradead.org,
        ndesaulniers@google.com, bot@kernelci.org, bigeasy@linutronix.de,
        nathan@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-mark-pagesets-as-__maybe_unused.patch added to -mm tree
Message-Id: <20220215210334.2127EC340EB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: mark pagesets as __maybe_unused
has been added to the -mm tree.  Its filename is
     mm-page_alloc-mark-pagesets-as-__maybe_unused.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-mark-pagesets-as-__maybe_unused.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-mark-pagesets-as-__maybe_unused.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nathan Chancellor <nathan@kernel.org>
Subject: mm/page_alloc: mark pagesets as __maybe_unused

Commit 9983a9d577db ("locking/local_lock: Make the empty local_lock_*()
function a macro.") in the -tip tree converted the local_lock_*()
functions into macros, which causes a warning with clang with
CONFIG_PREEMPT_RT=n + CONFIG_DEBUG_LOCK_ALLOC=n:

  mm/page_alloc.c:131:40: error: variable 'pagesets' is not needed and will not be emitted [-Werror,-Wunneeded-internal-declaration]
  static DEFINE_PER_CPU(struct pagesets, pagesets) = {
                                         ^
  1 error generated.

Prior to that change, clang was not able to tell that pagesets was unused
in this configuration because it does not perform cross function analysis
in the frontend.  After that change, it sees that the macros just do a
typecheck on the lock member of pagesets, which is evaluated at compile
time (so the variable is technically "used"), meaning the variable is not
needed in the final assembly, as the warning states.

Mark the variable as __maybe_unused to make it clear to clang that this is
expected in this configuration so there is no more warning.

Link: https://github.com/ClangBuiltLinux/linux/issues/1593
Link: https://lkml.kernel.org/r/20220215184322.440969-1-nathan@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-mark-pagesets-as-__maybe_unused
+++ a/mm/page_alloc.c
@@ -128,7 +128,7 @@ static DEFINE_MUTEX(pcp_batch_high_lock)
 struct pagesets {
 	local_lock_t lock;
 };
-static DEFINE_PER_CPU(struct pagesets, pagesets) = {
+static DEFINE_PER_CPU(struct pagesets, pagesets) __maybe_unused = {
 	.lock = INIT_LOCAL_LOCK(lock),
 };
 
_

Patches currently in -mm which might be from nathan@kernel.org are

mm-page_alloc-mark-pagesets-as-__maybe_unused.patch

