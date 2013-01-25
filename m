From: akpm@linux-foundation.org
Subject: + mutex-use-spin_lock-instead-of-arch_spin_lock.patch added to -mm tree
Date: Thu, 24 Jan 2013 16:14:24 -0800
Message-ID: <20130125001425.2AFE631C1D4@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:58643 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3AYAO0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jan 2013 19:14:26 -0500
Received: by mail-qe0-f73.google.com with SMTP id 7so166161qeb.0
        for <mm-commits@vger.kernel.org>; Thu, 24 Jan 2013 16:14:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yuanhan.liu@linux.intel.com, mingo@kernel.org


The patch titled
     Subject: mutex: use spin_[un]lock instead of arch_spin_[un]lock
has been added to the -mm tree.  Its filename is
     mutex-use-spin_lock-instead-of-arch_spin_lock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
lockstat-fix-a-typo.patch
fs-execc-make-bprm_mm_init-static.patch
mutex-use-spin_lock-instead-of-arch_spin_lock.patch
mutex-use-spin_lock-instead-of-arch_spin_lock-fix.patch

