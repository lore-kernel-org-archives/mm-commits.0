From: akpm@linux-foundation.org
Subject: - arm-convert-to-use-shared-apm-emulation.patch removed from -mm tree
Date: Fri, 09 Feb 2007 21:27:58 -0800
Message-ID: <200702100528.l1A5RxxQ004691@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:37006 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955AbXBJFbq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 10 Feb 2007 00:31:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ralf@linux-mips.org, lethal@linux-sh.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     ARM: convert to use shared APM emulation
has been removed from the -mm tree.  Its filename was
     arm-convert-to-use-shared-apm-emulation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ARM: convert to use shared APM emulation
From: Ralf Baechle <ralf@linux-mips.org>

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/arm/Kconfig               |   29 -
 arch/arm/common/sharpsl_pm.c   |    2 
 arch/arm/kernel/Makefile       |    1 
 arch/arm/kernel/apm.c          |  672 -------------------------------
 arch/arm/mach-pxa/corgi_pm.c   |    2 
 arch/arm/mach-pxa/sharpsl_pm.c |    2 
 arch/arm/mach-pxa/spitz_pm.c   |    2 
 include/asm-arm/apm.h          |   64 --
 8 files changed, 8 insertions(+), 766 deletions(-)

diff -puN arch/arm/Kconfig~arm-convert-to-use-shared-apm-emulation arch/arm/Kconfig
--- a/arch/arm/Kconfig~arm-convert-to-use-shared-apm-emulation
+++ a/arch/arm/Kconfig
@@ -9,6 +9,7 @@ config ARM
 	bool
 	default y
 	select RTC_LIB
+	select SYS_SUPPORTS_APM_EMULATION
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
@@ -17,6 +18,9 @@ config ARM
 	  Europe.  There is an ARM Linux project with a web page at
 	  <http://www.arm.linux.org.uk/>.
 
+config SYS_SUPPORTS_APM_EMULATION
+	bool
+
 config GENERIC_TIME
 	bool
 	default n
@@ -860,31 +864,6 @@ menu "Power management options"
 
 source "kernel/power/Kconfig"
 
-config APM
-	tristate "Advanced Power Management Emulation"
-	---help---
-	  APM is a BIOS specification for saving power using several different
-	  techniques. This is mostly useful for battery powered laptops with
-	  APM compliant BIOSes. If you say Y here, the system time will be
-	  reset after a RESUME operation, the /proc/apm device will provide
-	  battery status information, and user-space programs will receive
-	  notification of APM "events" (e.g. battery status change).
-
-	  In order to use APM, you will need supporting software. For location
-	  and more information, read <file:Documentation/pm.txt> and the
-	  Battery Powered Linux mini-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
-
-	  This driver does not spin down disk drives (see the hdparm(8)
-	  manpage ("man 8 hdparm") for that), and it doesn't turn off
-	  VESA-compliant "green" monitors.
-
-	  Generally, if you don't have a battery in your machine, there isn't
-	  much point in using this driver and you should say N. If you get
-	  random kernel OOPSes or reboots that don't seem to be related to
-	  anything, try disabling/enabling this option (or disabling/enabling
-	  APM in your BIOS).
-
 endmenu
 
 source "net/Kconfig"
diff -puN arch/arm/common/sharpsl_pm.c~arm-convert-to-use-shared-apm-emulation arch/arm/common/sharpsl_pm.c
--- a/arch/arm/common/sharpsl_pm.c~arm-convert-to-use-shared-apm-emulation
+++ a/arch/arm/common/sharpsl_pm.c
@@ -27,7 +27,7 @@
 #include <asm/hardware.h>
 #include <asm/mach-types.h>
 #include <asm/irq.h>
-#include <asm/apm.h>
+#include <asm/apm-emulation.h>
 #include <asm/arch/pm.h>
 #include <asm/arch/pxa-regs.h>
 #include <asm/arch/sharpsl.h>
