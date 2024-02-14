Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176115EE7E
	for <mm-commits@vger.kernel.org>; Wed, 14 Feb 2024 16:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707926925; cv=none; b=hQAWOsx2mIvj7pMLl4yA4F+7OGRc30eZMqL99DNsyYpG/f9nkOHkfDmd0UIW73uf2x5a1kofbEx+UaFSMIIfe5E00cA1OJ/jvRtmhCyupqWm16zmy5a1GVmfq0J5Xr96/erLxmI5UYqr6URT6gvm9KWtt9w2Cz/6WSH7JCo6NOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707926925; c=relaxed/simple;
	bh=J3Ass3kKwjJ2C7dHgh4OvDkqnC8XTxGB5D7uObpw80c=;
	h=Date:To:From:Subject:Message-Id; b=KF/8x1Q98EkiyVHkrk+K3CsK4qllaRS86TWZbTLHHQSc6cH8R9bRUGxOy+4JUX7ME7xl/XWHH4VS6wVHcih9OhAig9VVLMemk8W7Ejq1YMPbq2H77pLoyVcpsJnqKYNl6KsfOcQdZo3eMIFVggFyJcFlNywIp/PjihS0rfGXH38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wXiyka0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wXiyka0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8967BC433C7;
	Wed, 14 Feb 2024 16:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1707926924;
	bh=J3Ass3kKwjJ2C7dHgh4OvDkqnC8XTxGB5D7uObpw80c=;
	h=Date:To:From:Subject:From;
	b=wXiyka0Q5TZqyINRI92Tg3KoysDHO+V0oTQ0W0Nn7X8w4GSx0GvNdfZbWPGjzhl8H
	 PyI87Sqbm7B2RXY02M/pqn9bZygsTI1R0uQad15l2QkGCehLZMiQv9mCVKnBGYc16E
	 Mn8DwDvsqzpFHLwCEnBhJvTAD+J87y1DTO4svttU=
Date: Wed, 14 Feb 2024 08:08:43 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,timmurray@google.com,surenb@google.com,rppt@kernel.org,peterx@redhat.com,ngeoffray@google.com,Liam.Howlett@oracle.com,kaleshsingh@google.com,jannh@google.com,david@redhat.com,bgeffon@google.com,axelrasmussen@google.com,aarcange@redhat.com,lokeshgidra@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + userfaultfd-move-userfaultfd_ctx-struct-to-header-file.patch added to mm-unstable branch
Message-Id: <20240214160844.8967BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: userfaultfd: move userfaultfd_ctx struct to header file
has been added to the -mm mm-unstable branch.  Its filename is
     userfaultfd-move-userfaultfd_ctx-struct-to-header-file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/userfaultfd-move-userfaultfd_ctx-struct-to-header-file.patch

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
From: Lokesh Gidra <lokeshgidra@google.com>
Subject: userfaultfd: move userfaultfd_ctx struct to header file
Date: Tue, 13 Feb 2024 13:57:39 -0800

Patch series "per-vma locks in userfaultfd", v6.

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


This patch (of 6):

Moving the struct to userfaultfd_k.h to be accessible from
mm/userfaultfd.c.  There are no other changes in the struct.

This is required to prepare for using per-vma locks in userfaultfd
operations.

Link: https://lkml.kernel.org/r/20240213215741.3816570-1-lokeshgidra@google.com
Link: https://lkml.kernel.org/r/20240213215741.3816570-2-lokeshgidra@google.com
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Peter Xu <peterx@redhat.com>
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

userfaultfd-fix-return-error-if-mmap_changing-is-non-zero-in-move-ioctl.patch
userfaultfd-move-userfaultfd_ctx-struct-to-header-file.patch
userfaultfd-protect-mmap_changing-with-rw_sem-in-userfaulfd_ctx.patch
userfaultfd-use-per-vma-locks-in-userfaultfd-operations.patch

