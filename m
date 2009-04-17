From: akpm@linux-foundation.org
Subject: [merged] mm-pass-correct-mm-when-growing-stack.patch removed from -mm tree
Date: Fri, 17 Apr 2009 11:14:20 -0700
Message-ID: <200904171814.n3HIEKA9019158@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38317 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755528AbZDQSfQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Apr 2009 14:35:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, penguin-kernel@i-love.sakura.ne.jp, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: pass correct mm when growing stack
has been removed from the -mm tree.  Its filename was
     mm-pass-correct-mm-when-growing-stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: pass correct mm when growing stack
From: Hugh Dickins <hugh@veritas.com>

Tetsuo Handa reports seeing the WARN_ON(current->mm == NULL) in
security_vm_enough_memory(), when do_execve() is touching the target mm's
stack, to set up its args and environment.

Yes, a UMH_NO_WAIT or UMH_WAIT_PROC call_usermodehelper() spawns an
mm-less kernel thread to do the exec.  And in any case, that
vm_enough_memory check when growing stack ought to be done on the target
mm, not on the execer's mm (though apart from the warning, it only makes a
slight tweak to OVERCOMMIT_NEVER behaviour).

Reported-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: <stable@kernel.org>		[2.6.28.x, 2.6.29.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mmap.c~mm-pass-correct-mm-when-growing-stack mm/mmap.c
--- a/mm/mmap.c~mm-pass-correct-mm-when-growing-stack
+++ a/mm/mmap.c
@@ -1575,7 +1575,7 @@ static int acct_stack_growth(struct vm_a
 	 * Overcommit..  This must be the final test, as it will
 	 * update security statistics.
 	 */
-	if (security_vm_enough_memory(grow))
+	if (security_vm_enough_memory_mm(mm, grow))
 		return -ENOMEM;
 
 	/* Ok, everything looks good - let it rip */
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
clocksource-pass-clocksource-to-read-callback.patch
mm-disable-preemption-in-apply_to_pte_range.patch
getrusage-fill-ru_maxrss-value.patch
prio_tree-debugging-patch.patch

