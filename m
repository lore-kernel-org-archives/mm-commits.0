From: akpm@linux-foundation.org
Subject: + xen-paravirt-add-xen-interface-header-files.patch added to -mm tree
Date: Thu, 15 Feb 2007 23:00:26 -0800
Message-ID: <200702160700.l1G70Qdu022652@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55231 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932495AbXBPHBa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 02:01:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, Christian.Limpach@cl.cam.ac.uk, ak@suse.de, chrisw@sous-sol.org, ian.pratt@xensource.com, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com


The patch titled
     Xen-paravirt: add Xen interface header files
has been added to the -mm tree.  Its filename is
     xen-paravirt-add-xen-interface-header-files.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Xen-paravirt: add Xen interface header files
From: Jeremy Fitzhardinge <jeremy@goop.org>

Add Xen interface header files.  These are taken fairly directly from the Xen
tree and hence the style is not entirely in accordance with Linux guidelines. 
There is a tension between fitting with Linux coding rules and ease of
maintenance.

Define macros and inline functions for doing hypercalls into the hypervisor.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Ian Pratt <ian.pratt@xensource.com>
Signed-off-by: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/xen/hypercall.h      |  413 ++++++++++++++++++++++
 include/asm-i386/xen/hypervisor.h     |   72 +++
 include/asm-i386/xen/interface.h      |  187 ++++++++++
 include/xen/interface/elfnote.h       |  133 +++++++
 include/xen/interface/event_channel.h |  195 ++++++++++
 include/xen/interface/features.h      |   43 ++
 include/xen/interface/grant_table.h   |  301 ++++++++++++++++
 include/xen/interface/io/blkif.h      |   96 +++++
 include/xen/interface/io/console.h    |   23 +
 include/xen/interface/io/netif.h      |  152 ++++++++
 include/xen/interface/io/ring.h       |  260 ++++++++++++++
 include/xen/interface/io/xenbus.h     |   42 ++
 include/xen/interface/io/xs_wire.h    |   87 ++++
 include/xen/interface/memory.h        |  145 +++++++
 include/xen/interface/physdev.h       |   61 +++
 include/xen/interface/sched.h         |   77 ++++
 include/xen/interface/vcpu.h          |  109 +++++
 include/xen/interface/version.h       |   60 +++
 include/xen/interface/xen.h           |  445 ++++++++++++++++++++++++
 19 files changed, 2901 insertions(+)

