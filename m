From: akpm@linux-foundation.org
Subject: +
 mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix-fix.patch added to -mm tree
Date: Tue, 09 Jan 2018 13:59:53 -0800
Message-ID: <5a553b59./4zYwrVGnu7eMwk7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35844 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754962AbeAIV7z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jan 2018 16:59:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, christian.koenig@amd.com, mhocko@suse.com, pbonzini@redhat.com, sivanich@hpe.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, mmu_notifier: annotate mmu notifiers with blockable invalidate callbacks fix fix
has been added to the -mm tree.  Its filename is
     mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, mmu_notifier: annotate mmu notifiers with blockable invalidate callbacks fix fix

Fix mmu_notifier.h comments in "mm, mmu_notifier: annotate mmu notifiers
with blockable invalidate callbacks".

mmu_notifier_invalidate_range_end() can also call the invalidate_range()
callback, so it must not block for MMU_INVALIDATE_DOES_NOT_BLOCK to be
set.

Also remove a bogus comment about invalidate_range() always being called
under the ptl spinlock.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1801091339570.240101@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Acked-by: Christian König <christian.koenig@amd.com>
Acked-by: Dimitri Sivanich <sivanich@hpe.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff -puN include/linux/mmu_notifier.h~mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix-fix include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix-fix
+++ a/include/linux/mmu_notifier.h
@@ -34,8 +34,8 @@ struct mmu_notifier_ops {
 	 * Flags to specify behavior of callbacks for this MMU notifier.
 	 * Used to determine which context an operation may be called.
 	 *
-	 * MMU_INVALIDATE_DOES_NOT_BLOCK: invalidate_{start,end} does not
-	 *				  block
+	 * MMU_INVALIDATE_DOES_NOT_BLOCK: invalidate_range_* callbacks do not
+	 *	block
 	 */
 	int flags;
 
@@ -151,8 +151,9 @@ struct mmu_notifier_ops {
 	 * address space but may still be referenced by sptes until
 	 * the last refcount is dropped.
 	 *
-	 * If both of these callbacks cannot block, mmu_notifier_ops.flags
-	 * should have MMU_INVALIDATE_DOES_NOT_BLOCK set.
+	 * If both of these callbacks cannot block, and invalidate_range
+	 * cannot block, mmu_notifier_ops.flags should have
+	 * MMU_INVALIDATE_DOES_NOT_BLOCK set.
 	 */
 	void (*invalidate_range_start)(struct mmu_notifier *mn,
 				       struct mm_struct *mm,
@@ -175,12 +176,13 @@ struct mmu_notifier_ops {
 	 * external TLB range needs to be flushed. For more in depth
 	 * discussion on this see Documentation/vm/mmu_notifier.txt
 	 *
-	 * The invalidate_range() function is called under the ptl
-	 * spin-lock and not allowed to sleep.
-	 *
 	 * Note that this function might be called with just a sub-range
 	 * of what was passed to invalidate_range_start()/end(), if
 	 * called between those functions.
+	 *
+	 * If this callback cannot block, and invalidate_range_{start,end}
+	 * cannot block, mmu_notifier_ops.flags should have
+	 * MMU_INVALIDATE_DOES_NOT_BLOCK set.
 	 */
 	void (*invalidate_range)(struct mmu_notifier *mn, struct mm_struct *mm,
 				 unsigned long start, unsigned long end);
_

Patches currently in -mm which might be from rientjes@google.com are

mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks.patch
mm-mmu_notifier-annotate-mmu-notifiers-with-blockable-invalidate-callbacks-fix-fix.patch
mm-oom-avoid-reaping-only-for-mms-with-blockable-invalidate-callbacks.patch

