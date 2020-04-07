From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 077/166] mm/compaction: add missing annotation for
 compact_lock_irqsave
Date: Mon, 06 Apr 2020 20:08:06 -0700
Message-ID: <20200407030806.7koAVNn-w%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgDGDIH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 6 Apr 2020 23:08:07 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, jbi.octave@gmail.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
