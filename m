From: akpm@linux-foundation.org
Subject: + sgi-xp-enable-building-of-xpc-xpnet-on-x86_64.patch added to -mm tree
Date: Sat, 12 Jul 2008 23:10:40 -0700
Message-ID: <200807130610.m6D6AecT007344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57218 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751994AbYGMGKp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jul 2008 02:10:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dcn@sgi.com, steiner@sgi.com, tony.luck@intel.com


The patch titled
     sgi-xp: enable building of XPC/XPNET on x86_64
has been added to the -mm tree.  Its filename is
     sgi-xp-enable-building-of-xpc-xpnet-on-x86_64.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sgi-xp: enable building of XPC/XPNET on x86_64
From: Dean Nelson <dcn@sgi.com>

Get XPC/XPNET to build on x86_64.  Trying to modprobe them up on a non-UV
or sn2 system will result in a -ENODEV.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Cc: Jack Steiner <steiner@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig                |    2 -
 drivers/misc/sgi-xp/Makefile        |   14 +++++--
 drivers/misc/sgi-xp/xp.h            |   32 +++++++++++-----
 drivers/misc/sgi-xp/xp_main.c       |   10 ++++-
 drivers/misc/sgi-xp/xp_sn2.c        |   10 +++++
 drivers/misc/sgi-xp/xpc.h           |   34 +++++++-----------
 drivers/misc/sgi-xp/xpc_channel.c   |   18 +++------
 drivers/misc/sgi-xp/xpc_main.c      |   49 +++++++++++++-------------
 drivers/misc/sgi-xp/xpc_partition.c |   47 ++++++++++--------------
 drivers/misc/sgi-xp/xpc_sn2.c       |   30 +++++++++++++--
 drivers/misc/sgi-xp/xpc_uv.c        |    7 +--
 drivers/misc/sgi-xp/xpnet.c         |   28 +++++---------
 12 files changed, 155 insertions(+), 126 deletions(-)

diff -puN drivers/misc/Kconfig~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64 drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64
+++ a/drivers/misc/Kconfig
@@ -425,7 +425,7 @@ config ENCLOSURE_SERVICES
 
 config SGI_XP
 	tristate "Support communication between SGI SSIs"
-	depends on IA64_GENERIC || IA64_SGI_SN2
+	depends on IA64_GENERIC || IA64_SGI_SN2 || IA64_SGI_UV || (X86_64 && SMP)
 	select IA64_UNCACHED_ALLOCATOR if IA64_GENERIC || IA64_SGI_SN2
 	select GENERIC_ALLOCATOR if IA64_GENERIC || IA64_SGI_SN2
 	---help---
diff -puN drivers/misc/sgi-xp/Makefile~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64 drivers/misc/sgi-xp/Makefile
--- a/drivers/misc/sgi-xp/Makefile~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64
+++ a/drivers/misc/sgi-xp/Makefile
@@ -3,11 +3,17 @@
 #
 
 obj-$(CONFIG_SGI_XP)		+= xp.o
-xp-y				:= xp_main.o xp_uv.o
-xp-$(CONFIG_IA64)		+= xp_sn2.o xp_nofault.o
+xp-y				:= xp_main.o
+xp-$(CONFIG_IA64_SGI_SN2)	+= xp_sn2.o xp_nofault.o
+xp-$(CONFIG_IA64_GENERIC)	+= xp_sn2.o xp_nofault.o xp_uv.o
+xp-$(CONFIG_IA64_SGI_UV)	+= xp_uv.o
+xp-$(CONFIG_X86_64)		+= xp_uv.o
 
 obj-$(CONFIG_SGI_XP)		+= xpc.o
-xpc-y				:= xpc_main.o xpc_uv.o xpc_channel.o xpc_partition.o
-xpc-$(CONFIG_IA64)		+= xpc_sn2.o
+xpc-y				:= xpc_main.o xpc_channel.o xpc_partition.o
+xpc-$(CONFIG_IA64_SGI_SN2)	+= xpc_sn2.o
+xpc-$(CONFIG_IA64_GENERIC)	+= xpc_sn2.o xpc_uv.o
+xpc-$(CONFIG_IA64_SGI_UV) 	+= xpc_uv.o
+xpc-$(CONFIG_X86_64)		+= xpc_uv.o
 
 obj-$(CONFIG_SGI_XP)		+= xpnet.o
diff -puN drivers/misc/sgi-xp/xp.h~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64 drivers/misc/sgi-xp/xp.h
--- a/drivers/misc/sgi-xp/xp.h~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64
+++ a/drivers/misc/sgi-xp/xp.h
@@ -13,18 +13,17 @@
 #ifndef _DRIVERS_MISC_SGIXP_XP_H
 #define _DRIVERS_MISC_SGIXP_XP_H
 
