Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2883FC2
	for <mm-commits@vger.kernel.org>; Sat, 30 Nov 2024 04:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732940756; cv=none; b=Jx+jbpmRPKTcUSLAxYRp7rS5ds+HVKdV5wprvwzRhK8N+cxaj+TUo3Jm27ayMxRJwxGKa/Hjz70c8hQGSRHH6rEtl3CnCR88z4aotF5Z3q2QBj2NZ4MRi8v+/gSU3ROPy/goGqIPxvg26KmQLvIXO1En1nAOkfLa8kOS0G5wkqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732940756; c=relaxed/simple;
	bh=0zi1PKrKKRJuVx1SZWi8GBoB5PmvH6YOjBfuXpvg9KM=;
	h=Date:To:From:Subject:Message-Id; b=aVTc2wb2byNd060N8nJxkMTqepZ24xA0c7dqnW37H12mHQULKeky8xLd3t9ZTaRwh9MMw2N+d50jxYQZHAej4n/1GmR7u0CvBBlZGrBoGuxJdpGyywuZ2gd2+pPZKNG61RclZRIcc9vxS4/05qOEqkt9FPZFqOvI2Lp/wo70Gqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Joz4Gzys; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Joz4Gzys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1083C4CECC;
	Sat, 30 Nov 2024 04:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1732940754;
	bh=0zi1PKrKKRJuVx1SZWi8GBoB5PmvH6YOjBfuXpvg9KM=;
	h=Date:To:From:Subject:From;
	b=Joz4GzyscKjWEsY9vZgZabctVFH6XrA66+dy5nexsP+vuXzX3jIq2HY3RxzZoSBAn
	 u3rHv30QlHV9AncpTmNFipXJrxP7y+FEDSsTKKCwsNV0G7y7+nDxqnMqJ8nurVhVtW
	 hrmFi8GcjZALgFAfXGQPAgP/zkcdIFih0FIjmka4=
Date: Fri, 29 Nov 2024 20:25:54 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,torvalds@linuxfoundation.org,yongli-oc@zhaoxin.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + support-lockref-reference-count-if-enable-lock_stat.patch added to mm-unstable branch
Message-Id: <20241130042554.D1083C4CECC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/lockref.c: support lockref reference count if enable LOCK_STAT
has been added to the -mm mm-unstable branch.  Its filename is
     support-lockref-reference-count-if-enable-lock_stat.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/support-lockref-reference-count-if-enable-lock_stat.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: yongli-oc <yongli-oc@zhaoxin.com>
Subject: lib/lockref.c: support lockref reference count if enable LOCK_STAT
Date: Wed, 13 Nov 2024 16:57:03 +0800

Swap the positions of lock and count to support CMPXCHG_LOCKREF if
SPINLOCK_SIZE > 4 when enable LOCK_STAT.  The reference count can always
be used regardless of the spinlock_t size.

One of the struct lockref is used in dcache.h.  The spinlock_t is 4 bytes,
with the 4 bytes reference count, the struct lockref is a 8 bytes
variable, the count can be inc/dec by a 64 bits atomic operation, when the
spinlock is unlocked.

One of the struct lockref is used in dcache.h.  The spinlock_t is 4 bytes,
with the 4 bytes reference count, the struct lockref is a 8 bytes
variable, the count can be inc/dec by a 64 bits atomic operation, when the
spinlock is unlocked.

If the spinlock is more than 4 bytes, such as enable the kernel config
DEBUG_SPINLOCK or LOCK_STAT, the count inc/dec should got the spinlock
first, the sequence likes "lock; inc_ref; unlock;", which will caused
spinlock contention increased so much.

The chart below shows the spinlock contention with and without the lockref
patch.  it got by "cat /proc/lock_stat" after ubuntu 22.04 boot up.  I
tried each case two times.  the con-bounces and contentions of 6.6.28 with
LOCK_STAT enable are much more than it of the 6.6.28 lockref patched. 

With the lockref patch, the count can be operated by atomic too.  The
statistics result is similar to the 6.6.28 kernel production environment.

lock_stat version 0.4
  --------------------------------------------------
  bootup  class name     con-bounces    contentions
  times
  --------kernel 6.6.28, enable LOCK_STAT-----------
   1   &dentry->d_lock:    385336         413098
   2   &dentry->d_lock:    378268         402761
  --------------------------------------------------
  -------6.6.28 with lockref patch and LOCK_STAT----
   1   &dentry->d_lock:     79941          82431
   2   &dentry->d_lock:     77817          80301
  --------------------------------------------------

