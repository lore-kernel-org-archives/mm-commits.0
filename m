Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB35115624B
	for <mm-commits@vger.kernel.org>; Thu, 26 Dec 2024 21:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735247768; cv=none; b=X/bn8m85DkG/zonwuD7YWHHhBYpiqCi+TPfIVzbokZXOSuaFgSnoz4U2QJhCW3NbA+kAxXw6VF4axpkb7Upfz+W8P92QMQgZOjwLgW0tFc0xR5WK73JRryPBmTgDlEt3oaFSn6gN1xrSabXOxWBPFvedjbRQg3cK+S6c9PwgeXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735247768; c=relaxed/simple;
	bh=uGg5FyoSvzxVpmfAc19zA4uXH0X5pXk8PD5waguHwPc=;
	h=Date:To:From:Subject:Message-Id; b=ozI48EoUC3hYn83ToXudWPRREq398gWGKKhEoqnT4FElhqgh5jxRduLfIrYWi79JBpxDmUiltAqgi7InUVmLZS8Q6P1VuszpmcQ9ogvZ/qxYCPAxXYRYiFjcZBy20UHZHb0i32IvgQwtx6vy7L65/SgXbLGpLF6i6KnLCuTM2WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TbcKiW8m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TbcKiW8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B76C4CED1;
	Thu, 26 Dec 2024 21:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735247767;
	bh=uGg5FyoSvzxVpmfAc19zA4uXH0X5pXk8PD5waguHwPc=;
	h=Date:To:From:Subject:From;
	b=TbcKiW8m9yKYLcfYxdGh4Ex0uCCQXrC4i1yYg4wFfXir8joXV/YiJ/yyR2dX3OFc6
	 d4t7U+f7OF+xeg2TjmQVhB3Exshz9gUgl4FDquTRFtOzN2of38RGlNt3Y806zJAg5T
	 Xg7Vie1CyDd0n+PWxpLWOueE0w1T1LrKDdv5CeNo=
Date: Thu, 26 Dec 2024 13:16:07 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,vbabka@suse.cz,souravpanda@google.com,shakeel.butt@linux.dev,peterz@infradead.org,peterx@redhat.com,paulmck@kernel.org,pasha.tatashin@soleen.com,oliver.sang@intel.com,oleg@redhat.com,mjguzik@gmail.com,minchan@google.com,mhocko@suse.com,mgorman@techsingularity.net,lorenzo.stoakes@oracle.com,lokeshgidra@google.com,Liam.Howlett@Oracle.com,klarasmodin@gmail.com,jannh@google.com,hughd@google.com,hdanton@sina.com,hannes@cmpxchg.org,dhowells@redhat.com,david@redhat.com,dave@stgolabs.net,corbet@lwn.net,brauner@kernel.org,surenb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-uninline-the-main-body-of-vma_start_write.patch added to mm-unstable branch
Message-Id: <20241226211607.B7B76C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: uninline the main body of vma_start_write()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-uninline-the-main-body-of-vma_start_write.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-uninline-the-main-body-of-vma_start_write.patch

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
Subject: mm: uninline the main body of vma_start_write()
Date: Thu, 26 Dec 2024 09:07:02 -0800

vma_start_write() is used in many places and will grow in size very soon. 
It is not used in performance critical paths and uninlining it should
limit the future code size growth.  No functional changes.

Link: https://lkml.kernel.org/r/20241226170710.1159679-11-surenb@google.com
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

 include/linux/mm.h |   12 +++---------
 mm/memory.c        |   14 ++++++++++++++
 2 files changed, 17 insertions(+), 9 deletions(-)

--- a/include/linux/mm.h~mm-uninline-the-main-body-of-vma_start_write
+++ a/include/linux/mm.h
@@ -787,6 +787,8 @@ static bool __is_vma_write_locked(struct
 	return (vma->vm_lock_seq == *mm_lock_seq);
 }
 
+void __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq);
+
 /*
  * Begin writing to a VMA.
  * Exclude concurrent readers under the per-VMA lock until the currently
@@ -799,15 +801,7 @@ static inline void vma_start_write(struc
 	if (__is_vma_write_locked(vma, &mm_lock_seq))
 		return;
 
-	down_write(&vma->vm_lock.lock);
-	/*
-	 * We should use WRITE_ONCE() here because we can have concurrent reads
-	 * from the early lockless pessimistic check in vma_start_read().
-	 * We don't really care about the correctness of that early check, but
-	 * we should use WRITE_ONCE() for cleanliness and to keep KCSAN happy.
-	 */
-	WRITE_ONCE(vma->vm_lock_seq, mm_lock_seq);
-	up_write(&vma->vm_lock.lock);
+	__vma_start_write(vma, mm_lock_seq);
 }
 
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
--- a/mm/memory.c~mm-uninline-the-main-body-of-vma_start_write
+++ a/mm/memory.c
@@ -6328,6 +6328,20 @@ fail:
 #endif
 
 #ifdef CONFIG_PER_VMA_LOCK
+void __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq)
+{
+	down_write(&vma->vm_lock.lock);
+	/*
+	 * We should use WRITE_ONCE() here because we can have concurrent reads
+	 * from the early lockless pessimistic check in vma_start_read().
+	 * We don't really care about the correctness of that early check, but
+	 * we should use WRITE_ONCE() for cleanliness and to keep KCSAN happy.
+	 */
+	WRITE_ONCE(vma->vm_lock_seq, mm_lock_seq);
+	up_write(&vma->vm_lock.lock);
+}
+EXPORT_SYMBOL_GPL(__vma_start_write);
+
 /*
  * Lookup and lock a VMA under RCU protection. Returned VMA is guaranteed to be
  * stable and not isolated. If the VMA is not found or is being modified the
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