diff -puN arch/arm/kernel/Makefile~arm-convert-to-use-shared-apm-emulation arch/arm/kernel/Makefile
--- a/arch/arm/kernel/Makefile~arm-convert-to-use-shared-apm-emulation
+++ a/arch/arm/kernel/Makefile
@@ -10,7 +10,6 @@ obj-y		:= compat.o entry-armv.o entry-co
 		   process.o ptrace.o semaphore.o setup.o signal.o sys_arm.o \
 		   time.o traps.o
 
-obj-$(CONFIG_APM)		+= apm.o
 obj-$(CONFIG_ISA_DMA_API)	+= dma.o
 obj-$(CONFIG_ARCH_ACORN)	+= ecard.o 
 obj-$(CONFIG_FIQ)		+= fiq.o
diff -puN arch/arm/kernel/apm.c~arm-convert-to-use-shared-apm-emulation /dev/null
--- a/arch/arm/kernel/apm.c
+++ /dev/null
@@ -1,672 +0,0 @@
-/*
- * bios-less APM driver for ARM Linux 
- *  Jamey Hicks <jamey@crl.dec.com>
- *  adapted from the APM BIOS driver for Linux by Stephen Rothwell (sfr@linuxcare.com)
- *
- * APM 1.2 Reference:
- *   Intel Corporation, Microsoft Corporation. Advanced Power Management
- *   (APM) BIOS Interface Specification, Revision 1.2, February 1996.
- *
- * [This document is available from Microsoft at:
- *    http://www.microsoft.com/hwdev/busbios/amp_12.htm]
- */
-#include <linux/module.h>
-#include <linux/poll.h>
-#include <linux/slab.h>
-#include <linux/proc_fs.h>
-#include <linux/miscdevice.h>
-#include <linux/apm_bios.h>
-#include <linux/capability.h>
-#include <linux/sched.h>
-#include <linux/pm.h>
-#include <linux/device.h>
-#include <linux/kernel.h>
-#include <linux/list.h>
-#include <linux/init.h>
-#include <linux/completion.h>
-#include <linux/kthread.h>
-#include <linux/delay.h>
-
-#include <asm/apm.h> /* apm_power_info */
-#include <asm/system.h>
-
-/*
- * The apm_bios device is one of the misc char devices.
- * This is its minor number.
- */
-#define APM_MINOR_DEV	134
-
-/*
- * See Documentation/Config.help for the configuration options.
- *
- * Various options can be changed at boot time as follows:
- * (We allow underscores for compatibility with the modules code)
- *	apm=on/off			enable/disable APM
- */
-
-/*
- * Maximum number of events stored
- */
-#define APM_MAX_EVENTS		16
-
-struct apm_queue {
-	unsigned int		event_head;
-	unsigned int		event_tail;
-	apm_event_t		events[APM_MAX_EVENTS];
-};
-
-/*
- * The per-file APM data
- */
-struct apm_user {
-	struct list_head	list;
-
-	unsigned int		suser: 1;
-	unsigned int		writer: 1;
-	unsigned int		reader: 1;
-
-	int			suspend_result;
-	unsigned int		suspend_state;
-#define SUSPEND_NONE	0		/* no suspend pending */
-#define SUSPEND_PENDING	1		/* suspend pending read */
-#define SUSPEND_READ	2		/* suspend read, pending ack */
-#define SUSPEND_ACKED	3		/* suspend acked */
-#define SUSPEND_WAIT	4		/* waiting for suspend */
-#define SUSPEND_DONE	5		/* suspend completed */
-
-	struct apm_queue	queue;
-};
-
-/*
- * Local variables
- */
-static int suspends_pending;
-static int apm_disabled;
-static struct task_struct *kapmd_tsk;
-
-static DECLARE_WAIT_QUEUE_HEAD(apm_waitqueue);
-static DECLARE_WAIT_QUEUE_HEAD(apm_suspend_waitqueue);
-
-/*
- * This is a list of everyone who has opened /dev/apm_bios
- */
-static DECLARE_RWSEM(user_list_lock);
-static LIST_HEAD(apm_user_list);
-
-/*
- * kapmd info.  kapmd provides us a process context to handle
- * "APM" events within - specifically necessary if we're going
- * to be suspending the system.
- */
-static DECLARE_WAIT_QUEUE_HEAD(kapmd_wait);
-static DEFINE_SPINLOCK(kapmd_queue_lock);
-static struct apm_queue kapmd_queue;
-
-static DEFINE_MUTEX(state_lock);
-
-static const char driver_version[] = "1.13";	/* no spaces */
-
-
-
-/*
- * Compatibility cruft until the IPAQ people move over to the new
- * interface.
- */
-static void __apm_get_power_status(struct apm_power_info *info)
-{
-}
-
-/*
- * This allows machines to provide their own "apm get power status" function.
- */
-void (*apm_get_power_status)(struct apm_power_info *) = __apm_get_power_status;
-EXPORT_SYMBOL(apm_get_power_status);
-
-
-/*
- * APM event queue management.
- */
-static inline int queue_empty(struct apm_queue *q)
-{
-	return q->event_head == q->event_tail;
-}
-
-static inline apm_event_t queue_get_event(struct apm_queue *q)
-{
-	q->event_tail = (q->event_tail + 1) % APM_MAX_EVENTS;
-	return q->events[q->event_tail];
-}
-
-static void queue_add_event(struct apm_queue *q, apm_event_t event)
-{
-	q->event_head = (q->event_head + 1) % APM_MAX_EVENTS;
-	if (q->event_head == q->event_tail) {
-		static int notified;
-
-		if (notified++ == 0)
-		    printk(KERN_ERR "apm: an event queue overflowed\n");
-		q->event_tail = (q->event_tail + 1) % APM_MAX_EVENTS;
-	}
-	q->events[q->event_head] = event;
-}
-
-static void queue_event(apm_event_t event)
-{
-	struct apm_user *as;
-
-	down_read(&user_list_lock);
-	list_for_each_entry(as, &apm_user_list, list) {
-		if (as->reader)
-			queue_add_event(&as->queue, event);
-	}
-	up_read(&user_list_lock);
-	wake_up_interruptible(&apm_waitqueue);
-}
-
-/*
- * queue_suspend_event - queue an APM suspend event.
- *
- * Check that we're in a state where we can suspend.  If not,
- * return -EBUSY.  Otherwise, queue an event to all "writer"
- * users.  If there are no "writer" users, return '1' to
- * indicate that we can immediately suspend.
- */
-static int queue_suspend_event(apm_event_t event, struct apm_user *sender)
-{
-	struct apm_user *as;
-	int ret = 1;
-
-	mutex_lock(&state_lock);
-	down_read(&user_list_lock);
-
-	/*
-	 * If a thread is still processing, we can't suspend, so reject
-	 * the request.
-	 */
-	list_for_each_entry(as, &apm_user_list, list) {
-		if (as != sender && as->reader && as->writer && as->suser &&
-		    as->suspend_state != SUSPEND_NONE) {
-			ret = -EBUSY;
-			goto out;
-		}
-	}
-
-	list_for_each_entry(as, &apm_user_list, list) {
-		if (as != sender && as->reader && as->writer && as->suser) {
-			as->suspend_state = SUSPEND_PENDING;
-			suspends_pending++;
-			queue_add_event(&as->queue, event);
-			ret = 0;
-		}
-	}
- out:
-	up_read(&user_list_lock);
-	mutex_unlock(&state_lock);
-	wake_up_interruptible(&apm_waitqueue);
-	return ret;
-}
-
-static void apm_suspend(void)
-{
-	struct apm_user *as;
-	int err = pm_suspend(PM_SUSPEND_MEM);
-
-	/*
-	 * Anyone on the APM queues will think we're still suspended.
-	 * Send a message so everyone knows we're now awake again.
-	 */
-	queue_event(APM_NORMAL_RESUME);
-
-	/*
-	 * Finally, wake up anyone who is sleeping on the suspend.
-	 */
-	mutex_lock(&state_lock);
-	down_read(&user_list_lock);
-	list_for_each_entry(as, &apm_user_list, list) {
-		if (as->suspend_state == SUSPEND_WAIT ||
-		    as->suspend_state == SUSPEND_ACKED) {
-	  		as->suspend_result = err;
-			as->suspend_state = SUSPEND_DONE;
-		}
-	}
-	up_read(&user_list_lock);
-	mutex_unlock(&state_lock);
-
-	wake_up(&apm_suspend_waitqueue);
-}
-
-static ssize_t apm_read(struct file *fp, char __user *buf, size_t count, loff_t *ppos)
-{
-	struct apm_user *as = fp->private_data;
-	apm_event_t event;
-	int i = count, ret = 0;
-
-	if (count < sizeof(apm_event_t))
-		return -EINVAL;
-
-	if (queue_empty(&as->queue) && fp->f_flags & O_NONBLOCK)
-		return -EAGAIN;
-
-	wait_event_interruptible(apm_waitqueue, !queue_empty(&as->queue));
-
-	while ((i >= sizeof(event)) && !queue_empty(&as->queue)) {
-		event = queue_get_event(&as->queue);
-
-		ret = -EFAULT;
-		if (copy_to_user(buf, &event, sizeof(event)))
-			break;
-
-		mutex_lock(&state_lock);
-		if (as->suspend_state == SUSPEND_PENDING &&
-		    (event == APM_SYS_SUSPEND || event == APM_USER_SUSPEND))
-			as->suspend_state = SUSPEND_READ;
-		mutex_unlock(&state_lock);
-
-		buf += sizeof(event);
-		i -= sizeof(event);
-	}
-
-	if (i < count)
-		ret = count - i;
-
-	return ret;
-}
-
-static unsigned int apm_poll(struct file *fp, poll_table * wait)
-{
-	struct apm_user *as = fp->private_data;
-
-	poll_wait(fp, &apm_waitqueue, wait);
-	return queue_empty(&as->queue) ? 0 : POLLIN | POLLRDNORM;
-}
-
-/*
- * apm_ioctl - handle APM ioctl
- *
- * APM_IOC_SUSPEND
- *   This IOCTL is overloaded, and performs two functions.  It is used to:
- *     - initiate a suspend
- *     - acknowledge a suspend read from /dev/apm_bios.
- *   Only when everyone who has opened /dev/apm_bios with write permission
- *   has acknowledge does the actual suspend happen.
- */
-static int
-apm_ioctl(struct inode * inode, struct file *filp, u_int cmd, u_long arg)
-{
-	struct apm_user *as = filp->private_data;
-	unsigned long flags;
-	int err = -EINVAL;
-
-	if (!as->suser || !as->writer)
-		return -EPERM;
-
-	switch (cmd) {
-	case APM_IOC_SUSPEND:
-		mutex_lock(&state_lock);
-
-		as->suspend_result = -EINTR;
-
-		if (as->suspend_state == SUSPEND_READ) {
-			int pending;
-
-			/*
-			 * If we read a suspend command from /dev/apm_bios,
-			 * then the corresponding APM_IOC_SUSPEND ioctl is
-			 * interpreted as an acknowledge.
-			 */
-			as->suspend_state = SUSPEND_ACKED;
-			suspends_pending--;
-			pending = suspends_pending == 0;
-			mutex_unlock(&state_lock);
-
-			/*
-			 * If there are no further acknowledges required,
-			 * suspend the system.
-			 */
-			if (pending)
-				apm_suspend();
-
-			/*
-			 * Wait for the suspend/resume to complete.  If there
-			 * are pending acknowledges, we wait here for them.
-			 *
-			 * Note: we need to ensure that the PM subsystem does
-			 * not kick us out of the wait when it suspends the
-			 * threads.
-			 */
-			flags = current->flags;
-			current->flags |= PF_NOFREEZE;
-
-			wait_event(apm_suspend_waitqueue,
-				   as->suspend_state == SUSPEND_DONE);
-		} else {
-			as->suspend_state = SUSPEND_WAIT;
-			mutex_unlock(&state_lock);
-
-			/*
-			 * Otherwise it is a request to suspend the system.
-			 * Queue an event for all readers, and expect an
-			 * acknowledge from all writers who haven't already
-			 * acknowledged.
-			 */
-			err = queue_suspend_event(APM_USER_SUSPEND, as);
-			if (err < 0) {
-				/*
-				 * Avoid taking the lock here - this
-				 * should be fine.
-				 */
-				as->suspend_state = SUSPEND_NONE;
-				break;
-			}
-
-			if (err > 0)
-				apm_suspend();
-
-			/*
-			 * Wait for the suspend/resume to complete.  If there
-			 * are pending acknowledges, we wait here for them.
-			 *
-			 * Note: we need to ensure that the PM subsystem does
-			 * not kick us out of the wait when it suspends the
-			 * threads.
-			 */
-			flags = current->flags;
-			current->flags |= PF_NOFREEZE;
-
-			wait_event_interruptible(apm_suspend_waitqueue,
-					 as->suspend_state == SUSPEND_DONE);
-		}
-
-		current->flags = flags;
-
-		mutex_lock(&state_lock);
-		err = as->suspend_result;
-		as->suspend_state = SUSPEND_NONE;
-		mutex_unlock(&state_lock);
-		break;
-	}
-
-	return err;
-}
-
-static int apm_release(struct inode * inode, struct file * filp)
-{
-	struct apm_user *as = filp->private_data;
-	int pending = 0;
-
-	filp->private_data = NULL;
-
-	down_write(&user_list_lock);
-	list_del(&as->list);
-	up_write(&user_list_lock);
-
-	/*
-	 * We are now unhooked from the chain.  As far as new
-	 * events are concerned, we no longer exist.  However, we
-	 * need to balance suspends_pending, which means the
-	 * possibility of sleeping.
-	 */
-	mutex_lock(&state_lock);
-	if (as->suspend_state != SUSPEND_NONE) {
-		suspends_pending -= 1;
-		pending = suspends_pending == 0;
-	}
-	mutex_unlock(&state_lock);
-	if (pending)
-		apm_suspend();
-
-	kfree(as);
-	return 0;
-}
-
-static int apm_open(struct inode * inode, struct file * filp)
-{
-	struct apm_user *as;
-
-	as = kzalloc(sizeof(*as), GFP_KERNEL);
-	if (as) {
-		/*
-		 * XXX - this is a tiny bit broken, when we consider BSD
-		 * process accounting. If the device is opened by root, we
-		 * instantly flag that we used superuser privs. Who knows,
-		 * we might close the device immediately without doing a
-		 * privileged operation -- cevans
-		 */
-		as->suser = capable(CAP_SYS_ADMIN);
-		as->writer = (filp->f_mode & FMODE_WRITE) == FMODE_WRITE;
-		as->reader = (filp->f_mode & FMODE_READ) == FMODE_READ;
-
-		down_write(&user_list_lock);
-		list_add(&as->list, &apm_user_list);
-		up_write(&user_list_lock);
-
-		filp->private_data = as;
-	}
-
-	return as ? 0 : -ENOMEM;
-}
-
-static struct file_operations apm_bios_fops = {
-	.owner		= THIS_MODULE,
-	.read		= apm_read,
-	.poll		= apm_poll,
-	.ioctl		= apm_ioctl,
-	.open		= apm_open,
-	.release	= apm_release,
-};
-
-static struct miscdevice apm_device = {
-	.minor		= APM_MINOR_DEV,
-	.name		= "apm_bios",
-	.fops		= &apm_bios_fops
-};
-
-
-#ifdef CONFIG_PROC_FS
-/*
- * Arguments, with symbols from linux/apm_bios.h.
- *
- *   0) Linux driver version (this will change if format changes)
- *   1) APM BIOS Version.  Usually 1.0, 1.1 or 1.2.
- *   2) APM flags from APM Installation Check (0x00):
- *	bit 0: APM_16_BIT_SUPPORT
- *	bit 1: APM_32_BIT_SUPPORT
- *	bit 2: APM_IDLE_SLOWS_CLOCK
- *	bit 3: APM_BIOS_DISABLED
- *	bit 4: APM_BIOS_DISENGAGED
- *   3) AC line status
- *	0x00: Off-line
- *	0x01: On-line
- *	0x02: On backup power (BIOS >= 1.1 only)
- *	0xff: Unknown
- *   4) Battery status
- *	0x00: High
- *	0x01: Low
- *	0x02: Critical
- *	0x03: Charging
- *	0x04: Selected battery not present (BIOS >= 1.2 only)
- *	0xff: Unknown
- *   5) Battery flag
- *	bit 0: High
- *	bit 1: Low
- *	bit 2: Critical
- *	bit 3: Charging
- *	bit 7: No system battery
- *	0xff: Unknown
- *   6) Remaining battery life (percentage of charge):
- *	0-100: valid
- *	-1: Unknown
- *   7) Remaining battery life (time units):
- *	Number of remaining minutes or seconds
- *	-1: Unknown
- *   8) min = minutes; sec = seconds
- */
-static int apm_get_info(char *buf, char **start, off_t fpos, int length)
-{
-	struct apm_power_info info;
-	char *units;
-	int ret;
-
-	info.ac_line_status = 0xff;
-	info.battery_status = 0xff;
-	info.battery_flag   = 0xff;
-	info.battery_life   = -1;
-	info.time	    = -1;
-	info.units	    = -1;
-
-	if (apm_get_power_status)
-		apm_get_power_status(&info);
-
-	switch (info.units) {
-	default:	units = "?";	break;
-	case 0: 	units = "min";	break;
-	case 1: 	units = "sec";	break;
-	}
-
-	ret = sprintf(buf, "%s 1.2 0x%02x 0x%02x 0x%02x 0x%02x %d%% %d %s\n",
-		     driver_version, APM_32_BIT_SUPPORT,
-		     info.ac_line_status, info.battery_status,
-		     info.battery_flag, info.battery_life,
-		     info.time, units);
-
- 	return ret;
-}
-#endif
-
-static int kapmd(void *arg)
-{
-	do {
-		apm_event_t event;
-		int ret;
-
-		wait_event_interruptible(kapmd_wait,
-				!queue_empty(&kapmd_queue) || kthread_should_stop());
-
-		if (kthread_should_stop())
-			break;
-
-		spin_lock_irq(&kapmd_queue_lock);
-		event = 0;
-		if (!queue_empty(&kapmd_queue))
-			event = queue_get_event(&kapmd_queue);
-		spin_unlock_irq(&kapmd_queue_lock);
-
-		switch (event) {
-		case 0:
-			break;
-
-		case APM_LOW_BATTERY:
-		case APM_POWER_STATUS_CHANGE:
-			queue_event(event);
-			break;
-
-		case APM_USER_SUSPEND:
-		case APM_SYS_SUSPEND:
-			ret = queue_suspend_event(event, NULL);
-			if (ret < 0) {
-				/*
-				 * We were busy.  Try again in 50ms.
-				 */
-				queue_add_event(&kapmd_queue, event);
-				msleep(50);
-			}
-			if (ret > 0)
-				apm_suspend();
-			break;
-
-		case APM_CRITICAL_SUSPEND:
-			apm_suspend();
-			break;
-		}
-	} while (1);
-
-	return 0;
-}
-
-static int __init apm_init(void)
-{
-	int ret;
-
-	if (apm_disabled) {
-		printk(KERN_NOTICE "apm: disabled on user request.\n");
-		return -ENODEV;
-	}
-
-	kapmd_tsk = kthread_create(kapmd, NULL, "kapmd");
-	if (IS_ERR(kapmd_tsk)) {
-		ret = PTR_ERR(kapmd_tsk);
-		kapmd_tsk = NULL;
-		return ret;
-	}
-	kapmd_tsk->flags |= PF_NOFREEZE;
-	wake_up_process(kapmd_tsk);
-
-#ifdef CONFIG_PROC_FS
-	create_proc_info_entry("apm", 0, NULL, apm_get_info);
-#endif
-
-	ret = misc_register(&apm_device);
-	if (ret != 0) {
-		remove_proc_entry("apm", NULL);
-		kthread_stop(kapmd_tsk);
-	}
-
-	return ret;
-}
-
-static void __exit apm_exit(void)
-{
-	misc_deregister(&apm_device);
-	remove_proc_entry("apm", NULL);
-
-	kthread_stop(kapmd_tsk);
-}
-
-module_init(apm_init);
-module_exit(apm_exit);
-
-MODULE_AUTHOR("Stephen Rothwell");
-MODULE_DESCRIPTION("Advanced Power Management");
-MODULE_LICENSE("GPL");
-
-#ifndef MODULE
-static int __init apm_setup(char *str)
-{
-	while ((str != NULL) && (*str != '\0')) {
-		if (strncmp(str, "off", 3) == 0)
-			apm_disabled = 1;
-		if (strncmp(str, "on", 2) == 0)
-			apm_disabled = 0;
-		str = strchr(str, ',');
-		if (str != NULL)
-			str += strspn(str, ", \t");
-	}
-	return 1;
-}
-
-__setup("apm=", apm_setup);
-#endif
-
-/**
- * apm_queue_event - queue an APM event for kapmd
- * @event: APM event
- *
- * Queue an APM event for kapmd to process and ultimately take the
- * appropriate action.  Only a subset of events are handled:
- *   %APM_LOW_BATTERY
- *   %APM_POWER_STATUS_CHANGE
- *   %APM_USER_SUSPEND
- *   %APM_SYS_SUSPEND
- *   %APM_CRITICAL_SUSPEND
- */
-void apm_queue_event(apm_event_t event)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&kapmd_queue_lock, flags);
-	queue_add_event(&kapmd_queue, event);
-	spin_unlock_irqrestore(&kapmd_queue_lock, flags);
-
-	wake_up_interruptible(&kapmd_wait);
-}
-EXPORT_SYMBOL(apm_queue_event);
diff -puN arch/arm/mach-pxa/corgi_pm.c~arm-convert-to-use-shared-apm-emulation arch/arm/mach-pxa/corgi_pm.c
--- a/arch/arm/mach-pxa/corgi_pm.c~arm-convert-to-use-shared-apm-emulation
+++ a/arch/arm/mach-pxa/corgi_pm.c
@@ -16,7 +16,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
-#include <asm/apm.h>
+#include <asm/apm-emulation.h>
 #include <asm/irq.h>
 #include <asm/mach-types.h>
 #include <asm/hardware.h>
diff -puN arch/arm/mach-pxa/sharpsl_pm.c~arm-convert-to-use-shared-apm-emulation arch/arm/mach-pxa/sharpsl_pm.c
--- a/arch/arm/mach-pxa/sharpsl_pm.c~arm-convert-to-use-shared-apm-emulation
+++ a/arch/arm/mach-pxa/sharpsl_pm.c
@@ -23,7 +23,7 @@
 
 #include <asm/hardware.h>
 #include <asm/mach-types.h>
-#include <asm/apm.h>
+#include <asm/apm-emulation.h>
 #include <asm/arch/pm.h>
 #include <asm/arch/pxa-regs.h>
 #include <asm/arch/sharpsl.h>
diff -puN arch/arm/mach-pxa/spitz_pm.c~arm-convert-to-use-shared-apm-emulation arch/arm/mach-pxa/spitz_pm.c
--- a/arch/arm/mach-pxa/spitz_pm.c~arm-convert-to-use-shared-apm-emulation
+++ a/arch/arm/mach-pxa/spitz_pm.c
@@ -16,7 +16,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
-#include <asm/apm.h>
+#include <asm/apm-emulation.h>
 #include <asm/irq.h>
 #include <asm/mach-types.h>
 #include <asm/hardware.h>
diff -puN include/asm-arm/apm.h~arm-convert-to-use-shared-apm-emulation /dev/null
--- a/include/asm-arm/apm.h
+++ /dev/null
@@ -1,64 +0,0 @@
-/* -*- linux-c -*-
- *
- * (C) 2003 zecke@handhelds.org
- *
- * GPL version 2
- *
- * based on arch/arm/kernel/apm.c
- * factor out the information needed by architectures to provide
- * apm status
- *
- *
- */
-#ifndef ARM_ASM_SA1100_APM_H
-#define ARM_ASM_SA1100_APM_H
-
-#include <linux/apm_bios.h>
-
-/*
- * This structure gets filled in by the machine specific 'get_power_status'
- * implementation.  Any fields which are not set default to a safe value.
- */
-struct apm_power_info {
-	unsigned char	ac_line_status;
-#define APM_AC_OFFLINE			0
-#define APM_AC_ONLINE			1
-#define APM_AC_BACKUP			2
-#define APM_AC_UNKNOWN			0xff
-
-	unsigned char	battery_status;
-#define APM_BATTERY_STATUS_HIGH		0
-#define APM_BATTERY_STATUS_LOW		1
-#define APM_BATTERY_STATUS_CRITICAL	2
-#define APM_BATTERY_STATUS_CHARGING	3
-#define APM_BATTERY_STATUS_NOT_PRESENT	4
-#define APM_BATTERY_STATUS_UNKNOWN	0xff
-
-	unsigned char	battery_flag;
-#define APM_BATTERY_FLAG_HIGH		(1 << 0)
-#define APM_BATTERY_FLAG_LOW		(1 << 1)
-#define APM_BATTERY_FLAG_CRITICAL	(1 << 2)
-#define APM_BATTERY_FLAG_CHARGING	(1 << 3)
-#define APM_BATTERY_FLAG_NOT_PRESENT	(1 << 7)
-#define APM_BATTERY_FLAG_UNKNOWN	0xff
-
-	int		battery_life;
-	int		time;
-	int		units;
-#define APM_UNITS_MINS			0
-#define APM_UNITS_SECS			1
-#define APM_UNITS_UNKNOWN		-1
-
-};
-
-/*
- * This allows machines to provide their own "apm get power status" function.
- */
-extern void (*apm_get_power_status)(struct apm_power_info *);
-
-/*
- * Queue an event (APM_SYS_SUSPEND or APM_CRITICAL_SUSPEND)
- */
-void apm_queue_event(apm_event_t event);
-
-#endif
_

