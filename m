From: akpm@linux-foundation.org
Subject: [merged] rwsem-fix-rwsem_is_locked-bugs.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:55:45 -0800
Message-ID: <200912152155.nBFLtjk8015509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933785AbZLOV4b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:56:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: amwang@redhat.com, behlendorf1@llnl.gov, bwoodard@llnl.gov, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     rwsem: fix rwsem_is_locked() bugs
has been removed from the -mm tree.  Its filename was
     rwsem-fix-rwsem_is_locked-bugs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rwsem: fix rwsem_is_locked() bugs
From: Amerigo Wang <amwang@redhat.com>

rwsem_is_locked() tests ->activity without locks, so we should always keep
->activity consistent.  However, the code in __rwsem_do_wake() breaks this
rule, it updates ->activity after _all_ readers waken up, this may give
some reader a wrong ->activity value, thus cause rwsem_is_locked() behaves
wrong.

Quote from Andrew:

"
- we have one or more processes sleeping in down_read(), waiting for access.

- we wake one or more processes up without altering ->activity

- they start to run and they do rwsem_is_locked().  This incorrectly
  returns "false", because the waker process is still crunching away in
  __rwsem_do_wake().

- the waker now alters ->activity, but it was too late.
"

So we need get a spinlock to protect this.  And rwsem_is_locked() should
not block, thus we use spin_trylock_irqsave().

[akpm@linux-foundation.org: simplify code]
Reported-by: Brian Behlendorf <behlendorf1@llnl.gov>
Cc: Ben Woodard <bwoodard@llnl.gov>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: WANG Cong <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rwsem-spinlock.h |    6 +-----
 lib/rwsem-spinlock.c           |   13 +++++++++++++
 2 files changed, 14 insertions(+), 5 deletions(-)

diff -puN include/linux/rwsem-spinlock.h~rwsem-fix-rwsem_is_locked-bugs include/linux/rwsem-spinlock.h
--- a/include/linux/rwsem-spinlock.h~rwsem-fix-rwsem_is_locked-bugs
+++ a/include/linux/rwsem-spinlock.h
@@ -68,11 +68,7 @@ extern int __down_write_trylock(struct r
 extern void __up_read(struct rw_semaphore *sem);
 extern void __up_write(struct rw_semaphore *sem);
 extern void __downgrade_write(struct rw_semaphore *sem);
-
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->activity != 0);
-}
+extern int rwsem_is_locked(struct rw_semaphore *sem);
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_RWSEM_SPINLOCK_H */
diff -puN lib/rwsem-spinlock.c~rwsem-fix-rwsem_is_locked-bugs lib/rwsem-spinlock.c
--- a/lib/rwsem-spinlock.c~rwsem-fix-rwsem_is_locked-bugs
+++ a/lib/rwsem-spinlock.c
@@ -17,6 +17,19 @@ struct rwsem_waiter {
 #define RWSEM_WAITING_FOR_WRITE	0x00000002
 };
 
+int rwsem_is_locked(struct rw_semaphore *sem)
+{
+	int ret = 1;
+	unsigned long flags;
+
+	if (spin_trylock_irqsave(&sem->wait_lock, flags)) {
+		ret = (sem->activity != 0);
+		spin_unlock_irqrestore(&sem->wait_lock, flags);
+	}
+	return ret;
+}
+EXPORT_SYMBOL(rwsem_is_locked);
+
 /*
  * initialise the semaphore
  */
_

Patches currently in -mm which might be from amwang@redhat.com are

origin.patch
linux-next.patch
xtensa-use-generic-sys_pipe.patch
ipc-remove-unreachable-code-in-semc.patch
ipc-remove-unreachable-code-in-semc-fix.patch
ipc-hard_msgmax-should-be-higher-not-lower-on-64bit.patch
kexec-premit-reduction-of-the-reserved-memory-size.patch
kexec-premit-reduction-of-the-reserved-memory-size-fix.patch

