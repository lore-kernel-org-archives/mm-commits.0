From: akpm@linux-foundation.org
Subject: [patch 003/114] kasan/Makefile: support LLVM style asan
 parameters
Date: Tue, 06 Feb 2018 15:36:08 -0800
Message-ID: <20180206233608.yYR9EicXn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53172 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753862AbeBFXgJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Feb 2018 18:36:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, dvyukov@google.com, ghackmann@google.com, glider@google.com, mka@chromium.org, mm-commits@vger.kernel.org, paullawrence@google.com, torvalds@linux-foundation.org, yamada.masahiro@socionext.com

From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: kasan/Makefile: support LLVM style asan parameters

LLVM doesn't understand GCC-style paramters ("--param asan-foo=bar"), thus
we currently we don't use inline/globals/stack instrumentation when
building the kernel with clang.

Add support for LLVM-style parameters ("-mllvm -asan-foo=bar") to enable
all KASAN features.

Link: http://lkml.kernel.org/r/20171204191735.132544-3-paullawrence@google.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Paul Lawrence <paullawrence@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Greg Hackmann <ghackmann@google.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/Makefile.kasan |   29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff -puN scripts/Makefile.kasan~kasan-makefile-support-llvm-style-asan-parameters scripts/Makefile.kasan
--- a/scripts/Makefile.kasan~kasan-makefile-support-llvm-style-asan-parameters
+++ a/scripts/Makefile.kasan
@@ -10,10 +10,7 @@ KASAN_SHADOW_OFFSET ?= $(CONFIG_KASAN_SH
 
 CFLAGS_KASAN_MINIMAL := -fsanitize=kernel-address
 
-CFLAGS_KASAN := $(call cc-option, -fsanitize=kernel-address \
-		-fasan-shadow-offset=$(KASAN_SHADOW_OFFSET) \
-		--param asan-stack=1 --param asan-globals=1 \
-		--param asan-instrumentation-with-call-threshold=$(call_threshold))
+cc-param = $(call cc-option, -mllvm -$(1), $(call cc-option, --param $(1)))
 
 ifeq ($(call cc-option, $(CFLAGS_KASAN_MINIMAL) -Werror),)
    ifneq ($(CONFIG_COMPILE_TEST),y)
@@ -21,13 +18,23 @@ ifeq ($(call cc-option, $(CFLAGS_KASAN_M
             -fsanitize=kernel-address is not supported by compiler)
    endif
 else
-    ifeq ($(CFLAGS_KASAN),)
-        ifneq ($(CONFIG_COMPILE_TEST),y)
-            $(warning CONFIG_KASAN: compiler does not support all options.\
-                Trying minimal configuration)
-        endif
-        CFLAGS_KASAN := $(CFLAGS_KASAN_MINIMAL)
-    endif
+   # -fasan-shadow-offset fails without -fsanitize
+   CFLAGS_KASAN_SHADOW := $(call cc-option, -fsanitize=kernel-address \
+			-fasan-shadow-offset=$(KASAN_SHADOW_OFFSET), \
+			$(call cc-option, -fsanitize=kernel-address \
+			-mllvm -asan-mapping-offset=$(KASAN_SHADOW_OFFSET)))
+
+   ifeq ($(strip $(CFLAGS_KASAN_SHADOW)),)
+      CFLAGS_KASAN := $(CFLAGS_KASAN_MINIMAL)
+   else
+      # Now add all the compiler specific options that are valid standalone
+      CFLAGS_KASAN := $(CFLAGS_KASAN_SHADOW) \
+	$(call cc-param,asan-globals=1) \
+	$(call cc-param,asan-instrumentation-with-call-threshold=$(call_threshold)) \
+	$(call cc-param,asan-stack=1) \
+	$(call cc-param,asan-use-after-scope=1)
+   endif
+
 endif
 
 CFLAGS_KASAN += $(call cc-option, -fsanitize-address-use-after-scope)
_
