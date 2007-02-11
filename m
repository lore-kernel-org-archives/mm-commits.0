From: akpm@linux-foundation.org
Subject: - fix-sparse-annotation-of-spin-unlock-macros-in-one-case.patch removed from -mm tree
Date: Sun, 11 Feb 2007 14:55:24 -0800
Message-ID: <200702112255.l1BMtOa6016317@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60707 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932898AbXBKW41 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Feb 2007 17:56:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: proski@gnu.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Fix sparse annotation of spin unlock macros in one case
has been removed from the -mm tree.  Its filename was
     fix-sparse-annotation-of-spin-unlock-macros-in-one-case.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix sparse annotation of spin unlock macros in one case
From: Pavel Roskin <proski@gnu.org>

SMP systems without premption and spinlock debugging enabled use unlock
macros that don't tell sparse that the lock is being released.  Add sparse
annotations in this case.

Signed-off-by: Pavel Roskin <proski@gnu.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/spinlock.h |   33 ++++++++++++++++++++++++---------
 1 file changed, 24 insertions(+), 9 deletions(-)

diff -puN include/linux/spinlock.h~fix-sparse-annotation-of-spin-unlock-macros-in-one-case include/linux/spinlock.h
--- a/include/linux/spinlock.h~fix-sparse-annotation-of-spin-unlock-macros-in-one-case
+++ a/include/linux/spinlock.h
@@ -228,15 +228,30 @@ do {								\
 # define read_unlock_irq(lock)		_read_unlock_irq(lock)
 # define write_unlock_irq(lock)		_write_unlock_irq(lock)
 #else
-# define spin_unlock(lock)		__raw_spin_unlock(&(lock)->raw_lock)
-# define read_unlock(lock)		__raw_read_unlock(&(lock)->raw_lock)
-# define write_unlock(lock)		__raw_write_unlock(&(lock)->raw_lock)
-# define spin_unlock_irq(lock) \
-    do { __raw_spin_unlock(&(lock)->raw_lock); local_irq_enable(); } while (0)
-# define read_unlock_irq(lock) \
-    do { __raw_read_unlock(&(lock)->raw_lock); local_irq_enable(); } while (0)
-# define write_unlock_irq(lock) \
-    do { __raw_write_unlock(&(lock)->raw_lock); local_irq_enable(); } while (0)
+# define spin_unlock(lock) \
+    do {__raw_spin_unlock(&(lock)->raw_lock); __release(lock); } while (0)
+# define read_unlock(lock) \
+    do {__raw_read_unlock(&(lock)->raw_lock); __release(lock); } while (0)
+# define write_unlock(lock) \
+    do {__raw_write_unlock(&(lock)->raw_lock); __release(lock); } while (0)
+# define spin_unlock_irq(lock)			\
+do {						\
+	__raw_spin_unlock(&(lock)->raw_lock);	\
+	__release(lock);			\
+	local_irq_enable();			\
+} while (0)
+# define read_unlock_irq(lock)			\
+do {						\
+	__raw_read_unlock(&(lock)->raw_lock);	\
+	__release(lock);			\
+	local_irq_enable();			\
+} while (0)
+# define write_unlock_irq(lock)			\
+do {						\
+	__raw_write_unlock(&(lock)->raw_lock);	\
+	__release(lock);			\
+	local_irq_enable();			\
+} while (0)
 #endif
 
 #define spin_unlock_irqrestore(lock, flags) \
_

Patches currently in -mm which might be from proski@gnu.org are

origin.patch
