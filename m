From: akpm@linux-foundation.org
Subject: + mm-hugetlb-use-memory-policy-when-available-fix.patch added to
 -mm tree
Date: Wed, 21 Oct 2015 15:02:42 -0700
Message-ID: <56280b82.W/KfDIUUU9WCPLxU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45909 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbbJUWCn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Oct 2015 18:02:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.hansen@linux.intel.com, hillf.zj@alibaba-inc.com, kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlbfs: Fix new warning in fault-time huge page allocation
has been added to the -mm tree.  Its filename is
     mm-hugetlb-use-memory-policy-when-available-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-use-memory-policy-when-available-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-use-memory-policy-when-available-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
inotify-actually-check-for-invalid-bits-in-sys_inotify_add_watch-v2.patch
mm-hugetlb-use-memory-policy-when-available.patch
mm-hugetlb-use-memory-policy-when-available-fix.patch
mm-hugetlbfs-optimize-when-numa=n.patch

