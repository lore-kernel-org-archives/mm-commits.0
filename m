From: akpm@linux-foundation.org
Subject: [withdrawn]
 device-dax-implement-pagesize-for-smaps-to-report-mmupagesize.patch removed from -mm tree
Date: Tue, 12 Dec 2017 13:34:31 -0800
Message-ID: <5a304b67.eb0odngK4hVFb74M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53132 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752522AbdLLVec (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Dec 2017 16:34:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, benh@kernel.crashing.org, jane.chu@oracle.com, mpe@ellerman.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: implement ->pagesize() for smaps to report MMUPageSize
has been removed from the -mm tree.  Its filename was
     device-dax-implement-pagesize-for-smaps-to-report-mmupagesize.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: device-dax: implement ->pagesize() for smaps to report MMUPageSize

Given that device-dax is making similar page mapping size guarantees as
hugetlbfs, emit the size in smaps and any other kernel path that requests
the mapping size of a vma.

Link: http://lkml.kernel.org/r/151270386082.21215.150215755680990629.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Jane Chu <jane.chu@oracle.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/device.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN drivers/dax/device.c~device-dax-implement-pagesize-for-smaps-to-report-mmupagesize drivers/dax/device.c
--- a/drivers/dax/device.c~device-dax-implement-pagesize-for-smaps-to-report-mmupagesize
+++ a/drivers/dax/device.c
@@ -439,10 +439,20 @@ static int dev_dax_split(struct vm_area_
 	return 0;
 }
 
+static unsigned long dev_dax_pagesize(struct vm_area_struct *vma)
+{
+	struct file *filp = vma->vm_file;
+	struct dev_dax *dev_dax = filp->private_data;
+	struct dax_region *dax_region = dev_dax->region;
+
+	return dax_region->align;
+}
+
 static const struct vm_operations_struct dax_vm_ops = {
 	.fault = dev_dax_fault,
 	.huge_fault = dev_dax_huge_fault,
 	.split = dev_dax_split,
+	.pagesize = dev_dax_pagesize,
 };
 
 static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
_

Patches currently in -mm which might be from dan.j.williams@intel.com are


