From: akpm@linux-foundation.org
Subject: - futex-new-private-futexes.patch removed from -mm tree
Date: Wed, 09 May 2007 14:53:42 -0700
Message-ID: <200705092153.l49LrgZo003099@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759315AbXEIVyt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:54:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, drepper@gmail.com, mingo@elte.hu, nickpiggin@yahoo.com.au, pierre.peiffer@bull.net, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     FUTEX: new PRIVATE futexes
has been removed from the -mm tree.  Its filename was
     futex-new-private-futexes.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

------------------------------------------------------
Subject: FUTEX: new PRIVATE futexes
=46rom: Eric Dumazet <dada1@cosmosbay.com>

Analysis of current linux futex code :
--------------------------------------

A central hash table futex_queues[] holds all contexts (futex_q) of wai=
ting
threads.

Each futex_wait()/futex_wait() has to obtain a spinlock on a hash slot =
to
perform lookups or insert/deletion of a futex_q.

When a futex_wait() is done, calling thread has to :

1) - Obtain a read lock on mmap_sem to be able to validate the user poi=
nter
=A0 =A0 =A0(calling find_vma()). This validation tells us if the futex =
uses
=A0 =A0 =A0an inode based store (mapped file), or mm based store (anony=
mous mem)

2) - compute a hash key

3) - Atomic increment of reference counter on an inode or a mm_struct

4) - lock part of futex_queues[] hash table

5) - perform the test on value of futex.
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (rollback is value !=3D expected_value,=
 returns EWOULDBLOCK)
=A0 =A0 =A0 =A0 (various loops if test triggers mm faults)

6) queue the context into hash table, release the lock got in 4)

7) - release the read_lock on mmap_sem

=A0 =A0<block>

8) Eventually unqueue the context (but rarely, as this part =A0may be d=
one
   by the futex_wake())

=46utexes were designed to improve scalability but current implementati=
on has
various problems :

- Central hashtable :
=A0This means scalability problems if many processes/threads want to us=
e
=A0futexes at the same time.
=A0This means NUMA unbalance because this hashtable is located on one n=
ode.

- Using mmap_sem on every futex() syscall :

=A0Even if mmap_sem is a rw_semaphore, up_read()/down_read() are doing =
atomic
=A0ops on mmap_sem, dirtying cache line :
=A0 =A0 =A0 =A0 - lot of cache line ping pongs on SMP configurations.

=A0mmap_sem is also extensively used by mm code (page faults, mmap()/mu=
nmap())
=A0Highly threaded processes might suffer from mmap_sem contention.

=A0mmap_sem is also used by oprofile code. Enabling oprofile hurts thre=
aded
programs because of contention on the mmap_sem cache line.

- Using an atomic_inc()/atomic_dec() on inode ref counter or mm ref cou=
nter:
=A0It's also a cache line ping pong on SMP. It also increases mmap_sem =
hold time
=A0because of cache misses.

Most of these scalability problems come from the fact that futexes are =
in
one global namespace.  As we use a central hash table, we must make sur=
e
they are all using the same reference (given by the mm subsystem).  We
chose to force all futexes be 'shared'.  This has a cost.

But fact is POSIX defined PRIVATE and SHARED, allowing clear separation=
,
and optimal performance if carefuly implemented.  Time has come for lin=
ux
to have better threading performance.

The goal is to permit new futex commands to avoid :
=A0- Taking the mmap_sem semaphore, conflicting with other subsystems.
=A0- Modifying a ref_count on mm or an inode, still conflicting with mm=
 or fs.

This is possible because, for one process using PTHREAD_PROCESS_PRIVATE
futexes, we only need to distinguish futexes by their virtual address, =
no
matter the underlying mm storage is.

If glibc wants to exploit this new infrastructure, it should use new
_PRIVATE futex subcommands for PTHREAD_PROCESS_PRIVATE futexes.  And be
prepared to fallback on old subcommands for old kernels.  Using one glo=
bal
variable with the FUTEX_PRIVATE_FLAG or 0 value should be OK.

PTHREAD_PROCESS_SHARED futexes should still use the old subcommands.

Compatibility with old applications is preserved, they still hit the
scalability problems, but new applications can fly :)

Note : the same SHARED futex (mapped on a file) can be used by old bina=
ries
*and* new binaries, because both binaries will use the old subcommands.

Note : Vast majority of futexes should be using PROCESS_PRIVATE semanti=
c,
as this is the default semantic. Almost all applications should benefit
of this changes (new kernel and updated libc)

Some bench results on a Pentium M 1.6 GHz (SMP kernel on a UP machine)

/* calling futex_wait(addr, value) with value !=3D *addr */
433 cycles per futex(FUTEX_WAIT) call (mixing 2 futexes)
424 cycles per futex(FUTEX_WAIT) call (using one futex)
334 cycles per futex(FUTEX_WAIT_PRIVATE) call (mixing 2 futexes)
334 cycles per futex(FUTEX_WAIT_PRIVATE) call (using one futex)
=46or reference :
187 cycles per getppid() call
188 cycles per umask() call
181 cycles per ni_syscall() call

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Pierre Peiffer <pierre.peiffer@bull.net>
Cc: "Ulrich Drepper" <drepper@gmail.com>
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>
Cc: "Ingo Molnar" <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/futex.h |   29 +++
 kernel/futex.c        |  324 +++++++++++++++++++++++++---------------
 2 files changed, 236 insertions(+), 117 deletions(-)

