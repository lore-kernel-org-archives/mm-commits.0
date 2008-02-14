From: akpm@linux-foundation.org
Subject: - include-linux-remove-all-users-of-fastcall-macro.patch removed from -mm tree
Date: Thu, 14 Feb 2008 14:15:33 -0500
Message-ID: <200802150218.m1F2IqH6014959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56178 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756937AbYBOCS6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 21:18:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     include/linux: Remove all users of FASTCALL() macro
has been removed from the -mm tree.  Its filename was
     include-linux-remove-all-users-of-fastcall-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: include/linux: Remove all users of FASTCALL() macro
From: Harvey Harrison <harvey.harrison@gmail.com>

FASTCALL() is always expanded to empty, remove it.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/aio.h            |   20 +++++++++---------
 include/linux/buffer_head.h    |    6 ++---
 include/linux/file.h           |   16 +++++++-------
 include/linux/gfp.h            |   15 ++++++-------
 include/linux/interrupt.h      |    8 +++----
 include/linux/mm.h             |    4 +--
 include/linux/mutex-debug.h    |    2 -
 include/linux/namei.h          |    6 ++---
 include/linux/netdevice.h      |    2 -
 include/linux/pagemap.h        |   10 ++++-----
 include/linux/pid.h            |   21 +++++++++----------
 include/linux/rwsem-spinlock.h |   16 +++++++-------
 include/linux/sched.h          |   14 ++++++------
 include/linux/swap.h           |    8 +++----
 include/linux/wait.h           |   34 ++++++++++++++-----------------
 include/linux/workqueue.h      |   13 +++++------
 16 files changed, 95 insertions(+), 100 deletions(-)

diff -puN include/linux/aio.h~include-linux-remove-all-users-of-fastcall-macro include/linux/aio.h
--- a/include/linux/aio.h~include-linux-remove-all-users-of-fastcall-macro
+++ a/include/linux/aio.h
@@ -206,21 +206,21 @@ struct kioctx {
 /* prototypes */
 extern unsigned aio_max_size;
 
-extern ssize_t FASTCALL(wait_on_sync_kiocb(struct kiocb *iocb));
-extern int FASTCALL(aio_put_req(struct kiocb *iocb));
-extern void FASTCALL(kick_iocb(struct kiocb *iocb));
-extern int FASTCALL(aio_complete(struct kiocb *iocb, long res, long res2));
-extern void FASTCALL(__put_ioctx(struct kioctx *ctx));
+extern ssize_t wait_on_sync_kiocb(struct kiocb *iocb);
+extern int aio_put_req(struct kiocb *iocb);
+extern void kick_iocb(struct kiocb *iocb);
+extern int aio_complete(struct kiocb *iocb, long res, long res2);
+extern void __put_ioctx(struct kioctx *ctx);
 struct mm_struct;
-extern void FASTCALL(exit_aio(struct mm_struct *mm));
+extern void exit_aio(struct mm_struct *mm);
 extern struct kioctx *lookup_ioctx(unsigned long ctx_id);
-extern int FASTCALL(io_submit_one(struct kioctx *ctx,
-			struct iocb __user *user_iocb, struct iocb *iocb));
+extern int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
+			 struct iocb *iocb);
 
 /* semi private, but used by the 32bit emulations: */
 struct kioctx *lookup_ioctx(unsigned long ctx_id);
-int FASTCALL(io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
-				  struct iocb *iocb));
+int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
+		  struct iocb *iocb);
 
 #define get_ioctx(kioctx) do {						\
 	BUG_ON(atomic_read(&(kioctx)->users) <= 0);			\
diff -puN include/linux/buffer_head.h~include-linux-remove-all-users-of-fastcall-macro include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~include-linux-remove-all-users-of-fastcall-macro
+++ a/include/linux/buffer_head.h
@@ -144,7 +144,7 @@ BUFFER_FNS(Unwritten, unwritten)
  * Declarations
  */
 
-void FASTCALL(mark_buffer_dirty(struct buffer_head *bh));
+void mark_buffer_dirty(struct buffer_head *bh);
 void init_buffer(struct buffer_head *, bh_end_io_t *, void *);
 void set_bh_page(struct buffer_head *bh,
 		struct page *page, unsigned long offset);
