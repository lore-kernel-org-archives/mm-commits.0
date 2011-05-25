From: akpm@linux-foundation.org
Subject: [merged] mm-add-section_align_up-and-section_align_down-macro.patch removed from -mm tree
Date: Wed, 25 May 2011 13:30:29 -0700
Message-ID: <201105252028.p4PKSqwl014790@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755701Ab1EYU33 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:29:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dkiper@net-space.pl, konrad.wilk@oracle.com, mm-commits@vger.kernel.org


The patch titled
     mm: add SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN() macro
has been removed from the -mm tree.  Its filename was
     mm-add-section_align_up-and-section_align_down-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: add SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN() macro
From: Daniel Kiper <dkiper@net-space.pl>

Add SECTION_ALIGN_UP() and SECTION_ALIGN_DOWN() macro which aligns given
pfn to upper section and lower section boundary accordingly.

Required for the latest memory hotplug support for the Xen balloon driver.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN include/linux/mmzone.h~mm-add-section_align_up-and-section_align_down-macro include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-add-section_align_up-and-section_align_down-macro
+++ a/include/linux/mmzone.h
@@ -956,6 +956,9 @@ static inline unsigned long early_pfn_to
 #define pfn_to_section_nr(pfn) ((pfn) >> PFN_SECTION_SHIFT)
 #define section_nr_to_pfn(sec) ((sec) << PFN_SECTION_SHIFT)
 
+#define SECTION_ALIGN_UP(pfn)	(((pfn) + PAGES_PER_SECTION - 1) & PAGE_SECTION_MASK)
+#define SECTION_ALIGN_DOWN(pfn)	((pfn) & PAGE_SECTION_MASK)
+
 struct page;
 struct page_cgroup;
 struct mem_section {
_

Patches currently in -mm which might be from dkiper@net-space.pl are

origin.patch

