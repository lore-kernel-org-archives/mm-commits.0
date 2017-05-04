From: akpm@linux-foundation.org
Subject: [merged] kasan-improve-double-free-report-format.patch
 removed from -mm tree
Date: Thu, 04 May 2017 12:14:20 -0700
Message-ID: <20170504191420.LgoL7vrOl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52254 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754772AbdEDTOV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:14:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: improve double-free report format
has been removed from the -mm tree.  Its filename was
     kasan-improve-double-free-report-format.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: improve double-free report format

Changes double-free report header from

BUG: Double free or freeing an invalid pointer
Unexpected shadow byte: 0xFB

to

BUG: KASAN: double-free or invalid-free in kmalloc_oob_left+0xe5/0xef

This makes a bug uniquely identifiable by the first report line.
To account for removing of the unexpected shadow value, print shadow
bytes at the end of the report as in reports for other kinds of bugs.

Link: http://lkml.kernel.org/r/20170302134851.101218-9-andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c  |    3 ++-
 mm/kasan/kasan.h  |    2 +-
 mm/kasan/report.c |   30 ++++++++++++++----------------
 3 files changed, 17 insertions(+), 18 deletions(-)

diff -puN mm/kasan/kasan.c~kasan-improve-double-free-report-format mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~kasan-improve-double-free-report-format
+++ a/mm/kasan/kasan.c
@@ -577,7 +577,8 @@ bool kasan_slab_free(struct kmem_cache *
 
 	shadow_byte = READ_ONCE(*(s8 *)kasan_mem_to_shadow(object));
 	if (shadow_byte < 0 || shadow_byte >= KASAN_SHADOW_SCALE_SIZE) {
-		kasan_report_double_free(cache, object, shadow_byte);
+		kasan_report_double_free(cache, object,
+				__builtin_return_address(1));
 		return true;
 	}
 
diff -puN mm/kasan/kasan.h~kasan-improve-double-free-report-format mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~kasan-improve-double-free-report-format
+++ a/mm/kasan/kasan.h
@@ -99,7 +99,7 @@ static inline const void *kasan_shadow_t
 void kasan_report(unsigned long addr, size_t size,
 		bool is_write, unsigned long ip);
 void kasan_report_double_free(struct kmem_cache *cache, void *object,
-			s8 shadow);
+					void *ip);
 
 #if defined(CONFIG_SLAB) || defined(CONFIG_SLUB)
 void quarantine_put(struct kasan_free_meta *info, struct kmem_cache *cache);
diff -puN mm/kasan/report.c~kasan-improve-double-free-report-format mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-improve-double-free-report-format
+++ a/mm/kasan/report.c
@@ -243,22 +243,8 @@ static void describe_object(struct kmem_
 	describe_object_addr(cache, object, addr);
 }
 
-void kasan_report_double_free(struct kmem_cache *cache, void *object,
-			s8 shadow)
-{
-	unsigned long flags;
-
-	kasan_start_report(&flags);
-	pr_err("BUG: Double free or freeing an invalid pointer\n");
-	pr_err("Unexpected shadow byte: 0x%hhX\n", shadow);
-	dump_stack();
-	describe_object(cache, object, NULL);
-	kasan_end_report(&flags);
-}
-
-static void print_address_description(struct kasan_access_info *info)
+static void print_address_description(void *addr)
 {
-	void *addr = (void *)info->access_addr;
 	struct page *page = addr_to_page(addr);
 
 	dump_stack();
@@ -333,6 +319,18 @@ static void print_shadow_for_address(con
 	}
 }
 
+void kasan_report_double_free(struct kmem_cache *cache, void *object,
+				void *ip)
+{
+	unsigned long flags;
+
+	kasan_start_report(&flags);
+	pr_err("BUG: KASAN: double-free or invalid-free in %pS\n", ip);
+	print_address_description(object);
+	print_shadow_for_address(object);
+	kasan_end_report(&flags);
+}
+
 static void kasan_report_error(struct kasan_access_info *info)
 {
 	unsigned long flags;
@@ -344,7 +342,7 @@ static void kasan_report_error(struct ka
 	if (!addr_has_shadow(info)) {
 		dump_stack();
 	} else {
-		print_address_description(info);
+		print_address_description((void *)info->access_addr);
 		print_shadow_for_address(info->first_bad_addr);
 	}
 
_

Patches currently in -mm which might be from andreyknvl@google.com are


