From: akpm@linux-foundation.org
Subject: [merged] kmemcheck-remove-annotations.patch removed from
 -mm tree
Date: Thu, 16 Nov 2017 12:02:34 -0800
Message-ID: <20171116200234.9CF75OmPb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46682 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964820AbdKPUCg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:02:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexander.levin@verizon.com, devtimhansen@gmail.com, ebiederm@xmission.com, glider@google.com, mhocko@kernel.org, mm-commits@vger.kernel.org, penberg@kernel.org, rostedt@goodmis.org, vegardno@ifi.uio.no


The patch titled
     Subject: kmemcheck: remove annotations
has been removed from the -mm tree.  Its filename was
     kmemcheck-remove-annotations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Levin, Alexander (Sasha Levin)" <alexander.levin@verizon.com>
Subject: kmemcheck: remove annotations

Patch series "kmemcheck: kill kmemcheck", v2.

As discussed at LSF/MM, kill kmemcheck.

KASan is a replacement that is able to work without the limitation of
kmemcheck (single CPU, slow).  KASan is already upstream.

We are also not aware of any users of kmemcheck (or users who don't
consider KASan as a suitable replacement).

The only objection was that since KASAN wasn't supported by all GCC
versions provided by distros at that time we should hold off for 2 years,
and try again.

Now that 2 years have passed, and all distros provide gcc that supports
KASAN, kill kmemcheck again for the very same reasons.


This patch (of 4):

Remove kmemcheck annotations, and calls to kmemcheck from the kernel.

[alexander.levin@verizon.com: correctly remove kmemcheck call from dma_map_sg_attrs]
  Link: http://lkml.kernel.org/r/20171012192151.26531-1-alexander.levin@verizon.com
Link: http://lkml.kernel.org/r/20171007030159.22241-2-alexander.levin@verizon.com
Signed-off-by: Sasha Levin <alexander.levin@verizon.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tim Hansen <devtimhansen@gmail.com>
Cc: Vegard Nossum <vegardno@ifi.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/dma-iommu.h        |    1 -
 arch/openrisc/include/asm/dma-mapping.h |    1 -
 arch/x86/Makefile                       |    5 -----
 arch/x86/include/asm/dma-mapping.h      |    1 -
 arch/x86/include/asm/xor.h              |    5 +----
 arch/x86/kernel/traps.c                 |    5 -----
 arch/x86/mm/fault.c                     |    6 ------
 drivers/char/random.c                   |    1 -
 drivers/misc/c2port/core.c              |    2 --
 fs/dcache.c                             |    2 --
 include/linux/c2port.h                  |    4 ----
 include/linux/dma-mapping.h             |    8 +-------
 include/linux/filter.h                  |    2 --
 include/linux/mm_types.h                |    8 --------
 include/linux/net.h                     |    3 ---
 include/linux/ring_buffer.h             |    3 ---
 include/linux/skbuff.h                  |    3 ---
 include/net/inet_sock.h                 |    3 ---
 include/net/inet_timewait_sock.h        |    4 ----
 include/net/sock.h                      |    3 ---
 init/main.c                             |    1 -
 kernel/bpf/core.c                       |    6 ------
 kernel/locking/lockdep.c                |    3 ---
 kernel/trace/ring_buffer.c              |    3 ---
 mm/kmemleak.c                           |    9 ---------
 mm/page_alloc.c                         |   14 --------------
 mm/slab.c                               |   14 --------------
 mm/slab.h                               |    2 --
 mm/slub.c                               |   20 --------------------
 net/core/skbuff.c                       |    5 -----
 net/core/sock.c                         |    2 --
 net/ipv4/inet_timewait_sock.c           |    3 ---
 net/ipv4/tcp_input.c                    |    1 -
 net/socket.c                            |    1 -
 34 files changed, 2 insertions(+), 152 deletions(-)

diff -puN arch/arm/include/asm/dma-iommu.h~kmemcheck-remove-annotations arch/arm/include/asm/dma-iommu.h
--- a/arch/arm/include/asm/dma-iommu.h~kmemcheck-remove-annotations
+++ a/arch/arm/include/asm/dma-iommu.h
@@ -7,7 +7,6 @@
 #include <linux/mm_types.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-debug.h>
-#include <linux/kmemcheck.h>
 #include <linux/kref.h>
 
 #define ARM_MAPPING_ERROR		(~(dma_addr_t)0x0)
diff -puN arch/openrisc/include/asm/dma-mapping.h~kmemcheck-remove-annotations arch/openrisc/include/asm/dma-mapping.h
--- a/arch/openrisc/include/asm/dma-mapping.h~kmemcheck-remove-annotations
+++ a/arch/openrisc/include/asm/dma-mapping.h
@@ -23,7 +23,6 @@
  */
 
 #include <linux/dma-debug.h>
