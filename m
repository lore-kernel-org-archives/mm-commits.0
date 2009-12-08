From: akpm@linux-foundation.org
Subject: + mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range.patch added to -mm tree
Date: Tue, 08 Dec 2009 14:39:42 -0800
Message-ID: <200912082239.nB8MdgwG019623@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966742AbZLHWkv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Dec 2009 17:40:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, apw@canonical.com, fengguang.wu@intel.com, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, mel@csn.ul.ie, rientjes@google.com, stable@kernel.org


The patch titled
     mm: hugetlb: fix hugepage memory leak in walk_page_range()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: hugetlb: fix hugepage memory leak in walk_page_range()
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
should be in memory, and 1 hugepage is still accounted as used while there
is no file on hugetlbfs.

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

 mm/pagewalk.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

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
@@ -117,11 +119,21 @@ int walk_page_range(unsigned long addr, 
 	pgd = pgd_offset(walk->mm, addr);
 	do {
 		next = pgd_addr_end(addr, end);
+
+		/* skip hugetlb vma to avoid hugepage PMD being cleared
+		 * in pmd_none_or_clear_bad(). */
+		vma = find_vma(walk->mm, addr);
+		if (is_vm_hugetlb_page(vma)) {
+			next = (vma->vm_end < next) ? vma->vm_end : next;
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
@@ -131,7 +143,8 @@ int walk_page_range(unsigned long addr, 
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

mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-cleanup.patch
mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range.patch
mm-hugetlb-add-hugepage-support-to-pagemap.patch

