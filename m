From: akpm@linux-foundation.org
Subject: [patch 004/114] kasan: support alloca() poisoning
Date: Tue, 06 Feb 2018 15:36:11 -0800
Message-ID: <20180206233611.HdRYT-oR_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53558 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753862AbeBFXgX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:36:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, dvyukov@google.com, ghackmann@google.com, glider@google.com, mka@chromium.org, mm-commits@vger.kernel.org, paullawrence@google.com, torvalds@linux-foundation.org, yamada.masahiro@socionext.com

From: Paul Lawrence <paullawrence@google.com>
Subject: kasan: support alloca() poisoning

clang's AddressSanitizer implementation adds redzones on either side of
alloca()ed buffers.  These redzones are 32-byte aligned and at least 32
bytes long.

__asan_alloca_poison() is passed the size and address of the allocated
buffer, *excluding* the redzones on either side.  The left redzone will
always be to the immediate left of this buffer; but AddressSanitizer may
need to add padding between the end of the buffer and the right redzone. 
If there are any 8-byte chunks inside this padding, we should poison those
too.

__asan_allocas_unpoison() is just passed the top and bottom of the dynamic
stack area, so unpoisoning is simpler.

Link: http://lkml.kernel.org/r/20171204191735.132544-4-paullawrence@google.com
Signed-off-by: Greg Hackmann <ghackmann@google.com>
Signed-off-by: Paul Lawrence <paullawrence@google.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c       |   34 ++++++++++++++++++++++++++++++++++
 mm/kasan/kasan.h       |    8 ++++++++
 mm/kasan/report.c      |    4 ++++
 scripts/Makefile.kasan |    3 ++-
 4 files changed, 48 insertions(+), 1 deletion(-)

diff -puN mm/kasan/kasan.c~kasan-support-alloca-poisoning mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-support-alloca-poisoning
+++ a/mm/kasan/kasan.c
@@ -736,6 +736,40 @@ void __asan_unpoison_stack_memory(const
 }
 EXPORT_SYMBOL(__asan_unpoison_stack_memory);
 
+/* Emitted by compiler to poison alloca()ed objects. */
+void __asan_alloca_poison(unsigned long addr, size_t size)
+{
+	size_t rounded_up_size = round_up(size, KASAN_SHADOW_SCALE_SIZE);
+	size_t padding_size = round_up(size, KASAN_ALLOCA_REDZONE_SIZE) -
+			rounded_up_size;
+	size_t rounded_down_size = round_down(size, KASAN_SHADOW_SCALE_SIZE);
+
+	const void *left_redzone = (const void *)(addr -
+			KASAN_ALLOCA_REDZONE_SIZE);
+	const void *right_redzone = (const void *)(addr + rounded_up_size);
+
+	WARN_ON(!IS_ALIGNED(addr, KASAN_ALLOCA_REDZONE_SIZE));
+
+	kasan_unpoison_shadow((const void *)(addr + rounded_down_size),
+			      size - rounded_down_size);
+	kasan_poison_shadow(left_redzone, KASAN_ALLOCA_REDZONE_SIZE,
+			KASAN_ALLOCA_LEFT);
+	kasan_poison_shadow(right_redzone,
+			padding_size + KASAN_ALLOCA_REDZONE_SIZE,
+			KASAN_ALLOCA_RIGHT);
+}
+EXPORT_SYMBOL(__asan_alloca_poison);
+
+/* Emitted by compiler to unpoison alloca()ed areas when the stack unwinds. */
+void __asan_allocas_unpoison(const void *stack_top, const void *stack_bottom)
+{
+	if (unlikely(!stack_top || stack_top > stack_bottom))
+		return;
+
+	kasan_unpoison_shadow(stack_top, stack_bottom - stack_top);
+}
+EXPORT_SYMBOL(__asan_allocas_unpoison);
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 static int __meminit kasan_mem_notifier(struct notifier_block *nb,
 			unsigned long action, void *data)
diff -puN mm/kasan/kasan.h~kasan-support-alloca-poisoning mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~kasan-support-alloca-poisoning
+++ a/mm/kasan/kasan.h
@@ -24,6 +24,14 @@
 #define KASAN_STACK_PARTIAL     0xF4
 #define KASAN_USE_AFTER_SCOPE   0xF8
 
+/*
+ * alloca redzone shadow values
+ */
+#define KASAN_ALLOCA_LEFT	0xCA
+#define KASAN_ALLOCA_RIGHT	0xCB
+
+#define KASAN_ALLOCA_REDZONE_SIZE	32
+
 /* Don't break randconfig/all*config builds */
 #ifndef KASAN_ABI_VERSION
 #define KASAN_ABI_VERSION 1
diff -puN mm/kasan/report.c~kasan-support-alloca-poisoning mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-support-alloca-poisoning
+++ a/mm/kasan/report.c
@@ -102,6 +102,10 @@ static const char *get_shadow_bug_type(s
 	case KASAN_USE_AFTER_SCOPE:
 		bug_type = "use-after-scope";
 		break;
+	case KASAN_ALLOCA_LEFT:
+	case KASAN_ALLOCA_RIGHT:
+		bug_type = "alloca-out-of-bounds";
+		break;
 	}
 
 	return bug_type;
diff -puN scripts/Makefile.kasan~kasan-support-alloca-poisoning scripts/Makefile.kasan
--- a/scripts/Makefile.kasan~kasan-support-alloca-poisoning
+++ a/scripts/Makefile.kasan
@@ -32,7 +32,8 @@ else
 	$(call cc-param,asan-globals=1) \
 	$(call cc-param,asan-instrumentation-with-call-threshold=$(call_threshold)) \
 	$(call cc-param,asan-stack=1) \
-	$(call cc-param,asan-use-after-scope=1)
+	$(call cc-param,asan-use-after-scope=1) \
+	$(call cc-param,asan-instrument-allocas=1)
    endif
 
 endif
_
