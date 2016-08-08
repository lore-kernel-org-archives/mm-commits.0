From: akpm@linux-foundation.org
Subject: [merged] slub-drop-bogus-inline-for-fixup_red_left.patch removed
 from -mm tree
Date: Mon, 08 Aug 2016 13:15:15 -0700
Message-ID: <57a8e853.WvnozLhG8/1f5mpj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37366 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbcHHUPQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Aug 2016 16:15:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: geert@linux-m68k.org, glider@google.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: drop bogus inline for fixup_red_left()
has been removed from the -mm tree.  Its filename was
     slub-drop-bogus-inline-for-fixup_red_left.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: slub: drop bogus inline for fixup_red_left()

With m68k-linux-gnu-gcc-4.1:

    include/linux/slub_def.h:126: warning: `fixup_red_left' declared inline after being called
    include/linux/slub_def.h:126: warning: previous declaration of `fixup_red_left' was here

Commit c146a2b98eb5898e ("mm, kasan: account for object redzone in SLUB's
nearest_obj()") made fixup_red_left() global, but forgot to remove the
inline keyword.

Fixes: c146a2b98eb5898e ("mm, kasan: account for object redzone in SLUB's nearest_obj()")
Link: http://lkml.kernel.org/r/1470256262-1586-1-git-send-email-geert@linux-m68k.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Alexander Potapenko <glider@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-drop-bogus-inline-for-fixup_red_left mm/slub.c
--- a/mm/slub.c~slub-drop-bogus-inline-for-fixup_red_left
+++ a/mm/slub.c
@@ -124,7 +124,7 @@ static inline int kmem_cache_debug(struc
 #endif
 }
 
-inline void *fixup_red_left(struct kmem_cache *s, void *p)
+void *fixup_red_left(struct kmem_cache *s, void *p)
 {
 	if (kmem_cache_debug(s) && s->flags & SLAB_RED_ZONE)
 		p += s->red_left_pad;
_

Patches currently in -mm which might be from geert@linux-m68k.org are

mm-oom-fix-uninitialized-ret-in-task_will_free_mem.patch

