From: akpm@linux-foundation.org
Subject: + dax-check-return-value-of-dax_radix_entry-v2.patch added to -mm tree
Date: Fri, 04 Mar 2016 15:02:31 -0800
Message-ID: <56da1407.MhLAGrWeU1mxdx05%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44818 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759633AbcCDXCc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2016 18:02:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, dan.j.williams@intel.com, david@fromorbit.com, willy@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: dax-check-return-value-of-dax_radix_entry-v2
has been added to the -mm tree.  Its filename is
     dax-check-return-value-of-dax_radix_entry-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/dax-check-return-value-of-dax_radix_entry-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/dax-check-return-value-of-dax_radix_entry-v2.patch

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
dax-check-return-value-of-dax_radix_entry-v2.patch

