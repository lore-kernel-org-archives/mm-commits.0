From: akpm@linux-foundation.org
Subject: + kasan-support-alloca-poisoning.patch added to -mm tree
Date: Fri, 15 Dec 2017 15:57:03 -0800
Message-ID: <5a34614f.FIp1/uH0u4XBS8cb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36510 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755795AbdLOX5F (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Dec 2017 18:57:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: paullawrence@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, ghackmann@google.com, glider@google.com, mka@chromium.org, yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: support alloca() poisoning
has been added to the -mm tree.  Its filename is
     kasan-support-alloca-poisoning.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-support-alloca-poisoning.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-support-alloca-poisoning.patch

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

Patches currently in -mm which might be from paullawrence@google.com are

kasan-add-compiler-support-for-clang.patch
kasan-support-alloca-poisoning.patch
kasan-add-tests-for-alloca-poisoning.patch

