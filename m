From: akpm@linux-foundation.org
Subject: [patch 039/102] mm: remove rodata_test_data export, add
 pr_fmt
Date: Wed, 03 May 2017 14:53:32 -0700
Message-ID: <20170503215332.tD-bDRWmZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48318 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbdECVxp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:53:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arjan@linux.intel.com, jinb.park7@gmail.com, keescook@chromium.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Kees Cook <keescook@chromium.org>
Subject: mm: remove rodata_test_data export, add pr_fmt

Since commit 3ad38ceb2769 ("x86/mm: Remove CONFIG_DEBUG_NX_TEST"), nothing
is using the exported rodata_test_data variable, so drop the export. 
Additionally updates the pr_fmt to avoid redundant strings and adjusts
some whitespace.

Link: http://lkml.kernel.org/r/20170307005313.GA85809@beast
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: Jinbum Park <jinb.park7@gmail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rodata_test.h |    1 -
 mm/rodata_test.c            |   17 +++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN include/linux/rodata_test.h~mm-remove-rodata_test_data-export-add-pr_fmt include/linux/rodata_test.h
--- a/include/linux/rodata_test.h~mm-remove-rodata_test_data-export-add-pr_fmt
+++ a/include/linux/rodata_test.h
@@ -14,7 +14,6 @@
 #define _RODATA_TEST_H
 
 #ifdef CONFIG_DEBUG_RODATA_TEST
-extern const int rodata_test_data;
 void rodata_test(void);
 #else
 static inline void rodata_test(void) {}
diff -puN mm/rodata_test.c~mm-remove-rodata_test_data-export-add-pr_fmt mm/rodata_test.c
--- a/mm/rodata_test.c~mm-remove-rodata_test_data-export-add-pr_fmt
+++ a/mm/rodata_test.c
@@ -9,11 +9,12 @@
  * as published by the Free Software Foundation; version 2
  * of the License.
  */
+#define pr_fmt(fmt) "rodata_test: " fmt
+
 #include <linux/uaccess.h>
 #include <asm/sections.h>
 
 const int rodata_test_data = 0xC3;
-EXPORT_SYMBOL_GPL(rodata_test_data);
 
 void rodata_test(void)
 {
@@ -23,20 +24,20 @@ void rodata_test(void)
 	/* test 1: read the value */
 	/* If this test fails, some previous testrun has clobbered the state */
 	if (!rodata_test_data) {
-		pr_err("rodata_test: test 1 fails (start data)\n");
+		pr_err("test 1 fails (start data)\n");
 		return;
 	}
 
 	/* test 2: write to the variable; this should fault */
 	if (!probe_kernel_write((void *)&rodata_test_data,
-						(void *)&zero, sizeof(zero))) {
-		pr_err("rodata_test: test data was not read only\n");
+				(void *)&zero, sizeof(zero))) {
+		pr_err("test data was not read only\n");
 		return;
 	}
 
 	/* test 3: check the value hasn't changed */
 	if (rodata_test_data == zero) {
-		pr_err("rodata_test: test data was changed\n");
+		pr_err("test data was changed\n");
 		return;
 	}
 
@@ -44,13 +45,13 @@ void rodata_test(void)
 	start = (unsigned long)__start_rodata;
 	end = (unsigned long)__end_rodata;
 	if (start & (PAGE_SIZE - 1)) {
-		pr_err("rodata_test: start of .rodata is not page size aligned\n");
+		pr_err("start of .rodata is not page size aligned\n");
 		return;
 	}
 	if (end & (PAGE_SIZE - 1)) {
-		pr_err("rodata_test: end of .rodata is not page size aligned\n");
+		pr_err("end of .rodata is not page size aligned\n");
 		return;
 	}
 
-	pr_info("rodata_test: all tests were successful\n");
+	pr_info("all tests were successful\n");
 }
_
