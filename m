From: akpm@linux-foundation.org
Subject: + ipc-standardize-code-comments.patch added to -mm tree
Date: Fri, 10 Jan 2014 15:19:29 -0800
Message-ID: <52d08001.QaNZSoZl2IVO+aKg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33541 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaAJXTa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 10 Jan 2014 18:19:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, manfred@colorfullife.com, aswin@hp.com, davidlohr@hp.com

Subject: + ipc-standardize-code-comments.patch added to -mm tree
To: davidlohr@hp.com,aswin@hp.com,manfred@colorfullife.com,riel@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 10 Jan 2014 15:19:29 -0800


The patch titled
     Subject: ipc: standardize code comments
has been added to the -mm tree.  Its filename is
     ipc-standardize-code-comments.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-standardize-code-comments.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-standardize-code-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: ipc: standardize code comments

IPC commenting style is all over the place, *specially* in util.c.  This
patch orders things a bit.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c  |   24 ++---
 ipc/shm.c  |    1 
 ipc/util.c |  239 ++++++++++++++++++++++++---------------------------
 3 files changed, 125 insertions(+), 139 deletions(-)

diff -puN ipc/sem.c~ipc-standardize-code-comments ipc/sem.c
--- a/ipc/sem.c~ipc-standardize-code-comments
+++ a/ipc/sem.c
@@ -225,7 +225,7 @@ static void unmerge_queues(struct sem_ar
 }
 
 /**
- * merge_queues - Merge single semop queues into global queue
+ * merge_queues - merge single semop queues into global queue
  * @sma: semaphore array
  *
  * This function merges all per-semaphore queues into the global queue.
@@ -474,7 +474,6 @@ static inline void sem_rmid(struct ipc_n
  *
  * Called with sem_ids.rwsem held (as a writer)
  */
