From: akpm@linux-foundation.org
Subject: + rwsem-fix-rwsem_is_locked-bugs.patch added to -mm tree
Date: Thu, 15 Oct 2009 16:44:48 -0700
Message-ID: <200910152344.n9FNimxR007026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763328AbZJOXpl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 19:45:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: amwang@redhat.com, behlendorf1@llnl.gov, bwoodard@llnl.gov, dhowells@redhat.com


The patch titled
     rwsem: fix rwsem_is_locked() bugs
has been added to the -mm tree.  Its filename is
     rwsem-fix-rwsem_is_locked-bugs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

Reported-by: Brian Behlendorf <behlendorf1@llnl.gov>
Cc: Ben Woodard <bwoodard@llnl.gov>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: WANG Cong <amwang@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/rwsem-spinlock.h~rwsem-fix-rwsem_is_locked-bugs include/linux/rwsem-spinlock.h
--- a/include/linux/rwsem-spinlock.h~rwsem-fix-rwsem_is_locked-bugs
+++ a/include/linux/rwsem-spinlock.h
@@ -68,11 +68,9 @@ extern int __down_write_trylock(struct r
 extern void __up_read(struct rw_semaphore *sem);
 extern void __up_write(struct rw_semaphore *sem);
 extern void __downgrade_write(struct rw_semaphore *sem);
+extern int __rwsem_is_locked(struct rw_semaphore *sem);
 
-static inline int rwsem_is_locked(struct rw_semaphore *sem)
-{
-	return (sem->activity != 0);
-}
+#define rwsem_is_locked(sem) __rwsem_is_locked(sem)
 
 #endif /* __KERNEL__ */
 #endif /* _LINUX_RWSEM_SPINLOCK_H */
diff -puN lib/rwsem-spinlock.c~rwsem-fix-rwsem_is_locked-bugs lib/rwsem-spinlock.c
--- a/lib/rwsem-spinlock.c~rwsem-fix-rwsem_is_locked-bugs
+++ a/lib/rwsem-spinlock.c
@@ -17,6 +17,19 @@ struct rwsem_waiter {
 #define RWSEM_WAITING_FOR_WRITE	0x00000002
 };
 
+int __rwsem_is_locked(struct rw_semaphore *sem)
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
+EXPORT_SYMBOL(__rwsem_is_locked);
+
 /*
  * initialise the semaphore
  */
_

Patches currently in -mm which might be from amwang@redhat.com are

linux-next.patch
xtensa-use-generic-sys_pipe.patch
rwsem-spinlock-remove-useless-function-exports.patch
rwsem-fix-rwsem_is_locked-bugs.patch
kallsyms-remove-deprecated-print_fn_descriptor_symbol.patch

