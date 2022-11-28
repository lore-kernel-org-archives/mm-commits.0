Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEDFC43217
	for <mm-commits@archiver.kernel.org>; Mon, 28 Nov 2022 22:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbiK1W2L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Nov 2022 17:28:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233898AbiK1W2C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2022 17:28:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2AA3BA
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 14:28:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43BEDB8102C
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 22:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41C2C433D6;
        Mon, 28 Nov 2022 22:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669674479;
        bh=8tYn9MpDn0KmI48MUPBLNBsxT66UpsLVlML/lMvx4SI=;
        h=Date:To:From:Subject:From;
        b=TNb+fLLcOq/EzA2P1DiAKftoL6iP5b76PW/PRdO8NKh6D7f2mcjeGKg97ViYUxivN
         na4L0j+28/R+gxqNULJiro/B4WNzYor2WRZ/RAxZFvL7NIwpRE59PoRC6AgiyHHMt9
         OqUxr4J/DtQazXHT0l9C6J6t4rfIl2THu6qopsm4=
Date:   Mon, 28 Nov 2022 14:27:58 -0800
To:     mm-commits@vger.kernel.org, will@kernel.org, peterz@infradead.org,
        mingo@redhat.com, elver@google.com, ebiggers@kernel.org,
        dvyukov@google.com, glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lockdep-allow-instrumenting-lockdepc-with-kmsan.patch added to mm-unstable branch
Message-Id: <20221128222758.E41C2C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lockdep: allow instrumenting lockdep.c with KMSAN
has been added to the -mm mm-unstable branch.  Its filename is
     lockdep-allow-instrumenting-lockdepc-with-kmsan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lockdep-allow-instrumenting-lockdepc-with-kmsan.patch

This patch will later appear in the mm-unstable branch at
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
From: Alexander Potapenko <glider@google.com>
Subject: lockdep: allow instrumenting lockdep.c with KMSAN
Date: Mon, 28 Nov 2022 10:45:40 +0100

Lockdep and KMSAN used to play badly together, causing deadlocks when
KMSAN instrumentation of lockdep.c called lockdep functions recursively.

Looks like this is no more the case, and a kernel can run (yet slower)
with both KMSAN and lockdep enabled.  This patch should fix false
positives on wq_head->lock->dep_map, which KMSAN used to consider
uninitialized because of lockdep.c not being instrumented.

Link: https://lore.kernel.org/lkml/Y3b9AAEKp2Vr3e6O@sol.localdomain/
Link: https://lkml.kernel.org/r/20221128094541.2645890-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: Eric Biggers <ebiggers@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/locking/Makefile |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/locking/Makefile~lockdep-allow-instrumenting-lockdepc-with-kmsan
+++ a/kernel/locking/Makefile
@@ -7,7 +7,6 @@ obj-y += mutex.o semaphore.o rwsem.o per
 
 # Avoid recursion lockdep -> sanitizer -> ... -> lockdep.
 KCSAN_SANITIZE_lockdep.o := n
-KMSAN_SANITIZE_lockdep.o := n
 
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_lockdep.o = $(CC_FLAGS_FTRACE)
_

Patches currently in -mm which might be from glider@google.com are

revert-kmsan-unpoison-tlb-in-arch_tlb_gather_mmu.patch
lockdep-allow-instrumenting-lockdepc-with-kmsan.patch
kmsan-allow-using-__msan_instrument_asm_store-inside-runtime.patch

