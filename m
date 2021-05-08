Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 408A9C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:34:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 179236140E
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhEHWfm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:35:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWfl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:35:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3C2E613DD;
        Sat,  8 May 2021 22:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513278;
        bh=/L9JVJ9L/hW2HD6hi1dxZSpz/EWWf9tUUAUZDHCRUno=;
        h=Date:From:To:Subject:From;
        b=DIZbCaXvHU7QyXKYhkn8voLUDSS8KiUVlgDynLepHow6SWZugzy4RpHvudf+z1x0G
         7AChzHQe0AZ8csA/AhD+CTZOJO1GskZPN1iTMuh2CTA0pUSgKlE/8Jg2AOQDx9N/CK
         jhyK0ZdOJazvSGoYIk0vb9ux4oub/2V5vDdeTCsY=
Date:   Sat, 08 May 2021 15:34:38 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, glittao@gmail.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  [to-be-updated]
 kunit-add-a-kunit-test-for-slub-debugging-functionality.patch removed from
 -mm tree
Message-ID: <20210508223438.w608cH48K%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kunit: add a KUnit test for SLUB debugging functionality
has been removed from the -mm tree.  Its filename was
     kunit-add-a-kunit-test-for-slub-debugging-functionality.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oliver Glitta <glittao@gmail.com>
Subject: kunit: add a KUnit test for SLUB debugging functionality

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

Add new option CONFIG_SLUB_KUNIT_TEST in Kconfig.

Add a counter field "errors" to struct kmem_cache to count number of
errors detected in cache.

Silence bug report in SLUB test.  Add SLAB_SILENT_ERRORS debug flag.  Add
SLAB_SILENT_ERRORS flag to SLAB_NEVER_MERGE, SLAB_DEBUG_FLAGS,
SLAB_FLAGS_PERMITTED macros.

Link: https://lkml.kernel.org/r/20210331085156.5028-1-glittao@gmail.com
Signed-off-by: Oliver Glitta <glittao@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h     |    2 
 include/linux/slub_def.h |    2 
 lib/Kconfig.debug        |    5 +
 lib/Makefile             |    1 
 lib/test_slub.c          |  124 +++++++++++++++++++++++++++++++++++++
 mm/slab.h                |    7 +-
 mm/slab_common.c         |    2 
 mm/slub.c                |   64 +++++++++++++------
 8 files changed, 184 insertions(+), 23 deletions(-)

--- a/include/linux/slab.h~kunit-add-a-kunit-test-for-slub-debugging-functionality
+++ a/include/linux/slab.h
@@ -25,6 +25,8 @@
  */
 /* DEBUG: Perform (expensive) checks on alloc/free */
 #define SLAB_CONSISTENCY_CHECKS	((slab_flags_t __force)0x00000100U)
+/* DEBUG: Silent bug reports */
+#define SLAB_SILENT_ERRORS	((slab_flags_t __force)0x00000200U)
 /* DEBUG: Red zone objs in a cache */
 #define SLAB_RED_ZONE		((slab_flags_t __force)0x00000400U)
 /* DEBUG: Poison objects */
--- a/include/linux/slub_def.h~kunit-add-a-kunit-test-for-slub-debugging-functionality
+++ a/include/linux/slub_def.h
@@ -133,6 +133,8 @@ struct kmem_cache {
 	unsigned int usersize;		/* Usercopy region size */
 
 	struct kmem_cache_node *node[MAX_NUMNODES];
+
+	int errors;			/* Number of errors in cache */
 };
 
 #ifdef CONFIG_SLUB_CPU_PARTIAL
--- a/lib/Kconfig.debug~kunit-add-a-kunit-test-for-slub-debugging-functionality
+++ a/lib/Kconfig.debug
@@ -2429,6 +2429,11 @@ config BITS_TEST
 
 	  If unsure, say N.
 
+config SLUB_KUNIT_TEST
+	tristate "KUnit Test for SLUB cache error detection" if !KUNIT_ALL_TESTS
+	depends on SLUB_DEBUG && KUNIT
+	default KUNIT_ALL_TESTS
+
 config TEST_UDELAY
 	tristate "udelay test driver"
 	help
