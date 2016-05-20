From: akpm@linux-foundation.org
Subject: [patch 061/162] mm/kasan: add API to check memory regions
Date: Fri, 20 May 2016 16:59:28 -0700
Message-ID: <573fa4e0.pOGLw4jQheKsj8Th%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbcETX73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:59:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de

From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm/kasan: add API to check memory regions

Memory access coded in an assembly won't be seen by KASAN as a compiler
can instrument only C code.  Add kasan_check_[read,write]() API which is
going to be used to check a certain memory range.

Link: http://lkml.kernel.org/r/1462538722-1574-3-git-send-email-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Acked-by: Alexander Potapenko <glider@google.com>
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
@@ -6242,7 +6242,7 @@ S:	Maintained
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
