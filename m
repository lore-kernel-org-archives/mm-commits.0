From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-gup-fix-null-pointer-dereference-detected-by-coverity.patch added to -mm
 tree
Date: Wed, 08 Apr 2020 18:10:11 -0700
Message-ID: <20200409011011.yrijx6Jei%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbgDIBKN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Apr 2020 21:10:13 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ira.weiny@intel.com, miles.chen@mediatek.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: fix null pointer dereference detected by coverity
has been added to the -mm tree.  Its filename is
     mm-gup-fix-null-pointer-dereference-detected-by-coverity.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-gup-fix-null-pointer-dereference-detected-by-coverity.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-fix-null-pointer-dereference-detected-by-coverity.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miles Chen <miles.chen@mediatek.com>
Subject: mm/gup: fix null pointer dereference detected by coverity

In fixup_user_fault(), it is possible that unlocked is NULL,
so we should test unlocked before using it.

For example, in arch/arc/kernel/process.c, NULL is passed
to fixup_user_fault().

SYSCALL_DEFINE3(arc_usr_cmpxchg, int *, uaddr, int, expected, int, new)
{
...
	ret = fixup_user_fault(current, current->mm, (unsigned long) uaddr,
			       FAULT_FLAG_WRITE, NULL);
...
}

Link: http://lkml.kernel.org/r/20200407095107.1988-1-miles.chen@mediatek.com
Fixes: 4a9e1cda2748 ("mm: bring in additional flag for fixup_user_fault to signal unlock")
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/gup.c~mm-gup-fix-null-pointer-dereference-detected-by-coverity
+++ a/mm/gup.c
@@ -1231,7 +1231,8 @@ retry:
 	if (ret & VM_FAULT_RETRY) {
 		down_read(&mm->mmap_sem);
 		if (!(fault_flags & FAULT_FLAG_TRIED)) {
-			*unlocked = true;
+			if (unlocked)
+				*unlocked = true;
 			fault_flags |= FAULT_FLAG_TRIED;
 			goto retry;
 		}
_

Patches currently in -mm which might be from miles.chen@mediatek.com are

mm-gup-fix-null-pointer-dereference-detected-by-coverity.patch
