From: akpm@linux-foundation.org
Subject: [merged] arch-x86-mm-pageattr-testc-fix-false-positive-in-cpa-self-test.patch removed from -mm tree
Date: Mon, 15 Apr 2013 13:04:47 -0700
Message-ID: <20130415200447.75D0A5A42E5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:51360 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab3DOUEs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Apr 2013 16:04:48 -0400
Received: by mail-ye0-f201.google.com with SMTP id m2so504010yen.4
        for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2013 13:04:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/mm/pageattr-test.c: fix false positive in CPA self test
has been removed from the -mm tree.  Its filename was
     arch-x86-mm-pageattr-testc-fix-false-positive-in-cpa-self-test.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: arch/x86/mm/pageattr-test.c: fix false positive in CPA self test

If the pmd is not present, _PAGE_PSE will not be set anymore. Fix the
false positive.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/pageattr-test.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/mm/pageattr-test.c~arch-x86-mm-pageattr-testc-fix-false-positive-in-cpa-self-test arch/x86/mm/pageattr-test.c
--- a/arch/x86/mm/pageattr-test.c~arch-x86-mm-pageattr-testc-fix-false-positive-in-cpa-self-test
+++ a/arch/x86/mm/pageattr-test.c
@@ -68,7 +68,7 @@ static int print_split(struct split_stat
 			s->gpg++;
 			i += GPS/PAGE_SIZE;
 		} else if (level == PG_LEVEL_2M) {
-			if (!(pte_val(*pte) & _PAGE_PSE)) {
+			if ((pte_val(*pte) & _PAGE_PRESENT) && !(pte_val(*pte) & _PAGE_PSE)) {
 				printk(KERN_ERR
 					"%lx level %d but not PSE %Lx\n",
 					addr, level, (u64)pte_val(*pte));
_

Patches currently in -mm which might be from aarcange@redhat.com are

thp-fix-comment-about-memory-barrier.patch
mm-thp-add-split-tail-pages-to-shrink-page-list-in-page-reclaim.patch

