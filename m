From: akpm@linux-foundation.org
Subject: [patch 043/117] mm/hugetlb: introduce hugetlb_bad_size()
Date: Thu, 19 May 2016 17:11:04 -0700
Message-ID: <573e5618.1f9le00qx38ZFoj9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbcETALL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:11:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vaishali.thakkar@oracle.com, baiyaowei@cmss.chinamobile.com, benh@kernel.crashing.org, dave.hansen@linux.intel.com, dingel@linux.vnet.ibm.com, hillf.zj@alibaba-inc.com, hpa@zytor.com, james.hogan@imgtec.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, mingo@elte.hu, n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, tglx@linutronix.de

From: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Subject: mm/hugetlb: introduce hugetlb_bad_size()

When any unsupported hugepage size is specified, 'hugepagesz=' and
'hugepages=' should be ignored during command line parsing until any
supported hugepage size is found.  But currently incorrect number of
hugepages are allocated when unsupported size is specified as it fails to
ignore the 'hugepages=' command.

Test case:

Note that this is specific to x86 architecture.

Boot the kernel with command line option 'hugepagesz=256M hugepages=X'. 
After boot, dmesg output shows that X number of hugepages of the size 2M
is pre-allocated instead of 0.

So, to handle such command line options, introduce new routine
hugetlb_bad_size.  The routine hugetlb_bad_size sets the global variable
parsed_valid_hugepagesz.  We are using parsed_valid_hugepagesz to save the
state when unsupported hugepagesize is found so that we can ignore the
'hugepages=' parameters after that and then reset the variable when
supported hugepage size is found.

The routine hugetlb_bad_size can be called while setting 'hugepagesz='
parameter in an architecture specific code.

Signed-off-by: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Cc: Dominik Dingel <dingel@linux.vnet.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: James Hogan <james.hogan@imgtec.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    1 +
 mm/hugetlb.c            |   14 +++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-introduce-hugetlb_bad_size include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-introduce-hugetlb_bad_size
+++ a/include/linux/hugetlb.h
@@ -338,6 +338,7 @@ int huge_add_to_page_cache(struct page *
 /* arch callback */
 int __init alloc_bootmem_huge_page(struct hstate *h);
 
+void __init hugetlb_bad_size(void);
 void __init hugetlb_add_hstate(unsigned order);
 struct hstate *size_to_hstate(unsigned long size);
 
diff -puN mm/hugetlb.c~mm-hugetlb-introduce-hugetlb_bad_size mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-introduce-hugetlb_bad_size
+++ a/mm/hugetlb.c
@@ -51,6 +51,7 @@ __initdata LIST_HEAD(huge_boot_pages);
 static struct hstate * __initdata parsed_hstate;
 static unsigned long __initdata default_hstate_max_huge_pages;
 static unsigned long __initdata default_hstate_size;
+static bool __initdata parsed_valid_hugepagesz = true;
 
 /*
  * Protects updates to hugepage_freelists, hugepage_activelist, nr_huge_pages,
@@ -2659,6 +2660,11 @@ static int __init hugetlb_init(void)
 subsys_initcall(hugetlb_init);
 
 /* Should be called on processing a hugepagesz=... option */
+void __init hugetlb_bad_size(void)
+{
+	parsed_valid_hugepagesz = false;
+}
+
 void __init hugetlb_add_hstate(unsigned int order)
 {
 	struct hstate *h;
@@ -2691,11 +2697,17 @@ static int __init hugetlb_nrpages_setup(
 	unsigned long *mhp;
 	static unsigned long *last_mhp;
 
+	if (!parsed_valid_hugepagesz) {
+		pr_warn("hugepages = %s preceded by "
+			"an unsupported hugepagesz, ignoring\n", s);
+		parsed_valid_hugepagesz = true;
+		return 1;
+	}
 	/*
 	 * !hugetlb_max_hstate means we haven't parsed a hugepagesz= parameter yet,
 	 * so this hugepages= parameter goes to the "default hstate".
 	 */
-	if (!hugetlb_max_hstate)
+	else if (!hugetlb_max_hstate)
 		mhp = &default_hstate_max_huge_pages;
 	else
 		mhp = &parsed_hstate->max_huge_pages;
_
