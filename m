From: akpm@linux-foundation.org
Subject: + idr-rename-max_level-to-max_idr_level.patch added to -mm tree
Date: Wed, 12 Sep 2012 12:09:05 -0700
Message-ID: <20120912190906.0FE905C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:47531 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2ILTJJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Sep 2012 15:09:09 -0400
Received: by lbbge1 with SMTP id ge1so145418lbb.1
        for <mm-commits@vger.kernel.org>; Wed, 12 Sep 2012 12:09:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fengguang.wu@intel.com, bernd@petrovitsch.priv.at, glommer@parallels.com, wharms@bfs.de


The patch titled
     Subject: idr: rename MAX_LEVEL to MAX_IDR_LEVEL
has been added to the -mm tree.  Its filename is
     idr-rename-max_level-to-max_idr_level.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: idr: rename MAX_LEVEL to MAX_IDR_LEVEL

To avoid name conflicts:

drivers/video/riva/fbdev.c:281:9: sparse: preprocessor token MAX_LEVEL redefined

While at it, also make the other names more consistent and add
parentheses.

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Cc: walter harms <wharms@bfs.de>
Cc: Glauber Costa <glommer@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/idr.h |   10 +++++-----
 lib/idr.c           |   18 +++++++++---------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff -puN include/linux/idr.h~idr-rename-max_level-to-max_idr_level include/linux/idr.h
--- a/include/linux/idr.h~idr-rename-max_level-to-max_idr_level
+++ a/include/linux/idr.h
@@ -38,15 +38,15 @@
 #define IDR_SIZE (1 << IDR_BITS)
 #define IDR_MASK ((1 << IDR_BITS)-1)
 
-#define MAX_ID_SHIFT (sizeof(int)*8 - 1)
-#define MAX_ID_BIT (1U << MAX_ID_SHIFT)
-#define MAX_ID_MASK (MAX_ID_BIT - 1)
+#define MAX_IDR_SHIFT (sizeof(int)*8 - 1)
+#define MAX_IDR_BIT (1U << MAX_IDR_SHIFT)
+#define MAX_IDR_MASK (MAX_IDR_BIT - 1)
 
 /* Leave the possibility of an incomplete final layer */
-#define MAX_LEVEL (MAX_ID_SHIFT + IDR_BITS - 1) / IDR_BITS
+#define MAX_IDR_LEVEL ((MAX_IDR_SHIFT + IDR_BITS - 1) / IDR_BITS)
 
 /* Number of id_layer structs to leave in free list */
-#define IDR_FREE_MAX MAX_LEVEL + MAX_LEVEL
+#define MAX_IDR_FREE (MAX_IDR_LEVEL * 2)
 
 struct idr_layer {
 	unsigned long		 bitmap; /* A zero bit means "space here" */
diff -puN lib/idr.c~idr-rename-max_level-to-max_idr_level lib/idr.c
--- a/lib/idr.c~idr-rename-max_level-to-max_idr_level
+++ a/lib/idr.c
@@ -20,7 +20,7 @@
  * that id to this code and it returns your pointer.
 
  * You can release ids at any time. When all ids are released, most of
- * the memory is returned (we keep IDR_FREE_MAX) in a local pool so we
+ * the memory is returned (we keep MAX_IDR_FREE) in a local pool so we
  * don't need to go to the memory "store" during an id allocate, just
  * so you don't need to be too concerned about locking and conflicts
  * with the slab allocator.
@@ -122,7 +122,7 @@ static void idr_mark_full(struct idr_lay
  */
 int idr_pre_get(struct idr *idp, gfp_t gfp_mask)
 {
-	while (idp->id_free_cnt < IDR_FREE_MAX) {
+	while (idp->id_free_cnt < MAX_IDR_FREE) {
 		struct idr_layer *new;
 		new = kmem_cache_zalloc(idr_layer_cache, gfp_mask);
 		if (new == NULL)
@@ -179,7 +179,7 @@ static int sub_alloc(struct idr *idp, in
 			sh = IDR_BITS*l;
 			id = ((id >> sh) ^ n ^ m) << sh;
 		}
-		if ((id >= MAX_ID_BIT) || (id < 0))
+		if ((id >= MAX_IDR_BIT) || (id < 0))
 			return IDR_NOMORE_SPACE;
 		if (l == 0)
 			break;
@@ -402,7 +402,7 @@ void idr_remove(struct idr *idp, int id)
 	struct idr_layer *to_free;
 
 	/* Mask off upper bits we don't use for the search. */
-	id &= MAX_ID_MASK;
+	id &= MAX_IDR_MASK;
 
 	sub_remove(idp, (idp->layers - 1) * IDR_BITS, id);
 	if (idp->top && idp->top->count == 1 && (idp->layers > 1) &&
@@ -420,7 +420,7 @@ void idr_remove(struct idr *idp, int id)
 		to_free->bitmap = to_free->count = 0;
 		free_layer(to_free);
 	}
-	while (idp->id_free_cnt >= IDR_FREE_MAX) {
+	while (idp->id_free_cnt >= MAX_IDR_FREE) {
 		p = get_from_free_list(idp);
 		/*
 		 * Note: we don't call the rcu callback here, since the only
@@ -517,7 +517,7 @@ void *idr_find(struct idr *idp, int id)
 	n = (p->layer+1) * IDR_BITS;
 
 	/* Mask off upper bits we don't use for the search. */
-	id &= MAX_ID_MASK;
+	id &= MAX_IDR_MASK;
 
 	if (id >= (1 << n))
 		return NULL;
@@ -659,7 +659,7 @@ void *idr_replace(struct idr *idp, void 
 
 	n = (p->layer+1) * IDR_BITS;
 
-	id &= MAX_ID_MASK;
+	id &= MAX_IDR_MASK;
 
 	if (id >= (1 << n))
 		return ERR_PTR(-EINVAL);
@@ -793,7 +793,7 @@ int ida_get_new_above(struct ida *ida, i
 	if (t < 0)
 		return _idr_rc_to_errno(t);
 
-	if (t * IDA_BITMAP_BITS >= MAX_ID_BIT)
+	if (t * IDA_BITMAP_BITS >= MAX_IDR_BIT)
 		return -ENOSPC;
 
 	if (t != idr_id)
@@ -827,7 +827,7 @@ int ida_get_new_above(struct ida *ida, i
 	}
 
 	id = idr_id * IDA_BITMAP_BITS + t;
-	if (id >= MAX_ID_BIT)
+	if (id >= MAX_IDR_BIT)
 		return -ENOSPC;
 
 	__set_bit(t, bitmap->bitmap);
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

idr-rename-max_level-to-max_idr_level.patch
linux-next.patch
h8300-select-generic-atomic64_t-support.patch
unicore32-select-generic-atomic64_t-support.patch
readahead-fault-retry-breaks-mmap-file-read-random-detection.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
rbtree-performance-and-correctness-test-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
score-select-generic-atomic64_t-support.patch

