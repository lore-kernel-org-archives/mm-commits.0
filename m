From: akpm@linux-foundation.org
Subject: [merged]
 mm-thp-replace-smp_mb-after-atomic_add-by-smp_mb__after_atomic.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:04:15 -0700
Message-ID: <53e3dbbf.g436+V08zHcxp9x2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oa0-f74.google.com ([209.85.219.74]:52552 "EHLO
	mail-oa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaHGUEQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:04:16 -0400
Received: by mail-oa0-f74.google.com with SMTP id eb12so842988oac.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:04:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Waiman.Long@hp.com, aarcange@redhat.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, riel@redhat.com, scott.norton@hp.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, thp: replace smp_mb after atomic_add by smp_mb__after_atomic
has been removed from the -mm tree.  Its filename was
     mm-thp-replace-smp_mb-after-atomic_add-by-smp_mb__after_atomic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Waiman Long <Waiman.Long@hp.com>
Subject: mm, thp: replace smp_mb after atomic_add by smp_mb__after_atomic

In some architectures like x86, atomic_add() is a full memory barrier.  In
that case, an additional smp_mb() is just a waste of time.  This patch
replaces that smp_mb() by smp_mb__after_atomic() which will avoid the
redundant memory barrier in some architectures.

With a 3.16-rc1 based kernel, this patch reduced the execution time of
breaking 1000 transparent huge pages from 38,245us to 30,964us.  A
reduction of 19% which is quite sizeable.  It also reduces the %cpu time
of the __split_huge_page_refcount function in the perf profile from 2.18%
to 1.15%.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Scott J Norton <scott.norton@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/huge_memory.c~mm-thp-replace-smp_mb-after-atomic_add-by-smp_mb__after_atomic mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-replace-smp_mb-after-atomic_add-by-smp_mb__after_atomic
+++ a/mm/huge_memory.c
@@ -1681,7 +1681,7 @@ static void __split_huge_page_refcount(s
 			   &page_tail->_count);
 
 		/* after clearing PageTail the gup refcount can be released */
-		smp_mb();
+		smp_mb__after_atomic();
 
 		/*
 		 * retain hwpoison flag of the poisoned tail page:
_

Patches currently in -mm which might be from Waiman.Long@hp.com are

origin.patch