-#include <linux/cache.h>
-#include <linux/hardirq.h>
 #include <linux/mutex.h>
-#include <asm/sn/types.h>
+
 #ifdef CONFIG_IA64
-#include <asm/sn/arch.h>
+#include <asm/system.h>
+#include <asm/sn/arch.h>	/* defines is_shub1() and is_shub2() */
+#define is_shub()	ia64_platform_is("sn2")
+#define is_uv()		ia64_platform_is("uv")
 #endif
-
-#ifdef USE_DBUG_ON
-#define DBUG_ON(condition)	BUG_ON(condition)
-#else
-#define DBUG_ON(condition)
+#ifdef CONFIG_X86_64
+#include <asm/genapic.h>
+#define is_uv()		is_uv_system()
 #endif
 
 #ifndef is_shub1
@@ -36,13 +35,19 @@
 #endif
 
 #ifndef is_shub
-#define is_shub()	(is_shub1() || is_shub2())
+#define is_shub()	0
 #endif
 
 #ifndef is_uv
 #define is_uv()		0
 #endif
 
+#ifdef USE_DBUG_ON
+#define DBUG_ON(condition)	BUG_ON(condition)
+#else
+#define DBUG_ON(condition)
+#endif
+
 /*
  * Define the maximum number of partitions the system can possibly support.
  * It is based on the maximum number of hardware partitionable regions. The
@@ -200,7 +205,9 @@ enum xp_retval {
 	xpPayloadTooBig,	/* 55: payload too large for message slot */
 
 	xpUnsupported,		/* 56: unsupported functionality or resource */
-	xpUnknownReason		/* 57: unknown reason - must be last in enum */
+	xpNeedMoreInfo,		/* 57: more info is needed by SAL */
+
+	xpUnknownReason		/* 58: unknown reason - must be last in enum */
 };
 
 /*
@@ -339,8 +346,11 @@ xpc_partid_to_nasids(short partid, void 
 }
 
 extern short xp_max_npartitions;
+extern short xp_partition_id;
+extern u8 xp_region_size;
 
 extern enum xp_retval (*xp_remote_memcpy) (void *, const void *, size_t);
+extern int (*xp_cpu_to_nasid) (int);
 
 extern u64 xp_nofault_PIOR_target;
 extern int xp_nofault_PIOR(void *);
diff -puN drivers/misc/sgi-xp/xp_main.c~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64 drivers/misc/sgi-xp/xp_main.c
--- a/drivers/misc/sgi-xp/xp_main.c~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64
+++ a/drivers/misc/sgi-xp/xp_main.c
@@ -14,7 +14,6 @@
  *
  */
 
-#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include "xp.h"
@@ -36,9 +35,18 @@ struct device *xp = &xp_dbg_subname;
 short xp_max_npartitions;
 EXPORT_SYMBOL_GPL(xp_max_npartitions);
 
+short xp_partition_id;
+EXPORT_SYMBOL_GPL(xp_partition_id);
+
+u8 xp_region_size;
+EXPORT_SYMBOL_GPL(xp_region_size);
+
 enum xp_retval (*xp_remote_memcpy) (void *dst, const void *src, size_t len);
 EXPORT_SYMBOL_GPL(xp_remote_memcpy);
 
+int (*xp_cpu_to_nasid) (int cpuid);
+EXPORT_SYMBOL_GPL(xp_cpu_to_nasid);
+
 /*
  * xpc_registrations[] keeps track of xpc_connect()'s done by the kernel-level
  * users of XPC.
diff -puN drivers/misc/sgi-xp/xp_sn2.c~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64 drivers/misc/sgi-xp/xp_sn2.c
--- a/drivers/misc/sgi-xp/xp_sn2.c~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64
+++ a/drivers/misc/sgi-xp/xp_sn2.c
@@ -12,6 +12,7 @@
  *      Architecture specific implementation of common functions.
  */
 
+#include <linux/module.h>
 #include <linux/device.h>
 #include <asm/sn/bte.h>
 #include <asm/sn/sn_sal.h>
@@ -116,14 +117,23 @@ xp_remote_memcpy_sn2(void *vdst, const v
 	return xpBteCopyError;
 }
 
+static int
+xp_cpu_to_nasid_sn2(int cpuid)
+{
+	return cpuid_to_nasid(cpuid);
+}
+
 enum xp_retval
 xp_init_sn2(void)
 {
 	BUG_ON(!is_shub());
 
 	xp_max_npartitions = XP_MAX_NPARTITIONS_SN2;
+	xp_partition_id = sn_partition_id;
+	xp_region_size = sn_region_size;
 
 	xp_remote_memcpy = xp_remote_memcpy_sn2;
+	xp_cpu_to_nasid = xp_cpu_to_nasid_sn2;
 
 	return xp_register_nofault_code_sn2();
 }
