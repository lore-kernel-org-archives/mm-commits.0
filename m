From: akpm@osdl.org
Subject: + fix-sparse-annotation-of-spin-unlock-macros-in-one-case.patch added to -mm tree
Date: Mon, 29 Jan 2007 23:52:15 -0800
Message-ID: <200701300752.l0U7qGjC012690@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47208 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965015AbXA3Hwh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jan 2007 02:52:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: proski@gnu.org, mingo@elte.hu


The patch titled
     Fix sparse annotation of spin unlock macros in one case
has been added to the -mm tree.  Its filename is
     fix-sparse-annotation-of-spin-unlock-macros-in-one-case.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Fix sparse annotation of spin unlock macros in one case
From: Pavel Roskin <proski@gnu.org>

SMP systems without preemption and spinlock debugging enabled use unlock
macros that don't tell sparse that the lock is being released.  Add sparse
annotations in this case.

Signed-off-by: Pavel Roskin <proski@gnu.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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

fix-sparse-annotation-of-spin-unlock-macros-in-one-case.patch
