From: akpm@linux-foundation.org
Subject: +
 device-dax-implement-split-to-catch-invalid-munmap-attempts.patch added to
 -mm tree
Date: Tue, 21 Nov 2017 14:57:12 -0800
Message-ID: <5a14af48.yuPbt78i7HKdN1v6%akpm__16763.7582323097$1511305036$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38558 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751263AbdKUW5N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 21 Nov 2017 17:57:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, jmoyer@redhat.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: device-dax: implement ->split() to catch invalid munmap attempts
has been added to the -mm tree.  Its filename is
     device-dax-implement-split-to-catch-invalid-munmap-attempts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/device-dax-implement-split-to-catch-invalid-munmap-attempts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/device-dax-implement-split-to-catch-invalid-munmap-attempts.patch

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
Subject: device-dax: implement ->split() to catch invalid munmap attempts

Similar to how device-dax enforces that the 'address', 'offset', and 'len'
parameters to mmap() be aligned to the device's fundamental alignment, the
same constraints apply to munmap().  Implement ->split() to fail munmap
calls that violate the alignment constraint.  Otherwise, we later fail
VM_BUG_ON checks in the unmap_page_range() path with crash signatures of
the form:

    vma ffff8800b60c8a88 start 00007f88c0000000 end 00007f88c0e00000
    next           (null) prev           (null) mm ffff8800b61150c0
    prot 8000000000000027 anon_vma           (null) vm_ops ffffffffa0091240
    pgoff 0 file ffff8800b638ef80 private_data           (null)
    flags: 0x380000fb(read|write|shared|mayread|maywrite|mayexec|mayshare|softdirty|mixedmap|hugepage)
    ------------[ cut here ]------------
    kernel BUG at mm/huge_memory.c:2014!
    [..]
    RIP: 0010:__split_huge_pud+0x12a/0x180
    [..]
    Call Trace:
     unmap_page_range+0x245/0xa40
     ? __vma_adjust+0x301/0x990
     unmap_vmas+0x4c/0xa0
     unmap_region+0xae/0x120
     ? __vma_rb_erase+0x11a/0x230
     do_munmap+0x276/0x410
     vm_munmap+0x6a/0xa0
     SyS_munmap+0x1d/0x30

Link: http://lkml.kernel.org/r/151130418681.4029.7118245855057952010.stgit@dwillia2-desk3.amr.corp.intel.com
Fixes: dee410792419 ("/dev/dax, core: file operations and dax-mmap")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Jeff Moyer <jmoyer@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dax/device.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN drivers/dax/device.c~device-dax-implement-split-to-catch-invalid-munmap-attempts drivers/dax/device.c
--- a/drivers/dax/device.c~device-dax-implement-split-to-catch-invalid-munmap-attempts
+++ a/drivers/dax/device.c
@@ -428,9 +428,21 @@ static int dev_dax_fault(struct vm_fault
 	return dev_dax_huge_fault(vmf, PE_SIZE_PTE);
 }
 
+static int dev_dax_split(struct vm_area_struct *vma, unsigned long addr)
+{
+	struct file *filp = vma->vm_file;
+	struct dev_dax *dev_dax = filp->private_data;
+	struct dax_region *dax_region = dev_dax->region;
+
+	if (!IS_ALIGNED(addr, dax_region->align))
+		return -EINVAL;
+	return 0;
+}
+
 static const struct vm_operations_struct dax_vm_ops = {
 	.fault = dev_dax_fault,
 	.huge_fault = dev_dax_huge_fault,
+	.split = dev_dax_split,
 };
 
 static int dax_mmap(struct file *filp, struct vm_area_struct *vma)
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

