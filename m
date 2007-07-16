From: akpm@linux-foundation.org
Subject: - docs-static-initialization-of-spinlocks-is-ok.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:59:17 -0700
Message-ID: <200707162059.l6GKxHHQ002415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35998 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755718AbXGPVIA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:08:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     docs: static initialization of spinlocks is OK
has been removed from the -mm tree.  Its filename was
     docs-static-initialization-of-spinlocks-is-ok.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: docs: static initialization of spinlocks is OK
From: "Ed L. Cashin" <ecashin@coraid.com>

Static initialization of spinlocks is preferable to dynamic initialization
when it is practical.  This patch updates documentation for consistency
with comments in spinlock_types.h.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/spinlocks.txt |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN Documentation/spinlocks.txt~docs-static-initialization-of-spinlocks-is-ok Documentation/spinlocks.txt
--- a/Documentation/spinlocks.txt~docs-static-initialization-of-spinlocks-is-ok
+++ a/Documentation/spinlocks.txt
@@ -1,7 +1,12 @@
-UPDATE March 21 2005 Amit Gud <gud@eth.net>
+SPIN_LOCK_UNLOCKED and RW_LOCK_UNLOCKED defeat lockdep state tracking and
+are hence deprecated.
 
-Macros SPIN_LOCK_UNLOCKED and RW_LOCK_UNLOCKED are deprecated and will be
-removed soon. So for any new code dynamic initialization should be used:
+Please use DEFINE_SPINLOCK()/DEFINE_RWLOCK() or
+__SPIN_LOCK_UNLOCKED()/__RW_LOCK_UNLOCKED() as appropriate for static
+initialization.
+
+Dynamic initialization, when necessary, may be performed as
+demonstrated below.
 
    spinlock_t xxx_lock;
    rwlock_t xxx_rw_lock;
@@ -15,12 +20,9 @@ removed soon. So for any new code dynami
 
    module_init(xxx_init);
 
-Reasons for deprecation
-  - it hurts automatic lock validators
-  - it becomes intrusive for the realtime preemption patches
-
-Following discussion is still valid, however, with the dynamic initialization
-of spinlocks instead of static.
+The following discussion is still valid, however, with the dynamic
+initialization of spinlocks or with DEFINE_SPINLOCK, etc., used
+instead of SPIN_LOCK_UNLOCKED.
 
 -----------------------
 
_

Patches currently in -mm which might be from ecashin@coraid.com are

origin.patch
