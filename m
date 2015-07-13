From: akpm@linux-foundation.org
Subject: + ext4-huge-page-fault-support.patch added to -mm tree
Date: Mon, 13 Jul 2015 14:32:11 -0700
Message-ID: <55a42e5b.sTdDVrwrNKU2v4n6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbbGMVcN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jul 2015 17:32:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: willy@linux.intel.com, dhillf@gmail.com, jack@suse.cz, kirill.shutemov@linux.intel.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: huge page fault support
has been added to the -mm tree.  Its filename is
     ext4-huge-page-fault-support.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ext4-huge-page-fault-support.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ext4-huge-page-fault-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Matthew Wilcox <willy@linux.intel.com>
Subject: ext4: huge page fault support

Use DAX to provide support for huge pages.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Cc: Hillf Danton <dhillf@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/file.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff -puN fs/ext4/file.c~ext4-huge-page-fault-support fs/ext4/file.c
--- a/fs/ext4/file.c~ext4-huge-page-fault-support
+++ a/fs/ext4/file.c
@@ -211,6 +211,13 @@ static int ext4_dax_fault(struct vm_area
 					/* Is this the right get_block? */
 }
 
+static int ext4_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
+						pmd_t *pmd, unsigned int flags)
+{
+	return dax_pmd_fault(vma, addr, pmd, flags, ext4_get_block_write,
+				ext4_end_io_unwritten);
+}
+
 static int ext4_dax_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	return dax_mkwrite(vma, vmf, ext4_get_block, ext4_end_io_unwritten);
@@ -218,6 +225,7 @@ static int ext4_dax_mkwrite(struct vm_ar
 
 static const struct vm_operations_struct ext4_dax_vm_ops = {
 	.fault		= ext4_dax_fault,
+	.pmd_fault	= ext4_dax_pmd_fault,
 	.page_mkwrite	= ext4_dax_mkwrite,
 	.pfn_mkwrite	= dax_pfn_mkwrite,
 };
@@ -245,7 +253,7 @@ static int ext4_file_mmap(struct file *f
 	file_accessed(file);
 	if (IS_DAX(file_inode(file))) {
 		vma->vm_ops = &ext4_dax_vm_ops;
-		vma->vm_flags |= VM_MIXEDMAP;
+		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
 	} else {
 		vma->vm_ops = &ext4_file_vm_ops;
 	}
_

Patches currently in -mm which might be from willy@linux.intel.com are

mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested.patch
dax-move-dax-related-functions-to-a-new-header.patch
thp-prepare-for-dax-huge-pages.patch
mm-add-a-pmd_fault-handler.patch
mm-export-various-functions-for-the-benefit-of-dax.patch
mm-add-vmf_insert_pfn_pmd.patch
dax-add-huge-page-fault-support.patch
ext2-huge-page-fault-support.patch
ext4-huge-page-fault-support.patch
xfs-huge-page-fault-support.patch

