From: akpm@linux-foundation.org
Subject: [merged]
 slub-avoid-redzone-when-choosing-freepointer-location.patch removed from
 -mm tree
Date: Thu, 23 Apr 2020 12:51:27 -0700
Message-ID: <20200423195127.zgcnkj1Zb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbgDWTv2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 23 Apr 2020 15:51:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, elver@google.com, iamjoonsoo.kim@lge.com, keescook@chromium.org, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com


The patch titled
     Subject: slub: avoid redzone when choosing freepointer location
has been removed from the -mm tree.  Its filename was
     slub-avoid-redzone-when-choosing-freepointer-location.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: slub: avoid redzone when choosing freepointer location

Marco Elver reported system crashes when booting with "slub_debug=Z".  The
freepointer location (s->offset) was not taking into account that the
"inuse" size that includes the redzone area should not be used by the
freelist pointer.  Change the calculation to save the area of the object
that an inline freepointer may be written into.

Link: http://lkml.kernel.org/r/202004151054.BD695840@keescook
Link: https://lore.kernel.org/linux-mm/20200415164726.GA234932@google.com
Fixes: 3202fa62fb43 ("slub: relocate freelist pointer to middle of object")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reported-by: Marco Elver <elver@google.com>
Tested-by: Marco Elver <elver@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/slub.c~slub-avoid-redzone-when-choosing-freepointer-location
+++ a/mm/slub.c
@@ -3533,6 +3533,7 @@ static int calculate_sizes(struct kmem_c
 {
 	slab_flags_t flags = s->flags;
 	unsigned int size = s->object_size;
+	unsigned int freepointer_area;
 	unsigned int order;
 
 	/*
@@ -3541,6 +3542,13 @@ static int calculate_sizes(struct kmem_c
 	 * the possible location of the free pointer.
 	 */
 	size = ALIGN(size, sizeof(void *));
+	/*
+	 * This is the area of the object where a freepointer can be
+	 * safely written. If redzoning adds more to the inuse size, we
+	 * can't use that portion for writing the freepointer, so
+	 * s->offset must be limited within this for the general case.
+	 */
+	freepointer_area = size;
 
 #ifdef CONFIG_SLUB_DEBUG
 	/*
@@ -3582,13 +3590,13 @@ static int calculate_sizes(struct kmem_c
 		 */
 		s->offset = size;
 		size += sizeof(void *);
-	} else if (size > sizeof(void *)) {
+	} else if (freepointer_area > sizeof(void *)) {
 		/*
 		 * Store freelist pointer near middle of object to keep
 		 * it away from the edges of the object to avoid small
 		 * sized over/underflows from neighboring allocations.
 		 */
-		s->offset = ALIGN(size / 2, sizeof(void *));
+		s->offset = ALIGN(freepointer_area / 2, sizeof(void *));
 	}
 
 #ifdef CONFIG_SLUB_DEBUG
_

Patches currently in -mm which might be from keescook@chromium.org are
