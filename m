From: akpm@osdl.org
Subject: + numerous-fixes-to-kernel-doc-info-in-source-files.patch added to -mm tree
Date: Mon, 08 Jan 2007 15:44:09 -0800
Message-ID: <200701082344.l08Ni9RY022971@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55064 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbXAHXoR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 8 Jan 2007 18:44:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, rdunlap@xenotime.net


The patch titled
     Numerous fixes to kernel-doc info in source files.
has been added to the -mm tree.  Its filename is
     numerous-fixes-to-kernel-doc-info-in-source-files.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Numerous fixes to kernel-doc info in source files.
From: "Robert P. J. Day" <rpjday@mindspring.com>

A variety of (mostly) innocuous fixes to the embedded kernel-doc content in
source files, including:

  * make multi-line initial descriptions single line
  * denote some function names, constants and structs as such
  * change erroneous opening '/*' to '/**' in a few places
  * reword some text for clarity

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/asm-i386/atomic.h |    4 ++--
 include/asm-i386/bitops.h |    4 ++--
 include/linux/init.h      |    2 +-
 include/linux/kfifo.h     |    6 +++---
 include/linux/ktime.h     |    6 +++---
 include/linux/list.h      |   11 ++++++-----
 ipc/util.c                |   21 ++++++++++-----------
 kernel/exit.c             |    3 +--
 kernel/hrtimer.c          |    6 +++---
 kernel/kfifo.c            |   10 +++++-----
 kernel/kthread.c          |    6 +++---
 kernel/printk.c           |    2 +-
 kernel/relay.c            |   12 ++++++------
 kernel/sched.c            |    9 ++++-----
 kernel/signal.c           |    2 +-
 kernel/sys.c              |   10 +++++-----
 kernel/timer.c            |   20 ++++++++++----------
 kernel/workqueue.c        |    6 ++----
 lib/bitmap.c              |    8 ++++----
 lib/cmdline.c             |    8 ++++----
 lib/idr.c                 |    4 ++--
 lib/kobject.c             |    5 +++--
 lib/sha1.c                |    9 ++++-----
 lib/sort.c                |    2 +-
 lib/string.c              |    8 +++-----
 lib/textsearch.c          |    2 +-
 lib/vsprintf.c            |   12 ++++++------
 mm/filemap.c              |    4 ++--
 mm/memory.c               |    4 +---
 mm/mempool.c              |    6 +++---
 mm/page-writeback.c       |    5 +----
 mm/slab.c                 |    2 +-
 mm/truncate.c             |    3 +--
 mm/vmalloc.c              |    2 +-
 34 files changed, 106 insertions(+), 118 deletions(-)

