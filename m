From: akpm@linux-foundation.org
Subject: + kasan-improve-slab-object-description.patch added to -mm tree
Date: Fri, 03 Mar 2017 15:23:46 -0800
Message-ID: <58b9fb02.tXGqRt+nZgy0o1ZF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50662 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752221AbdCCXXy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 18:23:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: improve slab object description
has been added to the -mm tree.  Its filename is
     kasan-improve-slab-object-description.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-improve-slab-object-description.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-improve-slab-object-description.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: improve slab object description

Changes slab object description from:

Object at ffff880068388540, in cache kmalloc-128 size: 128

to:

The buggy address belongs to the object at ffff880068388540
 which belongs to the cache kmalloc-128 of size 128
The buggy address is located 123 bytes inside of
 128-byte region [ffff880068388540, ffff8800683885c0)

Makes it more explanatory and adds information about relative offset
of the accessed address to the start of the object.

Link: http://lkml.kernel.org/r/20170302134851.101218-7-andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   55 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 12 deletions(-)

diff -puN mm/kasan/report.c~kasan-improve-slab-object-description mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-improve-slab-object-description
+++ a/mm/kasan/report.c
@@ -196,18 +196,49 @@ static struct page *addr_to_page(const v
 	return NULL;
 }
 
-static void describe_object(struct kmem_cache *cache, void *object)
+static void describe_object_addr(struct kmem_cache *cache, void *object,
+				const void *addr)
 {
-	struct kasan_alloc_meta *alloc_info = get_alloc_info(cache, object);
-
-	pr_err("Object at %p, in cache %s size: %d\n", object, cache->name,
-		cache->object_size);
+	unsigned long access_addr = (unsigned long)addr;
+	unsigned long object_addr = (unsigned long)object;
+	const char *rel_type;
+	int rel_bytes;
+
+	pr_err("The buggy address belongs to the object at %p\n"
+	       " which belongs to the cache %s of size %d\n",
+		object, cache->name, cache->object_size);
 
-	if (!(cache->flags & SLAB_KASAN))
+	if (!addr)
 		return;
 
-	print_track(&alloc_info->alloc_track, "Allocated");
-	print_track(&alloc_info->free_track, "Freed");
+	if (access_addr < object_addr) {
+		rel_type = "to the left";
+		rel_bytes = object_addr - access_addr;
+	} else if (access_addr >= object_addr + cache->object_size) {
+		rel_type = "to the right";
+		rel_bytes = access_addr - (object_addr + cache->object_size);
+	} else {
+		rel_type = "inside";
+		rel_bytes = access_addr - object_addr;
+	}
+
+	pr_err("The buggy address is located %d bytes %s of\n"
+	       " %d-byte region [%p, %p)\n",
+		rel_bytes, rel_type, cache->object_size, (void *)object_addr,
+		(void *)(object_addr + cache->object_size));
+}
+
+static void describe_object(struct kmem_cache *cache, void *object,
+				const void *addr)
+{
+	struct kasan_alloc_meta *alloc_info = get_alloc_info(cache, object);
+
+	if (cache->flags & SLAB_KASAN) {
+		print_track(&alloc_info->alloc_track, "Allocated");
+		print_track(&alloc_info->free_track, "Freed");
+	}
+
+	describe_object_addr(cache, object, addr);
 }
 
 void kasan_report_double_free(struct kmem_cache *cache, void *object,
@@ -219,13 +250,13 @@ void kasan_report_double_free(struct kme
 	pr_err("BUG: Double free or freeing an invalid pointer\n");
 	pr_err("Unexpected shadow byte: 0x%hhX\n", shadow);
 	dump_stack();
-	describe_object(cache, object);
+	describe_object(cache, object, NULL);
 	kasan_end_report(&flags);
 }
 
 static void print_address_description(struct kasan_access_info *info)
 {
-	const void *addr = info->access_addr;
+	void *addr = (void *)info->access_addr;
 	struct page *page = addr_to_page(addr);
 
 	if (page)
@@ -235,9 +266,9 @@ static void print_address_description(st
 
 	if (page && PageSlab(page)) {
 		struct kmem_cache *cache = page->slab_cache;
-		void *object = nearest_obj(cache, page,	(void *)addr);
+		void *object = nearest_obj(cache, page,	addr);
 
-		describe_object(cache, object);
+		describe_object(cache, object, addr);
 	}
 
 	if (kernel_or_module_addr(addr)) {
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-introduce-helper-functions-for-determining-bug-type.patch
kasan-unify-report-headers.patch
kasan-change-allocation-and-freeing-stack-traces-headers.patch
kasan-simplify-address-description-logic.patch
kasan-change-report-header.patch
kasan-improve-slab-object-description.patch
kasan-print-page-description-after-stacks.patch
kasan-improve-double-free-report-format.patch
kasan-separate-report-parts-by-empty-lines.patch

