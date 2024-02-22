Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0285720DCF
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 23:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708644516; cv=none; b=GGCdY09TIkOQkydEBm9egARWXk+wqIqhQZNjzsXeZE4mUi51JmSH/ovxfSQVIKxF0WsuK09nSOL00Sk+j582zdWx4SmCK/ZCMSpduHCdkAEM0pc64+DeihcChu55EyfyalB6SNFo34I5bYiRUX395zihyy7XFvktY+MYwhP3ua8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708644516; c=relaxed/simple;
	bh=VE+BTuKJ4XpF3H2yAFHR7uiHx3eWadCB043BLpuiY4E=;
	h=Date:To:From:Subject:Message-Id; b=tc/DWIZ3/RK/XA2uKJUfIGDmw2QcuqX7hEJUJxr/Bw0Wy0n1A55UnCc3+SyKRc8IQca6OuX+r85WPC1zjP4++jYAJUDFHmUS2rvtoM1zb81HSFDTTrGmeRUnSTBPB2ZIgQWKkVL0WO9M4uGi9QXUj4M6wryM3V6/8pPzs5cc248=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w2quYTmC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w2quYTmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F787C433C7;
	Thu, 22 Feb 2024 23:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708644515;
	bh=VE+BTuKJ4XpF3H2yAFHR7uiHx3eWadCB043BLpuiY4E=;
	h=Date:To:From:Subject:From;
	b=w2quYTmCLXAruGQ8MkFdQwW+UdhASBbKTw65vxikVj0pcok1NFWOgtP3ncpoCrM9Y
	 OSLrsnPMOWPrj65NuPjnyJJBa7wjQigZak8f6ypZdnIPEwLAPBKKf3CSOwc5+5bwOa
	 M7be2DfMoyydQoBM/U0fxiBsjMgkymWA023SWRLE=
Date: Thu, 22 Feb 2024 15:28:34 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,timmurray@google.com,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,ngeoffray@google.com,Liam.Howlett@oracle.com,kaleshsingh@google.com,jannh@google.com,david@redhat.com,bgeffon@google.com,axelrasmussen@google.com,aarcange@redhat.com,lokeshgidra@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] userfaultfd-move-userfaultfd_ctx-struct-to-header-file.patch removed from -mm tree
Message-Id: <20240222232835.6F787C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: userfaultfd: move userfaultfd_ctx struct to header file
has been removed from the -mm tree.  Its filename was
     userfaultfd-move-userfaultfd_ctx-struct-to-header-file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lokesh Gidra <lokeshgidra@google.com>
Subject: userfaultfd: move userfaultfd_ctx struct to header file
Date: Thu, 15 Feb 2024 10:27:53 -0800

Patch series "per-vma locks in userfaultfd", v7.

Performing userfaultfd operations (like copy/move etc.) in critical
section of mmap_lock (read-mode) causes significant contention on the lock
when operations requiring the lock in write-mode are taking place
concurrently.  We can use per-vma locks instead to significantly reduce
the contention issue.

Android runtime's Garbage Collector uses userfaultfd for concurrent
compaction.  mmap-lock contention during compaction potentially causes
jittery experience for the user.  During one such reproducible scenario,
we observed the following improvements with this patch-set:

- Wall clock time of compaction phase came down from ~3s to <500ms
- Uninterruptible sleep time (across all threads in the process) was
  ~10ms (none in mmap_lock) during compaction, instead of >20s


This patch (of 4):

Move the struct to userfaultfd_k.h to be accessible from mm/userfaultfd.c.
There are no other changes in the struct.

This is required to prepare for using per-vma locks in userfaultfd
operations.

Link: https://lkml.kernel.org/r/20240215182756.3448972-1-lokeshgidra@google.com
Link: https://lkml.kernel.org/r/20240215182756.3448972-2-lokeshgidra@google.com
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tim Murray <timmurray@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/userfaultfd.c              |   39 --------------------------------
 include/linux/userfaultfd_k.h |   39 ++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 39 deletions(-)

