From: akpm@linux-foundation.org
Subject: + mm-remove-rodata_test_data-export-add-pr_fmt.patch added to -mm tree
Date: Tue, 07 Mar 2017 14:57:17 -0800
Message-ID: <58bf3acd.Ps9ZjPfO5C4t2UVX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44008 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756314AbdCGXGg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2017 18:06:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: keescook@chromium.org, arjan@linux.intel.com, jinb.park7@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove rodata_test_data export, add pr_fmt
has been added to the -mm tree.  Its filename is
     mm-remove-rodata_test_data-export-add-pr_fmt.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-rodata_test_data-export-add-pr_fmt.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-rodata_test_data-export-add-pr_fmt.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Signed-off-by: Andrew Morton <>
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

Patches currently in -mm which might be from keescook@chromium.org are

mm-remove-rodata_test_data-export-add-pr_fmt.patch

