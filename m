From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-fix-incorrect-proc-nr_hugepages-value.patch
 removed from -mm tree
Date: Tue, 23 Feb 2016 12:49:47 -0800
Message-ID: <56ccc5eb.Kz4bl4g32NOORYrZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53260 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbcBWUts (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Feb 2016 15:49:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vaishali.thakkar@oracle.com, dave.hansen@linux.intel.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb.c: fix incorrect proc nr_hugepages value
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-incorrect-proc-nr_hugepages-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Subject: mm/hugetlb.c: fix incorrect proc nr_hugepages value

Currently incorrect default hugepage pool size is reported by proc
nr_hugepages when number of pages for the default huge page size is
specified twice.

When multiple huge page sizes are supported, /proc/sys/vm/nr_hugepages
indicates the current number of pre-allocated huge pages of the default
size.  Basically /proc/sys/vm/nr_hugepages displays default_hstate->
max_huge_pages and after boot time pre-allocation, max_huge_pages should
equal the number of pre-allocated pages (nr_hugepages).

Test case:

Note that this is specific to x86 architecture.

Boot the kernel with command line option 'default_hugepagesz=1G
hugepages=X hugepagesz=2M hugepages=Y hugepagesz=1G hugepages=Z'.  After
boot, 'cat /proc/sys/vm/nr_hugepages' and 'sysctl -a | grep hugepages'
returns the value X.  However, dmesg output shows that Z huge pages were
pre-allocated.

So, the root cause of the problem here is that the global variable
default_hstate_max_huge_pages is set if a default huge page size is
specified (directly or indirectly) on the command line.  After the command
line processing in hugetlb_init, if default_hstate_max_huge_pages is set,
the value is assigned to default_hstae.max_huge_pages.  However,
default_hstate.max_huge_pages may have already been set based on the
number of pre-allocated huge pages of default_hstate size.

The solution to this problem is if hstate->max_huge_pages is already set
then it should not set as a result of global max_huge_pages value. 
Basically if the value of the variable hugepages is set multiple times on
a command line for a specific supported hugepagesize then proc layer
should consider the last specified value.

Signed-off-by: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-fix-incorrect-proc-nr_hugepages-value mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-fix-incorrect-proc-nr_hugepages-value
+++ a/mm/hugetlb.c
@@ -2630,8 +2630,10 @@ static int __init hugetlb_init(void)
 			hugetlb_add_hstate(HUGETLB_PAGE_ORDER);
 	}
 	default_hstate_idx = hstate_index(size_to_hstate(default_hstate_size));
-	if (default_hstate_max_huge_pages)
-		default_hstate.max_huge_pages = default_hstate_max_huge_pages;
+	if (default_hstate_max_huge_pages) {
+		if (!default_hstate.max_huge_pages)
+			default_hstate.max_huge_pages = default_hstate_max_huge_pages;
+	}
 
 	hugetlb_init_hstates();
 	gather_bootmem_prealloc();
_

Patches currently in -mm which might be from vaishali.thakkar@oracle.com are


