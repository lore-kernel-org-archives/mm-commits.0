From: akpm@linux-foundation.org
Subject: + lib-add-config_test_sort-to-enable-self-test-of-sort.patch
 added to -mm tree
Date: Mon, 09 Jan 2017 15:25:01 -0800
Message-ID: <58741bcd.SSmdC8XgCY0AFUsl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45952 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942519AbdAIXXe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jan 2017 18:23:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fkostenzer@live.at, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: add CONFIG_TEST_SORT to enable self-test of sort()
has been added to the -mm tree.  Its filename is
     lib-add-config_test_sort-to-enable-self-test-of-sort.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-add-config_test_sort-to-enable-self-test-of-sort.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-add-config_test_sort-to-enable-self-test-of-sort.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kostenzer Felix <fkostenzer@live.at>
Subject: lib: add CONFIG_TEST_SORT to enable self-test of sort()

Along with the addition made to Kconfig.debug, the prior existing but
permanently disabled test function has been slightly refactored.

Patch has been tested using QEMU 2.1.2 with a .config obtained through
'make defconfig' (x86_64) and manually enabling the option.

Link: http://lkml.kernel.org/r/HE1PR09MB0394B0418D504DCD27167D4FD49B0@HE1PR09MB0394.eurprd09.prod.outlook.com
Signed-off-by: Kostenzer Felix <fkostenzer@live.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    8 ++++++++
 lib/sort.c        |   41 ++++++++++++++++++++++++-----------------
 2 files changed, 32 insertions(+), 17 deletions(-)

diff -puN lib/Kconfig.debug~lib-add-config_test_sort-to-enable-self-test-of-sort lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-add-config_test_sort-to-enable-self-test-of-sort
+++ a/lib/Kconfig.debug
@@ -1714,6 +1714,14 @@ config TEST_LIST_SORT
 
 	  If unsure, say N.
 
+config TEST_SORT
+	bool "Array-based sort test"
+	depends on DEBUG_KERNEL
+	help
+	  This option enables the self-test function of 'sort()' at boot.
+
+	  If unsure, say N.
+
 config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
 	depends on DEBUG_KERNEL
diff -puN lib/sort.c~lib-add-config_test_sort-to-enable-self-test-of-sort lib/sort.c
--- a/lib/sort.c~lib-add-config_test_sort-to-enable-self-test-of-sort
+++ a/lib/sort.c
@@ -4,6 +4,8 @@
  * Jan 23 2005  Matt Mackall <mpm@selenic.com>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/types.h>
 #include <linux/export.h>
 #include <linux/sort.h>
@@ -102,41 +104,46 @@ void sort(void *base, size_t num, size_t
 
 EXPORT_SYMBOL(sort);
 
-#if 0
+#ifdef CONFIG_TEST_SORT
 #include <linux/slab.h>
+#include <linux/module.h>
 /* a simple boot-time regression test */
 
-int cmpint(const void *a, const void *b)
+#define TEST_LEN 1000
+
+static int __init cmpint(const void *a, const void *b)
 {
 	return *(int *)a - *(int *)b;
 }
 
-static int sort_test(void)
+static int __init test_sort_init(void)
 {
-	int *a, i, r = 1;
-
-	a = kmalloc(1000 * sizeof(int), GFP_KERNEL);
-	BUG_ON(!a);
+	int *a, i, r = 1, err = -ENOMEM;
 
-	printk("testing sort()\n");
+	a = kmalloc_array(TEST_LEN, sizeof(*a), GFP_KERNEL);
+	if (!a)
+		return err;
 
-	for (i = 0; i < 1000; i++) {
+	for (i = 0; i < TEST_LEN; i++) {
 		r = (r * 725861) % 6599;
 		a[i] = r;
 	}
 
-	sort(a, 1000, sizeof(int), cmpint, NULL);
+	sort(a, TEST_LEN, sizeof(*a), cmpint, NULL);
 
-	for (i = 0; i < 999; i++)
+	err = -EINVAL;
+	for (i = 0; i < TEST_LEN-1; i++)
 		if (a[i] > a[i+1]) {
-			printk("sort() failed!\n");
-			break;
+			pr_err("test has failed\n");
+			goto exit;
 		}
-
+	err = 0;
+	pr_info("test passed\n");
+exit:
 	kfree(a);
