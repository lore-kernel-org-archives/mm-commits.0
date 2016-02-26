From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs-v2.patch removed from -mm
 tree
Date: Fri, 26 Feb 2016 12:18:22 -0800
Message-ID: <56d0b30e.UJZlOuR1E3Bb14gq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55128 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbcBZUSY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Feb 2016 15:18:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kwapulinski.piotr@gmail.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, dan.j.williams@intel.com, dave.hansen@linux.intel.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs-v2
has been removed from the -mm tree.  Its filename was
     mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs-v2.patch

This patch was dropped because it was folded into mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs.patch

------------------------------------------------------
From: Piotr Kwapulinski <kwapulinski.piotr@gmail.com>
Subject: mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs-v2

The difference between v1 is that the prot variable is reset to
 reqprot for each loop iteration (thanks to Konstantin Khlebnikov for
pointing this out).
rier means "(current->personality & [R]EAD_[I]MPLIES_[E]XEC) &&
(prot & PROT_[R]EAD)".

Signed-off-by: Piotr Kwapulinski <kwapulinski.piotr@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/mprotect.c~mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs-v2 mm/mprotect.c
--- a/mm/mprotect.c~mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs-v2
+++ a/mm/mprotect.c
@@ -447,6 +447,7 @@ SYSCALL_DEFINE3(mprotect, unsigned long,
 			error = -ENOMEM;
 			goto out;
 		}
+		prot = reqprot;
 	}
 out:
 	up_write(&current->mm->mmap_sem);
_

Patches currently in -mm which might be from kwapulinski.piotr@gmail.com are

mm-mprotectc-dont-imply-prot_exec-on-non-exec-fs.patch

