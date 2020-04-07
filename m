From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 079/166] mm/mempolicy: add missing annotation for
 queue_pages_pmd()
Date: Mon, 06 Apr 2020 20:08:12 -0700
Message-ID: <20200407030812.Fdr-ZBRAj%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDIN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:08:13 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jbi.octave@gmail.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
