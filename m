From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-sparsec-add-note-about-only-vmemmap-supporting-sub-section-hotplug.patch
 added to -mm tree
Date: Thu, 12 Mar 2020 16:41:21 -0700
Message-ID: <20200312234121.RhETSbTWK%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbgCLXlX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Mar 2020 19:41:23 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, dan.j.williams@intel.com, david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, richard.weiyang@gmail.com


The patch titled
     Subject: mm/sparse.c: add note about only VMEMMAP supporting sub-section hotplug
has been added to the -mm tree.  Its filename is
     mm-sparsec-add-note-about-only-vmemmap-supporting-sub-section-hotplug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparsec-add-note-about-only-vmemmap-supporting-sub-section-hotplug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparsec-add-note-about-only-vmemmap-supporting-sub-section-hotplug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/sparse.c: add note about only VMEMMAP supporting sub-section hotplug

And tell check_pfn_span() gating the porper alignment and size of hot
added memory region.

And also move the code comments from inside section_deactivate() to being
above it.  The code comments are reasonable for the whole function, and
the moving makes code cleaner.

Link: http://lkml.kernel.org/r/20200312124414.439-5-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |   38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

--- a/mm/sparse.c~mm-sparsec-add-note-about-only-vmemmap-supporting-sub-section-hotplug
+++ a/mm/sparse.c
@@ -750,6 +750,22 @@ static bool is_subsection_map_empty(stru
 }
 #endif
 
+/*
+ * To deactivate a memory region, there are 3 cases to handle across
+ * two configurations (SPARSEMEM_VMEMMAP={y,n}):
+ *
+ * 1. deactivation of a partial hot-added section (only possible in
+ *    the SPARSEMEM_VMEMMAP=y case).
+ *      a) section was present at memory init.
+ *      b) section was hot-added post memory init.
+ * 2. deactivation of a complete hot-added section.
+ * 3. deactivation of a complete section from memory init.
+ *
+ * For 1, when subsection_map does not empty we will not be freeing the
+ * usage map, but still need to free the vmemmap range.
+ *
+ * For 2 and 3, the SPARSEMEM_VMEMMAP={y,n} cases are unified
+ */
 static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 		struct vmem_altmap *altmap)
 {
@@ -760,23 +776,7 @@ static void section_deactivate(unsigned
 
 	if (clear_subsection_map(pfn, nr_pages))
 		return;
-	/*
-	 * There are 3 cases to handle across two configurations
-	 * (SPARSEMEM_VMEMMAP={y,n}):
-	 *
-	 * 1/ deactivation of a partial hot-added section (only possible
-	 * in the SPARSEMEM_VMEMMAP=y case).
-	 *    a/ section was present at memory init
-	 *    b/ section was hot-added post memory init
-	 * 2/ deactivation of a complete hot-added section
-	 * 3/ deactivation of a complete section from memory init
-	 *
-	 * For 1/, when subsection_map does not empty we will not be
-	 * freeing the usage map, but still need to free the vmemmap
-	 * range.
-	 *
-	 * For 2/ and 3/ the SPARSEMEM_VMEMMAP={y,n} cases are unified
-	 */
+
 	empty = is_subsection_map_empty(ms);
 	if (empty) {
 		unsigned long section_nr = pfn_to_section_nr(pfn);
@@ -884,6 +884,10 @@ static struct page * __meminit section_a
  *
  * This is only intended for hotplug.
  *
+ * Note that only VMEMMAP supports sub-section aligned hotplug,
+ * the proper alignment and size are gated by check_pfn_span().
+ *
+ *
  * Return:
  * * 0		- On success.
  * * -EEXIST	- Section has been present.
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case.patch
mm-sparsec-use-kvmalloc_node-kvfree-to-alloc-free-memmap-for-the-classic-sparse.patch
mm-hotplug-only-respect-mem=-parameter-during-boot-stage.patch
mm-sparsec-introduce-new-function-fill_subsection_map.patch
mm-sparsec-introduce-a-new-function-clear_subsection_map.patch
mm-sparsec-only-use-subsection-map-in-vmemmap-case.patch
mm-sparsec-add-note-about-only-vmemmap-supporting-sub-section-hotplug.patch
mm-sparsec-move-subsection_map-related-functions-together.patch
