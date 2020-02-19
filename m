From: akpm@linux-foundation.org
Subject: +
 mm-sparse-rename-pfn_present-as-pfn_in_present_section.patch added to -mm
 tree
Date: Wed, 19 Feb 2020 15:08:56 -0800
Message-ID: <20200219230856.mAC1E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgBSXI5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 19 Feb 2020 18:08:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rafael@kernel.org, paulus@samba.org, nfont@linux.vnet.ibm.com, nathanl@linux.ibm.com, mpe@ellerman.id.au, mhocko@kernel.org, leonardo@linux.ibm.com, gregkh@linuxfoundation.org, david@redhat.com, dan.j.williams@intel.com, benh@kernel.crashing.org, kernelfans@gmail.com


The patch titled
     Subject: mm/sparse: rename pfn_present() to pfn_in_present_section()
has been added to the -mm tree.  Its filename is
     mm-sparse-rename-pfn_present-as-pfn_in_present_section.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-sparse-rename-pfn_present-as-pfn_in_present_section.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-sparse-rename-pfn_present-as-pfn_in_present_section.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pingfan Liu <kernelfans@gmail.com>
Subject: mm/sparse: rename pfn_present() to pfn_in_present_section()

After introducing mem sub section concept, pfn_present() loses its literal
meaning, and will not be necessary a truth on partial populated mem
section.

Since all of the callers use it to judge an absent section, it is better
to rename pfn_present() as pfn_in_present_section().

Link: http://lkml.kernel.org/r/1581919110-29575-1-git-send-email-kernelfans@gmail.com
Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>		[powerpc]
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Leonardo Bras <leonardo@linux.ibm.com>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/hotplug-memory.c |    2 +-
 drivers/base/node.c                             |    2 +-
 include/linux/mmzone.h                          |    4 ++--
 mm/page_ext.c                                   |    2 +-
 mm/shuffle.c                                    |    2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/powerpc/platforms/pseries/hotplug-memory.c~mm-sparse-rename-pfn_present-as-pfn_in_present_section
+++ a/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -360,7 +360,7 @@ static bool lmb_is_removable(struct drme
 
 	for (i = 0; i < scns_per_block; i++) {
 		pfn = PFN_DOWN(phys_addr);
-		if (!pfn_present(pfn)) {
+		if (!pfn_in_present_section(pfn)) {
 			phys_addr += MIN_MEMORY_BLOCK_SIZE;
 			continue;
 		}
--- a/drivers/base/node.c~mm-sparse-rename-pfn_present-as-pfn_in_present_section
+++ a/drivers/base/node.c
@@ -772,7 +772,7 @@ static int register_mem_sect_under_node(
 		 * memory block could have several absent sections from start.
 		 * skip pfn range from absent section
 		 */
-		if (!pfn_present(pfn)) {
+		if (!pfn_in_present_section(pfn)) {
 			pfn = round_down(pfn + PAGES_PER_SECTION,
 					 PAGES_PER_SECTION) - 1;
 			continue;
--- a/include/linux/mmzone.h~mm-sparse-rename-pfn_present-as-pfn_in_present_section
+++ a/include/linux/mmzone.h
@@ -1374,7 +1374,7 @@ static inline int pfn_valid(unsigned lon
 }
 #endif
 
-static inline int pfn_present(unsigned long pfn)
+static inline int pfn_in_present_section(unsigned long pfn)
 {
 	if (pfn_to_section_nr(pfn) >= NR_MEM_SECTIONS)
 		return 0;
@@ -1411,7 +1411,7 @@ void sparse_init(void);
 #else
 #define sparse_init()	do {} while (0)
 #define sparse_index_init(_sec, _nid)  do {} while (0)
-#define pfn_present pfn_valid
+#define pfn_in_present_section pfn_valid
 #define subsection_map_init(_pfn, _nr_pages) do {} while (0)
 #endif /* CONFIG_SPARSEMEM */
 
--- a/mm/page_ext.c~mm-sparse-rename-pfn_present-as-pfn_in_present_section
+++ a/mm/page_ext.c
@@ -304,7 +304,7 @@ static int __meminit online_page_ext(uns
 	}
 
 	for (pfn = start; !fail && pfn < end; pfn += PAGES_PER_SECTION) {
-		if (!pfn_present(pfn))
+		if (!pfn_in_present_section(pfn))
 			continue;
 		fail = init_section_page_ext(pfn, nid);
 	}
--- a/mm/shuffle.c~mm-sparse-rename-pfn_present-as-pfn_in_present_section
+++ a/mm/shuffle.c
@@ -72,7 +72,7 @@ static struct page * __meminit shuffle_v
 		return NULL;
 
 	/* ...is the pfn in a present section or a hole? */
-	if (!pfn_present(pfn))
+	if (!pfn_in_present_section(pfn))
 		return NULL;
 
 	/* ...is the page free and currently on a free_area list? */
_

Patches currently in -mm which might be from kernelfans@gmail.com are

mm-sparse-rename-pfn_present-as-pfn_in_present_section.patch
