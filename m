From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 6/7] kasan: consistently disable debugging
 features
Date: Wed, 13 May 2020 17:50:51 -0700
Message-ID: <20200514005051.lU7XkUgP7%akpm@linux-foundation.org>
References: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728313AbgENAuw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 May 2020 20:50:52 -0400
In-Reply-To: <20200513175005.1f4839360c18c0238df292d1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, leonro@mellanox.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: consistently disable debugging features

KASAN is incompatible with some kernel debugging/tracing features. 
There's been multiple patches that disable those feature for some of KASAN
files one by one.  Instead of prolonging that, disable these features for
all KASAN files at once.

Link: http://lkml.kernel.org/r/29bd753d5ff5596425905b0b07f51153e2345cc1.1589297433.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/Makefile |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/mm/kasan/Makefile~kasan-consistently-disable-debugging-features
+++ a/mm/kasan/Makefile
@@ -1,23 +1,28 @@
 # SPDX-License-Identifier: GPL-2.0
 KASAN_SANITIZE := n
-UBSAN_SANITIZE_common.o := n
-UBSAN_SANITIZE_generic.o := n
-UBSAN_SANITIZE_generic_report.o := n
-UBSAN_SANITIZE_tags.o := n
+UBSAN_SANITIZE := n
 KCOV_INSTRUMENT := n
 
+# Disable ftrace to avoid recursion.
 CFLAGS_REMOVE_common.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_generic.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_generic_report.o = $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_init.o = $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_quarantine.o = $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_report.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_tags.o = $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_tags_report.o = $(CC_FLAGS_FTRACE)
 
 # Function splitter causes unnecessary splits in __asan_load1/__asan_store1
 # see: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=63533