@@ -185,8 +185,8 @@ struct buffer_head *__bread(struct block
 void invalidate_bh_lrus(void);
 struct buffer_head *alloc_buffer_head(gfp_t gfp_flags);
 void free_buffer_head(struct buffer_head * bh);
-void FASTCALL(unlock_buffer(struct buffer_head *bh));
-void FASTCALL(__lock_buffer(struct buffer_head *bh));
+void unlock_buffer(struct buffer_head *bh);
+void __lock_buffer(struct buffer_head *bh);
 void ll_rw_block(int, int, struct buffer_head * bh[]);
 int sync_dirty_buffer(struct buffer_head *bh);
 int submit_bh(int, struct buffer_head *);
diff -puN include/linux/file.h~include-linux-remove-all-users-of-fastcall-macro include/linux/file.h
--- a/include/linux/file.h~include-linux-remove-all-users-of-fastcall-macro
+++ a/include/linux/file.h
@@ -59,8 +59,8 @@ struct files_struct {
 
 extern struct kmem_cache *filp_cachep;
 
-extern void FASTCALL(__fput(struct file *));
-extern void FASTCALL(fput(struct file *));
+extern void __fput(struct file *);
+extern void fput(struct file *);
 
 struct file_operations;
 struct vfsmount;
@@ -77,13 +77,13 @@ static inline void fput_light(struct fil
 		fput(file);
 }
 
-extern struct file * FASTCALL(fget(unsigned int fd));
-extern struct file * FASTCALL(fget_light(unsigned int fd, int *fput_needed));
-extern void FASTCALL(set_close_on_exec(unsigned int fd, int flag));
+extern struct file *fget(unsigned int fd);
+extern struct file *fget_light(unsigned int fd, int *fput_needed);
+extern void set_close_on_exec(unsigned int fd, int flag);
 extern void put_filp(struct file *);
 extern int get_unused_fd(void);
 extern int get_unused_fd_flags(int flags);
-extern void FASTCALL(put_unused_fd(unsigned int fd));
+extern void put_unused_fd(unsigned int fd);
 struct kmem_cache;
 
 extern int expand_files(struct files_struct *, int nr);
@@ -110,12 +110,12 @@ static inline struct file * fcheck_files
  */
 #define fcheck(fd)	fcheck_files(current->files, fd)
 
-extern void FASTCALL(fd_install(unsigned int fd, struct file * file));
+extern void fd_install(unsigned int fd, struct file *file);
 
 struct task_struct;
 
 struct files_struct *get_files_struct(struct task_struct *);
-void FASTCALL(put_files_struct(struct files_struct *fs));
+void put_files_struct(struct files_struct *fs);
 void reset_files_struct(struct task_struct *, struct files_struct *);
 
 extern struct kmem_cache *files_cachep;
diff -puN include/linux/gfp.h~include-linux-remove-all-users-of-fastcall-macro include/linux/gfp.h
--- a/include/linux/gfp.h~include-linux-remove-all-users-of-fastcall-macro
+++ a/include/linux/gfp.h
@@ -172,8 +172,7 @@ static inline void arch_free_page(struct
 static inline void arch_alloc_page(struct page *page, int order) { }
 #endif
 
-extern struct page *
-FASTCALL(__alloc_pages(gfp_t, unsigned int, struct zonelist *));
+extern struct page *__alloc_pages(gfp_t, unsigned int, struct zonelist *);
 
 static inline struct page *alloc_pages_node(int nid, gfp_t gfp_mask,
 						unsigned int order)
@@ -209,8 +208,8 @@ extern struct page *alloc_page_vma(gfp_t
 #endif
 #define alloc_page(gfp_mask) alloc_pages(gfp_mask, 0)
 
-extern unsigned long FASTCALL(__get_free_pages(gfp_t gfp_mask, unsigned int order));
-extern unsigned long FASTCALL(get_zeroed_page(gfp_t gfp_mask));
+extern unsigned long __get_free_pages(gfp_t gfp_mask, unsigned int order);
+extern unsigned long get_zeroed_page(gfp_t gfp_mask);
 
 #define __get_free_page(gfp_mask) \
 		__get_free_pages((gfp_mask),0)
@@ -218,10 +217,10 @@ extern unsigned long FASTCALL(get_zeroed
 #define __get_dma_pages(gfp_mask, order) \
 		__get_free_pages((gfp_mask) | GFP_DMA,(order))
 
-extern void FASTCALL(__free_pages(struct page *page, unsigned int order));
-extern void FASTCALL(free_pages(unsigned long addr, unsigned int order));
-extern void FASTCALL(free_hot_page(struct page *page));
-extern void FASTCALL(free_cold_page(struct page *page));
+extern void __free_pages(struct page *page, unsigned int order);
+extern void free_pages(unsigned long addr, unsigned int order);
+extern void free_hot_page(struct page *page);
+extern void free_cold_page(struct page *page);
 
 #define __free_page(page) __free_pages((page), 0)
 #define free_page(addr) free_pages((addr),0)
diff -puN include/linux/interrupt.h~include-linux-remove-all-users-of-fastcall-macro include/linux/interrupt.h
--- a/include/linux/interrupt.h~include-linux-remove-all-users-of-fastcall-macro
+++ a/include/linux/interrupt.h
@@ -273,8 +273,8 @@ asmlinkage void do_softirq(void);
 extern void open_softirq(int nr, void (*action)(struct softirq_action*), void *data);
 extern void softirq_init(void);
 #define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)
-extern void FASTCALL(raise_softirq_irqoff(unsigned int nr));
-extern void FASTCALL(raise_softirq(unsigned int nr));
+extern void raise_softirq_irqoff(unsigned int nr);
+extern void raise_softirq(unsigned int nr);
 
 
 /* Tasklets --- multithreaded analogue of BHs.
@@ -341,7 +341,7 @@ static inline void tasklet_unlock_wait(s
 #define tasklet_unlock(t) do { } while (0)
 #endif
 
-extern void FASTCALL(__tasklet_schedule(struct tasklet_struct *t));
+extern void __tasklet_schedule(struct tasklet_struct *t);
 
 static inline void tasklet_schedule(struct tasklet_struct *t)
 {
@@ -349,7 +349,7 @@ static inline void tasklet_schedule(stru
 		__tasklet_schedule(t);
 }
 
-extern void FASTCALL(__tasklet_hi_schedule(struct tasklet_struct *t));
+extern void __tasklet_hi_schedule(struct tasklet_struct *t);
 
 static inline void tasklet_hi_schedule(struct tasklet_struct *t)
 {
diff -puN include/linux/mm.h~include-linux-remove-all-users-of-fastcall-macro include/linux/mm.h
--- a/include/linux/mm.h~include-linux-remove-all-users-of-fastcall-macro
+++ a/include/linux/mm.h
@@ -786,7 +786,7 @@ int __set_page_dirty_nobuffers(struct pa
 int __set_page_dirty_no_writeback(struct page *page);
 int redirty_page_for_writepage(struct writeback_control *wbc,
 				struct page *page);
-int FASTCALL(set_page_dirty(struct page *page));
+int set_page_dirty(struct page *page);
 int set_page_dirty_lock(struct page *page);
 int clear_page_dirty_for_io(struct page *page);
 
@@ -829,7 +829,7 @@ extern void unregister_shrinker(struct s
 
 int vma_wants_writenotify(struct vm_area_struct *vma);
 
-extern pte_t *FASTCALL(get_locked_pte(struct mm_struct *mm, unsigned long addr, spinlock_t **ptl));
+extern pte_t *get_locked_pte(struct mm_struct *mm, unsigned long addr, spinlock_t **ptl);
 
 #ifdef __PAGETABLE_PUD_FOLDED
 static inline int __pud_alloc(struct mm_struct *mm, pgd_t *pgd,
diff -puN include/linux/mutex-debug.h~include-linux-remove-all-users-of-fastcall-macro include/linux/mutex-debug.h
--- a/include/linux/mutex-debug.h~include-linux-remove-all-users-of-fastcall-macro
+++ a/include/linux/mutex-debug.h
@@ -18,6 +18,6 @@ do {									\
 	__mutex_init((mutex), #mutex, &__key);				\
 } while (0)
 
-extern void FASTCALL(mutex_destroy(struct mutex *lock));
+extern void mutex_destroy(struct mutex *lock);
 
 #endif
diff -puN include/linux/namei.h~include-linux-remove-all-users-of-fastcall-macro include/linux/namei.h
--- a/include/linux/namei.h~include-linux-remove-all-users-of-fastcall-macro
+++ a/include/linux/namei.h
@@ -62,13 +62,13 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LA
 #define LOOKUP_ACCESS		(0x0400)
 #define LOOKUP_CHDIR		(0x0800)
 
-extern int FASTCALL(__user_walk(const char __user *, unsigned, struct nameidata *));
-extern int FASTCALL(__user_walk_fd(int dfd, const char __user *, unsigned, struct nameidata *));
+extern int __user_walk(const char __user *, unsigned, struct nameidata *);
+extern int __user_walk_fd(int dfd, const char __user *, unsigned, struct nameidata *);
 #define user_path_walk(name,nd) \
 	__user_walk_fd(AT_FDCWD, name, LOOKUP_FOLLOW, nd)
 #define user_path_walk_link(name,nd) \
 	__user_walk_fd(AT_FDCWD, name, 0, nd)
-extern int FASTCALL(path_lookup(const char *, unsigned, struct nameidata *));
+extern int path_lookup(const char *, unsigned, struct nameidata *);
 extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
 			   const char *, unsigned int, struct nameidata *);
 extern void path_release(struct nameidata *);
diff -puN include/linux/netdevice.h~include-linux-remove-all-users-of-fastcall-macro include/linux/netdevice.h
--- a/include/linux/netdevice.h~include-linux-remove-all-users-of-fastcall-macro
+++ a/include/linux/netdevice.h
@@ -322,7 +322,7 @@ enum
 	NAPI_STATE_DISABLE,	/* Disable pending */
 };
 
-extern void FASTCALL(__napi_schedule(struct napi_struct *n));
+extern void __napi_schedule(struct napi_struct *n);
 
 static inline int napi_disable_pending(struct napi_struct *n)
 {
diff -puN include/linux/pagemap.h~include-linux-remove-all-users-of-fastcall-macro include/linux/pagemap.h
--- a/include/linux/pagemap.h~include-linux-remove-all-users-of-fastcall-macro
+++ a/include/linux/pagemap.h
@@ -156,10 +156,10 @@ static inline pgoff_t linear_page_index(
 	return pgoff >> (PAGE_CACHE_SHIFT - PAGE_SHIFT);
 }
 
-extern void FASTCALL(__lock_page(struct page *page));
-extern int FASTCALL(__lock_page_killable(struct page *page));
-extern void FASTCALL(__lock_page_nosync(struct page *page));
-extern void FASTCALL(unlock_page(struct page *page));
+extern void __lock_page(struct page *page);
+extern int __lock_page_killable(struct page *page);
+extern void __lock_page_nosync(struct page *page);
+extern void unlock_page(struct page *page);
 
 /*
  * lock_page may only be called if we have the page's inode pinned.
@@ -199,7 +199,7 @@ static inline void lock_page_nosync(stru
  * This is exported only for wait_on_page_locked/wait_on_page_writeback.
  * Never use this directly!
  */
-extern void FASTCALL(wait_on_page_bit(struct page *page, int bit_nr));
+extern void wait_on_page_bit(struct page *page, int bit_nr);
 
 /* 
  * Wait for a page to be unlocked.
diff -puN include/linux/pid.h~include-linux-remove-all-users-of-fastcall-macro include/linux/pid.h
--- a/include/linux/pid.h~include-linux-remove-all-users-of-fastcall-macro
+++ a/include/linux/pid.h
@@ -79,10 +79,9 @@ static inline struct pid *get_pid(struct
 	return pid;
 }
 
-extern void FASTCALL(put_pid(struct pid *pid));
-extern struct task_struct *FASTCALL(pid_task(struct pid *pid, enum pid_type));
-extern struct task_struct *FASTCALL(get_pid_task(struct pid *pid,
-						enum pid_type));
+extern void put_pid(struct pid *pid);
+extern struct task_struct *pid_task(struct pid *pid, enum pid_type);
+extern struct task_struct *get_pid_task(struct pid *pid, enum pid_type);
 
 extern struct pid *get_task_pid(struct task_struct *task, enum pid_type type);
 
@@ -90,11 +89,11 @@ extern struct pid *get_task_pid(struct t
  * attach_pid() and detach_pid() must be called with the tasklist_lock
  * write-held.
  */
-extern int FASTCALL(attach_pid(struct task_struct *task,
-				enum pid_type type, struct pid *pid));
-extern void FASTCALL(detach_pid(struct task_struct *task, enum pid_type));
-extern void FASTCALL(transfer_pid(struct task_struct *old,
-				  struct task_struct *new, enum pid_type));
+extern int attach_pid(struct task_struct *task, enum pid_type type,
+		      struct pid *pid);
+extern void detach_pid(struct task_struct *task, enum pid_type);
+extern void transfer_pid(struct task_struct *old, struct task_struct *new,
+			 enum pid_type);
 
 struct pid_namespace;
 extern struct pid_namespace init_pid_ns;
@@ -109,7 +108,7 @@ extern struct pid_namespace init_pid_ns;
  *
  * see also find_task_by_pid() set in include/linux/sched.h
  */
-extern struct pid *FASTCALL(find_pid_ns(int nr, struct pid_namespace *ns));
+extern struct pid *find_pid_ns(int nr, struct pid_namespace *ns);
 extern struct pid *find_vpid(int nr);
 extern struct pid *find_pid(int nr);
 
@@ -121,7 +120,7 @@ extern struct pid *find_ge_pid(int nr, s
 int next_pidmap(struct pid_namespace *pid_ns, int last);
 
 extern struct pid *alloc_pid(struct pid_namespace *ns);
-extern void FASTCALL(free_pid(struct pid *pid));
+extern void free_pid(struct pid *pid);
 
 /*
  * the helpers to get the pid's id seen from different namespaces
diff -puN include/linux/rwsem-spinlock.h~include-linux-remove-all-users-of-fastcall-macro include/linux/rwsem-spinlock.h
--- a/include/linux/rwsem-spinlock.h~include-linux-remove-all-users-of-fastcall-macro
+++ a/include/linux/rwsem-spinlock.h
@@ -60,14 +60,14 @@ do {								\
 	__init_rwsem((sem), #sem, &__key);			\
 } while (0)
 
-extern void FASTCALL(__down_read(struct rw_semaphore *sem));
-extern int FASTCALL(__down_read_trylock(struct rw_semaphore *sem));
-extern void FASTCALL(__down_write(struct rw_semaphore *sem));
-extern void FASTCALL(__down_write_nested(struct rw_semaphore *sem, int subclass));
-extern int FASTCALL(__down_write_trylock(struct rw_semaphore *sem));
-extern void FASTCALL(__up_read(struct rw_semaphore *sem));
-extern void FASTCALL(__up_write(struct rw_semaphore *sem));
-extern void FASTCALL(__downgrade_write(struct rw_semaphore *sem));
+extern void __down_read(struct rw_semaphore *sem);
+extern int __down_read_trylock(struct rw_semaphore *sem);
+extern void __down_write(struct rw_semaphore *sem);
+extern void __down_write_nested(struct rw_semaphore *sem, int subclass);
+extern int __down_write_trylock(struct rw_semaphore *sem);
+extern void __up_read(struct rw_semaphore *sem);
+extern void __up_write(struct rw_semaphore *sem);
+extern void __downgrade_write(struct rw_semaphore *sem);
 
 static inline int rwsem_is_locked(struct rw_semaphore *sem)
 {
diff -puN include/linux/sched.h~include-linux-remove-all-users-of-fastcall-macro include/linux/sched.h
--- a/include/linux/sched.h~include-linux-remove-all-users-of-fastcall-macro
+++ a/include/linux/sched.h
@@ -323,7 +323,7 @@ extern char __sched_text_start[], __sche
 extern int in_sched_functions(unsigned long addr);
 
 #define	MAX_SCHEDULE_TIMEOUT	LONG_MAX
-extern signed long FASTCALL(schedule_timeout(signed long timeout));
+extern signed long schedule_timeout(signed long timeout);
 extern signed long schedule_timeout_interruptible(signed long timeout);
 extern signed long schedule_timeout_killable(signed long timeout);
 extern signed long schedule_timeout_uninterruptible(signed long timeout);
@@ -1648,10 +1648,10 @@ extern void release_uids(struct user_nam
 
 extern void do_timer(unsigned long ticks);
 
-extern int FASTCALL(wake_up_state(struct task_struct * tsk, unsigned int state));
-extern int FASTCALL(wake_up_process(struct task_struct * tsk));
-extern void FASTCALL(wake_up_new_task(struct task_struct * tsk,
-						unsigned long clone_flags));
+extern int wake_up_state(struct task_struct *tsk, unsigned int state);
+extern int wake_up_process(struct task_struct *tsk);
+extern void wake_up_new_task(struct task_struct *tsk,
+				unsigned long clone_flags);
 #ifdef CONFIG_SMP
  extern void kick_process(struct task_struct *tsk);
 #else
@@ -1741,7 +1741,7 @@ static inline int sas_ss_flags(unsigned 
 extern struct mm_struct * mm_alloc(void);
 
 /* mmdrop drops the mm and the page tables */
-extern void FASTCALL(__mmdrop(struct mm_struct *));
+extern void __mmdrop(struct mm_struct *);
 static inline void mmdrop(struct mm_struct * mm)
 {
 	if (unlikely(atomic_dec_and_test(&mm->mm_count)))
@@ -1925,7 +1925,7 @@ static inline int signal_pending(struct 
 	return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
 }
 
-extern int FASTCALL(__fatal_signal_pending(struct task_struct *p));
+extern int __fatal_signal_pending(struct task_struct *p);
 
 static inline int fatal_signal_pending(struct task_struct *p)
 {
diff -puN include/linux/swap.h~include-linux-remove-all-users-of-fastcall-macro include/linux/swap.h
--- a/include/linux/swap.h~include-linux-remove-all-users-of-fastcall-macro
+++ a/include/linux/swap.h
@@ -171,10 +171,10 @@ extern unsigned int nr_free_pagecache_pa
 
 
 /* linux/mm/swap.c */
-extern void FASTCALL(lru_cache_add(struct page *));
-extern void FASTCALL(lru_cache_add_active(struct page *));
-extern void FASTCALL(activate_page(struct page *));
-extern void FASTCALL(mark_page_accessed(struct page *));
+extern void lru_cache_add(struct page *);
+extern void lru_cache_add_active(struct page *);
+extern void activate_page(struct page *);
+extern void mark_page_accessed(struct page *);
 extern void lru_add_drain(void);
 extern int lru_add_drain_all(void);
 extern int rotate_reclaimable_page(struct page *page);
diff -puN include/linux/wait.h~include-linux-remove-all-users-of-fastcall-macro include/linux/wait.h
--- a/include/linux/wait.h~include-linux-remove-all-users-of-fastcall-macro
+++ a/include/linux/wait.h
@@ -117,9 +117,9 @@ static inline int waitqueue_active(wait_
  */
 #define is_sync_wait(wait)	(!(wait) || ((wait)->private))
 
-extern void FASTCALL(add_wait_queue(wait_queue_head_t *q, wait_queue_t * wait));
-extern void FASTCALL(add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t * wait));
-extern void FASTCALL(remove_wait_queue(wait_queue_head_t *q, wait_queue_t * wait));
+extern void add_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);
+extern void add_wait_queue_exclusive(wait_queue_head_t *q, wait_queue_t *wait);
+extern void remove_wait_queue(wait_queue_head_t *q, wait_queue_t *wait);
 
 static inline void __add_wait_queue(wait_queue_head_t *head, wait_queue_t *new)
 {
@@ -141,16 +141,16 @@ static inline void __remove_wait_queue(w
 	list_del(&old->task_list);
 }
 
-void FASTCALL(__wake_up(wait_queue_head_t *q, unsigned int mode, int nr, void *key));
-extern void FASTCALL(__wake_up_locked(wait_queue_head_t *q, unsigned int mode));
-extern void FASTCALL(__wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr));
-void FASTCALL(__wake_up_bit(wait_queue_head_t *, void *, int));
-int FASTCALL(__wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned));
-int FASTCALL(__wait_on_bit_lock(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned));
-void FASTCALL(wake_up_bit(void *, int));
-int FASTCALL(out_of_line_wait_on_bit(void *, int, int (*)(void *), unsigned));
-int FASTCALL(out_of_line_wait_on_bit_lock(void *, int, int (*)(void *), unsigned));
-wait_queue_head_t *FASTCALL(bit_waitqueue(void *, int));
+void __wake_up(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
+extern void __wake_up_locked(wait_queue_head_t *q, unsigned int mode);
+extern void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
+void __wake_up_bit(wait_queue_head_t *, void *, int);
+int __wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
+int __wait_on_bit_lock(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
+void wake_up_bit(void *, int);
+int out_of_line_wait_on_bit(void *, int, int (*)(void *), unsigned);
+int out_of_line_wait_on_bit_lock(void *, int, int (*)(void *), unsigned);
+wait_queue_head_t *bit_waitqueue(void *, int);
 
 #define wake_up(x)			__wake_up(x, TASK_NORMAL, 1, NULL)
 #define wake_up_nr(x, nr)		__wake_up(x, TASK_NORMAL, nr, NULL)
@@ -437,11 +437,9 @@ extern long interruptible_sleep_on_timeo
 /*
  * Waitqueues which are removed from the waitqueue_head at wakeup time
  */
-void FASTCALL(prepare_to_wait(wait_queue_head_t *q,
-				wait_queue_t *wait, int state));
-void FASTCALL(prepare_to_wait_exclusive(wait_queue_head_t *q,
-				wait_queue_t *wait, int state));
-void FASTCALL(finish_wait(wait_queue_head_t *q, wait_queue_t *wait));
+void prepare_to_wait(wait_queue_head_t *q, wait_queue_t *wait, int state);
+void prepare_to_wait_exclusive(wait_queue_head_t *q, wait_queue_t *wait, int state);
+void finish_wait(wait_queue_head_t *q, wait_queue_t *wait);
 int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
 int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
 
diff -puN include/linux/workqueue.h~include-linux-remove-all-users-of-fastcall-macro include/linux/workqueue.h
--- a/include/linux/workqueue.h~include-linux-remove-all-users-of-fastcall-macro
+++ a/include/linux/workqueue.h
@@ -178,18 +178,17 @@ __create_workqueue_key(const char *name,
 
 extern void destroy_workqueue(struct workqueue_struct *wq);
 
-extern int FASTCALL(queue_work(struct workqueue_struct *wq, struct work_struct *work));
-extern int FASTCALL(queue_delayed_work(struct workqueue_struct *wq,
-			struct delayed_work *work, unsigned long delay));
+extern int queue_work(struct workqueue_struct *wq, struct work_struct *work);
+extern int queue_delayed_work(struct workqueue_struct *wq,
+			struct delayed_work *work, unsigned long delay);
 extern int queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 			struct delayed_work *work, unsigned long delay);
 
-extern void FASTCALL(flush_workqueue(struct workqueue_struct *wq));
+extern void flush_workqueue(struct workqueue_struct *wq);
 extern void flush_scheduled_work(void);
 
-extern int FASTCALL(schedule_work(struct work_struct *work));
-extern int FASTCALL(schedule_delayed_work(struct delayed_work *work,
-					unsigned long delay));
+extern int schedule_work(struct work_struct *work);
+extern int schedule_delayed_work(struct delayed_work *work, unsigned long delay);
 extern int schedule_delayed_work_on(int cpu, struct delayed_work *work,
 					unsigned long delay);
 extern int schedule_on_each_cpu(work_func_t func);
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
inotify-make-variables-static-in-inotify_userc.patch
kernel-doc-remove-fastcall.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ubi-fix-sparse-errors-in-ubih.patch
x86-remove-pt_regs-arg-from-smp_thermal_interrupt.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
jbd-sparse-warnings-in-revokec-journalc.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
