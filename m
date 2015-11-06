From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-use-memory-policy-when-available-fix.patch removed from -mm tree
Date: Thu, 05 Nov 2015 18:29:25 -0800
Message-ID: <563c1085.Qs/d1GyTP9VHlozX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52503 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031154AbbKFC30 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 21:29:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.hansen@linux.intel.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlbfs: Fix new warning in fault-time huge page allocation
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-use-memory-policy-when-available-fix.patch

This patch was dropped because it was folded into mm-hugetlb-use-memory-policy-when-available.patch

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm, hugetlbfs: Fix new warning in fault-time huge page allocation

Kirill reported that he hit:
>> +	if (vma || addr) {
>> +		WARN_ON_ONCE(!addr || addr == -1);
>
> Trinity triggered the WARN for me:

This was just a dumb mistake. I put the WARN_ON() in and planned to
have addr=0 mean "use nid". But, I realized pretty quickly that addr=0
_is_ a valid place to fault. So I made it addr=-1 in
__alloc_buddy_huge_page_no_mpol(), but I did not fix up the WARN_ON().

So hitting the warning in this case was harmless.  But, fix up the
warning condition.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-use-memory-policy-when-available-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-use-memory-policy-when-available-fix
+++ a/mm/hugetlb.c
@@ -1514,8 +1514,13 @@ static struct page *__alloc_buddy_huge_p
 	if (hstate_is_gigantic(h))
 		return NULL;
 
-	if (vma || addr) {
-		WARN_ON_ONCE(!addr || addr == -1);
+	/*
+	 * Make sure that anyone specifying 'nid' is not also specifying a VMA.
+	 * This makes sure the caller is picking _one_ of the modes with which
+	 * we can call this function, not both.
+	 */
+	if (vma || (addr != -1)) {
+		WARN_ON_ONCE(addr == -1);
 		WARN_ON_ONCE(nid != NUMA_NO_NODE);
 	}
 	/*
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

inotify-hide-internal-kernel-bits-from-fdinfo.patch
inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch.patch
mm-hugetlb-use-memory-policy-when-available.patch
mm-hugetlbfs-optimize-when-numa=n.patch

