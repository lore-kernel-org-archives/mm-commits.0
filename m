From: akpm@linux-foundation.org
Subject: [merged]
 mm-fail-get_vaddr_frames-for-filesystem-dax-mappings.patch removed from -mm
 tree
Date: Thu, 30 Nov 2017 12:18:40 -0800
Message-ID: <20171130201840.YRzNg2bRy%akpm__13412.5714227141$1512073125$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52278 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751563AbdK3USm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:18:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, dledford@redhat.com, hal.rosenstock@gmail.com, hch@lst.de, inki.dae@samsung.com, jack@suse.cz, jgg@mellanox.com, jmoyer@redhat.com, jy0922.shim@samsung.com, kyungmin.park@samsung.com, mchehab@kernel.org, mgorman@suse.de, mm-commits@vger.kernel.org, ross.zwisler@linux.intel.com, sean.hefty@intel.com, stable@vger.kernel.org, sw0312.kim@samsung.com, vbabka@suse.cz


The patch titled
     Subject: mm: fail get_vaddr_frames() for filesystem-dax mappings
has been removed from the -mm tree.  Its filename was
     mm-fail-get_vaddr_frames-for-filesystem-dax-mappings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: fail get_vaddr_frames() for filesystem-dax mappings

Until there is a solution to the dma-to-dax vs truncate problem it is not
safe to allow V4L2, Exynos, and other frame vector users to create long
standing / irrevocable memory registrations against filesytem-dax vmas.

[dan.j.williams@intel.com: add comment for vma_is_fsdax() check in get_vaddr_frames(), per Jan]
  Link: http://lkml.kernel.org/r/151197874035.26211.4061781453123083667.stgit@dwillia2-desk3.amr.corp.intel.com
Link: http://lkml.kernel.org/r/151068939985.7446.15684639617389154187.stgit@dwillia2-desk3.amr.corp.intel.com
Fixes: 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/frame_vector.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN mm/frame_vector.c~mm-fail-get_vaddr_frames-for-filesystem-dax-mappings mm/frame_vector.c
--- a/mm/frame_vector.c~mm-fail-get_vaddr_frames-for-filesystem-dax-mappings
+++ a/mm/frame_vector.c
@@ -53,6 +53,18 @@ int get_vaddr_frames(unsigned long start
 		ret = -EFAULT;
 		goto out;
 	}
+
+	/*
+	 * While get_vaddr_frames() could be used for transient (kernel
+	 * controlled lifetime) pinning of memory pages all current
+	 * users establish long term (userspace controlled lifetime)
+	 * page pinning. Treat get_vaddr_frames() like
+	 * get_user_pages_longterm() and disallow it for filesystem-dax
+	 * mappings.
+	 */
+	if (vma_is_fsdax(vma))
+		return -EOPNOTSUPP;
+
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP))) {
 		vec->got_ref = true;
 		vec->is_pfns = false;
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


