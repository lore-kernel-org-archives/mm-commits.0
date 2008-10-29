From: akpm@linux-foundation.org
Subject: + nfsd-fix-vm-overcommit-crash.patch added to -mm tree
Date: Tue, 28 Oct 2008 17:35:03 -0700
Message-ID: <200810290035.m9T0Z3Gk008109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751955AbYJ2Afy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 20:35:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alan@redhat.com, hooanon05@yahoo.co.jp, jmorris@namei.org


The patch titled
     nfsd: fix vm overcommit crash
has been added to the -mm tree.  Its filename is
     nfsd-fix-vm-overcommit-crash.patch

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
Subject: nfsd: fix vm overcommit crash
From: Alan Cox <alan@redhat.com>

Junjiro R.  Okajima reported a problem where knfsd crashes if you are
using it to export shmemfs objects and run strict overcommit.  In this
situation the current->mm based modifier to the overcommit goes through a
NULL pointer.

We could simply check for NULL and skip the modifier but we've caught
other real bugs in the past from mm being NULL here - cases where we did
need a valid mm set up (eg the exec bug about a year ago).

To preserve the checks and get the logic we want shuffle the checking
around and add a new helper to the vm_ security wrappers

Also fix a current->mm reference in nommu that should use the passed mm

Reported-by: Junjiro R. Okajima <hooanon05@yahoo.co.jp>
Acked-by: James Morris <jmorris@namei.org>
Signed-off-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/security.h |    1 +
 mm/mmap.c                |    3 ++-
 mm/nommu.c               |    3 ++-
 mm/shmem.c               |    4 ++--
 security/security.c      |    9 +++++++++
 5 files changed, 16 insertions(+), 4 deletions(-)

diff -puN include/linux/security.h~nfsd-fix-vm-overcommit-crash include/linux/security.h
--- a/include/linux/security.h~nfsd-fix-vm-overcommit-crash
+++ a/include/linux/security.h
@@ -1585,6 +1585,7 @@ int security_syslog(int type);
 int security_settime(struct timespec *ts, struct timezone *tz);
 int security_vm_enough_memory(long pages);
 int security_vm_enough_memory_mm(struct mm_struct *mm, long pages);
+int security_vm_enough_memory_kern(long pages);
 int security_bprm_alloc(struct linux_binprm *bprm);
 void security_bprm_free(struct linux_binprm *bprm);
 void security_bprm_apply_creds(struct linux_binprm *bprm, int unsafe);
diff -puN mm/mmap.c~nfsd-fix-vm-overcommit-crash mm/mmap.c
--- a/mm/mmap.c~nfsd-fix-vm-overcommit-crash
+++ a/mm/mmap.c
@@ -175,7 +175,8 @@ int __vm_enough_memory(struct mm_struct 
 
 	/* Don't let a single process grow too big:
 	   leave 3% of the size of this process for other processes */
-	allowed -= mm->total_vm / 32;
+	if (mm)
+		allowed -= mm->total_vm / 32;
 
 	/*
 	 * cast `allowed' as a signed long because vm_committed_space
diff -puN mm/nommu.c~nfsd-fix-vm-overcommit-crash mm/nommu.c
--- a/mm/nommu.c~nfsd-fix-vm-overcommit-crash
+++ a/mm/nommu.c
@@ -1454,7 +1454,8 @@ int __vm_enough_memory(struct mm_struct 
 
 	/* Don't let a single process grow too big:
 	   leave 3% of the size of this process for other processes */
-	allowed -= current->mm->total_vm / 32;
+	if (mm)
+		allowed -= mm->total_vm / 32;
 
 	/*
 	 * cast `allowed' as a signed long because vm_committed_space
diff -puN mm/shmem.c~nfsd-fix-vm-overcommit-crash mm/shmem.c
--- a/mm/shmem.c~nfsd-fix-vm-overcommit-crash
+++ a/mm/shmem.c
@@ -162,7 +162,7 @@ static inline struct shmem_sb_info *SHME
 static inline int shmem_acct_size(unsigned long flags, loff_t size)
 {
 	return (flags & VM_ACCOUNT)?
-		security_vm_enough_memory(VM_ACCT(size)): 0;
+		security_vm_enough_memory_kern(VM_ACCT(size)): 0;
 }
 
 static inline void shmem_unacct_size(unsigned long flags, loff_t size)
@@ -180,7 +180,7 @@ static inline void shmem_unacct_size(uns
 static inline int shmem_acct_block(unsigned long flags)
 {
 	return (flags & VM_ACCOUNT)?
-		0: security_vm_enough_memory(VM_ACCT(PAGE_CACHE_SIZE));
+		0: security_vm_enough_memory_kern(VM_ACCT(PAGE_CACHE_SIZE));
 }
 
 static inline void shmem_unacct_blocks(unsigned long flags, long pages)
diff -puN security/security.c~nfsd-fix-vm-overcommit-crash security/security.c
--- a/security/security.c~nfsd-fix-vm-overcommit-crash
+++ a/security/security.c
@@ -198,14 +198,23 @@ int security_settime(struct timespec *ts
 
 int security_vm_enough_memory(long pages)
 {
+	WARN_ON(current->mm == NULL);
 	return security_ops->vm_enough_memory(current->mm, pages);
 }
 
 int security_vm_enough_memory_mm(struct mm_struct *mm, long pages)
 {
+	WARN_ON(mm == NULL);
 	return security_ops->vm_enough_memory(mm, pages);
 }
 
+int security_vm_enough_memory_kern(long pages)
+{
+	/* If current->mm is a kernel thread then we will pass NULL,
+	   for this specific case that is fine */
+	return security_ops->vm_enough_memory(current->mm, pages);
+}
+
 int security_bprm_alloc(struct linux_binprm *bprm)
 {
 	return security_ops->bprm_alloc_security(bprm);
_

Patches currently in -mm which might be from alan@redhat.com are

origin.patch
rationalise-randys-address-a-bit.patch
nfsd-fix-vm-overcommit-crash.patch
linux-next.patch

