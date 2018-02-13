From: akpm@linux-foundation.org
Subject: + mm-uninitialized-struct-page-poisoning-sanity-checking.patch
 added to -mm tree
Date: Tue, 13 Feb 2018 13:50:08 -0800
Message-ID: <5a835d90.rSjJrpJQBd9vRl8p%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59248 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965907AbeBMVuK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Feb 2018 16:50:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, bharata@linux.vnet.ibm.com, bhe@redhat.com, daniel.m.jordan@oracle.com, dan.j.williams@intel.com, gregkh@linuxfoundation.org, hpa@zytor.com, kirill.shutemov@linux.intel.com, mgorman@techsingularity.net, mhocko@suse.com, mingo@elte.hu, steven.sistare@oracle.com, tglx@linutronix.de, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: uninitialized struct page poisoning sanity checking
has been added to the -mm tree.  Its filename is
     mm-uninitialized-struct-page-poisoning-sanity-checking.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-uninitialized-struct-page-poisoning-sanity-checking.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-uninitialized-struct-page-poisoning-sanity-checking.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: mm: uninitialized struct page poisoning sanity checking

During boot we poison struct page memory in order to ensure that no one is
accessing this memory until the struct pages are initialized in
__init_single_page().

This patch adds more scrutiny to this checking, by making sure that flags
do not equal the poison pattern when the are accessed.  The pattern is all
ones.

Since node id is also stored in struct page, and may be accessed quiet
early we add the enforcement into page_to_nid() function as well.

Link: http://lkml.kernel.org/r/20180213193159.14606-4-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Steven Sistare <steven.sistare@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h         |    4 +++-
 include/linux/page-flags.h |   22 +++++++++++++++++-----
 mm/memblock.c              |    2 +-
 3 files changed, 21 insertions(+), 7 deletions(-)

diff -puN include/linux/mm.h~mm-uninitialized-struct-page-poisoning-sanity-checking include/linux/mm.h
--- a/include/linux/mm.h~mm-uninitialized-struct-page-poisoning-sanity-checking
+++ a/include/linux/mm.h
@@ -896,7 +896,9 @@ extern int page_to_nid(const struct page
 #else
 static inline int page_to_nid(const struct page *page)
 {
-	return (page->flags >> NODES_PGSHIFT) & NODES_MASK;
+	struct page *p = (struct page *)page;
+
+	return (PF_POISONED_CHECK(p)->flags >> NODES_PGSHIFT) & NODES_MASK;
 }
 #endif
 
diff -puN include/linux/page-flags.h~mm-uninitialized-struct-page-poisoning-sanity-checking include/linux/page-flags.h
--- a/include/linux/page-flags.h~mm-uninitialized-struct-page-poisoning-sanity-checking
+++ a/include/linux/page-flags.h
@@ -156,9 +156,18 @@ static __always_inline int PageCompound(
 	return test_bit(PG_head, &page->flags) || PageTail(page);
 }
 
+#define	PAGE_POISON_PATTERN	~0ul
+static inline int PagePoisoned(const struct page *page)
+{
+	return page->flags == PAGE_POISON_PATTERN;
+}
+
 /*
  * Page flags policies wrt compound pages
  *
+ * PF_POISONED_CHECK
+ *     check if this struct page poisoned/uninitialized
+ *
  * PF_ANY:
  *     the page flag is relevant for small, head and tail pages.
  *
@@ -176,17 +185,20 @@ static __always_inline int PageCompound(
  * PF_NO_COMPOUND:
  *     the page flag is not relevant for compound pages.
  */
-#define PF_ANY(page, enforce)	page
-#define PF_HEAD(page, enforce)	compound_head(page)
+#define PF_POISONED_CHECK(page) ({					\
+		VM_BUG_ON_PGFLAGS(PagePoisoned(page), page);		\
+		page;})
+#define PF_ANY(page, enforce)	PF_POISONED_CHECK(page)
+#define PF_HEAD(page, enforce)	PF_POISONED_CHECK(compound_head(page))
 #define PF_ONLY_HEAD(page, enforce) ({					\
 		VM_BUG_ON_PGFLAGS(PageTail(page), page);		\
-		page;})
+		PF_POISONED_CHECK(page);})
 #define PF_NO_TAIL(page, enforce) ({					\
 		VM_BUG_ON_PGFLAGS(enforce && PageTail(page), page);	\
-		compound_head(page);})
+		PF_POISONED_CHECK(compound_head(page));})
 #define PF_NO_COMPOUND(page, enforce) ({				\
 		VM_BUG_ON_PGFLAGS(enforce && PageCompound(page), page);	\
-		page;})
+		PF_POISONED_CHECK(page);})
 
 /*
  * Macros to create function definitions for page flags
diff -puN mm/memblock.c~mm-uninitialized-struct-page-poisoning-sanity-checking mm/memblock.c
--- a/mm/memblock.c~mm-uninitialized-struct-page-poisoning-sanity-checking
+++ a/mm/memblock.c
@@ -1373,7 +1373,7 @@ void * __init memblock_virt_alloc_try_ni
 					   min_addr, max_addr, nid);
 #ifdef CONFIG_DEBUG_VM
 	if (ptr && size > 0)
-		memset(ptr, 0xff, size);
+		memset(ptr, PAGE_POISON_PATTERN, size);
 #endif
 	return ptr;
 }
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

mm-initialize-pages-on-demand-during-boot.patch
mm-initialize-pages-on-demand-during-boot-fix2.patch
mm-memory_hotplug-enforce-block-size-aligned-range-check.patch
x86-mm-memory_hotplug-determine-block-size-based-on-the-end-of-boot-memory.patch
mm-uninitialized-struct-page-poisoning-sanity-checking.patch
mm-memory_hotplug-optimize-memory-hotplug.patch
sparc64-ng4-memset-32-bits-overflow.patch

