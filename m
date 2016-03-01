From: akpm@linux-foundation.org
Subject: + dax-check-return-value-of-dax_radix_entry.patch added to -mm
 tree
Date: Tue, 01 Mar 2016 14:22:01 -0800
Message-ID: <56d61609.tt76faQAfdl6S5ri%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbcCAWWC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2016 17:22:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax: check return value of dax_radix_entry()
has been added to the -mm tree.  Its filename is
     dax-check-return-value-of-dax_radix_entry.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-check-return-value-of-dax_radix_entry.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-check-return-value-of-dax_radix_entry.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax: check return value of dax_radix_entry()

dax_pfn_mkwrite() previously wasn't checking the return value of the call
to dax_radix_entry(), which was a mistake.

Instead, capture this return value and pass it up the stack if it is an
error.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

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
@@ -1065,7 +1066,11 @@ int dax_pfn_mkwrite(struct vm_area_struc
 	 * saves us from having to make a call to get_block() here to look
 	 * up the sector.
 	 */
-	dax_radix_entry(file->f_mapping, vmf->pgoff, NO_SECTOR, false, true);
+	error = dax_radix_entry(file->f_mapping, vmf->pgoff, NO_SECTOR, false,
+			true);
+	if (error)
+		return error;
+
 	return VM_FAULT_NOPAGE;
 }
 EXPORT_SYMBOL_GPL(dax_pfn_mkwrite);
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

dax-check-return-value-of-dax_radix_entry.patch

