Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB52C4167B
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 00:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E630224BD
	for <mm-commits@archiver.kernel.org>; Fri,  4 Dec 2020 00:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgLCX74 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Dec 2020 18:59:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:51992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727871AbgLCX7z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Dec 2020 18:59:55 -0500
Date:   Thu, 03 Dec 2020 15:59:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607039954;
        bh=ZUCJf2fUb0ui7sqhXWgseIYjXg7jgx6j0Ko4Q34rZpc=;
        h=From:To:Subject:From;
        b=0UPqk3kq/zLYmMwDdQ9cbtS19tywif8xRaq9yBqDmQifSqD2QZYIREHkah4mS+WMH
         3sE5UzhTL+ki3/BEJBrOqj5DyD60c3fvI4Yqd6aEXxzHbgyiWtnxsHT4n9LomkN3WO
         3P+GIXhLpqyYD5p7webuQkjvohZWlpxeiLabikpQ=
From:   akpm@linux-foundation.org
To:     andreyknvl@google.com, aryabinin@virtuozzo.com, corbet@lwn.net,
        dvyukov@google.com, elver@google.com, glider@google.com,
        jiangshanlai@gmail.com, matthias.bgg@gmail.com,
        mm-commits@vger.kernel.org, tj@kernel.org,
        walter-zh.wu@mediatek.com
Subject:  + lib-test_kasanc-add-workqueue-test-case.patch added to
 -mm tree
Message-ID: <20201203235913.zzLU2DDu9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/test_kasan.c: add workqueue test case
has been added to the -mm tree.  Its filename is
     lib-test_kasanc-add-workqueue-test-case.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-test_kasanc-add-workqueue-test-case.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-test_kasanc-add-workqueue-test-case.patch

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
Subject: lib/test_kasan.c: add workqueue test case

Adds a test to verify workqueue stack recording and print it in
KASAN report.

The KASAN report was as follows(cleaned up slightly):

 BUG: KASAN: use-after-free in kasan_workqueue_uaf

 Freed by task 54:
  kasan_save_stack+0x24/0x50
  kasan_set_track+0x24/0x38
  kasan_set_free_info+0x20/0x40
  __kasan_slab_free+0x10c/0x170
  kasan_slab_free+0x10/0x18
  kfree+0x98/0x270
  kasan_workqueue_work+0xc/0x18

 Last potentially related work creation:
  kasan_save_stack+0x24/0x50
  kasan_record_wq_stack+0xa8/0xb8
  insert_work+0x48/0x288
  __queue_work+0x3e8/0xc40
  queue_work_on+0xf4/0x118
  kasan_workqueue_uaf+0xfc/0x190

Link: https://lkml.kernel.org/r/20201203022748.30681-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Acked-by: Marco Elver <elver@google.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan_module.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/lib/test_kasan_module.c~lib-test_kasanc-add-workqueue-test-case
+++ a/lib/test_kasan_module.c
@@ -91,6 +91,34 @@ static noinline void __init kasan_rcu_ua
 	call_rcu(&global_rcu_ptr->rcu, kasan_rcu_reclaim);
 }
 
+static noinline void __init kasan_workqueue_work(struct work_struct *work)
+{
+	kfree(work);
+}
+
+static noinline void __init kasan_workqueue_uaf(void)
+{
+	struct workqueue_struct *workqueue;
+	struct work_struct *work;
+
+	workqueue = create_workqueue("kasan_wq_test");
+	if (!workqueue) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+	work = kmalloc(sizeof(struct work_struct), GFP_KERNEL);
+	if (!work) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	INIT_WORK(work, kasan_workqueue_work);
+	queue_work(workqueue, work);
+	destroy_workqueue(workqueue);
+
+	pr_info("use-after-free on workqueue\n");
+	((volatile struct work_struct *)work)->data;
+}
 
 static int __init test_kasan_module_init(void)
 {
@@ -102,6 +130,7 @@ static int __init test_kasan_module_init
 
 	copy_user_test();
 	kasan_rcu_uaf();
+	kasan_workqueue_uaf();
 
 	kasan_restore_multi_shot(multishot);
 	return -EAGAIN;
_

Patches currently in -mm which might be from walter-zh.wu@mediatek.com are

workqueue-kasan-record-workqueue-stack.patch
kasan-print-workqueue-stack.patch
lib-test_kasanc-add-workqueue-test-case.patch
kasan-update-documentation-for-generic-kasan.patch

