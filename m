Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D48C433E0
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 20:03:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A33372313F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 20:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgLVUDd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 15:03:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:46994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbgLVUDa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 15:03:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A63DF20771;
        Tue, 22 Dec 2020 20:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608667370;
        bh=qTjQu+aAiKh3WeHDrcy3Ad4bAKWypLWyNRllSXK4W20=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vV789QWAgVBT5A0euD4P8/nHuuqivsdYaCOmWjIBCj565zpMHb8JCcRG2m9aCHQTm
         KFrZLWCKwYs3GDy5OY23Gg2RXn/O/lvn8M8kOsidgjyBF0xGoXjQaASaKUnirZuxd+
         jiTlLF7PaB0/xnk1QnRnprE1eDjppk3eK+VH977Y=
Date:   Tue, 22 Dec 2020 12:02:49 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com,
        aryabinin@virtuozzo.com, Branislav.Rankov@arm.com,
        catalin.marinas@arm.com, dvyukov@google.com, elver@google.com,
        eugenis@google.com, glider@google.com, gor@linux.ibm.com,
        kevin.brodsky@arm.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vincenzo.frascino@arm.com, will.deacon@arm.com
Subject:  [patch 47/60] kasan: remove __kasan_unpoison_stack
Message-ID: <20201222200249.pSPi936nP%akpm@linux-foundation.org>
In-Reply-To: <20201222115844.d30aaef7df6f5b120d3e0c3d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: remove __kasan_unpoison_stack

There's no need for __kasan_unpoison_stack() helper, as it's only
currently used in a single place. Removing it also removes unneeded
arithmetic.

No functional changes.

Link: https://lkml.kernel.org/r/93e78948704a42ea92f6248ff8a725613d721161.1606162397.git.andreyknvl@google.com
Link: https://linux-review.googlesource.com/id/Ie5ba549d445292fe629b4a96735e4034957bcc50
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Branislav Rankov <Branislav.Rankov@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/mm/kasan/common.c~kasan-remove-__kasan_unpoison_stack
+++ a/mm/kasan/common.c
@@ -64,18 +64,12 @@ void kasan_unpoison_range(const void *ad
 }
 
 #if CONFIG_KASAN_STACK
-static void __kasan_unpoison_stack(struct task_struct *task, const void *sp)
-{
-	void *base = task_stack_page(task);
-	size_t size = sp - base;
-
-	unpoison_range(base, size);
-}
-
 /* Unpoison the entire stack for a task. */
 void kasan_unpoison_task_stack(struct task_struct *task)
 {
-	__kasan_unpoison_stack(task, task_stack_page(task) + THREAD_SIZE);
+	void *base = task_stack_page(task);
+
+	unpoison_range(base, THREAD_SIZE);
 }
 
 /* Unpoison the stack for the current task beyond a watermark sp value. */
_
