Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF52024B29
	for <mm-commits@vger.kernel.org>; Wed,  6 Aug 2025 02:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754448266; cv=none; b=FItps8C/X84LTZQUjU/OsvaUlGtlvGrFSgTB6NrpSVKsA0yeDhMxigeW3cdi0mE8jwnBas4hEtWvyHoh3wwEJql/u/fxtKlf4gtBzHq9WUa+enoPppi7sPQ8da5EPriY+LV4i2RGBNYRIftR8xlRFXN/7l4Got5h+i118EvKAuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754448266; c=relaxed/simple;
	bh=BINoaqN3NRXcGA2Qp0RbJ0PrY9vbrCgSRX5oaT1whN4=;
	h=Date:To:From:Subject:Message-Id; b=kk+uEDxfpBhl76zUTvAIUZIYPy4X7o+Hh3i3/VdOAWkzbP3UMPO5T7qyS2W5//2YJZZB/nJLT2rlcGGgvfhRs15nZuFTxuwdMwcj5mtQ6wFCkoJe2FaWty366NIo8KiBVyuV62H1t8bdgBS+CbaLtWGbauuguqCsIlakloky+fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EMYjcAtD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EMYjcAtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A46C4CEF0;
	Wed,  6 Aug 2025 02:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754448266;
	bh=BINoaqN3NRXcGA2Qp0RbJ0PrY9vbrCgSRX5oaT1whN4=;
	h=Date:To:From:Subject:From;
	b=EMYjcAtDMgtCwchghfGFT4wYQuUKVHFWoJ6CisEjGn0UdyAxbyzalzEayDcciGS3f
	 YL3E4xSC5p9MAYgxnAT0t8XPMd0lZJT2knm9iclcNwWM28inbYn2fkIcllEsT9JVO7
	 /rIRaEXdqUhHj90W7f51fr9BNC/XkFfelO1NWHJc=
Date: Tue, 05 Aug 2025 19:44:25 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-change-vma_start_read-to-drop-rcu-lock-on-failure.patch added to mm-new branch
Message-Id: <20250806024426.26A46C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: change vma_start_read() to drop RCU lock on failure
has been added to the -mm mm-new branch.  Its filename is
     mm-change-vma_start_read-to-drop-rcu-lock-on-failure.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-change-vma_start_read-to-drop-rcu-lock-on-failure.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: change vma_start_read() to drop RCU lock on failure
Date: Mon, 4 Aug 2025 16:33:49 -0700

vma_start_read() can drop and reacquire RCU lock in certain failure cases.
It's not apparent that the RCU session started by the caller of this
function might be interrupted when vma_start_read() fails to lock the vma.
This might become a source of subtle bugs and to prevent that we change
the locking rules for vma_start_read() to drop RCU read lock upon failure.
This way it's more obvious that RCU-protected objects are unsafe after
vma locking fails.

Link: https://lkml.kernel.org/r/20250804233349.1278678-2-surenb@google.com
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap_lock.c |   84 +++++++++++++++++++++++++----------------------
 1 file changed, 45 insertions(+), 39 deletions(-)

--- a/mm/mmap_lock.c~mm-change-vma_start_read-to-drop-rcu-lock-on-failure
+++ a/mm/mmap_lock.c
@@ -136,15 +136,16 @@ void vma_mark_detached(struct vm_area_st
  * Returns the vma on success, NULL on failure to lock and EAGAIN if vma got
  * detached.
  *
- * WARNING! The vma passed to this function cannot be used if the function
- * fails to lock it because in certain cases RCU lock is dropped and then
- * reacquired. Once RCU lock is dropped the vma can be concurently freed.
+ * IMPORTANT: RCU lock must be held upon entering the function, but upon error
+ *            IT IS RELEASED. The caller must handle this correctly.
  */
 static inline struct vm_area_struct *vma_start_read(struct mm_struct *mm,
 						    struct vm_area_struct *vma)
 {
+	struct mm_struct *other_mm;
 	int oldcnt;
 
+	RCU_LOCKDEP_WARN(!rcu_read_lock_held(), "no rcu lock held");
 	/*
 	 * Check before locking. A race might cause false locked result.
 	 * We can use READ_ONCE() for the mm_lock_seq here, and don't need
@@ -152,8 +153,10 @@ static inline struct vm_area_struct *vma
 	 * we don't rely on for anything - the mm_lock_seq read against which we
 	 * need ordering is below.
 	 */
-	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(mm->mm_lock_seq.sequence))
-		return NULL;
+	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(mm->mm_lock_seq.sequence)) {
+		vma = NULL;
+		goto err;
+	}
 
 	/*
 	 * If VMA_LOCK_OFFSET is set, __refcount_inc_not_zero_limited_acquire()
@@ -164,34 +167,14 @@ static inline struct vm_area_struct *vma
 	if (unlikely(!__refcount_inc_not_zero_limited_acquire(&vma->vm_refcnt, &oldcnt,
 							      VMA_REF_LIMIT))) {
 		/* return EAGAIN if vma got detached from under us */
