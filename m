From: akpm@linux-foundation.org
Subject: [merged]
 lib-stackdepot-fix-global-out-of-bounds-in-stack_slabs.patch removed from
 -mm tree
Date: Sun, 23 Feb 2020 16:45:01 -0800
Message-ID: <20200224004501.GAmhlki8G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:40232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727188AbgBXApC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 23 Feb 2020 19:45:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, glider@google.com, gregkh@linuxfoundation.org, jpoimboe@redhat.com, kstewart@linuxfoundation.org, matthias.bgg@gmail.com, mm-commits@vger.kernel.org, stable@vger.kernel.org, tglx@linutronix.de, walter-zh.wu@mediatek.com


The patch titled
     Subject: lib/stackdepot.c: fix global out-of-bounds in stack_slabs
has been removed from the -mm tree.  Its filename was
     lib-stackdepot-fix-global-out-of-bounds-in-stack_slabs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: lib/stackdepot.c: fix global out-of-bounds in stack_slabs

Walter Wu has reported a potential case in which init_stack_slab() is
called after stack_slabs[STACK_ALLOC_MAX_SLABS - 1] has already been
initialized.  In that case init_stack_slab() will overwrite
stack_slabs[STACK_ALLOC_MAX_SLABS], which may result in a memory
corruption.

Link: http://lkml.kernel.org/r/20200218102950.260263-1-glider@google.com
Fixes: cd11016e5f521 ("mm, kasan: stackdepot implementation. Enable stackdepot for SLAB")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: Walter Wu <walter-zh.wu@mediatek.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Kate Stewart <kstewart@linuxfoundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/lib/stackdepot.c~lib-stackdepot-fix-global-out-of-bounds-in-stack_slabs
+++ a/lib/stackdepot.c
@@ -83,15 +83,19 @@ static bool init_stack_slab(void **preal
 		return true;
 	if (stack_slabs[depot_index] == NULL) {
 		stack_slabs[depot_index] = *prealloc;
+		*prealloc = NULL;
 	} else {
-		stack_slabs[depot_index + 1] = *prealloc;
+		/* If this is the last depot slab, do not touch the next one. */
+		if (depot_index + 1 < STACK_ALLOC_MAX_SLABS) {
+			stack_slabs[depot_index + 1] = *prealloc;
+			*prealloc = NULL;
+		}
 		/*
 		 * This smp_store_release pairs with smp_load_acquire() from
 		 * |next_slab_inited| above and in stack_depot_save().
 		 */
 		smp_store_release(&next_slab_inited, 1);
 	}
-	*prealloc = NULL;
 	return true;
 }
 
_

Patches currently in -mm which might be from glider@google.com are

stackdepot-check-depot_index-before-accessing-the-stack-slab.patch
stackdepot-build-with-fno-builtin.patch
kasan-stackdepot-move-filter_irq_stacks-to-stackdepotc.patch
