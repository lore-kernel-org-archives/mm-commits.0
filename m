From: akpm@linux-foundation.org
Subject: + kasan-support-use-after-scope-detection.patch added to -mm tree
Date: Tue, 15 Nov 2016 15:40:05 -0800
Message-ID: <582b9cd5.5J2ye938d4mVWJy5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43548 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752456AbcKOXkG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2016 18:40:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, aryabinin@virtuozzo.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: support use-after-scope detection
has been added to the -mm tree.  Its filename is
     kasan-support-use-after-scope-detection.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-support-use-after-scope-detection.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-support-use-after-scope-detection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: kasan: support use-after-scope detection

Gcc revision 241896 implements use-after-scope detection.
Will be available in gcc 7. Support it in KASAN.

Gcc emits 2 new callbacks to poison/unpoison large stack
objects when they go in/out of scope.
Implement the callbacks and add a test.

Link: http://lkml.kernel.org/r/1479226045-145148-1-git-send-email-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c  |   24 ++++++++++++++++++++++++
 mm/kasan/kasan.c  |   19 +++++++++++++++++++
 mm/kasan/kasan.h  |    1 +
 mm/kasan/report.c |    3 +++
 4 files changed, 47 insertions(+)

diff -puN lib/test_kasan.c~kasan-support-use-after-scope-detection lib/test_kasan.c
--- a/lib/test_kasan.c~kasan-support-use-after-scope-detection
+++ a/lib/test_kasan.c
@@ -411,6 +411,29 @@ static noinline void __init copy_user_te
 	kfree(kmem);
 }
 
+static noinline void __init use_after_scope_test(void)
+{
+	volatile char *volatile p;
+
+	pr_info("use-after-scope on int\n");
+	{
+		int local = 0;
+
+		p = (char *)&local;
+	}
+	p[0] = 1;
+	p[3] = 1;
+
+	pr_info("use-after-scope on array\n");
+	{
+		char local[1024] = {0};
+
+		p = local;
+	}
+	p[0] = 1;
+	p[1023] = 1;
+}
+
 static int __init kmalloc_tests_init(void)
 {
 	kmalloc_oob_right();
@@ -436,6 +459,7 @@ static int __init kmalloc_tests_init(voi
 	kasan_global_oob();
 	ksize_unpoisons_memory();
 	copy_user_test();
+	use_after_scope_test();
 	return -EAGAIN;
 }
 
diff -puN mm/kasan/kasan.c~kasan-support-use-after-scope-detection mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-support-use-after-scope-detection
+++ a/mm/kasan/kasan.c
@@ -764,6 +764,25 @@ EXPORT_SYMBOL(__asan_storeN_noabort);
 void __asan_handle_no_return(void) {}
 EXPORT_SYMBOL(__asan_handle_no_return);
 
+/* Emitted by compiler to poison large objects when they go out of scope. */
+void __asan_poison_stack_memory(const void *addr, size_t size)
+{
+	/*
+	 * Addr is KASAN_SHADOW_SCALE_SIZE-aligned and the object is surrounded
+	 * by redzones, so we simply round up size to simplify logic.
+	 */
+	kasan_poison_shadow(addr, round_up(size, KASAN_SHADOW_SCALE_SIZE),
+			    KASAN_USE_AFTER_SCOPE);
+}
+EXPORT_SYMBOL(__asan_poison_stack_memory);
+
+/* Emitted by compiler to unpoison large objects when they go into of scope. */
+void __asan_unpoison_stack_memory(const void *addr, size_t size)
+{
+	kasan_unpoison_shadow(addr, size);
+}
+EXPORT_SYMBOL(__asan_unpoison_stack_memory);
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 static int kasan_mem_notifier(struct notifier_block *nb,
 			unsigned long action, void *data)
diff -puN mm/kasan/kasan.h~kasan-support-use-after-scope-detection mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~kasan-support-use-after-scope-detection
+++ a/mm/kasan/kasan.h
@@ -21,6 +21,7 @@
 #define KASAN_STACK_MID         0xF2
 #define KASAN_STACK_RIGHT       0xF3
 #define KASAN_STACK_PARTIAL     0xF4
+#define KASAN_USE_AFTER_SCOPE   0xF8
 
 /* Don't break randconfig/all*config builds */
 #ifndef KASAN_ABI_VERSION
diff -puN mm/kasan/report.c~kasan-support-use-after-scope-detection mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-support-use-after-scope-detection
+++ a/mm/kasan/report.c
@@ -90,6 +90,9 @@ static void print_error_description(stru
 	case KASAN_KMALLOC_FREE:
 		bug_type = "use-after-free";
 		break;
+	case KASAN_USE_AFTER_SCOPE:
+		bug_type = "use-after-scope";
+		break;
 	}
 
 	pr_err("BUG: KASAN: %s in %pS at addr %p\n",
_

Patches currently in -mm which might be from dvyukov@google.com are

kasan-support-panic_on_warn.patch
kasan-support-use-after-scope-detection.patch

