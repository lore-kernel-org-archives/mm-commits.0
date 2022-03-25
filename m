Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96679C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357407AbiCYBeE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357483AbiCYBdN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D7ABF533
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D232B81DEA
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C25C340EC;
        Fri, 25 Mar 2022 01:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171882;
        bh=+K8cBVdJ0XwwxfYJvaUJUM/d9bDYf0C/Jtdnn6hc9M0=;
        h=Date:To:From:Subject:From;
        b=nByTBSuwaYsaEaaeIxHce+YC4sHsOBNXBLmNIZhOEIU3rmqIAq2kOvXr+/bPXAVSK
         a0fIejcGEVvUZLXHK/5TrQ1WCl0CTGsOBc8FzwKP6ZdbvLRr74GRMFbKf9df6nYeKB
         mvcMQhNtnBJB3WeL54VvoXPJKsNtVvQhgzgEoyRA=
Date:   Thu, 24 Mar 2022 18:31:21 -0700
To:     mm-commits@vger.kernel.org, peterz@infradead.org,
        ndesaulniers@google.com, bot@kernelci.org, bigeasy@linutronix.de,
        nathan@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-page_alloc-mark-pagesets-as-__maybe_unused.patch removed from -mm tree
Message-Id: <20220325013121.F2C25C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: mark pagesets as __maybe_unused
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-mark-pagesets-as-__maybe_unused.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


