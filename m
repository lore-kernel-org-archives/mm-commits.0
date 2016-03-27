From: akpm@linux-foundation.org
Subject: [merged]
 kasan-modify-kmalloc_large_oob_right-add-kmalloc_pagealloc_oob_right.patch
 removed from -mm tree
Date: Sat, 26 Mar 2016 20:31:15 -0700
Message-ID: <56f75403.ogs7aPJacsMTxFvv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbcC0DbQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 26 Mar 2016 23:31:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, adech.fo@gmail.com, cl@linux.com, dmitryc@google.com, dvyukov@google.com, iamjoonsoo.kim@lge.com, kcc@google.com, penberg@kernel.org, rientjes@google.com, rostedt@goodmis.org, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: modify kmalloc_large_oob_right(), add kmalloc_pagealloc_oob_right()
has been removed from the -mm tree.  Its filename was
     kasan-modify-kmalloc_large_oob_right-add-kmalloc_pagealloc_oob_right.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: kasan: modify kmalloc_large_oob_right(), add kmalloc_pagealloc_oob_right()

This patchset implements SLAB support for KASAN

Unlike SLUB, SLAB doesn't store allocation/deallocation stacks for heap
objects, therefore we reimplement this feature in mm/kasan/stackdepot.c. 
The intention is to ultimately switch SLUB to use this implementation as
well, which will save a lot of memory (right now SLUB bloats each object
by 256 bytes to store the allocation/deallocation stacks).

Also neither SLUB nor SLAB delay the reuse of freed memory chunks, which
is necessary for better detection of use-after-free errors.  We introduce
memory quarantine (mm/kasan/quarantine.c), which allows delayed reuse of
deallocated memory.


This patch (of 7):

Rename kmalloc_large_oob_right() to kmalloc_pagealloc_oob_right(), as the
test only checks the page allocator functionality.  Also reimplement
kmalloc_large_oob_right() so that the test allocates a large enough chunk
of memory that still does not trigger the page allocator fallback.

Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Konstantin Serebryany <kcc@google.com>
Cc: Dmitry Chernenkov <dmitryc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff -puN lib/test_kasan.c~kasan-modify-kmalloc_large_oob_right-add-kmalloc_pagealloc_oob_right lib/test_kasan.c
--- a/lib/test_kasan.c~kasan-modify-kmalloc_large_oob_right-add-kmalloc_pagealloc_oob_right
+++ a/lib/test_kasan.c
@@ -65,11 +65,34 @@ static noinline void __init kmalloc_node
 	kfree(ptr);
 }
 
-static noinline void __init kmalloc_large_oob_right(void)
+#ifdef CONFIG_SLUB
+static noinline void __init kmalloc_pagealloc_oob_right(void)
 {
 	char *ptr;
 	size_t size = KMALLOC_MAX_CACHE_SIZE + 10;
 
+	/* Allocate a chunk that does not fit into a SLUB cache to trigger
+	 * the page allocator fallback.
+	 */
+	pr_info("kmalloc pagealloc allocation: out-of-bounds to right\n");
+	ptr = kmalloc(size, GFP_KERNEL);
+	if (!ptr) {
+		pr_err("Allocation failed\n");
+		return;
+	}
+
+	ptr[size] = 0;
+	kfree(ptr);
+}
+#endif
+
+static noinline void __init kmalloc_large_oob_right(void)
+{
+	char *ptr;
+	size_t size = KMALLOC_MAX_CACHE_SIZE - 256;
+	/* Allocate a chunk that is large enough, but still fits into a slab
+	 * and does not trigger the page allocator fallback in SLUB.
+	 */
 	pr_info("kmalloc large allocation: out-of-bounds to right\n");
 	ptr = kmalloc(size, GFP_KERNEL);
 	if (!ptr) {
@@ -324,6 +347,9 @@ static int __init kmalloc_tests_init(voi
 	kmalloc_oob_right();
 	kmalloc_oob_left();
 	kmalloc_node_oob_right();
+#ifdef CONFIG_SLUB
+	kmalloc_pagealloc_oob_right();
+#endif
 	kmalloc_large_oob_right();
 	kmalloc_oob_krealloc_more();
 	kmalloc_oob_krealloc_less();
_

Patches currently in -mm which might be from glider@google.com are

mm-kasan-initial-memory-quarantine-implementation.patch
mm-kasan-initial-memory-quarantine-implementation-v8.patch