diff -puN /dev/null include/asm-i386/xen/hypercall.h
--- /dev/null
+++ a/include/asm-i386/xen/hypercall.h
@@ -0,0 +1,413 @@
+/******************************************************************************
+ * hypercall.h
+ *
+ * Linux-specific hypervisor handling.
+ *
+ * Copyright (c) 2002-2004, K A Fraser
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+#ifndef __HYPERCALL_H__
+#define __HYPERCALL_H__
+
+#include <linux/errno.h>
+#include <linux/string.h>
+
+#include <xen/interface/xen.h>
+#include <xen/interface/sched.h>
+#include <xen/interface/physdev.h>
+
+extern struct { char _entry[32]; } hypercall_page[];
+
+#define _hypercall0(type, name)						\
+({									\
+	long __res;							\
+	asm volatile (							\
+		"call %[call]"						\
+		: "=a" (__res)						\
+		: [call] "m" (hypercall_page[__HYPERVISOR_##name])	\
+		: "memory" );						\
+	(type)__res;							\
+})
+
+#define _hypercall1(type, name, a1)					\
+({									\
+	long __res, __ign1;						\
+	asm volatile (							\
+		"call %[call]"						\
+		: "=a" (__res), "=b" (__ign1)				\
+		: "1" ((long)(a1)),					\
+		  [call] "m" (hypercall_page[__HYPERVISOR_##name])	\
+		: "memory" );						\
+	(type)__res;							\
+})
+
+#define _hypercall2(type, name, a1, a2)					\
+({									\
+	long __res, __ign1, __ign2;					\
+	asm volatile (							\
+		"call %[call]"						\
+		: "=a" (__res), "=b" (__ign1), "=c" (__ign2)		\
+		: "1" ((long)(a1)), "2" ((long)(a2)),			\
+		  [call] "m" (hypercall_page[__HYPERVISOR_##name])	\
+		: "memory" );						\
+	(type)__res;							\
+})
+
+#define _hypercall3(type, name, a1, a2, a3)				\
+({									\
+	long __res, __ign1, __ign2, __ign3;				\
+	asm volatile (							\
+		"call %[call]"						\
+		: "=a" (__res), "=b" (__ign1), "=c" (__ign2),		\
+		"=d" (__ign3)						\
+		: "1" ((long)(a1)), "2" ((long)(a2)),			\
+		  "3" ((long)(a3)),					\
+		  [call] "m" (hypercall_page[__HYPERVISOR_##name])	\
+		: "memory" );						\
+	(type)__res;							\
+})
+
+#define _hypercall4(type, name, a1, a2, a3, a4)				\
+({									\
+	long __res, __ign1, __ign2, __ign3, __ign4;			\
+	asm volatile (							\
+		"call %[call]"						\
+		: "=a" (__res), "=b" (__ign1), "=c" (__ign2),		\
+		"=d" (__ign3), "=S" (__ign4)				\
+		: "1" ((long)(a1)), "2" ((long)(a2)),			\
+		  "3" ((long)(a3)), "4" ((long)(a4)),			\
+		  [call] "m" (hypercall_page[__HYPERVISOR_##name])	\
+		: "memory" );						\
+	(type)__res;							\
+})
+
+#define _hypercall5(type, name, a1, a2, a3, a4, a5)			\
+({									\
+	long __res, __ign1, __ign2, __ign3, __ign4, __ign5;		\
+	asm volatile (							\
+		"call %[call]"						\
+		: "=a" (__res), "=b" (__ign1), "=c" (__ign2),		\
+		"=d" (__ign3), "=S" (__ign4), "=D" (__ign5)		\
+		: "1" ((long)(a1)), "2" ((long)(a2)),			\
+		  "3" ((long)(a3)), "4" ((long)(a4)),			\
+		  "5" ((long)(a5)),					\
+		  [call] "m" (hypercall_page[__HYPERVISOR_##name])	\
+		: "memory" );						\
+	(type)__res;							\
+})
+
+static inline int
+HYPERVISOR_set_trap_table(
+	struct trap_info *table)
+{
+	return _hypercall1(int, set_trap_table, table);
+}
+
+static inline int
+HYPERVISOR_mmu_update(
+	struct mmu_update *req, int count, int *success_count, domid_t domid)
+{
+	return _hypercall4(int, mmu_update, req, count, success_count, domid);
+}
+
+static inline int
+HYPERVISOR_mmuext_op(
+	struct mmuext_op *op, int count, int *success_count, domid_t domid)
+{
+	return _hypercall4(int, mmuext_op, op, count, success_count, domid);
+}
+
+static inline int
+HYPERVISOR_set_gdt(
+	unsigned long *frame_list, int entries)
+{
+	return _hypercall2(int, set_gdt, frame_list, entries);
+}
+
+static inline int
+HYPERVISOR_stack_switch(
+	unsigned long ss, unsigned long esp)
+{
+	return _hypercall2(int, stack_switch, ss, esp);
+}
+
+static inline int
+HYPERVISOR_set_callbacks(
+	unsigned long event_selector, unsigned long event_address,
+	unsigned long failsafe_selector, unsigned long failsafe_address)
+{
+	return _hypercall4(int, set_callbacks,
+			   event_selector, event_address,
+			   failsafe_selector, failsafe_address);
+}
+
+static inline int
+HYPERVISOR_fpu_taskswitch(
+	int set)
+{
+	return _hypercall1(int, fpu_taskswitch, set);
+}
+
+static inline int
+HYPERVISOR_sched_op(
+	int cmd, unsigned long arg)
+{
+	return _hypercall2(int, sched_op, cmd, arg);
+}
+
+static inline long
+HYPERVISOR_set_timer_op(
+	u64 timeout)
+{
+	unsigned long timeout_hi = (unsigned long)(timeout>>32);
+	unsigned long timeout_lo = (unsigned long)timeout;
+	return _hypercall2(long, set_timer_op, timeout_lo, timeout_hi);
+}
+
+static inline int
+HYPERVISOR_set_debugreg(
+	int reg, unsigned long value)
+{
+	return _hypercall2(int, set_debugreg, reg, value);
+}
+
+static inline unsigned long
+HYPERVISOR_get_debugreg(
+	int reg)
+{
+	return _hypercall1(unsigned long, get_debugreg, reg);
+}
+
+static inline int
+HYPERVISOR_update_descriptor(
+	u64 ma, u64 desc)
+{
+	return _hypercall4(int, update_descriptor, ma, ma>>32, desc, desc>>32);
+}
+
+static inline int
+HYPERVISOR_memory_op(
+	unsigned int cmd, void *arg)
+{
+	return _hypercall2(int, memory_op, cmd, arg);
+}
+
+static inline int
+HYPERVISOR_multicall(
+	void *call_list, int nr_calls)
+{
+	return _hypercall2(int, multicall, call_list, nr_calls);
+}
+
+static inline int
+HYPERVISOR_update_va_mapping(
+	unsigned long va, pte_t new_val, unsigned long flags)
+{
+	unsigned long pte_hi = 0;
+#ifdef CONFIG_X86_PAE
+	pte_hi = new_val.pte_high;
+#endif
+	return _hypercall4(int, update_va_mapping, va,
+			   new_val.pte_low, pte_hi, flags);
+}
+
+static inline int
+HYPERVISOR_event_channel_op(
+        int cmd, void *arg)
+{
+        int rc = _hypercall2(int, event_channel_op, cmd, arg);
+        if (unlikely(rc == -ENOSYS)) {
+                struct evtchn_op op;
+                op.cmd = cmd;
+                memcpy(&op.u, arg, sizeof(op.u));
+                rc = _hypercall1(int, event_channel_op_compat, &op);
+                memcpy(arg, &op.u, sizeof(op.u));
+        }
+        return rc;
+}
+
+static inline int
+HYPERVISOR_xen_version(
+	int cmd, void *arg)
+{
+	return _hypercall2(int, xen_version, cmd, arg);
+}
+
+static inline int
+HYPERVISOR_console_io(
+	int cmd, int count, char *str)
+{
+	return _hypercall3(int, console_io, cmd, count, str);
+}
+
+static inline int
+HYPERVISOR_physdev_op(int cmd, void *arg)
+{
+	int rc = _hypercall2(int, physdev_op, cmd, arg);
+	if (unlikely(rc == -ENOSYS)) {
+		struct physdev_op op;
+		op.cmd = cmd;
+		memcpy(&op.u, arg, sizeof(op.u));
+		rc = _hypercall1(int, physdev_op_compat, &op);
+		memcpy(arg, &op.u, sizeof(op.u));
+	}
+	return rc;
+}
+
+static inline int
+HYPERVISOR_grant_table_op(
+	unsigned int cmd, void *uop, unsigned int count)
+{
+	return _hypercall3(int, grant_table_op, cmd, uop, count);
+}
+
+static inline int
+HYPERVISOR_update_va_mapping_otherdomain(
+	unsigned long va, pte_t new_val, unsigned long flags, domid_t domid)
+{
+	unsigned long pte_hi = 0;
+#ifdef CONFIG_X86_PAE
+	pte_hi = new_val.pte_high;
+#endif
+	return _hypercall5(int, update_va_mapping_otherdomain, va,
+			   new_val.pte_low, pte_hi, flags, domid);
+}
+
+static inline int
+HYPERVISOR_vm_assist(
+	unsigned int cmd, unsigned int type)
+{
+	return _hypercall2(int, vm_assist, cmd, type);
+}
+
+static inline int
+HYPERVISOR_vcpu_op(
+	int cmd, int vcpuid, void *extra_args)
+{
+	return _hypercall3(int, vcpu_op, cmd, vcpuid, extra_args);
+}
+
+static inline int
+HYPERVISOR_suspend(
+	unsigned long srec)
+{
+	return _hypercall3(int, sched_op, SCHEDOP_shutdown,
+			   SHUTDOWN_suspend, srec);
+}
+
+static inline int
+HYPERVISOR_nmi_op(
+	unsigned long op,
+	unsigned long arg)
+{
+	return _hypercall2(int, nmi_op, op, arg);
+}
+
+static inline void
+MULTI_update_va_mapping(struct multicall_entry *mcl, unsigned long va,
+			pte_t new_val, unsigned long flags)
+{
+	mcl->op = __HYPERVISOR_update_va_mapping;
+	mcl->args[0] = va;
+#ifdef CONFIG_X86_PAE
+	mcl->args[1] = new_val.pte_low;
+	mcl->args[2] = new_val.pte_high;
+#else
+	mcl->args[1] = new_val.pte_low;
+	mcl->args[2] = 0;
+#endif
+	mcl->args[3] = flags;
+}
+
+static inline void
+MULTI_grant_table_op(struct multicall_entry *mcl, unsigned int cmd,
+		     void *uop, unsigned int count)
+{
+	mcl->op = __HYPERVISOR_grant_table_op;
+	mcl->args[0] = cmd;
+	mcl->args[1] = (unsigned long)uop;
+	mcl->args[2] = count;
+}
+
+static inline void
+MULTI_update_va_mapping_otherdomain(struct multicall_entry *mcl, unsigned long va,
+				    pte_t new_val, unsigned long flags, domid_t domid)
+{
+	mcl->op = __HYPERVISOR_update_va_mapping_otherdomain;
+	mcl->args[0] = va;
+#ifdef CONFIG_X86_PAE
+	mcl->args[1] = new_val.pte_low;
+	mcl->args[2] = new_val.pte_high;
+#else
+	mcl->args[1] = new_val.pte_low;
+	mcl->args[2] = 0;
+#endif
+	mcl->args[3] = flags;
+	mcl->args[4] = domid;
+}
+
+static inline void
+MULTI_update_descriptor(struct multicall_entry *mcl, u64 maddr,
+			struct desc_struct desc)
+{
+	mcl->op = __HYPERVISOR_update_descriptor;
+	mcl->args[0] = maddr;
+	mcl->args[1] = maddr >> 32;
+	mcl->args[2] = desc.a;
+	mcl->args[3] = desc.b;
+}
+
+static inline void
+MULTI_memory_op(struct multicall_entry *mcl, unsigned int cmd, void *arg)
+{
+	mcl->op = __HYPERVISOR_memory_op;
+	mcl->args[0] = cmd;
+	mcl->args[1] = (unsigned long)arg;
+}
+
+static inline void
+MULTI_mmu_update(struct multicall_entry *mcl, struct mmu_update *req,
+		 int count, int *success_count, domid_t domid)
+{
+	mcl->op = __HYPERVISOR_mmu_update;
+	mcl->args[0] = (unsigned long)req;
+	mcl->args[1] = count;
+	mcl->args[2] = (unsigned long)success_count;
+	mcl->args[3] = domid;
+}
+
+static inline void
+MULTI_mmuext_op(struct multicall_entry *mcl, struct mmuext_op *op, int count,
+		int *success_count, domid_t domid)
+{
+	mcl->op = __HYPERVISOR_mmuext_op;
+	mcl->args[0] = (unsigned long)op;
+	mcl->args[1] = count;
+	mcl->args[2] = (unsigned long)success_count;
+	mcl->args[3] = domid;
+}
+#endif /* __HYPERCALL_H__ */
diff -puN /dev/null include/asm-i386/xen/hypervisor.h
--- /dev/null
+++ a/include/asm-i386/xen/hypervisor.h
@@ -0,0 +1,72 @@
+/******************************************************************************
+ * hypervisor.h
+ *
+ * Linux-specific hypervisor handling.
+ *
+ * Copyright (c) 2002-2004, K A Fraser
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+#ifndef __HYPERVISOR_H__
+#define __HYPERVISOR_H__
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/version.h>
+
+#include <xen/interface/xen.h>
+#include <xen/interface/version.h>
+
+#include <asm/ptrace.h>
+#include <asm/page.h>
+#if defined(__i386__)
+#  ifdef CONFIG_X86_PAE
+#   include <asm-generic/pgtable-nopud.h>
+#  else
+#   include <asm-generic/pgtable-nopmd.h>
+#  endif
+#endif
+#include <asm/xen/hypercall.h>
+
+/* arch/i386/kernel/setup.c */
+extern struct shared_info *HYPERVISOR_shared_info;
+extern struct start_info *xen_start_info;
+#define is_initial_xendomain() (xen_start_info->flags & SIF_INITDOMAIN)
+
+/* arch/i386/mach-xen/evtchn.c */
+/* Force a proper event-channel callback from Xen. */
+extern void force_evtchn_callback(void);
+
+/* Turn jiffies into Xen system time. */
+u64 jiffies_to_st(unsigned long jiffies);
+
+
+#define MULTI_UVMFLAGS_INDEX 3
+#define MULTI_UVMDOMID_INDEX 4
+
+#define is_running_on_xen()	(xen_start_info ? 1 : 0)
+
+#endif /* __HYPERVISOR_H__ */
diff -puN /dev/null include/asm-i386/xen/interface.h
--- /dev/null
+++ a/include/asm-i386/xen/interface.h
@@ -0,0 +1,187 @@
+/******************************************************************************
+ * arch-x86_32.h
+ *
+ * Guest OS interface to x86 32-bit Xen.
+ *
+ * Copyright (c) 2004, K A Fraser
+ */
+
+#ifndef __XEN_PUBLIC_ARCH_X86_32_H__
+#define __XEN_PUBLIC_ARCH_X86_32_H__
+
+#ifdef __XEN__
+#define __DEFINE_GUEST_HANDLE(name, type) \
+    typedef struct { type *p; } __guest_handle_ ## name
+#else
+#define __DEFINE_GUEST_HANDLE(name, type) \
+    typedef type * __guest_handle_ ## name
+#endif
+
+#define DEFINE_GUEST_HANDLE_STRUCT(name) \
+	__DEFINE_GUEST_HANDLE(name, struct name)
+#define DEFINE_GUEST_HANDLE(name) __DEFINE_GUEST_HANDLE(name, name)
+#define GUEST_HANDLE(name)        __guest_handle_ ## name
+
+#ifndef __ASSEMBLY__
+/* Guest handles for primitive C types. */
+__DEFINE_GUEST_HANDLE(uchar, unsigned char);
+__DEFINE_GUEST_HANDLE(uint,  unsigned int);
+__DEFINE_GUEST_HANDLE(ulong, unsigned long);
+DEFINE_GUEST_HANDLE(char);
+DEFINE_GUEST_HANDLE(int);
+DEFINE_GUEST_HANDLE(long);
+DEFINE_GUEST_HANDLE(void);
+#endif
+
+/*
+ * SEGMENT DESCRIPTOR TABLES
+ */
+/*
+ * A number of GDT entries are reserved by Xen. These are not situated at the
+ * start of the GDT because some stupid OSes export hard-coded selector values
+ * in their ABI. These hard-coded values are always near the start of the GDT,
+ * so Xen places itself out of the way, at the far end of the GDT.
+ */
+#define FIRST_RESERVED_GDT_PAGE  14
+#define FIRST_RESERVED_GDT_BYTE  (FIRST_RESERVED_GDT_PAGE * 4096)
+#define FIRST_RESERVED_GDT_ENTRY (FIRST_RESERVED_GDT_BYTE / 8)
+
+/*
+ * These flat segments are in the Xen-private section of every GDT. Since these
+ * are also present in the initial GDT, many OSes will be able to avoid
+ * installing their own GDT.
+ */
+#define FLAT_RING1_CS 0xe019    /* GDT index 259 */
+#define FLAT_RING1_DS 0xe021    /* GDT index 260 */
+#define FLAT_RING1_SS 0xe021    /* GDT index 260 */
+#define FLAT_RING3_CS 0xe02b    /* GDT index 261 */
+#define FLAT_RING3_DS 0xe033    /* GDT index 262 */
+#define FLAT_RING3_SS 0xe033    /* GDT index 262 */
+
+#define FLAT_KERNEL_CS FLAT_RING1_CS
+#define FLAT_KERNEL_DS FLAT_RING1_DS
+#define FLAT_KERNEL_SS FLAT_RING1_SS
+#define FLAT_USER_CS    FLAT_RING3_CS
+#define FLAT_USER_DS    FLAT_RING3_DS
+#define FLAT_USER_SS    FLAT_RING3_SS
+
+/* And the trap vector is... */
+#define TRAP_INSTR "int $0x82"
+
+/*
+ * Virtual addresses beyond this are not modifiable by guest OSes. The
+ * machine->physical mapping table starts at this address, read-only.
+ */
+#ifdef CONFIG_X86_PAE
+#define __HYPERVISOR_VIRT_START 0xF5800000
+#else
+#define __HYPERVISOR_VIRT_START 0xFC000000
+#endif
+
+#ifndef HYPERVISOR_VIRT_START
+#define HYPERVISOR_VIRT_START mk_unsigned_long(__HYPERVISOR_VIRT_START)
+#endif
+
+#ifndef machine_to_phys_mapping
+#define machine_to_phys_mapping ((unsigned long *)HYPERVISOR_VIRT_START)
+#endif
+
+/* Maximum number of virtual CPUs in multi-processor guests. */
+#define MAX_VIRT_CPUS 32
+
+#ifndef __ASSEMBLY__
+
+/*
+ * Send an array of these to HYPERVISOR_set_trap_table()
+ */
+#define TI_GET_DPL(_ti)      ((_ti)->flags & 3)
+#define TI_GET_IF(_ti)       ((_ti)->flags & 4)
+#define TI_SET_DPL(_ti,_dpl) ((_ti)->flags |= (_dpl))
+#define TI_SET_IF(_ti,_if)   ((_ti)->flags |= ((!!(_if))<<2))
+struct trap_info {
+    uint8_t       vector;  /* exception vector                              */
+    uint8_t       flags;   /* 0-3: privilege level; 4: clear event enable?  */
+    uint16_t      cs;      /* code selector                                 */
+    unsigned long address; /* code offset                                   */
+};
+DEFINE_GUEST_HANDLE_STRUCT(trap_info);
+
+struct cpu_user_regs {
+    uint32_t ebx;
+    uint32_t ecx;
+    uint32_t edx;
+    uint32_t esi;
+    uint32_t edi;
+    uint32_t ebp;
+    uint32_t eax;
+    uint16_t error_code;    /* private */
+    uint16_t entry_vector;  /* private */
+    uint32_t eip;
+    uint16_t cs;
+    uint8_t  saved_upcall_mask;
+    uint8_t  _pad0;
+    uint32_t eflags;        /* eflags.IF == !saved_upcall_mask */
+    uint32_t esp;
+    uint16_t ss, _pad1;
+    uint16_t es, _pad2;
+    uint16_t ds, _pad3;
+    uint16_t fs, _pad4;
+    uint16_t gs, _pad5;
+};
+DEFINE_GUEST_HANDLE_STRUCT(cpu_user_regs);
+
+typedef uint64_t tsc_timestamp_t; /* RDTSC timestamp */
+
+/*
+ * The following is all CPU context. Note that the fpu_ctxt block is filled
+ * in by FXSAVE if the CPU has feature FXSR; otherwise FSAVE is used.
+ */
+struct vcpu_guest_context {
+    /* FPU registers come first so they can be aligned for FXSAVE/FXRSTOR. */
+    struct { char x[512]; } fpu_ctxt;       /* User-level FPU registers     */
+#define VGCF_I387_VALID (1<<0)
+#define VGCF_HVM_GUEST  (1<<1)
+#define VGCF_IN_KERNEL  (1<<2)
+    unsigned long flags;                    /* VGCF_* flags                 */
+    struct cpu_user_regs user_regs;         /* User-level CPU registers     */
+    struct trap_info trap_ctxt[256];        /* Virtual IDT                  */
+    unsigned long ldt_base, ldt_ents;       /* LDT (linear address, # ents) */
+    unsigned long gdt_frames[16], gdt_ents; /* GDT (machine frames, # ents) */
+    unsigned long kernel_ss, kernel_sp;     /* Virtual TSS (only SS1/SP1)   */
+    unsigned long ctrlreg[8];               /* CR0-CR7 (control registers)  */
+    unsigned long debugreg[8];              /* DB0-DB7 (debug registers)    */
+    unsigned long event_callback_cs;        /* CS:EIP of event callback     */
+    unsigned long event_callback_eip;
+    unsigned long failsafe_callback_cs;     /* CS:EIP of failsafe callback  */
+    unsigned long failsafe_callback_eip;
+    unsigned long vm_assist;                /* VMASST_TYPE_* bitmap */
+};
+DEFINE_GUEST_HANDLE_STRUCT(vcpu_guest_context);
+
+struct arch_shared_info {
+    unsigned long max_pfn;                  /* max pfn that appears in table */
+    /* Frame containing list of mfns containing list of mfns containing p2m. */
+    unsigned long pfn_to_mfn_frame_list_list;
+    unsigned long nmi_reason;
+};
+
+struct arch_vcpu_info {
+    unsigned long cr2;
+    unsigned long pad[5]; /* sizeof(struct vcpu_info) == 64 */
+};
+
+#endif /* !__ASSEMBLY__ */
+
+/*
+ * Prefix forces emulation of some non-trapping instructions.
+ * Currently only CPUID.
+ */
+#ifdef __ASSEMBLY__
+#define XEN_EMULATE_PREFIX .byte 0x0f,0x0b,0x78,0x65,0x6e ;
+#define XEN_CPUID          XEN_EMULATE_PREFIX cpuid
+#else
+#define XEN_EMULATE_PREFIX ".byte 0x0f,0x0b,0x78,0x65,0x6e ; "
+#define XEN_CPUID          XEN_EMULATE_PREFIX "cpuid"
+#endif
+
+#endif
diff -puN /dev/null include/xen/interface/elfnote.h
--- /dev/null
+++ a/include/xen/interface/elfnote.h
@@ -0,0 +1,133 @@
+/******************************************************************************
+ * elfnote.h
+ *
+ * Definitions used for the Xen ELF notes.
+ *
+ * Copyright (c) 2006, Ian Campbell, XenSource Ltd.
+ */
+
+#ifndef __XEN_PUBLIC_ELFNOTE_H__
+#define __XEN_PUBLIC_ELFNOTE_H__
+
+/*
+ * The notes should live in a SHT_NOTE segment and have "Xen" in the
+ * name field.
+ *
+ * Numeric types are either 4 or 8 bytes depending on the content of
+ * the desc field.
+ *
+ * LEGACY indicated the fields in the legacy __xen_guest string which
+ * this a note type replaces.
+ */
+
+/*
+ * NAME=VALUE pair (string).
+ *
+ * LEGACY: FEATURES and PAE
+ */
+#define XEN_ELFNOTE_INFO           0
+
+/*
+ * The virtual address of the entry point (numeric).
+ *
+ * LEGACY: VIRT_ENTRY
+ */
+#define XEN_ELFNOTE_ENTRY          1
+
+/* The virtual address of the hypercall transfer page (numeric).
+ *
+ * LEGACY: HYPERCALL_PAGE. (n.b. legacy value is a physical page
+ * number not a virtual address)
+ */
+#define XEN_ELFNOTE_HYPERCALL_PAGE 2
+
+/* The virtual address where the kernel image should be mapped (numeric).
+ *
+ * Defaults to 0.
+ *
+ * LEGACY: VIRT_BASE
+ */
+#define XEN_ELFNOTE_VIRT_BASE      3
+
+/*
+ * The offset of the ELF paddr field from the acutal required
+ * psuedo-physical address (numeric).
+ *
+ * This is used to maintain backwards compatibility with older kernels
+ * which wrote __PAGE_OFFSET into that field. This field defaults to 0
+ * if not present.
+ *
+ * LEGACY: ELF_PADDR_OFFSET. (n.b. legacy default is VIRT_BASE)
+ */
+#define XEN_ELFNOTE_PADDR_OFFSET   4
+
+/*
+ * The version of Xen that we work with (string).
+ *
+ * LEGACY: XEN_VER
+ */
+#define XEN_ELFNOTE_XEN_VERSION    5
+
+/*
+ * The name of the guest operating system (string).
+ *
+ * LEGACY: GUEST_OS
+ */
+#define XEN_ELFNOTE_GUEST_OS       6
+
+/*
+ * The version of the guest operating system (string).
+ *
+ * LEGACY: GUEST_VER
+ */
+#define XEN_ELFNOTE_GUEST_VERSION  7
+
+/*
+ * The loader type (string).
+ *
+ * LEGACY: LOADER
+ */
+#define XEN_ELFNOTE_LOADER         8
+
+/*
+ * The kernel supports PAE (x86/32 only, string = "yes" or "no").
+ *
+ * LEGACY: PAE (n.b. The legacy interface included a provision to
+ * indicate 'extended-cr3' support allowing L3 page tables to be
+ * placed above 4G. It is assumed that any kernel new enough to use
+ * these ELF notes will include this and therefore "yes" here is
+ * equivalent to "yes[entended-cr3]" in the __xen_guest interface.
+ */
+#define XEN_ELFNOTE_PAE_MODE       9
+
+/*
+ * The features supported/required by this kernel (string).
+ *
+ * The string must consist of a list of feature names (as given in
+ * features.h, without the "XENFEAT_" prefix) separated by '|'
+ * characters. If a feature is required for the kernel to function
+ * then the feature name must be preceded by a '!' character.
+ *
+ * LEGACY: FEATURES
+ */
+#define XEN_ELFNOTE_FEATURES      10
+
+/*
+ * The kernel requires the symbol table to be loaded (string = "yes" or "no")
+ * LEGACY: BSD_SYMTAB (n.b. The legacy treated the presence or absence
+ * of this string as a boolean flag rather than requiring "yes" or
+ * "no".
+ */
+#define XEN_ELFNOTE_BSD_SYMTAB    11
+
+#endif /* __XEN_PUBLIC_ELFNOTE_H__ */
+
+/*
+ * Local variables:
+ * mode: C
+ * c-set-style: "BSD"
+ * c-basic-offset: 4
+ * tab-width: 4
+ * indent-tabs-mode: nil
+ * End:
+ */
diff -puN /dev/null include/xen/interface/event_channel.h
--- /dev/null
+++ a/include/xen/interface/event_channel.h
@@ -0,0 +1,195 @@
+/******************************************************************************
+ * event_channel.h
+ *
+ * Event channels between domains.
+ *
+ * Copyright (c) 2003-2004, K A Fraser.
+ */
+
+#ifndef __XEN_PUBLIC_EVENT_CHANNEL_H__
+#define __XEN_PUBLIC_EVENT_CHANNEL_H__
+
+typedef uint32_t evtchn_port_t;
+DEFINE_GUEST_HANDLE(evtchn_port_t);
+
+/*
+ * EVTCHNOP_alloc_unbound: Allocate a port in domain <dom> and mark as
+ * accepting interdomain bindings from domain <remote_dom>. A fresh port
+ * is allocated in <dom> and returned as <port>.
+ * NOTES:
+ *  1. If the caller is unprivileged then <dom> must be DOMID_SELF.
+ *  2. <rdom> may be DOMID_SELF, allowing loopback connections.
+ */
+#define EVTCHNOP_alloc_unbound    6
+struct evtchn_alloc_unbound {
+    /* IN parameters */
+    domid_t dom, remote_dom;
+    /* OUT parameters */
+    evtchn_port_t port;
+};
+
+/*
+ * EVTCHNOP_bind_interdomain: Construct an interdomain event channel between
+ * the calling domain and <remote_dom>. <remote_dom,remote_port> must identify
+ * a port that is unbound and marked as accepting bindings from the calling
+ * domain. A fresh port is allocated in the calling domain and returned as
+ * <local_port>.
+ * NOTES:
+ *  2. <remote_dom> may be DOMID_SELF, allowing loopback connections.
+ */
+#define EVTCHNOP_bind_interdomain 0
+struct evtchn_bind_interdomain {
+    /* IN parameters. */
+    domid_t remote_dom;
+    evtchn_port_t remote_port;
+    /* OUT parameters. */
+    evtchn_port_t local_port;
+};
+
+/*
+ * EVTCHNOP_bind_virq: Bind a local event channel to VIRQ <irq> on specified
+ * vcpu.
+ * NOTES:
+ *  1. A virtual IRQ may be bound to at most one event channel per vcpu.
+ *  2. The allocated event channel is bound to the specified vcpu. The binding
+ *     may not be changed.
+ */
+#define EVTCHNOP_bind_virq        1
+struct evtchn_bind_virq {
+    /* IN parameters. */
+    uint32_t virq;
+    uint32_t vcpu;
+    /* OUT parameters. */
+    evtchn_port_t port;
+};
+
+/*
+ * EVTCHNOP_bind_pirq: Bind a local event channel to PIRQ <irq>.
+ * NOTES:
+ *  1. A physical IRQ may be bound to at most one event channel per domain.
+ *  2. Only a sufficiently-privileged domain may bind to a physical IRQ.
+ */
+#define EVTCHNOP_bind_pirq        2
+struct evtchn_bind_pirq {
+    /* IN parameters. */
+    uint32_t pirq;
+#define BIND_PIRQ__WILL_SHARE 1
+    uint32_t flags; /* BIND_PIRQ__* */
+    /* OUT parameters. */
+    evtchn_port_t port;
+};
+
+/*
+ * EVTCHNOP_bind_ipi: Bind a local event channel to receive events.
+ * NOTES:
+ *  1. The allocated event channel is bound to the specified vcpu. The binding
+ *     may not be changed.
+ */
+#define EVTCHNOP_bind_ipi         7
+struct evtchn_bind_ipi {
+    uint32_t vcpu;
+    /* OUT parameters. */
+    evtchn_port_t port;
+};
+
+/*
+ * EVTCHNOP_close: Close a local event channel <port>. If the channel is
+ * interdomain then the remote end is placed in the unbound state
+ * (EVTCHNSTAT_unbound), awaiting a new connection.
+ */
+#define EVTCHNOP_close            3
+struct evtchn_close {
+    /* IN parameters. */
+    evtchn_port_t port;
+};
+
+/*
+ * EVTCHNOP_send: Send an event to the remote end of the channel whose local
+ * endpoint is <port>.
+ */
+#define EVTCHNOP_send             4
+struct evtchn_send {
+    /* IN parameters. */
+    evtchn_port_t port;
+};
+
+/*
+ * EVTCHNOP_status: Get the current status of the communication channel which
+ * has an endpoint at <dom, port>.
+ * NOTES:
+ *  1. <dom> may be specified as DOMID_SELF.
+ *  2. Only a sufficiently-privileged domain may obtain the status of an event
+ *     channel for which <dom> is not DOMID_SELF.
+ */
+#define EVTCHNOP_status           5
+struct evtchn_status {
+    /* IN parameters */
+    domid_t  dom;
+    evtchn_port_t port;
+    /* OUT parameters */
+#define EVTCHNSTAT_closed       0  /* Channel is not in use.                 */
+#define EVTCHNSTAT_unbound      1  /* Channel is waiting interdom connection.*/
+#define EVTCHNSTAT_interdomain  2  /* Channel is connected to remote domain. */
+#define EVTCHNSTAT_pirq         3  /* Channel is bound to a phys IRQ line.   */
+#define EVTCHNSTAT_virq         4  /* Channel is bound to a virtual IRQ line */
+#define EVTCHNSTAT_ipi          5  /* Channel is bound to a virtual IPI line */
+    uint32_t status;
+    uint32_t vcpu;                 /* VCPU to which this channel is bound.   */
+    union {
+        struct {
+            domid_t dom;
+        } unbound; /* EVTCHNSTAT_unbound */
+        struct {
+            domid_t dom;
+            evtchn_port_t port;
+        } interdomain; /* EVTCHNSTAT_interdomain */
+        uint32_t pirq;      /* EVTCHNSTAT_pirq        */
+        uint32_t virq;      /* EVTCHNSTAT_virq        */
+    } u;
+};
+
+/*
+ * EVTCHNOP_bind_vcpu: Specify which vcpu a channel should notify when an
+ * event is pending.
+ * NOTES:
+ *  1. IPI- and VIRQ-bound channels always notify the vcpu that initialised
+ *     the binding. This binding cannot be changed.
+ *  2. All other channels notify vcpu0 by default. This default is set when
+ *     the channel is allocated (a port that is freed and subsequently reused
+ *     has its binding reset to vcpu0).
+ */
+#define EVTCHNOP_bind_vcpu        8
+struct evtchn_bind_vcpu {
+    /* IN parameters. */
+    evtchn_port_t port;
+    uint32_t vcpu;
+};
+
+/*
+ * EVTCHNOP_unmask: Unmask the specified local event-channel port and deliver
+ * a notification to the appropriate VCPU if an event is pending.
+ */
+#define EVTCHNOP_unmask           9
+struct evtchn_unmask {
+    /* IN parameters. */
+    evtchn_port_t port;
+};
+
+struct evtchn_op {
+    uint32_t cmd; /* EVTCHNOP_* */
+    union {
+        struct evtchn_alloc_unbound    alloc_unbound;
+        struct evtchn_bind_interdomain bind_interdomain;
+        struct evtchn_bind_virq        bind_virq;
+        struct evtchn_bind_pirq        bind_pirq;
+        struct evtchn_bind_ipi         bind_ipi;
+        struct evtchn_close            close;
+        struct evtchn_send             send;
+        struct evtchn_status           status;
+        struct evtchn_bind_vcpu        bind_vcpu;
+        struct evtchn_unmask           unmask;
+    } u;
+};
+DEFINE_GUEST_HANDLE_STRUCT(evtchn_op);
+
+#endif /* __XEN_PUBLIC_EVENT_CHANNEL_H__ */
diff -puN /dev/null include/xen/interface/features.h
--- /dev/null
+++ a/include/xen/interface/features.h
@@ -0,0 +1,43 @@
+/******************************************************************************
+ * features.h
+ *
+ * Feature flags, reported by XENVER_get_features.
+ *
+ * Copyright (c) 2006, Keir Fraser <keir@xensource.com>
+ */
+
+#ifndef __XEN_PUBLIC_FEATURES_H__
+#define __XEN_PUBLIC_FEATURES_H__
+
+/*
+ * If set, the guest does not need to write-protect its pagetables, and can
+ * update them via direct writes.
+ */
+#define XENFEAT_writable_page_tables       0
+
+/*
+ * If set, the guest does not need to write-protect its segment descriptor
+ * tables, and can update them via direct writes.
+ */
+#define XENFEAT_writable_descriptor_tables 1
+
+/*
+ * If set, translation between the guest's 'pseudo-physical' address space
+ * and the host's machine address space are handled by the hypervisor. In this
+ * mode the guest does not need to perform phys-to/from-machine translations
+ * when performing page table operations.
+ */
+#define XENFEAT_auto_translated_physmap    2
+
+/* If set, the guest is running in supervisor mode (e.g., x86 ring 0). */
+#define XENFEAT_supervisor_mode_kernel     3
+
+/*
+ * If set, the guest does not need to allocate x86 PAE page directories
+ * below 4GB. This flag is usually implied by auto_translated_physmap.
+ */
+#define XENFEAT_pae_pgdir_above_4gb        4
+
+#define XENFEAT_NR_SUBMAPS 1
+
+#endif /* __XEN_PUBLIC_FEATURES_H__ */
diff -puN /dev/null include/xen/interface/grant_table.h
--- /dev/null
+++ a/include/xen/interface/grant_table.h
@@ -0,0 +1,301 @@
+/******************************************************************************
+ * grant_table.h
+ *
+ * Interface for granting foreign access to page frames, and receiving
+ * page-ownership transfers.
+ *
+ * Copyright (c) 2004, K A Fraser
+ */
+
+#ifndef __XEN_PUBLIC_GRANT_TABLE_H__
+#define __XEN_PUBLIC_GRANT_TABLE_H__
+
+
+/***********************************
+ * GRANT TABLE REPRESENTATION
+ */
+
+/* Some rough guidelines on accessing and updating grant-table entries
+ * in a concurrency-safe manner. For more information, Linux contains a
+ * reference implementation for guest OSes (arch/i386/mach-xen/grant_table.c).
+ *
+ * NB. WMB is a no-op on current-generation x86 processors. However, a
+ *     compiler barrier will still be required.
+ *
+ * Introducing a valid entry into the grant table:
+ *  1. Write ent->domid.
+ *  2. Write ent->frame:
+ *      GTF_permit_access:   Frame to which access is permitted.
+ *      GTF_accept_transfer: Pseudo-phys frame slot being filled by new
+ *                           frame, or zero if none.
+ *  3. Write memory barrier (WMB).
+ *  4. Write ent->flags, inc. valid type.
+ *
+ * Invalidating an unused GTF_permit_access entry:
+ *  1. flags = ent->flags.
+ *  2. Observe that !(flags & (GTF_reading|GTF_writing)).
+ *  3. Check result of SMP-safe CMPXCHG(&ent->flags, flags, 0).
+ *  NB. No need for WMB as reuse of entry is control-dependent on success of
+ *      step 3, and all architectures guarantee ordering of ctrl-dep writes.
+ *
+ * Invalidating an in-use GTF_permit_access entry:
+ *  This cannot be done directly. Request assistance from the domain controller
+ *  which can set a timeout on the use of a grant entry and take necessary
+ *  action. (NB. This is not yet implemented!).
+ *
+ * Invalidating an unused GTF_accept_transfer entry:
+ *  1. flags = ent->flags.
+ *  2. Observe that !(flags & GTF_transfer_committed). [*]
+ *  3. Check result of SMP-safe CMPXCHG(&ent->flags, flags, 0).
+ *  NB. No need for WMB as reuse of entry is control-dependent on success of
+ *      step 3, and all architectures guarantee ordering of ctrl-dep writes.
+ *  [*] If GTF_transfer_committed is set then the grant entry is 'committed'.
+ *      The guest must /not/ modify the grant entry until the address of the
+ *      transferred frame is written. It is safe for the guest to spin waiting
+ *      for this to occur (detect by observing GTF_transfer_completed in
+ *      ent->flags).
+ *
+ * Invalidating a committed GTF_accept_transfer entry:
+ *  1. Wait for (ent->flags & GTF_transfer_completed).
+ *
+ * Changing a GTF_permit_access from writable to read-only:
+ *  Use SMP-safe CMPXCHG to set GTF_readonly, while checking !GTF_writing.
+ *
+ * Changing a GTF_permit_access from read-only to writable:
+ *  Use SMP-safe bit-setting instruction.
+ */
+
+/*
+ * A grant table comprises a packed array of grant entries in one or more
+ * page frames shared between Xen and a guest.
+ * [XEN]: This field is written by Xen and read by the sharing guest.
+ * [GST]: This field is written by the guest and read by Xen.
+ */
+struct grant_entry {
+    /* GTF_xxx: various type and flag information.  [XEN,GST] */
+    uint16_t flags;
+    /* The domain being granted foreign privileges. [GST] */
+    domid_t  domid;
+    /*
+     * GTF_permit_access: Frame that @domid is allowed to map and access. [GST]
+     * GTF_accept_transfer: Frame whose ownership transferred by @domid. [XEN]
+     */
+    uint32_t frame;
+};
+
+/*
+ * Type of grant entry.
+ *  GTF_invalid: This grant entry grants no privileges.
+ *  GTF_permit_access: Allow @domid to map/access @frame.
+ *  GTF_accept_transfer: Allow @domid to transfer ownership of one page frame
+ *                       to this guest. Xen writes the page number to @frame.
+ */
+#define GTF_invalid         (0U<<0)
+#define GTF_permit_access   (1U<<0)
+#define GTF_accept_transfer (2U<<0)
+#define GTF_type_mask       (3U<<0)
+
+/*
+ * Subflags for GTF_permit_access.
+ *  GTF_readonly: Restrict @domid to read-only mappings and accesses. [GST]
+ *  GTF_reading: Grant entry is currently mapped for reading by @domid. [XEN]
+ *  GTF_writing: Grant entry is currently mapped for writing by @domid. [XEN]
+ */
+#define _GTF_readonly       (2)
+#define GTF_readonly        (1U<<_GTF_readonly)
+#define _GTF_reading        (3)
+#define GTF_reading         (1U<<_GTF_reading)
+#define _GTF_writing        (4)
+#define GTF_writing         (1U<<_GTF_writing)
+
+/*
+ * Subflags for GTF_accept_transfer:
+ *  GTF_transfer_committed: Xen sets this flag to indicate that it is committed
+ *      to transferring ownership of a page frame. When a guest sees this flag
+ *      it must /not/ modify the grant entry until GTF_transfer_completed is
+ *      set by Xen.
+ *  GTF_transfer_completed: It is safe for the guest to spin-wait on this flag
+ *      after reading GTF_transfer_committed. Xen will always write the frame
+ *      address, followed by ORing this flag, in a timely manner.
+ */
+#define _GTF_transfer_committed (2)
+#define GTF_transfer_committed  (1U<<_GTF_transfer_committed)
+#define _GTF_transfer_completed (3)
+#define GTF_transfer_completed  (1U<<_GTF_transfer_completed)
+
+
+/***********************************
+ * GRANT TABLE QUERIES AND USES
+ */
+
+/*
+ * Reference to a grant entry in a specified domain's grant table.
+ */
+typedef uint32_t grant_ref_t;
+
+/*
+ * Handle to track a mapping created via a grant reference.
+ */
+typedef uint32_t grant_handle_t;
+
+/*
+ * GNTTABOP_map_grant_ref: Map the grant entry (<dom>,<ref>) for access
+ * by devices and/or host CPUs. If successful, <handle> is a tracking number
+ * that must be presented later to destroy the mapping(s). On error, <handle>
+ * is a negative status code.
+ * NOTES:
+ *  1. If GNTPIN_map_for_dev is specified then <dev_bus_addr> is the address
+ *     via which I/O devices may access the granted frame.
+ *  2. If GNTPIN_map_for_host is specified then a mapping will be added at
+ *     either a host virtual address in the current address space, or at
+ *     a PTE at the specified machine address.  The type of mapping to
+ *     perform is selected through the GNTMAP_contains_pte flag, and the
+ *     address is specified in <host_addr>.
+ *  3. Mappings should only be destroyed via GNTTABOP_unmap_grant_ref. If a
+ *     host mapping is destroyed by other means then it is *NOT* guaranteed
+ *     to be accounted to the correct grant reference!
+ */
+#define GNTTABOP_map_grant_ref        0
+struct gnttab_map_grant_ref {
+    /* IN parameters. */
+    uint64_t host_addr;
+    uint32_t flags;               /* GNTMAP_* */
+    grant_ref_t ref;
+    domid_t  dom;
+    /* OUT parameters. */
+    int16_t  status;              /* GNTST_* */
+    grant_handle_t handle;
+    uint64_t dev_bus_addr;
+};
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_map_grant_ref);
+
+/*
+ * GNTTABOP_unmap_grant_ref: Destroy one or more grant-reference mappings
+ * tracked by <handle>. If <host_addr> or <dev_bus_addr> is zero, that
+ * field is ignored. If non-zero, they must refer to a device/host mapping
+ * that is tracked by <handle>
+ * NOTES:
+ *  1. The call may fail in an undefined manner if either mapping is not
+ *     tracked by <handle>.
+ *  3. After executing a batch of unmaps, it is guaranteed that no stale
+ *     mappings will remain in the device or host TLBs.
+ */
+#define GNTTABOP_unmap_grant_ref      1
+struct gnttab_unmap_grant_ref {
+    /* IN parameters. */
+    uint64_t host_addr;
+    uint64_t dev_bus_addr;
+    grant_handle_t handle;
+    /* OUT parameters. */
+    int16_t  status;              /* GNTST_* */
+};
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_unmap_grant_ref);
+
+/*
+ * GNTTABOP_setup_table: Set up a grant table for <dom> comprising at least
+ * <nr_frames> pages. The frame addresses are written to the <frame_list>.
+ * Only <nr_frames> addresses are written, even if the table is larger.
+ * NOTES:
+ *  1. <dom> may be specified as DOMID_SELF.
+ *  2. Only a sufficiently-privileged domain may specify <dom> != DOMID_SELF.
+ *  3. Xen may not support more than a single grant-table page per domain.
+ */
+#define GNTTABOP_setup_table          2
+struct gnttab_setup_table {
+    /* IN parameters. */
+    domid_t  dom;
+    uint32_t nr_frames;
+    /* OUT parameters. */
+    int16_t  status;              /* GNTST_* */
+    GUEST_HANDLE(ulong) frame_list;
+};
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_setup_table);
+
+/*
+ * GNTTABOP_dump_table: Dump the contents of the grant table to the
+ * xen console. Debugging use only.
+ */
+#define GNTTABOP_dump_table           3
+struct gnttab_dump_table {
+    /* IN parameters. */
+    domid_t dom;
+    /* OUT parameters. */
+    int16_t status;               /* GNTST_* */
+};
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_dump_table);
+
+/*
+ * GNTTABOP_transfer_grant_ref: Transfer <frame> to a foreign domain. The
+ * foreign domain has previously registered its interest in the transfer via
+ * <domid, ref>.
+ *
+ * Note that, even if the transfer fails, the specified page no longer belongs
+ * to the calling domain *unless* the error is GNTST_bad_page.
+ */
+#define GNTTABOP_transfer                4
+struct gnttab_transfer {
+    /* IN parameters. */
+    unsigned long mfn;
+    domid_t       domid;
+    grant_ref_t   ref;
+    /* OUT parameters. */
+    int16_t       status;
+};
+DEFINE_GUEST_HANDLE_STRUCT(gnttab_transfer);
+
+/*
+ * Bitfield values for update_pin_status.flags.
+ */
+ /* Map the grant entry for access by I/O devices. */
+#define _GNTMAP_device_map      (0)
+#define GNTMAP_device_map       (1<<_GNTMAP_device_map)
+ /* Map the grant entry for access by host CPUs. */
+#define _GNTMAP_host_map        (1)
+#define GNTMAP_host_map         (1<<_GNTMAP_host_map)
+ /* Accesses to the granted frame will be restricted to read-only access. */
+#define _GNTMAP_readonly        (2)
+#define GNTMAP_readonly         (1<<_GNTMAP_readonly)
+ /*
+  * GNTMAP_host_map subflag:
+  *  0 => The host mapping is usable only by the guest OS.
+  *  1 => The host mapping is usable by guest OS + current application.
+  */
+#define _GNTMAP_application_map (3)
+#define GNTMAP_application_map  (1<<_GNTMAP_application_map)
+
+ /*
+  * GNTMAP_contains_pte subflag:
+  *  0 => This map request contains a host virtual address.
+  *  1 => This map request contains the machine addess of the PTE to update.
+  */
+#define _GNTMAP_contains_pte    (4)
+#define GNTMAP_contains_pte     (1<<_GNTMAP_contains_pte)
+
+/*
+ * Values for error status returns. All errors are -ve.
+ */
+#define GNTST_okay             (0)  /* Normal return.                        */
+#define GNTST_general_error    (-1) /* General undefined error.              */
+#define GNTST_bad_domain       (-2) /* Unrecognsed domain id.                */
+#define GNTST_bad_gntref       (-3) /* Unrecognised or inappropriate gntref. */
+#define GNTST_bad_handle       (-4) /* Unrecognised or inappropriate handle. */
+#define GNTST_bad_virt_addr    (-5) /* Inappropriate virtual address to map. */
+#define GNTST_bad_dev_addr     (-6) /* Inappropriate device address to unmap.*/
+#define GNTST_no_device_space  (-7) /* Out of space in I/O MMU.              */
+#define GNTST_permission_denied (-8) /* Not enough privilege for operation.  */
+#define GNTST_bad_page         (-9) /* Specified page was invalid for op.    */
+
+#define GNTTABOP_error_msgs {                   \
+    "okay",                                     \
+    "undefined error",                          \
+    "unrecognised domain id",                   \
+    "invalid grant reference",                  \
+    "invalid mapping handle",                   \
+    "invalid virtual address",                  \
+    "invalid device address",                   \
+    "no spare translation slot in the I/O MMU", \
+    "permission denied",                        \
+    "bad page"                                  \
+}
+
+#endif /* __XEN_PUBLIC_GRANT_TABLE_H__ */
diff -puN /dev/null include/xen/interface/io/blkif.h
--- /dev/null
+++ a/include/xen/interface/io/blkif.h
@@ -0,0 +1,96 @@
+/******************************************************************************
+ * blkif.h
+ *
+ * Unified block-device I/O interface for Xen guest OSes.
+ *
+ * Copyright (c) 2003-2004, Keir Fraser
+ */
+
+#ifndef __XEN_PUBLIC_IO_BLKIF_H__
+#define __XEN_PUBLIC_IO_BLKIF_H__
+
+#include "ring.h"
+#include "../grant_table.h"
+
+/*
+ * Front->back notifications: When enqueuing a new request, sending a
+ * notification can be made conditional on req_event (i.e., the generic
+ * hold-off mechanism provided by the ring macros). Backends must set
+ * req_event appropriately (e.g., using RING_FINAL_CHECK_FOR_REQUESTS()).
+ *
+ * Back->front notifications: When enqueuing a new response, sending a
+ * notification can be made conditional on rsp_event (i.e., the generic
+ * hold-off mechanism provided by the ring macros). Frontends must set
+ * rsp_event appropriately (e.g., using RING_FINAL_CHECK_FOR_RESPONSES()).
+ */
+
+#ifndef blkif_vdev_t
+#define blkif_vdev_t   uint16_t
+#endif
+#define blkif_sector_t uint64_t
+
+/*
+ * REQUEST CODES.
+ */
+#define BLKIF_OP_READ              0
+#define BLKIF_OP_WRITE             1
+/*
+ * Recognised only if "feature-barrier" is present in backend xenbus info.
+ * The "feature_barrier" node contains a boolean indicating whether barrier
+ * requests are likely to succeed or fail. Either way, a barrier request
+ * may fail at any time with BLKIF_RSP_EOPNOTSUPP if it is unsupported by
+ * the underlying block-device hardware. The boolean simply indicates whether
+ * or not it is worthwhile for the frontend to attempt barrier requests.
+ * If a backend does not recognise BLKIF_OP_WRITE_BARRIER, it should *not*
+ * create the "feature-barrier" node!
+ */
+#define BLKIF_OP_WRITE_BARRIER     2
+
+/*
+ * Maximum scatter/gather segments per request.
+ * This is carefully chosen so that sizeof(struct blkif_ring) <= PAGE_SIZE.
+ * NB. This could be 12 if the ring indexes weren't stored in the same page.
+ */
+#define BLKIF_MAX_SEGMENTS_PER_REQUEST 11
+
+struct blkif_request {
+    uint8_t        operation;    /* BLKIF_OP_???                         */
+    uint8_t        nr_segments;  /* number of segments                   */
+    blkif_vdev_t   handle;       /* only for read/write requests         */
+    uint64_t       id;           /* private guest value, echoed in resp  */
+    blkif_sector_t sector_number;/* start sector idx on disk (r/w only)  */
+    struct blkif_request_segment {
+        grant_ref_t gref;        /* reference to I/O buffer frame        */
+        /* @first_sect: first sector in frame to transfer (inclusive).   */
+        /* @last_sect: last sector in frame to transfer (inclusive).     */
+        uint8_t     first_sect, last_sect;
+    } seg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+};
+
+struct blkif_response {
+    uint64_t        id;              /* copied from request */
+    uint8_t         operation;       /* copied from request */
+    int16_t         status;          /* BLKIF_RSP_???       */
+};
+
+/*
+ * STATUS RETURN CODES.
+ */
+ /* Operation not supported (only happens on barrier writes). */
+#define BLKIF_RSP_EOPNOTSUPP  -2
+ /* Operation failed for some unspecified reason (-EIO). */
+#define BLKIF_RSP_ERROR       -1
+ /* Operation completed successfully. */
+#define BLKIF_RSP_OKAY         0
+
+/*
+ * Generate blkif ring structures and types.
+ */
+
+DEFINE_RING_TYPES(blkif, struct blkif_request, struct blkif_response);
+
+#define VDISK_CDROM        0x1
+#define VDISK_REMOVABLE    0x2
+#define VDISK_READONLY     0x4
+
+#endif /* __XEN_PUBLIC_IO_BLKIF_H__ */
diff -puN /dev/null include/xen/interface/io/console.h
--- /dev/null
+++ a/include/xen/interface/io/console.h
@@ -0,0 +1,23 @@
+/******************************************************************************
+ * console.h
+ *
+ * Console I/O interface for Xen guest OSes.
+ *
+ * Copyright (c) 2005, Keir Fraser
+ */
+
+#ifndef __XEN_PUBLIC_IO_CONSOLE_H__
+#define __XEN_PUBLIC_IO_CONSOLE_H__
+
+typedef uint32_t XENCONS_RING_IDX;
+
+#define MASK_XENCONS_IDX(idx, ring) ((idx) & (sizeof(ring)-1))
+
+struct xencons_interface {
+    char in[1024];
+    char out[2048];
+    XENCONS_RING_IDX in_cons, in_prod;
+    XENCONS_RING_IDX out_cons, out_prod;
+};
+
+#endif /* __XEN_PUBLIC_IO_CONSOLE_H__ */
diff -puN /dev/null include/xen/interface/io/netif.h
--- /dev/null
+++ a/include/xen/interface/io/netif.h
@@ -0,0 +1,152 @@
+/******************************************************************************
+ * netif.h
+ *
+ * Unified network-device I/O interface for Xen guest OSes.
+ *
+ * Copyright (c) 2003-2004, Keir Fraser
+ */
+
+#ifndef __XEN_PUBLIC_IO_NETIF_H__
+#define __XEN_PUBLIC_IO_NETIF_H__
+
+#include "ring.h"
+#include "../grant_table.h"
+
+/*
+ * Notifications after enqueuing any type of message should be conditional on
+ * the appropriate req_event or rsp_event field in the shared ring.
+ * If the client sends notification for rx requests then it should specify
+ * feature 'feature-rx-notify' via xenbus. Otherwise the backend will assume
+ * that it cannot safely queue packets (as it may not be kicked to send them).
+ */
+
+/*
+ * This is the 'wire' format for packets:
+ *  Request 1: netif_tx_request -- NETTXF_* (any flags)
+ * [Request 2: netif_tx_extra]  (only if request 1 has NETTXF_extra_info)
+ * [Request 3: netif_tx_extra]  (only if request 2 has XEN_NETIF_EXTRA_MORE)
+ *  Request 4: netif_tx_request -- NETTXF_more_data
+ *  Request 5: netif_tx_request -- NETTXF_more_data
+ *  ...
+ *  Request N: netif_tx_request -- 0
+ */
+
+/* Protocol checksum field is blank in the packet (hardware offload)? */
+#define _NETTXF_csum_blank     (0)
+#define  NETTXF_csum_blank     (1U<<_NETTXF_csum_blank)
+
+/* Packet data has been validated against protocol checksum. */
+#define _NETTXF_data_validated (1)
+#define  NETTXF_data_validated (1U<<_NETTXF_data_validated)
+
+/* Packet continues in the next request descriptor. */
+#define _NETTXF_more_data      (2)
+#define  NETTXF_more_data      (1U<<_NETTXF_more_data)
+
+/* Packet to be followed by extra descriptor(s). */
+#define _NETTXF_extra_info     (3)
+#define  NETTXF_extra_info     (1U<<_NETTXF_extra_info)
+
+struct netif_tx_request {
+    grant_ref_t gref;      /* Reference to buffer page */
+    uint16_t offset;       /* Offset within buffer page */
+    uint16_t flags;        /* NETTXF_* */
+    uint16_t id;           /* Echoed in response message. */
+    uint16_t size;         /* Packet size in bytes.       */
+};
+
+/* Types of netif_extra_info descriptors. */
+#define XEN_NETIF_EXTRA_TYPE_NONE  (0)  /* Never used - invalid */
+#define XEN_NETIF_EXTRA_TYPE_GSO   (1)  /* u.gso */
+#define XEN_NETIF_EXTRA_TYPE_MAX   (2)
+
+/* netif_extra_info flags. */
+#define _XEN_NETIF_EXTRA_FLAG_MORE (0)
+#define XEN_NETIF_EXTRA_FLAG_MORE  (1U<<_XEN_NETIF_EXTRA_FLAG_MORE)
+
+/* GSO types - only TCPv4 currently supported. */
+#define XEN_NETIF_GSO_TYPE_TCPV4        (1)
+
+/*
+ * This structure needs to fit within both netif_tx_request and
+ * netif_rx_response for compatibility.
+ */
+struct netif_extra_info {
+    uint8_t type;  /* XEN_NETIF_EXTRA_TYPE_* */
+    uint8_t flags; /* XEN_NETIF_EXTRA_FLAG_* */
+
+    union {
+        struct {
+            /*
+             * Maximum payload size of each segment. For example, for TCP this
+             * is just the path MSS.
+             */
+            uint16_t size;
+
+            /*
+             * GSO type. This determines the protocol of the packet and any
+             * extra features required to segment the packet properly.
+             */
+            uint8_t type; /* XEN_NETIF_GSO_TYPE_* */
+
+            /* Future expansion. */
+            uint8_t pad;
+
+            /*
+             * GSO features. This specifies any extra GSO features required
+             * to process this packet, such as ECN support for TCPv4.
+             */
+            uint16_t features; /* XEN_NETIF_GSO_FEAT_* */
+        } gso;
+
+        uint16_t pad[3];
+    } u;
+};
+
+struct netif_tx_response {
+    uint16_t id;
+    int16_t  status;       /* NETIF_RSP_* */
+};
+
+struct netif_rx_request {
+    uint16_t    id;        /* Echoed in response message.        */
+    grant_ref_t gref;      /* Reference to incoming granted frame */
+};
+
+/* Packet data has been validated against protocol checksum. */
+#define _NETRXF_data_validated (0)
+#define  NETRXF_data_validated (1U<<_NETRXF_data_validated)
+
+/* Protocol checksum field is blank in the packet (hardware offload)? */
+#define _NETRXF_csum_blank     (1)
+#define  NETRXF_csum_blank     (1U<<_NETRXF_csum_blank)
+
+/* Packet continues in the next request descriptor. */
+#define _NETRXF_more_data      (2)
+#define  NETRXF_more_data      (1U<<_NETRXF_more_data)
+
+/* Packet to be followed by extra descriptor(s). */
+#define _NETRXF_extra_info     (3)
+#define  NETRXF_extra_info     (1U<<_NETRXF_extra_info)
+
+struct netif_rx_response {
+    uint16_t id;
+    uint16_t offset;       /* Offset in page of start of received packet  */
+    uint16_t flags;        /* NETRXF_* */
+    int16_t  status;       /* -ve: BLKIF_RSP_* ; +ve: Rx'ed pkt size. */
+};
+
+/*
+ * Generate netif ring structures and types.
+ */
+
+DEFINE_RING_TYPES(netif_tx, struct netif_tx_request, struct netif_tx_response);
+DEFINE_RING_TYPES(netif_rx, struct netif_rx_request, struct netif_rx_response);
+
+#define NETIF_RSP_DROPPED         -2
+#define NETIF_RSP_ERROR           -1
+#define NETIF_RSP_OKAY             0
+/* No response: used for auxiliary requests (e.g., netif_tx_extra). */
+#define NETIF_RSP_NULL             1
+
+#endif
diff -puN /dev/null include/xen/interface/io/ring.h
--- /dev/null
+++ a/include/xen/interface/io/ring.h
@@ -0,0 +1,260 @@
+/******************************************************************************
+ * ring.h
+ *
+ * Shared producer-consumer ring macros.
+ *
+ * Tim Deegan and Andrew Warfield November 2004.
+ */
+
+#ifndef __XEN_PUBLIC_IO_RING_H__
+#define __XEN_PUBLIC_IO_RING_H__
+
+typedef unsigned int RING_IDX;
+
+/* Round a 32-bit unsigned constant down to the nearest power of two. */
+#define __RD2(_x)  (((_x) & 0x00000002) ? 0x2                  : ((_x) & 0x1))
+#define __RD4(_x)  (((_x) & 0x0000000c) ? __RD2((_x)>>2)<<2    : __RD2(_x))
+#define __RD8(_x)  (((_x) & 0x000000f0) ? __RD4((_x)>>4)<<4    : __RD4(_x))
+#define __RD16(_x) (((_x) & 0x0000ff00) ? __RD8((_x)>>8)<<8    : __RD8(_x))
+#define __RD32(_x) (((_x) & 0xffff0000) ? __RD16((_x)>>16)<<16 : __RD16(_x))
+
+/*
+ * Calculate size of a shared ring, given the total available space for the
+ * ring and indexes (_sz), and the name tag of the request/response structure.
+ * A ring contains as many entries as will fit, rounded down to the nearest
+ * power of two (so we can mask with (size-1) to loop around).
+ */
+#define __RING_SIZE(_s, _sz) \
+    (__RD32(((_sz) - (long)&(_s)->ring + (long)(_s)) / sizeof((_s)->ring[0])))
+
+/*
+ * Macros to make the correct C datatypes for a new kind of ring.
+ *
+ * To make a new ring datatype, you need to have two message structures,
+ * let's say struct request, and struct response already defined.
+ *
+ * In a header where you want the ring datatype declared, you then do:
+ *
+ *     DEFINE_RING_TYPES(mytag, struct request, struct response);
+ *
+ * These expand out to give you a set of types, as you can see below.
+ * The most important of these are:
+ *
+ *     struct mytag_sring      - The shared ring.
+ *     struct mytag_front_ring - The 'front' half of the ring.
+ *     struct mytag_back_ring  - The 'back' half of the ring.
+ *
+ * To initialize a ring in your code you need to know the location and size
+ * of the shared memory area (PAGE_SIZE, for instance). To initialise
+ * the front half:
+ *
+ *     struct mytag_front_ring front_ring;
+ *     SHARED_RING_INIT((struct mytag_sring *)shared_page);
+ *     FRONT_RING_INIT(&front_ring, (struct mytag_sring *)shared_page,
+ *                     PAGE_SIZE);
+ *
+ * Initializing the back follows similarly (note that only the front
+ * initializes the shared ring):
+ *
+ *     struct mytag_back_ring back_ring;
+ *     BACK_RING_INIT(&back_ring, (struct mytag_sring *)shared_page,
+ *                    PAGE_SIZE);
+ */
+
+#define DEFINE_RING_TYPES(__name, __req_t, __rsp_t)                     \
+                                                                        \
+/* Shared ring entry */                                                 \
+union __name##_sring_entry {                                            \
+    __req_t req;                                                        \
+    __rsp_t rsp;                                                        \
+};                                                                      \
+                                                                        \
+/* Shared ring page */                                                  \
+struct __name##_sring {                                                 \
+    RING_IDX req_prod, req_event;                                       \
+    RING_IDX rsp_prod, rsp_event;                                       \
+    uint8_t  pad[48];                                                   \
+    union __name##_sring_entry ring[1]; /* variable-length */           \
+};                                                                      \
+                                                                        \
+/* "Front" end's private variables */                                   \
+struct __name##_front_ring {                                            \
+    RING_IDX req_prod_pvt;                                              \
+    RING_IDX rsp_cons;                                                  \
+    unsigned int nr_ents;                                               \
+    struct __name##_sring *sring;                                       \
+};                                                                      \
+                                                                        \
+/* "Back" end's private variables */                                    \
+struct __name##_back_ring {                                             \
+    RING_IDX rsp_prod_pvt;                                              \
+    RING_IDX req_cons;                                                  \
+    unsigned int nr_ents;                                               \
+    struct __name##_sring *sring;                                       \
+};
+
+/*
+ * Macros for manipulating rings.
+ *
+ * FRONT_RING_whatever works on the "front end" of a ring: here
+ * requests are pushed on to the ring and responses taken off it.
+ *
+ * BACK_RING_whatever works on the "back end" of a ring: here
+ * requests are taken off the ring and responses put on.
+ *
+ * N.B. these macros do NO INTERLOCKS OR FLOW CONTROL.
+ * This is OK in 1-for-1 request-response situations where the
+ * requestor (front end) never has more than RING_SIZE()-1
+ * outstanding requests.
+ */
+
+/* Initialising empty rings */
+#define SHARED_RING_INIT(_s) do {                                       \
+    (_s)->req_prod  = (_s)->rsp_prod  = 0;                              \
+    (_s)->req_event = (_s)->rsp_event = 1;                              \
+    memset((_s)->pad, 0, sizeof((_s)->pad));                            \
+} while(0)
+
+#define FRONT_RING_INIT(_r, _s, __size) do {                            \
+    (_r)->req_prod_pvt = 0;                                             \
+    (_r)->rsp_cons = 0;                                                 \
+    (_r)->nr_ents = __RING_SIZE(_s, __size);                            \
+    (_r)->sring = (_s);                                                 \
+} while (0)
+
+#define BACK_RING_INIT(_r, _s, __size) do {                             \
+    (_r)->rsp_prod_pvt = 0;                                             \
+    (_r)->req_cons = 0;                                                 \
+    (_r)->nr_ents = __RING_SIZE(_s, __size);                            \
+    (_r)->sring = (_s);                                                 \
+} while (0)
+
+/* Initialize to existing shared indexes -- for recovery */
+#define FRONT_RING_ATTACH(_r, _s, __size) do {                          \
+    (_r)->sring = (_s);                                                 \
+    (_r)->req_prod_pvt = (_s)->req_prod;                                \
+    (_r)->rsp_cons = (_s)->rsp_prod;                                    \
+    (_r)->nr_ents = __RING_SIZE(_s, __size);                            \
+} while (0)
+
+#define BACK_RING_ATTACH(_r, _s, __size) do {                           \
+    (_r)->sring = (_s);                                                 \
+    (_r)->rsp_prod_pvt = (_s)->rsp_prod;                                \
+    (_r)->req_cons = (_s)->req_prod;                                    \
+    (_r)->nr_ents = __RING_SIZE(_s, __size);                            \
+} while (0)
+
+/* How big is this ring? */
+#define RING_SIZE(_r)                                                   \
+    ((_r)->nr_ents)
+
+/* Number of free requests (for use on front side only). */
+#define RING_FREE_REQUESTS(_r)						\
+    (RING_SIZE(_r) - ((_r)->req_prod_pvt - (_r)->rsp_cons))
+
+/* Test if there is an empty slot available on the front ring.
+ * (This is only meaningful from the front. )
+ */
+#define RING_FULL(_r)                                                   \
+    (RING_FREE_REQUESTS(_r) == 0)
+
+/* Test if there are outstanding messages to be processed on a ring. */
+#define RING_HAS_UNCONSUMED_RESPONSES(_r)                               \
+    ((_r)->sring->rsp_prod - (_r)->rsp_cons)
+
+#define RING_HAS_UNCONSUMED_REQUESTS(_r)                                \
+    ({									\
+	unsigned int req = (_r)->sring->req_prod - (_r)->req_cons;	\
+	unsigned int rsp = RING_SIZE(_r) -				\
+			   ((_r)->req_cons - (_r)->rsp_prod_pvt);	\
+	req < rsp ? req : rsp;						\
+    })
+
+/* Direct access to individual ring elements, by index. */
+#define RING_GET_REQUEST(_r, _idx)                                      \
+    (&((_r)->sring->ring[((_idx) & (RING_SIZE(_r) - 1))].req))
+
+#define RING_GET_RESPONSE(_r, _idx)                                     \
+    (&((_r)->sring->ring[((_idx) & (RING_SIZE(_r) - 1))].rsp))
+
+/* Loop termination condition: Would the specified index overflow the ring? */
+#define RING_REQUEST_CONS_OVERFLOW(_r, _cons)                           \
+    (((_cons) - (_r)->rsp_prod_pvt) >= RING_SIZE(_r))
+
+#define RING_PUSH_REQUESTS(_r) do {                                     \
+    wmb(); /* back sees requests /before/ updated producer index */     \
+    (_r)->sring->req_prod = (_r)->req_prod_pvt;                         \
+} while (0)
+
+#define RING_PUSH_RESPONSES(_r) do {                                    \
+    wmb(); /* front sees responses /before/ updated producer index */   \
+    (_r)->sring->rsp_prod = (_r)->rsp_prod_pvt;                         \
+} while (0)
+
+/*
+ * Notification hold-off (req_event and rsp_event):
+ *
+ * When queueing requests or responses on a shared ring, it may not always be
+ * necessary to notify the remote end. For example, if requests are in flight
+ * in a backend, the front may be able to queue further requests without
+ * notifying the back (if the back checks for new requests when it queues
+ * responses).
+ *
+ * When enqueuing requests or responses:
+ *
+ *  Use RING_PUSH_{REQUESTS,RESPONSES}_AND_CHECK_NOTIFY(). The second argument
+ *  is a boolean return value. True indicates that the receiver requires an
+ *  asynchronous notification.
+ *
+ * After dequeuing requests or responses (before sleeping the connection):
+ *
+ *  Use RING_FINAL_CHECK_FOR_REQUESTS() or RING_FINAL_CHECK_FOR_RESPONSES().
+ *  The second argument is a boolean return value. True indicates that there
+ *  are pending messages on the ring (i.e., the connection should not be put
+ *  to sleep).
+ *
+ *  These macros will set the req_event/rsp_event field to trigger a
+ *  notification on the very next message that is enqueued. If you want to
+ *  create batches of work (i.e., only receive a notification after several
+ *  messages have been enqueued) then you will need to create a customised
+ *  version of the FINAL_CHECK macro in your own code, which sets the event
+ *  field appropriately.
+ */
+
+#define RING_PUSH_REQUESTS_AND_CHECK_NOTIFY(_r, _notify) do {           \
+    RING_IDX __old = (_r)->sring->req_prod;                             \
+    RING_IDX __new = (_r)->req_prod_pvt;                                \
+    wmb(); /* back sees requests /before/ updated producer index */     \
+    (_r)->sring->req_prod = __new;                                      \
+    mb(); /* back sees new requests /before/ we check req_event */      \
+    (_notify) = ((RING_IDX)(__new - (_r)->sring->req_event) <           \
+                 (RING_IDX)(__new - __old));                            \
+} while (0)
+
+#define RING_PUSH_RESPONSES_AND_CHECK_NOTIFY(_r, _notify) do {          \
+    RING_IDX __old = (_r)->sring->rsp_prod;                             \
+    RING_IDX __new = (_r)->rsp_prod_pvt;                                \
+    wmb(); /* front sees responses /before/ updated producer index */   \
+    (_r)->sring->rsp_prod = __new;                                      \
+    mb(); /* front sees new responses /before/ we check rsp_event */    \
+    (_notify) = ((RING_IDX)(__new - (_r)->sring->rsp_event) <           \
+                 (RING_IDX)(__new - __old));                            \
+} while (0)
+
+#define RING_FINAL_CHECK_FOR_REQUESTS(_r, _work_to_do) do {             \
+    (_work_to_do) = RING_HAS_UNCONSUMED_REQUESTS(_r);                   \
+    if (_work_to_do) break;                                             \
+    (_r)->sring->req_event = (_r)->req_cons + 1;                        \
+    mb();                                                               \
+    (_work_to_do) = RING_HAS_UNCONSUMED_REQUESTS(_r);                   \
+} while (0)
+
+#define RING_FINAL_CHECK_FOR_RESPONSES(_r, _work_to_do) do {            \
+    (_work_to_do) = RING_HAS_UNCONSUMED_RESPONSES(_r);                  \
+    if (_work_to_do) break;                                             \
+    (_r)->sring->rsp_event = (_r)->rsp_cons + 1;                        \
+    mb();                                                               \
+    (_work_to_do) = RING_HAS_UNCONSUMED_RESPONSES(_r);                  \
+} while (0)
+
+#endif /* __XEN_PUBLIC_IO_RING_H__ */
diff -puN /dev/null include/xen/interface/io/xenbus.h
--- /dev/null
+++ a/include/xen/interface/io/xenbus.h
@@ -0,0 +1,42 @@
+/*****************************************************************************
+ * xenbus.h
+ *
+ * Xenbus protocol details.
+ *
+ * Copyright (C) 2005 XenSource Ltd.
+ */
+
+#ifndef _XEN_PUBLIC_IO_XENBUS_H
+#define _XEN_PUBLIC_IO_XENBUS_H
+
+/* The state of either end of the Xenbus, i.e. the current communication
+   status of initialisation across the bus.  States here imply nothing about
+   the state of the connection between the driver and the kernel's device
+   layers.  */
+enum xenbus_state
+{
+  XenbusStateUnknown      = 0,
+  XenbusStateInitialising = 1,
+  XenbusStateInitWait     = 2,  /* Finished early initialisation, but waiting
+                                   for information from the peer or hotplug
+				   scripts. */
+  XenbusStateInitialised  = 3,  /* Initialised and waiting for a connection
+				   from the peer. */
+  XenbusStateConnected    = 4,
+  XenbusStateClosing      = 5,  /* The device is being closed due to an error
+				   or an unplug event. */
+  XenbusStateClosed       = 6
+
+};
+
+#endif /* _XEN_PUBLIC_IO_XENBUS_H */
+
+/*
+ * Local variables:
+ *  c-file-style: "linux"
+ *  indent-tabs-mode: t
+ *  c-indent-level: 8
+ *  c-basic-offset: 8
+ *  tab-width: 8
+ * End:
+ */
diff -puN /dev/null include/xen/interface/io/xs_wire.h
--- /dev/null
+++ a/include/xen/interface/io/xs_wire.h
@@ -0,0 +1,87 @@
+/*
+ * Details of the "wire" protocol between Xen Store Daemon and client
+ * library or guest kernel.
+ * Copyright (C) 2005 Rusty Russell IBM Corporation
+ */
+
+#ifndef _XS_WIRE_H
+#define _XS_WIRE_H
+
+enum xsd_sockmsg_type
+{
+    XS_DEBUG,
+    XS_DIRECTORY,
+    XS_READ,
+    XS_GET_PERMS,
+    XS_WATCH,
+    XS_UNWATCH,
+    XS_TRANSACTION_START,
+    XS_TRANSACTION_END,
+    XS_INTRODUCE,
+    XS_RELEASE,
+    XS_GET_DOMAIN_PATH,
+    XS_WRITE,
+    XS_MKDIR,
+    XS_RM,
+    XS_SET_PERMS,
+    XS_WATCH_EVENT,
+    XS_ERROR,
+    XS_IS_DOMAIN_INTRODUCED
+};
+
+#define XS_WRITE_NONE "NONE"
+#define XS_WRITE_CREATE "CREATE"
+#define XS_WRITE_CREATE_EXCL "CREATE|EXCL"
+
+/* We hand errors as strings, for portability. */
+struct xsd_errors
+{
+    int errnum;
+    const char *errstring;
+};
+#define XSD_ERROR(x) { x, #x }
+static struct xsd_errors xsd_errors[] __attribute__((unused)) = {
+    XSD_ERROR(EINVAL),
+    XSD_ERROR(EACCES),
+    XSD_ERROR(EEXIST),
+    XSD_ERROR(EISDIR),
+    XSD_ERROR(ENOENT),
+    XSD_ERROR(ENOMEM),
+    XSD_ERROR(ENOSPC),
+    XSD_ERROR(EIO),
+    XSD_ERROR(ENOTEMPTY),
+    XSD_ERROR(ENOSYS),
+    XSD_ERROR(EROFS),
+    XSD_ERROR(EBUSY),
+    XSD_ERROR(EAGAIN),
+    XSD_ERROR(EISCONN)
+};
+
+struct xsd_sockmsg
+{
+    uint32_t type;  /* XS_??? */
+    uint32_t req_id;/* Request identifier, echoed in daemon's response.  */
+    uint32_t tx_id; /* Transaction id (0 if not related to a transaction). */
+    uint32_t len;   /* Length of data following this. */
+
+    /* Generally followed by nul-terminated string(s). */
+};
+
+enum xs_watch_type
+{
+    XS_WATCH_PATH = 0,
+    XS_WATCH_TOKEN
+};
+
+/* Inter-domain shared memory communications. */
+#define XENSTORE_RING_SIZE 1024
+typedef uint32_t XENSTORE_RING_IDX;
+#define MASK_XENSTORE_IDX(idx) ((idx) & (XENSTORE_RING_SIZE-1))
+struct xenstore_domain_interface {
+    char req[XENSTORE_RING_SIZE]; /* Requests to xenstore daemon. */
+    char rsp[XENSTORE_RING_SIZE]; /* Replies and async watch events. */
+    XENSTORE_RING_IDX req_cons, req_prod;
+    XENSTORE_RING_IDX rsp_cons, rsp_prod;
+};
+
+#endif /* _XS_WIRE_H */
diff -puN /dev/null include/xen/interface/memory.h
--- /dev/null
+++ a/include/xen/interface/memory.h
@@ -0,0 +1,145 @@
+/******************************************************************************
+ * memory.h
+ *
+ * Memory reservation and information.
+ *
+ * Copyright (c) 2005, Keir Fraser <keir@xensource.com>
+ */
+
+#ifndef __XEN_PUBLIC_MEMORY_H__
+#define __XEN_PUBLIC_MEMORY_H__
+
+/*
+ * Increase or decrease the specified domain's memory reservation. Returns a
+ * -ve errcode on failure, or the # extents successfully allocated or freed.
+ * arg == addr of struct xen_memory_reservation.
+ */
+#define XENMEM_increase_reservation 0
+#define XENMEM_decrease_reservation 1
+#define XENMEM_populate_physmap     6
+struct xen_memory_reservation {
+
+    /*
+     * XENMEM_increase_reservation:
+     *   OUT: MFN (*not* GMFN) bases of extents that were allocated
+     * XENMEM_decrease_reservation:
+     *   IN:  GMFN bases of extents to free
+     * XENMEM_populate_physmap:
+     *   IN:  GPFN bases of extents to populate with memory
+     *   OUT: GMFN bases of extents that were allocated
+     *   (NB. This command also updates the mach_to_phys translation table)
+     */
+    GUEST_HANDLE(ulong) extent_start;
+
+    /* Number of extents, and size/alignment of each (2^extent_order pages). */
+    unsigned long  nr_extents;
+    unsigned int   extent_order;
+
+    /*
+     * Maximum # bits addressable by the user of the allocated region (e.g.,
+     * I/O devices often have a 32-bit limitation even in 64-bit systems). If
+     * zero then the user has no addressing restriction.
+     * This field is not used by XENMEM_decrease_reservation.
+     */
+    unsigned int   address_bits;
+
+    /*
+     * Domain whose reservation is being changed.
+     * Unprivileged domains can specify only DOMID_SELF.
+     */
+    domid_t        domid;
+
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_memory_reservation);
+
+/*
+ * Returns the maximum machine frame number of mapped RAM in this system.
+ * This command always succeeds (it never returns an error code).
+ * arg == NULL.
+ */
+#define XENMEM_maximum_ram_page     2
+
+/*
+ * Returns the current or maximum memory reservation, in pages, of the
+ * specified domain (may be DOMID_SELF). Returns -ve errcode on failure.
+ * arg == addr of domid_t.
+ */
+#define XENMEM_current_reservation  3
+#define XENMEM_maximum_reservation  4
+
+/*
+ * Returns a list of MFN bases of 2MB extents comprising the machine_to_phys
+ * mapping table. Architectures which do not have a m2p table do not implement
+ * this command.
+ * arg == addr of xen_machphys_mfn_list_t.
+ */
+#define XENMEM_machphys_mfn_list    5
+struct xen_machphys_mfn_list {
+    /*
+     * Size of the 'extent_start' array. Fewer entries will be filled if the
+     * machphys table is smaller than max_extents * 2MB.
+     */
+    unsigned int max_extents;
+
+    /*
+     * Pointer to buffer to fill with list of extent starts. If there are
+     * any large discontiguities in the machine address space, 2MB gaps in
+     * the machphys table will be represented by an MFN base of zero.
+     */
+    GUEST_HANDLE(ulong) extent_start;
+
+    /*
+     * Number of extents written to the above array. This will be smaller
+     * than 'max_extents' if the machphys table is smaller than max_e * 2MB.
+     */
+    unsigned int nr_extents;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_machphys_mfn_list);
+
+/*
+ * Sets the GPFN at which a particular page appears in the specified guest's
+ * pseudophysical address space.
+ * arg == addr of xen_add_to_physmap_t.
+ */
+#define XENMEM_add_to_physmap      7
+struct xen_add_to_physmap {
+    /* Which domain to change the mapping for. */
+    domid_t domid;
+
+    /* Source mapping space. */
+#define XENMAPSPACE_shared_info 0 /* shared info page */
+#define XENMAPSPACE_grant_table 1 /* grant table page */
+    unsigned int space;
+
+    /* Index into source mapping space. */
+    unsigned long idx;
+
+    /* GPFN where the source mapping page should appear. */
+    unsigned long gpfn;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_add_to_physmap);
+
+/*
+ * Translates a list of domain-specific GPFNs into MFNs. Returns a -ve error
+ * code on failure. This call only works for auto-translated guests.
+ */
+#define XENMEM_translate_gpfn_list  8
+struct xen_translate_gpfn_list {
+    /* Which domain to translate for? */
+    domid_t domid;
+
+    /* Length of list. */
+    unsigned long nr_gpfns;
+
+    /* List of GPFNs to translate. */
+    GUEST_HANDLE(ulong) gpfn_list;
+
+    /*
+     * Output list to contain MFN translations. May be the same as the input
+     * list (in which case each input GPFN is overwritten with the output MFN).
+     */
+    GUEST_HANDLE(ulong) mfn_list;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_translate_gpfn_list);
+
+#endif /* __XEN_PUBLIC_MEMORY_H__ */
diff -puN /dev/null include/xen/interface/physdev.h
--- /dev/null
+++ a/include/xen/interface/physdev.h
@@ -0,0 +1,61 @@
+
+#ifndef __XEN_PUBLIC_PHYSDEV_H__
+#define __XEN_PUBLIC_PHYSDEV_H__
+
+/* Commands to HYPERVISOR_physdev_op() */
+#define PHYSDEVOP_IRQ_UNMASK_NOTIFY     4
+#define PHYSDEVOP_IRQ_STATUS_QUERY      5
+#define PHYSDEVOP_SET_IOPL              6
+#define PHYSDEVOP_SET_IOBITMAP          7
+#define PHYSDEVOP_APIC_READ             8
+#define PHYSDEVOP_APIC_WRITE            9
+#define PHYSDEVOP_ASSIGN_VECTOR         10
+
+struct physdevop_irq_status_query {
+    /* IN */
+    uint32_t irq;
+    /* OUT */
+/* Need to call PHYSDEVOP_IRQ_UNMASK_NOTIFY when the IRQ has been serviced? */
+#define PHYSDEVOP_IRQ_NEEDS_UNMASK_NOTIFY (1<<0)
+    uint32_t flags;
+};
+
+struct physdevop_set_iopl {
+    /* IN */
+    uint32_t iopl;
+};
+
+struct physdevop_set_iobitmap {
+    /* IN */
+    uint8_t *bitmap;
+    uint32_t nr_ports;
+};
+
+struct physdevop_apic {
+    /* IN */
+    unsigned long apic_physbase;
+    uint32_t reg;
+    /* IN or OUT */
+    uint32_t value;
+};
+
+struct physdevop_irq {
+    /* IN */
+    uint32_t irq;
+    /* OUT */
+    uint32_t vector;
+};
+
+struct physdev_op {
+    uint32_t cmd;
+    union {
+        struct physdevop_irq_status_query      irq_status_query;
+        struct physdevop_set_iopl              set_iopl;
+        struct physdevop_set_iobitmap          set_iobitmap;
+        struct physdevop_apic                  apic_op;
+        struct physdevop_irq                   irq_op;
+    } u;
+};
+DEFINE_GUEST_HANDLE_STRUCT(physdev_op);
+
+#endif /* __XEN_PUBLIC_PHYSDEV_H__ */
diff -puN /dev/null include/xen/interface/sched.h
--- /dev/null
+++ a/include/xen/interface/sched.h
@@ -0,0 +1,77 @@
+/******************************************************************************
+ * sched.h
+ *
+ * Scheduler state interactions
+ *
+ * Copyright (c) 2005, Keir Fraser <keir@xensource.com>
+ */
+
+#ifndef __XEN_PUBLIC_SCHED_H__
+#define __XEN_PUBLIC_SCHED_H__
+
+#include "event_channel.h"
+
+/*
+ * The prototype for this hypercall is:
+ *  long sched_op_new(int cmd, void *arg)
+ * @cmd == SCHEDOP_??? (scheduler operation).
+ * @arg == Operation-specific extra argument(s), as described below.
+ *
+ * **NOTE**:
+ * Versions of Xen prior to 3.0.2 provide only the following legacy version
+ * of this hypercall, supporting only the commands yield, block and shutdown:
+ *  long sched_op(int cmd, unsigned long arg)
+ * @cmd == SCHEDOP_??? (scheduler operation).
+ * @arg == 0               (SCHEDOP_yield and SCHEDOP_block)
+ *      == SHUTDOWN_* code (SCHEDOP_shutdown)
+ */
+
+/*
+ * Voluntarily yield the CPU.
+ * @arg == NULL.
+ */
+#define SCHEDOP_yield       0
+
+/*
+ * Block execution of this VCPU until an event is received for processing.
+ * If called with event upcalls masked, this operation will atomically
+ * reenable event delivery and check for pending events before blocking the
+ * VCPU. This avoids a "wakeup waiting" race.
+ * @arg == NULL.
+ */
+#define SCHEDOP_block       1
+
+/*
+ * Halt execution of this domain (all VCPUs) and notify the system controller.
+ * @arg == pointer to sched_shutdown structure.
+ */
+#define SCHEDOP_shutdown    2
+struct sched_shutdown {
+    unsigned int reason; /* SHUTDOWN_* */
+};
+DEFINE_GUEST_HANDLE_STRUCT(sched_shutdown);
+
+/*
+ * Poll a set of event-channel ports. Return when one or more are pending. An
+ * optional timeout may be specified.
+ * @arg == pointer to sched_poll structure.
+ */
+#define SCHEDOP_poll        3
+struct sched_poll {
+    GUEST_HANDLE(evtchn_port_t) ports;
+    unsigned int nr_ports;
+    uint64_t timeout;
+};
+DEFINE_GUEST_HANDLE_STRUCT(sched_poll);
+
+/*
+ * Reason codes for SCHEDOP_shutdown. These may be interpreted by control
+ * software to determine the appropriate action. For the most part, Xen does
+ * not care about the shutdown code.
+ */
+#define SHUTDOWN_poweroff   0  /* Domain exited normally. Clean up and kill. */
+#define SHUTDOWN_reboot     1  /* Clean up, kill, and then restart.          */
+#define SHUTDOWN_suspend    2  /* Clean up, save suspend info, kill.         */
+#define SHUTDOWN_crash      3  /* Tell controller we've crashed.             */
+
+#endif /* __XEN_PUBLIC_SCHED_H__ */
diff -puN /dev/null include/xen/interface/vcpu.h
--- /dev/null
+++ a/include/xen/interface/vcpu.h
@@ -0,0 +1,109 @@
+/******************************************************************************
+ * vcpu.h
+ *
+ * VCPU initialisation, query, and hotplug.
+ *
+ * Copyright (c) 2005, Keir Fraser <keir@xensource.com>
+ */
+
+#ifndef __XEN_PUBLIC_VCPU_H__
+#define __XEN_PUBLIC_VCPU_H__
+
+/*
+ * Prototype for this hypercall is:
+ *  int vcpu_op(int cmd, int vcpuid, void *extra_args)
+ * @cmd        == VCPUOP_??? (VCPU operation).
+ * @vcpuid     == VCPU to operate on.
+ * @extra_args == Operation-specific extra arguments (NULL if none).
+ */
+
+/*
+ * Initialise a VCPU. Each VCPU can be initialised only once. A
+ * newly-initialised VCPU will not run until it is brought up by VCPUOP_up.
+ *
+ * @extra_arg == pointer to vcpu_guest_context structure containing initial
+ *               state for the VCPU.
+ */
+#define VCPUOP_initialise           0
+
+/*
+ * Bring up a VCPU. This makes the VCPU runnable. This operation will fail
+ * if the VCPU has not been initialised (VCPUOP_initialise).
+ */
+#define VCPUOP_up                   1
+
+/*
+ * Bring down a VCPU (i.e., make it non-runnable).
+ * There are a few caveats that callers should observe:
+ *  1. This operation may return, and VCPU_is_up may return false, before the
+ *     VCPU stops running (i.e., the command is asynchronous). It is a good
+ *     idea to ensure that the VCPU has entered a non-critical loop before
+ *     bringing it down. Alternatively, this operation is guaranteed
+ *     synchronous if invoked by the VCPU itself.
+ *  2. After a VCPU is initialised, there is currently no way to drop all its
+ *     references to domain memory. Even a VCPU that is down still holds
+ *     memory references via its pagetable base pointer and GDT. It is good
+ *     practise to move a VCPU onto an 'idle' or default page table, LDT and
+ *     GDT before bringing it down.
+ */
+#define VCPUOP_down                 2
+
+/* Returns 1 if the given VCPU is up. */
+#define VCPUOP_is_up                3
+
+/*
+ * Return information about the state and running time of a VCPU.
+ * @extra_arg == pointer to vcpu_runstate_info structure.
+ */
+#define VCPUOP_get_runstate_info    4
+struct vcpu_runstate_info {
+    /* VCPU's current state (RUNSTATE_*). */
+    int      state;
+    /* When was current state entered (system time, ns)? */
+    uint64_t state_entry_time;
+    /*
+     * Time spent in each RUNSTATE_* (ns). The sum of these times is
+     * guaranteed not to drift from system time.
+     */
+    uint64_t time[4];
+};
+
+/* VCPU is currently running on a physical CPU. */
+#define RUNSTATE_running  0
+
+/* VCPU is runnable, but not currently scheduled on any physical CPU. */
+#define RUNSTATE_runnable 1
+
+/* VCPU is blocked (a.k.a. idle). It is therefore not runnable. */
+#define RUNSTATE_blocked  2
+
+/*
+ * VCPU is not runnable, but it is not blocked.
+ * This is a 'catch all' state for things like hotplug and pauses by the
+ * system administrator (or for critical sections in the hypervisor).
+ * RUNSTATE_blocked dominates this state (it is the preferred state).
+ */
+#define RUNSTATE_offline  3
+
+/*
+ * Register a shared memory area from which the guest may obtain its own
+ * runstate information without needing to execute a hypercall.
+ * Notes:
+ *  1. The registered address may be virtual or physical, depending on the
+ *     platform. The virtual address should be registered on x86 systems.
+ *  2. Only one shared area may be registered per VCPU. The shared area is
+ *     updated by the hypervisor each time the VCPU is scheduled. Thus
+ *     runstate.state will always be RUNSTATE_running and
+ *     runstate.state_entry_time will indicate the system time at which the
+ *     VCPU was last scheduled to run.
+ * @extra_arg == pointer to vcpu_register_runstate_memory_area structure.
+ */
+#define VCPUOP_register_runstate_memory_area 5
+struct vcpu_register_runstate_memory_area {
+    union {
+        struct vcpu_runstate_info *v;
+        uint64_t p;
+    } addr;
+};
+
+#endif /* __XEN_PUBLIC_VCPU_H__ */
diff -puN /dev/null include/xen/interface/version.h
--- /dev/null
+++ a/include/xen/interface/version.h
@@ -0,0 +1,60 @@
+/******************************************************************************
+ * version.h
+ *
+ * Xen version, type, and compile information.
+ *
+ * Copyright (c) 2005, Nguyen Anh Quynh <aquynh@gmail.com>
+ * Copyright (c) 2005, Keir Fraser <keir@xensource.com>
+ */
+
+#ifndef __XEN_PUBLIC_VERSION_H__
+#define __XEN_PUBLIC_VERSION_H__
+
+/* NB. All ops return zero on success, except XENVER_version. */
+
+/* arg == NULL; returns major:minor (16:16). */
+#define XENVER_version      0
+
+/* arg == xen_extraversion_t. */
+#define XENVER_extraversion 1
+struct xen_extraversion {
+    char extraversion[16];
+};
+#define XEN_EXTRAVERSION_LEN (sizeof(struct xen_extraversion))
+
+/* arg == xen_compile_info_t. */
+#define XENVER_compile_info 2
+struct xen_compile_info {
+    char compiler[64];
+    char compile_by[16];
+    char compile_domain[32];
+    char compile_date[32];
+};
+
+#define XENVER_capabilities 3
+struct xen_capabilities_info {
+    char info[1024];
+};
+#define XEN_CAPABILITIES_INFO_LEN (sizeof(struct xen_capabilities_info))
+
+#define XENVER_changeset 4
+struct xen_changeset_info {
+    char info[64];
+};
+#define XEN_CHANGESET_INFO_LEN (sizeof(struct xen_changeset_info))
+
+#define XENVER_platform_parameters 5
+struct xen_platform_parameters {
+    unsigned long virt_start;
+};
+
+#define XENVER_get_features 6
+struct xen_feature_info {
+    unsigned int submap_idx;    /* IN: which 32-bit submap to return */
+    uint32_t     submap;        /* OUT: 32-bit submap */
+};
+
+/* Declares the features reported by XENVER_get_features. */
+#include "features.h"
+
+#endif /* __XEN_PUBLIC_VERSION_H__ */
diff -puN /dev/null include/xen/interface/xen.h
--- /dev/null
+++ a/include/xen/interface/xen.h
@@ -0,0 +1,445 @@
+/******************************************************************************
+ * xen.h
+ *
+ * Guest OS interface to Xen.
+ *
+ * Copyright (c) 2004, K A Fraser
+ */
+
+#ifndef __XEN_PUBLIC_XEN_H__
+#define __XEN_PUBLIC_XEN_H__
+
+#include <asm/xen/interface.h>
+
+/*
+ * XEN "SYSTEM CALLS" (a.k.a. HYPERCALLS).
+ */
+
+/*
+ * x86_32: EAX = vector; EBX, ECX, EDX, ESI, EDI = args 1, 2, 3, 4, 5.
+ *         EAX = return value
+ *         (argument registers may be clobbered on return)
+ * x86_64: RAX = vector; RDI, RSI, RDX, R10, R8, R9 = args 1, 2, 3, 4, 5, 6.
+ *         RAX = return value
+ *         (argument registers not clobbered on return; RCX, R11 are)
+ */
+#define __HYPERVISOR_set_trap_table        0
+#define __HYPERVISOR_mmu_update            1
+#define __HYPERVISOR_set_gdt               2
+#define __HYPERVISOR_stack_switch          3
+#define __HYPERVISOR_set_callbacks         4
+#define __HYPERVISOR_fpu_taskswitch        5
+#define __HYPERVISOR_sched_op              6
+#define __HYPERVISOR_dom0_op               7
+#define __HYPERVISOR_set_debugreg          8
+#define __HYPERVISOR_get_debugreg          9
+#define __HYPERVISOR_update_descriptor    10
+#define __HYPERVISOR_memory_op            12
+#define __HYPERVISOR_multicall            13
+#define __HYPERVISOR_update_va_mapping    14
+#define __HYPERVISOR_set_timer_op         15
+#define __HYPERVISOR_event_channel_op_compat 16
+#define __HYPERVISOR_xen_version          17
+#define __HYPERVISOR_console_io           18
+#define __HYPERVISOR_physdev_op_compat    19
+#define __HYPERVISOR_grant_table_op       20
+#define __HYPERVISOR_vm_assist            21
+#define __HYPERVISOR_update_va_mapping_otherdomain 22
+#define __HYPERVISOR_iret                 23 /* x86 only */
+#define __HYPERVISOR_vcpu_op              24
+#define __HYPERVISOR_set_segment_base     25 /* x86/64 only */
+#define __HYPERVISOR_mmuext_op            26
+#define __HYPERVISOR_acm_op               27
+#define __HYPERVISOR_nmi_op               28
+#define __HYPERVISOR_sched_op_new         29
+#define __HYPERVISOR_callback_op          30
+#define __HYPERVISOR_xenoprof_op          31
+#define __HYPERVISOR_event_channel_op     32
+#define __HYPERVISOR_physdev_op           33
+#define __HYPERVISOR_hvm_op               34
+
+/*
+ * VIRTUAL INTERRUPTS
+ *
+ * Virtual interrupts that a guest OS may receive from Xen.
+ */
+#define VIRQ_TIMER      0  /* Timebase update, and/or requested timeout.  */
+#define VIRQ_DEBUG      1  /* Request guest to dump debug info.           */
+#define VIRQ_CONSOLE    2  /* (DOM0) Bytes received on emergency console. */
+#define VIRQ_DOM_EXC    3  /* (DOM0) Exceptional event for some domain.   */
+#define VIRQ_DEBUGGER   6  /* (DOM0) A domain has paused for debugging.   */
+#define NR_VIRQS        8
+
+/*
+ * MMU-UPDATE REQUESTS
+ *
+ * HYPERVISOR_mmu_update() accepts a list of (ptr, val) pairs.
+ * A foreigndom (FD) can be specified (or DOMID_SELF for none).
+ * Where the FD has some effect, it is described below.
+ * ptr[1:0] specifies the appropriate MMU_* command.
+ *
+ * ptr[1:0] == MMU_NORMAL_PT_UPDATE:
+ * Updates an entry in a page table. If updating an L1 table, and the new
+ * table entry is valid/present, the mapped frame must belong to the FD, if
+ * an FD has been specified. If attempting to map an I/O page then the
+ * caller assumes the privilege of the FD.
+ * FD == DOMID_IO: Permit /only/ I/O mappings, at the priv level of the caller.
+ * FD == DOMID_XEN: Map restricted areas of Xen's heap space.
+ * ptr[:2]  -- Machine address of the page-table entry to modify.
+ * val      -- Value to write.
+ *
+ * ptr[1:0] == MMU_MACHPHYS_UPDATE:
+ * Updates an entry in the machine->pseudo-physical mapping table.
+ * ptr[:2]  -- Machine address within the frame whose mapping to modify.
+ *             The frame must belong to the FD, if one is specified.
+ * val      -- Value to write into the mapping entry.
+ */
+#define MMU_NORMAL_PT_UPDATE     0 /* checked '*ptr = val'. ptr is MA.       */
+#define MMU_MACHPHYS_UPDATE      1 /* ptr = MA of frame to modify entry for  */
+
+/*
+ * MMU EXTENDED OPERATIONS
+ *
+ * HYPERVISOR_mmuext_op() accepts a list of mmuext_op structures.
+ * A foreigndom (FD) can be specified (or DOMID_SELF for none).
+ * Where the FD has some effect, it is described below.
+ *
+ * cmd: MMUEXT_(UN)PIN_*_TABLE
+ * mfn: Machine frame number to be (un)pinned as a p.t. page.
+ *      The frame must belong to the FD, if one is specified.
+ *
+ * cmd: MMUEXT_NEW_BASEPTR
+ * mfn: Machine frame number of new page-table base to install in MMU.
+ *
+ * cmd: MMUEXT_NEW_USER_BASEPTR [x86/64 only]
+ * mfn: Machine frame number of new page-table base to install in MMU
+ *      when in user space.
+ *
+ * cmd: MMUEXT_TLB_FLUSH_LOCAL
+ * No additional arguments. Flushes local TLB.
+ *
+ * cmd: MMUEXT_INVLPG_LOCAL
+ * linear_addr: Linear address to be flushed from the local TLB.
+ *
+ * cmd: MMUEXT_TLB_FLUSH_MULTI
+ * vcpumask: Pointer to bitmap of VCPUs to be flushed.
+ *
+ * cmd: MMUEXT_INVLPG_MULTI
+ * linear_addr: Linear address to be flushed.
+ * vcpumask: Pointer to bitmap of VCPUs to be flushed.
+ *
+ * cmd: MMUEXT_TLB_FLUSH_ALL
+ * No additional arguments. Flushes all VCPUs' TLBs.
+ *
+ * cmd: MMUEXT_INVLPG_ALL
+ * linear_addr: Linear address to be flushed from all VCPUs' TLBs.
+ *
+ * cmd: MMUEXT_FLUSH_CACHE
+ * No additional arguments. Writes back and flushes cache contents.
+ *
+ * cmd: MMUEXT_SET_LDT
+ * linear_addr: Linear address of LDT base (NB. must be page-aligned).
+ * nr_ents: Number of entries in LDT.
+ */
+#define MMUEXT_PIN_L1_TABLE      0
+#define MMUEXT_PIN_L2_TABLE      1
+#define MMUEXT_PIN_L3_TABLE      2
+#define MMUEXT_PIN_L4_TABLE      3
+#define MMUEXT_UNPIN_TABLE       4
+#define MMUEXT_NEW_BASEPTR       5
+#define MMUEXT_TLB_FLUSH_LOCAL   6
+#define MMUEXT_INVLPG_LOCAL      7
+#define MMUEXT_TLB_FLUSH_MULTI   8
+#define MMUEXT_INVLPG_MULTI      9
+#define MMUEXT_TLB_FLUSH_ALL    10
+#define MMUEXT_INVLPG_ALL       11
+#define MMUEXT_FLUSH_CACHE      12
+#define MMUEXT_SET_LDT          13
+#define MMUEXT_NEW_USER_BASEPTR 15
+
+#ifndef __ASSEMBLY__
+struct mmuext_op {
+    unsigned int cmd;
+    union {
+        /* [UN]PIN_TABLE, NEW_BASEPTR, NEW_USER_BASEPTR */
+        unsigned long mfn;
+        /* INVLPG_LOCAL, INVLPG_ALL, SET_LDT */
+        unsigned long linear_addr;
+    } arg1;
+    union {
+        /* SET_LDT */
+        unsigned int nr_ents;
+        /* TLB_FLUSH_MULTI, INVLPG_MULTI */
+        void *vcpumask;
+    } arg2;
+};
+DEFINE_GUEST_HANDLE_STRUCT(mmuext_op);
+#endif
+
+/* These are passed as 'flags' to update_va_mapping. They can be ORed. */
+/* When specifying UVMF_MULTI, also OR in a pointer to a CPU bitmap.   */
+/* UVMF_LOCAL is merely UVMF_MULTI with a NULL bitmap pointer.         */
+#define UVMF_NONE               (0UL<<0) /* No flushing at all.   */
+#define UVMF_TLB_FLUSH          (1UL<<0) /* Flush entire TLB(s).  */
+#define UVMF_INVLPG             (2UL<<0) /* Flush only one entry. */
+#define UVMF_FLUSHTYPE_MASK     (3UL<<0)
+#define UVMF_MULTI              (0UL<<2) /* Flush subset of TLBs. */
+#define UVMF_LOCAL              (0UL<<2) /* Flush local TLB.      */
+#define UVMF_ALL                (1UL<<2) /* Flush all TLBs.       */
+
+/*
+ * Commands to HYPERVISOR_console_io().
+ */
+#define CONSOLEIO_write         0
+#define CONSOLEIO_read          1
+
+/*
+ * Commands to HYPERVISOR_vm_assist().
+ */
+#define VMASST_CMD_enable                0
+#define VMASST_CMD_disable               1
+#define VMASST_TYPE_4gb_segments         0
+#define VMASST_TYPE_4gb_segments_notify  1
+#define VMASST_TYPE_writable_pagetables  2
+#define VMASST_TYPE_pae_extended_cr3     3
+#define MAX_VMASST_TYPE 3
+
+#ifndef __ASSEMBLY__
+
+typedef uint16_t domid_t;
+
+/* Domain ids >= DOMID_FIRST_RESERVED cannot be used for ordinary domains. */
+#define DOMID_FIRST_RESERVED (0x7FF0U)
+
+/* DOMID_SELF is used in certain contexts to refer to oneself. */
+#define DOMID_SELF (0x7FF0U)
+
+/*
+ * DOMID_IO is used to restrict page-table updates to mapping I/O memory.
+ * Although no Foreign Domain need be specified to map I/O pages, DOMID_IO
+ * is useful to ensure that no mappings to the OS's own heap are accidentally
+ * installed. (e.g., in Linux this could cause havoc as reference counts
+ * aren't adjusted on the I/O-mapping code path).
+ * This only makes sense in MMUEXT_SET_FOREIGNDOM, but in that context can
+ * be specified by any calling domain.
+ */
+#define DOMID_IO   (0x7FF1U)
+
+/*
+ * DOMID_XEN is used to allow privileged domains to map restricted parts of
+ * Xen's heap space (e.g., the machine_to_phys table).
+ * This only makes sense in MMUEXT_SET_FOREIGNDOM, and is only permitted if
+ * the caller is privileged.
+ */
+#define DOMID_XEN  (0x7FF2U)
+
+/*
+ * Send an array of these to HYPERVISOR_mmu_update().
+ * NB. The fields are natural pointer/address size for this architecture.
+ */
+struct mmu_update {
+    uint64_t ptr;       /* Machine address of PTE. */
+    uint64_t val;       /* New contents of PTE.    */
+};
+DEFINE_GUEST_HANDLE_STRUCT(mmu_update);
+
+/*
+ * Send an array of these to HYPERVISOR_multicall().
+ * NB. The fields are natural register size for this architecture.
+ */
+struct multicall_entry {
+    unsigned long op, result;
+    unsigned long args[6];
+};
+DEFINE_GUEST_HANDLE_STRUCT(multicall_entry);
+
+/*
+ * Event channel endpoints per domain:
+ *  1024 if a long is 32 bits; 4096 if a long is 64 bits.
+ */
+#define NR_EVENT_CHANNELS (sizeof(unsigned long) * sizeof(unsigned long) * 64)
+
+struct vcpu_time_info {
+    /*
+     * Updates to the following values are preceded and followed by an
+     * increment of 'version'. The guest can therefore detect updates by
+     * looking for changes to 'version'. If the least-significant bit of
+     * the version number is set then an update is in progress and the guest
+     * must wait to read a consistent set of values.
+     * The correct way to interact with the version number is similar to
+     * Linux's seqlock: see the implementations of read_seqbegin/read_seqretry.
+     */
+    uint32_t version;
+    uint32_t pad0;
+    uint64_t tsc_timestamp;   /* TSC at last update of time vals.  */
+    uint64_t system_time;     /* Time, in nanosecs, since boot.    */
+    /*
+     * Current system time:
+     *   system_time + ((tsc - tsc_timestamp) << tsc_shift) * tsc_to_system_mul
+     * CPU frequency (Hz):
+     *   ((10^9 << 32) / tsc_to_system_mul) >> tsc_shift
+     */
+    uint32_t tsc_to_system_mul;
+    int8_t   tsc_shift;
+    int8_t   pad1[3];
+}; /* 32 bytes */
+
+struct vcpu_info {
+    /*
+     * 'evtchn_upcall_pending' is written non-zero by Xen to indicate
+     * a pending notification for a particular VCPU. It is then cleared
+     * by the guest OS /before/ checking for pending work, thus avoiding
+     * a set-and-check race. Note that the mask is only accessed by Xen
+     * on the CPU that is currently hosting the VCPU. This means that the
+     * pending and mask flags can be updated by the guest without special
+     * synchronisation (i.e., no need for the x86 LOCK prefix).
+     * This may seem suboptimal because if the pending flag is set by
+     * a different CPU then an IPI may be scheduled even when the mask
+     * is set. However, note:
+     *  1. The task of 'interrupt holdoff' is covered by the per-event-
+     *     channel mask bits. A 'noisy' event that is continually being
+     *     triggered can be masked at source at this very precise
+     *     granularity.
+     *  2. The main purpose of the per-VCPU mask is therefore to restrict
+     *     reentrant execution: whether for concurrency control, or to
+     *     prevent unbounded stack usage. Whatever the purpose, we expect
+     *     that the mask will be asserted only for short periods at a time,
+     *     and so the likelihood of a 'spurious' IPI is suitably small.
+     * The mask is read before making an event upcall to the guest: a
+     * non-zero mask therefore guarantees that the VCPU will not receive
+     * an upcall activation. The mask is cleared when the VCPU requests
+     * to block: this avoids wakeup-waiting races.
+     */
+    uint8_t evtchn_upcall_pending;
+    uint8_t evtchn_upcall_mask;
+    unsigned long evtchn_pending_sel;
+    struct arch_vcpu_info arch;
+    struct vcpu_time_info time;
+}; /* 64 bytes (x86) */
+
+/*
+ * Xen/kernel shared data -- pointer provided in start_info.
+ * NB. We expect that this struct is smaller than a page.
+ */
+struct shared_info {
+    struct vcpu_info vcpu_info[MAX_VIRT_CPUS];
+
+    /*
+     * A domain can create "event channels" on which it can send and receive
+     * asynchronous event notifications. There are three classes of event that
+     * are delivered by this mechanism:
+     *  1. Bi-directional inter- and intra-domain connections. Domains must
+     *     arrange out-of-band to set up a connection (usually by allocating
+     *     an unbound 'listener' port and avertising that via a storage service
+     *     such as xenstore).
+     *  2. Physical interrupts. A domain with suitable hardware-access
+     *     privileges can bind an event-channel port to a physical interrupt
+     *     source.
+     *  3. Virtual interrupts ('events'). A domain can bind an event-channel
+     *     port to a virtual interrupt source, such as the virtual-timer
+     *     device or the emergency console.
+     *
+     * Event channels are addressed by a "port index". Each channel is
+     * associated with two bits of information:
+     *  1. PENDING -- notifies the domain that there is a pending notification
+     *     to be processed. This bit is cleared by the guest.
+     *  2. MASK -- if this bit is clear then a 0->1 transition of PENDING
+     *     will cause an asynchronous upcall to be scheduled. This bit is only
+     *     updated by the guest. It is read-only within Xen. If a channel
+     *     becomes pending while the channel is masked then the 'edge' is lost
+     *     (i.e., when the channel is unmasked, the guest must manually handle
+     *     pending notifications as no upcall will be scheduled by Xen).
+     *
+     * To expedite scanning of pending notifications, any 0->1 pending
+     * transition on an unmasked channel causes a corresponding bit in a
+     * per-vcpu selector word to be set. Each bit in the selector covers a
+     * 'C long' in the PENDING bitfield array.
+     */
+    unsigned long evtchn_pending[sizeof(unsigned long) * 8];
+    unsigned long evtchn_mask[sizeof(unsigned long) * 8];
+
+    /*
+     * Wallclock time: updated only by control software. Guests should base
+     * their gettimeofday() syscall on this wallclock-base value.
+     */
+    uint32_t wc_version;      /* Version counter: see vcpu_time_info_t. */
+    uint32_t wc_sec;          /* Secs  00:00:00 UTC, Jan 1, 1970.  */
+    uint32_t wc_nsec;         /* Nsecs 00:00:00 UTC, Jan 1, 1970.  */
+
+    struct arch_shared_info arch;
+
+};
+
+/*
+ * Start-of-day memory layout for the initial domain (DOM0):
+ *  1. The domain is started within contiguous virtual-memory region.
+ *  2. The contiguous region begins and ends on an aligned 4MB boundary.
+ *  3. The region start corresponds to the load address of the OS image.
+ *     If the load address is not 4MB aligned then the address is rounded down.
+ *  4. This the order of bootstrap elements in the initial virtual region:
+ *      a. relocated kernel image
+ *      b. initial ram disk              [mod_start, mod_len]
+ *      c. list of allocated page frames [mfn_list, nr_pages]
+ *      d. start_info_t structure        [register ESI (x86)]
+ *      e. bootstrap page tables         [pt_base, CR3 (x86)]
+ *      f. bootstrap stack               [register ESP (x86)]
+ *  5. Bootstrap elements are packed together, but each is 4kB-aligned.
+ *  6. The initial ram disk may be omitted.
+ *  7. The list of page frames forms a contiguous 'pseudo-physical' memory
+ *     layout for the domain. In particular, the bootstrap virtual-memory
+ *     region is a 1:1 mapping to the first section of the pseudo-physical map.
+ *  8. All bootstrap elements are mapped read-writable for the guest OS. The
+ *     only exception is the bootstrap page table, which is mapped read-only.
+ *  9. There is guaranteed to be at least 512kB padding after the final
+ *     bootstrap element. If necessary, the bootstrap virtual region is
+ *     extended by an extra 4MB to ensure this.
+ */
+
+#define MAX_GUEST_CMDLINE 1024
+struct start_info {
+    /* THE FOLLOWING ARE FILLED IN BOTH ON INITIAL BOOT AND ON RESUME.    */
+    char magic[32];             /* "xen-<version>-<platform>".            */
+    unsigned long nr_pages;     /* Total pages allocated to this domain.  */
+    unsigned long shared_info;  /* MACHINE address of shared info struct. */
+    uint32_t flags;             /* SIF_xxx flags.                         */
+    unsigned long store_mfn;    /* MACHINE page number of shared page.    */
+    uint32_t store_evtchn;      /* Event channel for store communication. */
+    union {
+        struct {
+            unsigned long mfn;      /* MACHINE page number of console page.   */
+            uint32_t  evtchn;   /* Event channel for console page.        */
+        } domU;
+        struct {
+            uint32_t info_off;  /* Offset of console_info struct.         */
+            uint32_t info_size; /* Size of console_info struct from start.*/
+        } dom0;
+    } console;
+    /* THE FOLLOWING ARE ONLY FILLED IN ON INITIAL BOOT (NOT RESUME).     */
+    unsigned long pt_base;      /* VIRTUAL address of page directory.     */
+    unsigned long nr_pt_frames; /* Number of bootstrap p.t. frames.       */
+    unsigned long mfn_list;     /* VIRTUAL address of page-frame list.    */
+    unsigned long mod_start;    /* VIRTUAL address of pre-loaded module.  */
+    unsigned long mod_len;      /* Size (bytes) of pre-loaded module.     */
+    int8_t cmd_line[MAX_GUEST_CMDLINE];
+};
+
+/* These flags are passed in the 'flags' field of start_info_t. */
+#define SIF_PRIVILEGED    (1<<0)  /* Is the domain privileged? */
+#define SIF_INITDOMAIN    (1<<1)  /* Is this the initial control domain? */
+
+typedef uint64_t cpumap_t;
+
+typedef uint8_t xen_domain_handle_t[16];
+
+/* Turn a plain number into a C unsigned long constant. */
+#define __mk_unsigned_long(x) x ## UL
+#define mk_unsigned_long(x) __mk_unsigned_long(x)
+
+#else /* __ASSEMBLY__ */
+
+/* In assembly code we cannot use C numeric constant suffixes. */
+#define mk_unsigned_long(x) x
+
+#endif /* !__ASSEMBLY__ */
+
+#endif /* __XEN_PUBLIC_XEN_H__ */
_

Patches currently in -mm which might be from jeremy@goop.org are

i386-probe_roms-cleanup.patch
no-need-to-use-traditional-for-processing-asm-in-i386-kernel.patch
xen-paravirt-fix-typo-in-sync_constant_test_bits-name.patch
xen-paravirt-ignore-vgacon-if-hardware-not-present.patch
xen-paravirt-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
xen-paravirt-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt-remove-ctor-for-pgd-cache.patch
xen-paravirt-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
xen-paravirt-allow-paravirt-backend-to-select-pgd-allocation-alignment.patch
xen-paravirt-add-hooks-to-intercept-mm-creation-and-destruction.patch
xen-paravirt-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
xen-paravirt-allocate-and-free-vmalloc-areas.patch
xen-paravirt-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt-add-xen-config-options-and-disable-unsupported-config-options.patch
xen-paravirt-add-xen-interface-header-files.patch
xen-paravirt-core-xen-implementation.patch
xen-paravirt-add-the-xen-virtual-console-driver.patch
xen-paravirt-add-xen-grant-table-support.patch
xen-paravirt-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt-add-xen-virtual-block-device-driver.patch
xen-paravirt-add-the-xen-virtual-network-device-driver.patch
uninline-jiffiesh-functions.patch
