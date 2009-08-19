From: akpm@linux-foundation.org
Subject: + flex_array-fix-get-function-for-elements-in-base-starting-at-non-zero.patch added to -mm tree
Date: Wed, 19 Aug 2009 13:53:55 -0700
Message-ID: <200908192053.n7JKrtP8016122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835AbZHSUyJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 Aug 2009 16:54:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, dave@linux.vnet.ibm.com


The patch titled
     flex_array: fix get function for elements in base starting at non-zero
has been added to the -mm tree.  Its filename is
     flex_array-fix-get-function-for-elements-in-base-starting-at-non-zero.patch

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

mm-revert-oom-move-oom_adj-value.patch
linux-next.patch
flex_array-fix-get-function-for-elements-in-base-starting-at-non-zero.patch
flex_array-fix-flex_array_free_parts-comment.patch
flex_array-declare-parts-member-to-have-incomplete-type.patch
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
fs-proc-task_mmuc-v1-fix-clear_refs_write-input-sanity-check.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

