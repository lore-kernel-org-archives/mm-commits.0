From: akpm@linux-foundation.org
Subject: [patch 5/7] kasan: update kasan_global for gcc 7
Date: Wed, 30 Nov 2016 15:54:13 -0800
Message-ID: <583f66a5.jnvgDeOd+93qU3vS%akpm__30570.4650505961$1480550045$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43302 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755305AbcK3Xx5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2016 18:53:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, dvyukov@google.com, aryabinin@virtuozzo.com, glider@google.com, stable@vger.kernel.org

From: Dmitry Vyukov <dvyukov@google.com>
Subject: kasan: update kasan_global for gcc 7

kasan_global struct is part of compiler/runtime ABI.  gcc revision 241983
has added a new field to kasan_global struct.  Update kernel definition of
kasan_global struct to include the new field.

Without this patch KASAN is broken with gcc 7.

Link: http://lkml.kernel.org/r/1479219743-28682-1-git-send-email-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: <stable@vger.kernel.org>	[4.0+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-gcc.h |    4 +++-
 mm/kasan/kasan.h             |    3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff -puN include/linux/compiler-gcc.h~kasan-update-kasan_global-for-gcc-7 include/linux/compiler-gcc.h
--- a/include/linux/compiler-gcc.h~kasan-update-kasan_global-for-gcc-7
+++ a/include/linux/compiler-gcc.h
@@ -263,7 +263,9 @@
 #endif
 #endif /* CONFIG_ARCH_USE_BUILTIN_BSWAP && !__CHECKER__ */
 
-#if GCC_VERSION >= 50000
+#if GCC_VERSION >= 70000
+#define KASAN_ABI_VERSION 5
+#elif GCC_VERSION >= 50000
 #define KASAN_ABI_VERSION 4
 #elif GCC_VERSION >= 40902
 #define KASAN_ABI_VERSION 3
diff -puN mm/kasan/kasan.h~kasan-update-kasan_global-for-gcc-7 mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~kasan-update-kasan_global-for-gcc-7
+++ a/mm/kasan/kasan.h
@@ -53,6 +53,9 @@ struct kasan_global {
 #if KASAN_ABI_VERSION >= 4
 	struct kasan_source_location *location;
 #endif
+#if KASAN_ABI_VERSION >= 5
+	char *odr_indicator;
+#endif
 };
 
 /**
_
