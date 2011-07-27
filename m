From: akpm@linux-foundation.org
Subject: [merged] asm-generic-atomich-fix-type-used-in-atomic_clear_mask.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:30:04 -0700
Message-ID: <201107271928.p6RJSogj003343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39562 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754885Ab1G0T3P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:29:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, arnd@arndb.de, asharma@fb.com, mm-commits@vger.kernel.org


The patch titled
     asm-generic/atomic.h: fix type used in atomic_clear_mask
has been removed from the -mm tree.  Its filename was
     asm-generic-atomich-fix-type-used-in-atomic_clear_mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm-generic/atomic.h: fix type used in atomic_clear_mask
From: Mike Frysinger <vapier@gentoo.org>

The atomic helpers are supposed to take an atomic_t pointer, not a random
unsigned long pointer.  So convert atomic_clear_mask over.

While we're here, also add some nice documentation to the func.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Arun Sharma <asharma@fb.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/atomic.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/atomic.h~asm-generic-atomich-fix-type-used-in-atomic_clear_mask include/asm-generic/atomic.h
--- a/include/asm-generic/atomic.h~asm-generic-atomich-fix-type-used-in-atomic_clear_mask
+++ a/include/asm-generic/atomic.h
@@ -140,13 +140,20 @@ static inline int __atomic_add_unless(at
   return c;
 }
 
-static inline void atomic_clear_mask(unsigned long mask, unsigned long *addr)
+/**
+ * atomic_clear_mask - Atomically clear bits in atomic variable
+ * @mask: Mask of the bits to be cleared
+ * @v: pointer of type atomic_t
+ *
+ * Atomically clears the bits set in @mask from @v
+ */
+static inline void atomic_clear_mask(unsigned long mask, atomic_t *v)
 {
 	unsigned long flags;
 
 	mask = ~mask;
 	raw_local_irq_save(flags); /* Don't trace it in a irqsoff handler */
-	*addr &= mask;
+	v->counter &= mask;
 	raw_local_irq_restore(flags);
 }
 
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch

