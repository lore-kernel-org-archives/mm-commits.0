Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CDF1E7C1C;
	Sat,  2 Aug 2025 18:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160865; cv=none; b=qgUyP9erLEVoYK9c0+F1rXbo1Uvf/sxIiya2N7qs2GkDly0FX90NqFrUFCupamoNnE79LaM3CnBDD8+HzPSrRzNYhT3CTteS3d4J3XJRRheXxhID4MuENQSOa545YVzSH1VddPD9Q0gkxpTmF3rSP5MQCyV6aJqpWW9mDpAMGxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160865; c=relaxed/simple;
	bh=1YFkP2J/8WHkQvaHW+DG5sRT7y4/csOCmR1Viv3n9Jo=;
	h=Date:To:From:Subject:Message-Id; b=EoA/S6o89esGIr3dhZqXkHCiZUiDtFP/5g8NO5U2s86OZfeqEGQumdTOPrJpNLZgcxce699bQUzBEskSIrUgL+fv9BShLO7KzQR8ad5TzuUeYQSl2en+gtfm/vzd/D9sh61sHapcYbgSKGuHeFnhYGa82jFOxHeDJWbf7bCPC5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=otZbs5q4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="otZbs5q4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60EA5C4CEEF;
	Sat,  2 Aug 2025 18:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160865;
	bh=1YFkP2J/8WHkQvaHW+DG5sRT7y4/csOCmR1Viv3n9Jo=;
	h=Date:To:From:Subject:From;
	b=otZbs5q4W7FJxhAYrTFQbIpRTC8XU1BsMd0WW7xVLw2D19V/xjvLOWiaxU7yv42xF
	 udi0cN1pvwUDw5qwJP9dsicBE9I8Ow1ZWNHk/WbZpzTTAwXM6Cy+mAlOfRuhcnj8Qo
	 vUFo+JJkkGN0fZu81Yj4JdtHMVBYaTfmhr0ZcfDI=
Date: Sat, 02 Aug 2025 11:54:24 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,stable@vger.kernel.org,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-a-uaf-when-vma-mm-is-freed-after-vma-vm_refcnt-got-dropped.patch removed from -mm tree
Message-Id: <20250802185425.60EA5C4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: fix a UAF when vma->mm is freed after vma->vm_refcnt got dropped
has been removed from the -mm tree.  Its filename was
     mm-fix-a-uaf-when-vma-mm-is-freed-after-vma-vm_refcnt-got-dropped.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: fix a UAF when vma->mm is freed after vma->vm_refcnt got dropped
Date: Mon, 28 Jul 2025 10:53:55 -0700

By inducing delays in the right places, Jann Horn created a reproducer for
a hard to hit UAF issue that became possible after VMAs were allowed to be
recycled by adding SLAB_TYPESAFE_BY_RCU to their cache.

Race description is borrowed from Jann's discovery report:
lock_vma_under_rcu() looks up a VMA locklessly with mas_walk() under
rcu_read_lock().  At that point, the VMA may be concurrently freed, and it
can be recycled by another process.  vma_start_read() then increments the
vma->vm_refcnt (if it is in an acceptable range), and if this succeeds,
vma_start_read() can return a recycled VMA.

In this scenario where the VMA has been recycled, lock_vma_under_rcu()
will then detect the mismatching ->vm_mm pointer and drop the VMA through
vma_end_read(), which calls vma_refcount_put().  vma_refcount_put() drops
the refcount and then calls rcuwait_wake_up() using a copy of vma->vm_mm. 
This is wrong: It implicitly assumes that the caller is keeping the VMA's
mm alive, but in this scenario the caller has no relation to the VMA's mm,
so the rcuwait_wake_up() can cause UAF.

The diagram depicting the race:
T1         T2         T3
==         ==         ==
lock_vma_under_rcu
  mas_walk
          <VMA gets removed from mm>
                      mmap
                        <the same VMA is reallocated>
  vma_start_read
    __refcount_inc_not_zero_limited_acquire
                      munmap
                        __vma_enter_locked
                          refcount_add_not_zero
  vma_end_read
    vma_refcount_put
      __refcount_dec_and_test
                          rcuwait_wait_event
                            <finish operation>
      rcuwait_wake_up [UAF]

