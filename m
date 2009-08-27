From: akpm@linux-foundation.org
Subject: [merged] flex_array-fix-get-function-for-elements-in-base-starting-at-non-zero.patch removed from -mm tree
Date: Thu, 27 Aug 2009 12:18:10 -0700
Message-ID: <200908271918.n7RJIAKr009805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460AbZH0TSP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Aug 2009 15:18:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, dave@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     flex_array: fix get function for elements in base starting at non-zero
has been removed from the -mm tree.  Its filename was
     flex_array-fix-get-function-for-elements-in-base-starting-at-non-zero.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flex_array: fix get function for elements in base starting at non-zero
From: David Rientjes <rientjes@google.com>

If all array elements fit into the base structure and data is copied using
flex_array_put() starting at a non-zero index, flex_array_get() will fail
to return the data.

This fixes the bug by only checking for NULL parts when all elements do
not fit in the base structure when flex_array_get() is used.  Otherwise,
fa_element_to_part_nr() will always be 0 since there are no parts
structures needed and such element may never have been put.  Thus, it will
remain NULL due to the kzalloc() of the base.

Additionally, flex_array_put() now only checks for a NULL part when all
elements do not fit in the base structure.  This is otherwise unnecessary
since the base structure is guaranteed to exist (or we would have already
hit a NULL pointer).

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/flex_array.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN lib/flex_array.c~flex_array-fix-get-function-for-elements-in-base-starting-at-non-zero lib/flex_array.c
--- a/lib/flex_array.c~flex_array-fix-get-function-for-elements-in-base-starting-at-non-zero
+++ a/lib/flex_array.c
@@ -198,10 +198,11 @@ int flex_array_put(struct flex_array *fa
 		return -ENOSPC;
 	if (elements_fit_in_base(fa))
 		part = (struct flex_array_part *)&fa->parts[0];
-	else
+	else {
 		part = __fa_get_part(fa, part_nr, flags);
-	if (!part)
-		return -ENOMEM;
+		if (!part)
+			return -ENOMEM;
+	}
 	dst = &part->elements[index_inside_part(fa, element_nr)];
 	memcpy(dst, src, fa->element_size);
 	return 0;
@@ -257,11 +258,12 @@ void *flex_array_get(struct flex_array *
 
 	if (element_nr >= fa->total_nr_elements)
 		return NULL;
-	if (!fa->parts[part_nr])
-		return NULL;
 	if (elements_fit_in_base(fa))
 		part = (struct flex_array_part *)&fa->parts[0];
-	else
+	else {
 		part = fa->parts[part_nr];
+		if (!part)
+			return NULL;
+	}
 	return &part->elements[index_inside_part(fa, element_nr)];
 }
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
linux-next.patch
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
hugetlbfs-allow-the-creation-of-files-suitable-for-map_private-on-the-vfs-internal-mount.patch
hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch
hugetlb-add-map_hugetlb-example.patch
flex_array-add-flex_array_clear-function.patch
flex_array-poison-free-elements.patch
flex_array-add-flex_array_shrink-function.patch
fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

