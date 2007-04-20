From: akpm@linux-foundation.org
Subject: + document-spin_lock_unlocked-rw_lock_unlocked-deprecation.patch added to -mm tree
Date: Thu, 19 Apr 2007 22:32:49 -0700
Message-ID: <200704200532.l3K5WnKx007793@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161282AbXDTFdd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 01:33:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael@ellerman.id.au, mingo@elte.hu


The patch titled
     Document SPIN_LOCK_UNLOCKED/RW_LOCK_UNLOCKED deprecation
has been added to the -mm tree.  Its filename is
     document-spin_lock_unlocked-rw_lock_unlocked-deprecation.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Document SPIN_LOCK_UNLOCKED/RW_LOCK_UNLOCKED deprecation
From: Michael Ellerman <michael@ellerman.id.au>

Apparently it's not cool anymore to use SPIN/RW_LOCK_UNLOCKED.  There's
some mention of this in Documentation/spinlocks.txt, but that only talks
about dynamic initialisation.

A comment in the code mentioning the preferred usage would be good IMHO.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spinlock_types.h |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN include/linux/spinlock_types.h~document-spin_lock_unlocked-rw_lock_unlocked-deprecation include/linux/spinlock_types.h
--- a/include/linux/spinlock_types.h~document-spin_lock_unlocked-rw_lock_unlocked-deprecation
+++ a/include/linux/spinlock_types.h
@@ -85,6 +85,11 @@ typedef struct {
 				RW_DEP_MAP_INIT(lockname) }
 #endif
 
+/*
+ * SPIN_LOCK_UNLOCKED and RW_LOCK_UNLOCKED are deprecated.
+ * Please use DEFINE_SPINLOCK()/DEFINE_RWLOCK() or
+ * __SPIN_LOCK_UNLOCKED()/__RW_LOCK_UNLOCKED() as appropriate.
+ */
 #define SPIN_LOCK_UNLOCKED	__SPIN_LOCK_UNLOCKED(old_style_spin_init)
 #define RW_LOCK_UNLOCKED	__RW_LOCK_UNLOCKED(old_style_rw_init)
 
_

Patches currently in -mm which might be from michael@ellerman.id.au are

powerpc-rtas-msi-support.patch
document-spin_lock_unlocked-rw_lock_unlocked-deprecation.patch
