From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 067/118] mm/migrate: add stable check in
 migrate_vma_insert_page()
Date: Thu, 30 Jan 2020 22:14:44 -0800
Message-ID: <20200131061444.j7ctq9JFZ%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGOq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:14:46 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bharata@linux.ibm.com, chris@chrisdown.name, hch@lst.de, jgg@mellanox.com, jglisse@redhat.com, jhubbard@nvidia.com, linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org, rcampbell@nvidia.com, torvalds@linux-foundation.org

From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/migrate: add stable check in migrate_vma_insert_page()

migrate_vma_insert_page() closely follows the code in:
  __handle_mm_fault()
    handle_pte_fault()
      do_anonymous_page()

Add a call to check_stable_address_space() after locking the page table
entry before inserting a ZONE_DEVICE private zero page mapping similar to
page faulting a new anonymous page.

Link: http://lkml.kernel.org/r/20200107211208.24595-4-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Bharata B Rao <bharata@linux.ibm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Chris Down <chris@chrisdown.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/migrate.c~mm-migrate-add-stable-check-in-migrate_vma_insert_page
+++ a/mm/migrate.c
@@ -48,6 +48,7 @@
 #include <linux/page_owner.h>
 #include <linux/sched/mm.h>
 #include <linux/ptrace.h>
+#include <linux/oom.h>
 
 #include <asm/tlbflush.h>
 
@@ -2695,6 +2696,14 @@ int migrate_vma_setup(struct migrate_vma
 }
 EXPORT_SYMBOL(migrate_vma_setup);
 
+/*
+ * This code closely matches the code in:
+ *   __handle_mm_fault()
+ *     handle_pte_fault()
+ *       do_anonymous_page()
+ * to map in an anonymous zero page but the struct page will be a ZONE_DEVICE
+ * private page.
+ */
 static void migrate_vma_insert_page(struct migrate_vma *migrate,
 				    unsigned long addr,
 				    struct page *page,
@@ -2775,6 +2784,9 @@ static void migrate_vma_insert_page(stru
 
 	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
 
+	if (check_stable_address_space(mm))
+		goto unlock_abort;
+
 	if (pte_present(*ptep)) {
 		unsigned long pfn = pte_pfn(*ptep);
 
_
