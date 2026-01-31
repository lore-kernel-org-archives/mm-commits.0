Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470CA376479
	for <mm-commits@vger.kernel.org>; Sat, 31 Jan 2026 21:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769896550; cv=none; b=MMMwG0inQQK7PRw3jgKpWFOzBLJfv3Wc6JDNahzZkOmmbDJdLxd6IVuQbKvNef+Ma1BIMq2xD93RtfNcDdgKdWBzC+h7vzmzS8QPKWKI3Mg2rLL9TKhsRh4vZ+NJLt0RKglPulZix6NKLIXT+Du6v84YCIqiJoLyco3w3IMLR6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769896550; c=relaxed/simple;
	bh=EvjHPsdNelQfYSZAmxBt1CXkElAUQFSz9KGGwyA8R8g=;
	h=Date:To:From:Subject:Message-Id; b=g66hAw9P9ecvwc8gtmuROOK2U8RR/tfW/wUgPqngc/FwMHHR8aFraF+Tkj/Kv/JuxBwcdex9+BLuxjxSNUtGxWFLfeXtiLF61wqE4gyFPxJguJp86cvgUlFuExgwoe1FkiNgkNXA75K3lL89V5ShDc4mwDyX7O9/7X2zUR4Fj9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=a4V8wqLX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="a4V8wqLX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A87C4CEF1;
	Sat, 31 Jan 2026 21:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769896549;
	bh=EvjHPsdNelQfYSZAmxBt1CXkElAUQFSz9KGGwyA8R8g=;
	h=Date:To:From:Subject:From;
	b=a4V8wqLXoAHbrKLhWZdN0j4cYcesrmnB+uLdM9FZ5Z26FyAWTcaP6h4tacPbATrPQ
	 ugHgCMYa3jenXrRwj/eLlt1Aa/G71CYeb9aoswYhzxylIuPZpsdeXVfFKIQTKZp/F0
	 lq+RzC+OZYgX0FnsXsSNJhlD6gYKbhTJJ/Il5ASY=
Date: Sat, 31 Jan 2026 13:55:49 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,mhocko@suse.com,longman@redhat.com,liam.howlett@oracle.com,boqun.feng@gmail.com,bigeasy@linutronix.de,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix.patch removed from -mm tree
Message-Id: <20260131215549.D3A87C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix
has been removed from the -mm tree.  Its filename was
     mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns-fix.patch

This patch was dropped because it was folded into mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns.patch

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
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
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

procfs-avoid-fetching-build-id-while-holding-vma-lock-fix.patch
mm-vma-introduce-helper-struct-thread-through-exclusive-lock-fns.patch
mm-pagewalk-use-min-to-simplify-the-code-fix.patch
mm-relocate-the-page-table-ceiling-and-floor-definitions-fix.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t-fix.patch
maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes.patch
liveupdate-luo_file-remember-retrieve-status-fix.patch

