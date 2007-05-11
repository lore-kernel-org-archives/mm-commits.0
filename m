From: akpm@linux-foundation.org
Subject: - introduce-freezer-flags-rev-2.patch removed from -mm tree
Date: Fri, 11 May 2007 12:29:31 -0700
Message-ID: <200705111929.l4BJTVM3024597@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759873AbXEKTby (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 May 2007 15:31:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, James.Bottomley@steeleye.com, ak@suse.de, benh@kernel.crashing.org, dhowells@redhat.com, drzeus@drzeus.cx, dwmw2@infradead.org, ego@in.ibm.com, greg@kroah.com, lethal@linux-sh.org, mingo@elte.hu, neilb@suse.de, oleg@tv-sign.ru, paulus@samba.org, pavel@ucw.cz, penberg@cs.helsinki.fi, ralf@linux-mips.org, stefanr@s5r6.in-berlin.de, mm-commits@vger.kernel.org


The patch titled
     Introduce freezer flags
has been removed from the -mm tree.  Its filename was
     introduce-freezer-flags-rev-2.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Introduce freezer flags
From: Rafael J. Wysocki <rjw@sisk.pl>

Move all of the freezer-related flags to a separate field in task_struct and
introduce functions to operate them using set_bit() etc.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Neil Brown <neilb@suse.de>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/power/kernel_threads.txt |    2 
 Documentation/power/swsusp.txt         |    4 -
 arch/i386/kernel/apm.c                 |    2 
 drivers/block/loop.c                   |    2 
 drivers/char/apm-emulation.c           |    6 +-
 drivers/ieee1394/ieee1394_core.c       |    2 
 drivers/md/md.c                        |    2 
 drivers/mmc/card/queue.c               |    3 -
 drivers/mtd/mtd_blkdevs.c              |    3 -
 drivers/scsi/libsas/sas_scsi_host.c    |    3 -
 drivers/scsi/scsi_error.c              |    2 
 drivers/usb/storage/usb.c              |    2 
 include/asm-arm/thread_info.h          |    2 
 include/asm-blackfin/thread_info.h     |    2 
 include/asm-frv/thread_info.h          |    2 
 include/asm-i386/thread_info.h         |    2 
 include/asm-ia64/thread_info.h         |    2 
 include/asm-mips/thread_info.h         |    2 
 include/asm-powerpc/thread_info.h      |    2 
 include/asm-sh/thread_info.h           |    2 
 include/asm-x86_64/thread_info.h       |    2 
 include/linux/freezer.h                |   63 ++++++++++++++++++-----
 include/linux/sched.h                  |    8 +-
 kernel/fork.c                          |    5 +
 kernel/freezer.c                       |   10 +--
 kernel/kthread.c                       |    3 -
 kernel/rcutorture.c                    |    4 -
 kernel/sched.c                         |    2 
 kernel/softirq.c                       |    2 
 kernel/softlockup.c                    |    2 
 kernel/workqueue.c                     |    2 
 31 files changed, 90 insertions(+), 62 deletions(-)

diff -puN Documentation/power/kernel_threads.txt~introduce-freezer-flags-rev-2 Documentation/power/kernel_threads.txt
--- a/Documentation/power/kernel_threads.txt~introduce-freezer-flags-rev-2
+++ a/Documentation/power/kernel_threads.txt
@@ -32,7 +32,7 @@ like this:
 	 */
 	daemonize("usb-storage");
 
-	current->flags |= PF_NOFREEZE;
+	freezer_exempt(current);
 
 from drivers/usb/storage/usb.c::usb_stor_control_thread()
 
diff -puN Documentation/power/swsusp.txt~introduce-freezer-flags-rev-2 Documentation/power/swsusp.txt
--- a/Documentation/power/swsusp.txt~introduce-freezer-flags-rev-2
+++ a/Documentation/power/swsusp.txt
@@ -152,8 +152,8 @@ add:
        try_to_freeze();
 
 If the thread is needed for writing the image to storage, you should
-instead set the PF_NOFREEZE process flag when creating the thread (and
-be very careful).
+instead use freezer_exempt() to mark the thread as nonfreezable when creating
+it (and be very careful).
 
 
 Q: What is the difference between "platform" and "shutdown"?
diff -puN arch/i386/kernel/apm.c~introduce-freezer-flags-rev-2 arch/i386/kernel/apm.c
--- a/arch/i386/kernel/apm.c~introduce-freezer-flags-rev-2
+++ a/arch/i386/kernel/apm.c
@@ -2313,7 +2313,7 @@ static int __init apm_init(void)
 		remove_proc_entry("apm", NULL);
 		return err;
 	}