diff -puN drivers/misc/sgi-xp/xpc.h~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64 drivers/misc/sgi-xp/xpc.h
--- a/drivers/misc/sgi-xp/xpc.h~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64
+++ a/drivers/misc/sgi-xp/xpc.h
@@ -13,17 +13,10 @@
 #ifndef _DRIVERS_MISC_SGIXP_XPC_H
 #define _DRIVERS_MISC_SGIXP_XPC_H
 
-#include <linux/interrupt.h>
-#include <linux/sysctl.h>
-#include <linux/device.h>
-#include <linux/mutex.h>
+#include <linux/wait.h>
 #include <linux/completion.h>
-#include <asm/pgtable.h>
-#include <asm/processor.h>
-#include <asm/sn/clksupport.h>
-#include <asm/sn/addrs.h>
-#include <asm/sn/mspec.h>
-#include <asm/sn/shub_mmr.h>
+#include <linux/timer.h>
+#include <linux/sched.h>
 #include "xp.h"
 
 /*
@@ -179,7 +172,8 @@ struct xpc_vars_part_sn2 {
 #define XPC_RP_HEADER_SIZE	L1_CACHE_ALIGN(sizeof(struct xpc_rsvd_page))
 #define XPC_RP_VARS_SIZE	L1_CACHE_ALIGN(sizeof(struct xpc_vars_sn2))
 
-#define XPC_RP_PART_NASIDS(_rp) ((u64 *)((u8 *)(_rp) + XPC_RP_HEADER_SIZE))
+#define XPC_RP_PART_NASIDS(_rp) ((unsigned long *)((u8 *)(_rp) + \
+				 XPC_RP_HEADER_SIZE))
 #define XPC_RP_MACH_NASIDS(_rp) (XPC_RP_PART_NASIDS(_rp) + \
 				 xpc_nasid_mask_nlongs)
 #define XPC_RP_VARS(_rp)	((struct xpc_vars_sn2 *) \
@@ -202,13 +196,13 @@ struct xpc_vars_part_sn2 {
 /*
  * Define a Get/Put value pair (pointers) used with a message queue.
  */
