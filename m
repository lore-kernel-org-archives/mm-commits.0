From: akpm@linux-foundation.org
Subject: +
 mm-thp-replace-smp_mb-after-atomic_add-by-smp_mb__after_atomic.patch added
 to -mm tree
Date: Wed, 18 Jun 2014 16:45:22 -0700
Message-ID: <53a22492.JLeRY38PxSZ9da6T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43196 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbaFRXpX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jun 2014 19:45:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, scott.norton@hp.com, riel@redhat.com, mgorman@suse.de, kirill.shutemov@linux.intel.com, aarcange@redhat.com, Waiman.Long@hp.com


The patch titled
     Subject: mm, thp: replace smp_mb after atomic_add by smp_mb__after_atomic
has been added to the -mm tree.  Its filename is
     mm-thp-replace-smp_mb-after-atomic_add-by-smp_mb__after_atomic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-thp-replace-smp_mb-after-atomic_add-by-smp_mb__after_atomic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-replace-smp_mb-after-atomic_add-by-smp_mb__after_atomic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-thp-move-invariant-bug-check-out-of-loop-in-__split_huge_page_map.patch
mm-thp-replace-smp_mb-after-atomic_add-by-smp_mb__after_atomic.patch

