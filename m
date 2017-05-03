From: akpm@linux-foundation.org
Subject: [patch 102/102] kasan: separate report parts by empty
 lines
Date: Wed, 03 May 2017 14:56:50 -0700
Message-ID: <20170503215650.n-5xD_TUy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53478 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbdECV56 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:57:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: separate report parts by empty lines

Makes the report easier to read.

Link: http://lkml.kernel.org/r/20170302134851.101218-10-andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/kasan/report.c~kasan-separate-report-parts-by-empty-lines mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-separate-report-parts-by-empty-lines
+++ a/mm/kasan/report.c
@@ -237,7 +237,9 @@ static void describe_object(struct kmem_
 
 	if (cache->flags & SLAB_KASAN) {
 		print_track(&alloc_info->alloc_track, "Allocated");
+		pr_err("\n");
 		print_track(&alloc_info->free_track, "Freed");
+		pr_err("\n");
 	}
 
 	describe_object_addr(cache, object, addr);
@@ -248,6 +250,7 @@ static void print_address_description(vo
 	struct page *page = addr_to_page(addr);
 
 	dump_stack();
+	pr_err("\n");
 
 	if (page && PageSlab(page)) {
 		struct kmem_cache *cache = page->slab_cache;
@@ -326,7 +329,9 @@ void kasan_report_double_free(struct kme
 
 	kasan_start_report(&flags);
 	pr_err("BUG: KASAN: double-free or invalid-free in %pS\n", ip);
+	pr_err("\n");
 	print_address_description(object);
+	pr_err("\n");
 	print_shadow_for_address(object);
 	kasan_end_report(&flags);
 }
@@ -338,11 +343,13 @@ static void kasan_report_error(struct ka
 	kasan_start_report(&flags);
 
 	print_error_description(info);
+	pr_err("\n");
 
 	if (!addr_has_shadow(info)) {
 		dump_stack();
 	} else {
 		print_address_description((void *)info->access_addr);
+		pr_err("\n");
 		print_shadow_for_address(info->first_bad_addr);
 	}
 
_
