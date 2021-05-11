Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D943AC433ED
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 21:59:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CA94616E9
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 21:59:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhEKWAl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 May 2021 18:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229736AbhEKWAk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 May 2021 18:00:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33A4C6187E;
        Tue, 11 May 2021 21:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620770372;
        bh=0FT5oPhMQxBTX1BU1OeWKKl7/S/e2TMPyNCLw57bvg8=;
        h=Date:From:To:Subject:From;
        b=eTuX3rpACIh1QXo0w9utho+fhQeCE1VUGPhfQgOxOvyLaDiEGW/wCfLKXcIKEPK0G
         PS+QrG1TCFravBe6HJADppMrmxErtvgdotnzuqXTniA5SE6JyInH66dnHr1kWW5egQ
         fpqtL8G1kE5Ic6IEWbrniU+cx9SThrGjItxtFPx4=
Date:   Tue, 11 May 2021 14:59:31 -0700
From:   akpm@linux-foundation.org
To:     brendanhiggins@google.com, cl@linux.com, dlatypov@google.com,
        elver@google.com, glittao@gmail.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  +
 mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality.patch added
 to -mm tree
Message-ID: <20210511215931.WmqRoQpN2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub, kunit: add a KUnit test for SLUB debugging functionality
has been added to the -mm tree.  Its filename is
     mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oliver Glitta <glittao@gmail.com>
Subject: mm/slub, kunit: add a KUnit test for SLUB debugging functionality

SLUB has resiliency_test() function which is hidden behind #ifdef
SLUB_RESILIENCY_TEST that is not part of Kconfig, so nobody runs it. 
KUnit should be a proper replacement for it.

Try changing byte in redzone after allocation and changing pointer to next
free node, first byte, 50th byte and redzone byte.  Check if validation
finds errors.

There are several differences from the original resiliency test: Tests
create own caches with known state instead of corrupting shared kmalloc
caches.

The corruption of freepointer uses correct offset, the original resiliency
test got broken with freepointer changes.

Scratch changing random byte test, because it does not have meaning in
this form where we need deterministic results.

Add new option CONFIG_SLUB_KUNIT_TEST in Kconfig.  Tests next_pointer,
first_word and clobber_50th_byte do not run with KASAN option on.  Because
the test deliberately modifies non-allocated objects.

Use kunit_resource to count errors in cache and silence bug reports. 
Count error whenever slab_bug() or slab_fix() is called or when the count
of pages is wrong.

Link: https://lkml.kernel.org/r/20210511150734.3492-2-glittao@gmail.com
Signed-off-by: Oliver Glitta <glittao@gmail.com>
Cc: Brendan Higgins <brendanhiggins@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Latypov <dlatypov@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Marco Elver <elver@google.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |   12 +++
 lib/Makefile      |    1 
 lib/slub_kunit.c  |  155 ++++++++++++++++++++++++++++++++++++++++++++
 mm/slab.h         |    1 
 mm/slub.c         |   46 ++++++++++++-
 5 files changed, 212 insertions(+), 3 deletions(-)

--- a/lib/Kconfig.debug~mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality
+++ a/lib/Kconfig.debug
@@ -2429,6 +2429,18 @@ config BITS_TEST
 
 	  If unsure, say N.
 
+config SLUB_KUNIT_TEST
+	tristate "KUnit test for SLUB cache error detection" if !KUNIT_ALL_TESTS
+	depends on SLUB_DEBUG && KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  This builds SLUB allocator unit test.
+	  Tests SLUB cache debugging functionality.
+	  For more information on KUnit and unit tests in general please refer
+	  to the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  If unsure, say N.
+
 config TEST_UDELAY
 	tristate "udelay test driver"
 	help
--- a/lib/Makefile~mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality
+++ a/lib/Makefile
@@ -353,5 +353,6 @@ obj-$(CONFIG_LIST_KUNIT_TEST) += list-te
 obj-$(CONFIG_LINEAR_RANGES_TEST) += test_linear_ranges.o
 obj-$(CONFIG_BITS_TEST) += test_bits.o
 obj-$(CONFIG_CMDLINE_KUNIT_TEST) += cmdline_kunit.o
+obj-$(CONFIG_SLUB_KUNIT_TEST) += slub_kunit.o
 
 obj-$(CONFIG_GENERIC_LIB_DEVMEM_IS_ALLOWED) += devmem_is_allowed.o
