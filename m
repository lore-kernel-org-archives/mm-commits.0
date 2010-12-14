From: akpm@linux-foundation.org
Subject: [nacked] rwsem-implement-rwsem_is_contended.patch removed from -mm tree
Date: Mon, 13 Dec 2010 16:56:50 -0800
Message-ID: <201012140056.oBE0upMv022477@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932109Ab0LNA53 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 13 Dec 2010 19:57:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, dhowells@redhat.com, hpa@zytor.com, hughd@google.com, kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu, npiggin@kernel.dk, peterz@infradead.org, riel@redhat.com, tglx@


The patch titled
     rwsem: implement rwsem_is_contended()
has been removed from the -mm tree.  Its filename was
     rwsem-implement-rwsem_is_contended.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rwsem: implement rwsem_is_contended()
From: Michel Lespinasse <walken@google.com>

Trivial implementations for rwsem_is_contended()

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/rwsem.h   |    5 +++++
 arch/ia64/include/asm/rwsem.h    |    5 +++++
 arch/powerpc/include/asm/rwsem.h |    5 +++++
 arch/s390/include/asm/rwsem.h    |    5 +++++
 arch/sh/include/asm/rwsem.h      |    5 +++++
 arch/sparc/include/asm/rwsem.h   |    5 +++++
 arch/x86/include/asm/rwsem.h     |    5 +++++
 arch/xtensa/include/asm/rwsem.h  |    5 +++++
 include/linux/rwsem-spinlock.h   |    1 +
 lib/rwsem-spinlock.c             |   12 ++++++++++++
 10 files changed, 53 insertions(+)

diff -puN arch/alpha/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended arch/alpha/include/asm/rwsem.h
--- a/arch/alpha/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended
+++ a/arch/alpha/include/asm/rwsem.h
@@ -255,5 +255,10 @@ static inline int rwsem_is_locked(struct
 	return (sem->count != 0);
 }
 
+static inline int rwsem_is_contended(struct rw_semaphore *sem)
+{
+        return (sem->count < 0);
+}
+
 #endif /* __KERNEL__ */
 #endif /* _ALPHA_RWSEM_H */
diff -puN arch/ia64/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended arch/ia64/include/asm/rwsem.h
--- a/arch/ia64/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended
+++ a/arch/ia64/include/asm/rwsem.h
@@ -179,4 +179,9 @@ static inline int rwsem_is_locked(struct
 	return (sem->count != 0);
 }
 
+static inline int rwsem_is_contended(struct rw_semaphore *sem)
+{
+        return (sem->count < 0);
+}
+
 #endif /* _ASM_IA64_RWSEM_H */
diff -puN arch/powerpc/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended arch/powerpc/include/asm/rwsem.h
--- a/arch/powerpc/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended
+++ a/arch/powerpc/include/asm/rwsem.h
@@ -179,5 +179,10 @@ static inline int rwsem_is_locked(struct
 	return sem->count != 0;
 }
 
+static inline int rwsem_is_contended(struct rw_semaphore *sem)
+{
+        return sem->count < 0;
+}
+
 #endif	/* __KERNEL__ */
 #endif	/* _ASM_POWERPC_RWSEM_H */
diff -puN arch/s390/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended arch/s390/include/asm/rwsem.h
--- a/arch/s390/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended
+++ a/arch/s390/include/asm/rwsem.h
@@ -382,5 +382,10 @@ static inline int rwsem_is_locked(struct
 	return (sem->count != 0);
 }
 
+static inline int rwsem_is_contended(struct rw_semaphore *sem)
+{
+        return (sem->count < 0);
+}
+
 #endif /* __KERNEL__ */
 #endif /* _S390_RWSEM_H */
diff -puN arch/sh/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended arch/sh/include/asm/rwsem.h
--- a/arch/sh/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended
+++ a/arch/sh/include/asm/rwsem.h
@@ -184,5 +184,10 @@ static inline int rwsem_is_locked(struct
 	return (sem->count != 0);
 }
 
