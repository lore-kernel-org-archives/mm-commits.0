From: akpm@linux-foundation.org
Subject: [merged] kasan-add-tests-for-alloca-poisoning.patch
 removed from -mm tree
Date: Wed, 07 Feb 2018 11:55:16 -0800
Message-ID: <20180207195516.x8APz8SyV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57894 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754002AbeBGTzR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:55:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, ghackmann@google.com, glider@google.com, mka@chromium.org, mm-commits@vger.kernel.org, paullawrence@google.com, yamada.masahiro@socionext.com


The patch titled
     Subject: kasan: add tests for alloca poisoning
has been removed from the -mm tree.  Its filename was
     kasan-add-tests-for-alloca-poisoning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Paul Lawrence <paullawrence@google.com>
Subject: kasan: add tests for alloca poisoning

Link: http://lkml.kernel.org/r/20171204191735.132544-5-paullawrence@google.com
Signed-off-by: Greg Hackmann <ghackmann@google.com>
Signed-off-by: Paul Lawrence <paullawrence@google.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN lib/test_kasan.c~kasan-add-tests-for-alloca-poisoning lib/test_kasan.c
--- a/lib/test_kasan.c~kasan-add-tests-for-alloca-poisoning
+++ a/lib/test_kasan.c
@@ -472,6 +472,26 @@ static noinline void __init use_after_sc
 	p[1023] = 1;
 }
 
+static noinline void __init kasan_alloca_oob_left(void)
+{
+	volatile int i = 10;
+	char alloca_array[i];
+	char *p = alloca_array - 1;
+
+	pr_info("out-of-bounds to left on alloca\n");
+	*(volatile char *)p;
+}
+
+static noinline void __init kasan_alloca_oob_right(void)
+{
+	volatile int i = 10;
+	char alloca_array[i];
+	char *p = alloca_array + i;
+
+	pr_info("out-of-bounds to right on alloca\n");
+	*(volatile char *)p;
+}
+
 static int __init kmalloc_tests_init(void)
 {
 	/*
@@ -502,6 +522,8 @@ static int __init kmalloc_tests_init(voi
 	memcg_accounted_kmem_cache();
 	kasan_stack_oob();
 	kasan_global_oob();
+	kasan_alloca_oob_left();
+	kasan_alloca_oob_right();
 	ksize_unpoisons_memory();
 	copy_user_test();
 	use_after_scope_test();
_

Patches currently in -mm which might be from paullawrence@google.com are


