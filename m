Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C601C433FE
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 00:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01A27222B6
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 00:00:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgLCX7z (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Dec 2020 18:59:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:51928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726525AbgLCX7z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Dec 2020 18:59:55 -0500
Date:   Thu, 03 Dec 2020 15:59:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607039948;
        bh=B2qnvfUrwVCypUd/7MGnp/FtG1ZCZd3WG0HqerS2BsU=;
        h=From:To:Subject:From;
        b=vM4CMe2xA6ButRDDFRFFi3RJph0e68mZw0aSmVyOxduTCwZXn2XPI6NRE1oN21TGk
         CsU3jNpUoH5NqouQIwIcO9jtHgxd/in0tBVHknJ9S+7tgQgoO77qzZk6j2Uind1OlW
         teACtR61LORqs4SxlKp/4UPYRQmX69eQyX01r0xY=
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, corbet@lwn.net,
        dvyukov@google.com, elver@google.com, glider@google.com,
        jiangshanlai@gmail.com, matthias.bgg@gmail.com,
        mm-commits@vger.kernel.org, tj@kernel.org,
        walter-zh.wu@mediatek.com
Subject:  + workqueue-kasan-record-workqueue-stack.patch added to
 -mm tree
Message-ID: <20201203235906.QZHXHVKCI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: workqueue: kasan: record workqueue stack
has been added to the -mm tree.  Its filename is
     workqueue-kasan-record-workqueue-stack.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/workqueue-kasan-record-workqueue-stack.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/workqueue-kasan-record-workqueue-stack.patch

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
Subject: workqueue: kasan: record workqueue stack

Patch series "kasan: add workqueue stack for generic KASAN", v5.

Syzbot reports many UAF issues for workqueue, see [1].
In some of these access/allocation happened in process_one_work(),
we see the free stack is useless in KASAN report, it doesn't help
programmers to solve UAF for workqueue issue.

This patchset improves KASAN reports by making them to have workqueue
queueing stack. It is useful for programmers to solve use-after-free
or double-free memory issue.

Generic KASAN also records the last two workqueue stacks and prints
them in KASAN report. It is only suitable for generic KASAN.

[1]https://groups.google.com/g/syzkaller-bugs/search?q=%22use-after-free%22+process_one_work
[2]https://bugzilla.kernel.org/show_bug.cgi?id=198437


This patch (of 4):

When analyzing use-after-free or double-free issue, recording the
enqueuing work stacks is helpful to preserve usage history which
potentially gives a hint about the affected code.

For workqueue it has turned out to be useful to record the enqueuing work
call stacks.  Because user can see KASAN report to determine whether it is
root cause.  They don't need to enable debugobjects, but they have a
chance to find out the root cause.

Link: https://lkml.kernel.org/r/20201203022148.29754-1-walter-zh.wu@mediatek.com
Link: https://lkml.kernel.org/r/20201203022442.30006-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Suggested-by: Marco Elver <elver@google.com>
Acked-by: Marco Elver <elver@google.com>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/workqueue.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/workqueue.c~workqueue-kasan-record-workqueue-stack
+++ a/kernel/workqueue.c
@@ -1327,6 +1327,9 @@ static void insert_work(struct pool_work
 {
 	struct worker_pool *pool = pwq->pool;
 
+	/* record the work call stack in order to print it in KASAN reports */
+	kasan_record_aux_stack(work);
+
 	/* we own @work, set data and link */
 	set_work_pwq(work, pwq, extra_flags);
 	list_add_tail(&work->entry, head);
_

Patches currently in -mm which might be from walter-zh.wu@mediatek.com are

workqueue-kasan-record-workqueue-stack.patch
kasan-print-workqueue-stack.patch
lib-test_kasanc-add-workqueue-test-case.patch
kasan-update-documentation-for-generic-kasan.patch

