From: akpm@linux-foundation.org
Subject: + kasan-add-tests-for-alloca-poisoning.patch added to -mm tree
Date: Fri, 15 Dec 2017 15:57:06 -0800
Message-ID: <5a346152.ru21mgvR2d946VBV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36518 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755795AbdLOX5H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Dec 2017 18:57:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paullawrence@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, ghackmann@google.com, glider@google.com, mka@chromium.org, yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add tests for alloca poisoning
has been added to the -mm tree.  Its filename is
     kasan-add-tests-for-alloca-poisoning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-add-tests-for-alloca-poisoning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-add-tests-for-alloca-poisoning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

kasan-add-compiler-support-for-clang.patch
kasan-support-alloca-poisoning.patch
kasan-add-tests-for-alloca-poisoning.patch

