From: akpm@linux-foundation.org
Subject: + flex_array-poison-free-elements.patch added to -mm tree
Date: Fri, 21 Aug 2009 16:49:47 -0700
Message-ID: <200908212349.n7LNnmEt002317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58252 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932374AbZHUXtv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Aug 2009 19:49:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, dave@linux.vnet.ibm.com


The patch titled
     flex_array: poison free elements
has been added to the -mm tree.  Its filename is
     flex_array-poison-free-elements.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flex_array: poison free elements
From: David Rientjes <rientjes@google.com>

Newly initialized flex_array's and/or flex_array_part's are now poisoned
with a new poison value, FLEX_ARRAY_FREE.  It's value is similar to
POISON_FREE used in the various slab allocators, but is different to
distinguish between flex array's poisoned kmem and slab allocator poisoned
kmem.

This will allow us to identify flex_array_part's that only contain free
elements (and free them with an addition to the flex_array API).  This
could also be extended in the future to identify `get' uses on elements
that have not been `put'.

If __GFP_ZERO is passed for a part's gfp mask, the poisoning is avoided. 
These elements are considered to be in-use since they have been
initialized.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/poison.h |    3 +++
 lib/flex_array.c       |   15 +++++++--------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff -puN include/linux/poison.h~flex_array-poison-free-elements include/linux/poison.h
--- a/include/linux/poison.h~flex_array-poison-free-elements
+++ a/include/linux/poison.h
@@ -77,6 +77,9 @@
 #define MUTEX_DEBUG_INIT	0x11
 #define MUTEX_DEBUG_FREE	0x22
 
+/********** lib/flex_array.c **********/
+#define FLEX_ARRAY_FREE	0x6c	/* for use-after-free poisoning */
+
 /********** security/ **********/
 #define KEY_DESTROY		0xbd
 
diff -puN lib/flex_array.c~flex_array-poison-free-elements lib/flex_array.c
--- a/lib/flex_array.c~flex_array-poison-free-elements
+++ a/lib/flex_array.c
@@ -113,6 +113,8 @@ struct flex_array *flex_array_alloc(int 
 		return NULL;
 	ret->element_size = element_size;
 	ret->total_nr_elements = total;
+	if (elements_fit_in_base(ret) && !(flags & __GFP_ZERO))
+		memset(ret->parts[0], FLEX_ARRAY_FREE, bytes_left_in_base());
 	return ret;
 }
 
@@ -159,15 +161,12 @@ __fa_get_part(struct flex_array *fa, int
 {
 	struct flex_array_part *part = fa->parts[part_nr];
 	if (!part) {
-		/*
-		 * This leaves the part pages uninitialized
-		 * and with potentially random data, just
-		 * as if the user had kmalloc()'d the whole.
-		 * __GFP_ZERO can be used to zero it.
-		 */
-		part = kmalloc(FLEX_ARRAY_PART_SIZE, flags);
+		part = kmalloc(sizeof(struct flex_array_part), flags);
 		if (!part)
 			return NULL;
+		if (!(flags & __GFP_ZERO))
+			memset(part, FLEX_ARRAY_FREE,
+				sizeof(struct flex_array_part));
 		fa->parts[part_nr] = part;
 	}
 	return part;
@@ -228,7 +227,7 @@ int flex_array_clear(struct flex_array *
 			return -EINVAL;
 	}
 	dst = &part->elements[index_inside_part(fa, element_nr)];
-	memset(dst, 0, fa->element_size);
+	memset(dst, FLEX_ARRAY_FREE, fa->element_size);
 	return 0;
 }
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
flex_array-fix-get-function-for-elements-in-base-starting-at-non-zero.patch
flex_array-fix-flex_array_free_parts-comment.patch
flex_array-declare-parts-member-to-have-incomplete-type.patch
flex_array-convert-element_nr-formals-to-unsigned.patch
flex_array-add-flex_array_clear-function.patch
flex_array-poison-free-elements.patch
flex_array-add-flex_array_shrink-function.patch
mm-remove-obsoleted-alloc_pages-cpuset-comment.patch
hugetlb-balance-freeing-of-huge-pages-across-nodes.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages.patch
hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-clean-up-and-update-huge-pages-documentation.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-update-alloc_flags-after-oom-killer-has-been-called.patch
pagemap-clear_refs-modify-to-specify-anon-or-mapped-vma-clearing.patch
oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong.patch
fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