diff -puN include/linux/futex.h~futex-new-private-futexes include/linux=
/futex.h
--- a/include/linux/futex.h~futex-new-private-futexes
+++ a/include/linux/futex.h
@@ -19,6 +19,18 @@ union ktime;
 #define FUTEX_TRYLOCK_PI	8
 #define FUTEX_CMP_REQUEUE_PI	9
=20
+#define FUTEX_PRIVATE_FLAG	128
+#define FUTEX_CMD_MASK		~FUTEX_PRIVATE_FLAG
+
+#define FUTEX_WAIT_PRIVATE	(FUTEX_WAIT | FUTEX_PRIVATE_FLAG)
+#define FUTEX_WAKE_PRIVATE	(FUTEX_WAKE | FUTEX_PRIVATE_FLAG)
+#define FUTEX_REQUEUE_PRIVATE	(FUTEX_REQUEUE | FUTEX_PRIVATE_FLAG)
+#define FUTEX_CMP_REQUEUE_PRIVATE (FUTEX_CMP_REQUEUE | FUTEX_PRIVATE_F=
LAG)
+#define FUTEX_WAKE_OP_PRIVATE	(FUTEX_WAKE_OP | FUTEX_PRIVATE_FLAG)
+#define FUTEX_LOCK_PI_PRIVATE	(FUTEX_LOCK_PI | FUTEX_PRIVATE_FLAG)
+#define FUTEX_UNLOCK_PI_PRIVATE	(FUTEX_UNLOCK_PI | FUTEX_PRIVATE_FLAG)
+#define FUTEX_TRYLOCK_PI_PRIVATE (FUTEX_TRYLOCK_PI | FUTEX_PRIVATE_FLA=
G)
+
 /*
  * Support for robust futexes: the kernel cleans up held futexes at
  * thread exit time.
@@ -114,8 +126,18 @@ handle_futex_death(u32 __user *uaddr, st
  * Don't rearrange members without looking at hash_futex().
  *
  * offset is aligned to a multiple of sizeof(u32) (=3D=3D 4) by defini=
tion.
- * We set bit 0 to indicate if it's an inode-based key.
- */
+ * We use the two low order bits of offset to tell what is the kind of=
 key :
+ *  00 : Private process futex (PTHREAD_PROCESS_PRIVATE)
+ *       (no reference on an inode or mm)
+ *  01 : Shared futex (PTHREAD_PROCESS_SHARED)
+ *	mapped on a file (reference on the underlying inode)
+ *  10 : Shared futex (PTHREAD_PROCESS_SHARED)
+ *       (but private mapping on an mm, and reference taken on it)
+*/
+
+#define FUT_OFF_INODE    1 /* We set bit 0 if key has a reference on i=
node */
+#define FUT_OFF_MMSHARED 2 /* We set bit 1 if key has a reference on m=
m */
+
 union futex_key {
 	u32 __user *uaddr;
 	struct {
@@ -134,7 +156,8 @@ union futex_key {
 		int offset;
 	} both;
 };
-int get_futex_key(u32 __user *uaddr, union futex_key *key);
+int get_futex_key(u32 __user *uaddr, struct rw_semaphore *shared,
+		  union futex_key *key);
 void get_futex_key_refs(union futex_key *key);
 void drop_futex_key_refs(union futex_key *key);
=20
diff -puN kernel/futex.c~futex-new-private-futexes kernel/futex.c
--- a/kernel/futex.c~futex-new-private-futexes
+++ a/kernel/futex.c
@@ -16,6 +16,9 @@
  *  Copyright (C) 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
  *  Copyright (C) 2006 Timesys Corp., Thomas Gleixner <tglx@timesys.co=
m>
  *
+ *  PRIVATE futexes by Eric Dumazet
+ *  Copyright (C) 2007 Eric Dumazet <dada1@cosmosbay.com>
+ *
  *  Thanks to Ben LaHaise for yelling "hashed waitqueues" loudly
  *  enough at me, Linus for the original (flawed) idea, Matthew
  *  Kirkwood for proof-of-concept implementation.
@@ -150,19 +153,26 @@ static inline int match_futex(union fute
 		&& key1->both.offset =3D=3D key2->both.offset);
 }
