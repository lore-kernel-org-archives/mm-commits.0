From: akpm@linux-foundation.org
Subject: + mm-use-dedicated-helper-to-access-rlimit-value.patch added to
 -mm tree
Date: Wed, 05 Jul 2017 14:44:27 -0700
Message-ID: <595d5dbb.2AcU0q8KU3CetRl1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57550 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751784AbdGEVo2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2017 17:44:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: k.opasiak@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use dedicated helper to access rlimit value
has been added to the -mm tree.  Its filename is
     mm-use-dedicated-helper-to-access-rlimit-value.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-dedicated-helper-to-access-rlimit-value.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-dedicated-helper-to-access-rlimit-value.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Krzysztof Opasiak <k.opasiak@samsung.com>
Subject: mm: use dedicated helper to access rlimit value

Use rlimit() helper instead of manually writing whole chain from current
task to rlim_cur.

Link: http://lkml.kernel.org/r/20170705172811.8027-1-k.opasiak@samsung.com
Signed-off-by: Krzysztof Opasiak <k.opasiak@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/mmap.c~mm-use-dedicated-helper-to-access-rlimit-value mm/mmap.c
--- a/mm/mmap.c~mm-use-dedicated-helper-to-access-rlimit-value
+++ a/mm/mmap.c
@@ -2177,7 +2177,6 @@ static int acct_stack_growth(struct vm_a
 			     unsigned long size, unsigned long grow)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	struct rlimit *rlim = current->signal->rlim;
 	unsigned long new_start;
 
 	/* address space limit tests */
@@ -2185,7 +2184,7 @@ static int acct_stack_growth(struct vm_a
 		return -ENOMEM;
 
 	/* Stack limit test */
-	if (size > READ_ONCE(rlim[RLIMIT_STACK].rlim_cur))
+	if (size > rlimit(RLIMIT_STACK))
 		return -ENOMEM;
 
 	/* mlock limit tests */
@@ -2193,7 +2192,7 @@ static int acct_stack_growth(struct vm_a
 		unsigned long locked;
 		unsigned long limit;
 		locked = mm->locked_vm + grow;
-		limit = READ_ONCE(rlim[RLIMIT_MEMLOCK].rlim_cur);
+		limit = rlimit(RLIMIT_MEMLOCK);
 		limit >>= PAGE_SHIFT;
 		if (locked > limit && !capable(CAP_IPC_LOCK))
 			return -ENOMEM;
_

Patches currently in -mm which might be from k.opasiak@samsung.com are

mm-use-dedicated-helper-to-access-rlimit-value.patch

