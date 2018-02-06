From: akpm@linux-foundation.org
Subject: [patch 005/114] kasan: add tests for alloca poisoning
Date: Tue, 06 Feb 2018 15:36:16 -0800
Message-ID: <20180206233616.EKoRkv_YK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53592 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753862AbeBFXgX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:36:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, dvyukov@google.com, ghackmann@google.com, glider@google.com, mka@chromium.org, mm-commits@vger.kernel.org, paullawrence@google.com, torvalds@linux-foundation.org, yamada.masahiro@socionext.com

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
