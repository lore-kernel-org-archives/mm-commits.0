From: akpm@linux-foundation.org
Subject: [patch 096/102] kasan: change allocation and freeing stack
 traces headers
Date: Wed, 03 May 2017 14:56:31 -0700
Message-ID: <20170503215631.u3AyqxVvu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52852 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbdECV5b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:57:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreyknvl@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
@@ -177,9 +177,9 @@ static void kasan_end_report(unsigned lo
 	kasan_enable_current();
 }
 
-static void print_track(struct kasan_track *track)
+static void print_track(struct kasan_track *track, const char *prefix)
 {
-	pr_err("PID = %u\n", track->pid);
+	pr_err("%s by task %u:\n", prefix, track->pid);
 	if (track->stack) {
 		struct stack_trace trace;
 
@@ -201,10 +201,8 @@ static void kasan_object_err(struct kmem
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
