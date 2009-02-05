From: akpm@linux-foundation.org
Subject: + mmu_notifiers-destroyed-by-__mmu_notifier_release-retain-extra-mm_count.patch added to -mm tree
Date: Thu, 05 Feb 2009 14:25:40 -0800
Message-ID: <200902052225.n15MPejn010091@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40684 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752779AbZBEW0I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 17:26:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, aarcange@redhat.com, cl@linux-foundation.org, npiggin@suse.de, stable@kernel.org


The patch titled
     mmu_notifiers destroyed by __mmu_notifier_release() retain extra mm_count
has been added to the -mm tree.  Its filename is
     mmu_notifiers-destroyed-by-__mmu_notifier_release-retain-extra-mm_count.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmu_notifiers destroyed by __mmu_notifier_release() retain extra mm_count
From: Robin Holt <holt@sgi.com>

An application relying upon mmu_notifier_release for teardown of the
mmu_notifiers will leak mm_structs.  At the do_mmu_notifier_register
increments mm_count, but __mmu_notifier_release() does not decrement it.

I detected this while running a 2.6.27 kernel.  It causes a denial of
service with OOM.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: <stable@kernel.org>		[2.6.27.x, 2.6.28.x]
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/mmu_notifier.c~mmu_notifiers-destroyed-by-__mmu_notifier_release-retain-extra-mm_count mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mmu_notifiers-destroyed-by-__mmu_notifier_release-retain-extra-mm_count
+++ a/mm/mmu_notifier.c
@@ -61,6 +61,7 @@ void __mmu_notifier_release(struct mm_st
 		if (mn->ops->release)
 			mn->ops->release(mn, mm);
 		rcu_read_unlock();
+		mmdrop(mm);	/* matches do_mmu_notifier_register's inc */
 		spin_lock(&mm->mmu_notifier_mm->lock);
 	}
 	spin_unlock(&mm->mmu_notifier_mm->lock);
_

Patches currently in -mm which might be from holt@sgi.com are

origin.patch
mmu_notifiers-destroyed-by-__mmu_notifier_release-retain-extra-mm_count.patch
factor-out-ifdefs-from-kernel-spinlockc-to-lock_contended_flags.patch
allow-rwlocks-to-re-enable-interrupts.patch
ia64-implement-interrupt-enabling-rwlocks.patch