-#include <linux/kmemcheck.h>
 #include <linux/dma-mapping.h>
 
 extern const struct dma_map_ops or1k_dma_map_ops;
diff -puN arch/x86/include/asm/dma-mapping.h~kmemcheck-remove-annotations arch/x86/include/asm/dma-mapping.h
--- a/arch/x86/include/asm/dma-mapping.h~kmemcheck-remove-annotations
+++ a/arch/x86/include/asm/dma-mapping.h
@@ -7,7 +7,6 @@
  * Documentation/DMA-API.txt for documentation.
  */
 
-#include <linux/kmemcheck.h>
 #include <linux/scatterlist.h>
 #include <linux/dma-debug.h>
 #include <asm/io.h>
diff -puN arch/x86/include/asm/xor.h~kmemcheck-remove-annotations arch/x86/include/asm/xor.h
--- a/arch/x86/include/asm/xor.h~kmemcheck-remove-annotations
+++ a/arch/x86/include/asm/xor.h
@@ -1,7 +1,4 @@
-#ifdef CONFIG_KMEMCHECK
-/* kmemcheck doesn't handle MMX/SSE/SSE2 instructions */
-# include <asm-generic/xor.h>
-#elif !defined(_ASM_X86_XOR_H)
+#ifndef _ASM_X86_XOR_H
 #define _ASM_X86_XOR_H
 
 /*
diff -puN arch/x86/kernel/traps.c~kmemcheck-remove-annotations arch/x86/kernel/traps.c
--- a/arch/x86/kernel/traps.c~kmemcheck-remove-annotations
+++ a/arch/x86/kernel/traps.c
@@ -42,7 +42,6 @@
 #include <linux/edac.h>
 #endif
 
-#include <asm/kmemcheck.h>
 #include <asm/stacktrace.h>
 #include <asm/processor.h>
 #include <asm/debugreg.h>
@@ -749,10 +748,6 @@ dotraplinkage void do_debug(struct pt_re
 	if (!dr6 && user_mode(regs))
 		user_icebp = 1;
 
-	/* Catch kmemcheck conditions! */
-	if ((dr6 & DR_STEP) && kmemcheck_trap(regs))
-		goto exit;
-
 	/* Store the virtualized DR6 value */
 	tsk->thread.debugreg6 = dr6;
 
diff -puN arch/x86/Makefile~kmemcheck-remove-annotations arch/x86/Makefile
--- a/arch/x86/Makefile~kmemcheck-remove-annotations
+++ a/arch/x86/Makefile
@@ -158,11 +158,6 @@ ifdef CONFIG_X86_X32
 endif
 export CONFIG_X86_X32_ABI
 
-# Don't unroll struct assignments with kmemcheck enabled
-ifeq ($(CONFIG_KMEMCHECK),y)
-	KBUILD_CFLAGS += $(call cc-option,-fno-builtin-memcpy)
-endif
-
 #
 # If the function graph tracer is used with mcount instead of fentry,
 # '-maccumulate-outgoing-args' is needed to prevent a GCC bug
diff -puN arch/x86/mm/fault.c~kmemcheck-remove-annotations arch/x86/mm/fault.c
--- a/arch/x86/mm/fault.c~kmemcheck-remove-annotations
+++ a/arch/x86/mm/fault.c
@@ -20,7 +20,6 @@
 #include <asm/cpufeature.h>		/* boot_cpu_has, ...		*/
 #include <asm/traps.h>			/* dotraplinkage, ...		*/
 #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
-#include <asm/kmemcheck.h>		/* kmemcheck_*(), ...		*/
 #include <asm/fixmap.h>			/* VSYSCALL_ADDR		*/
 #include <asm/vsyscall.h>		/* emulate_vsyscall		*/
 #include <asm/vm86.h>			/* struct vm86			*/