-struct xpc_gp {
+struct xpc_gp_sn2 {
 	s64 get;		/* Get value */
 	s64 put;		/* Put value */
 };
 
 #define XPC_GP_SIZE \
-		L1_CACHE_ALIGN(sizeof(struct xpc_gp) * XPC_MAX_NCHANNELS)
+		L1_CACHE_ALIGN(sizeof(struct xpc_gp_sn2) * XPC_MAX_NCHANNELS)
 
 /*
  * Define a structure that contains arguments associated with opening and
@@ -340,10 +334,10 @@ struct xpc_channel_sn2 {
 
 	/* various flavors of local and remote Get/Put values */
 
-	struct xpc_gp *local_GP;	/* local Get/Put values */
-	struct xpc_gp remote_GP;	/* remote Get/Put values */
-	struct xpc_gp w_local_GP;	/* working local Get/Put values */
-	struct xpc_gp w_remote_GP;	/* working remote Get/Put values */
+	struct xpc_gp_sn2 *local_GP;	/* local Get/Put values */
+	struct xpc_gp_sn2 remote_GP;	/* remote Get/Put values */
+	struct xpc_gp_sn2 w_local_GP;	/* working local Get/Put values */
+	struct xpc_gp_sn2 w_remote_GP;	/* working remote Get/Put values */
 	s64 next_msg_to_pull;	/* Put value of next msg to pull */
 
 	struct mutex msg_to_pull_mutex;	/* next msg to pull serialization */
@@ -506,9 +500,9 @@ struct xpc_partition_sn2 {
 	u8 remote_vars_version;	/* version# of partition's vars */
 
 	void *local_GPs_base;	/* base address of kmalloc'd space */
-	struct xpc_gp *local_GPs;	/* local Get/Put values */
+	struct xpc_gp_sn2 *local_GPs;	/* local Get/Put values */
 	void *remote_GPs_base;	/* base address of kmalloc'd space */
-	struct xpc_gp *remote_GPs;	/* copy of remote partition's local */
+	struct xpc_gp_sn2 *remote_GPs;	/* copy of remote partition's local */
 					/* Get/Put values */
 	u64 remote_GPs_pa;	/* phys address of remote partition's local */
 				/* Get/Put values */
@@ -629,6 +623,8 @@ extern void xpc_activate_partition(struc
 extern void xpc_activate_kthreads(struct xpc_channel *, int);
 extern void xpc_create_kthreads(struct xpc_channel *, int, int);
 extern void xpc_disconnect_wait(int);
+extern enum xp_retval (*xpc_get_partition_rsvd_page_pa) (u64, u64 *, u64 *,
+							 size_t *);
 extern enum xp_retval (*xpc_rsvd_page_init) (struct xpc_rsvd_page *);
 extern void (*xpc_heartbeat_init) (void);
 extern void (*xpc_heartbeat_exit) (void);
diff -puN drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64 drivers/misc/sgi-xp/xpc_channel.c
--- a/drivers/misc/sgi-xp/xpc_channel.c~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64
+++ a/drivers/misc/sgi-xp/xpc_channel.c
@@ -14,14 +14,7 @@
  *
  */
 
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/sched.h>
-#include <linux/cache.h>
-#include <linux/interrupt.h>
-#include <linux/mutex.h>
-#include <linux/completion.h>
-#include <asm/sn/sn_sal.h>
+#include <linux/device.h>
 #include "xpc.h"
 
 /*
@@ -373,8 +366,9 @@ again:
 		dev_dbg(xpc_chan, "XPC_CHCTL_OPENREPLY (local_msgqueue_pa="
 			"0x%lx, local_nentries=%d, remote_nentries=%d) "
 			"received from partid=%d, channel=%d\n",
-			args->local_msgqueue_pa, args->local_nentries,
-			args->remote_nentries, ch->partid, ch->number);
+			(unsigned long)args->local_msgqueue_pa,
+			args->local_nentries, args->remote_nentries,
+			ch->partid, ch->number);
 
 		if (ch->flags & (XPC_C_DISCONNECTING | XPC_C_DISCONNECTED)) {
 			spin_unlock_irqrestore(&ch->lock, irq_flags);
@@ -940,7 +934,7 @@ xpc_deliver_msg(struct xpc_channel *ch)
 		if (ch->func != NULL) {
 			dev_dbg(xpc_chan, "ch->func() called, msg=0x%p, "
 				"msg_number=%ld, partid=%d, channel=%d\n",
-				(void *)msg, msg->number, ch->partid,
+				msg, (signed long)msg->number, ch->partid,
 				ch->number);
 
 			/* deliver the message to its intended recipient */
@@ -949,7 +943,7 @@ xpc_deliver_msg(struct xpc_channel *ch)
 
 			dev_dbg(xpc_chan, "ch->func() returned, msg=0x%p, "
 				"msg_number=%ld, partid=%d, channel=%d\n",
-				(void *)msg, msg->number, ch->partid,
+				msg, (signed long)msg->number, ch->partid,
 				ch->number);
 		}
 
diff -puN drivers/misc/sgi-xp/xpc_main.c~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64 drivers/misc/sgi-xp/xpc_main.c
--- a/drivers/misc/sgi-xp/xpc_main.c~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64
+++ a/drivers/misc/sgi-xp/xpc_main.c
@@ -43,19 +43,13 @@
  *
  */
 
-#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
-#include <linux/cache.h>
-#include <linux/interrupt.h>
+#include <linux/sysctl.h>
+#include <linux/device.h>
 #include <linux/delay.h>
 #include <linux/reboot.h>
-#include <linux/completion.h>
 #include <linux/kdebug.h>
 #include <linux/kthread.h>
-#include <linux/uaccess.h>
-#include <asm/sn/intr.h>
-#include <asm/sn/sn_sal.h>
 #include "xpc.h"
 
 /* define two XPC debug device structures to be used with dev_dbg() et al */
@@ -175,6 +169,8 @@ static struct notifier_block xpc_die_not
 	.notifier_call = xpc_system_die,
 };
 
+enum xp_retval (*xpc_get_partition_rsvd_page_pa) (u64 buf, u64 *cookie,
+						  u64 *paddr, size_t *len);
 enum xp_retval (*xpc_rsvd_page_init) (struct xpc_rsvd_page *rp);
 void (*xpc_heartbeat_init) (void);
 void (*xpc_heartbeat_exit) (void);
@@ -920,7 +916,8 @@ xpc_die_deactivate(void)
 	struct xpc_partition *part;
 	short partid;
 	int any_engaged;
-	long time, printmsg_time, disengage_timeout;
+	long keep_waiting;
+	long wait_to_print;
 
 	/* keep xpc_hb_checker thread from doing anything (just in case) */
 	xpc_exiting = 1;
@@ -937,16 +934,17 @@ xpc_die_deactivate(void)
 		}
 	}
 
