From: akpm@linux-foundation.org
Subject: + lib-rbtreec-avoid-the-use-of-non-static-__always_inline.patch added to -mm tree
Date: Fri, 11 Jan 2013 13:25:13 -0800
Message-ID: <20130111212514.24EF820004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:53477 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261Ab3AKVZQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Jan 2013 16:25:16 -0500
Received: by mail-wg0-f74.google.com with SMTP id dt14so133329wgb.5
        for <mm-commits@vger.kernel.org>; Fri, 11 Jan 2013 13:25:15 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, fengguang.wu@intel.com


The patch titled
     Subject: lib/rbtree.c: avoid the use of non-static __always_inline
has been added to the -mm tree.  Its filename is
     lib-rbtreec-avoid-the-use-of-non-static-__always_inline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: lib/rbtree.c: avoid the use of non-static __always_inline

lib/rbtree.c declared __rb_erase_color() as __always_inline void, and then
exported it with EXPORT_SYMBOL.  This was because __rb_erase_color() must
be exported for augmented rbtree users, but it must also be inlined into
rb_erase() so that the dummy callback can get optimized out of that call
site.

(Actually with a modern compiler, none of the dummy callback functions
should even be generated as separate text functions).

The above usage is legal C, but it was unusual enough for some compilers
to warn about it.  This change makes things more explicit, with a static
__always_inline ____rb_erase_color function for use in rb_erase(), and a
separate non-inline __rb_erase_color function for use in
rb_erase_augmented call sites.

Signed-off-by: Michel Lespinasse <walken@google.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rbtree_augmented.h |   14 +++++++++++---
 lib/rbtree.c                     |   20 +++++++++++++++++---
 2 files changed, 28 insertions(+), 6 deletions(-)

diff -puN include/linux/rbtree_augmented.h~lib-rbtreec-avoid-the-use-of-non-static-__always_inline include/linux/rbtree_augmented.h
--- a/include/linux/rbtree_augmented.h~lib-rbtreec-avoid-the-use-of-non-static-__always_inline
+++ a/include/linux/rbtree_augmented.h
@@ -123,9 +123,9 @@ __rb_change_child(struct rb_node *old, s
 extern void __rb_erase_color(struct rb_node *parent, struct rb_root *root,
 	void (*augment_rotate)(struct rb_node *old, struct rb_node *new));
 
-static __always_inline void
-rb_erase_augmented(struct rb_node *node, struct rb_root *root,
-		   const struct rb_augment_callbacks *augment)
+static __always_inline struct rb_node *
+__rb_erase_augmented(struct rb_node *node, struct rb_root *root,
+		     const struct rb_augment_callbacks *augment)
 {
 	struct rb_node *child = node->rb_right, *tmp = node->rb_left;
 	struct rb_node *parent, *rebalance;
@@ -217,6 +217,14 @@ rb_erase_augmented(struct rb_node *node,
 	}
 
 	augment->propagate(tmp, NULL);
+	return rebalance;
+}
+
+static __always_inline void
+rb_erase_augmented(struct rb_node *node, struct rb_root *root,
+		   const struct rb_augment_callbacks *augment)
+{
+	struct rb_node *rebalance = __rb_erase_augmented(node, root, augment);
 	if (rebalance)
 		__rb_erase_color(rebalance, root, augment->rotate);
 }
diff -puN lib/rbtree.c~lib-rbtreec-avoid-the-use-of-non-static-__always_inline lib/rbtree.c
--- a/lib/rbtree.c~lib-rbtreec-avoid-the-use-of-non-static-__always_inline
+++ a/lib/rbtree.c
@@ -194,8 +194,12 @@ __rb_insert(struct rb_node *node, struct
 	}
 }
 
-__always_inline void
-__rb_erase_color(struct rb_node *parent, struct rb_root *root,
+/*
+ * Inline version for rb_erase() use - we want to be able to inline
+ * and eliminate the dummy_rotate callback there
+ */
+static __always_inline void
+____rb_erase_color(struct rb_node *parent, struct rb_root *root,
 	void (*augment_rotate)(struct rb_node *old, struct rb_node *new))
 {
 	struct rb_node *node = NULL, *sibling, *tmp1, *tmp2;
@@ -355,6 +359,13 @@ __rb_erase_color(struct rb_node *parent,
 		}
 	}
 }
+
+/* Non-inline version for rb_erase_augmented() use */
+void __rb_erase_color(struct rb_node *parent, struct rb_root *root,
+	void (*augment_rotate)(struct rb_node *old, struct rb_node *new))
+{
+	____rb_erase_color(parent, root, augment_rotate);
+}
 EXPORT_SYMBOL(__rb_erase_color);
 
 /*
@@ -380,7 +391,10 @@ EXPORT_SYMBOL(rb_insert_color);
 
 void rb_erase(struct rb_node *node, struct rb_root *root)
 {
-	rb_erase_augmented(node, root, &dummy_callbacks);
+	struct rb_node *rebalance;
+	rebalance = __rb_erase_augmented(node, root, &dummy_callbacks);
+	if (rebalance)
+		____rb_erase_color(rebalance, root, dummy_rotate);
 }
 EXPORT_SYMBOL(rb_erase);
 
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
lib-rbtreec-avoid-the-use-of-non-static-__always_inline.patch
mm-make-mlockall-preserve-flags-other-than-vm_locked-in-def_flags.patch
mm-remap_file_pages-fixes.patch
mm-introduce-mm_populate-for-populating-new-vmas.patch
mm-use-mm_populate-for-blocking-remap_file_pages.patch
mm-use-mm_populate-when-adjusting-brk-with-mcl_future-in-effect.patch
mm-use-mm_populate-for-mremap-of-vm_locked-vmas.patch
mm-remove-flags-argument-to-mmap_region.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma.patch
mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs.patch
mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch
mutex-subsystem-synchro-test-module.patch