@@ -1256,8 +1255,6 @@ __do_page_fault(struct pt_regs *regs, un
 	 * Detect and handle instructions that would cause a page fault for
 	 * both a tracked kernel page and a userspace page.
 	 */
-	if (kmemcheck_active(regs))
-		kmemcheck_hide(regs);
 	prefetchw(&mm->mmap_sem);
 
 	if (unlikely(kmmio_fault(regs, address)))
@@ -1280,9 +1277,6 @@ __do_page_fault(struct pt_regs *regs, un
 		if (!(error_code & (X86_PF_RSVD | X86_PF_USER | X86_PF_PROT))) {
 			if (vmalloc_fault(address) >= 0)
 				return;
-
-			if (kmemcheck_fault(regs, address, error_code))
-				return;
 		}
 
 		/* Can handle a stale RO->RW TLB: */
diff -puN drivers/char/random.c~kmemcheck-remove-annotations drivers/char/random.c
--- a/drivers/char/random.c~kmemcheck-remove-annotations
+++ a/drivers/char/random.c
@@ -259,7 +259,6 @@
 #include <linux/cryptohash.h>
 #include <linux/fips.h>
 #include <linux/ptrace.h>
-#include <linux/kmemcheck.h>
 #include <linux/workqueue.h>
 #include <linux/irq.h>
 #include <linux/syscalls.h>
diff -puN drivers/misc/c2port/core.c~kmemcheck-remove-annotations drivers/misc/c2port/core.c
--- a/drivers/misc/c2port/core.c~kmemcheck-remove-annotations
+++ a/drivers/misc/c2port/core.c
@@ -15,7 +15,6 @@
 #include <linux/errno.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
-#include <linux/kmemcheck.h>
 #include <linux/ctype.h>
 #include <linux/delay.h>
 #include <linux/idr.h>
@@ -904,7 +903,6 @@ struct c2port_device *c2port_device_regi
 		return ERR_PTR(-EINVAL);
 
 	c2dev = kmalloc(sizeof(struct c2port_device), GFP_KERNEL);
-	kmemcheck_annotate_bitfield(c2dev, flags);
 	if (unlikely(!c2dev))
 		return ERR_PTR(-ENOMEM);
 
diff -puN fs/dcache.c~kmemcheck-remove-annotations fs/dcache.c
--- a/fs/dcache.c~kmemcheck-remove-annotations
+++ a/fs/dcache.c
@@ -2705,8 +2705,6 @@ static void swap_names(struct dentry *de
 			 */
 			unsigned int i;
 			BUILD_BUG_ON(!IS_ALIGNED(DNAME_INLINE_LEN, sizeof(long)));
-			kmemcheck_mark_initialized(dentry->d_iname, DNAME_INLINE_LEN);
-			kmemcheck_mark_initialized(target->d_iname, DNAME_INLINE_LEN);
 			for (i = 0; i < DNAME_INLINE_LEN / sizeof(long); i++) {
 				swap(((long *) &dentry->d_iname)[i],
 				     ((long *) &target->d_iname)[i]);
diff -puN include/linux/c2port.h~kmemcheck-remove-annotations include/linux/c2port.h
--- a/include/linux/c2port.h~kmemcheck-remove-annotations
+++ a/include/linux/c2port.h
@@ -9,8 +9,6 @@
  * the Free Software Foundation
  */
 
-#include <linux/kmemcheck.h>
-
 #define C2PORT_NAME_LEN			32
 
 struct device;
@@ -22,10 +20,8 @@ struct device;
 /* Main struct */
 struct c2port_ops;
 struct c2port_device {
-	kmemcheck_bitfield_begin(flags);
 	unsigned int access:1;
 	unsigned int flash_access:1;
-	kmemcheck_bitfield_end(flags);
 
 	int id;
 	char name[C2PORT_NAME_LEN];
diff -puN include/linux/dma-mapping.h~kmemcheck-remove-annotations include/linux/dma-mapping.h
--- a/include/linux/dma-mapping.h~kmemcheck-remove-annotations
+++ a/include/linux/dma-mapping.h
@@ -9,7 +9,6 @@
 #include <linux/dma-debug.h>
 #include <linux/dma-direction.h>
 #include <linux/scatterlist.h>
-#include <linux/kmemcheck.h>
 #include <linux/bug.h>
 #include <linux/mem_encrypt.h>
 
@@ -232,7 +231,6 @@ static inline dma_addr_t dma_map_single_
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 	dma_addr_t addr;
 
-	kmemcheck_mark_initialized(ptr, size);
 	BUG_ON(!valid_dma_direction(dir));
 	addr = ops->map_page(dev, virt_to_page(ptr),
 			     offset_in_page(ptr), size,
@@ -265,11 +263,8 @@ static inline int dma_map_sg_attrs(struc
 				   unsigned long attrs)
 {
 	const struct dma_map_ops *ops = get_dma_ops(dev);
-	int i, ents;
-	struct scatterlist *s;
+	int ents;
 
-	for_each_sg(sg, s, nents, i)
-		kmemcheck_mark_initialized(sg_virt(s), s->length);
 	BUG_ON(!valid_dma_direction(dir));
 	ents = ops->map_sg(dev, sg, nents, dir, attrs);
 	BUG_ON(ents < 0);
@@ -299,7 +294,6 @@ static inline dma_addr_t dma_map_page_at
 	const struct dma_map_ops *ops = get_dma_ops(dev);
 	dma_addr_t addr;
 
-	kmemcheck_mark_initialized(page_address(page) + offset, size);
 	BUG_ON(!valid_dma_direction(dir));
 	addr = ops->map_page(dev, page, offset, size, dir, attrs);
 	debug_dma_map_page(dev, page, offset, size, dir, addr, false);
diff -puN include/linux/filter.h~kmemcheck-remove-annotations include/linux/filter.h
--- a/include/linux/filter.h~kmemcheck-remove-annotations
+++ a/include/linux/filter.h
@@ -454,13 +454,11 @@ struct bpf_binary_header {
 
 struct bpf_prog {
 	u16			pages;		/* Number of allocated pages */
-	kmemcheck_bitfield_begin(meta);
 	u16			jited:1,	/* Is our filter JIT'ed? */
 				locked:1,	/* Program image locked? */
 				gpl_compatible:1, /* Is filter GPL compatible? */
 				cb_access:1,	/* Is control block accessed? */
 				dst_needed:1;	/* Do we need dst entry? */
-	kmemcheck_bitfield_end(meta);
 	enum bpf_prog_type	type;		/* Type of BPF program */
 	u32			len;		/* Number of filter blocks */
 	u32			jited_len;	/* Size of jited insns in bytes */
diff -puN include/linux/mm_types.h~kmemcheck-remove-annotations include/linux/mm_types.h
--- a/include/linux/mm_types.h~kmemcheck-remove-annotations
+++ a/include/linux/mm_types.h
@@ -209,14 +209,6 @@ struct page {
 					   not kmapped, ie. highmem) */
 #endif /* WANT_PAGE_VIRTUAL */
 
-#ifdef CONFIG_KMEMCHECK
-	/*
-	 * kmemcheck wants to track the status of each byte in a page; this
-	 * is a pointer to such a status block. NULL if not tracked.
-	 */
-	void *shadow;
-#endif
-
 #ifdef LAST_CPUPID_NOT_IN_PAGE_FLAGS
 	int _last_cpupid;
 #endif
diff -puN include/linux/net.h~kmemcheck-remove-annotations include/linux/net.h
--- a/include/linux/net.h~kmemcheck-remove-annotations
+++ a/include/linux/net.h
@@ -22,7 +22,6 @@
 #include <linux/random.h>
 #include <linux/wait.h>
 #include <linux/fcntl.h>	/* For O_CLOEXEC and O_NONBLOCK */
-#include <linux/kmemcheck.h>
 #include <linux/rcupdate.h>
 #include <linux/once.h>
 #include <linux/fs.h>
@@ -111,9 +110,7 @@ struct socket_wq {
 struct socket {
 	socket_state		state;
 
-	kmemcheck_bitfield_begin(type);
 	short			type;
-	kmemcheck_bitfield_end(type);
 
 	unsigned long		flags;
 
diff -puN include/linux/ring_buffer.h~kmemcheck-remove-annotations include/linux/ring_buffer.h
--- a/include/linux/ring_buffer.h~kmemcheck-remove-annotations
+++ a/include/linux/ring_buffer.h
@@ -2,7 +2,6 @@
 #ifndef _LINUX_RING_BUFFER_H
 #define _LINUX_RING_BUFFER_H
 
-#include <linux/kmemcheck.h>
 #include <linux/mm.h>
 #include <linux/seq_file.h>
 #include <linux/poll.h>
@@ -14,9 +13,7 @@ struct ring_buffer_iter;
  * Don't refer to this struct directly, use functions below.
  */
 struct ring_buffer_event {
-	kmemcheck_bitfield_begin(bitfield);
 	u32		type_len:5, time_delta:27;
-	kmemcheck_bitfield_end(bitfield);
 
 	u32		array[];
 };
diff -puN include/linux/skbuff.h~kmemcheck-remove-annotations include/linux/skbuff.h
--- a/include/linux/skbuff.h~kmemcheck-remove-annotations
+++ a/include/linux/skbuff.h
@@ -15,7 +15,6 @@
 #define _LINUX_SKBUFF_H
 
 #include <linux/kernel.h>
-#include <linux/kmemcheck.h>
 #include <linux/compiler.h>
 #include <linux/time.h>
 #include <linux/bug.h>
@@ -704,7 +703,6 @@ struct sk_buff {
 	/* Following fields are _not_ copied in __copy_skb_header()
 	 * Note that queue_mapping is here mostly to fill a hole.
 	 */
-	kmemcheck_bitfield_begin(flags1);
 	__u16			queue_mapping;
 
 /* if you move cloned around you also must adapt those constants */
@@ -723,7 +721,6 @@ struct sk_buff {
 				head_frag:1,
 				xmit_more:1,
 				__unused:1; /* one bit hole */
-	kmemcheck_bitfield_end(flags1);
 
 	/* fields enclosed in headers_start/headers_end are copied
 	 * using a single memcpy() in __copy_skb_header()
diff -puN include/net/inet_sock.h~kmemcheck-remove-annotations include/net/inet_sock.h
--- a/include/net/inet_sock.h~kmemcheck-remove-annotations
+++ a/include/net/inet_sock.h
@@ -17,7 +17,6 @@
 #define _INET_SOCK_H
 
 #include <linux/bitops.h>
-#include <linux/kmemcheck.h>
 #include <linux/string.h>
 #include <linux/types.h>
 #include <linux/jhash.h>
@@ -84,7 +83,6 @@ struct inet_request_sock {
 #define ireq_state		req.__req_common.skc_state
 #define ireq_family		req.__req_common.skc_family
 
-	kmemcheck_bitfield_begin(flags);
 	u16			snd_wscale : 4,
 				rcv_wscale : 4,
 				tstamp_ok  : 1,
@@ -93,7 +91,6 @@ struct inet_request_sock {
 				ecn_ok	   : 1,
 				acked	   : 1,
 				no_srccheck: 1;
-	kmemcheck_bitfield_end(flags);
 	u32                     ir_mark;
 	union {
 		struct ip_options_rcu __rcu	*ireq_opt;
diff -puN include/net/inet_timewait_sock.h~kmemcheck-remove-annotations include/net/inet_timewait_sock.h
--- a/include/net/inet_timewait_sock.h~kmemcheck-remove-annotations
+++ a/include/net/inet_timewait_sock.h
@@ -15,8 +15,6 @@
 #ifndef _INET_TIMEWAIT_SOCK_
 #define _INET_TIMEWAIT_SOCK_
 
-
-#include <linux/kmemcheck.h>
 #include <linux/list.h>
 #include <linux/timer.h>
 #include <linux/types.h>
@@ -69,14 +67,12 @@ struct inet_timewait_sock {
 	/* Socket demultiplex comparisons on incoming packets. */
 	/* these three are in inet_sock */
 	__be16			tw_sport;
-	kmemcheck_bitfield_begin(flags);
 	/* And these are ours. */
 	unsigned int		tw_kill		: 1,
 				tw_transparent  : 1,
 				tw_flowlabel	: 20,
 				tw_pad		: 2,	/* 2 bits hole */
 				tw_tos		: 8;
-	kmemcheck_bitfield_end(flags);
 	struct timer_list	tw_timer;
 	struct inet_bind_bucket	*tw_tb;
 };
diff -puN include/net/sock.h~kmemcheck-remove-annotations include/net/sock.h
--- a/include/net/sock.h~kmemcheck-remove-annotations
+++ a/include/net/sock.h
@@ -436,7 +436,6 @@ struct sock {
 #define SK_FL_TYPE_MASK    0xffff0000
 #endif
 
-	kmemcheck_bitfield_begin(flags);
 	unsigned int		sk_padding : 1,
 				sk_kern_sock : 1,
 				sk_no_check_tx : 1,
@@ -445,8 +444,6 @@ struct sock {
 				sk_protocol  : 8,
 				sk_type      : 16;
 #define SK_PROTOCOL_MAX U8_MAX
-	kmemcheck_bitfield_end(flags);
-
 	u16			sk_gso_max_segs;
 	unsigned long	        sk_lingertime;
 	struct proto		*sk_prot_creator;
diff -puN init/main.c~kmemcheck-remove-annotations init/main.c
--- a/init/main.c~kmemcheck-remove-annotations
+++ a/init/main.c
@@ -70,7 +70,6 @@
 #include <linux/kgdb.h>
 #include <linux/ftrace.h>
 #include <linux/async.h>
-#include <linux/kmemcheck.h>
 #include <linux/sfi.h>
 #include <linux/shmem_fs.h>
 #include <linux/slab.h>
diff -puN kernel/bpf/core.c~kmemcheck-remove-annotations kernel/bpf/core.c
--- a/kernel/bpf/core.c~kmemcheck-remove-annotations
+++ a/kernel/bpf/core.c
@@ -85,8 +85,6 @@ struct bpf_prog *bpf_prog_alloc(unsigned
 	if (fp == NULL)
 		return NULL;
 
-	kmemcheck_annotate_bitfield(fp, meta);
-
 	aux = kzalloc(sizeof(*aux), GFP_KERNEL | gfp_extra_flags);
 	if (aux == NULL) {
 		vfree(fp);
@@ -127,8 +125,6 @@ struct bpf_prog *bpf_prog_realloc(struct
 	if (fp == NULL) {
 		__bpf_prog_uncharge(fp_old->aux->user, delta);
 	} else {
-		kmemcheck_annotate_bitfield(fp, meta);
-
 		memcpy(fp, fp_old, fp_old->pages * PAGE_SIZE);
 		fp->pages = pages;
 		fp->aux->prog = fp;
@@ -662,8 +658,6 @@ static struct bpf_prog *bpf_prog_clone_c
 
 	fp = __vmalloc(fp_other->pages * PAGE_SIZE, gfp_flags, PAGE_KERNEL);
 	if (fp != NULL) {
-		kmemcheck_annotate_bitfield(fp, meta);
-
 		/* aux->prog still points to the fp_other one, so
 		 * when promoting the clone to the real program,
 		 * this still needs to be adapted.
diff -puN kernel/locking/lockdep.c~kmemcheck-remove-annotations kernel/locking/lockdep.c
--- a/kernel/locking/lockdep.c~kmemcheck-remove-annotations
+++ a/kernel/locking/lockdep.c
@@ -47,7 +47,6 @@
 #include <linux/stringify.h>
 #include <linux/bitops.h>
 #include <linux/gfp.h>
-#include <linux/kmemcheck.h>
 #include <linux/random.h>
 #include <linux/jhash.h>
 
@@ -3238,8 +3237,6 @@ static void __lockdep_init_map(struct lo
 {
 	int i;
 
-	kmemcheck_mark_initialized(lock, sizeof(*lock));
-
 	for (i = 0; i < NR_LOCKDEP_CACHING_CLASSES; i++)
 		lock->class_cache[i] = NULL;
 
diff -puN kernel/trace/ring_buffer.c~kmemcheck-remove-annotations kernel/trace/ring_buffer.c
--- a/kernel/trace/ring_buffer.c~kmemcheck-remove-annotations
+++ a/kernel/trace/ring_buffer.c
@@ -13,7 +13,6 @@
 #include <linux/uaccess.h>
 #include <linux/hardirq.h>
 #include <linux/kthread.h>	/* for self test */
-#include <linux/kmemcheck.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
 #include <linux/mutex.h>
@@ -2055,7 +2054,6 @@ rb_reset_tail(struct ring_buffer_per_cpu
 	}
 
 	event = __rb_page_index(tail_page, tail);
-	kmemcheck_annotate_bitfield(event, bitfield);
 
 	/* account for padding bytes */
 	local_add(BUF_PAGE_SIZE - tail, &cpu_buffer->entries_bytes);
@@ -2686,7 +2684,6 @@ __rb_reserve_next(struct ring_buffer_per
 	/* We reserved something on the buffer */
 
 	event = __rb_page_index(tail_page, tail);
-	kmemcheck_annotate_bitfield(event, bitfield);
 	rb_update_event(cpu_buffer, event, info);
 
 	local_inc(&tail_page->entries);
diff -puN mm/kmemleak.c~kmemcheck-remove-annotations mm/kmemleak.c
--- a/mm/kmemleak.c~kmemcheck-remove-annotations
+++ a/mm/kmemleak.c
@@ -110,7 +110,6 @@
 #include <linux/atomic.h>
 
 #include <linux/kasan.h>
-#include <linux/kmemcheck.h>
 #include <linux/kmemleak.h>
 #include <linux/memory_hotplug.h>
 
@@ -1238,9 +1237,6 @@ static bool update_checksum(struct kmeml
 {
 	u32 old_csum = object->checksum;
 
-	if (!kmemcheck_is_obj_initialized(object->pointer, object->size))
-		return false;
-
 	kasan_disable_current();
 	object->checksum = crc32(0, (void *)object->pointer, object->size);
 	kasan_enable_current();
@@ -1314,11 +1310,6 @@ static void scan_block(void *_start, voi
 		if (scan_should_stop())
 			break;
 
-		/* don't scan uninitialized memory */
-		if (!kmemcheck_is_obj_initialized((unsigned long)ptr,
-						  BYTES_PER_POINTER))
-			continue;
-
 		kasan_disable_current();
 		pointer = *ptr;
 		kasan_enable_current();
diff -puN mm/page_alloc.c~kmemcheck-remove-annotations mm/page_alloc.c
--- a/mm/page_alloc.c~kmemcheck-remove-annotations
+++ a/mm/page_alloc.c
@@ -24,7 +24,6 @@
 #include <linux/memblock.h>
 #include <linux/compiler.h>
 #include <linux/kernel.h>
-#include <linux/kmemcheck.h>
 #include <linux/kasan.h>
 #include <linux/module.h>
 #include <linux/suspend.h>
@@ -1013,7 +1012,6 @@ static __always_inline bool free_pages_p
 	VM_BUG_ON_PAGE(PageTail(page), page);
 
 	trace_mm_page_free(page, order);
-	kmemcheck_free_shadow(page, order);
 
 	/*
 	 * Check tail pages before head page information is cleared to
@@ -2669,15 +2667,6 @@ void split_page(struct page *page, unsig
 	VM_BUG_ON_PAGE(PageCompound(page), page);
 	VM_BUG_ON_PAGE(!page_count(page), page);
 
-#ifdef CONFIG_KMEMCHECK
-	/*
-	 * Split shadow pages too, because free(page[0]) would
-	 * otherwise free the whole shadow.
-	 */
-	if (kmemcheck_page_is_tracked(page))
-		split_page(virt_to_page(page[0].shadow), order);
-#endif
-
 	for (i = 1; i < (1 << order); i++)
 		set_page_refcounted(page + i);
 	split_page_owner(page, order);
@@ -4223,9 +4212,6 @@ out:
 		page = NULL;
 	}
 
-	if (kmemcheck_enabled && page)
-		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
-
 	trace_mm_page_alloc(page, order, alloc_mask, ac.migratetype);
 
 	return page;
diff -puN mm/slab.c~kmemcheck-remove-annotations mm/slab.c
--- a/mm/slab.c~kmemcheck-remove-annotations
+++ a/mm/slab.c
@@ -114,7 +114,6 @@
 #include	<linux/rtmutex.h>
 #include	<linux/reciprocal_div.h>
 #include	<linux/debugobjects.h>
-#include	<linux/kmemcheck.h>
 #include	<linux/memory.h>
 #include	<linux/prefetch.h>
 #include	<linux/sched/task_stack.h>
@@ -1433,15 +1432,6 @@ static struct page *kmem_getpages(struct
 	if (sk_memalloc_socks() && page_is_pfmemalloc(page))
 		SetPageSlabPfmemalloc(page);
 
-	if (kmemcheck_enabled && !(cachep->flags & SLAB_NOTRACK)) {
-		kmemcheck_alloc_shadow(page, cachep->gfporder, flags, nodeid);
-
-		if (cachep->ctor)
-			kmemcheck_mark_uninitialized_pages(page, nr_pages);
-		else
-			kmemcheck_mark_unallocated_pages(page, nr_pages);
-	}
-
 	return page;
 }
 
@@ -1453,8 +1443,6 @@ static void kmem_freepages(struct kmem_c
 	int order = cachep->gfporder;
 	unsigned long nr_freed = (1 << order);
 
-	kmemcheck_free_shadow(page, order);
-
 	if (cachep->flags & SLAB_RECLAIM_ACCOUNT)
 		mod_lruvec_page_state(page, NR_SLAB_RECLAIMABLE, -nr_freed);
 	else
@@ -3515,8 +3503,6 @@ void ___cache_free(struct kmem_cache *ca
 	kmemleak_free_recursive(objp, cachep->flags);
 	objp = cache_free_debugcheck(cachep, objp, caller);
 
-	kmemcheck_slab_free(cachep, objp, cachep->object_size);
-
 	/*
 	 * Skip calling cache_free_alien() when the platform is not numa.
 	 * This will avoid cache misses that happen while accessing slabp (which
diff -puN mm/slab.h~kmemcheck-remove-annotations mm/slab.h
--- a/mm/slab.h~kmemcheck-remove-annotations
+++ a/mm/slab.h
@@ -40,7 +40,6 @@ struct kmem_cache {
 
 #include <linux/memcontrol.h>
 #include <linux/fault-inject.h>
-#include <linux/kmemcheck.h>
 #include <linux/kasan.h>
 #include <linux/kmemleak.h>
 #include <linux/random.h>
@@ -439,7 +438,6 @@ static inline void slab_post_alloc_hook(
 	for (i = 0; i < size; i++) {
 		void *object = p[i];
 
-		kmemcheck_slab_alloc(s, flags, object, slab_ksize(s));
 		kmemleak_alloc_recursive(object, s->object_size, 1,
 					 s->flags, flags);
 		kasan_slab_alloc(s, object, flags);
diff -puN mm/slub.c~kmemcheck-remove-annotations mm/slub.c
--- a/mm/slub.c~kmemcheck-remove-annotations
+++ a/mm/slub.c
@@ -22,7 +22,6 @@
 #include <linux/notifier.h>
 #include <linux/seq_file.h>
 #include <linux/kasan.h>
-#include <linux/kmemcheck.h>
 #include <linux/cpu.h>
 #include <linux/cpuset.h>
 #include <linux/mempolicy.h>
@@ -1377,7 +1376,6 @@ static inline void *slab_free_hook(struc
 		unsigned long flags;
 
 		local_irq_save(flags);
-		kmemcheck_slab_free(s, x, s->object_size);
 		debug_check_no_locks_freed(x, s->object_size);
 		local_irq_restore(flags);
 	}
@@ -1598,22 +1596,6 @@ static struct page *allocate_slab(struct
 		stat(s, ORDER_FALLBACK);
 	}
 
-	if (kmemcheck_enabled &&
-	    !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS))) {
-		int pages = 1 << oo_order(oo);
-
-		kmemcheck_alloc_shadow(page, oo_order(oo), alloc_gfp, node);
-
-		/*
-		 * Objects from caches that have a constructor don't get
-		 * cleared when they're allocated, so we need to do it here.
-		 */
-		if (s->ctor)
-			kmemcheck_mark_uninitialized_pages(page, pages);
-		else
-			kmemcheck_mark_unallocated_pages(page, pages);
-	}
-
 	page->objects = oo_objects(oo);
 
 	order = compound_order(page);
@@ -1689,8 +1671,6 @@ static void __free_slab(struct kmem_cach
 			check_object(s, page, p, SLUB_RED_INACTIVE);
 	}
 
-	kmemcheck_free_shadow(page, compound_order(page));
-
 	mod_lruvec_page_state(page,
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
diff -puN net/core/skbuff.c~kmemcheck-remove-annotations net/core/skbuff.c
--- a/net/core/skbuff.c~kmemcheck-remove-annotations
+++ a/net/core/skbuff.c
@@ -41,7 +41,6 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
-#include <linux/kmemcheck.h>
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/in.h>
@@ -234,14 +233,12 @@ struct sk_buff *__alloc_skb(unsigned int
 	shinfo = skb_shinfo(skb);
 	memset(shinfo, 0, offsetof(struct skb_shared_info, dataref));
 	atomic_set(&shinfo->dataref, 1);
-	kmemcheck_annotate_variable(shinfo->destructor_arg);
 
 	if (flags & SKB_ALLOC_FCLONE) {
 		struct sk_buff_fclones *fclones;
 
 		fclones = container_of(skb, struct sk_buff_fclones, skb1);
 
-		kmemcheck_annotate_bitfield(&fclones->skb2, flags1);
 		skb->fclone = SKB_FCLONE_ORIG;
 		refcount_set(&fclones->fclone_ref, 1);
 
@@ -301,7 +298,6 @@ struct sk_buff *__build_skb(void *data,
 	shinfo = skb_shinfo(skb);
 	memset(shinfo, 0, offsetof(struct skb_shared_info, dataref));
 	atomic_set(&shinfo->dataref, 1);
-	kmemcheck_annotate_variable(shinfo->destructor_arg);
 
 	return skb;
 }
@@ -1283,7 +1279,6 @@ struct sk_buff *skb_clone(struct sk_buff
 		if (!n)
 			return NULL;
 
-		kmemcheck_annotate_bitfield(n, flags1);
 		n->fclone = SKB_FCLONE_UNAVAILABLE;
 	}
 
diff -puN net/core/sock.c~kmemcheck-remove-annotations net/core/sock.c
--- a/net/core/sock.c~kmemcheck-remove-annotations
+++ a/net/core/sock.c
@@ -1469,8 +1469,6 @@ static struct sock *sk_prot_alloc(struct
 		sk = kmalloc(prot->obj_size, priority);
 
 	if (sk != NULL) {
-		kmemcheck_annotate_bitfield(sk, flags);
-
 		if (security_sk_alloc(sk, family, priority))
 			goto out_free;
 
diff -puN net/ipv4/inet_timewait_sock.c~kmemcheck-remove-annotations net/ipv4/inet_timewait_sock.c
--- a/net/ipv4/inet_timewait_sock.c~kmemcheck-remove-annotations
+++ a/net/ipv4/inet_timewait_sock.c
@@ -9,7 +9,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/kmemcheck.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <net/inet_hashtables.h>
@@ -167,8 +166,6 @@ struct inet_timewait_sock *inet_twsk_all
 	if (tw) {
 		const struct inet_sock *inet = inet_sk(sk);
 
-		kmemcheck_annotate_bitfield(tw, flags);
-
 		tw->tw_dr	    = dr;
 		/* Give us an identity. */
 		tw->tw_daddr	    = inet->inet_daddr;
diff -puN net/ipv4/tcp_input.c~kmemcheck-remove-annotations net/ipv4/tcp_input.c
--- a/net/ipv4/tcp_input.c~kmemcheck-remove-annotations
+++ a/net/ipv4/tcp_input.c
@@ -6195,7 +6195,6 @@ struct request_sock *inet_reqsk_alloc(co
 	if (req) {
 		struct inet_request_sock *ireq = inet_rsk(req);
 
-		kmemcheck_annotate_bitfield(ireq, flags);
 		ireq->ireq_opt = NULL;
 #if IS_ENABLED(CONFIG_IPV6)
 		ireq->pktopts = NULL;
diff -puN net/socket.c~kmemcheck-remove-annotations net/socket.c
--- a/net/socket.c~kmemcheck-remove-annotations
+++ a/net/socket.c
@@ -568,7 +568,6 @@ struct socket *sock_alloc(void)
 
 	sock = SOCKET_I(inode);
 
-	kmemcheck_annotate_bitfield(sock, type);
 	inode->i_ino = get_next_ino();
 	inode->i_mode = S_IFSOCK | S_IRWXUGO;
 	inode->i_uid = current_fsuid();
_

Patches currently in -mm which might be from alexander.levin@verizon.com are


