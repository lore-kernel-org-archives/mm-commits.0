Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8173C433F5
	for <mm-commits@archiver.kernel.org>; Tue, 14 Sep 2021 02:56:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9022260698
	for <mm-commits@archiver.kernel.org>; Tue, 14 Sep 2021 02:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238422AbhINC6E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:58:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238366AbhINC5w (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 13 Sep 2021 22:57:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F274560F3A;
        Tue, 14 Sep 2021 02:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631588195;
        bh=7JbYna5otOtacZcNIs3MgPVTCVaAW4ZwZp5b4qJ3Ra8=;
        h=Date:From:To:Subject:From;
        b=GRZxuhBInJ7eDwILdiI277dp+stUR6FVNsTZZVPEjVzP4JxcBCVwjYZPx/dftbKJz
         XgXIS8+M1v2QHhnbnITQyfe/h+qGes2IKY5u5Jx/NmnlbaC/PhgUDxga2BG/SUb7FA
         bli313J2J1Z3FKRaiesYpuBbBpdNw2ZnBnDQORUs=
Date:   Mon, 13 Sep 2021 19:56:34 -0700
From:   akpm@linux-foundation.org
To:     andreyknvl@gmail.com, bigeasy@linutronix.de, dvyukov@google.com,
        elver@google.com, glider@google.com, gustavoars@kernel.org,
        jiangshanlai@gmail.com, mm-commits@vger.kernel.org,
        ryabinin.a.a@gmail.com, skhan@linuxfoundation.org,
        tarasmadan@google.com, tglx@linutronix.de, tj@kernel.org,
        vinmenon@codeaurora.org, vjitta@codeaurora.org,
        walter-zh.wu@mediatek.com
Subject:  + lib-stackdepot-remove-unused-function-argument.patch
 added to -mm tree
Message-ID: <20210914025634.tfpSUuaRU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot: remove unused function argument
has been added to the -mm tree.  Its filename is
     lib-stackdepot-remove-unused-function-argument.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-stackdepot-remove-unused-function-argument.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-stackdepot-remove-unused-function-argument.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marco Elver <elver@google.com>
Subject: lib/stackdepot: remove unused function argument

alloc_flags in depot_alloc_stack() is no longer used; remove it.

Link: https://lkml.kernel.org/r/20210913112609.2651084-3-elver@google.com
Signed-off-by: Marco Elver <elver@google.com>
Tested-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Taras Madan <tarasmadan@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Cc: Walter Wu <walter-zh.wu@mediatek.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepot-remove-unused-function-argument
+++ a/lib/stackdepot.c
@@ -102,8 +102,8 @@ static bool init_stack_slab(void **preal
 }
 
 /* Allocation of a new stack in raw storage */
-static struct stack_record *depot_alloc_stack(unsigned long *entries, int size,
-		u32 hash, void **prealloc, gfp_t alloc_flags)
+static struct stack_record *
+depot_alloc_stack(unsigned long *entries, int size, u32 hash, void **prealloc)
 {
 	struct stack_record *stack;
 	size_t required_size = struct_size(stack, entries, size);
@@ -309,9 +309,8 @@ depot_stack_handle_t stack_depot_save(un
 
 	found = find_stack(*bucket, entries, nr_entries, hash);
 	if (!found) {
-		struct stack_record *new =
-			depot_alloc_stack(entries, nr_entries,
-					  hash, &prealloc, alloc_flags);
+		struct stack_record *new = depot_alloc_stack(entries, nr_entries, hash, &prealloc);
+
 		if (new) {
 			new->next = *bucket;
 			/*
_

Patches currently in -mm which might be from elver@google.com are

kasan-fix-kconfig-check-of-cc_has_working_nosanitize_address.patch
lib-stackdepot-include-gfph.patch
lib-stackdepot-remove-unused-function-argument.patch
lib-stackdepot-introduce-__stack_depot_save.patch
kasan-common-provide-can_alloc-in-kasan_save_stack.patch
kasan-generic-introduce-kasan_record_aux_stack_noalloc.patch
workqueue-kasan-avoid-alloc_pages-when-recording-stack.patch
mm-fix-data-race-in-pagepoisoned.patch

