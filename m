From: akpm@linux-foundation.org
Subject: [patch 08/11] kasan: report only the first error by default
Date: Fri, 31 Mar 2017 15:12:04 -0700
Message-ID: <58ded434.erWQ7/J27QlX/Lfd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41732 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933149AbdCaWMF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 31 Mar 2017 18:12:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mark.rutland@arm.com, andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com

From: Mark Rutland <mark.rutland@arm.com>
Subject: kasan: report only the first error by default

Disable kasan after the first report. There are several reasons for this:

- Single bug quite often has multiple invalid memory accesses causing
  storm in the dmesg.

- Write OOB access might corrupt metadata so the next report will print
  bogus alloc/free stacktraces.

- Reports after the first easily could be not bugs by itself but just
  side effects of the first one.

Given that multiple reports usually only do harm, it makes sense to
disable kasan after the first one.  If user wants to see all the reports,
the boot-time parameter kasan_multi_shot must be used.

[aryabinin@virtuozzo.com: wrote changelog and doc, added missing include]
Link: http://lkml.kernel.org/r/20170323154416.30257-1-aryabinin@virtuozzo.com
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |    6 ++
 include/linux/kasan.h                           |    3 +
 lib/test_kasan.c                                |   10 +++
 mm/kasan/kasan.h                                |    5 -
 mm/kasan/report.c                               |   36 ++++++++++++++
 5 files changed, 55 insertions(+), 5 deletions(-)

diff -puN Documentation/admin-guide/kernel-parameters.txt~kasan-report-only-the-first-error-by-default Documentation/admin-guide/kernel-parameters.txt
--- a/Documentation/admin-guide/kernel-parameters.txt~kasan-report-only-the-first-error-by-default
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1725,6 +1725,12 @@
 			kernel and module base offset ASLR (Address Space
 			Layout Randomization).
 
+	kasan_multi_shot
+			[KNL] Enforce KASAN (Kernel Address Sanitizer) to print
+			report on every invalid memory access. Without this
+			parameter KASAN will print report only for the first
+			invalid access.
+
 	keepinitrd	[HW,ARM]
 
 	kernelcore=	[KNL,X86,IA-64,PPC]
diff -puN include/linux/kasan.h~kasan-report-only-the-first-error-by-default include/linux/kasan.h
--- a/include/linux/kasan.h~kasan-report-only-the-first-error-by-default
+++ a/include/linux/kasan.h
@@ -76,6 +76,9 @@ size_t ksize(const void *);
 static inline void kasan_unpoison_slab(const void *ptr) { ksize(ptr); }
 size_t kasan_metadata_size(struct kmem_cache *cache);
 
+bool kasan_save_enable_multi_shot(void);
+void kasan_restore_multi_shot(bool enabled);
+
 #else /* CONFIG_KASAN */
 
 static inline void kasan_unpoison_shadow(const void *address, size_t size) {}
diff -puN lib/test_kasan.c~kasan-report-only-the-first-error-by-default lib/test_kasan.c
--- a/lib/test_kasan.c~kasan-report-only-the-first-error-by-default
+++ a/lib/test_kasan.c
@@ -20,6 +20,7 @@
 #include <linux/string.h>
 #include <linux/uaccess.h>
 #include <linux/module.h>
+#include <linux/kasan.h>
 
 /*
  * Note: test functions are marked noinline so that their names appear in
@@ -474,6 +475,12 @@ static noinline void __init use_after_sc
 
 static int __init kmalloc_tests_init(void)
 {
+	/*
+	 * Temporarily enable multi-shot mode. Otherwise, we'd only get a
+	 * report for the first case.
+	 */
+	bool multishot = kasan_save_enable_multi_shot();
+
 	kmalloc_oob_right();
 	kmalloc_oob_left();
 	kmalloc_node_oob_right();
@@ -499,6 +506,9 @@ static int __init kmalloc_tests_init(voi
 	ksize_unpoisons_memory();
 	copy_user_test();
 	use_after_scope_test();
+
+	kasan_restore_multi_shot(multishot);
+
 	return -EAGAIN;
 }
 
diff -puN mm/kasan/kasan.h~kasan-report-only-the-first-error-by-default mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~kasan-report-only-the-first-error-by-default
+++ a/mm/kasan/kasan.h
@@ -96,11 +96,6 @@ static inline const void *kasan_shadow_t
 		<< KASAN_SHADOW_SCALE_SHIFT);
 }
 
-static inline bool kasan_report_enabled(void)
-{
-	return !current->kasan_depth;
-}
-
 void kasan_report(unsigned long addr, size_t size,
 		bool is_write, unsigned long ip);
 void kasan_report_double_free(struct kmem_cache *cache, void *object,
diff -puN mm/kasan/report.c~kasan-report-only-the-first-error-by-default mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-report-only-the-first-error-by-default
+++ a/mm/kasan/report.c
@@ -13,7 +13,9 @@
  *
  */
 
+#include <linux/bitops.h>
 #include <linux/ftrace.h>
+#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/printk.h>
@@ -293,6 +295,40 @@ static void kasan_report_error(struct ka
 	kasan_end_report(&flags);
 }
 
+static unsigned long kasan_flags;
+
+#define KASAN_BIT_REPORTED	0
+#define KASAN_BIT_MULTI_SHOT	1
+
+bool kasan_save_enable_multi_shot(void)
+{
+	return test_and_set_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags);
+}
+EXPORT_SYMBOL_GPL(kasan_save_enable_multi_shot);
+
+void kasan_restore_multi_shot(bool enabled)
+{
+	if (!enabled)
+		clear_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags);
+}
+EXPORT_SYMBOL_GPL(kasan_restore_multi_shot);
+
+static int __init kasan_set_multi_shot(char *str)
+{
+	set_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags);
+	return 1;
+}
+__setup("kasan_multi_shot", kasan_set_multi_shot);
+
+static inline bool kasan_report_enabled(void)
+{
+	if (current->kasan_depth)
+		return false;
+	if (test_bit(KASAN_BIT_MULTI_SHOT, &kasan_flags))
+		return true;
+	return !test_and_set_bit(KASAN_BIT_REPORTED, &kasan_flags);
+}
+
 void kasan_report(unsigned long addr, size_t size,
 		bool is_write, unsigned long ip)
 {
_
