From: akpm@linux-foundation.org
Subject: [withdrawn] mmu_notifiers-destroyed-by-__mmu_notifier_release-retain-extra-mm_count.patch removed from -mm tree
Date: Fri, 06 Feb 2009 08:57:48 -0800
Message-ID: <200902061657.n16GvmR6021132@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259AbZBFQ6R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 11:58:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: holt@sgi.com, aarcange@redhat.com, cl@linux-foundation.org, npiggin@suse.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mmu_notifiers destroyed by __mmu_notifier_release() retain extra mm_count
has been removed from the -mm tree.  Its filename was
     mmu_notifiers-destroyed-by-__mmu_notifier_release-retain-extra-mm_count.patch

This patch was dropped because it was withdrawn

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

