From: akpm@linux-foundation.org
Subject: [patch 059/162] mm, kasan: add a ksize() test
Date: Fri, 20 May 2016 16:59:17 -0700
Message-ID: <573fa4d5.FGEmt1n443GbTbez%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbcETX7S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:59:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, glider@google.com, adech.fo@gmail.com, aryabinin@virtuozzo.com, cl@linux.com, dvyukov@google.com, kcc@google.com

From: Alexander Potapenko <glider@google.com>
Subject: mm, kasan: add a ksize() test

Add a test that makes sure ksize() unpoisons the whole chunk.

Signed-off-by: Alexander Potapenko <glider@google.com>
Acked-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Konstantin Serebryany <kcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN lib/test_kasan.c~mm-kasan-add-a-ksize-test lib/test_kasan.c
--- a/lib/test_kasan.c~mm-kasan-add-a-ksize-test
+++ a/lib/test_kasan.c
@@ -344,6 +344,25 @@ static noinline void __init kasan_stack_
 	*(volatile char *)p;
 }
 
+static noinline void __init ksize_unpoisons_memory(void)
+{
+	char *ptr;
+	size_t size = 123, real_size = size;
+
+	pr_info("ksize() unpoisons the whole allocated chunk\n");
+	ptr = kmalloc(size, GFP_KERNEL);
+	if (!ptr) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+	real_size = ksize(ptr);
+	/* This access doesn't trigger an error. */
+	ptr[size] = 'x';
+	/* This one does. */
+	ptr[real_size] = 'y';
+	kfree(ptr);
+}
+
 static int __init kmalloc_tests_init(void)
 {
 	kmalloc_oob_right();
@@ -367,6 +386,7 @@ static int __init kmalloc_tests_init(voi
 	kmem_cache_oob();
 	kasan_stack_oob();
 	kasan_global_oob();
+	ksize_unpoisons_memory();
 	return -EAGAIN;
 }
 
_
