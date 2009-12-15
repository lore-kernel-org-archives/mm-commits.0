From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:54:51 -0800
Message-ID: <200912152154.nBFLsptn015397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60875 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934022AbZLOWU0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:20:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, apw@canonical.com, fengguang.wu@intel.com, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, mel@csn.ul.ie, rientjes@google.com, stab


The patch titled
     mm: hugetlb: fix hugepage memory leak in walk_page_range()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: hugetlb: fix hugepage memory leak in walk_page_range()
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Most callers of pmd_none_or_clear_bad() check whether the target page is
in a hugepage or not, but walk_page_range() do not check it.  So if we
read /proc/pid/pagemap for the hugepage on x86 machine, the hugepage
memory is leaked as shown below.  This patch fixes it.

Details
=======
My test program (leak_pagemap) works as follows:
 - creat() and mmap() a file on hugetlbfs (file size is 200MB == 100 hugepages,)
 - read()/write() something on it,
 - call page-types with option -p (walk around the page tables),
 - munmap() and unlink() the file on hugetlbfs

Without my patches
------------------
$ cat /proc/meminfo |grep "HugePage"
HugePages_Total:    1000
HugePages_Free:     1000
HugePages_Rsvd:        0
HugePages_Surp:        0
$ ./leak_pagemap
[snip output]
$ cat /proc/meminfo |grep "HugePage"
HugePages_Total:    1000
HugePages_Free:      900
HugePages_Rsvd:        0
HugePages_Surp:        0
$ ls /hugetlbfs/
$

100 hugepages are accounted as used while there is no file on hugetlbfs.


With my patches
---------------
$ cat /proc/meminfo |grep "HugePage"
HugePages_Total:    1000
HugePages_Free:     1000
HugePages_Rsvd:        0
HugePages_Surp:        0
$ ./leak_pagemap
[snip output]
$ cat /proc/meminfo |grep "HugePage"
HugePages_Total:    1000
HugePages_Free:     1000
HugePages_Rsvd:        0
HugePages_Surp:        0
$ ls /hugetlbfs
$

No memory leaks.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff -puN mm/pagewalk.c~mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range mm/pagewalk.c
--- a/mm/pagewalk.c~mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range
+++ a/mm/pagewalk.c
@@ -1,6 +1,7 @@
 #include <linux/mm.h>
 #include <linux/highmem.h>
 #include <linux/sched.h>
+#include <linux/hugetlb.h>
 
 static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 			  struct mm_walk *walk)
@@ -107,6 +108,7 @@ int walk_page_range(unsigned long addr, 
 	pgd_t *pgd;
 	unsigned long next;
 	int err = 0;
+	struct vm_area_struct *vma;
 
 	if (addr >= end)
 		return err;
@@ -117,11 +119,22 @@ int walk_page_range(unsigned long addr, 
 	pgd = pgd_offset(walk->mm, addr);
 	do {
 		next = pgd_addr_end(addr, end);
+
+		/* skip hugetlb vma to avoid hugepage PMD being cleared
+		 * in pmd_none_or_clear_bad(). */
+		vma = find_vma(walk->mm, addr);
+		if (vma && is_vm_hugetlb_page(vma)) {
+			if (vma->vm_end < next)
+				next = vma->vm_end;
+			continue;
+		}
+
 		if (pgd_none_or_clear_bad(pgd)) {
 			if (walk->pte_hole)
 				err = walk->pte_hole(addr, next, walk);
 			if (err)
 				break;
+			pgd++;
 			continue;
 		}
 		if (walk->pgd_entry)
@@ -131,7 +144,8 @@ int walk_page_range(unsigned long addr, 
 			err = walk_pud_range(pgd, addr, next, walk);
 		if (err)
 			break;
-	} while (pgd++, addr = next, addr != end);
+		pgd++;
+	} while (addr = next, addr != end);
 
 	return err;
 }
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch

