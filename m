From: akpm@linux-foundation.org
Subject: + mlock-make-the-mlock-system-call-interruptible-by-fatal-signals.patch added to -mm tree
Date: Tue, 23 Sep 2008 16:16:34 -0700
Message-ID: <200809232316.m8NNGYY0030413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49187 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751753AbYIWXRP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Sep 2008 19:17:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sqazi@google.com, hugh@veritas.com, matthew@wil.cx, nickpiggin@yahoo.com.au


The patch titled
     mlock: make the mlock system call interruptible by fatal signals
has been added to the -mm tree.  Its filename is
     mlock-make-the-mlock-system-call-interruptible-by-fatal-signals.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mlock: make the mlock system call interruptible by fatal signals
From: sqazi@google.com (Salman Qazi)

Make the mlock system call interruptible by fatal signals, so that programs
that are mlocking a large number of pages terminate quickly when killed.

The following program can be used to verify that the above actually reduces the time required for an mlocking program to die, when a fatal signal is delivered:

/*
 * mlock_kill:  Attempts to SIGKILL a process that is mlocking a huge
 * chunk (4GB) of memory.  If the kill succeeds in less than a second
 * then mlock is interruptable.  If not, then there's a regression.
 *
 */
#include <stdlib.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/shm.h>
#include <signal.h>
#include <assert.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <errno.h>
#include <time.h>
#include <sys/time.h>
#include <string.h>

#define _LARGEFILE64_SOURCE

#define SHM_NAME	"dripd"
#define NUM_PAGES	1024*1024UL


union semun {
	int              val;    /* Value for SETVAL */
	struct semid_ds *buf;    /* Buffer for IPC_STAT, IPC_SET */
	unsigned short  *array;  /* Array for GETALL, SETALL */
	struct seminfo  *__buf;  /* Buffer for IPC_INFO
					(Linux specific) */
};

/*
 * The plan: Make a massive shared mem file, mmap it in a process,
 * lock its pages, and SIGKILL the process while doing so.
 * The mlock system call must abort early and the process must die
 * shortly afterwards.
 */
int main()
{
	int shm_id;
	int sem_id;
	int status;
	int pid;
	int ret;
	char *large_buffer = NULL;
	union semun data;
	struct timeval start;
	struct timeval end;
	struct timeval res;
	struct sembuf op;
	char cur_limit[256];
	char new_limit[256];
	int num_read;
	FILE *proc_file;

	/* Save the amount of shared memory allowed in the system */
	proc_file = fopen("/proc/sys/kernel/shmmax", "r+");
	num_read = fread(cur_limit, 1, 255, proc_file);
	cur_limit[num_read] = 0;
	printf("Limit was: %s", cur_limit);
	fclose(proc_file);

	/* increase it */
	proc_file = fopen("/proc/sys/kernel/shmmax", "w+");
	sprintf(new_limit, "%ld\n", (NUM_PAGES + 1)*4096);
	printf("New Limit: %s", new_limit);
	fwrite(new_limit, 1, strlen(new_limit),  proc_file);
	fclose(proc_file);

	op.sem_num = 0;
	shm_id = shmget(IPC_PRIVATE, NUM_PAGES*4096, 0600);
	if (errno) {
		perror("mlock_kill shmget");
		return EXIT_FAILURE;
	}
	sem_id = semget(IPC_PRIVATE, 1, IPC_CREAT);
	assert(sem_id >= 0);
	data.val = 0;
	semctl(sem_id, 0, SETVAL, data);
	pid = fork();
	if (pid < 0)
		return EXIT_FAILURE;
	if (pid == 0)
	{
		/* child process */
		large_buffer = shmat(shm_id, NULL, 0);

		if (large_buffer == MAP_FAILED) {
			perror("mlock_kill map failed");
			return 127;
		}
		/* Increment */
		op.sem_op = 1;
		semop(sem_id, &op, 1);
		/* Wait for ack. */
		op.sem_op = 0;
		semop(sem_id, &op, 1);
		printf("%lx\n", (unsigned long)large_buffer);
		ret = mlock(large_buffer, NUM_PAGES * 4096);
		printf("Parent failed to kill me in time!\n");
		return EXIT_FAILURE;
	} else {
		/* parent process */
		op.sem_op = -1;

		/* Wait for increment (and send ack) */
		semop(sem_id, &op, 1);
		printf("synced\n");

		/* when above ack happened, the other process was about to
		 * mlock.
		 * we should sleep a little and then kill it
		 */
		sleep(1);

		/* Kill dash nine - no more CPU time!  */
		kill(pid, SIGKILL);
		printf("waiting...\n");
		gettimeofday(&start, NULL);
		wait(&status);
		gettimeofday(&end, NULL);
		timersub(&end, &start, &res);
		printf("Took %d:%d to die.\n", res.tv_sec, res.tv_usec);
		/* free shared memory */
		shmdt(large_buffer);
		shmctl(shm_id, IPC_RMID, NULL);

		/* reset shmmax */
		proc_file = fopen("/proc/sys/kernel/shmmax", "w+");
		fwrite(cur_limit, 1, strlen(cur_limit),  proc_file);
		fclose(proc_file);
		printf("Limit reset\n");

		if (res.tv_sec > 0) {
			printf("FAIL");
			return EXIT_FAILURE;
		}
		printf("PASS");

	}
	return EXIT_SUCCESS;

}

Signed-off-by: Salman Qazi <sqazi@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    3 ++-
 mm/fremap.c        |    2 +-
 mm/memory.c        |   23 +++++++++++++++++------
 mm/mlock.c         |    2 +-
 mm/mmap.c          |   10 +++++-----
 mm/mremap.c        |    4 ++--
 6 files changed, 28 insertions(+), 16 deletions(-)

diff -puN include/linux/mm.h~mlock-make-the-mlock-system-call-interruptible-by-fatal-signals include/linux/mm.h
--- a/include/linux/mm.h~mlock-make-the-mlock-system-call-interruptible-by-fatal-signals
+++ a/include/linux/mm.h
@@ -807,7 +807,8 @@ static inline int handle_mm_fault(struct
 }
 #endif
 
-extern int make_pages_present(unsigned long addr, unsigned long end);
+extern int make_pages_present(unsigned long addr, unsigned long end,
+			int interruptible);
 extern int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, int len, int write);
 
 int get_user_pages(struct task_struct *tsk, struct mm_struct *mm, unsigned long start,
diff -puN mm/fremap.c~mlock-make-the-mlock-system-call-interruptible-by-fatal-signals mm/fremap.c
--- a/mm/fremap.c~mlock-make-the-mlock-system-call-interruptible-by-fatal-signals
+++ a/mm/fremap.c
@@ -223,7 +223,7 @@ asmlinkage long sys_remap_file_pages(uns
 			downgrade_write(&mm->mmap_sem);
 			has_write_lock = 0;
 		}
-		make_pages_present(start, start+size);
+		make_pages_present(start, start+size, 0);
 	}
 
 	/*
diff -puN mm/memory.c~mlock-make-the-mlock-system-call-interruptible-by-fatal-signals mm/memory.c
--- a/mm/memory.c~mlock-make-the-mlock-system-call-interruptible-by-fatal-signals
+++ a/mm/memory.c
@@ -1129,9 +1129,10 @@ static inline int use_zero_page(struct v
 	return !vma->vm_ops || !vma->vm_ops->fault;
 }
 
-int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
-		unsigned long start, int len, int write, int force,
-		struct page **pages, struct vm_area_struct **vmas)
+static int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+			unsigned long start, int len, int write, int force,
+			struct page **pages, struct vm_area_struct **vmas,
+			int interruptible)
 {
 	int i;
 	unsigned int vm_flags;
@@ -1223,6 +1224,8 @@ int get_user_pages(struct task_struct *t
 			cond_resched();
 			while (!(page = follow_page(vma, start, foll_flags))) {
 				int ret;
+				if (interruptible && fatal_signal_pending(tsk))
+					return i ? i : -EINTR;
 				ret = handle_mm_fault(mm, vma, start,
 						foll_flags & FOLL_WRITE);
 				if (ret & VM_FAULT_ERROR) {
@@ -1266,6 +1269,14 @@ int get_user_pages(struct task_struct *t
 	} while (len);
 	return i;
 }
+
+int get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
+		unsigned long start, int len, int write, int force,
+		struct page **pages, struct vm_area_struct **vmas)
+{
+	return __get_user_pages(tsk, mm, start, len, write, force,
+				pages, vmas, 0);
+}
 EXPORT_SYMBOL(get_user_pages);
 
 pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr,
@@ -2758,7 +2769,7 @@ int __pmd_alloc(struct mm_struct *mm, pu
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-int make_pages_present(unsigned long addr, unsigned long end)
+int make_pages_present(unsigned long addr, unsigned long end, int interruptible)
 {
 	int ret, len, write;
 	struct vm_area_struct * vma;
@@ -2770,8 +2781,8 @@ int make_pages_present(unsigned long add
 	BUG_ON(addr >= end);
 	BUG_ON(end > vma->vm_end);
 	len = DIV_ROUND_UP(end, PAGE_SIZE) - addr/PAGE_SIZE;
-	ret = get_user_pages(current, current->mm, addr,
-			len, write, 0, NULL, NULL);
+	ret = __get_user_pages(current, current->mm, addr,
+			len, write, 0, NULL, NULL, interruptible);
 	if (ret < 0) {
 		/*
 		   SUS require strange return value to mlock
diff -puN mm/mlock.c~mlock-make-the-mlock-system-call-interruptible-by-fatal-signals mm/mlock.c
--- a/mm/mlock.c~mlock-make-the-mlock-system-call-interruptible-by-fatal-signals
+++ a/mm/mlock.c
@@ -73,7 +73,7 @@ success:
 	if (newflags & VM_LOCKED) {
 		pages = -pages;
 		if (!(newflags & VM_IO))
-			ret = make_pages_present(start, end);
+			ret = make_pages_present(start, end, 1);
 	}
 
 	mm->locked_vm -= pages;
diff -puN mm/mmap.c~mlock-make-the-mlock-system-call-interruptible-by-fatal-signals mm/mmap.c
--- a/mm/mmap.c~mlock-make-the-mlock-system-call-interruptible-by-fatal-signals
+++ a/mm/mmap.c
@@ -1225,10 +1225,10 @@ out:
 	vm_stat_account(mm, vm_flags, file, len >> PAGE_SHIFT);
 	if (vm_flags & VM_LOCKED) {
 		mm->locked_vm += len >> PAGE_SHIFT;
-		make_pages_present(addr, addr + len);
+		make_pages_present(addr, addr + len, 0);
 	}
 	if ((flags & MAP_POPULATE) && !(flags & MAP_NONBLOCK))
-		make_pages_present(addr, addr + len);
+		make_pages_present(addr, addr + len, 0);
 	return addr;
 
 unmap_and_free_vma:
@@ -1701,7 +1701,7 @@ find_extend_vma(struct mm_struct *mm, un
 	if (!prev || expand_stack(prev, addr))
 		return NULL;
 	if (prev->vm_flags & VM_LOCKED)
-		make_pages_present(addr, prev->vm_end);
+		make_pages_present(addr, prev->vm_end, 0);
 	return prev;
 }
 #else
@@ -1728,7 +1728,7 @@ find_extend_vma(struct mm_struct * mm, u
 	if (expand_stack(vma, addr))
 		return NULL;
 	if (vma->vm_flags & VM_LOCKED)
-		make_pages_present(addr, start);
+		make_pages_present(addr, start, 0);
 	return vma;
 }
 #endif
@@ -2049,7 +2049,7 @@ out:
 	mm->total_vm += len >> PAGE_SHIFT;
 	if (flags & VM_LOCKED) {
 		mm->locked_vm += len >> PAGE_SHIFT;
-		make_pages_present(addr, addr + len);
+		make_pages_present(addr, addr + len, 0);
 	}
 	return addr;
 }
diff -puN mm/mremap.c~mlock-make-the-mlock-system-call-interruptible-by-fatal-signals mm/mremap.c
--- a/mm/mremap.c~mlock-make-the-mlock-system-call-interruptible-by-fatal-signals
+++ a/mm/mremap.c
@@ -239,7 +239,7 @@ static unsigned long move_vma(struct vm_
 		mm->locked_vm += new_len >> PAGE_SHIFT;
 		if (new_len > old_len)
 			make_pages_present(new_addr + old_len,
-					   new_addr + new_len);
+					   new_addr + new_len, 0);
 	}
 
 	return new_addr;
@@ -380,7 +380,7 @@ unsigned long do_mremap(unsigned long ad
 			if (vma->vm_flags & VM_LOCKED) {
 				mm->locked_vm += pages;
 				make_pages_present(addr + old_len,
-						   addr + new_len);
+						   addr + new_len, 0);
 			}
 			ret = addr;
 			goto out;
_

Patches currently in -mm which might be from sqazi@google.com are

linux-next.patch
mlock-make-the-mlock-system-call-interruptible-by-fatal-signals.patch