Note that rcuwait_wait_event() in T3 does not block because refcount was
already dropped by T1.  At this point T3 can exit and free the mm causing
UAF in T1.

To avoid this we move vma->vm_mm verification into vma_start_read() and
grab vma->vm_mm to stabilize it before vma_refcount_put() operation.

[surenb@google.com: v3]
  Link: https://lkml.kernel.org/r/20250729145709.2731370-1-surenb@google.com
Link: https://lkml.kernel.org/r/20250728175355.2282375-1-surenb@google.com
Fixes: 3104138517fc ("mm: make vma cache SLAB_TYPESAFE_BY_RCU")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Jann Horn <jannh@google.com>
Closes: https://lore.kernel.org/all/CAG48ez0-deFbVH=E3jbkWx=X3uVbd8nWeo6kbJPQ0KoUD+m2tA@mail.gmail.com/
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmap_lock.h |   30 ++++++++++++++++++++++++++++++
 mm/mmap_lock.c            |   10 +++-------
 2 files changed, 33 insertions(+), 7 deletions(-)

--- a/include/linux/mmap_lock.h~mm-fix-a-uaf-when-vma-mm-is-freed-after-vma-vm_refcnt-got-dropped
+++ a/include/linux/mmap_lock.h
@@ -12,6 +12,7 @@ extern int rcuwait_wake_up(struct rcuwai
 #include <linux/tracepoint-defs.h>
 #include <linux/types.h>
 #include <linux/cleanup.h>
+#include <linux/sched/mm.h>
 
 #define MMAP_LOCK_INITIALIZER(name) \
 	.mmap_lock = __RWSEM_INITIALIZER((name).mmap_lock),
@@ -154,6 +155,10 @@ static inline void vma_refcount_put(stru
  * reused and attached to a different mm before we lock it.
  * Returns the vma on success, NULL on failure to lock and EAGAIN if vma got
  * detached.
+ *
+ * WARNING! The vma passed to this function cannot be used if the function
+ * fails to lock it because in certain cases RCU lock is dropped and then
+ * reacquired. Once RCU lock is dropped the vma can be concurently freed.
  */
 static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
 						    struct vm_area_struct *vma)
@@ -183,6 +188,31 @@ static inline struct vm_area_struct *vma
 	}
 
 	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
+
+	/*
+	 * If vma got attached to another mm from under us, that mm is not
+	 * stable and can be freed in the narrow window after vma->vm_refcnt
+	 * is dropped and before rcuwait_wake_up(mm) is called. Grab it before
+	 * releasing vma->vm_refcnt.
+	 */
+	if (unlikely(vma->vm_mm != mm)) {
+		/* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt */
+		struct mm_struct *other_mm = vma->vm_mm;
+
+		/*
+		 * __mmdrop() is a heavy operation and we don't need RCU
+		 * protection here. Release RCU lock during these operations.
+		 * We reinstate the RCU read lock as the caller expects it to
+		 * be held when this function returns even on error.
+		 */
+		rcu_read_unlock();
+		mmgrab(other_mm);
+		vma_refcount_put(vma);
+		mmdrop(other_mm);
+		rcu_read_lock();
+		return NULL;
+	}
+
 	/*
 	 * Overflow of vm_lock_seq/mm_lock_seq might produce false locked result.
 	 * False unlocked result is impossible because we modify and check
--- a/mm/mmap_lock.c~mm-fix-a-uaf-when-vma-mm-is-freed-after-vma-vm_refcnt-got-dropped
+++ a/mm/mmap_lock.c
@@ -164,8 +164,7 @@ retry:
 	 */
 
 	/* Check if the vma we locked is the right one. */
-	if (unlikely(vma->vm_mm != mm ||
-		     address < vma->vm_start || address >= vma->vm_end))
+	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
 		goto inval_end_read;
 
 	rcu_read_unlock();
@@ -236,11 +235,8 @@ retry:
 		goto fallback;
 	}
 
-	/*
-	 * Verify the vma we locked belongs to the same address space and it's
-	 * not behind of the last search position.
-	 */
-	if (unlikely(vma->vm_mm != mm || from_addr >= vma->vm_end))
+	/* Verify the vma is not behind the last search position. */
+	if (unlikely(from_addr >= vma->vm_end))
 		goto fallback_unlock;
 
 	/*
_

Patches currently in -mm which might be from surenb@google.com are