-	kapmd_task->flags |= PF_NOFREEZE;
+	freezer_exempt(kapmd_task);
 	wake_up_process(kapmd_task);
 
 	if (num_online_cpus() > 1 && !smp ) {
diff -puN drivers/block/loop.c~introduce-freezer-flags-rev-2 drivers/block/loop.c
--- a/drivers/block/loop.c~introduce-freezer-flags-rev-2
+++ a/drivers/block/loop.c
@@ -582,7 +582,7 @@ static int loop_thread(void *data)
 	 * hence, it mustn't be stopped at all
 	 * because it could be indirectly used during suspension
 	 */
-	current->flags |= PF_NOFREEZE;
+	freezer_exempt(current);
 
 	set_user_nice(current, -20);
 
diff -puN drivers/char/apm-emulation.c~introduce-freezer-flags-rev-2 drivers/char/apm-emulation.c
--- a/drivers/char/apm-emulation.c~introduce-freezer-flags-rev-2
+++ a/drivers/char/apm-emulation.c
@@ -336,7 +336,7 @@ apm_ioctl(struct inode * inode, struct f
 			 * threads.
 			 */
 			flags = current->flags;
-			current->flags |= PF_NOFREEZE;
+			freezer_exempt(current);
 
 			wait_event(apm_suspend_waitqueue,
 				   as->suspend_state == SUSPEND_DONE);
@@ -372,7 +372,7 @@ apm_ioctl(struct inode * inode, struct f
 			 * threads.
 			 */
 			flags = current->flags;
-			current->flags |= PF_NOFREEZE;
+			freezer_exempt(current);
 
 			wait_event_interruptible(apm_suspend_waitqueue,
 					 as->suspend_state == SUSPEND_DONE);
@@ -601,7 +601,7 @@ static int __init apm_init(void)
 		kapmd_tsk = NULL;
 		return ret;
 	}
-	kapmd_tsk->flags |= PF_NOFREEZE;
+	freezer_exempt(kapmd_tsk);
 	wake_up_process(kapmd_tsk);
 
 #ifdef CONFIG_PROC_FS
diff -puN drivers/ieee1394/ieee1394_core.c~introduce-freezer-flags-rev-2 drivers/ieee1394/ieee1394_core.c
--- a/drivers/ieee1394/ieee1394_core.c~introduce-freezer-flags-rev-2
+++ a/drivers/ieee1394/ieee1394_core.c
@@ -1134,7 +1134,7 @@ static int hpsbpkt_thread(void *__hi)
 	struct list_head tmp;
 	int may_schedule;
 
-	current->flags |= PF_NOFREEZE;
+	freezer_exempt(current);
 
 	while (!kthread_should_stop()) {
 
diff -puN drivers/md/md.c~introduce-freezer-flags-rev-2 drivers/md/md.c
--- a/drivers/md/md.c~introduce-freezer-flags-rev-2
+++ a/drivers/md/md.c
@@ -4634,7 +4634,7 @@ static int md_thread(void * arg)
 	 * many dirty RAID5 blocks.
 	 */
 
-	current->flags |= PF_NOFREEZE;
+	freezer_exempt(current);
 	allow_signal(SIGKILL);
 	while (!kthread_should_stop()) {
 
diff -puN drivers/mmc/card/queue.c~introduce-freezer-flags-rev-2 drivers/mmc/card/queue.c
--- a/drivers/mmc/card/queue.c~introduce-freezer-flags-rev-2
+++ a/drivers/mmc/card/queue.c
@@ -66,7 +66,8 @@ static int mmc_queue_thread(void *d)
 	 * Set iothread to ensure that we aren't put to sleep by
 	 * the process freezing.  We handle suspension ourselves.
 	 */
-	current->flags |= PF_MEMALLOC|PF_NOFREEZE;
+	current->flags |= PF_MEMALLOC;
+	freezer_exempt(current);
 
 	down(&mq->thread_sem);
 	do {
diff -puN drivers/mtd/mtd_blkdevs.c~introduce-freezer-flags-rev-2 drivers/mtd/mtd_blkdevs.c
--- a/drivers/mtd/mtd_blkdevs.c~introduce-freezer-flags-rev-2
+++ a/drivers/mtd/mtd_blkdevs.c
@@ -81,7 +81,8 @@ static int mtd_blktrans_thread(void *arg
 	struct request_queue *rq = tr->blkcore_priv->rq;
 
 	/* we might get involved when memory gets low, so use PF_MEMALLOC */
-	current->flags |= PF_MEMALLOC | PF_NOFREEZE;
+	current->flags |= PF_MEMALLOC;
+	freezer_exempt(current);
 
 	spin_lock_irq(rq->queue_lock);
 	while (!kthread_should_stop()) {
diff -puN drivers/scsi/libsas/sas_scsi_host.c~introduce-freezer-flags-rev-2 drivers/scsi/libsas/sas_scsi_host.c
--- a/drivers/scsi/libsas/sas_scsi_host.c~introduce-freezer-flags-rev-2
+++ a/drivers/scsi/libsas/sas_scsi_host.c
@@ -904,8 +904,7 @@ static int sas_queue_thread(void *_sas_h
 {
 	struct sas_ha_struct *sas_ha = _sas_ha;
 
-	current->flags |= PF_NOFREEZE;
-
+	freezer_exempt(current);
 	while (1) {
 		try_to_freeze();
 		set_current_state(TASK_INTERRUPTIBLE);
diff -puN drivers/scsi/scsi_error.c~introduce-freezer-flags-rev-2 drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c~introduce-freezer-flags-rev-2
+++ a/drivers/scsi/scsi_error.c
@@ -1537,7 +1537,7 @@ int scsi_error_handler(void *data)
 {
 	struct Scsi_Host *shost = data;
 
-	current->flags |= PF_NOFREEZE;
+	freezer_exempt(current);
 
 	/*
 	 * We use TASK_INTERRUPTIBLE so that the thread is not
diff -puN drivers/usb/storage/usb.c~introduce-freezer-flags-rev-2 drivers/usb/storage/usb.c
--- a/drivers/usb/storage/usb.c~introduce-freezer-flags-rev-2
+++ a/drivers/usb/storage/usb.c
@@ -301,7 +301,7 @@ static int usb_stor_control_thread(void 
 	struct us_data *us = (struct us_data *)__us;
 	struct Scsi_Host *host = us_to_host(us);
 
-	current->flags |= PF_NOFREEZE;
+	freezer_exempt(current);
 
 	for(;;) {
 		try_to_freeze();
diff -puN include/asm-arm/thread_info.h~introduce-freezer-flags-rev-2 include/asm-arm/thread_info.h
--- a/include/asm-arm/thread_info.h~introduce-freezer-flags-rev-2
+++ a/include/asm-arm/thread_info.h
@@ -148,7 +148,6 @@ extern void iwmmxt_task_switch(struct th
 #define TIF_POLLING_NRFLAG	16
 #define TIF_USING_IWMMXT	17
 #define TIF_MEMDIE		18
-#define TIF_FREEZE		19
 
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
@@ -156,7 +155,6 @@ extern void iwmmxt_task_switch(struct th
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_USING_IWMMXT	(1 << TIF_USING_IWMMXT)
-#define _TIF_FREEZE		(1 << TIF_FREEZE)
 
 /*
  * Change these and you break ASM code in entry-common.S
diff -puN include/asm-blackfin/thread_info.h~introduce-freezer-flags-rev-2 include/asm-blackfin/thread_info.h
--- a/include/asm-blackfin/thread_info.h~introduce-freezer-flags-rev-2
+++ a/include/asm-blackfin/thread_info.h
@@ -125,7 +125,6 @@ static inline struct thread_info *curren
 					   TIF_NEED_RESCHED */
 #define TIF_MEMDIE              5
 #define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
-#define TIF_FREEZE              7       /* is freezing for suspend */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -134,7 +133,6 @@ static inline struct thread_info *curren
 #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
-#define _TIF_FREEZE             (1<<TIF_FREEZE)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 
diff -puN include/asm-frv/thread_info.h~introduce-freezer-flags-rev-2 include/asm-frv/thread_info.h
--- a/include/asm-frv/thread_info.h~introduce-freezer-flags-rev-2
+++ a/include/asm-frv/thread_info.h
@@ -116,7 +116,6 @@ register struct thread_info *__current_t
 #define TIF_RESTORE_SIGMASK	6	/* restore signal mask in do_signal() */
 #define TIF_POLLING_NRFLAG	16	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		17	/* OOM killer killed process */
-#define TIF_FREEZE		18	/* freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
@@ -126,7 +125,6 @@ register struct thread_info *__current_t
 #define _TIF_IRET		(1 << TIF_IRET)
 #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
-#define _TIF_FREEZE		(1 << TIF_FREEZE)
 
 #define _TIF_WORK_MASK		0x0000FFFE	/* work to do on interrupt/exception return */
 #define _TIF_ALLWORK_MASK	0x0000FFFF	/* work to do on any return to u-space */
diff -puN include/asm-i386/thread_info.h~introduce-freezer-flags-rev-2 include/asm-i386/thread_info.h
--- a/include/asm-i386/thread_info.h~introduce-freezer-flags-rev-2
+++ a/include/asm-i386/thread_info.h
@@ -136,7 +136,6 @@ static inline struct thread_info *curren
 #define TIF_MEMDIE		16
 #define TIF_DEBUG		17	/* uses debug registers */
 #define TIF_IO_BITMAP		18	/* uses I/O bitmap */
-#define TIF_FREEZE		19	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
@@ -150,7 +149,6 @@ static inline struct thread_info *curren
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_DEBUG		(1<<TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
-#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
diff -puN include/asm-ia64/thread_info.h~introduce-freezer-flags-rev-2 include/asm-ia64/thread_info.h
--- a/include/asm-ia64/thread_info.h~introduce-freezer-flags-rev-2
+++ a/include/asm-ia64/thread_info.h
@@ -90,7 +90,6 @@ struct thread_info {
 #define TIF_MEMDIE		17
 #define TIF_MCA_INIT		18	/* this task is processing MCA or INIT */
 #define TIF_DB_DISABLED		19	/* debug trap disabled for fsyscall */
-#define TIF_FREEZE		20	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
@@ -103,7 +102,6 @@ struct thread_info {
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_MCA_INIT		(1 << TIF_MCA_INIT)
 #define _TIF_DB_DISABLED	(1 << TIF_DB_DISABLED)
-#define _TIF_FREEZE		(1 << TIF_FREEZE)
 
 /* "work to do on user-return" bits */
 #define TIF_ALLWORK_MASK	(_TIF_NOTIFY_RESUME|_TIF_SIGPENDING|_TIF_NEED_RESCHED|_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_RESTORE_SIGMASK)
diff -puN include/asm-mips/thread_info.h~introduce-freezer-flags-rev-2 include/asm-mips/thread_info.h
--- a/include/asm-mips/thread_info.h~introduce-freezer-flags-rev-2
+++ a/include/asm-mips/thread_info.h
@@ -118,7 +118,6 @@ register struct thread_info *__current_t
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		18
-#define TIF_FREEZE		19
 #define TIF_SYSCALL_TRACE	31	/* syscall trace active */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -130,7 +129,6 @@ register struct thread_info *__current_t
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
-#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK		(0x0000ffef & ~_TIF_SECCOMP)
diff -puN include/asm-powerpc/thread_info.h~introduce-freezer-flags-rev-2 include/asm-powerpc/thread_info.h
--- a/include/asm-powerpc/thread_info.h~introduce-freezer-flags-rev-2
+++ a/include/asm-powerpc/thread_info.h
@@ -122,7 +122,6 @@ static inline struct thread_info *curren
 #define TIF_RESTOREALL		12	/* Restore all regs (implies NOERROR) */
 #define TIF_NOERROR		14	/* Force successful syscall return */
 #define TIF_RESTORE_SIGMASK	15	/* Restore signal mask in do_signal */
-#define TIF_FREEZE		16	/* Freezing for suspend */
 
 /* as above, but as bit values */
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
@@ -139,7 +138,6 @@ static inline struct thread_info *curren
 #define _TIF_RESTOREALL		(1<<TIF_RESTOREALL)
 #define _TIF_NOERROR		(1<<TIF_NOERROR)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
-#define _TIF_FREEZE		(1<<TIF_FREEZE)
 #define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP)
 
 #define _TIF_USER_WORK_MASK	(_TIF_NOTIFY_RESUME | _TIF_SIGPENDING | \
diff -puN include/asm-sh/thread_info.h~introduce-freezer-flags-rev-2 include/asm-sh/thread_info.h
--- a/include/asm-sh/thread_info.h~introduce-freezer-flags-rev-2
+++ a/include/asm-sh/thread_info.h
@@ -115,7 +115,6 @@ static inline struct thread_info *curren
 #define TIF_USEDFPU		16	/* FPU was used by this task this quantum (SMP) */
 #define TIF_POLLING_NRFLAG	17	/* true if poll_idle() is polling TIF_NEED_RESCHED */
 #define TIF_MEMDIE		18
-#define TIF_FREEZE		19
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
@@ -125,7 +124,6 @@ static inline struct thread_info *curren
 #define _TIF_SINGLESTEP		(1<<TIF_SINGLESTEP)
 #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
 #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
-#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 #define _TIF_WORK_MASK		0x000000FE	/* work to do on interrupt/exception return */
 #define _TIF_ALLWORK_MASK	0x000000FF	/* work to do on any return to u-space */
diff -puN include/asm-x86_64/thread_info.h~introduce-freezer-flags-rev-2 include/asm-x86_64/thread_info.h
--- a/include/asm-x86_64/thread_info.h~introduce-freezer-flags-rev-2
+++ a/include/asm-x86_64/thread_info.h
@@ -123,7 +123,6 @@ static inline struct thread_info *stack_
 #define TIF_MEMDIE		20
 #define TIF_DEBUG		21	/* uses debug registers */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
-#define TIF_FREEZE		23	/* is freezing for suspend */
 
 #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
@@ -140,7 +139,6 @@ static inline struct thread_info *stack_
 #define _TIF_ABI_PENDING	(1<<TIF_ABI_PENDING)
 #define _TIF_DEBUG		(1<<TIF_DEBUG)
 #define _TIF_IO_BITMAP		(1<<TIF_IO_BITMAP)
-#define _TIF_FREEZE		(1<<TIF_FREEZE)
 
 /* work to do on interrupt/exception return */
 #define _TIF_WORK_MASK \
diff -puN include/linux/freezer.h~introduce-freezer-flags-rev-2 include/linux/freezer.h
--- a/include/linux/freezer.h~introduce-freezer-flags-rev-2
+++ a/include/linux/freezer.h
@@ -3,12 +3,33 @@
 #include <linux/sched.h>
 
 #ifdef CONFIG_FREEZER
+
+/*
+ *	Per task flags used by the freezer
+ *
+ *	They should not be referred to directly outside of this file.
+ */
+#define TFF_NOFREEZE	0	/* task should not be frozen */
+#define TFF_FREEZE	8	/* task should go to the refrigerator ASAP */
+#define TFF_SKIP	9	/* do not count this task as freezable */
+#define TFF_FROZEN	10	/* task is frozen */
+
 /*
  * Check if a process has been frozen
  */
 static inline int frozen(struct task_struct *p)
 {
-	return p->flags & PF_FROZEN;
+	return test_bit(TFF_FROZEN, &p->freezer_flags);
+}
+
+static inline void set_frozen_flag(struct task_struct *p)
+{
+	set_bit(TFF_FROZEN, &p->freezer_flags);
+}
+
+static inline void clear_frozen_flag(struct task_struct *p)
+{
+	clear_bit(TFF_FROZEN, &p->freezer_flags);
 }
 
 /*
@@ -16,7 +37,7 @@ static inline int frozen(struct task_str
  */
 static inline int freezing(struct task_struct *p)
 {
-	return test_tsk_thread_flag(p, TIF_FREEZE);
+	return test_bit(TFF_FREEZE, &p->freezer_flags);
 }
 
 /*
@@ -24,15 +45,31 @@ static inline int freezing(struct task_s
  */
 static inline void freeze(struct task_struct *p)
 {
-	set_tsk_thread_flag(p, TIF_FREEZE);
+	set_bit(TFF_FREEZE, &p->freezer_flags);
+}
+
+/*
+ * Cancel the previous 'freeze' request
+ */
+static inline void clear_freeze_flag(struct task_struct *p)
+{
+	clear_bit(TFF_FREEZE, &p->freezer_flags);
+}
+
+/*
+ * Check if the task wants to be exempted from freezing
+ */
+static inline int freezer_should_exempt(struct task_struct *p)
+{
+	return test_bit(TFF_NOFREEZE, &p->freezer_flags);
 }
 
 /*
- * Sometimes we may need to cancel the previous 'freeze' request
+ * Tell the freezer to exempt this task from freezing
  */
-static inline void do_not_freeze(struct task_struct *p)
+static inline void freezer_exempt(struct task_struct *p)
 {
-	clear_tsk_thread_flag(p, TIF_FREEZE);
+	set_bit(TFF_NOFREEZE, &p->freezer_flags);
 }
 
 /*
@@ -48,12 +85,12 @@ static inline int thaw_process(struct ta
 {
 	task_lock(p);
 	if (frozen(p)) {
-		p->flags &= ~PF_FROZEN;
+		clear_frozen_flag(p);
 		task_unlock(p);
 		wake_up_process(p);
 		return 1;
 	}
-	clear_tsk_thread_flag(p, TIF_FREEZE);
+	clear_freeze_flag(p);
 	task_unlock(p);
 	return 0;
 }
@@ -92,7 +129,7 @@ static inline int try_to_freeze(void)
 static inline void freezer_do_not_count(void)
 {
 	if (current->mm)
-		current->flags |= PF_FREEZER_SKIP;
+		set_bit(TFF_SKIP, &current->freezer_flags);
 }
 
 /*
@@ -102,7 +139,7 @@ static inline void freezer_do_not_count(
 static inline void freezer_count(void)
 {
 	if (current->mm) {
-		current->flags &= ~PF_FREEZER_SKIP;
+		clear_bit(TFF_SKIP, &current->freezer_flags);
 		try_to_freeze();
 	}
 }
@@ -112,13 +149,17 @@ static inline void freezer_count(void)
  */
 static inline int freezer_should_skip(struct task_struct *p)
 {
-	return !!(p->flags & PF_FREEZER_SKIP);
+	return test_bit(TFF_SKIP, &current->freezer_flags);
 }
 
 #else
 static inline int frozen(struct task_struct *p) { return 0; }
+static inline void set_frozen_flag(struct task_struct *p) {}
+static inline void clear_frozen_flag(struct task_struct *p) {}
 static inline int freezing(struct task_struct *p) { return 0; }
 static inline void freeze(struct task_struct *p) { BUG(); }
+static inline int freezer_should_exempt(struct task_struct *p) { return 0; }
+static inline void freezer_exempt(struct task_struct *p) {}
 static inline int thaw_process(struct task_struct *p) { return 1; }
 
 static inline void refrigerator(void) {}
diff -puN include/linux/sched.h~introduce-freezer-flags-rev-2 include/linux/sched.h
--- a/include/linux/sched.h~introduce-freezer-flags-rev-2
+++ a/include/linux/sched.h
@@ -983,7 +983,10 @@ struct task_struct {
 	/* Deadlock detection and priority inheritance handling */
 	struct rt_mutex_waiter *pi_blocked_on;
 #endif
-
+#ifdef CONFIG_FREEZER
+	/* Used by the process freezer, defined in freezer.h */
+	unsigned long freezer_flags;
+#endif
 #ifdef CONFIG_DEBUG_MUTEXES
 	/* mutex deadlock detection */
 	struct mutex_waiter *blocked_on;
@@ -1163,8 +1166,6 @@ static inline void put_task_struct(struc
 #define PF_MEMALLOC	0x00000800	/* Allocating memory */
 #define PF_FLUSHER	0x00001000	/* responsible for disk writeback */
 #define PF_USED_MATH	0x00002000	/* if unset the fpu must be initialized before use */
-#define PF_NOFREEZE	0x00008000	/* this thread should not be frozen */
-#define PF_FROZEN	0x00010000	/* frozen for system suspend */
 #define PF_FSTRANS	0x00020000	/* inside a filesystem transaction */
 #define PF_KSWAPD	0x00040000	/* I am kswapd */
 #define PF_SWAPOFF	0x00080000	/* I am in swapoff */
@@ -1176,7 +1177,6 @@ static inline void put_task_struct(struc
 #define PF_SPREAD_SLAB	0x02000000	/* Spread some slab caches over cpuset */
 #define PF_MEMPOLICY	0x10000000	/* Non-default NUMA mempolicy */
 #define PF_MUTEX_TESTER	0x20000000	/* Thread belongs to the rt mutex tester */
-#define PF_FREEZER_SKIP	0x40000000	/* Freezer should not count it as freezeable */
 
 /*
  * Only the _current_ task can read/write to tsk->flags, but other
diff -puN kernel/fork.c~introduce-freezer-flags-rev-2 kernel/fork.c
--- a/kernel/fork.c~introduce-freezer-flags-rev-2
+++ a/kernel/fork.c
@@ -919,11 +919,14 @@ static inline void copy_flags(unsigned l
 {
 	unsigned long new_flags = p->flags;
 
-	new_flags &= ~(PF_SUPERPRIV | PF_NOFREEZE);
+	new_flags &= ~PF_SUPERPRIV;
 	new_flags |= PF_FORKNOEXEC;
 	if (!(clone_flags & CLONE_PTRACE))
 		p->ptrace = 0;
 	p->flags = new_flags;
+#ifdef CONFIG_FREEZER
+	p->freezer_flags = 0;
+#endif
 }
 
 asmlinkage long sys_set_tid_address(int __user *tidptr)
diff -puN kernel/freezer.c~introduce-freezer-flags-rev-2 kernel/freezer.c
--- a/kernel/freezer.c~introduce-freezer-flags-rev-2
+++ a/kernel/freezer.c
@@ -26,7 +26,7 @@
 static inline int freezeable(struct task_struct * p)
 {
 	if ((p == current) ||
-	    (p->flags & PF_NOFREEZE) ||
+	    freezer_should_exempt(p) ||
 	    (p->exit_state != 0))
 		return 0;
 	return 1;
@@ -37,11 +37,11 @@ static inline int freezeable(struct task
  */
 static inline void frozen_process(void)
 {
-	if (!unlikely(current->flags & PF_NOFREEZE)) {
-		current->flags |= PF_FROZEN;
+	if (!unlikely(freezer_should_exempt(current))) {
+		set_frozen_flag(current);
 		wmb();
 	}
-	clear_tsk_thread_flag(current, TIF_FREEZE);
+	clear_freeze_flag(current);
 }
 
 /* Refrigerator is place where frozen processes are stored :-). */
@@ -100,7 +100,7 @@ static void cancel_freezing(struct task_
 
 	if (freezing(p)) {
 		pr_debug("  clean up: %s\n", p->comm);
-		do_not_freeze(p);
+		clear_freeze_flag(p);
 		spin_lock_irqsave(&p->sighand->siglock, flags);
 		recalc_sigpending_tsk(p);
 		spin_unlock_irqrestore(&p->sighand->siglock, flags);
diff -puN kernel/kthread.c~introduce-freezer-flags-rev-2 kernel/kthread.c
--- a/kernel/kthread.c~introduce-freezer-flags-rev-2
+++ a/kernel/kthread.c
@@ -13,6 +13,7 @@
 #include <linux/file.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/freezer.h>
 #include <asm/semaphore.h>
 
 static DEFINE_SPINLOCK(kthread_create_lock);
@@ -232,7 +233,7 @@ int kthreadd(void *unused)
 	/* Setup a clean context for our children to inherit. */
 	kthreadd_setup();
 
-	current->flags |= PF_NOFREEZE;
+	freezer_exempt(current);
 
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
diff -puN kernel/rcutorture.c~introduce-freezer-flags-rev-2 kernel/rcutorture.c
--- a/kernel/rcutorture.c~introduce-freezer-flags-rev-2
+++ a/kernel/rcutorture.c
@@ -559,7 +559,7 @@ rcu_torture_fakewriter(void *arg)
 
 	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task started");
 	set_user_nice(current, 19);
-	current->flags |= PF_NOFREEZE;
+	freezer_exempt(current);
 
 	do {
 		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
@@ -590,7 +590,7 @@ rcu_torture_reader(void *arg)
 
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
 	set_user_nice(current, 19);
-	current->flags |= PF_NOFREEZE;
+	freezer_exempt(current);
 
 	do {
 		idx = cur_ops->readlock();
diff -puN kernel/sched.c~introduce-freezer-flags-rev-2 kernel/sched.c
--- a/kernel/sched.c~introduce-freezer-flags-rev-2
+++ a/kernel/sched.c
@@ -5398,7 +5398,7 @@ migration_call(struct notifier_block *nf
 		p = kthread_create(migration_thread, hcpu, "migration/%d",cpu);
 		if (IS_ERR(p))
 			return NOTIFY_BAD;
-		p->flags |= PF_NOFREEZE;
+		freezer_exempt(p);
 		kthread_bind(p, cpu);
 		/* Must be high prio: stop_machine expects to yield to it. */
 		rq = task_rq_lock(p, &flags);
diff -puN kernel/softirq.c~introduce-freezer-flags-rev-2 kernel/softirq.c
--- a/kernel/softirq.c~introduce-freezer-flags-rev-2
+++ a/kernel/softirq.c
@@ -490,7 +490,7 @@ void __init softirq_init(void)
 static int ksoftirqd(void * __bind_cpu)
 {
 	set_user_nice(current, 19);
-	current->flags |= PF_NOFREEZE;
+	freezer_exempt(current);
 
 	set_current_state(TASK_INTERRUPTIBLE);
 
diff -puN kernel/softlockup.c~introduce-freezer-flags-rev-2 kernel/softlockup.c
--- a/kernel/softlockup.c~introduce-freezer-flags-rev-2
+++ a/kernel/softlockup.c
@@ -117,7 +117,7 @@ static int watchdog(void * __bind_cpu)
 	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
-	current->flags |= PF_NOFREEZE;
+	freezer_exempt(current);
 
 	/* initialize timestamp */
 	touch_softlockup_watchdog();
diff -puN kernel/workqueue.c~introduce-freezer-flags-rev-2 kernel/workqueue.c
--- a/kernel/workqueue.c~introduce-freezer-flags-rev-2
+++ a/kernel/workqueue.c
@@ -296,7 +296,7 @@ static int worker_thread(void *__cwq)
 	DEFINE_WAIT(wait);
 
 	if (!cwq->wq->freezeable)
-		current->flags |= PF_NOFREEZE;
+		freezer_exempt(current);
 
 	set_user_nice(current, -5);
 
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
introduce-freezer-flags-rev-2.patch
add-common-orderly_poweroff.patch
add-suspend-related-notifications-for-cpu-hotplug-statistics.patch
shrink_slab-handle-bad-shrinkers.patch
