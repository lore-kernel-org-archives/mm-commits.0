From: akpm@linux-foundation.org
Subject: + kasan-add-tests-for-call_rcu-stack-recording.patch
 added to -mm tree
Date: Fri, 03 Jul 2020 10:28:34 -0700
Message-ID: <20200703172834.PTFqhoBEr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726147AbgGCR2g (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Jul 2020 13:28:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, aryabinin@virtuozzo.com, corbet@lwn.net, dvyukov@google.com, glider@google.com, jiangshanlai@gmail.com, joel@joelfernandes.org, josh@joshtriplett.org, mathieu.desnoyers@efficios.com, matthias.bgg@gmail.com, mm-commits@vger.kernel.org, paulmck@kernel.org, walter-zh.wu@mediatek.com


The patch titled
     Subject: kasan: add tests for call_rcu stack recording
has been added to the -mm tree.  Its filename is
     kasan-add-tests-for-call_rcu-stack-recording.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-add-tests-for-call_rcu-stack-recording.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-add-tests-for-call_rcu-stack-recording.patch

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
Subject: kasan: add tests for call_rcu stack recording

Test call_rcu() call stack recording and verify whether it correctly is
printed in KASAN report.

Link: http://lkml.kernel.org/r/20200601051045.1294-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Tested-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/lib/test_kasan.c~kasan-add-tests-for-call_rcu-stack-recording
+++ a/lib/test_kasan.c
@@ -801,6 +801,35 @@ static noinline void __init vmalloc_oob(
 static void __init vmalloc_oob(void) {}
 #endif
 
+static struct kasan_rcu_info {
+	int i;
+	struct rcu_head rcu;
+} *global_rcu_ptr;
+
+static noinline void __init kasan_rcu_reclaim(struct rcu_head *rp)
+{
+	struct kasan_rcu_info *fp = container_of(rp,
+						struct kasan_rcu_info, rcu);
+
+	kfree(fp);
+	fp->i = 1;
+}
+
+static noinline void __init kasan_rcu_uaf(void)
+{
+	struct kasan_rcu_info *ptr;
+
+	pr_info("use-after-free in kasan_rcu_reclaim\n");
+	ptr = kmalloc(sizeof(struct kasan_rcu_info), GFP_KERNEL);
+	if (!ptr) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	global_rcu_ptr = rcu_dereference_protected(ptr, NULL);
+	call_rcu(&global_rcu_ptr->rcu, kasan_rcu_reclaim);
+}
+
 static int __init kmalloc_tests_init(void)
 {
 	/*
@@ -848,6 +877,7 @@ static int __init kmalloc_tests_init(voi
 	kasan_bitops();
 	kmalloc_double_kzfree();
 	vmalloc_oob();
+	kasan_rcu_uaf();
 
 	kasan_restore_multi_shot(multishot);
 
_

Patches currently in -mm which might be from walter-zh.wu@mediatek.com are

rcu-kasan-record-and-print-call_rcu-call-stack.patch
kasan-record-and-print-the-free-track.patch
kasan-add-tests-for-call_rcu-stack-recording.patch
kasan-update-documentation-for-generic-kasan.patch
