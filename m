From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 118/166] lib/stackdepot.c: build with -fno-builtin
Date: Mon, 06 Apr 2020 20:10:19 -0700
Message-ID: <20200407031019.GPp46WoMb%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgDGDKU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:10:20 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreyknvl@google.com, arnd@arndb.de, aryabinin@virtuozzo.com, dvyukov@google.com, elver@google.com, glider@google.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, torvalds@linux-foundation.org, vegard.nossum@oracle.com

From: Alexander Potapenko <glider@google.com>
Subject: lib/stackdepot.c: build with -fno-builtin

Clang may replace stackdepot_memcmp() with a call to instrumented bcmp(),
which is exactly what we wanted to avoid creating stackdepot_memcmp(). 
Building the file with -fno-builtin prevents such optimizations.

This patch has been previously mailed as part of KMSAN RFC patch series.

Link: http://lkml.kernel.org/r/20200220141916.55455-2-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Makefile |    4 ++++
 1 file changed, 4 insertions(+)

--- a/lib/Makefile~stackdepot-build-with-fno-builtin
+++ a/lib/Makefile
@@ -223,6 +223,10 @@ obj-$(CONFIG_MEMREGION) += memregion.o
 obj-$(CONFIG_STMP_DEVICE) += stmp_device.o
 obj-$(CONFIG_IRQ_POLL) += irq_poll.o
 
+# stackdepot.c should not be instrumented or call instrumented functions.
+# Prevent the compiler from calling builtins like memcmp() or bcmp() from this
+# file.
+CFLAGS_stackdepot.o += -fno-builtin
 obj-$(CONFIG_STACKDEPOT) += stackdepot.o
 KASAN_SANITIZE_stackdepot.o := n
 KCOV_INSTRUMENT_stackdepot.o := n
_