-
 static int newary(struct ipc_namespace *ns, struct ipc_params *params)
 {
 	int id;
@@ -682,7 +681,7 @@ static void wake_up_sem_queue_prepare(st
 }
 
 /**
- * wake_up_sem_queue_do(pt) - do the actual wake-up
+ * wake_up_sem_queue_do - do the actual wake-up
  * @pt: list of tasks to be woken up
  *
  * Do the actual wake-up.
@@ -748,7 +747,7 @@ static int check_restart(struct sem_arra
 }
 
 /**
- * wake_const_ops(sma, semnum, pt) - Wake up non-alter tasks
+ * wake_const_ops - wake up non-alter tasks
  * @sma: semaphore array.
  * @semnum: semaphore that was modified.
  * @pt: list head for the tasks that must be woken up.
@@ -798,15 +797,14 @@ static int wake_const_ops(struct sem_arr
 }
 
 /**
- * do_smart_wakeup_zero(sma, sops, nsops, pt) - wakeup all wait for zero tasks
+ * do_smart_wakeup_zero - wakeup all wait for zero tasks
  * @sma: semaphore array
  * @sops: operations that were performed
  * @nsops: number of operations
  * @pt: list head of the tasks that must be woken up.
  *
- * do_smart_wakeup_zero() checks all required queue for wait-for-zero
- * operations, based on the actual changes that were performed on the
- * semaphore array.
+ * Checks all required queue for wait-for-zero operations, based
+ * on the actual changes that were performed on the semaphore array.
  * The function returns 1 if at least one operation was completed successfully.
  */
 static int do_smart_wakeup_zero(struct sem_array *sma, struct sembuf *sops,
@@ -850,7 +848,7 @@ static int do_smart_wakeup_zero(struct s
 
 
 /**
- * update_queue(sma, semnum): Look for tasks that can be completed.
+ * update_queue - look for tasks that can be completed.
  * @sma: semaphore array.
  * @semnum: semaphore that was modified.
  * @pt: list head for the tasks that must be woken up.
@@ -920,7 +918,7 @@ again:
 }
 
 /**
- * set_semotime(sma, sops) - set sem_otime
+ * set_semotime - set sem_otime
  * @sma: semaphore array
  * @sops: operations that modified the array, may be NULL
  *
@@ -938,7 +936,7 @@ static void set_semotime(struct sem_arra
 }
 
 /**
- * do_smart_update(sma, sops, nsops, otime, pt) - optimized update_queue
+ * do_smart_update - optimized update_queue
  * @sma: semaphore array
  * @sops: operations that were performed
  * @nsops: number of operations
@@ -1647,7 +1645,7 @@ static struct sem_undo *lookup_undo(stru
 }
 
 /**
- * find_alloc_undo - Lookup (and if not present create) undo array
+ * find_alloc_undo - lookup (and if not present create) undo array
  * @ns: namespace
  * @semid: semaphore array id
  *
@@ -1737,7 +1735,7 @@ out:
 
 
 /**
- * get_queue_result - Retrieve the result code from sem_queue
+ * get_queue_result - retrieve the result code from sem_queue
  * @q: Pointer to queue structure
  *
  * Retrieve the return code from the pending queue. If IN_WAKEUP is found in
diff -puN ipc/shm.c~ipc-standardize-code-comments ipc/shm.c
--- a/ipc/shm.c~ipc-standardize-code-comments
+++ a/ipc/shm.c
@@ -477,7 +477,6 @@ static const struct vm_operations_struct
  *
  * Called with shm_ids.rwsem held as a writer.
  */
-
 static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
 {
 	key_t key = params->key;
diff -puN ipc/util.c~ipc-standardize-code-comments ipc/util.c
--- a/ipc/util.c~ipc-standardize-code-comments
+++ a/ipc/util.c
@@ -110,15 +110,15 @@ static struct notifier_block ipc_memory_
 };
 
 /**
- *	ipc_init	-	initialise IPC subsystem
+ * ipc_init - initialise ipc subsystem
  *
- *	The various system5 IPC resources (semaphores, messages and shared
- *	memory) are initialised
- *	A callback routine is registered into the memory hotplug notifier
- *	chain: since msgmni scales to lowmem this callback routine will be
- *	called upon successful memory add / remove to recompute msmgni.
+ * The various sysv ipc resources (semaphores, messages and shared
+ * memory) are initialised.
+ *
+ * A callback routine is registered into the memory hotplug notifier
+ * chain: since msgmni scales to lowmem this callback routine will be
+ * called upon successful memory add / remove to recompute msmgni.
  */
- 
 static int __init ipc_init(void)
 {
 	sem_init();
@@ -131,13 +131,12 @@ static int __init ipc_init(void)
 __initcall(ipc_init);
 
 /**
- *	ipc_init_ids		-	initialise IPC identifiers
- *	@ids: Identifier set
+ * ipc_init_ids	- initialise ipc identifiers
+ * @ids: ipc identifier set
  *
- *	Set up the sequence range to use for the ipc identifier range (limited
- *	below IPCMNI) then initialise the ids idr.
+ * Set up the sequence range to use for the ipc identifier range (limited
+ * below IPCMNI) then initialise the ids idr.
  */
- 
 void ipc_init_ids(struct ipc_ids *ids)
 {
 	init_rwsem(&ids->rwsem);
@@ -159,11 +158,11 @@ void ipc_init_ids(struct ipc_ids *ids)
 #ifdef CONFIG_PROC_FS
 static const struct file_operations sysvipc_proc_fops;
 /**
- *	ipc_init_proc_interface	-  Create a proc interface for sysipc types using a seq_file interface.
- *	@path: Path in procfs
- *	@header: Banner to be printed at the beginning of the file.
- *	@ids: ipc id table to iterate.
- *	@show: show routine.
+ * ipc_init_proc_interface -  create a proc interface for sysipc types using a seq_file interface.
+ * @path: Path in procfs
+ * @header: Banner to be printed at the beginning of the file.
+ * @ids: ipc id table to iterate.
+ * @show: show routine.
  */
 void __init ipc_init_proc_interface(const char *path, const char *header,
 		int ids, int (*show)(struct seq_file *, void *))
@@ -191,16 +190,15 @@ void __init ipc_init_proc_interface(cons
 #endif
 
 /**
- *	ipc_findkey	-	find a key in an ipc identifier set	
- *	@ids: Identifier set
- *	@key: The key to find
+ * ipc_findkey	- find a key in an ipc identifier set
+ * @ids: ipc identifier set
+ * @key: key to find
  *	
- *	Requires ipc_ids.rwsem locked.
- *	Returns the LOCKED pointer to the ipc structure if found or NULL
- *	if not.
- *	If key is found ipc points to the owning ipc structure
+ * Returns the locked pointer to the ipc structure if found or NULL
+ * otherwise. If key is found ipc points to the owning ipc structure
+ *
+ * Called with ipc_ids.rwsem held.
  */
- 
 static struct kern_ipc_perm *ipc_findkey(struct ipc_ids *ids, key_t key)
 {
 	struct kern_ipc_perm *ipc;
@@ -227,12 +225,11 @@ static struct kern_ipc_perm *ipc_findkey
 }
 
 /**
- *	ipc_get_maxid	-	get the last assigned id
- *	@ids: IPC identifier set
+ * ipc_get_maxid - get the last assigned id
+ * @ids: ipc identifier set
  *
- *	Called with ipc_ids.rwsem held.
+ * Called with ipc_ids.rwsem held.
  */
-
 int ipc_get_maxid(struct ipc_ids *ids)
 {
 	struct kern_ipc_perm *ipc;
@@ -258,17 +255,17 @@ int ipc_get_maxid(struct ipc_ids *ids)
 }
 
 /**
- *	ipc_addid	-	add an IPC identifier
- *	@ids: IPC identifier set
- *	@new: new IPC permission set
- *	@size: limit for the number of used ids
- *
- *	Add an entry 'new' to the IPC ids idr. The permissions object is
- *	initialised and the first free entry is set up and the id assigned
- *	is returned. The 'new' entry is returned in a locked state on success.
- *	On failure the entry is not locked and a negative err-code is returned.
+ * ipc_addid - add an ipc identifier
+ * @ids: ipc identifier set
+ * @new: new ipc permission set
+ * @size: limit for the number of used ids
  *
- *	Called with writer ipc_ids.rwsem held.
+ * Add an entry 'new' to the ipc ids idr. The permissions object is
+ * initialised and the first free entry is set up and the id assigned
+ * is returned. The 'new' entry is returned in a locked state on success.
+ * On failure the entry is not locked and a negative err-code is returned.
+ *
+ * Called with writer ipc_ids.rwsem held.
  */
 int ipc_addid(struct ipc_ids *ids, struct kern_ipc_perm *new, int size)
 {
@@ -320,14 +317,14 @@ int ipc_addid(struct ipc_ids *ids, struc
 }
 
 /**
- *	ipcget_new	-	create a new ipc object
- *	@ns: namespace
- *	@ids: IPC identifer set
- *	@ops: the actual creation routine to call
- *	@params: its parameters
+ * ipcget_new -	create a new ipc object
+ * @ns: ipc namespace
+ * @ids: ipc identifer set
+ * @ops: the actual creation routine to call
+ * @params: its parameters
  *
- *	This routine is called by sys_msgget, sys_semget() and sys_shmget()
- *	when the key is IPC_PRIVATE.
+ * This routine is called by sys_msgget, sys_semget() and sys_shmget()
+ * when the key is IPC_PRIVATE.
  */
 static int ipcget_new(struct ipc_namespace *ns, struct ipc_ids *ids,
 		struct ipc_ops *ops, struct ipc_params *params)
@@ -341,19 +338,19 @@ static int ipcget_new(struct ipc_namespa
 }
 
 /**
- *	ipc_check_perms	-	check security and permissions for an IPC
- *	@ns: IPC namespace
- *	@ipcp: ipc permission set
- *	@ops: the actual security routine to call
- *	@params: its parameters
- *
- *	This routine is called by sys_msgget(), sys_semget() and sys_shmget()
- *      when the key is not IPC_PRIVATE and that key already exists in the
- *      ids IDR.
+ * ipc_check_perms - check security and permissions for an ipc object
+ * @ns: ipc namespace
+ * @ipcp: ipc permission set
+ * @ops: the actual security routine to call
+ * @params: its parameters
+ *
+ * This routine is called by sys_msgget(), sys_semget() and sys_shmget()
+ * when the key is not IPC_PRIVATE and that key already exists in the
+ * ds IDR.
  *
- *	On success, the IPC id is returned.
+ * On success, the ipc id is returned.
  *
- *	It is called with ipc_ids.rwsem and ipcp->lock held.
+ * It is called with ipc_ids.rwsem and ipcp->lock held.
  */
 static int ipc_check_perms(struct ipc_namespace *ns,
 			   struct kern_ipc_perm *ipcp,
@@ -374,18 +371,18 @@ static int ipc_check_perms(struct ipc_na
 }
 
 /**
- *	ipcget_public	-	get an ipc object or create a new one
- *	@ns: namespace
- *	@ids: IPC identifer set
- *	@ops: the actual creation routine to call
- *	@params: its parameters
- *
- *	This routine is called by sys_msgget, sys_semget() and sys_shmget()
- *	when the key is not IPC_PRIVATE.
- *	It adds a new entry if the key is not found and does some permission
- *      / security checkings if the key is found.
+ * ipcget_public - get an ipc object or create a new one
+ * @ns: ipc namespace
+ * @ids: ipc identifer set
+ * @ops: the actual creation routine to call
+ * @params: its parameters
+ *
+ * This routine is called by sys_msgget, sys_semget() and sys_shmget()
+ * when the key is not IPC_PRIVATE.
+ * It adds a new entry if the key is not found and does some permission
+ * / security checkings if the key is found.
  *
- *	On success, the ipc id is returned.
+ * On success, the ipc id is returned.
  */
 static int ipcget_public(struct ipc_namespace *ns, struct ipc_ids *ids,
 		struct ipc_ops *ops, struct ipc_params *params)
@@ -431,14 +428,13 @@ static int ipcget_public(struct ipc_name
 
 
 /**
- *	ipc_rmid	-	remove an IPC identifier
- *	@ids: IPC identifier set
- *	@ipcp: ipc perm structure containing the identifier to remove
+ * ipc_rmid - remove an ipc identifier
+ * @ids: ipc identifier set
+ * @ipcp: ipc perm structure containing the identifier to remove
  *
- *	ipc_ids.rwsem (as a writer) and the spinlock for this ID are held
- *	before this function is called, and remain locked on the exit.
+ * ipc_ids.rwsem (as a writer) and the spinlock for this ID are held
+ * before this function is called, and remain locked on the exit.
  */
- 
 void ipc_rmid(struct ipc_ids *ids, struct kern_ipc_perm *ipcp)
 {
 	int lid = ipcid_to_idx(ipcp->id);
@@ -453,13 +449,12 @@ void ipc_rmid(struct ipc_ids *ids, struc
 }
 
 /**
- *	ipc_alloc	-	allocate ipc space
- *	@size: size desired
+ * ipc_alloc -	allocate ipc space
+ * @size: size desired
  *
- *	Allocate memory from the appropriate pools and return a pointer to it.
- *	NULL is returned if the allocation fails
+ * Allocate memory from the appropriate pools and return a pointer to it.
+ * NULL is returned if the allocation fails
  */
- 
 void *ipc_alloc(int size)
 {
 	void *out;
@@ -471,14 +466,13 @@ void *ipc_alloc(int size)
 }
 
 /**
- *	ipc_free        -       free ipc space
- *	@ptr: pointer returned by ipc_alloc
- *	@size: size of block
+ * ipc_free - free ipc space
+ * @ptr: pointer returned by ipc_alloc
+ * @size: size of block
  *
- *	Free a block created with ipc_alloc(). The caller must know the size
- *	used in the allocation call.
+ * Free a block created with ipc_alloc(). The caller must know the size
+ * used in the allocation call.
  */
-
 void ipc_free(void *ptr, int size)
 {
 	if (size > PAGE_SIZE)
@@ -488,11 +482,11 @@ void ipc_free(void *ptr, int size)
 }
 
 /**
- *	ipc_rcu_alloc	-	allocate ipc and rcu space 
- *	@size: size desired
+ * ipc_rcu_alloc - allocate ipc and rcu space
+ * @size: size desired
  *
- *	Allocate memory for the rcu header structure +  the object.
- *	Returns the pointer to the object or NULL upon failure.
+ * Allocate memory for the rcu header structure +  the object.
+ * Returns the pointer to the object or NULL upon failure.
  */
 void *ipc_rcu_alloc(int size)
 {
@@ -534,17 +528,16 @@ void ipc_rcu_free(struct rcu_head *head)
 }
 
 /**
- *	ipcperms	-	check IPC permissions
- *	@ns: IPC namespace
- *	@ipcp: IPC permission set
- *	@flag: desired permission set.
+ * ipcperms - check ipc permissions
+ * @ns: ipc namespace
+ * @ipcp: ipc permission set
+ * @flag: desired permission set
  *
- *	Check user, group, other permissions for access
- *	to ipc resources. return 0 if allowed
+ * Check user, group, other permissions for access
+ * to ipc resources. return 0 if allowed
  *
- *	@flag will most probably be 0 or S_...UGO from <linux/stat.h>
+ * @flag will most probably be 0 or S_...UGO from <linux/stat.h>
  */
- 
 int ipcperms(struct ipc_namespace *ns, struct kern_ipc_perm *ipcp, short flag)
 {
 	kuid_t euid = current_euid();
@@ -572,15 +565,13 @@ int ipcperms(struct ipc_namespace *ns, s
  */
 
 /**
- *	kernel_to_ipc64_perm	-	convert kernel ipc permissions to user
- *	@in: kernel permissions
- *	@out: new style IPC permissions
+ * kernel_to_ipc64_perm	- convert kernel ipc permissions to user
+ * @in: kernel permissions
+ * @out: new style ipc permissions
  *
- *	Turn the kernel object @in into a set of permissions descriptions
- *	for returning to userspace (@out).
+ * Turn the kernel object @in into a set of permissions descriptions
+ * for returning to userspace (@out).
  */
- 
-
 void kernel_to_ipc64_perm(struct kern_ipc_perm *in, struct ipc64_perm *out)
 {
 	out->key	= in->key;
@@ -593,14 +584,13 @@ void kernel_to_ipc64_perm(struct kern_ip
 }
 
 /**
- *	ipc64_perm_to_ipc_perm	-	convert new ipc permissions to old
- *	@in: new style IPC permissions
- *	@out: old style IPC permissions
+ * ipc64_perm_to_ipc_perm - convert new ipc permissions to old
+ * @in: new style ipc permissions
+ * @out: old style ipc permissions
  *
- *	Turn the new style permissions object @in into a compatibility
- *	object and store it into the @out pointer.
+ * Turn the new style permissions object @in into a compatibility
+ * object and store it into the @out pointer.
  */
- 
 void ipc64_perm_to_ipc_perm(struct ipc64_perm *in, struct ipc_perm *out)
 {
 	out->key	= in->key;
@@ -635,8 +625,8 @@ struct kern_ipc_perm *ipc_obtain_object(
 }
 
 /**
- * ipc_lock - Lock an ipc structure without rwsem held
- * @ids: IPC identifier set
+ * ipc_lock - lock an ipc structure without rwsem held
+ * @ids: ipc identifier set
  * @id: ipc id to look for
  *
  * Look for an id in the ipc ids idr and lock the associated ipc object.
@@ -693,11 +683,11 @@ out:
 
 /**
  * ipcget - Common sys_*get() code
- * @ns : namsepace
- * @ids : IPC identifier set
- * @ops : operations to be called on ipc object creation, permission checks
- *        and further checks
- * @params : the parameters needed by the previous operations.
+ * @ns: namsepace
+ * @ids: ipc identifier set
+ * @ops: operations to be called on ipc object creation, permission checks
+ *       and further checks
+ * @params: the parameters needed by the previous operations.
  *
  * Common routine called by sys_msgget(), sys_semget() and sys_shmget().
  */
@@ -711,7 +701,7 @@ int ipcget(struct ipc_namespace *ns, str
 }
 
 /**
- * ipc_update_perm - update the permissions of an IPC.
+ * ipc_update_perm - update the permissions of an ipc object
  * @in:  the permission given as input.
  * @out: the permission of the ipc to set.
  */
@@ -732,7 +722,7 @@ int ipc_update_perm(struct ipc64_perm *i
 
 /**
  * ipcctl_pre_down_nolock - retrieve an ipc and check permissions for some IPC_XXX cmd
- * @ns:  the ipc namespace
+ * @ns:  ipc namespace
  * @ids:  the table of ids where to look for the ipc
  * @id:   the id of the ipc to retrieve
  * @cmd:  the cmd to check
@@ -779,14 +769,13 @@ err:
 
 
 /**
- *	ipc_parse_version	-	IPC call version
- *	@cmd: pointer to command
+ * ipc_parse_version - ipc call version
+ * @cmd: pointer to command
  *
- *	Return IPC_64 for new style IPC and IPC_OLD for old style IPC. 
- *	The @cmd value is turned from an encoding command and version into
- *	just the command code.
+ * Return IPC_64 for new style IPC and IPC_OLD for old style IPC.
+ * The @cmd value is turned from an encoding command and version into
+ * just the command code.
  */
- 
 int ipc_parse_version(int *cmd)
 {
 	if (*cmd & IPC_64) {
_

Patches currently in -mm which might be from davidlohr@hp.com are

x86-mm-account-for-tlb-flushes-only-when-debugging.patch
x86-mm-clean-up-inconsistencies-when-flushing-tlb-ranges.patch
x86-mm-eliminate-redundant-page-table-walk-during-tlb-range-flushing.patch
x86-mm-change-tlb_flushall_shift-for-ivybridge.patch
mm-x86-revisit-tlb_flushall_shift-tuning-for-page-flushes-except-on-ivybridge.patch
mm-mmapc-add-mlock_future_check-helper.patch
mm-mlock-prepare-params-outside-critical-region.patch
partitions-efi-complete-documentation-of-gpt-kernel-param-purpose.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix-2.patch
ipc-introduce-ipc_valid_object-helper-to-sort-out-ipc_rmid-races.patch
ipc-change-kern_ipc_permdeleted-type-to-bool.patch
ipc-whitespace-cleanup.patch
ipc-standardize-code-comments.patch
ipc-remove-braces-for-single-statements.patch
ipc-remove-useless-return-statement.patch
ipc-simplify-sysvipc_proc_open-return.patch
ipc-delete-seq_max-field-in-struct-ipc_ids.patch
ipc-share-ids-rwsem-when-possible-in-ipcget_public.patch
ipcmsg-document-barriers.patch

