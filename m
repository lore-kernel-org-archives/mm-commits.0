From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 113/155] kasan: add test for invalid size in
 memmove
Date: Wed, 01 Apr 2020 21:09:40 -0700
Message-ID: <20200402040940.YMfv5iTTH%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgDBEJm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:09:42 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, linux-mm@kvack.org, lkp@intel.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org, walter-zh.wu@mediatek.com

From: Walter Wu <walter-zh.wu@mediatek.com>
Subject: kasan: add test for invalid size in memmove

Test negative size in memmove in order to verify whether it correctly get
KASAN report.

Casting negative numbers to size_t would indeed turn up as a large size_t,
so it will have out-of-bounds bug and be detected by KASAN.

[walter-zh.wu@mediatek.com: fix -Wstringop-overflow warning]
  Link: http://lkml.kernel.org/r/20200311134244.13016-1-walter-zh.wu@mediatek.com
Link: http://lkml.kernel.org/r/20191112065313.7060-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/lib/test_kasan.c~kasan-add-test-for-invalid-size-in-memmove
+++ a/lib/test_kasan.c
@@ -285,6 +285,24 @@ static noinline void __init kmalloc_oob_
 	kfree(ptr);
 }
 
+static noinline void __init kmalloc_memmove_invalid_size(void)
+{
+	char *ptr;
+	size_t size = 64;
+	volatile size_t invalid_size = -2;
+
+	pr_info("invalid size in memmove\n");
+	ptr = kmalloc(size, GFP_KERNEL);
+	if (!ptr) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	memset((char *)ptr, 0, 64);
+	memmove((char *)ptr, (char *)ptr + 4, invalid_size);
+	kfree(ptr);
+}
+
 static noinline void __init kmalloc_uaf(void)
 {
 	char *ptr;
@@ -799,6 +817,7 @@ static int __init kmalloc_tests_init(voi
 	kmalloc_oob_memset_4();
 	kmalloc_oob_memset_8();
 	kmalloc_oob_memset_16();
+	kmalloc_memmove_invalid_size();
 	kmalloc_uaf();
 	kmalloc_uaf_memset();
 	kmalloc_uaf2();
_
