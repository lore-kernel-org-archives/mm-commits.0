From: akpm@linux-foundation.org
Subject: + arch-x86-mm-pageattr-testc-fix-false-positive-in-cpa-self-test.patch added to -mm tree
Date: Thu, 11 Apr 2013 14:52:07 -0700
Message-ID: <20130411215207.6FE8D31C10E@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:41841 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3DKVwI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Apr 2013 17:52:08 -0400
Received: by mail-qe0-f73.google.com with SMTP id 1so190935qee.0
        for <mm-commits@vger.kernel.org>; Thu, 11 Apr 2013 14:52:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, mingo@kernel.org


The patch titled
     Subject: arch/x86/mm/pageattr-test.c: fix false positive in CPA self test
has been added to the -mm tree.  Its filename is
     arch-x86-mm-pageattr-testc-fix-false-positive-in-cpa-self-test.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-pageattr-convert-noop-to-functional-fix.patch
arch-x86-mm-pageattr-testc-fix-false-positive-in-cpa-self-test.patch
thp-fix-comment-about-memory-barrier.patch

