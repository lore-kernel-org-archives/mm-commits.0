From: akpm@linux-foundation.org
Subject: + mm-make-the-function-madvise_behaviour_valid-bool.patch added
 to -mm tree
Date: Thu, 09 Jul 2015 15:49:11 -0700
Message-ID: <559efa67.tyPFmdJzU+xvThav%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53418 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbbGIWtL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jul 2015 18:49:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xerofoify@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise.c: make madvise_behaviour_valid() return bool
has been added to the -mm tree.  Its filename is
     mm-make-the-function-madvise_behaviour_valid-bool.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-make-the-function-madvise_behaviour_valid-bool.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-make-the-function-madvise_behaviour_valid-bool.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Nicholas Krause <xerofoify@gmail.com>
Subject: mm/madvise.c: make madvise_behaviour_valid() return bool

This makes the madvise_bahaviour_valid( return bool due to this particular
function always returning the value of either one or zero as its return
value.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/madvise.c~mm-make-the-function-madvise_behaviour_valid-bool mm/madvise.c
--- a/mm/madvise.c~mm-make-the-function-madvise_behaviour_valid-bool
+++ a/mm/madvise.c
@@ -386,7 +386,7 @@ madvise_vma(struct vm_area_struct *vma,
 	}
 }
 
-static int
+static bool
 madvise_behavior_valid(int behavior)
 {
 	switch (behavior) {
@@ -408,10 +408,10 @@ madvise_behavior_valid(int behavior)
 #endif
 	case MADV_DONTDUMP:
 	case MADV_DODUMP:
-		return 1;
+		return true;
 
 	default:
-		return 0;
+		return false;
 	}
 }
 
_

Patches currently in -mm which might be from xerofoify@gmail.com are

hugetlb-make-the-function-vma_shareable-bool.patch
mm-change-function-return-from-int-to-bool-for-the-function-is_page_busy.patch
memory-make-the-function-tlb_next_batch-bool-now.patch
mm-make-the-function-madvise_behaviour_valid-bool.patch
linux-next.patch

