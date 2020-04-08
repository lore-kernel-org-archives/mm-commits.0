From: akpm@linux-foundation.org
Subject: [merged] stackdepot-build-with-fno-builtin.patch removed
 from -mm tree
Date: Tue, 07 Apr 2020 19:01:07 -0700
Message-ID: <20200408020107.HpOnu_rtS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbgDHCBI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 22:01:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, arnd@arndb.de, aryabinin@virtuozzo.com, dvyukov@google.com, elver@google.com, glider@google.com, mm-commits@vger.kernel.org, sergey.senozhatsky@gmail.com, vegard.nossum@oracle.com


The patch titled
     Subject: lib/stackdepot.c: build with -fno-builtin
has been removed from the -mm tree.  Its filename was
     stackdepot-build-with-fno-builtin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from glider@google.com are
