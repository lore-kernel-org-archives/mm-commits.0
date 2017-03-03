From: akpm@linux-foundation.org
Subject: + kasan-change-allocation-and-freeing-stack-traces-headers.patch
 added to -mm tree
Date: Fri, 03 Mar 2017 15:23:40 -0800
Message-ID: <58b9fafc.zcPcsDb8DZY93OQR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50506 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752184AbdCCXXx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 18:23:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: change allocation and freeing stack traces headers
has been added to the -mm tree.  Its filename is
     kasan-change-allocation-and-freeing-stack-traces-headers.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-change-allocation-and-freeing-stack-traces-headers.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-change-allocation-and-freeing-stack-traces-headers.patch

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
Subject: kasan: change allocation and freeing stack traces headers

Change stack traces headers from:

Allocated:
PID = 42

to:

Allocated by task 42:

Makes the report one line shorter and look better.

Link: http://lkml.kernel.org/r/20170302134851.101218-4-andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN mm/kasan/report.c~kasan-change-allocation-and-freeing-stack-traces-headers mm/kasan/report.c
--- a/mm/kasan/report.c~kasan-change-allocation-and-freeing-stack-traces-headers
+++ a/mm/kasan/report.c
@@ -175,9 +175,9 @@ static void kasan_end_report(unsigned lo
 	kasan_enable_current();
 }
 
-static void print_track(struct kasan_track *track)
+static void print_track(struct kasan_track *track, const char *prefix)
 {
-	pr_err("PID = %u\n", track->pid);
+	pr_err("%s by task %u:\n", prefix, track->pid);
 	if (track->stack) {
 		struct stack_trace trace;
 
@@ -199,10 +199,8 @@ static void kasan_object_err(struct kmem
 	if (!(cache->flags & SLAB_KASAN))
 		return;
 
-	pr_err("Allocated:\n");
-	print_track(&alloc_info->alloc_track);
-	pr_err("Freed:\n");
-	print_track(&alloc_info->free_track);
+	print_track(&alloc_info->alloc_track, "Allocated");
+	print_track(&alloc_info->free_track, "Freed");
 }
 
 void kasan_report_double_free(struct kmem_cache *cache, void *object,
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

