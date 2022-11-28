Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3665C46467
	for <mm-commits@archiver.kernel.org>; Mon, 28 Nov 2022 22:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbiK1W2L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Nov 2022 17:28:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233980AbiK1W2C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 28 Nov 2022 17:28:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 171C3CDA
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 14:28:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 905D8614AE
        for <mm-commits@vger.kernel.org>; Mon, 28 Nov 2022 22:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9209C433D6;
        Mon, 28 Nov 2022 22:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669674481;
        bh=YterWD/JD1JzQh4ZoeJX55r2hUSXpLUkxodDnE69RSQ=;
        h=Date:To:From:Subject:From;
        b=eUB028PbWd1UUCuI1047eXaBqAoMCw5ZFYx9VyZtCL7FdrKi7U8YoHzqYb6x/aBzd
         PLMTAKljct0vxkZb1YRMBuFjcGC1QlG6q042ff5cUYvYRIhD+1QdzUHiyOl0707/M5
         TiuuFHGFF4TF7cIZpY4f9BRRqXs4Iz+aKXHg9Npw=
Date:   Mon, 28 Nov 2022 14:28:00 -0800
To:     mm-commits@vger.kernel.org, will@kernel.org, peterz@infradead.org,
        mingo@redhat.com, elver@google.com, ebiggers@kernel.org,
        dvyukov@google.com, glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-allow-using-__msan_instrument_asm_store-inside-runtime.patch added to mm-unstable branch
Message-Id: <20221128222800.E9209C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kmsan: allow using __msan_instrument_asm_store() inside runtime
has been added to the -mm mm-unstable branch.  Its filename is
     kmsan-allow-using-__msan_instrument_asm_store-inside-runtime.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-allow-using-__msan_instrument_asm_store-inside-runtime.patch

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
Subject: kmsan: allow using __msan_instrument_asm_store() inside runtime
Date: Mon, 28 Nov 2022 10:45:41 +0100

In certain cases (e.g.  when handling a softirq)
__msan_instrument_asm_store(&var, sizeof(var)) may be called with from
within KMSAN runtime, but later the value of @var is used with
!kmsan_in_runtime(), leading to false positives.

Because kmsan_internal_unpoison_memory() doesn't take locks, it should be
fine to call it without kmsan_in_runtime() checks, which fixes the
mentioned false positives.

Link: https://lkml.kernel.org/r/20221128094541.2645890-2-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Marco Elver <elver@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/instrumentation.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/kmsan/instrumentation.c~kmsan-allow-using-__msan_instrument_asm_store-inside-runtime
+++ a/mm/kmsan/instrumentation.c
@@ -81,12 +81,16 @@ DECLARE_METADATA_PTR_GETTER(8);
  * Handle a memory store performed by inline assembly. KMSAN conservatively
  * attempts to unpoison the outputs of asm() directives to prevent false
  * positives caused by missed stores.
+ *
+ * __msan_instrument_asm_store() may be called for inline assembly code when
+ * entering or leaving IRQ. We omit the check for kmsan_in_runtime() to ensure
+ * the memory written to in these cases is also marked as initialized.
  */
 void __msan_instrument_asm_store(void *addr, uintptr_t size)
 {
 	unsigned long ua_flags;
 
-	if (!kmsan_enabled || kmsan_in_runtime())
+	if (!kmsan_enabled)
 		return;
 
 	ua_flags = user_access_save();
@@ -103,10 +107,8 @@ void __msan_instrument_asm_store(void *a
 		user_access_restore(ua_flags);
 		return;
 	}
-	kmsan_enter_runtime();
 	/* Unpoisoning the memory on best effort. */
 	kmsan_internal_unpoison_memory(addr, size, /*checked*/ false);
-	kmsan_leave_runtime();
 	user_access_restore(ua_flags);
 }
 EXPORT_SYMBOL(__msan_instrument_asm_store);
_

Patches currently in -mm which might be from glider@google.com are

revert-kmsan-unpoison-tlb-in-arch_tlb_gather_mmu.patch
lockdep-allow-instrumenting-lockdepc-with-kmsan.patch
kmsan-allow-using-__msan_instrument_asm_store-inside-runtime.patch