--- /dev/null
+++ a/lib/slub_kunit.c
@@ -0,0 +1,155 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <kunit/test.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include "../mm/slab.h"
+
+static struct kunit_resource resource;
+static int slab_errors;
+
+static void test_clobber_zone(struct kunit *test)
+{
+	struct kmem_cache *s = kmem_cache_create("TestSlub_RZ_alloc", 64, 0,
+				SLAB_RED_ZONE, NULL);
+	u8 *p = kmem_cache_alloc(s, GFP_KERNEL);
+
+	kasan_disable_current();
+	p[64] = 0x12;
+
+	validate_slab_cache(s);
+	KUNIT_EXPECT_EQ(test, 2, slab_errors);
+
+	kasan_enable_current();
+	kmem_cache_free(s, p);
+	kmem_cache_destroy(s);
+}
+
+#ifndef CONFIG_KASAN
+static void test_next_pointer(struct kunit *test)
+{
+	struct kmem_cache *s = kmem_cache_create("TestSlub_next_ptr_free", 64, 0,
+				SLAB_POISON, NULL);
+	u8 *p = kmem_cache_alloc(s, GFP_KERNEL);
+	unsigned long tmp;
+	unsigned long *ptr_addr;
+
+	kmem_cache_free(s, p);
+
+	ptr_addr = (unsigned long *)(p + s->offset);
+	tmp = *ptr_addr;
+	p[s->offset] = 0x12;
+
+	/*
+	 * Expecting three errors.
+	 * One for the corrupted freechain and the other one for the wrong
+	 * count of objects in use. The third error is fixing broken cache.
+	 */
+	validate_slab_cache(s);
+	KUNIT_EXPECT_EQ(test, 3, slab_errors);
+
+	/*
+	 * Try to repair corrupted freepointer.
+	 * Still expecting two errors. The first for the wrong count
+	 * of objects in use.
+	 * The second error is for fixing broken cache.
+	 */
+	*ptr_addr = tmp;
+	slab_errors = 0;
+
+	validate_slab_cache(s);
+	KUNIT_EXPECT_EQ(test, 2, slab_errors);
+
+	/*
+	 * Previous validation repaired the count of objects in use.
+	 * Now expecting no error.
+	 */
+	slab_errors = 0;
+	validate_slab_cache(s);
+	KUNIT_EXPECT_EQ(test, 0, slab_errors);
+
+	kmem_cache_destroy(s);
+}
+
+static void test_first_word(struct kunit *test)
+{
+	struct kmem_cache *s = kmem_cache_create("TestSlub_1th_word_free", 64, 0,
+				SLAB_POISON, NULL);
+	u8 *p = kmem_cache_alloc(s, GFP_KERNEL);
+
+	kmem_cache_free(s, p);
+	*p = 0x78;
+
+	validate_slab_cache(s);
+	KUNIT_EXPECT_EQ(test, 2, slab_errors);
+
+	kmem_cache_destroy(s);
+}
+
+static void test_clobber_50th_byte(struct kunit *test)
+{
+	struct kmem_cache *s = kmem_cache_create("TestSlub_50th_word_free", 64, 0,
+				SLAB_POISON, NULL);
+	u8 *p = kmem_cache_alloc(s, GFP_KERNEL);
+
+	kmem_cache_free(s, p);
+	p[50] = 0x9a;
+
+	validate_slab_cache(s);
+	KUNIT_EXPECT_EQ(test, 2, slab_errors);
+
+	kmem_cache_destroy(s);
+}
+#endif
+
+static void test_clobber_redzone_free(struct kunit *test)
+{
+	struct kmem_cache *s = kmem_cache_create("TestSlub_RZ_free", 64, 0,
+				SLAB_RED_ZONE, NULL);
+	u8 *p = kmem_cache_alloc(s, GFP_KERNEL);
+
+	kasan_disable_current();
+	kmem_cache_free(s, p);
+	p[64] = 0xab;
+
+	validate_slab_cache(s);
+	KUNIT_EXPECT_EQ(test, 2, slab_errors);
+
+	kasan_enable_current();
+	kmem_cache_destroy(s);
+}
+
+static int test_init(struct kunit *test)
+{
+	slab_errors = 0;
+
+	kunit_add_named_resource(test, NULL, NULL, &resource,
+					"slab_errors", &slab_errors);
+	return 0;
+}
+
+static void test_exit(struct kunit *test) {}
+
+static struct kunit_case test_cases[] = {
+	KUNIT_CASE(test_clobber_zone),
+
+#ifndef CONFIG_KASAN
+	KUNIT_CASE(test_next_pointer),
+	KUNIT_CASE(test_first_word),
+	KUNIT_CASE(test_clobber_50th_byte),
+#endif
+
+	KUNIT_CASE(test_clobber_redzone_free),
+	{}
+};
+
+static struct kunit_suite test_suite = {
+	.name = "slub_test",
+	.init = test_init,
+	.exit = test_exit,
+	.test_cases = test_cases,
+};
+kunit_test_suite(test_suite);
+
+MODULE_LICENSE("GPL");
--- a/mm/slab.h~mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality
+++ a/mm/slab.h
@@ -215,6 +215,7 @@ DECLARE_STATIC_KEY_TRUE(slub_debug_enabl
 DECLARE_STATIC_KEY_FALSE(slub_debug_enabled);
 #endif
 extern void print_tracking(struct kmem_cache *s, void *object);
+long validate_slab_cache(struct kmem_cache *s);
 #else
 static inline void print_tracking(struct kmem_cache *s, void *object)
 {
--- a/mm/slub.c~mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality
+++ a/mm/slub.c
@@ -35,6 +35,7 @@
 #include <linux/prefetch.h>
 #include <linux/memcontrol.h>
 #include <linux/random.h>
+#include <kunit/test.h>
 
 #include <trace/events/kmem.h>
 
@@ -447,6 +448,26 @@ static inline bool cmpxchg_double_slab(s
 static unsigned long object_map[BITS_TO_LONGS(MAX_OBJS_PER_PAGE)];
 static DEFINE_SPINLOCK(object_map_lock);
 
+#if IS_ENABLED(CONFIG_KUNIT)
+static bool slab_add_kunit_errors(void)
+{
+	struct kunit_resource *resource;
+
+	if (likely(!current->kunit_test))
+		return false;
+
+	resource = kunit_find_named_resource(current->kunit_test, "slab_errors");
+	if (!resource)
+		return false;
+
+	(*(int *)resource->data)++;
+	kunit_put_resource(resource);
+	return true;
+}
+#else
+static inline bool slab_add_kunit_errors(void) { return false; }
+#endif
+
 /*
  * Determine a map of object in use on a page.
  *
@@ -677,6 +698,9 @@ static void slab_fix(struct kmem_cache *
 	struct va_format vaf;
 	va_list args;
 
+	if (slab_add_kunit_errors())
+		return;
+
 	va_start(args, fmt);
 	vaf.fmt = fmt;
 	vaf.va = &args;
@@ -740,6 +764,9 @@ static void print_trailer(struct kmem_ca
 void object_err(struct kmem_cache *s, struct page *page,
 			u8 *object, char *reason)
 {
+	if (slab_add_kunit_errors())
+		return;
+
 	slab_bug(s, "%s", reason);
 	print_trailer(s, page, object);
 }
@@ -750,6 +777,9 @@ static __printf(3, 4) void slab_err(stru
 	va_list args;
 	char buf[100];
 
+	if (slab_add_kunit_errors())
+		return;
+
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
@@ -799,12 +829,16 @@ static int check_bytes_and_report(struct
 	while (end > fault && end[-1] == value)
 		end--;
 
+	if (slab_add_kunit_errors())
+		goto skip_bug_print;
+
 	slab_bug(s, "%s overwritten", what);
 	pr_err("0x%p-0x%p @offset=%tu. First byte 0x%x instead of 0x%x\n",
 					fault, end - 1, fault - addr,
 					fault[0], value);
 	print_trailer(s, page, object);
 
+skip_bug_print:
 	restore_bytes(s, what, value, fault, end);
 	return 0;
 }
@@ -4653,9 +4687,11 @@ static int validate_slab_node(struct kme
 		validate_slab(s, page);
 		count++;
 	}
-	if (count != n->nr_partial)
+	if (count != n->nr_partial) {
 		pr_err("SLUB %s: %ld partial slabs counted but counter=%ld\n",
 		       s->name, count, n->nr_partial);
+		slab_add_kunit_errors();
+	}
 
 	if (!(s->flags & SLAB_STORE_USER))
 		goto out;
@@ -4664,16 +4700,18 @@ static int validate_slab_node(struct kme
 		validate_slab(s, page);
 		count++;
 	}
-	if (count != atomic_long_read(&n->nr_slabs))
+	if (count != atomic_long_read(&n->nr_slabs)) {
 		pr_err("SLUB: %s %ld slabs counted but counter=%ld\n",
 		       s->name, count, atomic_long_read(&n->nr_slabs));
+		slab_add_kunit_errors();
+	}
 
 out:
 	spin_unlock_irqrestore(&n->list_lock, flags);
 	return count;
 }
 
-static long validate_slab_cache(struct kmem_cache *s)
+long validate_slab_cache(struct kmem_cache *s)
 {
 	int node;
 	unsigned long count = 0;
@@ -4685,6 +4723,8 @@ static long validate_slab_cache(struct k
 
 	return count;
 }
+EXPORT_SYMBOL(validate_slab_cache);
+
 /*
  * Generate lists of code addresses where slabcache objects are allocated
  * and freed.
_

Patches currently in -mm which might be from glittao@gmail.com are

mm-slub-kunit-add-a-kunit-test-for-slub-debugging-functionality.patch
slub-remove-resiliency_test-function.patch

