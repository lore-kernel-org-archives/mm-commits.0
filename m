From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:54:47 -0800
Message-ID: <200912152154.nBFLslY9015392@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53874 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761281AbZLOVz6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:55:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, apw@canonical.com, fengguang.wu@intel.com, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, mel@csn.ul.ie, rientjes@google.com, stab


The patch titled
     mm: hugetlb: fix hugepage memory leak in mincore()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: hugetlb: fix hugepage memory leak in mincore()
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Most callers of pmd_none_or_clear_bad() check whether the target page is
in a hugepage or not, but mincore() and walk_page_range() do not check it.
 So if we use mincore() on a hugepage on x86 machine, the hugepage memory
is leaked as shown below.  This patch fixes it by extending mincore()
system call to support hugepages.

Details
=======
My test program (leak_mincore) works as follows:
 - creat() and mmap() a file on hugetlbfs (file size is 200MB == 100 hugepages,)
 - read()/write() something on it,
 - call mincore() for first ten pages and printf() the values of *vec
 - munmap() and unlink() the file on hugetlbfs

Without my patch
----------------
$ cat /proc/meminfo| grep "HugePage"
HugePages_Total:    1000
HugePages_Free:     1000
HugePages_Rsvd:        0
HugePages_Surp:        0
$ ./leak_mincore
vec[0] 0
vec[1] 0
vec[2] 0
vec[3] 0
vec[4] 0
vec[5] 0
vec[6] 0
vec[7] 0
vec[8] 0
vec[9] 0
$ cat /proc/meminfo |grep "HugePage"
HugePages_Total:    1000
HugePages_Free:      999
HugePages_Rsvd:        0
HugePages_Surp:        0
$ ls /hugetlbfs/
$

Return values in *vec from mincore() are set to 0, while the hugepage
should be in memory, and 1 hugepage is still accounted as used while
there is no file on hugetlbfs.

With my patch
-------------
$ cat /proc/meminfo| grep "HugePage"
HugePages_Total:    1000
HugePages_Free:     1000
HugePages_Rsvd:        0
HugePages_Surp:        0
$ ./leak_mincore
vec[0] 1
vec[1] 1
vec[2] 1
vec[3] 1
vec[4] 1
vec[5] 1
vec[6] 1
vec[7] 1
vec[8] 1
vec[9] 1
$ cat /proc/meminfo |grep "HugePage"
HugePages_Total:    1000
HugePages_Free:     1000
HugePages_Rsvd:        0
HugePages_Surp:        0
$ ls /hugetlbfs/
$

Return value in *vec set to 1 and no memory leaks.

[akpm@linux-foundation.org: cleanup]
[akpm@linux-foundation.org: build fix]
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

 mm/mincore.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff -puN mm/mincore.c~mm-hugetlb-fix-hugepage-memory-leak-in-mincore mm/mincore.c
--- a/mm/mincore.c~mm-hugetlb-fix-hugepage-memory-leak-in-mincore
+++ a/mm/mincore.c
@@ -14,6 +14,7 @@
 #include <linux/syscalls.h>
 #include <linux/swap.h>
 #include <linux/swapops.h>
+#include <linux/hugetlb.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -72,6 +73,42 @@ static long do_mincore(unsigned long add
 	if (!vma || addr < vma->vm_start)
 		return -ENOMEM;
 
+#ifdef CONFIG_HUGETLB_PAGE
+	if (is_vm_hugetlb_page(vma)) {
+		struct hstate *h;
+		unsigned long nr_huge;
+		unsigned char present;
+
+		i = 0;
+		nr = min(pages, (vma->vm_end - addr) >> PAGE_SHIFT);
+		h = hstate_vma(vma);
+		nr_huge = ((addr + pages * PAGE_SIZE - 1) >> huge_page_shift(h))
+			  - (addr >> huge_page_shift(h)) + 1;
+		nr_huge = min(nr_huge,
+			      (vma->vm_end - addr) >> huge_page_shift(h));
+		while (1) {
+			/* hugepage always in RAM for now,
+			 * but generally it needs to be check */
+			ptep = huge_pte_offset(current->mm,
+					       addr & huge_page_mask(h));
+			present = !!(ptep &&
+				     !huge_pte_none(huge_ptep_get(ptep)));
+			while (1) {
+				vec[i++] = present;
+				addr += PAGE_SIZE;
+				/* reach buffer limit */
+				if (i == nr)
+					return nr;
+				/* check hugepage border */
+				if (!((addr & ~huge_page_mask(h))
+				      >> PAGE_SHIFT))
+					break;
+			}
+		}
+		return nr;
+	}
+#endif
+
 	/*
 	 * Calculate how many pages there are left in the last level of the
 	 * PTE array for our address.
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

origin.patch

