From: akpm@linux-foundation.org
Subject: [patch 002/114] kasan: add compiler support for clang
Date: Tue, 06 Feb 2018 15:36:03 -0800
Message-ID: <20180206233603.1cr6c3Pe5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53056 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753862AbeBFXgG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:36:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, dvyukov@google.com, ghackmann@google.com, glider@google.com, mka@chromium.org, mm-commits@vger.kernel.org, paullawrence@google.com, torvalds@linux-foundation.org, yamada.masahiro@socionext.com

From: Paul Lawrence <paullawrence@google.com>
Subject: kasan: add compiler support for clang

Patch series "kasan: support alloca, LLVM", v4.


This patch (of 5):

For now we can hard-code ASAN ABI level 5, since historical clang builds
can't build the kernel anyway.  We also need to emulate gcc's
__SANITIZE_ADDRESS__ flag, or memset() calls won't be instrumented.

Link: http://lkml.kernel.org/r/20171204191735.132544-2-paullawrence@google.com
Signed-off-by: Greg Hackmann <ghackmann@google.com>
Signed-off-by: Paul Lawrence <paullawrence@google.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler-clang.h |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN include/linux/compiler-clang.h~kasan-add-compiler-support-for-clang include/linux/compiler-clang.h
--- a/include/linux/compiler-clang.h~kasan-add-compiler-support-for-clang
+++ a/include/linux/compiler-clang.h
@@ -19,3 +19,11 @@
 
 #define randomized_struct_fields_start	struct {
 #define randomized_struct_fields_end	};
+
+/* all clang versions usable with the kernel support KASAN ABI version 5 */
+#define KASAN_ABI_VERSION 5
+
+/* emulate gcc's __SANITIZE_ADDRESS__ flag */
+#if __has_feature(address_sanitizer)
+#define __SANITIZE_ADDRESS__
+#endif
_
