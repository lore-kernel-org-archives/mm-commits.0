From: akpm@linux-foundation.org
Subject: [folded-merged]
 lib-string_helpers-introduce-string_escape_mem-fix.patch removed from -mm
 tree
Date: Mon, 13 Oct 2014 15:41:45 -0700
Message-ID: <543c5529.r4WX1eDJ+2bKNua6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbaJMWlp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Oct 2014 18:41:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib-string_helpers-introduce-string_escape_mem-fix
has been removed from the -mm tree.  Its filename was
     lib-string_helpers-introduce-string_escape_mem-fix.patch

This patch was dropped because it was folded into lib-string_helpers-introduce-string_escape_mem.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: lib-string_helpers-introduce-string_escape_mem-fix

avoid 1k stack consumption

Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test-string_helpers.c |   37 +++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff -puN lib/test-string_helpers.c~lib-string_helpers-introduce-string_escape_mem-fix lib/test-string_helpers.c
--- a/lib/test-string_helpers.c~lib-string_helpers-introduce-string_escape_mem-fix
+++ a/lib/test-string_helpers.c
@@ -5,6 +5,7 @@
 
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/random.h>
 #include <linux/string.h>
@@ -62,10 +63,14 @@ static const struct test_string strings[
 static void __init test_string_unescape(const char *name, unsigned int flags,
 					bool inplace)
 {
-	char in[256];
-	char out_test[256];
-	char out_real[256];
-	int i, p = 0, q_test = 0, q_real = sizeof(out_real);
+	int q_real = 256;
+	char *in = kmalloc(q_real, GFP_KERNEL);
+	char *out_test = kmalloc(q_real, GFP_KERNEL);
+	char *out_real = kmalloc(q_real, GFP_KERNEL);
+	int i, p = 0, q_test = 0;
+
+	if (!in || !out_test || !out_real)
+		goto out;
 
 	for (i = 0; i < ARRAY_SIZE(strings); i++) {
 		const char *s = strings[i].in;
@@ -100,6 +105,10 @@ static void __init test_string_unescape(
 
 	test_string_check_buf(name, flags, in, p - 1, out_real, q_real,
 			      out_test, q_test);
+out:
+	kfree(out_real);
+	kfree(out_test);
+	kfree(in);
 }
 
 struct test_string_1 {
@@ -255,10 +264,15 @@ static __init void test_string_escape(co
 				      const struct test_string_2 *s2,
 				      unsigned int flags, const char *esc)
 {
-	char in[256];
-	char out_test[512];
-	char out_real[512], *buf = out_real;
-	int p = 0, q_test = 0, q_real = sizeof(out_real);
+	int q_real = 512;
+	char *out_test = kmalloc(q_real, GFP_KERNEL);
+	char *out_real = kmalloc(q_real, GFP_KERNEL);
+	char *in = kmalloc(256, GFP_KERNEL);
+	char *buf = out_real;
+	int p = 0, q_test = 0;
+
+	if (!out_test || !out_real || !in)
+		goto out;
 
 	for (; s2->in; s2++) {
 		const char *out;
@@ -289,7 +303,12 @@ static __init void test_string_escape(co
 
 	q_real = string_escape_mem(in, p, &buf, q_real, flags, esc);
 
-	test_string_check_buf(name, flags, in, p, out_real, q_real, out_test, q_test);
+	test_string_check_buf(name, flags, in, p, out_real, q_real, out_test,
+			      q_test);
+out:
+	kfree(in);
+	kfree(out_real);
+	kfree(out_test);
 }
 
 static __init void test_string_escape_nomem(void)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cma-fix-cma-bitmap-aligned-mask-computing.patch
drivers-dma-coherent-add-initialization-from-device-tree.patch
checkpatch-fix-spello.patch
checkpatch-warn-on-logging-functions-with-kern_level.patch
rtc-rk808-add-rtc-driver-for-rk808.patch
rtc-bq32000-add-trickle-charger-option-with-device-tree-binding.patch
rtc-max77686-use-ffs-to-calculate-tm_wday.patch
rtc-add-driver-for-maxim-77802-pmic-real-time-clock.patch
x86-optimize-resource-lookups-for-ioremap.patch
init-resolve-shadow-warnings.patch
arch-x86-kernel-cpu-commonc-fix-unused-symbol-warning.patch
mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable.patch
lib-string_helpers-introduce-string_escape_mem.patch
lib-vsprintf-add-%pe-format-specifier-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix.patch
wireless-hostap-proc-print-properly-escaped-ssid-fix-2.patch
watchdog-control-hard-lockup-detection-default-fix.patch

