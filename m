Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5FB5C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 01:18:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61A5764F04
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 01:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhCRBSW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 21:18:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229880AbhCRBST (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 21:18:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BFED64E02;
        Thu, 18 Mar 2021 01:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616030298;
        bh=KGV04UYD11tqK5Qgn34xAZSNFmtdnzb3H58wEst3RlU=;
        h=Date:From:To:Subject:From;
        b=drn87ZUjX4Gs24iyz0FnsBfbGiyw0GsXZpH0+0qfVZnHPX1hUUz2qMTC04fCnhsnC
         yVJT0/eU4fqc0TialRkdemCkIcHfllYmKa2ynx5C8NwK3INX8UGoA3QEQePnqV9/yO
         hB57b9hcZminNZAPrkO6aDyIX+EZEN1i0CymJYns=
Date:   Wed, 17 Mar 2021 18:18:17 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andreyknvl@google.com, axboe@kernel.dk,
        dvyukov@google.com, glider@google.com, matthias.bgg@gmail.com,
        mm-commits@vger.kernel.org, oleg@redhat.com,
        ryabinin.a.a@gmail.com, walter-zh.wu@mediatek.com
Subject:  + task_work-kasan-record-task_work_add-call-stack.patch
 added to -mm tree
Message-ID: <20210318011817.JJuFVbZdn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: record task_work_add() call stack
has been added to the -mm tree.  Its filename is
     task_work-kasan-record-task_work_add-call-stack.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/task_work-kasan-record-task_work_add-call-stack.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/task_work-kasan-record-task_work_add-call-stack.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Walter Wu <walter-zh.wu@mediatek.com>
Subject: kasan: record task_work_add() call stack

Why record task_work_add() call stack?  Syzbot reports many use-after-free
issues for task_work, see [1].  After seeing the free stack and the
current auxiliary stack, we think they are useless, we don't know where
the work was registered.  This work may be the free call stack, so we miss
the root cause and don't solve the use-after-free.

Add the task_work_add() call stack into the KASAN auxiliary stack in order
to improve KASAN reports.  It helps programmers solve use-after-free
issues.

[1]: https://groups.google.com/g/syzkaller-bugs/search?q=kasan%20use-after-free%20task_work_run

Link: https://lkml.kernel.org/r/20210316024410.19967-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Suggested-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/task_work.c |    3 +++
 mm/kasan/kasan.h   |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/task_work.c~task_work-kasan-record-task_work_add-call-stack
+++ a/kernel/task_work.c
@@ -34,6 +34,9 @@ int task_work_add(struct task_struct *ta
 {
 	struct callback_head *head;
 
+	/* record the work call stack in order to print it in KASAN reports */
+	kasan_record_aux_stack(work);
+
 	do {
 		head = READ_ONCE(task->task_works);
 		if (unlikely(head == &work_exited))
--- a/mm/kasan/kasan.h~task_work-kasan-record-task_work_add-call-stack
+++ a/mm/kasan/kasan.h
@@ -146,7 +146,7 @@ struct kasan_alloc_meta {
 	struct kasan_track alloc_track;
 #ifdef CONFIG_KASAN_GENERIC
 	/*
-	 * call_rcu() call stack is stored into struct kasan_alloc_meta.
+	 * The auxiliary stack is stored into struct kasan_alloc_meta.
 	 * The free stack is stored into struct kasan_free_meta.
 	 */
 	depot_stack_handle_t aux_stack[2];
_

Patches currently in -mm which might be from walter-zh.wu@mediatek.com are

kasan-remove-redundant-config-option.patch
task_work-kasan-record-task_work_add-call-stack.patch

