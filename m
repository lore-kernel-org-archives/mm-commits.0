From: akpm@linux-foundation.org
Subject: [merged] mm-kasan-add-a-ksize-test.patch removed from -mm tree
Date: Mon, 23 May 2016 12:47:24 -0700
Message-ID: <57435e4c.Uytmu8e5dH5t3S7D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbcEWTrZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 15:47:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, adech.fo@gmail.com, aryabinin@virtuozzo.com, cl@linux.com, dvyukov@google.com, kcc@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, kasan: add a ksize() test
has been removed from the -mm tree.  Its filename was
     mm-kasan-add-a-ksize-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from glider@google.com are