--- a/lib/Makefile~kunit-add-a-kunit-test-for-slub-debugging-functionality
+++ a/lib/Makefile
@@ -353,5 +353,6 @@ obj-$(CONFIG_LIST_KUNIT_TEST) += list-te
 obj-$(CONFIG_LINEAR_RANGES_TEST) += test_linear_ranges.o
 obj-$(CONFIG_BITS_TEST) += test_bits.o
 obj-$(CONFIG_CMDLINE_KUNIT_TEST) += cmdline_kunit.o
+obj-$(CONFIG_SLUB_KUNIT_TEST) += test_slub.o
 
 obj-$(CONFIG_GENERIC_LIB_DEVMEM_IS_ALLOWED) += devmem_is_allowed.o
--- /dev/null
+++ a/lib/test_slub.c
@@ -0,0 +1,124 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <kunit/test.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include "../mm/slab.h"
+
+
+static void test_clobber_zone(struct kunit *test)
+{
+	struct kmem_cache *s = kmem_cache_create("TestSlub_RZ_alloc", 64, 0,
+				SLAB_RED_ZONE | SLAB_SILENT_ERRORS, NULL);
+	u8 *p = kmem_cache_alloc(s, GFP_KERNEL);
+
+	p[64] = 0x12;
+
+	validate_slab_cache(s);
+	KUNIT_EXPECT_EQ(test, 1, s->errors);
+
+	kmem_cache_free(s, p);
+	kmem_cache_destroy(s);
+}
+
+static void test_next_pointer(struct kunit *test)
+{
+	struct kmem_cache *s = kmem_cache_create("TestSlub_next_ptr_free", 64, 0,
+				SLAB_POISON | SLAB_SILENT_ERRORS, NULL);
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
+	 * Expecting two errors.
+	 * One for the corrupted freechain and the other one for the wrong
+	 * count of objects in use.
+	 */
+	validate_slab_cache(s);
+	KUNIT_EXPECT_EQ(test, 2, s->errors);
+
+	/*
+	 * Try to repair corrupted freepointer.
+	 * Still expecting one error for the wrong count of objects in use.
+	 */
+	*ptr_addr = tmp;
+
+	validate_slab_cache(s);
+	KUNIT_EXPECT_EQ(test, 1, s->errors);
+
+	/*
+	 * Previous validation repaired the count of objects in use.
+	 * Now expecting no error.
+	 */
+	validate_slab_cache(s);
+	KUNIT_EXPECT_EQ(test, 0, s->errors);
+
+	kmem_cache_destroy(s);
+}
+
+static void test_first_word(struct kunit *test)
+{
+	struct kmem_cache *s = kmem_cache_create("TestSlub_1th_word_free", 64, 0,
+				SLAB_POISON | SLAB_SILENT_ERRORS, NULL);
+	u8 *p = kmem_cache_alloc(s, GFP_KERNEL);
+
+	kmem_cache_free(s, p);
+	*p = 0x78;
+
+	validate_slab_cache(s);
+	KUNIT_EXPECT_EQ(test, 1, s->errors);
+
+	kmem_cache_destroy(s);
+}
+
+static void test_clobber_50th_byte(struct kunit *test)
+{
+	struct kmem_cache *s = kmem_cache_create("TestSlub_50th_word_free", 64, 0,
+				SLAB_POISON | SLAB_SILENT_ERRORS, NULL);
+	u8 *p = kmem_cache_alloc(s, GFP_KERNEL);
+
+	kmem_cache_free(s, p);
+	p[50] = 0x9a;
+
+	validate_slab_cache(s);
+	KUNIT_EXPECT_EQ(test, 1, s->errors);
+	kmem_cache_destroy(s);
+}
+
+static void test_clobber_redzone_free(struct kunit *test)
+{
+	struct kmem_cache *s = kmem_cache_create("TestSlub_RZ_free", 64, 0,
+				SLAB_RED_ZONE | SLAB_SILENT_ERRORS, NULL);
+	u8 *p = kmem_cache_alloc(s, GFP_KERNEL);
+
+	kmem_cache_free(s, p);
+	p[64] = 0xab;
+
+	validate_slab_cache(s);
+	KUNIT_EXPECT_EQ(test, 1, s->errors);
+	kmem_cache_destroy(s);
+}
+
+static struct kunit_case test_cases[] = {
+	KUNIT_CASE(test_clobber_zone),
+	KUNIT_CASE(test_next_pointer),
+	KUNIT_CASE(test_first_word),
+	KUNIT_CASE(test_clobber_50th_byte),
+	KUNIT_CASE(test_clobber_redzone_free),
+	{}
+};
+
+static struct kunit_suite test_suite = {
+	.name = "slub_test",
+	.test_cases = test_cases,
+};
+kunit_test_suite(test_suite);
+
+MODULE_LICENSE("GPL");
--- a/mm/slab_common.c~kunit-add-a-kunit-test-for-slub-debugging-functionality
+++ a/mm/slab_common.c
@@ -55,7 +55,7 @@ static DECLARE_WORK(slab_caches_to_rcu_d
  */
 #define SLAB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
 		SLAB_TRACE | SLAB_TYPESAFE_BY_RCU | SLAB_NOLEAKTRACE | \
-		SLAB_FAILSLAB | kasan_never_merge())
+		SLAB_FAILSLAB | SLAB_SILENT_ERRORS | kasan_never_merge())
 
 #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
 			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT)
