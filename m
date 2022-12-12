Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D67FC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231328AbiLLCOq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbiLLCOJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452F7DECB
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B25DFCE0CEB
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91D2C433EF;
        Mon, 12 Dec 2022 02:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811242;
        bh=udJ514cYbViqImmmrYZQbvI2NbTsaAgHabSdYTc+GXY=;
        h=Date:To:From:Subject:From;
        b=Nq4cRzti69KIi15dRf87Y98Q81AEj1tVft0W5UVcyeYxhCuxjktQxu1tYaNc33xCe
         VAbxxbfV4XPdQTBvGe4kLScXsWuFqnZGSS+uioor5O6F/TRCHm69eZWrims+Q0v/Jb
         WqOpLyDTTmvyC6BEMi6RDvh+4nLkFotWaZ7TP+To=
Date:   Sun, 11 Dec 2022 18:14:01 -0800
To:     mm-commits@vger.kernel.org, will@kernel.org, peterz@infradead.org,
        mingo@redhat.com, elver@google.com, ebiggers@kernel.org,
        dvyukov@google.com, glider@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kmsan-allow-using-__msan_instrument_asm_store-inside-runtime.patch removed from -mm tree
Message-Id: <20221212021401.E91D2C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kmsan: allow using __msan_instrument_asm_store() inside runtime
has been removed from the -mm tree.  Its filename was
     kmsan-allow-using-__msan_instrument_asm_store-inside-runtime.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


