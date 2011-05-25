From: akpm@linux-foundation.org
Subject: [merged] mm-enable-set_page_section-only-if-config_sparsemem-and-config_sparsemem_vmemmap.patch removed from -mm tree
Date: Wed, 25 May 2011 13:29:55 -0700
Message-ID: <201105252028.p4PKSIOh014730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754304Ab1EYUtA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:49:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dkiper@net-space.pl, dave@linux.vnet.ibm.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     mm: enable set_page_section() only if CONFIG_SPARSEMEM and !CONFIG_SPARSEMEM_VMEMMAP
has been removed from the -mm tree.  Its filename was
     mm-enable-set_page_section-only-if-config_sparsemem-and-config_sparsemem_vmemmap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: enable set_page_section() only if CONFIG_SPARSEMEM and !CONFIG_SPARSEMEM_VMEMMAP
From: Daniel Kiper <dkiper@net-space.pl>

set_page_section() is meaningful only in CONFIG_SPARSEMEM and
!CONFIG_SPARSEMEM_VMEMMAP context.  Move it to proper place and amend
accordingly functions which are using it.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN include/linux/mm.h~mm-enable-set_page_section-only-if-config_sparsemem-and-config_sparsemem_vmemmap include/linux/mm.h
--- a/include/linux/mm.h~mm-enable-set_page_section-only-if-config_sparsemem-and-config_sparsemem_vmemmap
+++ a/include/linux/mm.h
@@ -682,6 +682,12 @@ static inline struct zone *page_zone(str
 }
 
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
+static inline void set_page_section(struct page *page, unsigned long section)
+{
+	page->flags &= ~(SECTIONS_MASK << SECTIONS_PGSHIFT);
+	page->flags |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
+}
+
 static inline unsigned long page_to_section(struct page *page)
 {
 	return (page->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
@@ -700,18 +706,14 @@ static inline void set_page_node(struct 
 	page->flags |= (node & NODES_MASK) << NODES_PGSHIFT;
 }
 
-static inline void set_page_section(struct page *page, unsigned long section)
-{
-	page->flags &= ~(SECTIONS_MASK << SECTIONS_PGSHIFT);
-	page->flags |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
-}
