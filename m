From: akpm@linux-foundation.org
Subject: [merged]
 mm-export-find_extend_vma-and-handle_mm_fault-for-driver-use.patch removed
 from -mm tree
Date: Sat, 13 Dec 2014 20:07:23 -0800
Message-ID: <548d0cfb.T6GXLYploZMqj4Pl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47585 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbaLNEHP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:07:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbarnes@virtuousgeek.org, jroedel@suse.de, oded.gabbay@amd.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: export find_extend_vma() and handle_mm_fault() for driver use
has been removed from the -mm tree.  Its filename was
     mm-export-find_extend_vma-and-handle_mm_fault-for-driver-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: mm: export find_extend_vma() and handle_mm_fault() for driver use

This lets drivers like the AMD IOMMUv2 driver handle faults a bit more
simply, rather than doing tricks with page refs and get_user_pages().

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Oded Gabbay <oded.gabbay@amd.com>
Cc: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    1 +
 mm/mmap.c   |    2 ++
 2 files changed, 3 insertions(+)

diff -puN mm/memory.c~mm-export-find_extend_vma-and-handle_mm_fault-for-driver-use mm/memory.c
--- a/mm/memory.c~mm-export-find_extend_vma-and-handle_mm_fault-for-driver-use
+++ a/mm/memory.c
@@ -3365,6 +3365,7 @@ int handle_mm_fault(struct mm_struct *mm
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(handle_mm_fault);
 
 #ifndef __PAGETABLE_PUD_FOLDED
 /*
diff -puN mm/mmap.c~mm-export-find_extend_vma-and-handle_mm_fault-for-driver-use mm/mmap.c
--- a/mm/mmap.c~mm-export-find_extend_vma-and-handle_mm_fault-for-driver-use
+++ a/mm/mmap.c
@@ -2362,6 +2362,8 @@ find_extend_vma(struct mm_struct *mm, un
 }
 #endif
 
+EXPORT_SYMBOL_GPL(find_extend_vma);
+
 /*
  * Ok - we have the memory areas we should free on the vma list,
  * so release them, and do the vma updates.
_

Patches currently in -mm which might be from jbarnes@virtuousgeek.org are

origin.patch
linux-next.patch

