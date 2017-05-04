From: akpm@linux-foundation.org
Subject: [merged] kasan-simplify-address-description-logic.patch
 removed from -mm tree
Date: Thu, 04 May 2017 12:14:05 -0700
Message-ID: <20170504191405.01mDO909c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52220 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752337AbdEDTOH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:14:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: simplify address description logic
has been removed from the -mm tree.  Its filename was
     kasan-simplify-address-description-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: simplify address description logic

Simplify logic for describing a memory address.
Add addr_to_page() helper function.

Makes the code easier to follow.

Link: http://lkml.kernel.org/r/20170302134851.101218-5-andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff -puN mm/kasan/report.c~kasan-simplify-address-description-logic mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-simplify-address-description-logic
+++ a/mm/kasan/report.c
@@ -190,11 +190,18 @@ static void print_track(struct kasan_tra
 	}
 }
 
-static void kasan_object_err(struct kmem_cache *cache, void *object)
+static struct page *addr_to_page(const void *addr)
+{
+	if ((addr >= (void *)PAGE_OFFSET) &&
+			(addr < high_memory))
+		return virt_to_head_page(addr);
+	return NULL;
+}
+
+static void describe_object(struct kmem_cache *cache, void *object)
 {
 	struct kasan_alloc_meta *alloc_info = get_alloc_info(cache, object);
 
-	dump_stack();
 	pr_err("Object at %p, in cache %s size: %d\n", object, cache->name,
 		cache->object_size);
 
@@ -213,34 +220,32 @@ void kasan_report_double_free(struct kme
 	kasan_start_report(&flags);
 	pr_err("BUG: Double free or freeing an invalid pointer\n");
 	pr_err("Unexpected shadow byte: 0x%hhX\n", shadow);
-	kasan_object_err(cache, object);
+	dump_stack();
+	describe_object(cache, object);
 	kasan_end_report(&flags);
 }
 
 static void print_address_description(struct kasan_access_info *info)
 {
 	const void *addr = info->access_addr;
+	struct page *page = addr_to_page(addr);
 
-	if ((addr >= (void *)PAGE_OFFSET) &&
-		(addr < high_memory)) {
-		struct page *page = virt_to_head_page(addr);
-
-		if (PageSlab(page)) {
-			void *object;
-			struct kmem_cache *cache = page->slab_cache;
-			object = nearest_obj(cache, page,
-						(void *)info->access_addr);
-			kasan_object_err(cache, object);
-			return;
-		}
+	if (page)
 		dump_page(page, "kasan: bad access detected");
+
+	dump_stack();
+
+	if (page && PageSlab(page)) {
+		struct kmem_cache *cache = page->slab_cache;
+		void *object = nearest_obj(cache, page,	(void *)addr);
+
+		describe_object(cache, object);
 	}
 
 	if (kernel_or_module_addr(addr)) {
 		if (!init_task_stack_addr(addr))
 			pr_err("Address belongs to variable %pS\n", addr);
 	}
-	dump_stack();
 }
 
 static bool row_is_guilty(const void *row, const void *guilty)
_

Patches currently in -mm which might be from andreyknvl@google.com are


