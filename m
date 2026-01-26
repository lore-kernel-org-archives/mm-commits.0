Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B441226ED48
	for <mm-commits@vger.kernel.org>; Mon, 26 Jan 2026 19:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769456296; cv=none; b=XXA24QfkoE0Tuxs3qlwQFS+fBIUpV4gA58Q3L3K7o4OYxgyoCyG3GOqIRiX8hd+aJkV8ZjE4c9R+R1F/tbQM/4Lgc/3hQYiyVCgsaPUDG43v1IwF9BA/lzfqF862lbNQE5eS53oplyj5oY5hQDONAeq9+gt6E/2CGnNl58kmP1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769456296; c=relaxed/simple;
	bh=2K5BDdzgQcEsRoCoGJ00IG0BlAE8vRI0Oozc4bQZyC8=;
	h=Date:To:From:Subject:Message-Id; b=bsdqJBv6IdUOFoAP40ZBxWJcwOHAZufyM8ev5Xqpb27k9HiRkLZ0F6FA8WWEO4nKD6847DpT8zUXSYFyW7LyuS+jaB5n3r/KGDVFx9LvALIJknOoOOJSwyjUcgMX0bZnZ6IEL01kde6iHoetaSaIUbqwMwRy29xIx6ML1enZ8To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TxQl/4qt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TxQl/4qt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C99C116C6;
	Mon, 26 Jan 2026 19:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769456296;
	bh=2K5BDdzgQcEsRoCoGJ00IG0BlAE8vRI0Oozc4bQZyC8=;
	h=Date:To:From:Subject:From;
	b=TxQl/4qtp6sGGtDMwwWWO9pYBC+cTTyGKVg8/G0KGShdsgOeHYKA7gcVJlYjvr1OO
	 aTbTBrGlsGLrCS9OV6MDShUp8RgroRbyeKyIlXu56VtgqyodzYSh13WvRofiqhMSw+
	 FRJ1E0nASyMdmfdhlxjxUs817nSM5/oBoeK943eo=
Date: Mon, 26 Jan 2026 11:38:15 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,longman@redhat.com,liam.howlett@oracle.com,boqun.feng@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix.patch added to mm-unstable branch
Message-Id: <20260126193816.39C99C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix
Date: Fri, 23 Jan 2026 20:12:17 +0000

fix function naming in comments, add comment per Vlastimil per Lorenzo

Link: https://lkml.kernel.org/r/7d3084d596c84da10dd374130a5055deba6439c0.1769198904.git.lorenzo.stoakes@oracle.com
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    4 ++--
 mm/mmap_lock.c           |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/mm_types.h~mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix
+++ a/include/linux/mm_types.h
@@ -1011,12 +1011,12 @@ struct vm_area_struct {
 	 * decrementing it again.
 	 *
 	 * VM_REFCNT_EXCLUDE_READERS_FLAG - Detached, pending
-	 * __vma_exit_exclusive_locked() completion which will decrement the
+	 * __vma_end_exclude_readers() completion which will decrement the
 	 * reference count to zero. IMPORTANT - at this stage no further readers
 	 * can increment the reference count. It can only be reduced.
 	 *
 	 * VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either write-locking
-	 * an attached VMA and has yet to invoke __vma_exit_exclusive_locked(),
+	 * an attached VMA and has yet to invoke __vma_end_exclude_readers(),
 	 * OR a thread is detaching a VMA and is waiting on a single spurious
 	 * reader in order to decrement the reference count. IMPORTANT - as
 	 * above, no further readers can increment the reference count.
--- a/mm/mmap_lock.c~mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix
+++ a/mm/mmap_lock.c
@@ -46,7 +46,7 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_relea
 #ifdef CONFIG_MMU
 #ifdef CONFIG_PER_VMA_LOCK
 
-/* State shared across __vma_[enter, exit]_exclusive_locked(). */
+/* State shared across __vma_[start, end]_exclude_readers. */
 struct vma_exclude_readers_state {
 	/* Input parameters. */
 	struct vm_area_struct *vma;
@@ -100,7 +100,7 @@ static unsigned int get_target_refcnt(st
  *
  * If ves->state is set to something other than TASK_UNINTERRUPTIBLE, the
  * function may also return -EINTR to indicate a fatal signal was received while
- * waiting.
+ * waiting.  Otherwise, the function returns 0.
  */
 static int __vma_start_exclude_readers(struct vma_exclude_readers_state *ves)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kho-kho_preserve_vmalloc-dont-return-0-when-enomem.patch
memcg-rename-mem_cgroup_ino-to-mem_cgroup_id-fix-fix.patch
mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix.patch
mm-add-wq_percpu-to-alloc_workqueue-users-fix-fix.patch
sparc-mm-export-symbols-for-lazy_mmu_mode-kunit-tests-fix.patch
mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch

