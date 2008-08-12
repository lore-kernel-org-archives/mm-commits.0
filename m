From: akpm@linux-foundation.org
Subject: - lockdep-shrink-held_lock-structure-fix.patch removed from -mm tree
Date: Tue, 12 Aug 2008 13:33:26 -0700
Message-ID: <200808122033.m7CKXQH2011787@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42660 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751565AbYHLUeX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Aug 2008 16:34:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, davej@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     lockdep: shrink held_lock structure (fix)
has been removed from the -mm tree.  Its filename was
     lockdep-shrink-held_lock-structure-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lockdep: shrink held_lock structure (fix)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Replacement patch - on account of the old one having a bug that
basically disables lockdep.

Cc: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockdep.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/lockdep.h~lockdep-shrink-held_lock-structure-fix include/linux/lockdep.h
--- a/include/linux/lockdep.h~lockdep-shrink-held_lock-structure-fix
+++ a/include/linux/lockdep.h
@@ -229,10 +229,10 @@ struct held_lock {
 	 * The following field is used to detect when we cross into an
 	 * interrupt context:
 	 */
-	unsigned int irq_context:1;
+	unsigned int irq_context:2; /* bit 0 - soft, bit 1 - hard */
 	unsigned int trylock:1;
-	unsigned int read:2;
-	unsigned int check:1;
+	unsigned int read:2;        /* see lock_acquire() comment */
+	unsigned int check:2;       /* see lock_acquire() comment */
 	unsigned int hardirqs_off:1;
 };
 
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
linux-next.patch
irq-warn-about-irqf_disabledirqf_shared.patch

