From: akpm@linux-foundation.org
Subject: [merged] flex_array-declare-parts-member-to-have-incomplete-type.patch removed from -mm tree
Date: Thu, 27 Aug 2009 12:18:14 -0700
Message-ID: <200908271918.n7RJIENF009839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751593AbZH0TSR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Aug 2009 15:18:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, dave@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     flex_array: declare parts member to have incomplete type
has been removed from the -mm tree.  Its filename was
     flex_array-declare-parts-member-to-have-incomplete-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: flex_array: declare parts member to have incomplete type
From: David Rientjes <rientjes@google.com>

The `parts' member of struct flex_array should evaluate to an incomplete
type so that sizeof() cannot be used and C99 does not require the
zero-length specification.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/flex_array.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/flex_array.h~flex_array-declare-parts-member-to-have-incomplete-type include/linux/flex_array.h
--- a/include/linux/flex_array.h~flex_array-declare-parts-member-to-have-incomplete-type
+++ a/include/linux/flex_array.h
@@ -21,7 +21,7 @@ struct flex_array {
 		struct {
 			int element_size;
 			int total_nr_elements;
-			struct flex_array_part *parts[0];
+			struct flex_array_part *parts[];
 		};
 		/*
 		 * This little trick makes sure that
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

