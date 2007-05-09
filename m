From: akpm@linux-foundation.org
Subject: - document-spin_lock_unlocked-rw_lock_unlocked-deprecation.patch removed from -mm tree
Date: Tue, 08 May 2007 19:50:35 -0700
Message-ID: <200705090250.l492oZ7s009369@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970002AbXEICur (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:50:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael@ellerman.id.au, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Document SPIN_LOCK_UNLOCKED/RW_LOCK_UNLOCKED deprecation
has been removed from the -mm tree.  Its filename was
     document-spin_lock_unlocked-rw_lock_unlocked-deprecation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Document SPIN_LOCK_UNLOCKED/RW_LOCK_UNLOCKED deprecation
From: Michael Ellerman <michael@ellerman.id.au>

Apparently it's not cool anymore to use SPIN/RW_LOCK_UNLOCKED.  There's
some mention of this in Documentation/spinlocks.txt, but that only talks
about dynamic initialisation.

A comment in the code mentioning the preferred usage would be good IMHO.

[akpm@linux-foundation.org: add reason for deprecation]
Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spinlock_types.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN include/linux/spinlock_types.h~document-spin_lock_unlocked-rw_lock_unlocked-deprecation include/linux/spinlock_types.h
--- a/include/linux/spinlock_types.h~document-spin_lock_unlocked-rw_lock_unlocked-deprecation
+++ a/include/linux/spinlock_types.h
@@ -85,6 +85,12 @@ typedef struct {
 				RW_DEP_MAP_INIT(lockname) }
 #endif
 
+/*
+ * SPIN_LOCK_UNLOCKED and RW_LOCK_UNLOCKED defeat lockdep state tracking and
+ * are hence deprecated.
+ * Please use DEFINE_SPINLOCK()/DEFINE_RWLOCK() or
+ * __SPIN_LOCK_UNLOCKED()/__RW_LOCK_UNLOCKED() as appropriate.
+ */
 #define SPIN_LOCK_UNLOCKED	__SPIN_LOCK_UNLOCKED(old_style_spin_init)
 #define RW_LOCK_UNLOCKED	__RW_LOCK_UNLOCKED(old_style_rw_init)
 
_

Patches currently in -mm which might be from michael@ellerman.id.au are

origin.patch
