From: akpm@linux-foundation.org
Subject: + lib-test_kasan-add-some-testcases.patch added to -mm tree
Date: Mon, 14 Sep 2015 15:06:48 -0700
Message-ID: <55f744f8.jCefrT1bkjTpKHsO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52401 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbbINWGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Sep 2015 18:06:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: long.wanglong@huawei.com, aryabinin@virtuozzo.com, vladimir.murzin@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: test_kasan: add some testcases
has been added to the -mm tree.  Its filename is
     lib-test_kasan-add-some-testcases.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-test_kasan-add-some-testcases.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-test_kasan-add-some-testcases.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

lib-test_kasan-add-some-testcases.patch
kasan-fix-a-type-conversion-error.patch