-	time = rtc_time();
-	printmsg_time = time +
-	    (XPC_DEACTIVATE_PRINTMSG_INTERVAL * sn_rtc_cycles_per_second);
-	disengage_timeout = time +
-	    (xpc_disengage_timelimit * sn_rtc_cycles_per_second);
-
 	/*
 	 * Though we requested that all other partitions deactivate from us,
-	 * we only wait until they've all disengaged.
+	 * we only wait until they've all disengaged or we've reached the
+	 * defined timelimit.
+	 *
+	 * Given that one iteration through the following while-loop takes
+	 * approximately 200 microseconds, calculate the #of loops to take
+	 * before bailing and the #of loops before printing a waiting message.
 	 */
+	keep_waiting = xpc_disengage_timelimit * 1000 * 5;
+	wait_to_print = XPC_DEACTIVATE_PRINTMSG_INTERVAL * 1000 * 5;
 
 	while (1) {
 		any_engaged = xpc_any_partition_engaged();
@@ -955,8 +953,7 @@ xpc_die_deactivate(void)
 			break;
 		}
 
-		time = rtc_time();
-		if (time >= disengage_timeout) {
+		if (!keep_waiting--) {
 			for (partid = 0; partid < xp_max_npartitions;
 			     partid++) {
 				if (xpc_partition_engaged(partid)) {
@@ -968,15 +965,15 @@ xpc_die_deactivate(void)
 			break;
 		}
 
-		if (time >= printmsg_time) {
+		if (!wait_to_print--) {
 			dev_info(xpc_part, "waiting for remote partitions to "
 				 "deactivate, timeout in %ld seconds\n",
-				 (disengage_timeout - time) /
-				 sn_rtc_cycles_per_second);
-			printmsg_time = time +
-			    (XPC_DEACTIVATE_PRINTMSG_INTERVAL *
-			     sn_rtc_cycles_per_second);
+				 keep_waiting / (1000 * 5));
+			wait_to_print = XPC_DEACTIVATE_PRINTMSG_INTERVAL *
+			    1000 * 5;
 		}
+
+		udelay(200);
 	}
 }
 
@@ -991,6 +988,7 @@ xpc_die_deactivate(void)
 static int
 xpc_system_die(struct notifier_block *nb, unsigned long event, void *unused)
 {
+#ifdef CONFIG_IA64		/* !!! temporary kludge */
 	switch (event) {
 	case DIE_MACHINE_RESTART:
 	case DIE_MACHINE_HALT:
@@ -1019,6 +1017,9 @@ xpc_system_die(struct notifier_block *nb
 		xpc_online_heartbeat();
 		break;
 	}
+#else
+	xpc_die_deactivate();
+#endif
 
 	return NOTIFY_DONE;
 }
diff -puN drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64 drivers/misc/sgi-xp/xpc_partition.c
--- a/drivers/misc/sgi-xp/xpc_partition.c~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64
+++ a/drivers/misc/sgi-xp/xpc_partition.c
@@ -15,15 +15,8 @@
  *
  */
 
-#include <linux/kernel.h>
-#include <linux/sysctl.h>
-#include <linux/cache.h>
-#include <linux/mmzone.h>
-#include <linux/nodemask.h>
-#include <asm/sn/intr.h>
-#include <asm/sn/sn_sal.h>
-#include <asm/sn/nodepda.h>
-#include <asm/sn/addrs.h>
+#include <linux/device.h>
+#include <linux/hardirq.h>
 #include "xpc.h"
 
 /* XPC is exiting flag */
@@ -71,24 +64,23 @@ static u64
 xpc_get_rsvd_page_pa(int nasid)
 {
 	enum xp_retval ret;
-	s64 status;
 	u64 cookie = 0;
 	u64 rp_pa = nasid;	/* seed with nasid */
-	u64 len = 0;
+	size_t len = 0;
 	u64 buf = buf;
 	u64 buf_len = 0;
 	void *buf_base = NULL;
 
 	while (1) {
 
-		status = sn_partition_reserved_page_pa(buf, &cookie, &rp_pa,
-						       &len);
+		ret = xpc_get_partition_rsvd_page_pa(buf, &cookie, &rp_pa,
+						     &len);
 
-		dev_dbg(xpc_part, "SAL returned with status=%li, cookie="
-			"0x%016lx, address=0x%016lx, len=0x%016lx\n",
-			status, cookie, rp_pa, len);
+		dev_dbg(xpc_part, "SAL returned with ret=%d, cookie=0x%016lx, "
+			"address=0x%016lx, len=0x%016lx\n", ret,
+			(unsigned long)cookie, (unsigned long)rp_pa, len);
 
-		if (status != SALRET_MORE_PASSES)
+		if (ret != xpNeedMoreInfo)
 			break;
 
 		/* !!! L1_CACHE_ALIGN() is only a sn2-bte_copy requirement */
@@ -100,8 +92,9 @@ xpc_get_rsvd_page_pa(int nasid)
 								 &buf_base);
 			if (buf_base == NULL) {
 				dev_err(xpc_part, "unable to kmalloc "
-					"len=0x%016lx\n", buf_len);
-				status = SALRET_ERROR;
+					"len=0x%016lx\n",
+					(unsigned long)buf_len);
+				ret = xpNoMemory;
 				break;
 			}
 		}
@@ -109,17 +102,17 @@ xpc_get_rsvd_page_pa(int nasid)
 		ret = xp_remote_memcpy((void *)buf, (void *)rp_pa, buf_len);
 		if (ret != xpSuccess) {
 			dev_dbg(xpc_part, "xp_remote_memcpy failed %d\n", ret);
-			status = SALRET_ERROR;
 			break;
 		}
 	}
 
 	kfree(buf_base);
 
