From: akpm@linux-foundation.org
Subject: [merged] lib-test_kasan-add-some-testcases.patch removed from -mm tree
Date: Fri, 06 Nov 2015 12:17:49 -0800
Message-ID: <563d0aed.oPI2QDZTgpM3RlOx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49130 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161815AbbKFURt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:17:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: long.wanglong@huawei.com, aryabinin@virtuozzo.com, vladimir.murzin@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: test_kasan: add some testcases
has been removed from the -mm tree.  Its filename was
     lib-test_kasan-add-some-testcases.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang Long <long.wanglong@huawei.com>
Subject: lib: test_kasan: add some testcases

Add some out of bounds testcases to test_kasan module.

Signed-off-by: Wang Long <long.wanglong@huawei.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   69 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff -puN lib/test_kasan.c~lib-test_kasan-add-some-testcases lib/test_kasan.c
--- a/lib/test_kasan.c~lib-test_kasan-add-some-testcases
+++ a/lib/test_kasan.c
@@ -138,6 +138,71 @@ static noinline void __init kmalloc_oob_
 	kfree(ptr2);
 }
 
+static noinline void __init kmalloc_oob_memset_2(void)
+{
+	char *ptr;
+	size_t size = 8;
+
+	pr_info("out-of-bounds in memset2\n");
+	ptr = kmalloc(size, GFP_KERNEL);
+	if (!ptr) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	memset(ptr+7, 0, 2);
+	kfree(ptr);
+}
+
+static noinline void __init kmalloc_oob_memset_4(void)
+{
+	char *ptr;
+	size_t size = 8;
+
+	pr_info("out-of-bounds in memset4\n");
+	ptr = kmalloc(size, GFP_KERNEL);
+	if (!ptr) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	memset(ptr+5, 0, 4);
+	kfree(ptr);
+}
+
+
+static noinline void __init kmalloc_oob_memset_8(void)
+{
+	char *ptr;
+	size_t size = 8;
+
+	pr_info("out-of-bounds in memset8\n");
+	ptr = kmalloc(size, GFP_KERNEL);
+	if (!ptr) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	memset(ptr+1, 0, 8);
+	kfree(ptr);
+}
+
+static noinline void __init kmalloc_oob_memset_16(void)
+{
+	char *ptr;
+	size_t size = 16;
+
+	pr_info("out-of-bounds in memset16\n");
+	ptr = kmalloc(size, GFP_KERNEL);
+	if (!ptr) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	memset(ptr+1, 0, 16);
+	kfree(ptr);
+}
+
 static noinline void __init kmalloc_oob_in_memset(void)
 {
 	char *ptr;
@@ -264,6 +329,10 @@ static int __init kmalloc_tests_init(voi
 	kmalloc_oob_krealloc_less();
 	kmalloc_oob_16();
 	kmalloc_oob_in_memset();
+	kmalloc_oob_memset_2();
+	kmalloc_oob_memset_4();
+	kmalloc_oob_memset_8();
+	kmalloc_oob_memset_16();
 	kmalloc_uaf();
 	kmalloc_uaf_memset();
 	kmalloc_uaf2();
_

Patches currently in -mm which might be from long.wanglong@huawei.com are