-		return oldcnt ? NULL : ERR_PTR(-EAGAIN);
+		vma = oldcnt ? NULL : ERR_PTR(-EAGAIN);
+		goto err;
 	}
 
 	rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
 
-	/*
-	 * If vma got attached to another mm from under us, that mm is not
-	 * stable and can be freed in the narrow window after vma->vm_refcnt
-	 * is dropped and before rcuwait_wake_up(mm) is called. Grab it before
-	 * releasing vma->vm_refcnt.
-	 */
-	if (unlikely(vma->vm_mm != mm)) {
-		/* Use a copy of vm_mm in case vma is freed after we drop vm_refcnt */
-		struct mm_struct *other_mm = vma->vm_mm;
-
-		/*
-		 * __mmdrop() is a heavy operation and we don't need RCU
-		 * protection here. Release RCU lock during these operations.
-		 * We reinstate the RCU read lock as the caller expects it to
-		 * be held when this function returns even on error.
-		 */
-		rcu_read_unlock();
-		mmgrab(other_mm);
-		vma_refcount_put(vma);
-		mmdrop(other_mm);
-		rcu_read_lock();
-		return NULL;
-	}
+	if (unlikely(vma->vm_mm != mm))
+		goto err_unstable;
 
 	/*
 	 * Overflow of vm_lock_seq/mm_lock_seq might produce false locked result.
@@ -206,10 +189,31 @@ static inline struct vm_area_struct *vma
 	 */
 	if (unlikely(vma->vm_lock_seq == raw_read_seqcount(&mm->mm_lock_seq))) {
 		vma_refcount_put(vma);
-		return NULL;
+		vma = NULL;
+		goto err;
 	}
 
 	return vma;
+err:
+	rcu_read_unlock();
+
+	return vma;
+err_unstable:
+	/*
+	 * If vma got attached to another mm from under us, that mm is not
+	 * stable and can be freed in the narrow window after vma->vm_refcnt
+	 * is dropped and before rcuwait_wake_up(mm) is called. Grab it before
+	 * releasing vma->vm_refcnt.
+	 */
+	other_mm = vma->vm_mm; /* use a copy as vma can be freed after we drop vm_refcnt */
+
+	/* __mmdrop() is a heavy operation, do it after dropping RCU lock. */
+	rcu_read_unlock();
+	mmgrab(other_mm);
+	vma_refcount_put(vma);
+	mmdrop(other_mm);
+
+	return NULL;
 }
 
 /*
@@ -223,11 +227,13 @@ struct vm_area_struct *lock_vma_under_rc
 	MA_STATE(mas, &mm->mm_mt, address, address);
 	struct vm_area_struct *vma;
 
-	rcu_read_lock();
 retry:
+	rcu_read_lock();
 	vma = mas_walk(&mas);
-	if (!vma)
+	if (!vma) {
+		rcu_read_unlock();
 		goto inval;
+	}
 
 	vma = vma_start_read(mm, vma);
 	if (IS_ERR_OR_NULL(vma)) {
@@ -247,18 +253,17 @@ retry:
 	 * From here on, we can access the VMA without worrying about which
 	 * fields are accessible for RCU readers.
 	 */
+	rcu_read_unlock();
 
 	/* Check if the vma we locked is the right one. */
-	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
-		goto inval_end_read;
+	if (unlikely(address < vma->vm_start || address >= vma->vm_end)) {
+		vma_end_read(vma);
+		goto inval;
+	}
 
-	rcu_read_unlock();
 	return vma;
 
-inval_end_read:
-	vma_end_read(vma);
 inval:
-	rcu_read_unlock();
 	count_vm_vma_lock_event(VMA_LOCK_ABORT);
 	return NULL;
 }
@@ -313,6 +318,7 @@ retry:
 		 */
 		if (PTR_ERR(vma) == -EAGAIN) {
 			/* reset to search from the last address */
+			rcu_read_lock();
 			vma_iter_set(vmi, from_addr);
 			goto retry;
 		}
@@ -342,9 +348,9 @@ retry:
 	return vma;
 
 fallback_unlock:
+	rcu_read_unlock();
 	vma_end_read(vma);
 fallback:
-	rcu_read_unlock();
 	vma = lock_next_vma_under_mmap_lock(mm, vmi, from_addr);
 	rcu_read_lock();
 	/* Reinitialize the iterator after re-entering rcu read section */
_

Patches currently in -mm which might be from surenb@google.com are

mm-limit-the-scope-of-vma_start_read.patch
mm-change-vma_start_read-to-drop-rcu-lock-on-failure.patch

