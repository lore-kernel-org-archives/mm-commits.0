From: akpm@linux-foundation.org
Subject: [merged]
 mm-compaction-add-missing-annotation-for-compact_lock_irqsave.patch removed
 from -mm tree
Date: Tue, 07 Apr 2020 18:59:36 -0700
Message-ID: <20200408015936.UqB9ce4-H%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgDHB7h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Apr 2020 21:59:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jbi.octave@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: add missing annotation for compact_lock_irqsave
has been removed from the -mm tree.  Its filename was
     mm-compaction-add-missing-annotation-for-compact_lock_irqsave.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jules Irenge <jbi.octave@gmail.com>
Subject: mm/compaction: add missing annotation for compact_lock_irqsave

Sparse reports a warning at compact_lock_irqsave()

warning: context imbalance in compact_lock_irqsave() - wrong count at exit

The root cause is the missing annotation at compact_lock_irqsave()
Add the missing __acquires(lock) annotation.

Link: http://lkml.kernel.org/r/20200214204741.94112-6-jbi.octave@gmail.com
Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/compaction.c~mm-compaction-add-missing-annotation-for-compact_lock_irqsave
+++ a/mm/compaction.c
@@ -481,6 +481,7 @@ static bool test_and_set_skip(struct com
  */
 static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
 						struct compact_control *cc)
+	__acquires(lock)
 {
 	/* Track if the lock is contended in async mode */
 	if (cc->mode == MIGRATE_ASYNC && !cc->contended) {
_

Patches currently in -mm which might be from jbi.octave@gmail.com are
