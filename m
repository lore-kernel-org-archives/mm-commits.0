Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31209189F20
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735247784; cv=none; b=aMjI4oRL1c6msF1GccucTJZESUFd57jvJpEAMQ8rFXPw3a/nqMMrG3V9+Rq8Wtu91Mq0CjWcsnYBkqjkefnSrl0RuyuRYsG9UJNuhCG8kPnf8/oFMtxH8S/ih9K7Th0rzksmjPS76elrF6ufgkV1JSy4l9uu6eW6ogH2VyxuBS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735247784; c=relaxed/simple;
	bh=lmHN/d0ns4v5ZWwisncTx6KW5OQKiKaAkYqpja5pPmY=;
	h=Date:To:From:Subject:Message-Id; b=jv23qx57U2XppYKMR2N+FSJ4RITeP/kYXyiHHRoKJDcjwS57xRDVMRrY32rfAfn4yKKtJ/AVNtgcu/OeZqRDRA1ShYykZFzJCPJzoBScRd4gaiS6/ezwhMX2N9+2ZvEwr1kkM9pmgYtNSsMoZUiSk7yzZZ6MyK9dOsIicp63wEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HXXeQRB8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HXXeQRB8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0176C4CED1;
	Thu, 26 Dec 2024 21:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735247784;
	bh=lmHN/d0ns4v5ZWwisncTx6KW5OQKiKaAkYqpja5pPmY=;
	h=Date:To:From:Subject:From;
	b=HXXeQRB8n0fgkRNklzlNkzhvziXAwfN/rlKX89CR0fthe0xguv4mfh7uz0lzPzZyO
	 IqYdi7tPwud+NgIh+1Klx6aqkxzxvM+lDrx4vqMTEdfl6bocUOPmsYDpOghnGiNCEf
	 +pI2lLp7P7/lZU5HNQvVMKbSw+Cf+iC+bukntoP4=
Date: Thu, 26 Dec 2024 13:16:23 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oliver.sang@intel.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch added to mm-unstable branch
Message-Id: <20241226211623.F0176C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: prepare lock_vma_under_rcu() for vma reuse possibility
has been added to the -mm mm-unstable branch.  Its filename is
     mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch

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
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm: prepare lock_vma_under_rcu() for vma reuse possibility
Date: Thu, 26 Dec 2024 09:07:07 -0800

Once we make vma cache SLAB_TYPESAFE_BY_RCU, it will be possible for a vma
to be reused and attached to another mm after lock_vma_under_rcu() locks
the vma. lock_vma_under_rcu() should ensure that vma_start_read() is using
the original mm and after locking the vma it should ensure that vma->vm_mm
has not changed from under us.

Link: https://lkml.kernel.org/r/20241226170710.1159679-16-surenb@google.com
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Klara Modin <klarasmodin@gmail.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Sourav Panda <souravpanda@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   10 ++++++----
 mm/memory.c        |    7 ++++---
 2 files changed, 10 insertions(+), 7 deletions(-)

--- a/include/linux/mm.h~mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility
+++ a/include/linux/mm.h
@@ -730,8 +730,10 @@ static inline void vma_refcount_put(stru
  * Try to read-lock a vma. The function is allowed to occasionally yield false
  * locked result to avoid performance overhead, in which case we fall back to
  * using mmap_lock. The function should never yield false unlocked result.
+ * False locked result is possible if mm_lock_seq overflows or if vma gets
+ * reused and attached to a different mm before we lock it.
  */
-static inline bool vma_start_read(struct vm_area_struct *vma)
+static inline bool vma_start_read(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	int oldcnt;
 
@@ -742,7 +744,7 @@ static inline bool vma_start_read(struct
 	 * we don't rely on for anything - the mm_lock_seq read against which we
 	 * need ordering is below.
 	 */
-	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(vma->vm_mm->mm_lock_seq.sequence))
+	if (READ_ONCE(vma->vm_lock_seq) == READ_ONCE(mm->mm_lock_seq.sequence))
 		return false;
 
 
@@ -767,7 +769,7 @@ static inline bool vma_start_read(struct
 	 * This pairs with RELEASE semantics in vma_end_write_all().
 	 */
 	if (unlikely(oldcnt & VMA_LOCK_OFFSET ||
-		     vma->vm_lock_seq == raw_read_seqcount(&vma->vm_mm->mm_lock_seq))) {
+		     vma->vm_lock_seq == raw_read_seqcount(&mm->mm_lock_seq))) {
 		vma_refcount_put(vma);
 		return false;
 	}
@@ -905,7 +907,7 @@ struct vm_area_struct *lock_vma_under_rc
 
 static inline void vma_lockdep_init(struct vm_area_struct *vma) {}
 static inline void vma_init_lock(struct vm_area_struct *vma, bool reset_refcnt) {}
-static inline bool vma_start_read(struct vm_area_struct *vma)
+static inline bool vma_start_read(struct mm_struct *mm, struct vm_area_struct *vma)
 		{ return false; }
 static inline void vma_end_read(struct vm_area_struct *vma) {}
 static inline void vma_start_write(struct vm_area_struct *vma) {}
--- a/mm/memory.c~mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility
+++ a/mm/memory.c
@@ -6414,7 +6414,7 @@ struct vm_area_struct *lock_vma_under_rc
 	if (!vma)
 		goto inval;
 
-	if (!vma_start_read(vma))
+	if (!vma_start_read(mm, vma))
 		goto inval;
 
 	/*
@@ -6424,8 +6424,9 @@ struct vm_area_struct *lock_vma_under_rc
 	 * fields are accessible for RCU readers.
 	 */
 
-	/* Check since vm_start/vm_end might change before we lock the VMA */
-	if (unlikely(address < vma->vm_start || address >= vma->vm_end))
+	/* Check if the vma we locked is the right one. */
+	if (unlikely(vma->vm_mm != mm ||
+		     address < vma->vm_start || address >= vma->vm_end))
 		goto inval_end_read;
 
 	rcu_read_unlock();
_

Patches currently in -mm which might be from surenb@google.com are

seqlock-add-raw_seqcount_try_begin.patch
mm-convert-mm_lock_seq-to-a-proper-seqcount.patch
mm-introduce-mmap_lock_speculate_try_beginretry.patch
mm-introduce-vma_start_read_locked_nested-helpers.patch
mm-move-per-vma-lock-into-vm_area_struct.patch
mm-mark-vma-as-detached-until-its-added-into-vma-tree.patch
mm-modify-vma_iter_store_gfp-to-indicate-if-its-storing-a-new-vma.patch
mm-mark-vmas-detached-upon-exit.patch
mm-nommu-fix-the-last-places-where-vma-is-not-locked-before-being-attached.patch
types-move-struct-rcuwait-into-typesh.patch
mm-allow-vma_start_read_locked-vma_start_read_locked_nested-to-fail.patch
mm-move-mmap_init_lock-out-of-the-header-file.patch
mm-uninline-the-main-body-of-vma_start_write.patch
refcount-introduce-__refcount_addinc_not_zero_limited.patch
mm-replace-vm_lock-and-detached-flag-with-a-reference-count.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma.patch
mm-debug-print-vm_refcnt-state-when-dumping-the-vma-fix.patch
mm-remove-extra-vma_numab_state_init-call.patch
mm-prepare-lock_vma_under_rcu-for-vma-reuse-possibility.patch
mm-make-vma-cache-slab_typesafe_by_rcu.patch
docs-mm-document-latest-changes-to-vm_lock.patch

