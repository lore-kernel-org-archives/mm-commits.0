Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599C0C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:44:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C1BD61415
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhEHWpl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:45:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:54418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhEHWpk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:45:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B49D613EA;
        Sat,  8 May 2021 22:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513879;
        bh=LRqaXBMK2Eh+e+y593SfbKtgWxWxfk57cw8RgX+WKQ0=;
        h=Date:From:To:Subject:From;
        b=HssQva0zM2GZ2HqxSK0BjxEvn488wj3wLLMiJFuTpdTNvhIpcU62cx55zFRH4RMUa
         1mbYMTszsAu/2dx1dYZFhftr+zFpf+7Z0B+iAhw/NeH21i+KRHgL7FJ+3lWbZpzGq3
         csk29lnA2Sr2Kr23aIW/7NSRTbnUAZEqNmIZt35M=
Date:   Sat, 08 May 2021 15:44:38 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, andreyknvl@google.com, axboe@kernel.dk,
        dvyukov@google.com, glider@google.com, matthias.bgg@gmail.com,
        mm-commits@vger.kernel.org, oleg@redhat.com,
        ryabinin.a.a@gmail.com, walter-zh.wu@mediatek.com
Subject:  [merged]
 task_work-kasan-record-task_work_add-call-stack.patch removed from -mm tree
Message-ID: <20210508224438.pn3rzsDH2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: record task_work_add() call stack
has been removed from the -mm tree.  Its filename was
     task_work-kasan-record-task_work_add-call-stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -163,7 +163,7 @@ struct kasan_alloc_meta {
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


