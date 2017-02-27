From: akpm@linux-foundation.org
Subject: [merged] kasan-add-memcg-kmem_cache-test.patch removed from -mm
 tree
Date: Mon, 27 Feb 2017 12:28:15 -0800
Message-ID: <58b48bdf.SNPic21T5pllkHLS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60498 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752004AbdB0U2S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:28:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, aryabinin@virtuozzo.com, cl@linux.com, dvyukov@google.com, glider@google.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: add memcg kmem_cache test
has been removed from the -mm tree.  Its filename was
     kasan-add-memcg-kmem_cache-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Greg Thelen <gthelen@google.com>
Subject: kasan: add memcg kmem_cache test

Make a kasan test which uses a SLAB_ACCOUNT slab cache.  If the test is
run within a non default memcg, then it uncovers the bug fixed by
"kasan: drain quarantine of memcg slab objects"[1].

If run without fix [1] it shows "Slab cache still has objects", and the
kmem_cache structure is leaked.
Here's an unpatched kernel test:
$ dmesg -c > /dev/null
$ mkdir /sys/fs/cgroup/memory/test
$ echo $$ > /sys/fs/cgroup/memory/test/tasks
$ modprobe test_kasan 2> /dev/null
$ dmesg | grep -B1 still
[ 123.456789] kasan test: memcg_accounted_kmem_cache allocate memcg accounted object
[ 124.456789] kmem_cache_destroy test_cache: Slab cache still has objects

Kernels with fix [1] don't have the "Slab cache still has objects"
warning or the underlying leak.

The new test runs and passes in the default (root) memcg, though in the
root memcg it won't uncover the problem fixed by [1].

Link: http://lkml.kernel.org/r/1482257462-36948-2-git-send-email-gthelen@google.com
Signed-off-by: Greg Thelen <gthelen@google.com>
Reviewed-by: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_kasan.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff -puN lib/test_kasan.c~kasan-add-memcg-kmem_cache-test lib/test_kasan.c
--- a/lib/test_kasan.c~kasan-add-memcg-kmem_cache-test
+++ a/lib/test_kasan.c
@@ -11,6 +11,7 @@
 
 #define pr_fmt(fmt) "kasan test: %s " fmt, __func__
 
+#include <linux/delay.h>
 #include <linux/kernel.h>
 #include <linux/mman.h>
 #include <linux/mm.h>
@@ -331,6 +332,38 @@ static noinline void __init kmem_cache_o
 	kmem_cache_destroy(cache);
 }
 
+static noinline void __init memcg_accounted_kmem_cache(void)
+{
+	int i;
+	char *p;
+	size_t size = 200;
+	struct kmem_cache *cache;
+
+	cache = kmem_cache_create("test_cache", size, 0, SLAB_ACCOUNT, NULL);
+	if (!cache) {
+		pr_err("Cache allocation failed\n");
+		return;
+	}
+
+	pr_info("allocate memcg accounted object\n");
+	/*
+	 * Several allocations with a delay to allow for lazy per memcg kmem
+	 * cache creation.
+	 */
+	for (i = 0; i < 5; i++) {
+		p = kmem_cache_alloc(cache, GFP_KERNEL);
+		if (!p) {
+			pr_err("Allocation failed\n");
+			goto free_cache;
+		}
+		kmem_cache_free(cache, p);
+		msleep(100);
+	}
+
+free_cache:
+	kmem_cache_destroy(cache);
+}
+
 static char global_array[10];
 
 static noinline void __init kasan_global_oob(void)
@@ -460,6 +493,7 @@ static int __init kmalloc_tests_init(voi
 	kmalloc_uaf_memset();
 	kmalloc_uaf2();
 	kmem_cache_oob();
+	memcg_accounted_kmem_cache();
 	kasan_stack_oob();
 	kasan_global_oob();
 	ksize_unpoisons_memory();
_

Patches currently in -mm which might be from gthelen@google.com are


