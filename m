From: akpm@linux-foundation.org
Subject: [merged] kasan-add-compiler-support-for-clang.patch
 removed from -mm tree
Date: Wed, 07 Feb 2018 11:55:06 -0800
Message-ID: <20180207195506.Dm3ndyoIc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57846 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753721AbeBGTzH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 7 Feb 2018 14:55:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, ghackmann@google.com, glider@google.com, mka@chromium.org, mm-commits@vger.kernel.org, paullawrence@google.com, yamada.masahiro@socionext.com


The patch titled
     Subject: kasan: add compiler support for clang
has been removed from the -mm tree.  Its filename was
     kasan-add-compiler-support-for-clang.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from paullawrence@google.com are


