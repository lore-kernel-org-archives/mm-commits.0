Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C62A9C433B4
	for <mm-commits@archiver.kernel.org>; Thu,  1 Apr 2021 00:45:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B2296101E
	for <mm-commits@archiver.kernel.org>; Thu,  1 Apr 2021 00:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbhDAAo0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 20:44:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:54758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229812AbhDAAoA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 20:44:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C381A6101E;
        Thu,  1 Apr 2021 00:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617237840;
        bh=SloJ0yaFBTG1Qpv49fSD9Ro1foTNP5eEh8mcVNyzyBs=;
        h=Date:From:To:Subject:From;
        b=xW9Qia2u8bL/pmvvFzX32PDzXevBVeECWkw50qZHORAU7xi9Dj7xY9ILNqsI0/497
         LingoUpcKwiU0j7BotMxH6ctHIfNReAFcY1WWeH5dGVyIzK57S3IfR8qqyjWeuXh3V
         A+u6IQb2T2VbWPOfABMGZK4k4lHaXnv9rCKYLEaw=
Date:   Wed, 31 Mar 2021 17:43:59 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, glittao@gmail.com, iamjoonsoo.kim@lge.com,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, vbabka@suse.cz
Subject:  [to-be-updated]
 selftests-add-a-kselftest-for-slub-debugging-functionality.patch removed
 from -mm tree
Message-ID: <20210401004359.7TA3r5hGo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: selftests: add a kselftest for SLUB debugging functionality
has been removed from the -mm tree.  Its filename was
     selftests-add-a-kselftest-for-slub-debugging-functionality.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oliver Glitta <glittao@gmail.com>
Subject: selftests: add a kselftest for SLUB debugging functionality

SLUB has resiliency_test() function which is hidden behind #ifdef
SLUB_RESILIENCY_TEST that is not part of Kconfig, so nobody runs it. 
Kselftest should proper replacement for it.

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

Add new option CONFIG_TEST_SLUB in Kconfig.

Add parameter to function validate_slab_cache() to return number of errors
in cache.

[vbabka@suse.cz: remove a BUILD_BUG_ON left over from original resiliency_test() that breaks builds]
  Link: https://lkml.kernel.org/r/53cc267d-aa0a-071a-f9f8-0b47ec4b2b9d@suse.cz
Link: https://lkml.kernel.org/r/20210316124118.6874-1-glittao@gmail.com
Signed-off-by: Oliver Glitta <glittao@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug                    |    4 
 lib/Makefile                         |    1 
 lib/test_slub.c                      |  122 +++++++++++++++++++++++++
 mm/slab.h                            |    1 
 mm/slub.c                            |   34 ++++--
 tools/testing/selftests/lib/Makefile |    2 
 tools/testing/selftests/lib/config   |    1 
 tools/testing/selftests/lib/slub.sh  |    3 
 8 files changed, 156 insertions(+), 12 deletions(-)

--- a/lib/Kconfig.debug~selftests-add-a-kselftest-for-slub-debugging-functionality
+++ a/lib/Kconfig.debug
@@ -2123,6 +2123,10 @@ config TEST_KSTRTOX
 config TEST_PRINTF
 	tristate "Test printf() family of functions at runtime"
 
+config TEST_SLUB
+	tristate "Test SLUB cache errors at runtime"
+	depends on SLUB_DEBUG
+
 config TEST_BITMAP
 	tristate "Test bitmap_*() family of functions at runtime"
 	help
--- a/lib/Makefile~selftests-add-a-kselftest-for-slub-debugging-functionality
+++ a/lib/Makefile
@@ -83,6 +83,7 @@ obj-$(CONFIG_TEST_USER_COPY) += test_use
 obj-$(CONFIG_TEST_STATIC_KEYS) += test_static_keys.o
 obj-$(CONFIG_TEST_STATIC_KEYS) += test_static_key_base.o
 obj-$(CONFIG_TEST_PRINTF) += test_printf.o
+obj-$(CONFIG_TEST_SLUB) += test_slub.o
 obj-$(CONFIG_TEST_BITMAP) += test_bitmap.o
 obj-$(CONFIG_TEST_STRSCPY) += test_strscpy.o
 obj-$(CONFIG_TEST_UUID) += test_uuid.o
