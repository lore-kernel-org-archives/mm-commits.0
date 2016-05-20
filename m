From: akpm@linux-foundation.org
Subject: [patch 048/117] x86: mm: use hugetlb_bad_size()
Date: Thu, 19 May 2016 17:11:20 -0700
Message-ID: <573e5628.A+MenqQ63R45kxO/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbcETALW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:11:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, vaishali.thakkar@oracle.com, baiyaowei@cmss.chinamobile.com, dave.hansen@linux.intel.com, dingel@linux.vnet.ibm.com, hillf.zj@alibaba-inc.com, hpa@zytor.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, mingo@elte.hu, n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, tglx@linutronix.de

From: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Subject: x86: mm: use hugetlb_bad_size()

Update setup_hugepagesz() to call hugetlb_bad_size() when unsupported
hugepage size is found.

Signed-off-by: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Yaowei Bai <baiyaowei@cmss.chinamobile.com>
Cc: Dominik Dingel <dingel@linux.vnet.ibm.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/hugetlbpage.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/mm/hugetlbpage.c~x86-mm-use-hugetlb_bad_size arch/x86/mm/hugetlbpage.c
--- a/arch/x86/mm/hugetlbpage.c~x86-mm-use-hugetlb_bad_size
+++ a/arch/x86/mm/hugetlbpage.c
@@ -165,6 +165,7 @@ static __init int setup_hugepagesz(char
 	} else if (ps == PUD_SIZE && boot_cpu_has(X86_FEATURE_GBPAGES)) {
 		hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);
 	} else {
+		hugetlb_bad_size();
 		printk(KERN_ERR "hugepagesz: Unsupported page size %lu M\n",
 			ps >> 20);
 		return 0;
_
