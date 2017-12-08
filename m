From: akpm@linux-foundation.org
Subject: +
 device-dax-implement-pagesize-for-smaps-to-report-mmupagesize.patch added
 to -mm tree
Date: Fri, 08 Dec 2017 14:19:47 -0800
Message-ID: <5a2b1003.HfyJSn72bcf2cgiq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50924 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753099AbdLHWTs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 8 Dec 2017 17:19:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, benh@kernel.crashing.org, jane.chu@oracle.com, mpe@ellerman.id.au, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: implement ->pagesize() for smaps to report MMUPageSize
has been added to the -mm tree.  Its filename is
     device-dax-implement-pagesize-for-smaps-to-report-mmupagesize.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/device-dax-implement-pagesize-for-smaps-to-report-mmupagesize.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/device-dax-implement-pagesize-for-smaps-to-report-mmupagesize.patch

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

mm-hugetlbfs-introduce-pagesize-to-vm_operations_struct.patch
device-dax-implement-pagesize-for-smaps-to-report-mmupagesize.patch

