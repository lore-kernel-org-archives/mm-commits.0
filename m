Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A032CC433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:00:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8279461483
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 06:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbhD3GBf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:01:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:54760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230285AbhD3GBf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 02:01:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A6AB6147E;
        Fri, 30 Apr 2021 06:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762446;
        bh=mRwLr0e8X+wSiQl3LIXYEs0Wa7hiH8VOxiNWAGA+BiQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1DiD93kHRwzafgQvysrrOgOYbRCt8+cpqZPAmGkO6+GAhM7KaD+KQ4b18jSnmAsjE
         NZInkMylZa608zH74GUbjzetGkpeLdLrSo80yPnQHXKW+5QM1ot00j97D75wvjTXXs
         rMugj4hjMsUGIyFbvkqvuw4+Qy2sJ1W4o2wSYtyk=
Date:   Thu, 29 Apr 2021 23:00:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, andreyknvl@google.com, axboe@kernel.dk,
        dvyukov@google.com, glider@google.com, linux-mm@kvack.org,
        matthias.bgg@gmail.com, mm-commits@vger.kernel.org,
        oleg@redhat.com, ryabinin.a.a@gmail.com,
        torvalds@linux-foundation.org, walter-zh.wu@mediatek.com
Subject:  [patch 147/178] kasan: record task_work_add() call stack
Message-ID: <20210430060045.EygxZbqmc%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
