From: akpm@linux-foundation.org
Subject: + mm-kasan-get-rid-of-alloc_size-in-struct-kasan_alloc_meta.patch added to -mm tree
Date: Mon, 01 Aug 2016 13:16:14 -0700
Message-ID: <579fae0e.qHyVNOwoZxHxhXDx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41288 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028AbcHAUlt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Aug 2016 16:41:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kasan: get rid of ->alloc_size in struct kasan_alloc_meta
has been added to the -mm tree.  Its filename is
     mm-kasan-get-rid-of-alloc_size-in-struct-kasan_alloc_meta.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kasan-get-rid-of-alloc_size-in-struct-kasan_alloc_meta.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kasan-get-rid-of-alloc_size-in-struct-kasan_alloc_meta.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: mm/kasan: get rid of ->alloc_size in struct kasan_alloc_meta

Size of slab object already stored in cache->object_size.

Note, that kmalloc() internally rounds up size of allocation, so
object_size may be not equal to alloc_size, but, usually we don't need
to know the exact size of allocated object. In case if we need that
information, we still can figure it out from the report. The dump of
shadow memory allows to identify the end of allocated memory, and thereby
the exact allocation size.

Link: http://lkml.kernel.org/r/1470062715-14077-4-git-send-email-aryabinin@virtuozzo.com
Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c  |    1 -
 mm/kasan/kasan.h  |    3 +--
 mm/kasan/report.c |    8 +++-----
 3 files changed, 4 insertions(+), 8 deletions(-)

diff -puN mm/kasan/kasan.c~mm-kasan-get-rid-of-alloc_size-in-struct-kasan_alloc_meta mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-kasan-get-rid-of-alloc_size-in-struct-kasan_alloc_meta
+++ a/mm/kasan/kasan.c
@@ -584,7 +584,6 @@ void kasan_kmalloc(struct kmem_cache *ca
 			get_alloc_info(cache, object);
 
 		alloc_info->state = KASAN_STATE_ALLOC;
-		alloc_info->alloc_size = size;
 		set_track(&alloc_info->track, flags);
 	}
 }
diff -puN mm/kasan/kasan.h~mm-kasan-get-rid-of-alloc_size-in-struct-kasan_alloc_meta mm/kasan/kasan.h
--- a/mm/kasan/kasan.h~mm-kasan-get-rid-of-alloc_size-in-struct-kasan_alloc_meta
+++ a/mm/kasan/kasan.h
@@ -75,8 +75,7 @@ struct kasan_track {
 
 struct kasan_alloc_meta {
 	struct kasan_track track;
-	u32 state : 2;	/* enum kasan_state */
-	u32 alloc_size : 30;
+	u32 state;
 };
 
 struct qlist_node {
diff -puN mm/kasan/report.c~mm-kasan-get-rid-of-alloc_size-in-struct-kasan_alloc_meta mm/kasan/report.c
--- a/mm/kasan/report.c~mm-kasan-get-rid-of-alloc_size-in-struct-kasan_alloc_meta
+++ a/mm/kasan/report.c
@@ -136,7 +136,9 @@ static void kasan_object_err(struct kmem
 	struct kasan_free_meta *free_info;
 
 	dump_stack();
-	pr_err("Object at %p, in cache %s\n", object, cache->name);
+	pr_err("Object at %p, in cache %s size: %d\n", object, cache->name,
+		cache->object_size);
+
 	if (!(cache->flags & SLAB_KASAN))
 		return;
 	switch (alloc_info->state) {
@@ -144,15 +146,11 @@ static void kasan_object_err(struct kmem
 		pr_err("Object not allocated yet\n");
 		break;
 	case KASAN_STATE_ALLOC:
-		pr_err("Object allocated with size %u bytes.\n",
-		       alloc_info->alloc_size);
 		pr_err("Allocation:\n");
 		print_track(&alloc_info->track);
 		break;
 	case KASAN_STATE_FREE:
 	case KASAN_STATE_QUARANTINE:
-		pr_err("Object freed, allocated with size %u bytes\n",
-		       alloc_info->alloc_size);
 		free_info = get_free_info(cache, object);
 		pr_err("Allocation:\n");
 		print_track(&alloc_info->track);
_

Patches currently in -mm which might be from aryabinin@virtuozzo.com are

mm-kasan-fix-corruptions-and-false-positive-reports.patch
mm-kasan-dont-reduce-quarantine-in-atomic-contexts.patch
mm-kasan-slub-dont-disable-interrupts-when-object-leaves-quarantine.patch
mm-kasan-get-rid-of-alloc_size-in-struct-kasan_alloc_meta.patch
mm-kasan-get-rid-of-state-in-struct-kasan_alloc_meta.patch
kasan-improve-double-free-reports.patch

