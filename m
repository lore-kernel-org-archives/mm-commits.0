From: akpm@linux-foundation.org
Subject: [patch 015/111] mm/kasan: get rid of ->alloc_size in struct
 kasan_alloc_meta
Date: Tue, 02 Aug 2016 14:02:49 -0700
Message-ID: <57a10a79.fkJ+92+l4X7FlYmt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbcHBVNv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:13:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, aryabinin@virtuozzo.com, dvyukov@google.com, glider@google.com

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
