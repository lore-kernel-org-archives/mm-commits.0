From: akpm@linux-foundation.org
Subject: + kasan-update-kasan_global-for-gcc-7.patch added to -mm tree
Date: Tue, 15 Nov 2016 15:42:49 -0800
Message-ID: <582b9d79.TIU+L+hAonTzgG9s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43604 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933603AbcKOXmz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 15 Nov 2016 18:42:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, aryabinin@virtuozzo.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: update kasan_global for gcc 7
has been added to the -mm tree.  Its filename is
     kasan-update-kasan_global-for-gcc-7.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-update-kasan_global-for-gcc-7.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-update-kasan_global-for-gcc-7.patch

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
Subject: kasan: update kasan_global for gcc 7

kasan_global struct is part of compiler/runtime ABI.  gcc revision 241983
has added a new field to kasan_global struct.  Update kernel definition of
kasan_global struct to include the new field.

Link: http://lkml.kernel.org/r/1479219743-28682-1-git-send-email-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
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
kasan-update-kasan_global-for-gcc-7.patch
kasan-support-use-after-scope-detection.patch

