From: akpm@linux-foundation.org
Subject: + mm-kasan-add-a-ksize-test.patch added to -mm tree
Date: Fri, 22 Apr 2016 14:34:21 -0700
Message-ID: <571a98dd.fz6SXSZrmDyqSF4a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35874 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbcDVVeW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Apr 2016 17:34:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, adech.fo@gmail.com, cl@linux.com, dvyukov@google.com, kcc@google.com, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, kasan: add a ksize() test
has been added to the -mm tree.  Its filename is
     mm-kasan-add-a-ksize-test.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-add-a-ksize-test.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-add-a-ksize-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: mm, kasan: add a ksize() test

Add a test that makes sure ksize() unpoisons the whole chunk.

Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Konstantin Serebryany <kcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -puN lib/test_kasan.c~mm-kasan-add-a-ksize-test lib/test_kasan.c
--- a/lib/test_kasan.c~mm-kasan-add-a-ksize-test
+++ a/lib/test_kasan.c
@@ -370,6 +370,25 @@ static noinline void __init kasan_quaran
 }
 #endif
 
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
@@ -396,6 +415,7 @@ static int __init kmalloc_tests_init(voi
 #ifdef CONFIG_SLAB
 	kasan_quarantine_cache();
 #endif
+	ksize_unpoisons_memory();
 	return -EAGAIN;
 }
 
_

Patches currently in -mm which might be from glider@google.com are

lib-stackdepotc-allow-the-stack-trace-hash-to-be-zero.patch
mm-kasan-initial-memory-quarantine-implementation.patch
mm-kasan-initial-memory-quarantine-implementation-v8.patch
mm-kasan-dont-call-kasan_krealloc-from-ksize.patch
mm-kasan-add-a-ksize-test.patch

