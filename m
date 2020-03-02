From: akpm@linux-foundation.org
Subject: + kasan-add-test-for-invalid-size-in-memmove.patch added
 to -mm tree
Date: Mon, 02 Mar 2020 14:37:40 -0800
Message-ID: <20200302223740.urlYZFUzG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbgCBWhl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 2 Mar 2020 17:37:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, lkp@intel.com, mm-commits@vger.kernel.org, walter-zh.wu@mediatek.com


The patch titled
     Subject: kasan: add test for invalid size in memmove
has been added to the -mm tree.  Its filename is
     kasan-add-test-for-invalid-size-in-memmove.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-add-test-for-invalid-size-in-memmove.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-add-test-for-invalid-size-in-memmove.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Walter Wu <walter-zh.wu@mediatek.com>
Subject: kasan: add test for invalid size in memmove

Test negative size in memmove in order to verify whether it correctly get
KASAN report.

Casting negative numbers to size_t would indeed turn up as a large size_t,
so it will have out-of-bounds bug and be detected by KASAN.

Link: http://lkml.kernel.org/r/20191112065313.7060-1-walter-zh.wu@mediatek.com
Signed-off-by: Walter Wu <walter-zh.wu@mediatek.com>
Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: kernel test robot <lkp@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/lib/test_kasan.c~kasan-add-test-for-invalid-size-in-memmove
+++ a/lib/test_kasan.c
@@ -285,6 +285,23 @@ static noinline void __init kmalloc_oob_
 	kfree(ptr);
 }
 
+static noinline void __init kmalloc_memmove_invalid_size(void)
+{
+	char *ptr;
+	size_t size = 64;
+
+	pr_info("invalid size in memmove\n");
+	ptr = kmalloc(size, GFP_KERNEL);
+	if (!ptr) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	memset((char *)ptr, 0, 64);
+	memmove((char *)ptr, (char *)ptr + 4, -2);
+	kfree(ptr);
+}
+
 static noinline void __init kmalloc_uaf(void)
 {
 	char *ptr;
@@ -799,6 +816,7 @@ static int __init kmalloc_tests_init(voi
 	kmalloc_oob_memset_4();
 	kmalloc_oob_memset_8();
 	kmalloc_oob_memset_16();
+	kmalloc_memmove_invalid_size();
 	kmalloc_uaf();
 	kmalloc_uaf_memset();
 	kmalloc_uaf2();
_

Patches currently in -mm which might be from walter-zh.wu@mediatek.com are

kasan-detect-negative-size-in-memory-operation-function.patch
kasan-add-test-for-invalid-size-in-memmove.patch
