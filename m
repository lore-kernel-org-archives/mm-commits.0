From: akpm@linux-foundation.org
Subject: - semaphore-introduce-down_try.patch removed from -mm tree
Date: Fri, 23 May 2008 11:56:36 -0700
Message-ID: <200805231856.m4NIuadT004033@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60799 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751196AbYEWS57 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 14:57:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, hch@infradead.org, matthew@wil.cx, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     semaphore: introduce down_try()
has been removed from the -mm tree.  Its filename was
     semaphore-introduce-down_try.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: semaphore: introduce down_try()
From: Rusty Russell <rusty@rustcorp.com.au>

I plan on removing the much-disliked down_trylock() (with its backwards
return codes) in 2.6.27, but it's creating something of a logjam with
other patches in -mm and linux-next.

Andrew suggested introducing "down_try" as a wrapper now, to make the
transition easier.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/semaphore.h |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff -puN include/linux/semaphore.h~semaphore-introduce-down_try include/linux/semaphore.h
--- a/include/linux/semaphore.h~semaphore-introduce-down_try
+++ a/include/linux/semaphore.h
@@ -48,4 +48,18 @@ extern int __must_check down_trylock(str
 extern int __must_check down_timeout(struct semaphore *sem, long jiffies);
 extern void up(struct semaphore *sem);
 
+/**
+ * down_try - try to down a semaphore, but don't block
+ * @sem: the semaphore
+ *
+ * This is equivalent to down_trylock(), but has the same return codes as
+ * spin_trylock and mutex_trylock: 1 if semaphore acquired, 0 if not.
+ *
+ * down_trylock() with its confusing return codes will be deprecated
+ * soon.  It will not be missed.
+ */
+static inline int __must_check down_try(struct semaphore *sem)
+{
+        return !down_trylock(sem);
+}
 #endif /* __LINUX_SEMAPHORE_H */
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

origin.patch
linux-next.patch
lguest-use-cpu-capability-accessors.patch
semaphore-introduce-down_try.patch
semaphore-introduce-down_try-checkpatch-fixes.patch
undeprecate-down_trylock.patch
git-semaphore.patch
percpu-introduce-define_per_cpu_page_aligned.patch
reiser4.patch

