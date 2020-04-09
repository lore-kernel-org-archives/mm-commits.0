From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated]
 mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t.patch removed
 from -mm tree
Date: Wed, 08 Apr 2020 17:58:50 -0700
Message-ID: <20200409005850.Gu_0JGMtX%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbgDIA6v (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Apr 2020 20:58:51 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: mm/hugetlb.c: fix printk format warning for 32-bit phys_addr_t
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/hugetlb.c: fix printk format warning for 32-bit phys_addr_t

Fix printk format warnings when phys_addr_t is 32 bits, i.e.,
CONFIG_PHYS_ADDR_T_64BIT is not set/enabled.

Fixes these build warnings:
  CC      mm/hugetlb.o
In file included from ../include/linux/printk.h:7:0,
                 from ../include/linux/kernel.h:15,
                 from ../include/linux/list.h:9,
                 from ../mm/hugetlb.c:6:
../mm/hugetlb.c: In function `hugetlb_cma_reserve':
../include/linux/kern_levels.h:5:18: warning: format `%llu' expects argument of type `long long unsigned int', but argument 4 has type `unsigned int' [-Wformat=]
 #define KERN_SOH "^A"  /* ASCII Start Of Header */
                  ^
../include/linux/kern_levels.h:12:22: note: in expansion of macro `KERN_SOH'
 #define KERN_WARNING KERN_SOH "4" /* warning conditions */
                      ^~~~~~~~
../include/linux/printk.h:306:9: note: in expansion of macro `KERN_WARNING'
  printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
         ^~~~~~~~~~~~
../mm/hugetlb.c:5472:4: note: in expansion of macro `pr_warn'
    pr_warn("hugetlb_cma: reservation failed: err %d, node %d, [%llu, %llu)",
    ^~~~~~~
../mm/hugetlb.c:5472:67: note: format string is defined here
    pr_warn("hugetlb_cma: reservation failed: err %d, node %d, [%llu, %llu)",
                                                                ~~~^
                                                                %u
In file included from ../include/linux/printk.h:7:0,
                 from ../include/linux/kernel.h:15,
                 from ../include/linux/list.h:9,
                 from ../mm/hugetlb.c:6:
../include/linux/kern_levels.h:5:18: warning: format `%llu' expects argument of type `long long unsigned int', but argument 5 has type `unsigned int' [-Wformat=]
 #define KERN_SOH "^A"  /* ASCII Start Of Header */
                  ^
../include/linux/kern_levels.h:12:22: note: in expansion of macro `KERN_SOH'
 #define KERN_WARNING KERN_SOH "4" /* warning conditions */
                      ^~~~~~~~
../include/linux/printk.h:306:9: note: in expansion of macro `KERN_WARNING'
  printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)
         ^~~~~~~~~~~~
../mm/hugetlb.c:5472:4: note: in expansion of macro `pr_warn'
    pr_warn("hugetlb_cma: reservation failed: err %d, node %d, [%llu, %llu)",
    ^~~~~~~
../mm/hugetlb.c:5472:73: note: format string is defined here
    pr_warn("hugetlb_cma: reservation failed: err %d, node %d, [%llu, %llu)",
                                                                      ~~~^
                                                                      %u

Link: http://lkml.kernel.org/r/b74dcb60-ef35-f06e-de2d-b165ed38036a@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Joe Perches <joe@perches.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t
+++ a/mm/hugetlb.c
@@ -5600,8 +5600,10 @@ void __init hugetlb_cma_reserve(int orde
 					     0, false,
 					     "hugetlb", &hugetlb_cma[nid]);
 		if (res) {
-			pr_warn("hugetlb_cma: reservation failed: err %d, node %d, [%llu, %llu)",
-				res, nid, PFN_PHYS(min_pfn), PFN_PHYS(max_pfn));
+			phys_addr_t begpa = PFN_PHYS(min_pfn);
+			phys_addr_t endpa = PFN_PHYS(max_pfn);
+			pr_warn("hugetlb_cma: reservation failed: err %d, node %d, [%pap, %pap)",
+				res, nid, &begpa, &endpa);
 			break;
 		}
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are

mm-page_alloc-fix-kernel-doc-warning.patch
