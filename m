From: akpm@linux-foundation.org
Subject: [nacked] mutex-use-spin_lock-instead-of-arch_spin_lock.patch removed from -mm tree
Date: Fri, 25 Jan 2013 17:04:53 -0800
Message-ID: <20130126010454.6A2825A41B9@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:36222 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753496Ab3AZBEz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Jan 2013 20:04:55 -0500
Received: by mail-gh0-f202.google.com with SMTP id z10so98253ghb.5
        for <mm-commits@vger.kernel.org>; Fri, 25 Jan 2013 17:04:54 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuanhan.liu@linux.intel.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mutex: use spin_[un]lock instead of arch_spin_[un]lock
has been removed from the -mm tree.  Its filename was
     mutex-use-spin_lock-instead-of-arch_spin_lock.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: mutex: use spin_[un]lock instead of arch_spin_[un]lock

Use spin_[un]lock instead of arch_spin_[un]lock in mutex-debug.h so
that we can collect the lock statistics of spin_lock_mutex from
/proc/lock_stat.

Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---

index 0799fd3..556c0bc 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/mutex-debug.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/mutex-debug.h~mutex-use-spin_lock-instead-of-arch_spin_lock kernel/mutex-debug.h
--- a/kernel/mutex-debug.h~mutex-use-spin_lock-instead-of-arch_spin_lock
+++ a/kernel/mutex-debug.h
@@ -43,13 +43,13 @@ static inline void mutex_clear_owner(str
 							\
 		DEBUG_LOCKS_WARN_ON(in_interrupt());	\
 		local_irq_save(flags);			\
-		arch_spin_lock(&(lock)->rlock.raw_lock);\
+		spin_lock(lock);			\
 		DEBUG_LOCKS_WARN_ON(l->magic != l);	\
 	} while (0)
 
 #define spin_unlock_mutex(lock, flags)				\
 	do {							\
-		arch_spin_unlock(&(lock)->rlock.raw_lock);	\
+		spin_unlock(lock);				\
 		local_irq_restore(flags);			\
 		preempt_check_resched();			\
 	} while (0)
_

Patches currently in -mm which might be from yuanhan.liu@linux.intel.com are

mm-fix-wrong-comments-about-anon_vma-lock.patch
linux-next.patch
fs-execc-make-bprm_mm_init-static.patch
mutex-use-spin_lock-instead-of-arch_spin_lock-fix.patch

