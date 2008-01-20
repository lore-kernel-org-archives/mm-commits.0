From: akpm@linux-foundation.org
Subject: - ifdef-very-expensive-debug-check-in-page-fault-path.patch removed from -mm tree
Date: Sat, 19 Jan 2008 23:04:56 -0800
Message-ID: <200801200704.m0K74avK007818@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38644 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753713AbYATHEp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 Jan 2008 02:04:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cotte@de.ibm.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     #ifdef very expensive debug check in page fault path
has been removed from the -mm tree.  Its filename was
     ifdef-very-expensive-debug-check-in-page-fault-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: #ifdef very expensive debug check in page fault path
From: Carsten Otte <cotte@de.ibm.com>

This patch puts #ifdef CONFIG_DEBUG_VM around a check in vm_normal_page
that verifies that a pfn is valid.  This patch increases performance of the
page fault microbenchmark in lmbench by 13% and overall dbench performance
by 7% on s390x.  pfn_valid() is an expensive operation on s390 that needs a
high double digit amount of CPU cycles.  Nick Piggin suggested that
pfn_valid() involves an array lookup on systems with sparsemem, and
therefore is an expensive operation there too.

The check looks like a clear debug thing to me, it should never trigger on
regular kernels.  And if a pte is created for an invalid pfn, we'll find
out once the memory gets accessed later on anyway.  Please consider
inclusion of this patch into mm.

Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Acked-by: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/memory.c~ifdef-very-expensive-debug-check-in-page-fault-path mm/memory.c
--- a/mm/memory.c~ifdef-very-expensive-debug-check-in-page-fault-path
+++ a/mm/memory.c
@@ -392,6 +392,7 @@ struct page *vm_normal_page(struct vm_ar
 			return NULL;
 	}
 
+#ifdef CONFIG_DEBUG_VM
 	/*
 	 * Add some anal sanity checks for now. Eventually,
 	 * we should just do "return pfn_to_page(pfn)", but
@@ -402,6 +403,7 @@ struct page *vm_normal_page(struct vm_ar
 		print_bad_pte(vma, pte, addr);
 		return NULL;
 	}
+#endif
 
 	/*
 	 * NOTE! We still have PageReserved() pages in the page 
_

Patches currently in -mm which might be from cotte@de.ibm.com are

origin.patch
git-kvm.patch
check-advice-of-fadvice64_64-even-if-get_xip_page-is-given.patch
ext2-xip-check-fix.patch
