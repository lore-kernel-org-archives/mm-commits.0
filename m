From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-remove-vm_bug_onpageslab-from-page_mapcount.patch
 added to -mm tree
Date: Sun, 24 May 2020 17:49:08 -0700
Message-ID: <20200525004908.ptY_Df6aP%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388014AbgEYAtK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 24 May 2020 20:49:10 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, khlebnikov@yandex-team.ru, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, rientjes@google.com, stable@vger.kernel.org, vbabka@suse.cz


The patch titled
     Subject: mm: remove VM_BUG_ON(PageSlab()) from page_mapcount()
has been added to the -mm tree.  Its filename is
     mm-remove-vm_bug_onpageslab-from-page_mapcount.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-vm_bug_onpageslab-from-page_mapcount.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-vm_bug_onpageslab-from-page_mapcount.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: mm: remove VM_BUG_ON(PageSlab()) from page_mapcount()

Replace superfluous VM_BUG_ON() with comment about correct usage.

Technically reverts commit 1d148e218a0d0566b1c06f2f45f1436d53b049b2
("mm: add VM_BUG_ON_PAGE() to page_mapcount()"), but context have changed.

Function isolate_migratepages_block() runs some checks out of lru_lock
when choose pages for migration.  After checking PageLRU() it checks extra
page references by comparing page_count() and page_mapcount().  Between
these two checks page could be removed from lru, freed and taken by slab.

As a result this race triggers VM_BUG_ON(PageSlab()) in page_mapcount().
Race window is tiny. For certain workload this happens around once a year.

 page:ffffea0105ca9380 count:1 mapcount:0 mapping:ffff88ff7712c180 index:0x0 compound_mapcount: 0
 flags: 0x500000000008100(slab|head)
 raw: 0500000000008100 dead000000000100 dead000000000200 ffff88ff7712c180
 raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
 page dumped because: VM_BUG_ON_PAGE(PageSlab(page))
 ------------[ cut here ]------------
 kernel BUG at ./include/linux/mm.h:628!
 invalid opcode: 0000 [#1] SMP NOPTI
 CPU: 77 PID: 504 Comm: kcompactd1 Tainted: G        W         4.19.109-27 #1
 Hardware name: Yandex T175-N41-Y3N/MY81-EX0-Y3N, BIOS R05 06/20/2019
 RIP: 0010:isolate_migratepages_block+0x986/0x9b0

Code in isolate_migratepages_block() was added in commit 119d6d59dcc0
("mm, compaction: avoid isolating pinned pages") before adding VM_BUG_ON
into page_mapcount().

This race has been predicted in 2015 by Vlastimil Babka (see link below).

Link: http://lkml.kernel.org/r/159032779896.957378.7852761411265662220.stgit@buzz
Link: https://lore.kernel.org/lkml/557710E1.6060103@suse.cz/
Link: https://lore.kernel.org/linux-mm/158937872515.474360.5066096871639561424.stgit@buzz/T/ (v1)
Fixes: 1d148e218a0d ("mm: add VM_BUG_ON_PAGE() to page_mapcount()")
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/include/linux/mm.h~mm-remove-vm_bug_onpageslab-from-page_mapcount
+++ a/include/linux/mm.h
@@ -782,6 +782,11 @@ static inline void *kvcalloc(size_t n, s
 
 extern void kvfree(const void *addr);
 
+/*
+ * Mapcount of compound page as a whole, not includes mapped sub-pages.
+ *
+ * Must be called only for compound pages or any their tail sub-pages.
+ */
 static inline int compound_mapcount(struct page *page)
 {
 	VM_BUG_ON_PAGE(!PageCompound(page), page);
@@ -801,10 +806,15 @@ static inline void page_mapcount_reset(s
 
 int __page_mapcount(struct page *page);
 
+/*
+ * Mapcount of 0-order page, for sub-page includes compound_mapcount().
+ *
+ * Result is undefined for pages which cannot be mapped into userspace.
+ * For example SLAB or special types of pages. See function page_has_type().
+ * They use this place in struct page differently.
+ */
 static inline int page_mapcount(struct page *page)
 {
-	VM_BUG_ON_PAGE(PageSlab(page), page);
