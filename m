From: akpm@linux-foundation.org
Subject: + mm-kasan-add-api-to-check-memory-regions.patch added to -mm
 tree
Date: Fri, 06 May 2016 15:48:25 -0700
Message-ID: <572d1f39.OgyZFA9t5eegIZeE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55218 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759200AbcEFWs0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 May 2016 18:48:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan: add API to check memory regions
has been added to the -mm tree.  Its filename is
     mm-kasan-add-api-to-check-memory-regions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-add-api-to-check-memory-regions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-add-api-to-check-memory-regions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm/kasan: add API to check memory regions

Memory access coded in an assembly won't be seen by KASAN as a compiler
can instrument only C code.  Add kasan_check_[read,write]() API which is
going to be used to check a certain memory range.

Link: http://lkml.kernel.org/r/1462538722-1574-3-git-send-email-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS                  |    2 +-
 include/linux/kasan-checks.h |   12 ++++++++++++
 mm/kasan/kasan.c             |   12 ++++++++++++
 3 files changed, 25 insertions(+), 1 deletion(-)

diff -puN MAINTAINERS~mm-kasan-add-api-to-check-memory-regions MAINTAINERS
--- a/MAINTAINERS~mm-kasan-add-api-to-check-memory-regions
+++ a/MAINTAINERS
@@ -6175,7 +6175,7 @@ S:	Maintained
 F:	arch/*/include/asm/kasan.h
 F:	arch/*/mm/kasan_init*
 F:	Documentation/kasan.txt
-F:	include/linux/kasan.h
+F:	include/linux/kasan*.h
 F:	lib/test_kasan.c
 F:	mm/kasan/
 F:	scripts/Makefile.kasan
diff -puN /dev/null include/linux/kasan-checks.h
--- /dev/null
+++ a/include/linux/kasan-checks.h
@@ -0,0 +1,12 @@
+#ifndef _LINUX_KASAN_CHECKS_H
+#define _LINUX_KASAN_CHECKS_H
+
+#ifdef CONFIG_KASAN
+void kasan_check_read(const void *p, unsigned int size);
+void kasan_check_write(const void *p, unsigned int size);
+#else
+static inline void kasan_check_read(const void *p, unsigned int size) { }
+static inline void kasan_check_write(const void *p, unsigned int size) { }
+#endif
+
+#endif
diff -puN mm/kasan/kasan.c~mm-kasan-add-api-to-check-memory-regions mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-kasan-add-api-to-check-memory-regions
+++ a/mm/kasan/kasan.c
@@ -299,6 +299,18 @@ static void check_memory_region(unsigned
 	check_memory_region_inline(addr, size, write, ret_ip);
 }
 
+void kasan_check_read(const void *p, unsigned int size)
+{
+	check_memory_region((unsigned long)p, size, false, _RET_IP_);
+}
+EXPORT_SYMBOL(kasan_check_read);
+
+void kasan_check_write(const void *p, unsigned int size)
+{
+	check_memory_region((unsigned long)p, size, true, _RET_IP_);
+}
+EXPORT_SYMBOL(kasan_check_write);
+
 #undef memset
 void *memset(void *addr, int c, size_t len)
 {
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-kasan-print-name-of-mem-caller-in-report.patch
mm-kasan-add-api-to-check-memory-regions.patch
x86-kasan-instrument-user-memory-access-api.patch
kasan-tests-add-tests-for-user-memory-access-functions.patch

