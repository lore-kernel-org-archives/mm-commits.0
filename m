From: akpm@linux-foundation.org
Subject: [nacked]
 mm-gup-fix-null-pointer-dereference-detected-by-coverity.patch removed from
 -mm tree
Date: Sat, 11 Apr 2020 23:43:51 -0700
Message-ID: <20200412064351.w3zOJQPsH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbgDLGnx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 12 Apr 2020 02:43:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ira.weiny@intel.com, miles.chen@mediatek.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: fix null pointer dereference detected by coverity
has been removed from the -mm tree.  Its filename was
     mm-gup-fix-null-pointer-dereference-detected-by-coverity.patch

This patch was dropped because it was nacked

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
