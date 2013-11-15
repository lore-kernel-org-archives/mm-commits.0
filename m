From: akpm@linux-foundation.org
Subject: [merged]
 mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch removed from -mm tree
Date: Fri, 15 Nov 2013 12:07:23 -0800
Message-ID: <52867efb.z7R3TlFI44dqSXGs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab3KOUHZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 15:07:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tglx@linutronix.de, srikar@linux.vnet.ibm.com, sedat.dilek@gmail.com, robinmholt@gmail.com, riel@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com, oleg@redhat.com, n-horiguchi@ah.jp.nec.com, mtk.manpages@gmail.com, mingo@redhat.com, mgorman@suse.de, keescook@chromium.org, hughd@google.com, hannes@cmpxchg.org, fweisbec@gmail.com, ebiederm@xmission.com, dhowells@redhat.com, davej@redhat.com, dave.hansen@intel.com, athorlton@sgi.com, ak@linux.intel.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com

Subject: [merged] mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,aarcange@redhat.com,ak@linux.intel.com,athorlton@sgi.com,dave.hansen@intel.com,davej@redhat.com,dhowells@redhat.com,ebiederm@xmission.com,fweisbec@gmail.com,hannes@cmpxchg.org,hughd@google.com,keescook@chromium.org,mgorman@suse.de,mingo@redhat.com,mtk.manpages@gmail.com,n-horiguchi@ah.jp.nec.com,oleg@redhat.com,paulmck@linux.vnet.ibm.com,peterz@infradead.org,riel@redhat.com,robinmholt@gmail.com,sedat.dilek@gmail.com,srikar@linux.vnet.ibm.com,tglx@linutronix.de,viro@zeniv.linux.org.uk,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 12:07:23 -0800


The patch titled
     Subject: mm: introduce api for split page table lock for PMD level
has been removed from the -mm tree.  Its filename was
     mm-introduce-api-for-split-page-table-lock-for-pmd-level.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: introduce api for split page table lock for PMD level

Basic api, backed by mm->page_table_lock for now. Actual implementation
will be added later.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Alex Thorlton <athorlton@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Jones <davej@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Robin Holt <robinmholt@gmail.com>
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN include/linux/mm.h~mm-introduce-api-for-split-page-table-lock-for-pmd-level include/linux/mm.h
--- a/include/linux/mm.h~mm-introduce-api-for-split-page-table-lock-for-pmd-level
+++ a/include/linux/mm.h
@@ -1378,6 +1378,19 @@ static inline void pgtable_page_dtor(str
 	((unlikely(pmd_none(*(pmd))) && __pte_alloc_kernel(pmd, address))? \
 		NULL: pte_offset_kernel(pmd, address))
 
+static inline spinlock_t *pmd_lockptr(struct mm_struct *mm, pmd_t *pmd)
+{
+	return &mm->page_table_lock;
+}
+
+
+static inline spinlock_t *pmd_lock(struct mm_struct *mm, pmd_t *pmd)
+{
+	spinlock_t *ptl = pmd_lockptr(mm, pmd);
+	spin_lock(ptl);
+	return ptl;
+}
+
 extern void free_area_init(unsigned long * zones_size);
 extern void free_area_init_node(int nid, unsigned long * zones_size,
 		unsigned long zone_start_pfn, unsigned long *zholes_size);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
x86-mm-get-aslr-work-for-hugetlb-mappings.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch

