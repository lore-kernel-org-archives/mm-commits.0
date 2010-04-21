From: akpm@linux-foundation.org
Subject: + vmware-balloon-driver.patch added to -mm tree
Date: Wed, 21 Apr 2010 16:54:57 -0700
Message-ID: <201004212354.o3LNsvSD017309@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754731Ab0DUX4K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Apr 2010 19:56:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dtor@vmware.com, avi@redhat.com, jeremy@goop.org, mingo@elte.hu


The patch titled
     VMware Balloon driver
has been added to the -mm tree.  Its filename is
     vmware-balloon-driver.patch

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
Subject: VMware Balloon driver
From: Dmitry Torokhov <dtor@vmware.com>

This is a standalone version of VMware Balloon driver.  Ballooning is a
technique that allows hypervisor dynamically limit the amount of memory
available to the guest (with guest cooperation).  In the overcommit
scenario, when hypervisor set detects that it needs to shuffle some
memory, it instructs the driver to allocate certain number of pages, and
the underlying memory gets returned to the hypervisor.  Later hypervisor
may return memory to the guest by reattaching memory to the pageframes and
instructing the driver to "deflate" balloon.

We are submitting a standalone driver because KVM maintainer (Avi Kivity)
expressed opinion (rightly) that our transport does not fit well into
virtqueue paradigm and thus it does not make much sense to integrate with
virtio.

There were also some concerns whether current ballooning technique is the
right thing.  If there appears a better framework to achieve this we are
prepared to evaluate and switch to using it, but in the meantime we'd like
to get this driver upstream.

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/vmware.c  |    2 
 drivers/misc/Kconfig          |   16 
 drivers/misc/Makefile         |    1 
 drivers/misc/vmware_balloon.c |  808 ++++++++++++++++++++++++++++++++
 4 files changed, 827 insertions(+)

diff -puN arch/x86/kernel/cpu/vmware.c~vmware-balloon-driver arch/x86/kernel/cpu/vmware.c
--- a/arch/x86/kernel/cpu/vmware.c~vmware-balloon-driver
+++ a/arch/x86/kernel/cpu/vmware.c
@@ -22,6 +22,7 @@
  */
 
 #include <linux/dmi.h>
+#include <linux/module.h>
 #include <asm/div64.h>
 #include <asm/vmware.h>
 #include <asm/x86_init.h>
@@ -101,6 +102,7 @@ int vmware_platform(void)
 
 	return 0;
 }
