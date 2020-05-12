From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-consistently-disable-debugging-features.patch
 added to -mm tree
Date: Tue, 12 May 2020 14:03:25 -0700
Message-ID: <20200512210325._e0c4j-S5%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgELVD1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 12 May 2020 17:03:27 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, leonro@mellanox.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: consistently disable debugging features
has been added to the -mm tree.  Its filename is
     kasan-consistently-disable-debugging-features.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-consistently-disable-debugging-features.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-consistently-disable-debugging-features.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
