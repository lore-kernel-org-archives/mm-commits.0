From: akpm@linux-foundation.org
Subject: [merged] asm-generic-atomich-add-atomic_set_mask-helper.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:30:06 -0700
Message-ID: <201107271928.p6RJSq87003348@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755063Ab1G0T3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:29:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, arnd@arndb.de, asharma@fb.com, mm-commits@vger.kernel.org


The patch titled
     asm-generic/atomic.h: add atomic_set_mask() helper
has been removed from the -mm tree.  Its filename was
     asm-generic-atomich-add-atomic_set_mask-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm-generic/atomic.h: add atomic_set_mask() helper
From: Mike Frysinger <vapier@gentoo.org>

Since arches are expected to implement this guy, add a common version for
people the same way as atomic_clear_mask is handled.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Arun Sharma <asharma@fb.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/atomic.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff -puN include/asm-generic/atomic.h~asm-generic-atomich-add-atomic_set_mask-helper include/asm-generic/atomic.h
--- a/include/asm-generic/atomic.h~asm-generic-atomich-add-atomic_set_mask-helper
+++ a/include/asm-generic/atomic.h
@@ -157,6 +157,22 @@ static inline void atomic_clear_mask(uns
 	raw_local_irq_restore(flags);
 }
 
+/**
+ * atomic_set_mask - Atomically set bits in atomic variable
+ * @mask: Mask of the bits to be set
+ * @v: pointer of type atomic_t
+ *
+ * Atomically sets the bits set in @mask in @v
+ */
+static inline void atomic_set_mask(unsigned int mask, atomic_t *v)
+{
+	unsigned long flags;
+
+	raw_local_irq_save(flags); /* Don't trace it in a irqsoff handler */
+	v->counter |= mask;
+	raw_local_irq_restore(flags);
+}
+
 /* Assume that atomic operations are already serializing */
 #define smp_mb__before_atomic_dec()	barrier()
 #define smp_mb__after_atomic_dec()	barrier()
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch

