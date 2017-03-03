From: akpm@linux-foundation.org
Subject: + kasan-improve-double-free-report-format.patch added to -mm tree
Date: Fri, 03 Mar 2017 15:23:50 -0800
Message-ID: <58b9fb06.Pgb657Idhw6LXGVb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50716 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752161AbdCCXXz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 18:23:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: improve double-free report format
has been added to the -mm tree.  Its filename is
     kasan-improve-double-free-report-format.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-improve-double-free-report-format.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-improve-double-free-report-format.patch

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
Subject: kasan: improve double-free report format

Changes double-free report header from:

BUG: Double free or freeing an invalid pointer
Unexpected shadow byte: 0xFB

to:

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
@@ -104,7 +104,7 @@ static inline bool kasan_report_enabled(
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
@@ -241,22 +241,8 @@ static void describe_object(struct kmem_
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
@@ -331,6 +317,18 @@ static void print_shadow_for_address(con
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
@@ -342,7 +340,7 @@ static void kasan_report_error(struct ka
 	if (!addr_has_shadow(info)) {
 		dump_stack();
 	} else {
-		print_address_description(info);
+		print_address_description((void *)info->access_addr);
 		print_shadow_for_address(info->first_bad_addr);
 	}
 
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

