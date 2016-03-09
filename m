From: akpm@linux-foundation.org
Subject: [folded-merged]
 dax-check-return-value-of-dax_radix_entry-v2.patch removed from -mm tree
Date: Wed, 09 Mar 2016 14:05:49 -0800
Message-ID: <56e09e3d.JLG1t7NsgjVEh3h+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56767 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934228AbcCIWFu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2016 17:05:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, david@fromorbit.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax-check-return-value-of-dax_radix_entry-v2
has been removed from the -mm tree.  Its filename was
     dax-check-return-value-of-dax_radix_entry-v2.patch

This patch was dropped because it was folded into dax-check-return-value-of-dax_radix_entry.patch

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: dax-check-return-value-of-dax_radix_entry-v2

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/dax.c~dax-check-return-value-of-dax_radix_entry-v2 fs/dax.c
--- a/fs/dax.c~dax-check-return-value-of-dax_radix_entry-v2
+++ a/fs/dax.c
@@ -1068,9 +1068,11 @@ int dax_pfn_mkwrite(struct vm_area_struc
 	 */
 	error = dax_radix_entry(file->f_mapping, vmf->pgoff, NO_SECTOR, false,
 			true);
-	if (error)
-		return error;
 
+	if (error == -ENOMEM)
+		return VM_FAULT_OOM;
+	if (error)
+		return VM_FAULT_SIGBUS;
 	return VM_FAULT_NOPAGE;
 }
 EXPORT_SYMBOL_GPL(dax_pfn_mkwrite);
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

dax-check-return-value-of-dax_radix_entry.patch

