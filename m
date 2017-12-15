From: akpm@linux-foundation.org
Subject: + kasan-added-functions-for-unpoisoning-stack-variables.patch
 added to -mm tree
Date: Fri, 15 Dec 2017 15:57:09 -0800
Message-ID: <5a346155.1iq7IZ0jFOHpjoNx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36528 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755795AbdLOX5L (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 15 Dec 2017 18:57:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, ghackmann@google.com, mka@chromium.org, paullawrence@google.com, yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add functions for unpoisoning stack variables
has been added to the -mm tree.  Its filename is
     kasan-added-functions-for-unpoisoning-stack-variables.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-added-functions-for-unpoisoning-stack-variables.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-added-functions-for-unpoisoning-stack-variables.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kasan: add functions for unpoisoning stack variables

As a code-size optimization, LLVM builds since r279383 may bulk-manipulate
the shadow region when (un)poisoning large memory blocks.  This requires
new callbacks that simply do an uninstrumented memset().

This fixes linking the Clang-built kernel when using KASAN.

[ghackmann@google.com: fix memset() parameters, and tweak commit message to describe new callbacks]
Link: http://lkml.kernel.org/r/20171204191735.132544-6-paullawrence@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Greg Hackmann <ghackmann@google.com>
Signed-off-by: Paul Lawrence <paullawrence@google.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN mm/kasan/kasan.c~kasan-added-functions-for-unpoisoning-stack-variables mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-added-functions-for-unpoisoning-stack-variables
+++ a/mm/kasan/kasan.c
@@ -770,6 +770,21 @@ void __asan_allocas_unpoison(const void
 }
 EXPORT_SYMBOL(__asan_allocas_unpoison);
 
+/* Emitted by the compiler to [un]poison local variables. */
+#define DEFINE_ASAN_SET_SHADOW(byte) \
+	void __asan_set_shadow_##byte(const void *addr, size_t size)	\
+	{								\
+		__memset((void *)addr, 0x##byte, size);			\
+	}								\
+	EXPORT_SYMBOL(__asan_set_shadow_##byte)
+
+DEFINE_ASAN_SET_SHADOW(00);
+DEFINE_ASAN_SET_SHADOW(f1);
+DEFINE_ASAN_SET_SHADOW(f2);
+DEFINE_ASAN_SET_SHADOW(f3);
+DEFINE_ASAN_SET_SHADOW(f5);
+DEFINE_ASAN_SET_SHADOW(f8);
+
 #ifdef CONFIG_MEMORY_HOTPLUG
 static int __meminit kasan_mem_notifier(struct notifier_block *nb,
 			unsigned long action, void *data)
_

Patches currently in -mm which might be from glider@google.com are

kasan-added-functions-for-unpoisoning-stack-variables.patch
lib-stackdepot-use-a-non-instrumented-version-of-memcmp.patch

