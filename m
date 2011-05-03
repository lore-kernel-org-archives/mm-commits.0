From: akpm@linux-foundation.org
Subject: + mm-enable-set_page_section-only-if-config_sparsemem-and-config_sparsemem_vmemmap.patch added to -mm tree
Date: Tue, 03 May 2011 16:35:54 -0700
Message-ID: <201105032335.p43NZsk4017523@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753976Ab1ECXgK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 May 2011 19:36:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dkiper@net-space.pl, dave@linux.vnet.ibm.com


The patch titled
     mm: enable set_page_section() only if CONFIG_SPARSEMEM and !CONFIG_SPARSEMEM_VMEMMAP
has been added to the -mm tree.  Its filename is
     mm-enable-set_page_section-only-if-config_sparsemem-and-config_sparsemem_vmemmap.patch

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
Subject: mm: enable set_page_section() only if CONFIG_SPARSEMEM and !CONFIG_SPARSEMEM_VMEMMAP
From: Daniel Kiper <dkiper@net-space.pl>

set_page_section() is valid only in CONFIG_SPARSEMEM and
!CONFIG_SPARSEMEM_VMEMMAP context.  Move it to proper place and amend
accordingly functions which are using it.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
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