+EXPORT_SYMBOL(vmware_platform);
 
 /*
  * VMware hypervisor takes care of exporting a reliable TSC to the guest.
diff -puN drivers/misc/Kconfig~vmware-balloon-driver drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~vmware-balloon-driver
+++ a/drivers/misc/Kconfig
@@ -311,6 +311,22 @@ config TI_DAC7512
 	  This driver can also be built as a module. If so, the module
 	  will be calles ti_dac7512.
 
+config VMWARE_BALLOON
+	tristate "VMware Balloon Driver"
+	depends on X86
+	help
+	  This is VMware physical memory management driver which acts
+	  like a "balloon" that can be inflated to reclaim physical pages
+	  by reserving them in the guest and invalidating them in the
+	  monitor, freeing up the underlying machine pages so they can
+	  be allocated to other guests. The balloon can also be deflated
+	  to allow the guest to use more physical memory.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called vmware_balloon.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff -puN drivers/misc/Makefile~vmware-balloon-driver drivers/misc/Makefile
--- a/drivers/misc/Makefile~vmware-balloon-driver
+++ a/drivers/misc/Makefile
@@ -28,3 +28,4 @@ obj-$(CONFIG_C2PORT)		+= c2port/
 obj-$(CONFIG_IWMC3200TOP)      += iwmc3200top/
 obj-y				+= eeprom/
 obj-y				+= cb710/
+obj-$(CONFIG_VMWARE_BALLOON)	+= vmware_balloon.o
diff -puN /dev/null drivers/misc/vmware_balloon.c
--- /dev/null
+++ a/drivers/misc/vmware_balloon.c
@@ -0,0 +1,808 @@
+/*
+ * VMware Balloon driver.
+ *
+ * Copyright (C) 2000-2010, VMware, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; version 2 of the License and no later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Maintained by: Dmitry Torokhov <dtor@vmware.com>
+ */
+
+/*
+ * This is VMware physical memory management driver for Linux. The driver
+ * acts like a "balloon" that can be inflated to reclaim physical pages by
+ * reserving them in the guest and invalidating them in the monitor,
+ * freeing up the underlying machine pages so they can be allocated to
+ * other guests.  The balloon can also be deflated to allow the guest to
+ * use more physical memory. Higher level policies can control the sizes
+ * of balloons in VMs in order to manage physical memory resources.
+ */
+
+//#define DEBUG
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/workqueue.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+#include <asm/vmware.h>
+
+MODULE_AUTHOR("VMware, Inc.");
+MODULE_DESCRIPTION("VMware Memory Control (Balloon) Driver");
+MODULE_VERSION("1.2.1.0-K");
+MODULE_ALIAS("dmi:*:svnVMware*:*");
+MODULE_ALIAS("vmware_vmmemctl");
+MODULE_LICENSE("GPL");
+
+#define VMW_BALLOON_NOSLEEP_ALLOC_MAX	16384U
+
+#define VMW_BALLOON_RATE_ALLOC_MIN	512U
+#define VMW_BALLOON_RATE_ALLOC_MAX	2048U
+#define VMW_BALLOON_RATE_ALLOC_INC	16U
+
+#define VMW_BALLOON_RATE_FREE_MIN	512U
+#define VMW_BALLOON_RATE_FREE_MAX	16384U
+#define VMW_BALLOON_RATE_FREE_INC	16U
+
+/*
+ * When guest is under memory pressure, use a reduced page allocation
+ * rate for next several cycles.
+ */
+#define VMW_BALLOON_SLOW_CYCLES		4
+
+/*
+ * Use __GFP_HIGHMEM to allow pages from HIGHMEM zone. We don't
+ * allow wait (__GFP_WAIT) for NOSLEEP page allocations. Use
+ * __GFP_NOWARN, to suppress page allocation failure warnings.
+ */
+#define VMW_PAGE_ALLOC_NOSLEEP		(__GFP_HIGHMEM|__GFP_NOWARN)
+
+/*
+ * Use GFP_HIGHUSER when executing in a separate kernel thread
+ * context and allocation can sleep.  This is less stressful to
+ * the guest memory system, since it allows the thread to block
+ * while memory is reclaimed, and won't take pages from emergency
+ * low-memory pools.
+ */
+#define VMW_PAGE_ALLOC_CANSLEEP		(GFP_HIGHUSER)
+
+/* Maximum number of page allocations without yielding processor */
+#define VMW_BALLOON_YIELD_THRESHOLD	1024
+
+#define VMW_BALLOON_HV_PORT		0x5670
+#define VMW_BALLOON_HV_MAGIC		0x456c6d6f
+#define VMW_BALLOON_PROTOCOL_VERSION	2
+#define VMW_BALLOON_GUEST_ID		1	/* Linux */
+
+#define VMW_BALLOON_CMD_START		0
+#define VMW_BALLOON_CMD_GET_TARGET	1
+#define VMW_BALLOON_CMD_LOCK		2
+#define VMW_BALLOON_CMD_UNLOCK		3
+#define VMW_BALLOON_CMD_GUEST_ID	4
+
+/* error codes */
+#define VMW_BALLOON_SUCCESS		0
+#define VMW_BALLOON_FAILURE		-1
+#define VMW_BALLOON_ERROR_CMD_INVALID	1
+#define VMW_BALLOON_ERROR_PPN_INVALID	2
+#define VMW_BALLOON_ERROR_PPN_LOCKED	3
+#define VMW_BALLOON_ERROR_PPN_UNLOCKED	4
+#define VMW_BALLOON_ERROR_PPN_PINNED	5
+#define VMW_BALLOON_ERROR_PPN_NOTNEEDED	6
+#define VMW_BALLOON_ERROR_RESET		7
+#define VMW_BALLOON_ERROR_BUSY		8
+
+#define VMWARE_BALLOON_CMD(cmd, data, result)		\
+({							\
+	unsigned long __stat, __dummy1, __dummy2;	\
+	__asm__ __volatile__ ("inl (%%dx)" :		\
+		"=a"(__stat),				\
+		"=c"(__dummy1),				\
+		"=d"(__dummy2),				\
+		"=b"(result) :				\
+		"0"(VMW_BALLOON_HV_MAGIC),		\
+		"1"(VMW_BALLOON_CMD_##cmd),		\
+		"2"(VMW_BALLOON_HV_PORT),		\
+		"3"(data) :				\
+		"memory");				\
+	result &= -1UL;					\
+	__stat & -1UL;					\
+})
+
+#define STATS_INC(stat) (stat)++
+
+struct vmballoon_stats {
+	unsigned int timer;
+
+	/* allocation statustics */
+	unsigned int alloc;
+	unsigned int alloc_fail;
+	unsigned int sleep_alloc;
+	unsigned int sleep_alloc_fail;
+	unsigned int refused_alloc;
+	unsigned int refused_free;
+	unsigned int free;
+
+	/* monitor operations */
+	unsigned int lock;
+	unsigned int lock_fail;
+	unsigned int unlock;
+	unsigned int unlock_fail;
+	unsigned int target;
+	unsigned int target_fail;
+	unsigned int start;
+	unsigned int start_fail;
+	unsigned int guest_type;
+	unsigned int guest_type_fail;
+};
+
+struct vmballoon {
+
+	/* list of reserved physical pages */
+	struct list_head pages;
+
+	/* transient list of non-balloonable pages */
+	struct list_head refused_pages;
+
+	/* balloon size in pages */
+	unsigned int size;
+	unsigned int target;
+
+	/* reset flag */
+	bool reset_required;
+
+	/* adjustment rates (pages per second) */
+	unsigned int rate_alloc;
+	unsigned int rate_free;
+
+	/* slowdown page allocations for next few cycles */
+	unsigned int slow_allocation_cycles;
+
+	/* statistics */
+	struct vmballoon_stats stats;
+
+	/* debugfs file exporting statistics */
+	struct dentry *dbg_entry;
+
+	struct sysinfo sysinfo;
+
+	struct delayed_work dwork;
+};
+
+static struct vmballoon balloon;
+static struct workqueue_struct *vmballoon_wq;
+
+/*
+ * Send "start" command to the host, communicating supported version
+ * of the protocol.
+ */
+static bool vmballoon_send_start(struct vmballoon *b)
+{
+	unsigned long status, dummy;
+
+	STATS_INC(b->stats.start);
+
+	status = VMWARE_BALLOON_CMD(START, VMW_BALLOON_PROTOCOL_VERSION, dummy);
+	if (status == VMW_BALLOON_SUCCESS)
+		return true;
+
+	pr_debug("%s - failed, hv returns %ld\n", __func__, status);
+	STATS_INC(b->stats.start_fail);
+	return false;
+}
+
+static bool vmballoon_check_status(struct vmballoon *b, unsigned long status)
+{
+	switch (status) {
+	case VMW_BALLOON_SUCCESS:
+		return true;
+
+	case VMW_BALLOON_ERROR_RESET:
+		b->reset_required = true;
+		/* fall through */
+
+	default:
+		return false;
+	}
+}
+
+/*
+ * Communicate guest type to the host so that it can adjust ballooning
+ * algorithm to the one most appropriate for the guest. This command
+ * is normally issued after sending "start" command and is part of
+ * standard reset sequence.
+ */
+static bool vmballoon_send_guest_id(struct vmballoon *b)
+{
+	unsigned long status, dummy;
+
+	status = VMWARE_BALLOON_CMD(GUEST_ID, VMW_BALLOON_GUEST_ID, dummy);
+
+	STATS_INC(b->stats.guest_type);
+
+	if (vmballoon_check_status(b, status))
+		return true;
+
+	pr_debug("%s - failed, hv returns %ld\n", __func__, status);
+	STATS_INC(b->stats.guest_type_fail);
+	return false;
+}
+
+/*
+ * Retrieve desired balloon size from the host.
+ */
+static bool vmballoon_send_get_target(struct vmballoon *b, u32 *new_target)
+{
+	unsigned long status;
+	unsigned long target;
+	unsigned long limit;
+	u32 limit32;
+
+	/*
+	 * si_meminfo() is cheap. Moreover, we want to provide dynamic
+	 * max balloon size later. So let us call si_meminfo() every
+	 * iteration.
+	 */
+	si_meminfo(&b->sysinfo);
+	limit = b->sysinfo.totalram;
+
+	/* Ensure limit fits in 32-bits */
+	limit32 = (u32)limit;
+	if (limit != limit32)
+		return false;
+
+	/* update stats */
+	STATS_INC(b->stats.target);
+
+	status = VMWARE_BALLOON_CMD(GET_TARGET, limit, target);
+	if (vmballoon_check_status(b, status)) {
+		*new_target = target;
+		return true;
+	}
+
+	pr_debug("%s - failed, hv returns %ld\n", __func__, status);
+	STATS_INC(b->stats.target_fail);
+	return false;
+}
+
+/*
+ * Notify the host about allocated page so that host can use it without
+ * fear that guest will need it. Host may reject some pages, we need to
+ * check the return value and maybe submit a different page.
+ */
+static bool vmballoon_send_lock_page(struct vmballoon *b, unsigned long pfn)
+{
+	unsigned long status, dummy;
+	u32 pfn32;
+
+	pfn32 = (u32)pfn;
+	if (pfn32 != pfn)
+		return false;
+
+	STATS_INC(b->stats.lock);
+
+	status = VMWARE_BALLOON_CMD(LOCK, pfn, dummy);
+	if (vmballoon_check_status(b, status))
+		return true;
+
+	pr_debug("%s - ppn %lx, hv returns %ld\n", __func__, pfn, status);
+	STATS_INC(b->stats.lock_fail);
+	return false;
+}
+
+/*
+ * Notify the host that guest intends to release given page back into
+ * the pool of available (to the guest) pages.
+ */
+static bool vmballoon_send_unlock_page(struct vmballoon *b, unsigned long pfn)
+{
+	unsigned long status, dummy;
+	u32 pfn32;
+
+	pfn32 = (u32)pfn;
+	if (pfn32 != pfn)
+		return false;
+
+	STATS_INC(b->stats.unlock);
+
+	status = VMWARE_BALLOON_CMD(UNLOCK, pfn, dummy);
+	if (vmballoon_check_status(b, status))
+		return true;
+
+	pr_debug("%s - ppn %lx, hv returns %ld\n", __func__, pfn, status);
+	STATS_INC(b->stats.unlock_fail);
+	return false;
+}
+
+/*
+ * Quickly release all pages allocated for the balloon. This function is
+ * called when host decides to "reset" balloon for one reason or another.
+ * Unlike normal "deflate" we do not (shall not) notify host of the pages
+ * being released.
+ */
+static void vmballoon_pop(struct vmballoon *b)
+{
+	struct page *page, *next;
+	unsigned int count = 0;
+
+	list_for_each_entry_safe(page, next, &b->pages, lru) {
+		list_del(&page->lru);
+		__free_page(page);
+		STATS_INC(b->stats.free);
+		b->size--;
+
+		if (++count >= b->rate_free) {
+			count = 0;
+			cond_resched();
+		}
+	}
+}
+
+/*
+ * Perform standard reset sequence by popping the balloon (in case it
+ * is not  empty) and then restarting protocol. This operation normally
+ * happens when host responds with VMW_BALLOON_ERROR_RESET to a command.
+ */
+static void vmballoon_reset(struct vmballoon *b)
+{
+	/* free all pages, skipping monitor unlock */
+	vmballoon_pop(b);
+
+	if (vmballoon_send_start(b)) {
+		b->reset_required = false;
+		if (!vmballoon_send_guest_id(b))
+			pr_err("failed to send guest ID to the host\n");
+	}
+}
+
+/*
+ * Allocate (or reserve) a page for the balloon and notify the host.  If host
+ * refuses the page put it on "refuse" list and allocate another one until host
+ * is satisfied. "Refused" pages are released at the end of inflation cycle
+ * (when we allocate b->rate_alloc pages).
+ */
+static int vmballoon_reserve_page(struct vmballoon *b, bool can_sleep)
+{
+	struct page *page;
+	gfp_t flags;
+	bool locked = false;
+
+	do {
+		if (!can_sleep)
+			STATS_INC(b->stats.alloc);
+		else
+			STATS_INC(b->stats.sleep_alloc);
+
+		flags = can_sleep ? VMW_PAGE_ALLOC_CANSLEEP : VMW_PAGE_ALLOC_NOSLEEP;
+		page = alloc_page(flags);
+		if (!page) {
+			if (!can_sleep)
+				STATS_INC(b->stats.alloc_fail);
+			else
+				STATS_INC(b->stats.sleep_alloc_fail);
+			return -ENOMEM;
+		}
+
+		/* inform monitor */
+		locked = vmballoon_send_lock_page(b, page_to_pfn(page));
+		if (!locked) {
+			if (b->reset_required) {
+				__free_page(page);
+				return -EIO;
+			}
+
+			/* place on list of non-balloonable pages, retry allocation */
+			list_add(&page->lru, &b->refused_pages);
+			STATS_INC(b->stats.refused_alloc);
+		}
+	} while (!locked);
+
+	/* track allocated page */
+	list_add(&page->lru, &b->pages);
+
+	/* update balloon size */
+	b->size++;
+
+	return 0;
+}
+
+/*
+ * Release the page allocated for the balloon. Note that we first notify
+ * the host so it can make sure the page will be available for the guest
+ * to use, if needed.
+ */
+static int vmballoon_release_page(struct vmballoon *b, struct page *page)
+{
+	if (!vmballoon_send_unlock_page(b, page_to_pfn(page)))
+		return -EIO;
+
+	list_del(&page->lru);
+
+	/* deallocate page */
+	__free_page(page);
+	STATS_INC(b->stats.free);
+
+	/* update balloon size */
+	b->size--;
+
+	return 0;
+}
+
+/*
+ * Release pages that were allocated while attempting to inflate the
+ * balloon but were refused by the host for one reason or another.
+ */
+static void vmballoon_release_refused_pages(struct vmballoon *b)
+{
+	struct page *page, *next;
+
+	list_for_each_entry_safe(page, next, &b->refused_pages, lru) {
+		list_del(&page->lru);
+		__free_page(page);
+		STATS_INC(b->stats.refused_free);
+	}
+}
+
+/*
+ * Inflate the balloon towards its target size. Note that we try to limit
+ * the rate of allocation to make sure we are not choking the rest of the
+ * system.
+ */
+static void vmballoon_inflate(struct vmballoon *b)
+{
+	unsigned int goal;
+	unsigned int rate;
+	unsigned int i;
+	unsigned int allocations = 0;
+	int error = 0;
+	bool alloc_can_sleep = false;
+
+	pr_debug("%s - size: %d, target %d\n", __func__, b->size, b->target);
+
+	/*
+	 * First try NOSLEEP page allocations to inflate balloon.
+	 *
+	 * If we do not throttle nosleep allocations, we can drain all
+	 * free pages in the guest quickly (if the balloon target is high).
+	 * As a side-effect, draining free pages helps to inform (force)
+	 * the guest to start swapping if balloon target is not met yet,
+	 * which is a desired behavior. However, balloon driver can consume
+	 * all available CPU cycles if too many pages are allocated in a
+	 * second. Therefore, we throttle nosleep allocations even when
+	 * the guest is not under memory pressure. OTOH, if we have already
+	 * predicted that the guest is under memory pressure, then we
+	 * slowdown page allocations considerably.
+	 */
+
+	goal = b->target - b->size;
+	/*
+	 * Start with no sleep allocation rate which may be higher
+	 * than sleeping allocation rate.
+	 */
+	rate = b->slow_allocation_cycles ?
+			b->rate_alloc : VMW_BALLOON_NOSLEEP_ALLOC_MAX;
+
+	pr_debug("%s - goal: %d, no-sleep rate: %d, sleep rate: %d\n",
+		 __func__, goal, rate, b->rate_alloc);
+
+	for (i = 0; i < goal; i++) {
+
+		error = vmballoon_reserve_page(b, alloc_can_sleep);
+		if (error) {
+			if (error != -ENOMEM) {
+				/*
+				 * Not a page allocation failure, stop this
+				 * cycle. Maybe we'll get new target from
+				 * the host soon.
+				 */
+				break;
+			}
+
+			if (alloc_can_sleep) {
+				/*
+				 * CANSLEEP page allocation failed, so guest
+				 * is under severe memory pressure. Quickly
+				 * decrease allocation rate.
+				 */
+				b->rate_alloc = max(b->rate_alloc / 2,
+						    VMW_BALLOON_RATE_ALLOC_MIN);
+				break;
+			}
+
+			/*
+			 * NOSLEEP page allocation failed, so the guest is
+			 * under memory pressure. Let us slow down page
+			 * allocations for next few cycles so that the guest
+			 * gets out of memory pressure. Also, if we already
+			 * allocated b->rate_alloc pages, let's pause,
+			 * otherwise switch to sleeping allocations.
+			 */
+			b->slow_allocation_cycles = VMW_BALLOON_SLOW_CYCLES;
+
+			if (i >= b->rate_alloc)
+				break;
+
+			alloc_can_sleep = true;
+			/* Lower rate for sleeping allocations. */
+			rate = b->rate_alloc;
+		}
+
+		if (++allocations > VMW_BALLOON_YIELD_THRESHOLD) {
+			cond_resched();
+			allocations = 0;
+		}
+
+		if (i >= rate) {
+			/* We allocated enough pages, let's take a break. */
+			break;
+		}
+	}
+
+	/*
+	 * We reached our goal without failures so try increasing
+	 * allocation rate.
+	 */
+	if (error == 0 && i >= b->rate_alloc) {
+		unsigned int mult = i / b->rate_alloc;
+
+		b->rate_alloc =
+			min(b->rate_alloc + mult * VMW_BALLOON_RATE_ALLOC_INC,
+			    VMW_BALLOON_RATE_ALLOC_MAX);
+	}
+
+	vmballoon_release_refused_pages(b);
+}
+
+/*
+ * Decrease the size of the balloon allowing guest to use more memory.
+ */
+static void vmballoon_deflate(struct vmballoon *b)
+{
+	struct page *page, *next;
+	unsigned int i = 0;
+	unsigned int goal;
+	int error;
+
+	pr_debug("%s - size: %d, target %d\n", __func__, b->size, b->target);
+
+	/* limit deallocation rate */
+	goal = min(b->size - b->target, b->rate_free);
+
+	pr_debug("%s - goal: %d, rate: %d\n", __func__, goal, b->rate_free);
+
+	/* free pages to reach target */
+	list_for_each_entry_safe(page, next, &b->pages, lru) {
+		error = vmballoon_release_page(b, page);
+		if (error) {
+			/* quickly decrease rate in case of error */
+			b->rate_free = max(b->rate_free / 2,
+					   VMW_BALLOON_RATE_FREE_MIN);
+			return;
+		}
+
+		if (++i >= goal)
+			break;
+	}
+
+	/* slowly increase rate if there were no errors */
+	b->rate_free = min(b->rate_free + VMW_BALLOON_RATE_FREE_INC,
+			   VMW_BALLOON_RATE_FREE_MAX);
+}
+
+/*
+ * Balloon work function: reset protocol, if needed, get the new size and
+ * adjust balloon as needed. Repeat in 1 sec.
+ */
+static void vmballoon_work(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct vmballoon *b = container_of(dwork, struct vmballoon, dwork);
+	unsigned int target;
+
+	STATS_INC(b->stats.timer);
+
+	if (b->reset_required)
+		vmballoon_reset(b);
+
+	if (b->slow_allocation_cycles > 0)
+		b->slow_allocation_cycles--;
+
+	if (vmballoon_send_get_target(b, &target)) {
+		/* update target, adjust size */
+		b->target = target;
+
+		if (b->size < target)
+			vmballoon_inflate(b);
+		else if (b->size > target)
+			vmballoon_deflate(b);
+	}
+
+	queue_delayed_work(vmballoon_wq, dwork, round_jiffies_relative(HZ));
+}
+
+/*
+ * PROCFS Interface
+ */
+#ifdef CONFIG_DEBUG_FS
+
+static int vmballoon_debug_show(struct seq_file *f, void *offset)
+{
+	struct vmballoon *b = f->private;
+	struct vmballoon_stats *stats = &b->stats;
+
+	/* format size info */
+	seq_printf(f,
+		   "target:             %8d pages\n"
+		   "current:            %8d pages\n",
+		   b->target, b->size);
+
+	/* format rate info */
+	seq_printf(f,
+		   "rateNoSleepAlloc:   %8d pages/sec\n"
+		   "rateSleepAlloc:     %8d pages/sec\n"
+		   "rateFree:           %8d pages/sec\n",
+		   VMW_BALLOON_NOSLEEP_ALLOC_MAX,
+		   b->rate_alloc, b->rate_free);
+
+	seq_printf(f,
+		   "\n"
+		   "timer:              %8u\n"
+		   "start:              %8u (%4u failed)\n"
+		   "guestType:          %8u (%4u failed)\n"
+		   "lock:               %8u (%4u failed)\n"
+		   "unlock:             %8u (%4u failed)\n"
+		   "target:             %8u (%4u failed)\n"
+		   "primNoSleepAlloc:   %8u (%4u failed)\n"
+		   "primCanSleepAlloc:  %8u (%4u failed)\n"
+		   "primFree:           %8u\n"
+		   "errAlloc:           %8u\n"
+		   "errFree:            %8u\n",
+		   stats->timer,
+		   stats->start, stats->start_fail,
+		   stats->guest_type, stats->guest_type_fail,
+		   stats->lock,  stats->lock_fail,
+		   stats->unlock, stats->unlock_fail,
+		   stats->target, stats->target_fail,
+		   stats->alloc, stats->alloc_fail,
+		   stats->sleep_alloc, stats->sleep_alloc_fail,
+		   stats->free,
+		   stats->refused_alloc, stats->refused_free);
+
+	return 0;
+}
+
+static int vmballoon_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, vmballoon_debug_show, inode->i_private);
+}
+
+static const struct file_operations vmballoon_debug_fops = {
+	.owner		= THIS_MODULE,
+	.open		= vmballoon_debug_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init vmballoon_debugfs_init(struct vmballoon *b)
+{
+	int error;
+
+	b->dbg_entry = debugfs_create_file("vmmemctl", S_IRUGO, NULL, b,
+					   &vmballoon_debug_fops);
+	if (IS_ERR(b->dbg_entry)) {
+		error = PTR_ERR(b->dbg_entry);
+		pr_err("failed to create debugfs entry, error: %d\n", error);
+		return error;
+	}
+
+	return 0;
+}
+
+static void __exit vmballoon_debugfs_exit(struct vmballoon *b)
+{
+	debugfs_remove(b->dbg_entry);
+}
+
+#else
+
+static inline int vmballoon_debugfs_init(struct vmballoon *b)
+{
+	return 0;
+}
+
+static inline void vmballoon_debugfs_exit(void)
+{
+}
+
+#endif	/* CONFIG_PROC_FS */
+
+static int __init vmballoon_init(void)
+{
+	int error;
+
+	/*
+	 * Check if we are running on VMware's hypervisor and bail out
+	 * if we are not.
+	 */
+	if (!vmware_platform())
+		return -ENODEV;
+
+	vmballoon_wq = create_freezeable_workqueue("vmmemctl");
+	if (!vmballoon_wq) {
+		pr_err("failed to create workqueue\n");
+		return -ENOMEM;
+	}
+
+	/* initialize global state */
+	memset(&balloon, 0, sizeof(balloon));
+	INIT_LIST_HEAD(&balloon.pages);
+	INIT_LIST_HEAD(&balloon.refused_pages);
+
+	/* initialize rates */
+	balloon.rate_alloc = VMW_BALLOON_RATE_ALLOC_MAX;
+	balloon.rate_free = VMW_BALLOON_RATE_FREE_MAX;
+
+	INIT_DELAYED_WORK(&balloon.dwork, vmballoon_work);
+
+	/*
+	 * Start balloon.
+	 */
+	if (!vmballoon_send_start(&balloon)) {
+		pr_err("failed to send start command to the host\n");
+		error = -EIO;
+		goto fail;
+	}
+
+	if (!vmballoon_send_guest_id(&balloon)) {
+		pr_err("failed to send guest ID to the host\n");
+		error = -EIO;
+		goto fail;
+	}
+
+	error = vmballoon_debugfs_init(&balloon);
+	if (error)
+		goto fail;
+
+	queue_delayed_work(vmballoon_wq, &balloon.dwork, 0);
+
+	return 0;
+
+fail:
+	destroy_workqueue(vmballoon_wq);
+	return error;
+}
+module_init(vmballoon_init);
+
+static void __exit vmballoon_exit(void)
+{
+	cancel_delayed_work_sync(&balloon.dwork);
+	destroy_workqueue(vmballoon_wq);
+
+	vmballoon_debugfs_exit(&balloon);
+
+	/*
+	 * Deallocate all reserved memory, and reset connection with monitor.
+	 * Reset connection before deallocating memory to avoid potential for
+	 * additional spurious resets from guest touching deallocated pages.
+	 */
+	vmballoon_send_start(&balloon);
+	vmballoon_pop(&balloon);
+}
+module_exit(vmballoon_exit);
_

Patches currently in -mm which might be from dtor@vmware.com are

vmware-balloon-driver.patch

