From: akpm@linux-foundation.org
Subject: + mm-teach-mm-by-current-context-info-to-not-do-i-o-during-memory-allocation.patch added to -mm tree
Date: Thu, 17 Jan 2013 13:57:43 -0800
Message-ID: <20130117215743.D79C85A41EB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ia0-f202.google.com ([209.85.210.202]:43959 "EHLO
	mail-ia0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756725Ab3AQV5q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Jan 2013 16:57:46 -0500
Received: by mail-ia0-f202.google.com with SMTP id p22so211317iad.1
        for <mm-commits@vger.kernel.org>; Thu, 17 Jan 2013 13:57:46 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ming.lei@canonical.com, axboe@kernel.dk, davem@davemloft.net, david.decotigny@google.com, eric.dumazet@gmail.com, greg@kroah.com, jiri.kosina@suse.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mhocko@suse.cz, minchan@kernel.org, mingo@elte.hu, mingo@redhat.com, oneukum@suse.de, peterz@infradead.org, rjw@sisk.pl, stern@rowland.harvard.edu, therbert@google.com


The patch titled
     Subject: mm: teach mm by current context info to not do I/O during memory allocation
has been added to the -mm tree.  Its filename is
     mm-teach-mm-by-current-context-info-to-not-do-i-o-during-memory-allocation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ming Lei <ming.lei@canonical.com>
Subject: mm: teach mm by current context info to not do I/O during memory allocation

This patch introduces PF_MEMALLOC_NOIO on process flag('flags' field of
'struct task_struct'), so that the flag can be set by one task to avoid
doing I/O inside memory allocation in the task's context.

The patch trys to solve one deadlock problem caused by block device, and
the problem may happen at least in the below situations:

- during block device runtime resume, if memory allocation with
  GFP_KERNEL is called inside runtime resume callback of any one of its
  ancestors(or the block device itself), the deadlock may be triggered
  inside the memory allocation since it might not complete until the block
  device becomes active and the involed page I/O finishes.  The situation
  is pointed out first by Alan Stern.  It is not a good approach to
  convert all GFP_KERNEL[1] in the path into GFP_NOIO because several
  subsystems may be involved(for example, PCI, USB and SCSI may be
  involved for usb mass stoarage device, network devices involved too in
  the iSCSI case)

- during block device runtime suspend, because runtime resume need to
  wait for completion of concurrent runtime suspend.

- during error handling of usb mass storage deivce, USB bus reset will
  be put on the device, so there shouldn't have any memory allocation with
  GFP_KERNEL during USB bus reset, otherwise the deadlock similar with
  above may be triggered.  Unfortunately, any usb device may include one
  mass storage interface in theory, so it requires all usb interface
  drivers to handle the situation.  In fact, most usb drivers don't know
  how to handle bus reset on the device and don't provide .pre_set() and
  .post_reset() callback at all, so USB core has to unbind and bind driver
  for these devices.  So it is still not practical to resort to GFP_NOIO
  for solving the problem.

Also the introduced solution can be used by block subsystem or block
drivers too, for example, set the PF_MEMALLOC_NOIO flag before doing
actual I/O transfer.

It is not a good idea to convert all these GFP_KERNEL in the affected path
into GFP_NOIO because these functions doing that may be implemented as
library and will be called in many other contexts.

In fact, memalloc_noio_flags() can convert some of current static GFP_NOIO
allocation into GFP_KERNEL back in other non-affected contexts, at least
almost all GFP_NOIO in USB subsystem can be converted into GFP_KERNEL
after applying the approach and make allocation with GFP_NOIO only happen
in runtime resume/bus reset/block I/O transfer contexts generally.

[1], several GFP_KERNEL allocation examples in runtime resume path

- pci subsystem
acpi_os_allocate
	<-acpi_ut_allocate
		<-ACPI_ALLOCATE_ZEROED
			<-acpi_evaluate_object
				<-__acpi_bus_set_power
					<-acpi_bus_set_power
						<-acpi_pci_set_power_state
							<-platform_pci_set_power_state
								<-pci_platform_power_transition
									<-__pci_complete_power_transition
										<-pci_set_power_state
											<-pci_restore_standard_config
												<-pci_pm_runtime_resume
- usb subsystem
usb_get_status
	<-finish_port_resume
		<-usb_port_resume
			<-generic_resume
				<-usb_resume_device
					<-usb_resume_both
						<-usb_runtime_resume

- some individual usb drivers
usblp, uvc, gspca, most of dvb-usb-v2 media drivers, cpia2, az6007, ....

That is just what I have found.  Unfortunately, this allocation can only
be found by human being now, and there should be many not found since any
function in the resume path(call tree) may allocate memory with
GFP_KERNEL.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oneukum@suse.de>
Cc: Jiri Kosina <jiri.kosina@suse.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <greg@kroah.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Decotigny <david.decotigny@google.com>
Cc: Tom Herbert <therbert@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |   22 ++++++++++++++++++++++
 mm/page_alloc.c       |    9 ++++++++-
 mm/vmscan.c           |    4 ++--
 3 files changed, 32 insertions(+), 3 deletions(-)

diff -puN include/linux/sched.h~mm-teach-mm-by-current-context-info-to-not-do-i-o-during-memory-allocation include/linux/sched.h
--- a/include/linux/sched.h~mm-teach-mm-by-current-context-info-to-not-do-i-o-during-memory-allocation
+++ a/include/linux/sched.h
@@ -51,6 +51,7 @@ struct sched_param {
 #include <linux/cred.h>
 #include <linux/llist.h>
 #include <linux/uidgid.h>
+#include <linux/gfp.h>
 
 #include <asm/processor.h>
 
@@ -1815,6 +1816,7 @@ extern void thread_group_cputime_adjuste
 #define PF_FROZEN	0x00010000	/* frozen for system suspend */
 #define PF_FSTRANS	0x00020000	/* inside a filesystem transaction */
 #define PF_KSWAPD	0x00040000	/* I am kswapd */
+#define PF_MEMALLOC_NOIO 0x00080000	/* Allocating memory without IO involved */
 #define PF_LESS_THROTTLE 0x00100000	/* Throttle me less: I clean memory */
 #define PF_KTHREAD	0x00200000	/* I am a kernel thread */
 #define PF_RANDOMIZE	0x00400000	/* randomize virtual address space */
@@ -1852,6 +1854,26 @@ extern void thread_group_cputime_adjuste
 #define tsk_used_math(p) ((p)->flags & PF_USED_MATH)
 #define used_math() tsk_used_math(current)
 
+/* __GFP_IO isn't allowed if PF_MEMALLOC_NOIO is set in current->flags */
+static inline gfp_t memalloc_noio_flags(gfp_t flags)
+{
+	if (unlikely(current->flags & PF_MEMALLOC_NOIO))
+		flags &= ~__GFP_IO;
+	return flags;
+}
+
+static inline unsigned int memalloc_noio_save(void)
+{
+	unsigned int flags = current->flags & PF_MEMALLOC_NOIO;
+	current->flags |= PF_MEMALLOC_NOIO;
+	return flags;
+}
+
+static inline void memalloc_noio_restore(unsigned int flags)
+{
+	current->flags = (current->flags & ~PF_MEMALLOC_NOIO) | flags;
+}
+
 /*
  * task->jobctl flags
  */
diff -puN mm/page_alloc.c~mm-teach-mm-by-current-context-info-to-not-do-i-o-during-memory-allocation mm/page_alloc.c
--- a/mm/page_alloc.c~mm-teach-mm-by-current-context-info-to-not-do-i-o-during-memory-allocation
+++ a/mm/page_alloc.c
@@ -2616,10 +2616,17 @@ retry_cpuset:
 	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
 			zonelist, high_zoneidx, alloc_flags,
 			preferred_zone, migratetype);
-	if (unlikely(!page))
+	if (unlikely(!page)) {
+		/*
+		 * Runtime PM, block IO and its error handling path
+		 * can deadlock because I/O on the device might not
+		 * complete.
+		 */
+		gfp_mask = memalloc_noio_flags(gfp_mask);
 		page = __alloc_pages_slowpath(gfp_mask, order,
 				zonelist, high_zoneidx, nodemask,
 				preferred_zone, migratetype);
+	}
 
 	trace_mm_page_alloc(page, order, gfp_mask, migratetype);
 
diff -puN mm/vmscan.c~mm-teach-mm-by-current-context-info-to-not-do-i-o-during-memory-allocation mm/vmscan.c
--- a/mm/vmscan.c~mm-teach-mm-by-current-context-info-to-not-do-i-o-during-memory-allocation
+++ a/mm/vmscan.c
@@ -2352,7 +2352,7 @@ unsigned long try_to_free_pages(struct z
 {
 	unsigned long nr_reclaimed;
 	struct scan_control sc = {
-		.gfp_mask = gfp_mask,
+		.gfp_mask = (gfp_mask = memalloc_noio_flags(gfp_mask)),
 		.may_writepage = !laptop_mode,
 		.nr_to_reclaim = SWAP_CLUSTER_MAX,
 		.may_unmap = 1,
@@ -3313,7 +3313,7 @@ static int __zone_reclaim(struct zone *z
 		.may_unmap = !!(zone_reclaim_mode & RECLAIM_SWAP),
 		.may_swap = 1,
 		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
-		.gfp_mask = gfp_mask,
+		.gfp_mask = (gfp_mask = memalloc_noio_flags(gfp_mask)),
 		.order = order,
 		.priority = ZONE_RECLAIM_PRIORITY,
 	};
_

Patches currently in -mm which might be from ming.lei@canonical.com are

origin.patch
linux-next.patch
mm-teach-mm-by-current-context-info-to-not-do-i-o-during-memory-allocation.patch
pm-runtime-introduce-pm_runtime_set_memalloc_noio.patch
block-genhdc-apply-pm_runtime_set_memalloc_noio-on-block-devices.patch
net-core-apply-pm_runtime_set_memalloc_noio-on-network-devices.patch
pm-runtime-force-memory-allocation-with-no-i-o-during-runtime-pm-callbcack.patch
usb-forbid-memory-allocation-with-i-o-during-bus-reset.patch