--- a/fs/userfaultfd.c~userfaultfd-move-userfaultfd_ctx-struct-to-header-file
+++ a/fs/userfaultfd.c
@@ -50,45 +50,6 @@ static struct ctl_table vm_userfaultfd_t
 
 static struct kmem_cache *userfaultfd_ctx_cachep __ro_after_init;
 
-/*
- * Start with fault_pending_wqh and fault_wqh so they're more likely
- * to be in the same cacheline.
- *
- * Locking order:
- *	fd_wqh.lock
- *		fault_pending_wqh.lock
- *			fault_wqh.lock
- *		event_wqh.lock
- *
- * To avoid deadlocks, IRQs must be disabled when taking any of the above locks,
- * since fd_wqh.lock is taken by aio_poll() while it's holding a lock that's
- * also taken in IRQ context.
- */
-struct userfaultfd_ctx {
-	/* waitqueue head for the pending (i.e. not read) userfaults */
-	wait_queue_head_t fault_pending_wqh;
-	/* waitqueue head for the userfaults */
-	wait_queue_head_t fault_wqh;
-	/* waitqueue head for the pseudo fd to wakeup poll/read */
-	wait_queue_head_t fd_wqh;
-	/* waitqueue head for events */
-	wait_queue_head_t event_wqh;
-	/* a refile sequence protected by fault_pending_wqh lock */
-	seqcount_spinlock_t refile_seq;
-	/* pseudo fd refcounting */
-	refcount_t refcount;
-	/* userfaultfd syscall flags */
-	unsigned int flags;
-	/* features requested from the userspace */
-	unsigned int features;
-	/* released */
-	bool released;
-	/* memory mappings are changing because of non-cooperative event */
-	atomic_t mmap_changing;
-	/* mm with one ore more vmas attached to this userfaultfd_ctx */
-	struct mm_struct *mm;
-};
-
 struct userfaultfd_fork_ctx {
 	struct userfaultfd_ctx *orig;
 	struct userfaultfd_ctx *new;
--- a/include/linux/userfaultfd_k.h~userfaultfd-move-userfaultfd_ctx-struct-to-header-file
+++ a/include/linux/userfaultfd_k.h
@@ -36,6 +36,45 @@
 #define UFFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
 #define UFFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS)
 
+/*
+ * Start with fault_pending_wqh and fault_wqh so they're more likely
+ * to be in the same cacheline.
+ *
+ * Locking order:
+ *	fd_wqh.lock
+ *		fault_pending_wqh.lock
+ *			fault_wqh.lock
+ *		event_wqh.lock
+ *
+ * To avoid deadlocks, IRQs must be disabled when taking any of the above locks,
+ * since fd_wqh.lock is taken by aio_poll() while it's holding a lock that's
+ * also taken in IRQ context.
+ */
+struct userfaultfd_ctx {
+	/* waitqueue head for the pending (i.e. not read) userfaults */
+	wait_queue_head_t fault_pending_wqh;
+	/* waitqueue head for the userfaults */
+	wait_queue_head_t fault_wqh;
+	/* waitqueue head for the pseudo fd to wakeup poll/read */
+	wait_queue_head_t fd_wqh;
+	/* waitqueue head for events */
+	wait_queue_head_t event_wqh;
+	/* a refile sequence protected by fault_pending_wqh lock */
+	seqcount_spinlock_t refile_seq;
+	/* pseudo fd refcounting */
+	refcount_t refcount;
+	/* userfaultfd syscall flags */
+	unsigned int flags;
+	/* features requested from the userspace */
+	unsigned int features;
+	/* released */
+	bool released;
+	/* memory mappings are changing because of non-cooperative event */
+	atomic_t mmap_changing;
+	/* mm with one ore more vmas attached to this userfaultfd_ctx */
+	struct mm_struct *mm;
+};
+
 extern vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason);
 
 /* A combined operation mode + behavior flags. */
_

Patches currently in -mm which might be from lokeshgidra@google.com are


