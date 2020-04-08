From: akpm@linux-foundation.org
Subject: [merged]
 mm-mempolicy-add-missing-annotation-for-queue_pages_pmd.patch removed from
 -mm tree
Date: Tue, 07 Apr 2020 18:59:40 -0700
Message-ID: <20200408015940.fHuJtXNvn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHB7m (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:59:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbi.octave@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: add missing annotation for queue_pages_pmd()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-add-missing-annotation-for-queue_pages_pmd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jules Irenge <jbi.octave@gmail.com>
Subject: mm/mempolicy: add missing annotation for queue_pages_pmd()

Sparse reports a warning at queue_pages_pmd()

context imbalance in queue_pages_pmd() - unexpected unlock

The root cause is the missing annotation at queue_pages_pmd()
Add the missing __releases(ptl)

Link: http://lkml.kernel.org/r/20200214204741.94112-8-jbi.octave@gmail.com
Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/mempolicy.c~mm-mempolicy-add-missing-annotation-for-queue_pages_pmd
+++ a/mm/mempolicy.c
@@ -442,6 +442,7 @@ static inline bool queue_pages_required(
  */
 static int queue_pages_pmd(pmd_t *pmd, spinlock_t *ptl, unsigned long addr,
 				unsigned long end, struct mm_walk *walk)
+	__releases(ptl)
 {
 	int ret = 0;
 	struct page *page;
_

Patches currently in -mm which might be from jbi.octave@gmail.com are
