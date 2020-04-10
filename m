From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 07/35] mm/gup: fix null pointer dereference
 detected by coverity
Date: Fri, 10 Apr 2020 14:32:35 -0700
Message-ID: <20200410213235.M6eTaELL2%akpm@linux-foundation.org>
References: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgDJVcf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 17:32:35 -0400
In-Reply-To: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ira.weiny@intel.com, linux-mm@kvack.org, miles.chen@mediatek.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