--- /dev/null
+++ a/lib/test_slub.c
@@ -0,0 +1,122 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Test cases for slub facility.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include "../mm/slab.h"
+
+#include "../tools/testing/selftests/kselftest_module.h"
+
+
+KSTM_MODULE_GLOBALS();
+
+
+static void __init validate_result(struct kmem_cache *s, int expected_errors)
+{
+	int errors = 0;
+
+	validate_slab_cache(s, &errors);
+	KSTM_CHECK_ZERO(errors - expected_errors);
+}
+
+static void __init test_clobber_zone(void)
+{
+	struct kmem_cache *s = kmem_cache_create("TestSlub_RZ_alloc", 64, 0,
+				SLAB_RED_ZONE, NULL);
+	u8 *p = kmem_cache_alloc(s, GFP_KERNEL);
+
+	p[64] = 0x12;
+	pr_err("1. kmem_cache: Clobber Redzone 0x12->0x%p\n", p + 64);
+
+	validate_result(s, 1);
+	kmem_cache_free(s, p);
+	kmem_cache_destroy(s);
+}
+
+static void __init test_next_pointer(void)
+{
+	struct kmem_cache *s = kmem_cache_create("TestSlub_next_ptr_free", 64, 0,
+				SLAB_RED_ZONE, NULL);
+	u8 *p = kmem_cache_alloc(s, GFP_KERNEL);
+
+	kmem_cache_free(s, p);
+	p[s->offset] = 0x12;
+	pr_err("1. kmem_cache: Clobber next pointer 0x34 -> -0x%p\n", p);
+
+	validate_result(s, 1);
+	kmem_cache_destroy(s);
+}
+
+static void __init test_first_word(void)
+{
+	struct kmem_cache *s = kmem_cache_create("TestSlub_1th_word_free", 64, 0,
+				SLAB_POISON, NULL);
+	u8 *p = kmem_cache_alloc(s, GFP_KERNEL);
+
+	kmem_cache_free(s, p);
+	*p = 0x78;
+	pr_err("2. kmem_cache: Clobber first word 0x78->0x%p\n", p);
+
+	validate_result(s, 1);
+	kmem_cache_destroy(s);
+}
+
+static void __init test_clobber_50th_byte(void)
+{
+	struct kmem_cache *s = kmem_cache_create("TestSlub_50th_word_free", 64, 0,
+				SLAB_POISON, NULL);
+	u8 *p = kmem_cache_alloc(s, GFP_KERNEL);
+
+	kmem_cache_free(s, p);
+	p[50] = 0x9a;
+	pr_err("3. kmem_cache: Clobber 50th byte 0x9a->0x%p\n", p);
+
+	validate_result(s, 1);
+	kmem_cache_destroy(s);
+}
+
+static void __init test_clobber_redzone_free(void)
+{
+	struct kmem_cache *s = kmem_cache_create("TestSlub_RZ_free", 64, 0,
+				SLAB_RED_ZONE, NULL);
+	u8 *p = kmem_cache_alloc(s, GFP_KERNEL);
+
+	kmem_cache_free(s, p);
+	p[64] = 0xab;
+	pr_err("4. kmem_cache: Clobber redzone 0xab->0x%p\n", p);
+
+	validate_result(s, 1);
+	kmem_cache_destroy(s);
+}
+
+static void __init resiliency_test(void)
+{
+	pr_err("SLUB resiliency testing\n");
+	pr_err("-----------------------\n");
+	pr_err("A. Corruption after allocation\n");
+
+	test_clobber_zone();
+
+	pr_err("\nB. Corruption after free\n");
+
+	test_next_pointer();
+	test_first_word();
+	test_clobber_50th_byte();
+	test_clobber_redzone_free();
+}
+
+
+static void __init selftest(void)
+{
+	resiliency_test();
+}
+
+
+KSTM_MODULE_LOADERS(test_slub);
+MODULE_LICENSE("GPL");
--- a/mm/slab.h~selftests-add-a-kselftest-for-slub-debugging-functionality
+++ a/mm/slab.h
@@ -215,6 +215,7 @@ DECLARE_STATIC_KEY_TRUE(slub_debug_enabl
 DECLARE_STATIC_KEY_FALSE(slub_debug_enabled);
 #endif
 extern void print_tracking(struct kmem_cache *s, void *object);
+long validate_slab_cache(struct kmem_cache *s, int *errors);
 #else
 static inline void print_tracking(struct kmem_cache *s, void *object)
 {
--- a/mm/slub.c~selftests-add-a-kselftest-for-slub-debugging-functionality
+++ a/mm/slub.c
@@ -4621,7 +4621,8 @@ static int count_total(struct page *page
 #endif
 
 #ifdef CONFIG_SLUB_DEBUG
-static void validate_slab(struct kmem_cache *s, struct page *page)
+static void validate_slab(struct kmem_cache *s, struct page *page,
+						int *errors)
 {
 	void *p;
 	void *addr = page_address(page);
@@ -4629,8 +4630,10 @@ static void validate_slab(struct kmem_ca
 
 	slab_lock(page);
 
-	if (!check_slab(s, page) || !on_freelist(s, page, NULL))
+	if (!check_slab(s, page) || !on_freelist(s, page, NULL)) {
+		*errors += 1;
 		goto unlock;
+	}
 
 	/* Now we know that a valid freelist exists */
 	map = get_map(s, page);
@@ -4638,8 +4641,10 @@ static void validate_slab(struct kmem_ca
 		u8 val = test_bit(__obj_to_index(s, addr, p), map) ?
 			 SLUB_RED_INACTIVE : SLUB_RED_ACTIVE;
 
-		if (!check_object(s, page, p, val))
+		if (!check_object(s, page, p, val)) {
+			*errors += 1;
 			break;
+		}
 	}
 	put_map(map);
 unlock:
@@ -4647,7 +4652,7 @@ unlock:
 }
 
 static int validate_slab_node(struct kmem_cache *s,
-		struct kmem_cache_node *n)
+		struct kmem_cache_node *n, int *errors)
 {
 	unsigned long count = 0;
 	struct page *page;
@@ -4656,30 +4661,34 @@ static int validate_slab_node(struct kme
 	spin_lock_irqsave(&n->list_lock, flags);
 
 	list_for_each_entry(page, &n->partial, slab_list) {
-		validate_slab(s, page);
+		validate_slab(s, page, errors);
 		count++;
 	}
-	if (count != n->nr_partial)
+	if (count != n->nr_partial) {
 		pr_err("SLUB %s: %ld partial slabs counted but counter=%ld\n",
 		       s->name, count, n->nr_partial);
+		*errors += 1;
+	}
 
 	if (!(s->flags & SLAB_STORE_USER))
 		goto out;
 
 	list_for_each_entry(page, &n->full, slab_list) {
-		validate_slab(s, page);
+		validate_slab(s, page, errors);
 		count++;
 	}
-	if (count != atomic_long_read(&n->nr_slabs))
+	if (count != atomic_long_read(&n->nr_slabs)) {
 		pr_err("SLUB: %s %ld slabs counted but counter=%ld\n",
 		       s->name, count, atomic_long_read(&n->nr_slabs));
+		*errors += 1;
+	}
 
 out:
 	spin_unlock_irqrestore(&n->list_lock, flags);
 	return count;
 }
 
-static long validate_slab_cache(struct kmem_cache *s)
+long validate_slab_cache(struct kmem_cache *s, int *errors)
 {
 	int node;
 	unsigned long count = 0;
@@ -4687,10 +4696,12 @@ static long validate_slab_cache(struct k
 
 	flush_all(s);
 	for_each_kmem_cache_node(s, node, n)
-		count += validate_slab_node(s, n);
+		count += validate_slab_node(s, n, errors);
 
 	return count;
 }
+EXPORT_SYMBOL(validate_slab_cache);
+
 /*
  * Generate lists of code addresses where slabcache objects are allocated
  * and freed.
@@ -5345,9 +5356,10 @@ static ssize_t validate_store(struct kme
 			const char *buf, size_t length)
 {
 	int ret = -EINVAL;
+	int errors = 0;
 
 	if (buf[0] == '1') {
-		ret = validate_slab_cache(s);
+		ret = validate_slab_cache(s, &errors);
 		if (ret >= 0)
 			ret = length;
 	}
--- a/tools/testing/selftests/lib/config~selftests-add-a-kselftest-for-slub-debugging-functionality
+++ a/tools/testing/selftests/lib/config
@@ -3,3 +3,4 @@ CONFIG_TEST_BITMAP=m
 CONFIG_PRIME_NUMBERS=m
 CONFIG_TEST_STRSCPY=m
 CONFIG_TEST_BITOPS=m
+CONFIG_TEST_SLUB=m
\ No newline at end of file
--- a/tools/testing/selftests/lib/Makefile~selftests-add-a-kselftest-for-slub-debugging-functionality
+++ a/tools/testing/selftests/lib/Makefile
@@ -4,6 +4,6 @@
 # No binaries, but make sure arg-less "make" doesn't trigger "run_tests"
 all:
 
-TEST_PROGS := printf.sh bitmap.sh prime_numbers.sh strscpy.sh
+TEST_PROGS := printf.sh bitmap.sh prime_numbers.sh strscpy.sh slub.sh
 
 include ../lib.mk
--- /dev/null
+++ a/tools/testing/selftests/lib/slub.sh
@@ -0,0 +1,3 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0+
+$(dirname $0)/../kselftest/module.sh "slub" test_slub
_

Patches currently in -mm which might be from glittao@gmail.com are

slub-remove-resiliency_test-function.patch

