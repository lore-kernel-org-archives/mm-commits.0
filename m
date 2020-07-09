From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-optimize-migrate_vma_setup-for-holes.patch
 added to -mm tree
Date: Thu, 09 Jul 2020 16:46:33 -0700
Message-ID: <20200709234633.CvgqR0RwB%akpm@linux-foundation.org>
References: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbgGIXqe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 9 Jul 2020 19:46:34 -0400
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bharata@linux.ibm.com, hch@lst.de, jgg@mellanox.com, jglisse@redhat.com, jhubbard@nvidia.com, mm-commits@vger.kernel.org, rcampbell@nvidia.com, shuah@kernel.org


The patch titled
     Subject: mm/migrate: optimize migrate_vma_setup() for holes
has been added to the -mm tree.  Its filename is
     mm-migrate-optimize-migrate_vma_setup-for-holes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-migrate-optimize-migrate_vma_setup-for-holes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-migrate-optimize-migrate_vma_setup-for-holes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ralph Campbell <rcampbell@nvidia.com>
Subject: mm/migrate: optimize migrate_vma_setup() for holes

Patch series "mm/migrate: optimize migrate_vma_setup() for holes".

A simple optimization for migrate_vma_*() when the source vma is not an
anonymous vma and a new test case to exercise it.


This patch (of 2):

When migrating system memory to device private memory, if the source
address range is a valid VMA range and there is no memory or a zero page,
the source PFN array is marked as valid but with no PFN.

This lets the device driver allocate private memory and clear it, then
insert the new device private struct page into the CPU's page tables when
migrate_vma_pages() is called.  migrate_vma_pages() only inserts the new
page if the VMA is an anonymous range.

There is no point in telling the device driver to allocate device private
memory and then not migrate the page.  Instead, mark the source PFN array
entries as not migrating to avoid this overhead.

Link: http://lkml.kernel.org/r/20200709165711.26584-1-rcampbell@nvidia.com
Link: http://lkml.kernel.org/r/20200709165711.26584-2-rcampbell@nvidia.com
Signed-off-by: Ralph Campbell <rcampbell@nvidia.com>
Cc: Jerome Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: "Bharata B Rao" <bharata@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/migrate.c~mm-migrate-optimize-migrate_vma_setup-for-holes
+++ a/mm/migrate.c
@@ -2167,9 +2167,13 @@ static int migrate_vma_collect_hole(unsi
 {
 	struct migrate_vma *migrate = walk->private;
 	unsigned long addr;
+	unsigned long flags;
+
+	/* Only allow populating anonymous memory. */
+	flags = vma_is_anonymous(walk->vma) ? MIGRATE_PFN_MIGRATE : 0;
 
 	for (addr = start; addr < end; addr += PAGE_SIZE) {
-		migrate->src[migrate->npages] = MIGRATE_PFN_MIGRATE;
+		migrate->src[migrate->npages] = flags;
 		migrate->dst[migrate->npages] = 0;
 		migrate->npages++;
 		migrate->cpages++;
_

Patches currently in -mm which might be from rcampbell@nvidia.com are

mm-remove-redundant-check-non_swap_entry.patch
mm-migrate-optimize-migrate_vma_setup-for-holes.patch
mm-migrate-add-migrate-shared-test-for-migrate_vma_.patch