Link: https://lkml.kernel.org/r/20241113085703.148839-1-yongli-oc@zhaoxin.com
Signed-off-by: yongli-oc <yongli-oc@zhaoxin.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lockref.h |   17 ++++++++++-
 lib/lockref.c           |   58 +++++++++++++++++++++++++++-----------
 2 files changed, 58 insertions(+), 17 deletions(-)

--- a/include/linux/lockref.h~support-lockref-reference-count-if-enable-lock_stat
+++ a/include/linux/lockref.h
@@ -22,15 +22,30 @@
 	(IS_ENABLED(CONFIG_ARCH_USE_CMPXCHG_LOCKREF) && \
 	 IS_ENABLED(CONFIG_SMP) && SPINLOCK_SIZE <= 4)
 
+#define USE_CMPXCHG_LOCKREF_ALTERNATIVE \
+	(IS_ENABLED(CONFIG_ARCH_USE_CMPXCHG_LOCKREF) && \
+	 IS_ENABLED(CONFIG_SMP) && SPINLOCK_SIZE > 4)
+
 struct lockref {
 	union {
 #if USE_CMPXCHG_LOCKREF
 		aligned_u64 lock_count;
-#endif
 		struct {
 			spinlock_t lock;
 			int count;
 		};
+#elif USE_CMPXCHG_LOCKREF_ALTERNATIVE
+		aligned_u64 lock_count;
+		struct {
+			int count;
+			spinlock_t lock;
+		} __packed;
+#else
+		struct {
+			spinlock_t lock;
+			int count;
+		};
+#endif
 	};
 };
 
--- a/lib/lockref.c~support-lockref-reference-count-if-enable-lock_stat
+++ a/lib/lockref.c
@@ -8,22 +8,48 @@
  * Note that the "cmpxchg()" reloads the "old" value for the
  * failure case.
  */
-#define CMPXCHG_LOOP(CODE, SUCCESS) do {					\
-	int retry = 100;							\
-	struct lockref old;							\
-	BUILD_BUG_ON(sizeof(old) != 8);						\
-	old.lock_count = READ_ONCE(lockref->lock_count);			\
-	while (likely(arch_spin_value_unlocked(old.lock.rlock.raw_lock))) {  	\
-		struct lockref new = old;					\
-		CODE								\
-		if (likely(try_cmpxchg64_relaxed(&lockref->lock_count,		\
-						 &old.lock_count,		\
-						 new.lock_count))) {		\
-			SUCCESS;						\
-		}								\
-		if (!--retry)							\
-			break;							\
-	}									\
+#define CMPXCHG_LOOP(CODE, SUCCESS) do {				\
+	int retry = 100;						\
+	struct lockref old;						\
+	BUILD_BUG_ON(sizeof(old) != 8);					\
+	old.lock_count = READ_ONCE(lockref->lock_count);		\
+	while (likely(arch_spin_value_unlocked(old.lock.rlock.raw_lock))) {  \
+		struct lockref new = old;				\
+		CODE							\
+		if (likely(try_cmpxchg64_relaxed(&lockref->lock_count,	\
+						 &old.lock_count,	\
+						 new.lock_count))) {	\
+			SUCCESS;					\
+		}							\
+		if (!--retry)						\
+			break;						\
+	}								\
+} while (0)
+
+#elif USE_CMPXCHG_LOCKREF_ALTERNATIVE
+
+/*
+ * Note that the "cmpxchg()" reloads the "old" value for the
+ * failure case.
+ */
+#define CMPXCHG_LOOP(CODE, SUCCESS) do {				\
+	int retry = 100;						\
+	struct lockref old;						\
+	BUILD_BUG_ON(offsetof(struct lockref, lock) != 4);		\
+	BUILD_BUG_ON(offsetof(spinlock_t, rlock) != 0);			\
+	BUILD_BUG_ON(offsetof(raw_spinlock_t, raw_lock) != 0);		\
+	old.lock_count = READ_ONCE(lockref->lock_count);		\
+	while (likely(arch_spin_value_unlocked(old.lock.rlock.raw_lock))) {\
+		struct lockref new = old;				\
+		CODE							\
+		if (likely(try_cmpxchg64_relaxed(&lockref->lock_count,	\
+						 &old.lock_count,	\
+						 new.lock_count))) {	\
+			SUCCESS;					\
+		}							\
+		if (!--retry)						\
+			break;						\
+	}								\
 } while (0)
 
 #else
_

Patches currently in -mm which might be from yongli-oc@zhaoxin.com are

support-lockref-reference-count-if-enable-lock_stat.patch