--- a/mm/slab.h~kunit-add-a-kunit-test-for-slub-debugging-functionality
+++ a/mm/slab.h
@@ -134,7 +134,8 @@ static inline slab_flags_t kmem_cache_fl
 #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER)
 #elif defined(CONFIG_SLUB_DEBUG)
 #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
-			  SLAB_TRACE | SLAB_CONSISTENCY_CHECKS)
+			  SLAB_TRACE | SLAB_CONSISTENCY_CHECKS | \
+			  SLAB_SILENT_ERRORS)
 #else
 #define SLAB_DEBUG_FLAGS (0)
 #endif
@@ -164,7 +165,8 @@ static inline slab_flags_t kmem_cache_fl
 			      SLAB_NOLEAKTRACE | \
 			      SLAB_RECLAIM_ACCOUNT | \
 			      SLAB_TEMPORARY | \
-			      SLAB_ACCOUNT)
+			      SLAB_ACCOUNT | \
+			      SLAB_SILENT_ERRORS)
 
 bool __kmem_cache_empty(struct kmem_cache *);
 int __kmem_cache_shutdown(struct kmem_cache *);
@@ -215,6 +217,7 @@ DECLARE_STATIC_KEY_TRUE(slub_debug_enabl
 DECLARE_STATIC_KEY_FALSE(slub_debug_enabled);
 #endif
 extern void print_tracking(struct kmem_cache *s, void *object);
+long validate_slab_cache(struct kmem_cache *s);
 #else
 static inline void print_tracking(struct kmem_cache *s, void *object)
 {
--- a/mm/slub.c~kunit-add-a-kunit-test-for-slub-debugging-functionality
+++ a/mm/slub.c
@@ -674,14 +674,16 @@ static void slab_bug(struct kmem_cache *
 
 static void slab_fix(struct kmem_cache *s, char *fmt, ...)
 {
-	struct va_format vaf;
-	va_list args;
-
-	va_start(args, fmt);
-	vaf.fmt = fmt;
-	vaf.va = &args;
-	pr_err("FIX %s: %pV\n", s->name, &vaf);
-	va_end(args);
+	if (!(s->flags & SLAB_SILENT_ERRORS)) {
+		struct va_format vaf;
+		va_list args;
+
+		va_start(args, fmt);
+		vaf.fmt = fmt;
+		vaf.va = &args;
+		pr_err("FIX %s: %pV\n", s->name, &vaf);
+		va_end(args);
+	}
 }
 
 static bool freelist_corrupted(struct kmem_cache *s, struct page *page,
@@ -740,8 +742,10 @@ static void print_trailer(struct kmem_ca
 void object_err(struct kmem_cache *s, struct page *page,
 			u8 *object, char *reason)
 {
-	slab_bug(s, "%s", reason);
-	print_trailer(s, page, object);
+	if (!(s->flags & SLAB_SILENT_ERRORS)) {
+		slab_bug(s, "%s", reason);
+		print_trailer(s, page, object);
+	}
 }
 
 static __printf(3, 4) void slab_err(struct kmem_cache *s, struct page *page,
@@ -753,9 +757,11 @@ static __printf(3, 4) void slab_err(stru
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
-	slab_bug(s, "%s", buf);
-	print_page_info(page);
-	dump_stack();
+	if (!(s->flags & SLAB_SILENT_ERRORS)) {
+		slab_bug(s, "%s", buf);
+		print_page_info(page);
+		dump_stack();
+	}
 }
 
 static void init_object(struct kmem_cache *s, void *object, u8 val)
@@ -799,11 +805,13 @@ static int check_bytes_and_report(struct
 	while (end > fault && end[-1] == value)
 		end--;
 
-	slab_bug(s, "%s overwritten", what);
-	pr_err("0x%p-0x%p @offset=%tu. First byte 0x%x instead of 0x%x\n",
+	if (!(s->flags & SLAB_SILENT_ERRORS)) {
+		slab_bug(s, "%s overwritten", what);
+		pr_err("0x%p-0x%p @offset=%tu. First byte 0x%x instead of 0x%x\n",
 					fault, end - 1, fault - addr,
 					fault[0], value);
-	print_trailer(s, page, object);
+		print_trailer(s, page, object);
+	}
 
 	restore_bytes(s, what, value, fault, end);
 	return 0;
@@ -965,6 +973,7 @@ static int check_slab(struct kmem_cache
 
 	if (!PageSlab(page)) {
 		slab_err(s, page, "Not a valid slab page");
+		s->errors += 1;
 		return 0;
 	}
 
@@ -972,11 +981,13 @@ static int check_slab(struct kmem_cache
 	if (page->objects > maxobj) {
 		slab_err(s, page, "objects %u > max %u",
 			page->objects, maxobj);
+		s->errors += 1;
 		return 0;
 	}
 	if (page->inuse > page->objects) {
 		slab_err(s, page, "inuse %u > max %u",
 			page->inuse, page->objects);
+		s->errors += 1;
 		return 0;
 	}
 	/* Slab_pad_check fixes things up after itself */
@@ -1009,8 +1020,10 @@ static int on_freelist(struct kmem_cache
 				page->freelist = NULL;
 				page->inuse = page->objects;
 				slab_fix(s, "Freelist cleared");
+				s->errors += 1;
 				return 0;
 			}
+			s->errors += 1;
 			break;
 		}
 		object = fp;
@@ -1027,12 +1040,14 @@ static int on_freelist(struct kmem_cache
 			 page->objects, max_objects);
 		page->objects = max_objects;
 		slab_fix(s, "Number of objects adjusted.");
+		s->errors += 1;
 	}
 	if (page->inuse != page->objects - nr) {
 		slab_err(s, page, "Wrong object count. Counter is %d but counted were %d",
 			 page->inuse, page->objects - nr);
 		page->inuse = page->objects - nr;
 		slab_fix(s, "Object count adjusted.");
+		s->errors += 1;
 	}
 	return search == NULL;
 }
@@ -4641,8 +4656,10 @@ static void validate_slab(struct kmem_ca
 		u8 val = test_bit(__obj_to_index(s, addr, p), map) ?
 			 SLUB_RED_INACTIVE : SLUB_RED_ACTIVE;
 
-		if (!check_object(s, page, p, val))
+		if (!check_object(s, page, p, val)) {
+			s->errors += 1;
 			break;
+		}
 	}
 	put_map(map);
 unlock:
@@ -4662,9 +4679,11 @@ static int validate_slab_node(struct kme
 		validate_slab(s, page);
 		count++;
 	}
-	if (count != n->nr_partial)
+	if (count != n->nr_partial) {
 		pr_err("SLUB %s: %ld partial slabs counted but counter=%ld\n",
 		       s->name, count, n->nr_partial);
+		s->errors += 1;
+	}
 
 	if (!(s->flags & SLAB_STORE_USER))
 		goto out;
@@ -4673,20 +4692,23 @@ static int validate_slab_node(struct kme
 		validate_slab(s, page);
 		count++;
 	}
-	if (count != atomic_long_read(&n->nr_slabs))
+	if (count != atomic_long_read(&n->nr_slabs)) {
 		pr_err("SLUB: %s %ld slabs counted but counter=%ld\n",
 		       s->name, count, atomic_long_read(&n->nr_slabs));
+		s->errors += 1;
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
 	struct kmem_cache_node *n;
+	s->errors = 0;
 
 	flush_all(s);
 	for_each_kmem_cache_node(s, node, n)
@@ -4694,6 +4716,8 @@ static long validate_slab_cache(struct k
 
 	return count;
 }
+EXPORT_SYMBOL(validate_slab_cache);
+
 /*
  * Generate lists of code addresses where slabcache objects are allocated
  * and freed.
_

Patches currently in -mm which might be from glittao@gmail.com are


