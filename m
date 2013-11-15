From: akpm@linux-foundation.org
Subject: [merged] mm-allow-pgtable_page_ctor-to-fail.patch removed from
 -mm tree
Date: Fri, 15 Nov 2013 12:07:48 -0800
Message-ID: <52867f14.HG6r1zTW6nJ1Pcmb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab3KOUHs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:07:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, kirill.shutemov@linux.intel.com

Subject: [merged] mm-allow-pgtable_page_ctor-to-fail.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:07:48 -0800


The patch titled
     Subject: mm: allow pgtable_page_ctor() to fail
has been removed from the -mm tree.  Its filename was
     mm-allow-pgtable_page_ctor-to-fail.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: allow pgtable_page_ctor() to fail

Change pgtable_page_ctor() return type from void to bool.  Returns true,
if initialization is successful and false otherwise.

Current implementation never fails, but it will change later.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/mm.h~mm-allow-pgtable_page_ctor-to-fail include/linux/mm.h
--- a/include/linux/mm.h~mm-allow-pgtable_page_ctor-to-fail
+++ a/include/linux/mm.h
@@ -1338,10 +1338,11 @@ static inline pmd_t *pmd_alloc(struct mm
 #define pte_lockptr(mm, pmd)	({(void)(pmd); &(mm)->page_table_lock;})
 #endif /* USE_SPLIT_PTE_PTLOCKS */
 
-static inline void pgtable_page_ctor(struct page *page)
+static inline bool pgtable_page_ctor(struct page *page)
 {
 	pte_lock_init(page);
 	inc_zone_page_state(page, NR_PAGETABLE);
+	return true;
 }
 
 static inline void pgtable_page_dtor(struct page *page)
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

