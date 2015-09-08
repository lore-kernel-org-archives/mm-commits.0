From: akpm@linux-foundation.org
Subject: [merged] mm-make-the-function-madvise_behaviour_valid-bool.patch
 removed from -mm tree
Date: Tue, 08 Sep 2015 11:12:15 -0700
Message-ID: <55ef24ff.WTNtCG4LkG1Dgbol%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60427 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbbIHSMP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Sep 2015 14:12:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xerofoify@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/madvise.c: make madvise_behaviour_valid() return bool
has been removed from the -mm tree.  Its filename was
     mm-make-the-function-madvise_behaviour_valid-bool.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-make-the-function-set_recommended_min_free_kbytes-have-a-return-type-of-void.patch

