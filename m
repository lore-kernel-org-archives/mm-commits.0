From: akpm@linux-foundation.org
Subject: [merged] mm-kasan-fix-compilation-for-config_slab.patch removed
 from -mm tree
Date: Mon, 04 Apr 2016 11:09:32 -0700
Message-ID: <5702addc.8T1RPWw4yIdoSghu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56924 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbcDDSJd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Apr 2016 14:09:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, adech.fo@gmail.com, cl@linux.com, dvyukov@google.com, iamjoonsoo.kim@lge.com, kcc@google.com, rostedt@goodmis.org, ryabinin.a.a@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, kasan: fix compilation for CONFIG_SLAB
has been removed from the -mm tree.  Its filename was
     mm-kasan-fix-compilation-for-config_slab.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: mm, kasan: fix compilation for CONFIG_SLAB

Add the missing argument to set_track().

Fixes: cd11016e5f52 ("mm, kasan: stackdepot implementation. Enable stackdepot for SLAB")
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <adech.fo@gmail.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Konstantin Serebryany <kcc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/kasan/kasan.c~mm-kasan-fix-compilation-for-config_slab mm/kasan/kasan.c
--- a/mm/kasan/kasan.c~mm-kasan-fix-compilation-for-config_slab
+++ a/mm/kasan/kasan.c
@@ -498,7 +498,7 @@ void kasan_slab_free(struct kmem_cache *
 		struct kasan_alloc_meta *alloc_info =
 			get_alloc_info(cache, object);
 		alloc_info->state = KASAN_STATE_FREE;
-		set_track(&free_info->track);
+		set_track(&free_info->track, GFP_NOWAIT);
 	}
 #endif
 
_

Patches currently in -mm which might be from glider@google.com are

mm-kasan-initial-memory-quarantine-implementation.patch
mm-kasan-initial-memory-quarantine-implementation-v8.patch

