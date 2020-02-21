From: akpm@linux-foundation.org
Subject: + stackdepot-build-with-fno-builtin.patch added to -mm tree
Date: Thu, 20 Feb 2020 16:44:09 -0800
Message-ID: <20200221004409.T4k60%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729419AbgBUAoK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Feb 2020 19:44:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vegard.nossum@oracle.com, sergey.senozhatsky@gmail.com, elver@google.com, dvyukov@google.com, aryabinin@virtuozzo.com, arnd@arndb.de, andreyknvl@google.com, glider@google.com


The patch titled
     Subject: lib/stackdepot.c: build with -fno-builtin
has been added to the -mm tree.  Its filename is
     stackdepot-build-with-fno-builtin.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/stackdepot-build-with-fno-builtin.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/stackdepot-build-with-fno-builtin.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -222,6 +222,10 @@ obj-$(CONFIG_MEMREGION) += memregion.o
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

lib-stackdepot-fix-global-out-of-bounds-in-stack_slabs.patch
stackdepot-check-depot_index-before-accessing-the-stack-slab.patch
stackdepot-build-with-fno-builtin.patch
kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc.patch
