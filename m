From: akpm@linux-foundation.org
Subject: [merged] kasan-update-kasan_global-for-gcc-7.patch removed from
 -mm tree
Date: Thu, 01 Dec 2016 12:06:53 -0800
Message-ID: <584082dd.5lASjXu0AebqP+ps%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44588 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759436AbcLAUGy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Dec 2016 15:06:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, aryabinin@virtuozzo.com, glider@google.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: update kasan_global for gcc 7
has been removed from the -mm tree.  Its filename was
     kasan-update-kasan_global-for-gcc-7.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from dvyukov@google.com are

kasan-support-panic_on_warn.patch
kasan-eliminate-long-stalls-during-quarantine-reduction.patch

