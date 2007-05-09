From: akpm@linux-foundation.org
Subject: - fix-leaky-resv_huge_pages-when-cpuset-is-in-use.patch removed from -mm tree
Date: Wed, 09 May 2007 14:49:18 -0700
Message-ID: <200705092149.l49LnIQk002688@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751076AbXEIVuz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:50:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kenchen@google.com, agl@us.ibm.com, david@gibson.dropbear.id.au, dwg@au1.ibm.com, mbligh@google.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     fix leaky resv_huge_pages when cpuset is in use
has been removed from the -mm tree.  Its filename was
     fix-leaky-resv_huge_pages-when-cpuset-is-in-use.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fix leaky resv_huge_pages when cpuset is in use
From: "Ken Chen" <kenchen@google.com>

The internal hugetlb resv_huge_pages variable can permanently leak nonzero
value in the error path of hugetlb page fault handler when hugetlb page is
used in combination of cpuset.  The leaked count can permanently trap N
number of hugetlb pages in unusable "reserved" state.

Steps to reproduce the bug:

  (1) create two cpuset, user1 and user2
  (2) reserve 50 htlb pages in cpuset user1
  (3) attempt to shmget/shmat 50 htlb page inside cpuset user2
  (4) kernel oom the user process in step 3
  (5) ipcrm the shm segment

At this point resv_huge_pages will have a count of 49, even though
there are no active hugetlbfs file nor hugetlb shared memory segment
in the system.  The leak is permanent and there is no recovery method
other than system reboot. The leaked count will hold up all future use
of that many htlb pages in all cpusets.

The culprit is that the error path of alloc_huge_page() did not
properly undo the change it made to resv_huge_page, causing
inconsistent state.

Signed-off-by: Ken Chen <kenchen@google.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Martin Bligh <mbligh@google.com>
Acked-by: David Gibson <dwg@au1.ibm.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/hugetlb.c~fix-leaky-resv_huge_pages-when-cpuset-is-in-use mm/hugetlb.c
--- a/mm/hugetlb.c~fix-leaky-resv_huge_pages-when-cpuset-is-in-use
+++ a/mm/hugetlb.c
@@ -140,6 +140,8 @@ static struct page *alloc_huge_page(stru
 	return page;
 
 fail:
+	if (vma->vm_flags & VM_MAYSHARE)
+		resv_huge_pages++;
 	spin_unlock(&hugetlb_lock);
 	return NULL;
 }
_

Patches currently in -mm which might be from kenchen@google.com are

origin.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
