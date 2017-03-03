From: akpm@linux-foundation.org
Subject: + kasan-separate-report-parts-by-empty-lines.patch added to -mm
 tree
Date: Fri, 03 Mar 2017 15:23:53 -0800
Message-ID: <58b9fb09.0TabbLRE2/pwDfvh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50716 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752252AbdCCXX5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 18:23:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: separate report parts by empty lines
has been added to the -mm tree.  Its filename is
     kasan-separate-report-parts-by-empty-lines.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-separate-report-parts-by-empty-lines.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-separate-report-parts-by-empty-lines.patch

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
@@ -235,7 +235,9 @@ static void describe_object(struct kmem_
 
 	if (cache->flags & SLAB_KASAN) {
 		print_track(&alloc_info->alloc_track, "Allocated");
+		pr_err("\n");
 		print_track(&alloc_info->free_track, "Freed");
+		pr_err("\n");
 	}
 
 	describe_object_addr(cache, object, addr);
@@ -246,6 +248,7 @@ static void print_address_description(vo
 	struct page *page = addr_to_page(addr);
 
 	dump_stack();
+	pr_err("\n");
 
 	if (page && PageSlab(page)) {
 		struct kmem_cache *cache = page->slab_cache;
@@ -324,7 +327,9 @@ void kasan_report_double_free(struct kme
 
 	kasan_start_report(&flags);
 	pr_err("BUG: KASAN: double-free or invalid-free in %pS\n", ip);
+	pr_err("\n");
 	print_address_description(object);
+	pr_err("\n");
 	print_shadow_for_address(object);
 	kasan_end_report(&flags);
 }
@@ -336,11 +341,13 @@ static void kasan_report_error(struct ka
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