=20
-/*
- * Get parameters which are the keys for a futex.
+/**
+ * get_futex_key - Get parameters which are the keys for a futex.
+ * @uaddr: virtual address of the futex
+ * @shared: NULL for a PROCESS_PRIVATE futex,
+ *	&current->mm->mmap_sem for a PROCESS_SHARED futex
+ * @key: address where result is stored.
+ *
+ * Returns a negative error code or 0
+ * The key words are stored in *key on success.
  *
  * For shared mappings, it's (page->index, vma->vm_file->f_path.dentry=
->d_inode,
  * offset_within_page).  For private mappings, it's (uaddr, current->m=
m).
  * We can usually work out the index without swapping in the page.
  *
- * Returns: 0, or negative error code.
- * The key words are stored in *key on success.
- *
- * Should be called with &current->mm->mmap_sem but NOT any spinlocks.
+ * fshared is NULL for PROCESS_PRIVATE futexes
+ * For other futexes, it points to &current->mm->mmap_sem and
+ * caller must have taken the reader lock. but NOT any spinlocks.
  */
-int get_futex_key(u32 __user *uaddr, union futex_key *key)
+int get_futex_key(u32 __user *uaddr, struct rw_semaphore *fshared,
+		  union futex_key *key)
 {
 	unsigned long address =3D (unsigned long)uaddr;
 	struct mm_struct *mm =3D current->mm;
@@ -174,11 +184,25 @@ int get_futex_key(u32 __user *uaddr, uni
 	 * The futex address must be "naturally" aligned.
 	 */
 	key->both.offset =3D address % PAGE_SIZE;
-	if (unlikely((key->both.offset % sizeof(u32)) !=3D 0))
+	if (unlikely((address % sizeof(u32)) !=3D 0))
 		return -EINVAL;
 	address -=3D key->both.offset;
=20
 	/*
+	 * PROCESS_PRIVATE futexes are fast.
+	 * As the mm cannot disappear under us and the 'key' only needs
+	 * virtual address, we dont even have to find the underlying vma.
+	 * Note : We do have to check 'uaddr' is a valid user address,
+	 *        but access_ok() should be faster than find_vma()
+	 */
+	if (!fshared) {
+		if (unlikely(!access_ok(VERIFY_WRITE, uaddr, sizeof(u32))))
+			return -EFAULT;
+		key->private.mm =3D mm;
+		key->private.address =3D address;
+		return 0;
+	}
+	/*
 	 * The futex is hashed differently depending on whether
 	 * it's in a shared or private mapping.  So check vma first.
 	 */
@@ -205,6 +229,7 @@ int get_futex_key(u32 __user *uaddr, uni
 	 * mappings of _writable_ handles.
 	 */
 	if (likely(!(vma->vm_flags & VM_MAYSHARE))) {
+		key->both.offset |=3D FUT_OFF_MMSHARED; /* reference taken on mm */
 		key->private.mm =3D mm;
 		key->private.address =3D address;
 		return 0;
@@ -214,7 +239,7 @@ int get_futex_key(u32 __user *uaddr, uni
 	 * Linear file mappings are also simple.
 	 */
 	key->shared.inode =3D vma->vm_file->f_path.dentry->d_inode;
-	key->both.offset++; /* Bit 0 of offset indicates inode-based key. */
+	key->both.offset |=3D FUT_OFF_INODE; /* inode-based key. */
 	if (likely(!(vma->vm_flags & VM_NONLINEAR))) {
 		key->shared.pgoff =3D (((address - vma->vm_start) >> PAGE_SHIFT)
 				     + vma->vm_pgoff);
@@ -242,16 +267,18 @@ EXPORT_SYMBOL_GPL(get_futex_key);
  * Take a reference to the resource addressed by a key.
  * Can be called while holding spinlocks.
  *
- * NOTE: mmap_sem MUST be held between get_futex_key() and calling thi=
s
- * function, if it is called at all.  mmap_sem keeps key->shared.inode=
 valid.
  */
 inline void get_futex_key_refs(union futex_key *key)
 {
-	if (key->both.ptr !=3D 0) {
-		if (key->both.offset & 1)
+	if (key->both.ptr =3D=3D 0)
+		return;
+	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
+		case FUT_OFF_INODE:
 			atomic_inc(&key->shared.inode->i_count);
-		else
+			break;
+		case FUT_OFF_MMSHARED:
 			atomic_inc(&key->private.mm->mm_count);
+			break;
 	}
 }
 EXPORT_SYMBOL_GPL(get_futex_key_refs);
@@ -262,11 +289,15 @@ EXPORT_SYMBOL_GPL(get_futex_key_refs);
  */
 void drop_futex_key_refs(union futex_key *key)
 {
-	if (key->both.ptr !=3D 0) {
-		if (key->both.offset & 1)
+	if (key->both.ptr =3D=3D 0)
+		return;
+	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
+		case FUT_OFF_INODE:
 			iput(key->shared.inode);
-		else
+			break;
+		case FUT_OFF_MMSHARED:
 			mmdrop(key->private.mm);
+			break;
 	}
 }
 EXPORT_SYMBOL_GPL(drop_futex_key_refs);
@@ -283,28 +314,38 @@ static inline int get_futex_value_locked
 }
=20
 /*
- * Fault handling. Called with current->mm->mmap_sem held.
+ * Fault handling.
+ * if fshared is non NULL, current->mm->mmap_sem is already held
  */
-static int futex_handle_fault(unsigned long address, int attempt)
+static int futex_handle_fault(unsigned long address,
+			      struct rw_semaphore *fshared, int attempt)
 {
 	struct vm_area_struct * vma;
 	struct mm_struct *mm =3D current->mm;
+	int ret =3D -EFAULT;
=20
-	if (attempt > 2 || !(vma =3D find_vma(mm, address)) ||
-	    vma->vm_start > address || !(vma->vm_flags & VM_WRITE))
-		return -EFAULT;
+	if (attempt > 2)
+		return ret;
=20
-	switch (handle_mm_fault(mm, vma, address, 1)) {
-	case VM_FAULT_MINOR:
-		current->min_flt++;
-		break;
-	case VM_FAULT_MAJOR:
-		current->maj_flt++;
-		break;
-	default:
-		return -EFAULT;
+	if (!fshared)
+		down_read(&mm->mmap_sem);
+	vma =3D find_vma(mm, address);
+	if (vma && address >=3D vma->vm_start &&
+	    (vma->vm_flags & VM_WRITE)) {
+		switch (handle_mm_fault(mm, vma, address, 1)) {
+		case VM_FAULT_MINOR:
+			ret =3D 0;
+			current->min_flt++;
+			break;
+		case VM_FAULT_MAJOR:
+			ret =3D 0;
+			current->maj_flt++;
+			break;
+		}
 	}
-	return 0;
+	if (!fshared)
+		up_read(&mm->mmap_sem);
+	return ret;
 }
=20
 /*
@@ -647,7 +688,8 @@ double_lock_hb(struct futex_hash_bucket=20
  * Wake up all waiters hashed on the physical page that is mapped
  * to this virtual address:
  */
-static int futex_wake(u32 __user *uaddr, int nr_wake)
+static int futex_wake(u32 __user *uaddr, struct rw_semaphore *fshared,
+		      int nr_wake)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
@@ -655,9 +697,10 @@ static int futex_wake(u32 __user *uaddr,
 	union futex_key key;
 	int ret;
=20
-	down_read(&current->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
=20
-	ret =3D get_futex_key(uaddr, &key);
+	ret =3D get_futex_key(uaddr, fshared, &key);
 	if (unlikely(ret !=3D 0))
 		goto out;
=20
@@ -679,7 +722,8 @@ static int futex_wake(u32 __user *uaddr,
=20
 	spin_unlock(&hb->lock);
 out:
-	up_read(&current->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 	return ret;
 }
=20
@@ -746,7 +790,9 @@ retry:
  * and requeue the next nr_requeue waiters following hashed on
  * one physical page to another physical page (PI-futex uaddr2)
  */
-static int futex_requeue_pi(u32 __user *uaddr1, u32 __user *uaddr2,
+static int futex_requeue_pi(u32 __user *uaddr1,
+			    struct rw_semaphore *fshared,
+			    u32 __user *uaddr2,
 			    int nr_wake, int nr_requeue, u32 *cmpval)
 {
 	union futex_key key1, key2;
@@ -765,12 +811,13 @@ retry:
 	/*
 	 * First take all the futex related locks:
 	 */
-	down_read(&current->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
=20
-	ret =3D get_futex_key(uaddr1, &key1);
+	ret =3D get_futex_key(uaddr1, fshared, &key1);
 	if (unlikely(ret !=3D 0))
 		goto out;
-	ret =3D get_futex_key(uaddr2, &key2);
+	ret =3D get_futex_key(uaddr2, fshared, &key2);
 	if (unlikely(ret !=3D 0))
 		goto out;
=20
@@ -793,7 +840,8 @@ retry:
 			 * If we would have faulted, release mmap_sem, fault
 			 * it in and start all over again.
 			 */
-			up_read(&current->mm->mmap_sem);
+			if (fshared)
+				up_read(fshared);
=20
 			ret =3D get_user(curval, uaddr1);
=20
@@ -927,7 +975,8 @@ out_unlock:
 		drop_futex_key_refs(&key1);
=20
 out:
-	up_read(&current->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 	return ret;
 }
=20
@@ -936,7 +985,8 @@ out:
  * to this virtual address:
  */
 static int
-futex_wake_op(u32 __user *uaddr1, u32 __user *uaddr2,
+futex_wake_op(u32 __user *uaddr1, struct rw_semaphore *fshared,
+	      u32 __user *uaddr2,
 	      int nr_wake, int nr_wake2, int op)
 {
 	union futex_key key1, key2;
@@ -946,12 +996,13 @@ futex_wake_op(u32 __user *uaddr1, u32 __
 	int ret, op_ret, attempt =3D 0;
=20
 retryfull:
-	down_read(&current->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
=20
-	ret =3D get_futex_key(uaddr1, &key1);
+	ret =3D get_futex_key(uaddr1, fshared, &key1);
 	if (unlikely(ret !=3D 0))
 		goto out;
-	ret =3D get_futex_key(uaddr2, &key2);
+	ret =3D get_futex_key(uaddr2, fshared, &key2);
 	if (unlikely(ret !=3D 0))
 		goto out;
=20
@@ -991,11 +1042,10 @@ retry:
 		 * still holding the mmap_sem.
 		 */
 		if (attempt++) {
-			if (futex_handle_fault((unsigned long)uaddr2,
-						attempt)) {
-				ret =3D -EFAULT;
+			ret =3D futex_handle_fault((unsigned long)uaddr2,
+						fshared, attempt);
+			if (ret)
 				goto out;
-			}
 			goto retry;
 		}
=20
@@ -1003,7 +1053,8 @@ retry:
 		 * If we would have faulted, release mmap_sem,
 		 * fault it in and start all over again.
 		 */
-		up_read(&current->mm->mmap_sem);
+		if (fshared)
+			up_read(fshared);
=20
 		ret =3D get_user(dummy, uaddr2);
 		if (ret)
@@ -1040,7 +1091,8 @@ retry:
 	if (hb1 !=3D hb2)
 		spin_unlock(&hb2->lock);
 out:
-	up_read(&current->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 	return ret;
 }
=20
@@ -1048,7 +1100,8 @@ out:
  * Requeue all waiters hashed on one physical page to another
  * physical page.
  */
-static int futex_requeue(u32 __user *uaddr1, u32 __user *uaddr2,
+static int futex_requeue(u32 __user *uaddr1, struct rw_semaphore *fsha=
red,
+			 u32 __user *uaddr2,
 			 int nr_wake, int nr_requeue, u32 *cmpval)
 {
 	union futex_key key1, key2;
@@ -1058,12 +1111,13 @@ static int futex_requeue(u32 __user *uad
 	int ret, drop_count =3D 0;
=20
  retry:
-	down_read(&current->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
=20
-	ret =3D get_futex_key(uaddr1, &key1);
+	ret =3D get_futex_key(uaddr1, fshared, &key1);
 	if (unlikely(ret !=3D 0))
 		goto out;
-	ret =3D get_futex_key(uaddr2, &key2);
+	ret =3D get_futex_key(uaddr2, fshared, &key2);
 	if (unlikely(ret !=3D 0))
 		goto out;
=20
@@ -1086,7 +1140,8 @@ static int futex_requeue(u32 __user *uad
 			 * If we would have faulted, release mmap_sem, fault
 			 * it in and start all over again.
 			 */
-			up_read(&current->mm->mmap_sem);
+			if (fshared)
+				up_read(fshared);
=20
 			ret =3D get_user(curval, uaddr1);
=20
@@ -1139,7 +1194,8 @@ out_unlock:
 		drop_futex_key_refs(&key1);
=20
 out:
-	up_read(&current->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 	return ret;
 }
=20
@@ -1273,7 +1329,8 @@ static void unqueue_me_pi(struct futex_q
  * The cur->mm semaphore must be  held, it is released at return of th=
is
  * function.
  */
-static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
+static int fixup_pi_state_owner(u32 __user *uaddr, struct rw_semaphore=
 *fshared,
+				struct futex_q *q,
 				struct futex_hash_bucket *hb,
 				struct task_struct *curr)
 {
@@ -1300,7 +1357,8 @@ static int fixup_pi_state_owner(u32 __us
=20
 	/* Unqueue and drop the lock */
 	unqueue_me_pi(q);
-	up_read(&curr->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 	/*
 	 * We own it, so we have to replace the pending owner
 	 * TID. This must be atomic as we have preserve the
@@ -1321,8 +1379,15 @@ static int fixup_pi_state_owner(u32 __us
 	return ret;
 }
=20
+/*
+ * In case we must use restart_block to restart a futex_wait,
+ * we encode in the 'arg3' shared capability
+ */
+#define ARG3_SHARED  1
+
 static long futex_wait_restart(struct restart_block *restart);
-static int futex_wait(u32 __user *uaddr, u32 val, ktime_t *abs_time)
+static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
+		      u32 val, ktime_t *abs_time)
 {
 	struct task_struct *curr =3D current;
 	DECLARE_WAITQUEUE(wait, curr);
@@ -1335,9 +1400,10 @@ static int futex_wait(u32 __user *uaddr,
=20
 	q.pi_state =3D NULL;
  retry:
-	down_read(&curr->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
=20
-	ret =3D get_futex_key(uaddr, &q.key);
+	ret =3D get_futex_key(uaddr, fshared, &q.key);
 	if (unlikely(ret !=3D 0))
 		goto out_release_sem;
=20
@@ -1360,8 +1426,8 @@ static int futex_wait(u32 __user *uaddr,
 	 * a wakeup when *uaddr !=3D val on entry to the syscall.  This is
 	 * rare, but normal.
 	 *
-	 * We hold the mmap semaphore, so the mapping cannot have changed
-	 * since we looked it up in get_futex_key.
+	 * for shared futexes, we hold the mmap semaphore, so the mapping
+	 * cannot have changed since we looked it up in get_futex_key.
 	 */
 	ret =3D get_futex_value_locked(&uval, uaddr);
=20
@@ -1372,7 +1438,8 @@ static int futex_wait(u32 __user *uaddr,
 		 * If we would have faulted, release mmap_sem, fault it in and
 		 * start all over again.
 		 */
-		up_read(&curr->mm->mmap_sem);
+		if (fshared)
+			up_read(fshared);
=20
 		ret =3D get_user(uval, uaddr);
=20
@@ -1399,7 +1466,8 @@ static int futex_wait(u32 __user *uaddr,
 	 * Now the futex is queued and we have checked the data, we
 	 * don't want to hold mmap_sem while we sleep.
 	 */
-	up_read(&curr->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
=20
 	/*
 	 * There might have been scheduling since the queue_me(), as we
@@ -1469,7 +1537,8 @@ static int futex_wait(u32 __user *uaddr,
 		else
 			ret =3D rt_mutex_timed_lock(lock, to, 1);
=20
-		down_read(&curr->mm->mmap_sem);
+		if (fshared)
+			down_read(fshared);
 		spin_lock(q.lock_ptr);
=20
 		/*
@@ -1486,7 +1555,8 @@ static int futex_wait(u32 __user *uaddr,
=20
 			/* mmap_sem and hash_bucket lock are unlocked at
 			   return of this function */
-			ret =3D fixup_pi_state_owner(uaddr, &q, hb, curr);
+			ret =3D fixup_pi_state_owner(uaddr, fshared,
+						   &q, hb, curr);
 		} else {
 			/*
 			 * Catch the rare case, where the lock was released
@@ -1499,7 +1569,8 @@ static int futex_wait(u32 __user *uaddr,
 			}
 			/* Unqueue and drop the lock */
 			unqueue_me_pi(&q);
-			up_read(&curr->mm->mmap_sem);
+			if (fshared)
+				up_read(fshared);
 		}
=20
 		debug_rt_mutex_free_waiter(&q.waiter);
@@ -1528,6 +1599,9 @@ static int futex_wait(u32 __user *uaddr,
 		restart->arg0 =3D (unsigned long)uaddr;
 		restart->arg1 =3D (unsigned long)val;
 		restart->arg2 =3D (unsigned long)abs_time;
+		restart->arg3 =3D 0;
+		if (fshared)
+			restart->arg3 |=3D ARG3_SHARED;
 		return -ERESTART_RESTARTBLOCK;
 	}
=20
@@ -1535,7 +1609,8 @@ static int futex_wait(u32 __user *uaddr,
 	queue_unlock(&q, hb);
=20
  out_release_sem:
-	up_read(&curr->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 	return ret;
 }
=20
@@ -1545,9 +1620,12 @@ static long futex_wait_restart(struct re
 	u32 __user *uaddr =3D (u32 __user *)restart->arg0;
 	u32 val =3D (u32)restart->arg1;
 	ktime_t *abs_time =3D (ktime_t *)restart->arg2;
+	struct rw_semaphore *fshared =3D NULL;
=20
 	restart->fn =3D do_no_restart_syscall;
-	return (long)futex_wait(uaddr, val, abs_time);
+	if (restart->arg3 & ARG3_SHARED)
+		fshared =3D &current->mm->mmap_sem;
+	return (long)futex_wait(uaddr, fshared, val, abs_time);
 }
=20
=20
@@ -1602,8 +1680,8 @@ static void set_pi_futex_owner(struct fu
  * if there are waiters then it will block, it does PI, etc. (Due to
  * races the kernel might see a 0 value of the futex too.)
  */
-static int futex_lock_pi(u32 __user *uaddr, int detect, ktime_t *time,
-			 int trylock)
+static int futex_lock_pi(u32 __user *uaddr, struct rw_semaphore *fshar=
ed,
+			 int detect, ktime_t *time, int trylock)
 {
 	struct hrtimer_sleeper timeout, *to =3D NULL;
 	struct task_struct *curr =3D current;
@@ -1624,9 +1702,10 @@ static int futex_lock_pi(u32 __user *uad
=20
 	q.pi_state =3D NULL;
  retry:
-	down_read(&curr->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
=20
-	ret =3D get_futex_key(uaddr, &q.key);
+	ret =3D get_futex_key(uaddr, fshared, &q.key);
 	if (unlikely(ret !=3D 0))
 		goto out_release_sem;
=20
@@ -1747,7 +1826,8 @@ static int futex_lock_pi(u32 __user *uad
 	 * Now the futex is queued and we have checked the data, we
 	 * don't want to hold mmap_sem while we sleep.
 	 */
-	up_read(&curr->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
=20
 	WARN_ON(!q.pi_state);
 	/*
@@ -1761,7 +1841,8 @@ static int futex_lock_pi(u32 __user *uad
 		ret =3D ret ? 0 : -EWOULDBLOCK;
 	}
=20
-	down_read(&curr->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
 	spin_lock(q.lock_ptr);
=20
 	/*
@@ -1770,7 +1851,7 @@ static int futex_lock_pi(u32 __user *uad
 	 */
 	if (!ret && q.pi_state->owner !=3D curr)
 		/* mmap_sem is unlocked at return of this function */
-		ret =3D fixup_pi_state_owner(uaddr, &q, hb, curr);
+		ret =3D fixup_pi_state_owner(uaddr, fshared, &q, hb, curr);
 	else {
 		/*
 		 * Catch the rare case, where the lock was released
@@ -1783,7 +1864,8 @@ static int futex_lock_pi(u32 __user *uad
 		}
 		/* Unqueue and drop the lock */
 		unqueue_me_pi(&q);
-		up_read(&curr->mm->mmap_sem);
+		if (fshared)
+			up_read(fshared);
 	}
=20
 	if (!detect && ret =3D=3D -EDEADLK && 0)
@@ -1795,7 +1877,8 @@ static int futex_lock_pi(u32 __user *uad
 	queue_unlock(&q, hb);
=20
  out_release_sem:
-	up_read(&curr->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
 	return ret;
=20
  uaddr_faulted:
@@ -1806,15 +1889,16 @@ static int futex_lock_pi(u32 __user *uad
 	 * still holding the mmap_sem.
 	 */
 	if (attempt++) {
-		if (futex_handle_fault((unsigned long)uaddr, attempt)) {
-			ret =3D -EFAULT;
+		ret =3D futex_handle_fault((unsigned long)uaddr, fshared,
+					 attempt);
+		if (ret)
 			goto out_unlock_release_sem;
-		}
 		goto retry_locked;
 	}
=20
 	queue_unlock(&q, hb);
-	up_read(&curr->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
=20
 	ret =3D get_user(uval, uaddr);
 	if (!ret && (uval !=3D -EFAULT))
@@ -1828,7 +1912,7 @@ static int futex_lock_pi(u32 __user *uad
  * This is the in-kernel slowpath: we look up the PI state (if any),
  * and do the rt-mutex unlock.
  */
-static int futex_unlock_pi(u32 __user *uaddr)
+static int futex_unlock_pi(u32 __user *uaddr, struct rw_semaphore *fsh=
ared)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
@@ -1848,9 +1932,10 @@ retry:
 	/*
 	 * First take all the futex related locks:
 	 */
-	down_read(&current->mm->mmap_sem);
+	if (fshared)
+		down_read(fshared);
=20
-	ret =3D get_futex_key(uaddr, &key);
+	ret =3D get_futex_key(uaddr, fshared, &key);
 	if (unlikely(ret !=3D 0))
 		goto out;
=20
@@ -1909,7 +1994,8 @@ retry_locked:
 out_unlock:
 	spin_unlock(&hb->lock);
 out:
-	up_read(&current->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
=20
 	return ret;
=20
@@ -1921,15 +2007,16 @@ pi_faulted:
 	 * still holding the mmap_sem.
 	 */
 	if (attempt++) {
-		if (futex_handle_fault((unsigned long)uaddr, attempt)) {
-			ret =3D -EFAULT;
+		ret =3D futex_handle_fault((unsigned long)uaddr, fshared,
+					 attempt);
+		if (ret)
 			goto out_unlock;
-		}
 		goto retry_locked;
 	}
=20
 	spin_unlock(&hb->lock);
-	up_read(&current->mm->mmap_sem);
+	if (fshared)
+		up_read(fshared);
=20
 	ret =3D get_user(uval, uaddr);
 	if (!ret && (uval !=3D -EFAULT))
@@ -1981,6 +2068,7 @@ static int futex_fd(u32 __user *uaddr, i
 	struct futex_q *q;
 	struct file *filp;
 	int ret, err;
+	struct rw_semaphore *fshared;
 	static unsigned long printk_interval;
=20
 	if (printk_timed_ratelimit(&printk_interval, 60 * 60 * 1000)) {
@@ -2022,11 +2110,12 @@ static int futex_fd(u32 __user *uaddr, i
 	}
 	q->pi_state =3D NULL;
=20
-	down_read(&current->mm->mmap_sem);
-	err =3D get_futex_key(uaddr, &q->key);
+	fshared =3D &current->mm->mmap_sem;
+	down_read(fshared);
+	err =3D get_futex_key(uaddr, fshared, &q->key);
=20
 	if (unlikely(err !=3D 0)) {
-		up_read(&current->mm->mmap_sem);
+		up_read(fshared);
 		kfree(q);
 		goto error;
 	}
@@ -2038,7 +2127,7 @@ static int futex_fd(u32 __user *uaddr, i
 	filp->private_data =3D q;
=20
 	queue_me(q, ret, filp);
-	up_read(&current->mm->mmap_sem);
+	up_read(fshared);
=20
 	/* Now we map fd to filp, so userspace can access it */
 	fd_install(ret, filp);
@@ -2167,7 +2256,7 @@ retry:
 		 */
 		if (!pi) {
 			if (uval & FUTEX_WAITERS)
-				futex_wake(uaddr, 1);
+				futex_wake(uaddr, &curr->mm->mmap_sem, 1);
 		}
 	}
 	return 0;
@@ -2223,7 +2312,8 @@ void exit_robust_list(struct task_struct
 		return;
=20
 	if (pending)
-		handle_futex_death((void __user *)pending + futex_offset, curr, pip)=
;
+		handle_futex_death((void __user *)pending + futex_offset,
+				   curr, pip);
=20
 	while (entry !=3D &head->list) {
 		/*
@@ -2253,38 +2343,43 @@ long do_futex(u32 __user *uaddr, int op,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {
 	int ret;
+	int cmd =3D op & FUTEX_CMD_MASK;
+	struct rw_semaphore *fshared =3D NULL;
+
+	if (!(op & FUTEX_PRIVATE_FLAG))
+		fshared =3D &current->mm->mmap_sem;
=20
-	switch (op) {
+	switch (cmd) {
 	case FUTEX_WAIT:
-		ret =3D futex_wait(uaddr, val, timeout);
+		ret =3D futex_wait(uaddr, fshared, val, timeout);
 		break;
 	case FUTEX_WAKE:
-		ret =3D futex_wake(uaddr, val);
+		ret =3D futex_wake(uaddr, fshared, val);
 		break;
 	case FUTEX_FD:
 		/* non-zero val means F_SETOWN(getpid()) & F_SETSIG(val) */
 		ret =3D futex_fd(uaddr, val);
 		break;
 	case FUTEX_REQUEUE:
-		ret =3D futex_requeue(uaddr, uaddr2, val, val2, NULL);
+		ret =3D futex_requeue(uaddr, fshared, uaddr2, val, val2, NULL);
 		break;
 	case FUTEX_CMP_REQUEUE:
-		ret =3D futex_requeue(uaddr, uaddr2, val, val2, &val3);
+		ret =3D futex_requeue(uaddr, fshared, uaddr2, val, val2, &val3);
 		break;
 	case FUTEX_WAKE_OP:
-		ret =3D futex_wake_op(uaddr, uaddr2, val, val2, val3);
+		ret =3D futex_wake_op(uaddr, fshared, uaddr2, val, val2, val3);
 		break;
 	case FUTEX_LOCK_PI:
-		ret =3D futex_lock_pi(uaddr, val, timeout, 0);
+		ret =3D futex_lock_pi(uaddr, fshared, val, timeout, 0);
 		break;
 	case FUTEX_UNLOCK_PI:
-		ret =3D futex_unlock_pi(uaddr);
+		ret =3D futex_unlock_pi(uaddr, fshared);
 		break;
 	case FUTEX_TRYLOCK_PI:
-		ret =3D futex_lock_pi(uaddr, 0, timeout, 1);
+		ret =3D futex_lock_pi(uaddr, fshared, 0, timeout, 1);
 		break;
 	case FUTEX_CMP_REQUEUE_PI:
-		ret =3D futex_requeue_pi(uaddr, uaddr2, val, val2, &val3);
+		ret =3D futex_requeue_pi(uaddr, fshared, uaddr2, val, val2, &val3);
 		break;
 	default:
 		ret =3D -ENOSYS;
@@ -2300,23 +2395,24 @@ asmlinkage long sys_futex(u32 __user *ua
 	struct timespec ts;
 	ktime_t t, *tp =3D NULL;
 	u32 val2 =3D 0;
+	int cmd =3D op & FUTEX_CMD_MASK;
=20
-	if (utime && (op =3D=3D FUTEX_WAIT || op =3D=3D FUTEX_LOCK_PI)) {
+	if (utime && (cmd =3D=3D FUTEX_WAIT || cmd =3D=3D FUTEX_LOCK_PI)) {
 		if (copy_from_user(&ts, utime, sizeof(ts)) !=3D 0)
 			return -EFAULT;
 		if (!timespec_valid(&ts))
 			return -EINVAL;
=20
 		t =3D timespec_to_ktime(ts);
-		if (op =3D=3D FUTEX_WAIT)
+		if (cmd =3D=3D FUTEX_WAIT)
 			t =3D ktime_add(ktime_get(), t);
 		tp =3D &t;
 	}
 	/*
-	 * requeue parameter in 'utime' if op =3D=3D FUTEX_REQUEUE.
+	 * requeue parameter in 'utime' if cmd =3D=3D FUTEX_REQUEUE.
 	 */
-	if (op =3D=3D FUTEX_REQUEUE || op =3D=3D FUTEX_CMP_REQUEUE
-	    || op =3D=3D FUTEX_CMP_REQUEUE_PI)
+	if (cmd =3D=3D FUTEX_REQUEUE || cmd =3D=3D FUTEX_CMP_REQUEUE
+	    || cmd =3D=3D FUTEX_CMP_REQUEUE_PI)
 		val2 =3D (u32) (unsigned long) utime;
=20
 	return do_futex(uaddr, op, val, tp, uaddr2, val2, val3);
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

origin.patch
getrusage-fill-ru_inblock-and-ru_oublock-fields-if-possible.patch
lguest-the-host-code.patch
