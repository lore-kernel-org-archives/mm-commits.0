From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-correct-bit-shift-in-hstate_sizelog.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:57:16 -0800
Message-ID: <5489e90c.CLv2CFofOuw5tr2e%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45368 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794AbaLKS5R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:57:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sasha.levin@oracle.com, a.ryabinin@samsung.com, aarcange@redhat.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: correct bit shift in hstate_sizelog()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-correct-bit-shift-in-hstate_sizelog.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Sasha Levin <sasha.levin@oracle.com>
Subject: mm, hugetlb: correct bit shift in hstate_sizelog()

hstate_sizelog() would shift left an int rather than long, triggering
undefined behaviour and passing an incorrect value when the requested
page size was more than 4GB, thus breaking >4GB pages.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/hugetlb.h~mm-hugetlb-correct-bit-shift-in-hstate_sizelog include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlb-correct-bit-shift-in-hstate_sizelog
+++ a/include/linux/hugetlb.h
@@ -311,7 +311,8 @@ static inline struct hstate *hstate_size
 {
 	if (!page_size_log)
 		return &default_hstate;
-	return size_to_hstate(1 << page_size_log);
+
+	return size_to_hstate(1UL << page_size_log);
 }
 
 static inline struct hstate *hstate_vma(struct vm_area_struct *vma)
_

Patches currently in -mm which might be from sasha.levin@oracle.com are

origin.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