-	if (status != SALRET_OK)
+	if (ret != xpSuccess)
 		rp_pa = 0;
 
-	dev_dbg(xpc_part, "reserved page at phys address 0x%016lx\n", rp_pa);
+	dev_dbg(xpc_part, "reserved page at phys address 0x%016lx\n",
+		(unsigned long)rp_pa);
 	return rp_pa;
 }
 
@@ -138,7 +131,7 @@ xpc_setup_rsvd_page(void)
 	/* get the local reserved page's address */
 
 	preempt_disable();
-	rp_pa = xpc_get_rsvd_page_pa(cpuid_to_nasid(smp_processor_id()));
+	rp_pa = xpc_get_rsvd_page_pa(xp_cpu_to_nasid(smp_processor_id()));
 	preempt_enable();
 	if (rp_pa == 0) {
 		dev_err(xpc_part, "SAL failed to locate the reserved page\n");
@@ -150,7 +143,7 @@ xpc_setup_rsvd_page(void)
 		/* SAL_versions < 3 had a SAL_partid defined as a u8 */
 		rp->SAL_partid &= 0xff;
 	}
-	BUG_ON(rp->SAL_partid != sn_partition_id);
+	BUG_ON(rp->SAL_partid != xp_partition_id);
 
 	if (rp->SAL_partid < 0 || rp->SAL_partid >= xp_max_npartitions) {
 		dev_err(xpc_part, "the reserved page's partid of %d is outside "
@@ -237,11 +230,11 @@ xpc_get_remote_rp(int nasid, unsigned lo
 	/* check that both remote and local partids are valid for each side */
 	if (remote_rp->SAL_partid < 0 ||
 	    remote_rp->SAL_partid >= xp_max_npartitions ||
-	    remote_rp->max_npartitions <= sn_partition_id) {
+	    remote_rp->max_npartitions <= xp_partition_id) {
 		return xpInvalidPartid;
 	}
 
-	if (remote_rp->SAL_partid == sn_partition_id)
+	if (remote_rp->SAL_partid == xp_partition_id)
 		return xpLocalPartid;
 
 	return xpSuccess;
@@ -426,7 +419,7 @@ xpc_discovery(void)
 	 * protection is in regards to memory, IOI and IPI.
 	 */
 	max_regions = 64;
-	region_size = sn_region_size;
+	region_size = xp_region_size;
 
 	switch (region_size) {
 	case 128:
diff -puN drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64 drivers/misc/sgi-xp/xpc_sn2.c
--- a/drivers/misc/sgi-xp/xpc_sn2.c~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64
+++ a/drivers/misc/sgi-xp/xpc_sn2.c
@@ -13,9 +13,9 @@
  *
  */
 
-#include <linux/kernel.h>
 #include <linux/delay.h>
 #include <asm/uncached.h>
+#include <asm/sn/mspec.h>
 #include <asm/sn/sn_sal.h>
 #include "xpc.h"
 
@@ -176,7 +176,7 @@ xpc_send_IRQ_sn2(struct amo *amo, u64 fl
 
 	local_irq_restore(irq_flags);
 
-	return ((ret == 0) ? xpSuccess : xpPioReadError);
+	return (ret == 0) ? xpSuccess : xpPioReadError;
 }
 
 static struct amo *
@@ -284,7 +284,7 @@ xpc_handle_notify_IRQ_sn2(int irq, void 
 	short partid = (short)(u64)dev_id;
 	struct xpc_partition *part = &xpc_partitions[partid];
 
-	DBUG_ON(partid < 0 || partid >= xp_max_npartitions);
+	DBUG_ON(partid < 0 || partid >= XP_MAX_NPARTITIONS_SN2);
 
 	if (xpc_part_ref(part)) {
 		xpc_check_for_sent_chctl_flags_sn2(part);
@@ -577,6 +577,25 @@ xpc_allow_amo_ops_shub_wars_1_1_sn2(void
 }
 
 static enum xp_retval
+xpc_get_partition_rsvd_page_pa_sn2(u64 buf, u64 *cookie, u64 *paddr,
+				   size_t *len)
+{
+	s64 status;
+	enum xp_retval ret;
+
+	status = sn_partition_reserved_page_pa(buf, cookie, paddr, len);
+	if (status == SALRET_OK)
+		ret = xpSuccess;
+	else if (status == SALRET_MORE_PASSES)
+		ret = xpNeedMoreInfo;
+	else
+		ret = xpSalError;
+
+	return ret;
+}
+
+
+static enum xp_retval
 xpc_rsvd_page_init_sn2(struct xpc_rsvd_page *rp)
 {
 	struct amo *amos_page;
@@ -636,7 +655,7 @@ xpc_rsvd_page_init_sn2(struct xpc_rsvd_p
 
 	/* clear xpc_vars_part_sn2 */
 	memset((u64 *)xpc_vars_part_sn2, 0, sizeof(struct xpc_vars_part_sn2) *
-	       xp_max_npartitions);
+	       XP_MAX_NPARTITIONS_SN2);
 
 	/* initialize the activate IRQ related amo variables */
 	for (i = 0; i < xpc_nasid_mask_nlongs; i++)
@@ -699,7 +718,7 @@ xpc_check_remote_hb_sn2(void)
 
 	remote_vars = (struct xpc_vars_sn2 *)xpc_remote_copy_buffer_sn2;
 
-	for (partid = 0; partid < xp_max_npartitions; partid++) {
+	for (partid = 0; partid < XP_MAX_NPARTITIONS_SN2; partid++) {
 
 		if (xpc_exiting)
 			break;
@@ -2386,6 +2405,7 @@ xpc_init_sn2(void)
 	int ret;
 	size_t buf_size;
 
+	xpc_get_partition_rsvd_page_pa = xpc_get_partition_rsvd_page_pa_sn2;
 	xpc_rsvd_page_init = xpc_rsvd_page_init_sn2;
 	xpc_increment_heartbeat = xpc_increment_heartbeat_sn2;
 	xpc_offline_heartbeat = xpc_offline_heartbeat_sn2;
diff -puN drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64 drivers/misc/sgi-xp/xpc_uv.c
--- a/drivers/misc/sgi-xp/xpc_uv.c~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64
+++ a/drivers/misc/sgi-xp/xpc_uv.c
@@ -14,11 +14,8 @@
  */
 
 #include <linux/kernel.h>
-
-/* !!! #include <gru/grukservices.h> */
-/* !!! uv_gpa() is defined in <gru/grukservices.h> */
-#define uv_gpa(_a)		((unsigned long)_a)
-
+#include <asm/uv/uv_hub.h>
+#include "../sgi-gru/grukservices.h"
 #include "xpc.h"
 
 static DECLARE_BITMAP(xpc_heartbeating_to_mask_uv, XP_MAX_NPARTITIONS_UV);
diff -puN drivers/misc/sgi-xp/xpnet.c~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64 drivers/misc/sgi-xp/xpnet.c
--- a/drivers/misc/sgi-xp/xpnet.c~sgi-xp-enable-building-of-xpc-xpnet-on-x86_64
+++ a/drivers/misc/sgi-xp/xpnet.c
@@ -21,17 +21,8 @@
  */
 
 #include <linux/module.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/ioport.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-#include <linux/delay.h>
-#include <linux/ethtool.h>
-#include <linux/mii.h>
-#include <linux/smp.h>
-#include <linux/string.h>
-#include <asm/atomic.h>
 #include "xp.h"
 
 /*
@@ -175,8 +166,9 @@ xpnet_receive(short partid, int channel,
 
 		return;
 	}
-	dev_dbg(xpnet, "received 0x%lx, %d, %d, %d\n", msg->buf_pa, msg->size,
-		msg->leadin_ignore, msg->tailout_ignore);
+	dev_dbg(xpnet, "received 0x%lx, %d, %d, %d\n",
+		(unsigned long)msg->buf_pa, msg->size, msg->leadin_ignore,
+		msg->tailout_ignore);
 
 	/* reserve an extra cache line */
 	skb = dev_alloc_skb(msg->size + L1_CACHE_BYTES);
@@ -320,8 +312,10 @@ xpnet_dev_open(struct net_device *dev)
 
 	dev_dbg(xpnet, "calling xpc_connect(%d, 0x%p, NULL, %ld, %ld, %ld, "
 		"%ld)\n", XPC_NET_CHANNEL, xpnet_connection_activity,
-		XPNET_MSG_SIZE, XPNET_MSG_NENTRIES, XPNET_MAX_KTHREADS,
-		XPNET_MAX_IDLE_KTHREADS);
+		(unsigned long)XPNET_MSG_SIZE,
+		(unsigned long)XPNET_MSG_NENTRIES,
+		(unsigned long)XPNET_MAX_KTHREADS,
+		(unsigned long)XPNET_MAX_IDLE_KTHREADS);
 
 	ret = xpc_connect(XPC_NET_CHANNEL, xpnet_connection_activity, NULL,
 			  XPNET_MSG_SIZE, XPNET_MSG_NENTRIES,
@@ -439,8 +433,8 @@ xpnet_send(struct sk_buff *skb, struct x
 	dev_dbg(xpnet, "sending XPC message to %d:%d\n"
 		KERN_DEBUG "msg->buf_pa=0x%lx, msg->size=%u, "
 		"msg->leadin_ignore=%u, msg->tailout_ignore=%u\n",
-		dest_partid, XPC_NET_CHANNEL, msg->buf_pa, msg->size,
-		msg->leadin_ignore, msg->tailout_ignore);
+		dest_partid, XPC_NET_CHANNEL, (unsigned long)msg->buf_pa,
+		msg->size, msg->leadin_ignore, msg->tailout_ignore);
 
 	atomic_inc(&queued_msg->use_count);
 
@@ -602,8 +596,8 @@ xpnet_init(void)
 	 */
 	xpnet_device->dev_addr[0] = 0x02;     /* locally administered, no OUI */
 
-	xpnet_device->dev_addr[XPNET_PARTID_OCTET + 1] = sn_partition_id;
-	xpnet_device->dev_addr[XPNET_PARTID_OCTET + 0] = (sn_partition_id >> 8);
+	xpnet_device->dev_addr[XPNET_PARTID_OCTET + 1] = xp_partition_id;
+	xpnet_device->dev_addr[XPNET_PARTID_OCTET + 0] = (xp_partition_id >> 8);
 
 	/*
 	 * ether_setup() sets this to a multicast device.  We are
_

Patches currently in -mm which might be from dcn@sgi.com are

sgi-xp-define-is_shub-and-is_uv-macros.patch
sgi-xp-define-xpsalerror-reason-code.patch
sgi-xp-define-bytes_per_word.patch
sgi-xp-support-runtime-selection-of-xp_max_npartitions.patch
sgi-xp-create-a-common-xp_remote_memcpy-function.patch
sgi-xp-prepare-xpc_rsvd_page-to-work-on-either-sn2-or-uv-hardware.patch
sgi-xp-isolate-xpc_vars_part-structure-to-sn2-only.patch
sgi-xp-isolate-xpc_vars-structure-to-sn2-only.patch
sgi-xp-base-xpc_rsvd_pages-timestamp-on-jiffies.patch
sgi-xp-move-xpc_allocate-into-xpc_send-xpc_send_notify.patch
sgi-xp-isolate-activate-irqs-hardware-specific-components.patch
sgi-xp-isolate-additional-sn2-specific-code.patch
sgi-xp-separate-chctl_flags-from-xpcs-notify-irq.patch
sgi-xp-replace-amo_t-typedef-by-struct-amo.patch
sgi-xp-isolate-allocation-of-xpcs-msgqueues-to-sn2-only.patch
sgi-xp-enable-xpnet-to-handle-more-than-64-partitions.patch
sgi-xp-isolate-remote-copy-buffer-to-sn2-only.patch
sgi-xp-add-_sn2-suffix-to-a-few-variables.patch
sgi-xp-eliminate-in-comments.patch
sgi-xp-use-standard-bitops-macros-and-functions.patch
sgi-xp-add-jiffies-to-reserved-pages-timestamp-name.patch
sgi-xp-enable-building-of-xpc-xpnet-on-x86_64.patch
sgi-xp-add-usage-of-gru-driver-by-xpc_remote_memcpy.patch
sgi-xp-move-xpc_check_remote_hb-to-support-both-sn2-and-uv.patch
sgi-xp-cleanup-naming-of-partition-defines.patch
sgi-xp-setup-the-activate-gru-message-queue.patch
sgi-xp-setup-the-notify-gru-message-queue.patch

