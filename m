From: akpm@linux-foundation.org
Subject: + ib-core-disable-memory-registration-of-fileystem-dax-vmas.patch added to -mm tree
Date: Tue, 21 Nov 2017 15:13:33 -0800
Message-ID: <5a14b31d.jCkjlR4LLi7czaBu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39226 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751504AbdKUXNf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2017 18:13:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dledford@redhat.com, hal.rosenstock@gmail.com, hch@lst.de, inki.dae@samsung.com, jack@suse.cz, jgunthorpe@obsidianresearch.com, jmoyer@redhat.com, jy0922.shim@samsung.com, kyungmin.park@samsung.com, mchehab@kernel.org, mgorman@suse.de, ross.zwisler@linux.intel.com, sean.hefty@intel.com, stable@vger.kernel.org, sw0312.kim@samsung.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: IB/core: disable memory registration of fileystem-dax vmas
has been added to the -mm tree.  Its filename is
     ib-core-disable-memory-registration-of-fileystem-dax-vmas.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ib-core-disable-memory-registration-of-fileystem-dax-vmas.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ib-core-disable-memory-registration-of-fileystem-dax-vmas.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: IB/core: disable memory registration of fileystem-dax vmas

Until there is a solution to the dma-to-dax vs truncate problem it is not
safe to allow RDMA to create long standing memory registrations against
filesytem-dax vmas.

Link: http://lkml.kernel.org/r/151068941011.7446.7766030590347262502.stgit@dwillia2-desk3.amr.corp.intel.com
Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/core/umem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/infiniband/core/umem.c~ib-core-disable-memory-registration-of-fileystem-dax-vmas drivers/infiniband/core/umem.c
--- a/drivers/infiniband/core/umem.c~ib-core-disable-memory-registration-of-fileystem-dax-vmas
+++ a/drivers/infiniband/core/umem.c
@@ -191,7 +191,7 @@ struct ib_umem *ib_umem_get(struct ib_uc
 	sg_list_start = umem->sg_head.sgl;
 
 	while (npages) {
-		ret = get_user_pages(cur_base,
+		ret = get_user_pages_longterm(cur_base,
 				     min_t(unsigned long, npages,
 					   PAGE_SIZE / sizeof (struct page *)),
 				     gup_flags, page_list, vma_list);
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages.patch
mm-fix-device-dax-pud-write-faults-triggered-by-get_user_pages-v3.patch
mm-switch-to-define-pmd_write-instead-of-__have_arch_pmd_write.patch
mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths.patch
mm-replace-pud_write-with-pud_access_permitted-in-fault-gup-paths-v3.patch
mm-replace-pmd_write-with-pmd_access_permitted-in-fault-gup-paths.patch
mm-replace-pte_write-with-pte_access_permitted-in-fault-gup-paths.patch
mm-hugetlbfs-introduce-split-to-vm_operations_struct.patch
device-dax-implement-split-to-catch-invalid-munmap-attempts.patch
mm-introduce-get_user_pages_longterm.patch
mm-fail-get_vaddr_frames-for-filesystem-dax-mappings.patch
v4l2-disable-filesystem-dax-mapping-support.patch
ib-core-disable-memory-registration-of-fileystem-dax-vmas.patch

