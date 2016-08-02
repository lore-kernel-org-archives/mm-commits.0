From: akpm@linux-foundation.org
Subject: [patch 009/111] mm/hugetlb: avoid soft lockup in
 set_max_huge_pages()
Date: Tue, 02 Aug 2016 14:02:31 -0700
Message-ID: <57a10a67.t/ObZcQI446RCKRk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60006 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbcHBVCd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Aug 2016 17:02:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, hejianet@gmail.com, dave.hansen@linux.intel.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, stable@vger.kernel.org

From: Jia He <hejianet@gmail.com>
Subject: mm/hugetlb: avoid soft lockup in set_max_huge_pages()

In powerpc servers with large memory(32TB), we watched several soft
lockups for hugepage under stress tests.

The call traces are as follows:
1.
get_page_from_freelist+0x2d8/0xd50
__alloc_pages_nodemask+0x180/0xc20
alloc_fresh_huge_page+0xb0/0x190
set_max_huge_pages+0x164/0x3b0

2.
prep_new_huge_page+0x5c/0x100
alloc_fresh_huge_page+0xc8/0x190
set_max_huge_pages+0x164/0x3b0

This patch fixes such soft lockups.  It is safe to call cond_resched()
there because it is out of spin_lock/unlock section.

Link: http://lkml.kernel.org/r/1469674442-14848-1-git-send-email-hejianet@gmail.com
Signed-off-by: Jia He <hejianet@gmail.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/hugetlb.c~mm-hugetlb-avoid-soft-lockup-in-set_max_huge_pages mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-avoid-soft-lockup-in-set_max_huge_pages
+++ a/mm/hugetlb.c
@@ -2216,6 +2216,10 @@ static unsigned long set_max_huge_pages(
 		 * and reducing the surplus.
 		 */
 		spin_unlock(&hugetlb_lock);
+
+		/* yield cpu to avoid soft lockup */
+		cond_resched();
+
 		if (hstate_is_gigantic(h))
 			ret = alloc_fresh_gigantic_page(h, nodes_allowed);
 		else
_
