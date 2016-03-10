From: akpm@linux-foundation.org
Subject: [merged] dax-check-return-value-of-dax_radix_entry.patch removed
 from -mm tree
Date: Thu, 10 Mar 2016 10:58:12 -0800
Message-ID: <56e1c3c4.AG7/A4bsDqFJe/QA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51845 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbcCJS6S (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2016 13:58:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, david@fromorbit.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: check return value of dax_radix_entry()
has been removed from the -mm tree.  Its filename was
     dax-check-return-value-of-dax_radix_entry.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: check return value of dax_radix_entry()

dax_pfn_mkwrite() previously wasn't checking the return value of the call
to dax_radix_entry(), which was a mistake.

Instead, capture this return value and return the appropriate VM_FAULT_
value.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN fs/dax.c~dax-check-return-value-of-dax_radix_entry fs/dax.c
--- a/fs/dax.c~dax-check-return-value-of-dax_radix_entry
+++ a/fs/dax.c
@@ -1056,6 +1056,7 @@ EXPORT_SYMBOL_GPL(dax_pmd_fault);
 int dax_pfn_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct file *file = vma->vm_file;
+	int error;
 
 	/*
 	 * We pass NO_SECTOR to dax_radix_entry() because we expect that a
@@ -1065,7 +1066,13 @@ int dax_pfn_mkwrite(struct vm_area_struc
 	 * saves us from having to make a call to get_block() here to look
 	 * up the sector.
 	 */
-	dax_radix_entry(file->f_mapping, vmf->pgoff, NO_SECTOR, false, true);
+	error = dax_radix_entry(file->f_mapping, vmf->pgoff, NO_SECTOR, false,
+			true);
+
+	if (error == -ENOMEM)
+		return VM_FAULT_OOM;
+	if (error)
+		return VM_FAULT_SIGBUS;
 	return VM_FAULT_NOPAGE;
 }
 EXPORT_SYMBOL_GPL(dax_pfn_mkwrite);
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are