Patches currently in -mm which might be from ralf@linux-mips.org are

origin.patch
git-mips.patch
mips-remove-smp_tune_scheduling.patch
fix-pnx8550-serial-breakage.patch
pnx8550-uart-driver.patch
pnx8550-uart-driver-fixes.patch
make-cardbus_mem_size-and-cardbus_io_size-boot-options.patch
xfs-remove-useless-wmb-memory-barrier.patch
ioc3-ioc4-pci-mem-space-resources.patch
proc-remove-useless-and-buggy-nlink-settings.patch
simplify-the-stacktrace-code.patch
extend-the-set-of-__attribute__-shortcut-macros.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
clocksource-fixup-is_continous-changes-on-mips.patch
dynamic-kernel-command-line-common.patch
dynamic-kernel-command-line-mips.patch
dynamic-kernel-command-line-parisc.patch
cyber2010-framebuffer-on-arm-netwinder-fix.patch
cyber2010-framebuffer-on-arm-netwinder-fix-tidy.patch
sysctl-x25-remove-unnecessary-insert_at_head-from-register_sysctl_table.patch
sysctl-rose-remove-unnecessary-insert_at_head-flag.patch
sysctl-netrom-remove-unnecessary-insert_at_head-flag.patch
sysctl-ax25-remove-unnecessary-insert_at_head-flag.patch
sysctl-mips-au1000-remove-sys_sysctl-support.patch
sysctl-c99-convert-the-ctl_tables-in-arch-mips-au1000-common-powerc.patch
sysctl-c99-convert-arch-mips-lasat-sysctlc-and-remove-abi-breakage.patch
sysctl-remove-sys_sysctl-support-from-drivers-char-rtcc.patch
sysctl-remove-insert_at_head-from-register_sysctl.patch