+static inline int rwsem_is_contended(struct rw_semaphore *sem)
+{
+        return (sem->count < 0);
+}
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_SH_RWSEM_H */
diff -puN arch/sparc/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended arch/sparc/include/asm/rwsem.h
--- a/arch/sparc/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended
+++ a/arch/sparc/include/asm/rwsem.h
@@ -165,6 +165,11 @@ static inline int rwsem_is_locked(struct
 	return (sem->count != 0);
 }
 
+static inline int rwsem_is_contended(struct rw_semaphore *sem)
+{
+        return (sem->count < 0);
+}
+
 #endif /* __KERNEL__ */
 
 #endif /* _SPARC64_RWSEM_H */
diff -puN arch/x86/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended arch/x86/include/asm/rwsem.h
--- a/arch/x86/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended
+++ a/arch/x86/include/asm/rwsem.h
@@ -275,5 +275,10 @@ static inline int rwsem_is_locked(struct
 	return (sem->count != 0);
 }
 
+static inline int rwsem_is_contended(struct rw_semaphore *sem)
+{
+	return (sem->count < 0);
+}
+
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_RWSEM_H */
diff -puN arch/xtensa/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended arch/xtensa/include/asm/rwsem.h
--- a/arch/xtensa/include/asm/rwsem.h~rwsem-implement-rwsem_is_contended
+++ a/arch/xtensa/include/asm/rwsem.h
@@ -165,4 +165,9 @@ static inline int rwsem_is_locked(struct
 	return (sem->count != 0);
 }
 
+static inline int rwsem_is_contended(struct rw_semaphore *sem)
+{
+        return (sem->count < 0);
+}
+
 #endif	/* _XTENSA_RWSEM_H */
diff -puN include/linux/rwsem-spinlock.h~rwsem-implement-rwsem_is_contended include/linux/rwsem-spinlock.h
--- a/include/linux/rwsem-spinlock.h~rwsem-implement-rwsem_is_contended
+++ a/include/linux/rwsem-spinlock.h
@@ -69,6 +69,7 @@ extern void __up_read(struct rw_semaphor
 extern void __up_write(struct rw_semaphore *sem);
 extern void __downgrade_write(struct rw_semaphore *sem);
 extern int rwsem_is_locked(struct rw_semaphore *sem);
+extern int rwsem_is_contended(struct rw_semaphore *sem);
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_RWSEM_SPINLOCK_H */
diff -puN lib/rwsem-spinlock.c~rwsem-implement-rwsem_is_contended lib/rwsem-spinlock.c
--- a/lib/rwsem-spinlock.c~rwsem-implement-rwsem_is_contended
+++ a/lib/rwsem-spinlock.c
@@ -30,6 +30,18 @@ int rwsem_is_locked(struct rw_semaphore 
 }
 EXPORT_SYMBOL(rwsem_is_locked);
 
+int rwsem_is_contended(struct rw_semaphore *sem)
+{
+	int ret = 0;
+	unsigned long flags;
+
+	if (spin_trylock_irqsave(&sem->wait_lock, flags)) {
+		ret = !list_empty(&sem->wait_list);
+		spin_unlock_irqrestore(&sem->wait_lock, flags);
+	}
+	return ret;
+}
+
 /*
  * initialise the semaphore
  */
_

Patches currently in -mm which might be from walken@google.com are

do_wp_page-remove-the-reuse-flag.patch
do_wp_page-clarify-dirty_page-handling.patch
mlock-avoid-dirtying-pages-and-triggering-writeback.patch
mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages.patch
mm-add-foll_mlock-follow_page-flag.patch
mm-move-vm_locked-check-to-__mlock_vma_pages_range.patch
rwsem-implement-rwsem_is_contended-checkpatch-fixes.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time-fix.patch
x86-rwsem-more-precise-rwsem_is_contended-implementation.patch