diff -puN include/asm-i386/atomic.h~numerous-fixes-to-kernel-doc-info-in-source-files include/asm-i386/atomic.h
--- a/include/asm-i386/atomic.h~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/include/asm-i386/atomic.h
@@ -211,12 +211,12 @@ static __inline__ int atomic_sub_return(
 #define atomic_xchg(v, new) (xchg(&((v)->counter), new))
 
 /**
- * atomic_add_unless - add unless the number is a given value
+ * atomic_add_unless - add unless the number is already a given value
  * @v: pointer of type atomic_t
  * @a: the amount to add to v...
  * @u: ...unless v is equal to u.
  *
- * Atomically adds @a to @v, so long as it was not @u.
+ * Atomically adds @a to @v, so long as @v was not already @u.
  * Returns non-zero if @v was not @u, and zero otherwise.
  */
 #define atomic_add_unless(v, a, u)				\
diff -puN include/asm-i386/bitops.h~numerous-fixes-to-kernel-doc-info-in-source-files include/asm-i386/bitops.h
--- a/include/asm-i386/bitops.h~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/include/asm-i386/bitops.h
@@ -371,7 +371,7 @@ static inline unsigned long ffz(unsigned
  *
  * This is defined the same way as
  * the libc and compiler builtin ffs routines, therefore
- * differs in spirit from the above ffz (man ffs).
+ * differs in spirit from the above ffz() (man ffs).
  */
 static inline int ffs(int x)
 {
@@ -388,7 +388,7 @@ static inline int ffs(int x)
  * fls - find last bit set
  * @x: the word to search
  *
- * This is defined the same way as ffs.
+ * This is defined the same way as ffs().
  */
 static inline int fls(int x)
 {
diff -puN include/linux/init.h~numerous-fixes-to-kernel-doc-info-in-source-files include/linux/init.h
--- a/include/linux/init.h~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/include/linux/init.h
@@ -172,7 +172,7 @@ void __init parse_early_param(void);
  * module_init() - driver initialization entry point
  * @x: function to be run at kernel boot time or module insertion
  * 
- * module_init() will either be called during do_initcalls (if
+ * module_init() will either be called during do_initcalls() (if
  * builtin) or at module insertion time (if a module).  There can only
  * be one per module.
  */
diff -puN include/linux/kfifo.h~numerous-fixes-to-kernel-doc-info-in-source-files include/linux/kfifo.h
--- a/include/linux/kfifo.h~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/include/linux/kfifo.h
@@ -74,7 +74,7 @@ static inline void kfifo_reset(struct kf
  * @buffer: the data to be added.
  * @len: the length of the data to be added.
  *
- * This function copies at most 'len' bytes from the 'buffer' into
+ * This function copies at most @len bytes from the @buffer into
  * the FIFO depending on the free space, and returns the number of
  * bytes copied.
  */
@@ -99,8 +99,8 @@ static inline unsigned int kfifo_put(str
  * @buffer: where the data must be copied.
  * @len: the size of the destination buffer.
  *
- * This function copies at most 'len' bytes from the FIFO into the
- * 'buffer' and returns the number of copied bytes.
+ * This function copies at most @len bytes from the FIFO into the
+ * @buffer and returns the number of copied bytes.
  */
 static inline unsigned int kfifo_get(struct kfifo *fifo,
 				     unsigned char *buffer, unsigned int len)
diff -puN include/linux/ktime.h~numerous-fixes-to-kernel-doc-info-in-source-files include/linux/ktime.h
--- a/include/linux/ktime.h~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/include/linux/ktime.h
@@ -163,7 +163,7 @@ static inline ktime_t ktime_sub(const kt
  * @add1:	addend1
  * @add2:	addend2
  *
- * Returns the sum of addend1 and addend2
+ * Returns the sum of @add1 and @add2.
  */
 static inline ktime_t ktime_add(const ktime_t add1, const ktime_t add2)
 {
@@ -189,7 +189,7 @@ static inline ktime_t ktime_add(const kt
  * @kt:		addend
  * @nsec:	the scalar nsec value to add
  *
- * Returns the sum of kt and nsec in ktime_t format
+ * Returns the sum of @kt and @nsec in ktime_t format
  */
 extern ktime_t ktime_add_ns(const ktime_t kt, u64 nsec);
 
@@ -246,7 +246,7 @@ static inline struct timeval ktime_to_ti
  * ktime_to_ns - convert a ktime_t variable to scalar nanoseconds
  * @kt:		the ktime_t variable to convert
  *
- * Returns the scalar nanoseconds representation of kt
+ * Returns the scalar nanoseconds representation of @kt
  */
 static inline s64 ktime_to_ns(const ktime_t kt)
 {
diff -puN include/linux/list.h~numerous-fixes-to-kernel-doc-info-in-source-files include/linux/list.h
--- a/include/linux/list.h~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/include/linux/list.h
@@ -161,7 +161,7 @@ static inline void __list_del(struct lis
 /**
  * list_del - deletes entry from list.
  * @entry: the element to delete from the list.
- * Note: list_empty on entry does not return true after this, the entry is
+ * Note: list_empty() on entry does not return true after this, the entry is
  * in an undefined state.
  */
 #ifndef CONFIG_DEBUG_LIST
@@ -179,7 +179,7 @@ extern void list_del(struct list_head *e
  * list_del_rcu - deletes entry from list without re-initialization
  * @entry: the element to delete from the list.
  *
- * Note: list_empty on entry does not return true after this,
+ * Note: list_empty() on entry does not return true after this,
  * the entry is in an undefined state. It is useful for RCU based
  * lockfree traversal.
  *
@@ -209,7 +209,8 @@ static inline void list_del_rcu(struct l
  * list_replace - replace old entry by new one
  * @old : the element to be replaced
  * @new : the new element to insert
- * Note: if 'old' was empty, it will be overwritten.
+ *
+ * If @old was empty, it will be overwritten.
  */
 static inline void list_replace(struct list_head *old,
 				struct list_head *new)
@@ -488,12 +489,12 @@ static inline void list_splice_init_rcu(
 	     pos = list_entry(pos->member.prev, typeof(*pos), member))
 
 /**
- * list_prepare_entry - prepare a pos entry for use in list_for_each_entry_continue
+ * list_prepare_entry - prepare a pos entry for use in list_for_each_entry_continue()
  * @pos:	the type * to use as a start point
  * @head:	the head of the list
  * @member:	the name of the list_struct within the struct.
  *
- * Prepares a pos entry for use as a start point in list_for_each_entry_continue.
+ * Prepares a pos entry for use as a start point in list_for_each_entry_continue().
  */
 #define list_prepare_entry(pos, head, member) \
 	((pos) ? : list_entry(head, typeof(*pos), member))
diff -puN ipc/util.c~numerous-fixes-to-kernel-doc-info-in-source-files ipc/util.c
--- a/ipc/util.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/ipc/util.c
@@ -150,7 +150,7 @@ void free_ipc_ns(struct kref *kref)
  *	ipc_init	-	initialise IPC subsystem
  *
  *	The various system5 IPC resources (semaphores, messages and shared
- *	memory are initialised
+ *	memory) are initialised
  */
  
 static int __init ipc_init(void)
@@ -207,8 +207,7 @@ void __ipc_init ipc_init_ids(struct ipc_
 #ifdef CONFIG_PROC_FS
 static struct file_operations sysvipc_proc_fops;
 /**
- *	ipc_init_proc_interface	-  Create a proc interface for sysipc types
- *				   using a seq_file interface.
+ *	ipc_init_proc_interface	-  Create a proc interface for sysipc types using a seq_file interface.
  *	@path: Path in procfs
  *	@header: Banner to be printed at the beginning of the file.
  *	@ids: ipc id table to iterate.
@@ -417,7 +416,7 @@ void* ipc_alloc(int size)
  *	@ptr: pointer returned by ipc_alloc
  *	@size: size of block
  *
- *	Free a block created with ipc_alloc. The caller must know the size
+ *	Free a block created with ipc_alloc(). The caller must know the size
  *	used in the allocation call.
  */
 
@@ -524,7 +523,7 @@ static void ipc_do_vfree(struct work_str
  * @head: RCU callback structure for queued work
  * 
  * Since RCU callback function is called in bh,
- * we need to defer the vfree to schedule_work
+ * we need to defer the vfree to schedule_work().
  */
 static void ipc_schedule_free(struct rcu_head *head)
 {
@@ -541,7 +540,7 @@ static void ipc_schedule_free(struct rcu
  * ipc_immediate_free - free ipc + rcu space
  * @head: RCU callback structure that contains pointer to be freed
  *
- * Free from the RCU callback context
+ * Free from the RCU callback context.
  */
 static void ipc_immediate_free(struct rcu_head *head)
 {
@@ -603,8 +602,8 @@ int ipcperms (struct kern_ipc_perm *ipcp
  *	@in: kernel permissions
  *	@out: new style IPC permissions
  *
- *	Turn the kernel object 'in' into a set of permissions descriptions
- *	for returning to userspace (out).
+ *	Turn the kernel object @in into a set of permissions descriptions
+ *	for returning to userspace (@out).
  */
  
 
@@ -624,8 +623,8 @@ void kernel_to_ipc64_perm (struct kern_i
  *	@in: new style IPC permissions
  *	@out: old style IPC permissions
  *
- *	Turn the new style permissions object in into a compatibility
- *	object and store it into the 'out' pointer.
+ *	Turn the new style permissions object @in into a compatibility
+ *	object and store it into the @out pointer.
  */
  
 void ipc64_perm_to_ipc_perm (struct ipc64_perm *in, struct ipc_perm *out)
@@ -722,7 +721,7 @@ int ipc_checkid(struct ipc_ids* ids, str
  *	@cmd: pointer to command
  *
  *	Return IPC_64 for new style IPC and IPC_OLD for old style IPC. 
- *	The cmd value is turned from an encoding command and version into
+ *	The @cmd value is turned from an encoding command and version into
  *	just the command code.
  */
  
diff -puN kernel/exit.c~numerous-fixes-to-kernel-doc-info-in-source-files kernel/exit.c
--- a/kernel/exit.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/kernel/exit.c
@@ -257,8 +257,7 @@ static int has_stopped_jobs(int pgrp)
 }
 
 /**
- * reparent_to_init - Reparent the calling kernel thread to the init task
- * of the pid space that the thread belongs to.
+ * reparent_to_init - Reparent the calling kernel thread to the init task of the pid space that the thread belongs to.
  *
  * If a kernel thread is launched as a result of a system call, or if
  * it ever exits, it should generally reparent itself to init so that
diff -puN kernel/hrtimer.c~numerous-fixes-to-kernel-doc-info-in-source-files kernel/hrtimer.c
--- a/kernel/hrtimer.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/kernel/hrtimer.c
@@ -102,7 +102,7 @@ static DEFINE_PER_CPU(struct hrtimer_bas
  *
  * The function calculates the monotonic clock from the realtime
  * clock and the wall_to_monotonic offset and stores the result
- * in normalized timespec format in the variable pointed to by ts.
+ * in normalized timespec format in the variable pointed to by @ts.
  */
 void ktime_get_ts(struct timespec *ts)
 {
@@ -583,8 +583,8 @@ EXPORT_SYMBOL_GPL(hrtimer_init);
  * @which_clock: which clock to query
  * @tp:		 pointer to timespec variable to store the resolution
  *
- * Store the resolution of the clock selected by which_clock in the
- * variable pointed to by tp.
+ * Store the resolution of the clock selected by @which_clock in the
+ * variable pointed to by @tp.
  */
 int hrtimer_get_res(const clockid_t which_clock, struct timespec *tp)
 {
diff -puN kernel/kfifo.c~numerous-fixes-to-kernel-doc-info-in-source-files kernel/kfifo.c
--- a/kernel/kfifo.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/kernel/kfifo.c
@@ -32,8 +32,8 @@
  * @gfp_mask: get_free_pages mask, passed to kmalloc()
  * @lock: the lock to be used to protect the fifo buffer
  *
- * Do NOT pass the kfifo to kfifo_free() after use ! Simply free the
- * struct kfifo with kfree().
+ * Do NOT pass the kfifo to kfifo_free() after use! Simply free the
+ * &struct kfifo with kfree().
  */
 struct kfifo *kfifo_init(unsigned char *buffer, unsigned int size,
 			 gfp_t gfp_mask, spinlock_t *lock)
@@ -108,7 +108,7 @@ EXPORT_SYMBOL(kfifo_free);
  * @buffer: the data to be added.
  * @len: the length of the data to be added.
  *
- * This function copies at most 'len' bytes from the 'buffer' into
+ * This function copies at most @len bytes from the @buffer into
  * the FIFO depending on the free space, and returns the number of
  * bytes copied.
  *
@@ -155,8 +155,8 @@ EXPORT_SYMBOL(__kfifo_put);
  * @buffer: where the data must be copied.
  * @len: the size of the destination buffer.
  *
- * This function copies at most 'len' bytes from the FIFO into the
- * 'buffer' and returns the number of copied bytes.
+ * This function copies at most @len bytes from the FIFO into the
+ * @buffer and returns the number of copied bytes.
  *
  * Note that with only one concurrent reader and one concurrent
  * writer, you don't need extra locking to use these functions.
diff -puN kernel/kthread.c~numerous-fixes-to-kernel-doc-info-in-source-files kernel/kthread.c
--- a/kernel/kthread.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/kernel/kthread.c
@@ -50,7 +50,7 @@ static struct kthread_stop_info kthread_
 /**
  * kthread_should_stop - should this kthread return now?
  *
- * When someone calls kthread_stop on your kthread, it will be woken
+ * When someone calls kthread_stop() on your kthread, it will be woken
  * and this will return true.  You should then return, and your return
  * value will be passed through to kthread_stop().
  */
@@ -143,7 +143,7 @@ static void keventd_create_kthread(struc
  * it.  See also kthread_run(), kthread_create_on_cpu().
  *
  * When woken, the thread will run @threadfn() with @data as its
- * argument. @threadfn can either call do_exit() directly if it is a
+ * argument. @threadfn() can either call do_exit() directly if it is a
  * standalone thread for which noone will call kthread_stop(), or
  * return when 'kthread_should_stop()' is true (which means
  * kthread_stop() has been called).  The return value should be zero
@@ -192,7 +192,7 @@ EXPORT_SYMBOL(kthread_create);
  *
  * Description: This function is equivalent to set_cpus_allowed(),
  * except that @cpu doesn't need to be online, and the thread must be
- * stopped (i.e., just returned from kthread_create().
+ * stopped (i.e., just returned from kthread_create()).
  */
 void kthread_bind(struct task_struct *k, unsigned int cpu)
 {
diff -puN kernel/printk.c~numerous-fixes-to-kernel-doc-info-in-source-files kernel/printk.c
--- a/kernel/printk.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/kernel/printk.c
@@ -483,7 +483,7 @@ static int have_callable_console(void)
  * printk - print a kernel message
  * @fmt: format string
  *
- * This is printk.  It can be called from any context.  We want it to work.
+ * This is printk().  It can be called from any context.  We want it to work.
  *
  * We try to grab the console_sem.  If we succeed, it's easy - we log the output and
  * call the console drivers.  If we fail to get the semaphore we place the output
diff -puN kernel/relay.c~numerous-fixes-to-kernel-doc-info-in-source-files kernel/relay.c
--- a/kernel/relay.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/kernel/relay.c
@@ -328,7 +328,7 @@ static void wakeup_readers(struct work_s
  *	@buf: the channel buffer
  *	@init: 1 if this is a first-time initialization
  *
- *	See relay_reset for description of effect.
+ *	See relay_reset() for description of effect.
  */
 static void __relay_reset(struct rchan_buf *buf, unsigned int init)
 {
@@ -364,7 +364,7 @@ static void __relay_reset(struct rchan_b
  *	and restarting the channel in its initial state.  The buffers
  *	are not freed, so any mappings are still in effect.
  *
- *	NOTE: Care should be taken that the channel isn't actually
+ *	NOTE. Care should be taken that the channel isn't actually
  *	being used by anything when this call is made.
  */
 void relay_reset(struct rchan *chan)
@@ -528,7 +528,7 @@ static int __cpuinit relay_hotcpu_callba
  *	Creates a channel buffer for each cpu using the sizes and
  *	attributes specified.  The created channel buffer files
  *	will be named base_filename0...base_filenameN-1.  File
- *	permissions will be S_IRUSR.
+ *	permissions will be %S_IRUSR.
  */
 struct rchan *relay_open(const char *base_filename,
 			 struct dentry *parent,
@@ -648,7 +648,7 @@ EXPORT_SYMBOL_GPL(relay_switch_subbuf);
  *	subbufs_consumed should be the number of sub-buffers newly consumed,
  *	not the total consumed.
  *
- *	NOTE: Kernel clients don't need to call this function if the channel
+ *	NOTE. Kernel clients don't need to call this function if the channel
  *	mode is 'overwrite'.
  */
 void relay_subbufs_consumed(struct rchan *chan,
@@ -749,7 +749,7 @@ static int relay_file_open(struct inode 
  *	@filp: the file
  *	@vma: the vma describing what to map
  *
- *	Calls upon relay_mmap_buf to map the file into user space.
+ *	Calls upon relay_mmap_buf() to map the file into user space.
  */
 static int relay_file_mmap(struct file *filp, struct vm_area_struct *vma)
 {
@@ -891,7 +891,7 @@ static size_t relay_file_read_subbuf_ava
  *	@read_pos: file read position
  *	@buf: relay channel buffer
  *
- *	If the read_pos is in the middle of padding, return the
+ *	If the @read_pos is in the middle of padding, return the
  *	position of the first actually available byte, otherwise
  *	return the original value.
  */
diff -puN kernel/sched.c~numerous-fixes-to-kernel-doc-info-in-source-files kernel/sched.c
--- a/kernel/sched.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/kernel/sched.c
@@ -4210,13 +4210,12 @@ static void __setscheduler(struct task_s
 }
 
 /**
- * sched_setscheduler - change the scheduling policy and/or RT priority of
- * a thread.
+ * sched_setscheduler - change the scheduling policy and/or RT priority of a thread.
  * @p: the task in question.
  * @policy: new policy.
  * @param: structure containing the new RT priority.
  *
- * NOTE: the task may be already dead
+ * NOTE that the task may be already dead.
  */
 int sched_setscheduler(struct task_struct *p, int policy,
 		       struct sched_param *param)
@@ -4584,7 +4583,7 @@ asmlinkage long sys_sched_getaffinity(pi
 /**
  * sys_sched_yield - yield the current processor to other threads.
  *
- * this function yields the current CPU by moving the calling thread
+ * This function yields the current CPU by moving the calling thread
  * to the expired array. If there are no other threads running on this
  * CPU then this function will return.
  */
@@ -4711,7 +4710,7 @@ EXPORT_SYMBOL(cond_resched_softirq);
 /**
  * yield - yield the current processor to other threads.
  *
- * this is a shortcut for kernel-space yielding - it marks the
+ * This is a shortcut for kernel-space yielding - it marks the
  * thread runnable and calls sys_sched_yield().
  */
 void __sched yield(void)
diff -puN kernel/signal.c~numerous-fixes-to-kernel-doc-info-in-source-files kernel/signal.c
--- a/kernel/signal.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/kernel/signal.c
@@ -2282,7 +2282,7 @@ static int do_tkill(int tgid, int pid, i
  *  @pid: the PID of the thread
  *  @sig: signal to be sent
  *
- *  This syscall also checks the tgid and returns -ESRCH even if the PID
+ *  This syscall also checks the @tgid and returns -ESRCH even if the PID
  *  exists but it's not belonging to the target process anymore. This
  *  method solves the problem of threads exiting and PIDs getting reused.
  */
diff -puN kernel/sys.c~numerous-fixes-to-kernel-doc-info-in-source-files kernel/sys.c
--- a/kernel/sys.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/kernel/sys.c
@@ -215,7 +215,7 @@ EXPORT_SYMBOL_GPL(atomic_notifier_chain_
  *	This routine uses RCU to synchronize with changes to the chain.
  *
  *	If the return value of the notifier can be and'ed
- *	with %NOTIFY_STOP_MASK then atomic_notifier_call_chain
+ *	with %NOTIFY_STOP_MASK then atomic_notifier_call_chain()
  *	will return immediately, with the return value of
  *	the notifier function which halted execution.
  *	Otherwise the return value is the return value
@@ -313,7 +313,7 @@ EXPORT_SYMBOL_GPL(blocking_notifier_chai
  *	run in a process context, so they are allowed to block.
  *
  *	If the return value of the notifier can be and'ed
- *	with %NOTIFY_STOP_MASK then blocking_notifier_call_chain
+ *	with %NOTIFY_STOP_MASK then blocking_notifier_call_chain()
  *	will return immediately, with the return value of
  *	the notifier function which halted execution.
  *	Otherwise the return value is the return value
@@ -386,7 +386,7 @@ EXPORT_SYMBOL_GPL(raw_notifier_chain_unr
  *	All locking must be provided by the caller.
  *
  *	If the return value of the notifier can be and'ed
- *	with %NOTIFY_STOP_MASK then raw_notifier_call_chain
+ *	with %NOTIFY_STOP_MASK then raw_notifier_call_chain()
  *	will return immediately, with the return value of
  *	the notifier function which halted execution.
  *	Otherwise the return value is the return value
@@ -480,7 +480,7 @@ EXPORT_SYMBOL_GPL(srcu_notifier_chain_un
  *	run in a process context, so they are allowed to block.
  *
  *	If the return value of the notifier can be and'ed
- *	with %NOTIFY_STOP_MASK then srcu_notifier_call_chain
+ *	with %NOTIFY_STOP_MASK then srcu_notifier_call_chain()
  *	will return immediately, with the return value of
  *	the notifier function which halted execution.
  *	Otherwise the return value is the return value
@@ -531,7 +531,7 @@ EXPORT_SYMBOL_GPL(srcu_init_notifier_hea
  *	Registers a function with the list of functions
  *	to be called at reboot time.
  *
- *	Currently always returns zero, as blocking_notifier_chain_register
+ *	Currently always returns zero, as blocking_notifier_chain_register()
  *	always returns zero.
  */
  
diff -puN kernel/timer.c~numerous-fixes-to-kernel-doc-info-in-source-files kernel/timer.c
--- a/kernel/timer.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/kernel/timer.c
@@ -85,7 +85,7 @@ static DEFINE_PER_CPU(tvec_base_t *, tve
  * @j: the time in (absolute) jiffies that should be rounded
  * @cpu: the processor number on which the timeout will happen
  *
- * __round_jiffies rounds an absolute time in the future (in jiffies)
+ * __round_jiffies() rounds an absolute time in the future (in jiffies)
  * up or down to (approximately) full seconds. This is useful for timers
  * for which the exact time they fire does not matter too much, as long as
  * they fire approximately every X seconds.
@@ -98,7 +98,7 @@ static DEFINE_PER_CPU(tvec_base_t *, tve
  * processors firing at the exact same time, which could lead
  * to lock contention or spurious cache line bouncing.
  *
- * The return value is the rounded version of the "j" parameter.
+ * The return value is the rounded version of the @j parameter.
  */
 unsigned long __round_jiffies(unsigned long j, int cpu)
 {
@@ -142,7 +142,7 @@ EXPORT_SYMBOL_GPL(__round_jiffies);
  * @j: the time in (relative) jiffies that should be rounded
  * @cpu: the processor number on which the timeout will happen
  *
- * __round_jiffies_relative rounds a time delta  in the future (in jiffies)
+ * __round_jiffies_relative() rounds a time delta  in the future (in jiffies)
  * up or down to (approximately) full seconds. This is useful for timers
  * for which the exact time they fire does not matter too much, as long as
  * they fire approximately every X seconds.
@@ -155,7 +155,7 @@ EXPORT_SYMBOL_GPL(__round_jiffies);
  * processors firing at the exact same time, which could lead
  * to lock contention or spurious cache line bouncing.
  *
- * The return value is the rounded version of the "j" parameter.
+ * The return value is the rounded version of the @j parameter.
  */
 unsigned long __round_jiffies_relative(unsigned long j, int cpu)
 {
@@ -173,7 +173,7 @@ EXPORT_SYMBOL_GPL(__round_jiffies_relati
  * round_jiffies - function to round jiffies to a full second
  * @j: the time in (absolute) jiffies that should be rounded
  *
- * round_jiffies rounds an absolute time in the future (in jiffies)
+ * round_jiffies() rounds an absolute time in the future (in jiffies)
  * up or down to (approximately) full seconds. This is useful for timers
  * for which the exact time they fire does not matter too much, as long as
  * they fire approximately every X seconds.
@@ -182,7 +182,7 @@ EXPORT_SYMBOL_GPL(__round_jiffies_relati
  * at the same time, rather than at various times spread out. The goal
  * of this is to have the CPU wake up less, which saves power.
  *
- * The return value is the rounded version of the "j" parameter.
+ * The return value is the rounded version of the @j parameter.
  */
 unsigned long round_jiffies(unsigned long j)
 {
@@ -194,7 +194,7 @@ EXPORT_SYMBOL_GPL(round_jiffies);
  * round_jiffies_relative - function to round jiffies to a full second
  * @j: the time in (relative) jiffies that should be rounded
  *
- * round_jiffies_relative rounds a time delta  in the future (in jiffies)
+ * round_jiffies_relative() rounds a time delta  in the future (in jiffies)
  * up or down to (approximately) full seconds. This is useful for timers
  * for which the exact time they fire does not matter too much, as long as
  * they fire approximately every X seconds.
@@ -203,7 +203,7 @@ EXPORT_SYMBOL_GPL(round_jiffies);
  * at the same time, rather than at various times spread out. The goal
  * of this is to have the CPU wake up less, which saves power.
  *
- * The return value is the rounded version of the "j" parameter.
+ * The return value is the rounded version of the @j parameter.
  */
 unsigned long round_jiffies_relative(unsigned long j)
 {
@@ -387,7 +387,7 @@ void add_timer_on(struct timer_list *tim
  * @timer: the timer to be modified
  * @expires: new timeout in jiffies
  *
- * mod_timer is a more efficient way to update the expire field of an
+ * mod_timer() is a more efficient way to update the expire field of an
  * active timer (if the timer is inactive it will be activated)
  *
  * mod_timer(timer, expires) is equivalent to:
@@ -490,7 +490,7 @@ out:
  * the timer it also makes sure the handler has finished executing on other
  * CPUs.
  *
- * Synchronization rules: callers must prevent restarting of the timer,
+ * Synchronization rules: Callers must prevent restarting of the timer,
  * otherwise this function is meaningless. It must not be called from
  * interrupt contexts. The caller must not hold locks which would prevent
  * completion of the timer's handler. The timer's handler must not call
diff -puN kernel/workqueue.c~numerous-fixes-to-kernel-doc-info-in-source-files kernel/workqueue.c
--- a/kernel/workqueue.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/kernel/workqueue.c
@@ -656,8 +656,7 @@ void flush_scheduled_work(void)
 EXPORT_SYMBOL(flush_scheduled_work);
 
 /**
- * cancel_rearming_delayed_workqueue - reliably kill off a delayed
- *			work whose handler rearms the delayed work.
+ * cancel_rearming_delayed_workqueue - reliably kill off a delayed work whose handler rearms the delayed work.
  * @wq:   the controlling workqueue structure
  * @dwork: the delayed work struct
  */
@@ -670,8 +669,7 @@ void cancel_rearming_delayed_workqueue(s
 EXPORT_SYMBOL(cancel_rearming_delayed_workqueue);
 
 /**
- * cancel_rearming_delayed_work - reliably kill off a delayed keventd
- *			work whose handler rearms the delayed work.
+ * cancel_rearming_delayed_work - reliably kill off a delayed keventd work whose handler rearms the delayed work.
  * @dwork: the delayed work struct
  */
 void cancel_rearming_delayed_work(struct delayed_work *dwork)
diff -puN lib/bitmap.c~numerous-fixes-to-kernel-doc-info-in-source-files lib/bitmap.c
--- a/lib/bitmap.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/lib/bitmap.c
@@ -95,7 +95,7 @@ void __bitmap_complement(unsigned long *
 }
 EXPORT_SYMBOL(__bitmap_complement);
 
-/*
+/**
  * __bitmap_shift_right - logical right shift of the bits in a bitmap
  *   @dst - destination bitmap
  *   @src - source bitmap
@@ -139,7 +139,7 @@ void __bitmap_shift_right(unsigned long 
 EXPORT_SYMBOL(__bitmap_shift_right);
 
 
-/*
+/**
  * __bitmap_shift_left - logical left shift of the bits in a bitmap
  *   @dst - destination bitmap
  *   @src - source bitmap
@@ -529,7 +529,7 @@ int bitmap_parselist(const char *bp, uns
 }
 EXPORT_SYMBOL(bitmap_parselist);
 
-/*
+/**
  * bitmap_pos_to_ord(buf, pos, bits)
  *	@buf: pointer to a bitmap
  *	@pos: a bit position in @buf (0 <= @pos < @bits)
@@ -804,7 +804,7 @@ EXPORT_SYMBOL(bitmap_find_free_region);
  *	@pos: beginning of bit region to release
  *	@order: region size (log base 2 of number of bits) to release
  *
- * This is the complement to __bitmap_find_free_region and releases
+ * This is the complement to __bitmap_find_free_region() and releases
  * the found region (by clearing it in the bitmap).
  *
  * No return value.
diff -puN lib/cmdline.c~numerous-fixes-to-kernel-doc-info-in-source-files lib/cmdline.c
--- a/lib/cmdline.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/lib/cmdline.c
@@ -43,10 +43,10 @@ static int get_range(char **str, int *pi
  *	comma as well.
  *
  *	Return values:
- *	0 : no int in string
- *	1 : int found, no subsequent comma
- *	2 : int found including a subsequent comma
- *	3 : hyphen found to denote a range
+ *	0 - no int in string
+ *	1 - int found, no subsequent comma
+ *	2 - int found including a subsequent comma
+ *	3 - hyphen found to denote a range
  */
 
 int get_option (char **str, int *pint)
diff -puN lib/idr.c~numerous-fixes-to-kernel-doc-info-in-source-files lib/idr.c
--- a/lib/idr.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/lib/idr.c
@@ -329,8 +329,8 @@ static void sub_remove(struct idr *idp, 
 
 /**
  * idr_remove - remove the given id and free it's slot
- * idp: idr handle
- * id: uniqueue key
+ * @idp: idr handle
+ * @id: uniqueue key
  */
 void idr_remove(struct idr *idp, int id)
 {
diff -puN lib/kobject.c~numerous-fixes-to-kernel-doc-info-in-source-files lib/kobject.c
--- a/lib/kobject.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/lib/kobject.c
@@ -99,11 +99,12 @@ static void fill_kobj_path(struct kobjec
 }
 
 /**
- * kobject_get_path - generate and return the path associated with a given kobj
- * and kset pair.  The result must be freed by the caller with kfree().
+ * kobject_get_path - generate and return the path associated with a given kobj and kset pair.
  *
  * @kobj:	kobject in question, with which to build the path
  * @gfp_mask:	the allocation type used to allocate the path
+ *
+ * The result must be freed by the caller with kfree().
  */
 char *kobject_get_path(struct kobject *kobj, gfp_t gfp_mask)
 {
diff -puN lib/sha1.c~numerous-fixes-to-kernel-doc-info-in-source-files lib/sha1.c
--- a/lib/sha1.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/lib/sha1.c
@@ -20,8 +20,8 @@
 #define K3  0x8F1BBCDCL			/* Rounds 40-59: sqrt(5) * 2^30 */
 #define K4  0xCA62C1D6L			/* Rounds 60-79: sqrt(10) * 2^30 */
 
-/*
- * sha_transform: single block SHA1 transform
+/**
+ * sha_transform - single block SHA1 transform
  *
  * @digest: 160 bit digest to update
  * @data:   512 bits of data to hash
@@ -80,9 +80,8 @@ void sha_transform(__u32 *digest, const 
 }
 EXPORT_SYMBOL(sha_transform);
 
-/*
- * sha_init: initialize the vectors for a SHA1 digest
- *
+/**
+ * sha_init - initialize the vectors for a SHA1 digest
  * @buf: vector to initialize
  */
 void sha_init(__u32 *buf)
diff -puN lib/sort.c~numerous-fixes-to-kernel-doc-info-in-source-files lib/sort.c
--- a/lib/sort.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/lib/sort.c
@@ -27,7 +27,7 @@ static void generic_swap(void *a, void *
 	} while (--size > 0);
 }
 
-/*
+/**
  * sort - sort an array of elements
  * @base: pointer to data to sort
  * @num: number of elements
diff -puN lib/string.c~numerous-fixes-to-kernel-doc-info-in-source-files lib/string.c
--- a/lib/string.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/lib/string.c
@@ -160,7 +160,7 @@ EXPORT_SYMBOL(strcat);
  * @src: The string to append to it
  * @count: The maximum numbers of bytes to copy
  *
- * Note that in contrast to strncpy, strncat ensures the result is
+ * Note that in contrast to strncpy(), strncat() ensures the result is
  * terminated.
  */
 char *strncat(char *dest, const char *src, size_t count)
@@ -366,8 +366,7 @@ EXPORT_SYMBOL(strnlen);
 
 #ifndef __HAVE_ARCH_STRSPN
 /**
- * strspn - Calculate the length of the initial substring of @s which only
- * 	contain letters in @accept
+ * strspn - Calculate the length of the initial substring of @s which only contain letters in @accept
  * @s: The string to be searched
  * @accept: The string to search for
  */
@@ -394,8 +393,7 @@ EXPORT_SYMBOL(strspn);
 
 #ifndef __HAVE_ARCH_STRCSPN
 /**
- * strcspn - Calculate the length of the initial substring of @s which does
- * 	not contain letters in @reject
+ * strcspn - Calculate the length of the initial substring of @s which does not contain letters in @reject
  * @s: The string to be searched
  * @reject: The string to avoid
  */
diff -puN lib/textsearch.c~numerous-fixes-to-kernel-doc-info-in-source-files lib/textsearch.c
--- a/lib/textsearch.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/lib/textsearch.c
@@ -218,7 +218,7 @@ static unsigned int get_linear_data(unsi
  * Call textsearch_next() to retrieve subsequent matches.
  *
  * Returns the position of first occurrence of the pattern or
- * UINT_MAX if no occurrence was found.
+ * %UINT_MAX if no occurrence was found.
  */ 
 unsigned int textsearch_find_continuous(struct ts_config *conf,
 					struct ts_state *state,
diff -puN lib/vsprintf.c~numerous-fixes-to-kernel-doc-info-in-source-files lib/vsprintf.c
--- a/lib/vsprintf.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/lib/vsprintf.c
@@ -247,12 +247,12 @@ static char * number(char * buf, char * 
  * be generated for the given input, excluding the trailing
  * '\0', as per ISO C99. If you want to have the exact
  * number of characters written into @buf as return value
- * (not including the trailing '\0'), use vscnprintf. If the
+ * (not including the trailing '\0'), use vscnprintf(). If the
  * return is greater than or equal to @size, the resulting
  * string is truncated.
  *
  * Call this function if you are already dealing with a va_list.
- * You probably want snprintf instead.
+ * You probably want snprintf() instead.
  */
 int vsnprintf(char *buf, size_t size, const char *fmt, va_list args)
 {
@@ -509,7 +509,7 @@ EXPORT_SYMBOL(vsnprintf);
  * returns 0.
  *
  * Call this function if you are already dealing with a va_list.
- * You probably want scnprintf instead.
+ * You probably want scnprintf() instead.
  */
 int vscnprintf(char *buf, size_t size, const char *fmt, va_list args)
 {
@@ -577,11 +577,11 @@ EXPORT_SYMBOL(scnprintf);
  * @args: Arguments for the format string
  *
  * The function returns the number of characters written
- * into @buf. Use vsnprintf or vscnprintf in order to avoid
+ * into @buf. Use vsnprintf() or vscnprintf() in order to avoid
  * buffer overflows.
  *
  * Call this function if you are already dealing with a va_list.
- * You probably want sprintf instead.
+ * You probably want sprintf() instead.
  */
 int vsprintf(char *buf, const char *fmt, va_list args)
 {
@@ -597,7 +597,7 @@ EXPORT_SYMBOL(vsprintf);
  * @...: Arguments for the format string
  *
  * The function returns the number of characters written
- * into @buf. Use snprintf or scnprintf in order to avoid
+ * into @buf. Use snprintf() or scnprintf() in order to avoid
  * buffer overflows.
  */
 int sprintf(char * buf, const char *fmt, ...)
diff -puN mm/filemap.c~numerous-fixes-to-kernel-doc-info-in-source-files mm/filemap.c
--- a/mm/filemap.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/mm/filemap.c
@@ -297,7 +297,7 @@ EXPORT_SYMBOL(sync_page_range);
  * @pos:	beginning offset in pages to write
  * @count:	number of bytes to write
  *
- * Note: Holding i_mutex across sync_page_range_nolock is not a good idea
+ * Note: Holding i_mutex across sync_page_range_nolock() is not a good idea
  * as it forces O_SYNC writers to different parts of the same file
  * to be serialised right until io completion.
  */
@@ -752,7 +752,7 @@ unsigned find_get_pages_tag(struct addre
  * @mapping: target address_space
  * @index: the page index
  *
- * Same as grab_cache_page, but do not wait if the page is unavailable.
+ * Same as grab_cache_page(), but do not wait if the page is unavailable.
  * This is intended for speculative data generators, where the data can
  * be regenerated if the page couldn't be grabbed.  This routine should
  * be safe to call while holding the lock for another page.
diff -puN mm/memory.c~numerous-fixes-to-kernel-doc-info-in-source-files mm/memory.c
--- a/mm/memory.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/mm/memory.c
@@ -1776,9 +1776,7 @@ restart:
 }
 
 /**
- * unmap_mapping_range - unmap the portion of all mmaps
- * in the specified address_space corresponding to the specified
- * page range in the underlying file.
+ * unmap_mapping_range - unmap the portion of all mmaps in the specified address_space corresponding to the specified page range in the underlying file.
  * @mapping: the address space containing mmaps to be unmapped.
  * @holebegin: byte in first page to unmap, relative to the start of
  * the underlying file.  This will be rounded down to a PAGE_SIZE
diff -puN mm/mempool.c~numerous-fixes-to-kernel-doc-info-in-source-files mm/mempool.c
--- a/mm/mempool.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/mm/mempool.c
@@ -46,9 +46,9 @@ static void free_pool(mempool_t *pool)
  * @pool_data: optional private data available to the user-defined functions.
  *
  * this function creates and allocates a guaranteed size, preallocated
- * memory pool. The pool can be used from the mempool_alloc and mempool_free
+ * memory pool. The pool can be used from the mempool_alloc() and mempool_free()
  * functions. This function might sleep. Both the alloc_fn() and the free_fn()
- * functions might sleep - as long as the mempool_alloc function is not called
+ * functions might sleep - as long as the mempool_alloc() function is not called
  * from IRQ contexts.
  */
 mempool_t *mempool_create(int min_nr, mempool_alloc_t *alloc_fn,
@@ -195,7 +195,7 @@ EXPORT_SYMBOL(mempool_destroy);
  *             mempool_create().
  * @gfp_mask:  the usual allocation bitmask.
  *
- * this function only sleeps if the alloc_fn function sleeps or
+ * this function only sleeps if the alloc_fn() function sleeps or
  * returns NULL. Note that due to preallocation, this function
  * *never* fails when called from process contexts. (it might
  * fail if called from an IRQ context.)
diff -puN mm/page-writeback.c~numerous-fixes-to-kernel-doc-info-in-source-files mm/page-writeback.c
--- a/mm/page-writeback.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/mm/page-writeback.c
@@ -554,9 +554,7 @@ void __init page_writeback_init(void)
 }
 
 /**
- * generic_writepages - walk the list of dirty pages of the given
- *                      address space and writepage() all of them.
- *
+ * generic_writepages - walk the list of dirty pages of the given address space and writepage() all of them.
  * @mapping: address space structure to write
  * @wbc: subtract the number of written pages from *@wbc->nr_to_write
  *
@@ -704,7 +702,6 @@ int do_writepages(struct address_space *
 
 /**
  * write_one_page - write out a single page and optionally wait on I/O
- *
  * @page: the page to write
  * @wait: if true, wait on writeout
  *
diff -puN mm/slab.c~numerous-fixes-to-kernel-doc-info-in-source-files mm/slab.c
--- a/mm/slab.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/mm/slab.c
@@ -2517,7 +2517,7 @@ EXPORT_SYMBOL(kmem_cache_shrink);
  * kmem_cache_destroy - delete a cache
  * @cachep: the cache to destroy
  *
- * Remove a struct kmem_cache object from the slab cache.
+ * Remove a &struct kmem_cache object from the slab cache.
  *
  * It is expected this function will be called by a module when it is
  * unloaded.  This will remove the cache completely, and avoid a duplicate
diff -puN mm/truncate.c~numerous-fixes-to-kernel-doc-info-in-source-files mm/truncate.c
--- a/mm/truncate.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/mm/truncate.c
@@ -123,8 +123,7 @@ invalidate_complete_page(struct address_
 }
 
 /**
- * truncate_inode_pages - truncate range of pages specified by start and
- * end byte offsets
+ * truncate_inode_pages_range - truncate range of pages specified by start and end byte offsets
  * @mapping: mapping to truncate
  * @lstart: offset from which to truncate
  * @lend: offset to which to truncate
diff -puN mm/vmalloc.c~numerous-fixes-to-kernel-doc-info-in-source-files mm/vmalloc.c
--- a/mm/vmalloc.c~numerous-fixes-to-kernel-doc-info-in-source-files
+++ a/mm/vmalloc.c
@@ -699,7 +699,7 @@ finished:
  *	that it is big enough to cover the vma. Will return failure if
  *	that criteria isn't met.
  *
- *	Similar to remap_pfn_range (see mm/memory.c)
+ *	Similar to remap_pfn_range() (see mm/memory.c)
  */
 int remap_vmalloc_range(struct vm_area_struct *vma, void *addr,
 						unsigned long pgoff)
_

Patches currently in -mm which might be from rpjday@mindspring.com are

git-alsa.patch
ppc-use-syslog-macro-for-the-printk-log-level.patch
rewrite-unnecessary-duplicated-code-to-use-field_sizeof.patch
transform-kmem_cache_allocmemset0-kmem_cache_zalloc.patch
get-rid-of-double-zeroing-of-allocated-pages.patch
remove-unnecessary-memset0-calls-after-kzalloc-calls.patch
discuss-a-couple-common-errors-in-kernel-doc-usage.patch
numerous-fixes-to-kernel-doc-info-in-source-files.patch
oss-replace-kmallocmemset-combos-with-kzalloc.patch
