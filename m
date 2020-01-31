From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 065/118] mm/migrate: remove useless mask of start
 address
Date: Thu, 30 Jan 2020 22:14:38 -0800
Message-ID: <20200131061438.WFlUS3DD-%akpm@linux-foundation.org>
References: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgAaGOj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jan 2020 01:14:39 -0500
In-Reply-To: <20200130221021.5f0211c56346d5485af07923@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bharata@linux.ibm.com, chris@chrisdown.name, hch@lst.de, jgg@mellanox.com, jglisse@redhat.com, jhubbard@nvidia.com, linux-mm@kvack.org, mhocko@kernel.org, mm-commits@vger.kernel.org, rcampbell@nvidia.com, torvalds@linux-foundation.org

From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/migrate: remove useless mask of start address

Addresses passed to walk_page_range() callback functions are already page
aligned and don't need to be masked with PAGE_MASK.

Link: http://lkml.kernel.org/r/20200107211208.24595-2-rcampbell@nvidia.com
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

 mm/migrate.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/migrate.c~mm-migrate-remove-useless-mask-of-start-address
+++ a/mm/migrate.c
@@ -2156,7 +2156,7 @@ static int migrate_vma_collect_hole(unsi
 	struct migrate_vma *migrate = walk->private;
 	unsigned long addr;
 
-	for (addr = start & PAGE_MASK; addr < end; addr += PAGE_SIZE) {
+	for (addr = start; addr < end; addr += PAGE_SIZE) {
 		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE;
 		migrate->dst[migrate->npages] = 0;
 		migrate->npages++;
@@ -2173,7 +2173,7 @@ static int migrate_vma_collect_skip(unsi
 	struct migrate_vma *migrate = walk->private;
 	unsigned long addr;
 
-	for (addr = start & PAGE_MASK; addr < end; addr += PAGE_SIZE) {
+	for (addr = start; addr < end; addr += PAGE_SIZE) {
 		migrate->dst[migrate->npages] = 0;
 		migrate->src[migrate->npages++] = 0;
 	}
_
