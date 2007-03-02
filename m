From: akpm@linux-foundation.org
Subject: - xen-paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch removed from -mm tree
Date: Thu, 01 Mar 2007 20:57:10 -0800
Message-ID: <200703020457.l224vAPQ000508@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41944 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422911AbXCBE5T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 23:57:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, anthony@codemonkey.ws, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com, mm-commits@vger.kernel.org


The patch titled
     xen-paravirt_ops: consistently wrap paravirt ops callsites to make them patchable
has been removed from the -mm tree.  Its filename was
     xen-paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch

This patch was dropped because Zach's patches destroyed it all

------------------------------------------------------
Subject: xen-paravirt_ops: consistently wrap paravirt ops callsites to make them patchable
From: Jeremy Fitzhardinge <jeremy@goop.org>

Wrap a set of interesting paravirt_ops calls in a wrapper which makes the
callsites available for patching.  Unfortunately this is pretty ugly because
there's no way to get gcc to generate a function call, but also wrap just the
callsite itself with the necessary labels.

This patch supports functions with 0-4 arguments, and either void or returning
a value.  64-bit arguments must be split into a pair of 32-bit arguments
(lower word first).  Small structures are returned in registers.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/paravirt.h |  246 +++++++++++++++++++++++++++++++---
 1 file changed, 229 insertions(+), 17 deletions(-)

diff -puN include/asm-i386/paravirt.h~xen-paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~xen-paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable
+++ a/include/asm-i386/paravirt.h
@@ -33,6 +33,222 @@
 #define paravirt_alt(insn_string)				\
 	_paravirt_alt(insn_string, "%c[paravirt_typenum]", "%c[paravirt_clobber]")
 
+#define PVOP_CALL0(__rettype, __op)					\
+	({								\
+		__rettype __ret;					\
+		if (sizeof(__rettype) > sizeof(unsigned long)) {	\
+			unsigned long long __tmp;			\
+			unsigned long __ecx;				\
+			asm volatile(paravirt_alt("call *%[op]")	\
+				     : "=A" (__tmp), "=c" (__ecx)	\
+				     : [op] "m" (paravirt_ops.__op),	\
+				       paravirt_type(PARAVIRT_PATCH(__op)), \
+				       paravirt_clobber(CLBR_ANY)	\
+				     : "memory", "cc");			\
+			__ret = (__rettype)__tmp;			\
+		} else {						\
+			unsigned long __tmp, __edx, __ecx;	\
+			asm volatile(paravirt_alt("call *%[op]")	\
+				     : "=a" (__tmp), "=d" (__edx), "=c" (__ecx) \
+				     : [op] "m" (paravirt_ops.__op),	\
+				       paravirt_type(PARAVIRT_PATCH(__op)), \
+				       paravirt_clobber(CLBR_ANY)	\
+				     : "memory", "cc");			\
+			__ret = (__rettype)__tmp;			\
+		}							\
+		__ret;							\
+	})
+#define PVOP_VCALL0(__op)						\
+	({								\
+		unsigned long __eax, __edx, __ecx;			\
+		asm volatile(paravirt_alt("call *%[op]")		\
+			     : "=a" (__eax), "=d" (__edx), "=c" (__ecx) \
+			     : [op] "m" (paravirt_ops.__op),		\
+			       paravirt_type(PARAVIRT_PATCH(__op)),	\
+			       paravirt_clobber(CLBR_ANY)		\
+			     : "memory", "cc");				\
+	})
+
+#define PVOP_CALL1(__rettype, __op, arg1)				\
+	({								\
+		__rettype __ret;					\
+		if (sizeof(__rettype) > sizeof(unsigned long)) {	\
+			unsigned long long __tmp;			\
+			unsigned long __ecx;				\
+			asm volatile(paravirt_alt("call *%[op]")	\
+				     : "=A" (__tmp), "=c" (__ecx)	\
+				     : [op] "m" (paravirt_ops.__op),	\
+				       "a" ((u32)(arg1)),		\
+				       paravirt_type(PARAVIRT_PATCH(__op)), \
+				       paravirt_clobber(CLBR_ANY)	\
+				     : "memory", "cc");			\
+			__ret = (__rettype)__tmp;			\
+		} else {						\
+			unsigned long __tmp, __edx, __ecx;	\
+			asm volatile(paravirt_alt("call *%[op]")	\
+				     : "=a" (__tmp), "=d" (__edx), "=c" (__ecx) \
+				     : [op] "m" (paravirt_ops.__op),	\
+				       "0" ((u32)(arg1)),		\
+				       paravirt_type(PARAVIRT_PATCH(__op)), \
+				       paravirt_clobber(CLBR_ANY)	\
+				     : "memory", "cc");			\
+			__ret = (__rettype)__tmp;			\
+		}							\
+		__ret;							\
+	})
+#define PVOP_VCALL1(__op, arg1)						\
+	({								\
+		unsigned long __eax, __edx, __ecx;			\
+		asm volatile(paravirt_alt("call *%[op]")		\
+			     : "=a" (__eax), "=d" (__edx), "=c" (__ecx) \
+			     : [op] "m" (paravirt_ops.__op),		\
+			       "0" ((u32)(arg1)),			\
+			       paravirt_type(PARAVIRT_PATCH(__op)),	\
+			       paravirt_clobber(CLBR_ANY)		\
+			     : "memory", "cc");				\
+	})
+
+#define PVOP_CALL2(__rettype, __op, arg1, arg2)				\
+	({								\
+		__rettype __ret;					\
+		if (sizeof(__rettype) > sizeof(unsigned long)) {	\
+			unsigned long long __tmp;			\
+			unsigned long __ecx;				\
+			asm volatile(paravirt_alt("call *%[op]")	\
+				     : "=A" (__tmp), "=c" (__ecx)	\
+				     : [op] "m" (paravirt_ops.__op),	\
+				       "a" ((u32)(arg1)),		\
+				       "d" ((u32)(arg2)),		\
+				       paravirt_type(PARAVIRT_PATCH(__op)), \
+				       paravirt_clobber(CLBR_ANY)	\
+				     : "memory", "cc");			\
+			__ret = (__rettype)__tmp;			\
+		} else {						\
+			unsigned long __tmp, __edx, __ecx;	\
+			asm volatile(paravirt_alt("call *%[op]")	\
+				     : "=a" (__tmp), "=d" (__edx), "=c" (__ecx) \
+				     : [op] "m" (paravirt_ops.__op),	\
+				       "0" ((u32)(arg1)),		\
+				       "1" ((u32)(arg2)),		\
+				       paravirt_type(PARAVIRT_PATCH(__op)), \
+				       paravirt_clobber(CLBR_ANY)	\
+				     : "memory", "cc");			\
+			__ret = (__rettype)__tmp;			\
+		}							\
+		__ret;							\
+	})
+#define PVOP_VCALL2(__op, arg1, arg2)					\
+	({								\
+		unsigned long __eax, __edx, __ecx;			\
+		asm volatile(paravirt_alt("call *%[op]")		\
+			     : "=a" (__eax), "=d" (__edx), "=c" (__ecx) \
+			     : [op] "m" (paravirt_ops.__op),		\
+			       "0" ((u32)(arg1)),			\
+			       "1" ((u32)(arg2)),			\
+			       paravirt_type(PARAVIRT_PATCH(__op)),	\
+			       paravirt_clobber(CLBR_ANY)		\
+			     : "memory", "cc");				\
+	})
+
+#define PVOP_CALL3(__rettype, __op, arg1, arg2, arg3)			\
+	({								\
+		__rettype __ret;					\
+		if (sizeof(__rettype) > sizeof(unsigned long)) {	\
+			unsigned long long __tmp;			\
+			unsigned long __ecx;				\
+			asm volatile(paravirt_alt("call *%[op]")	\
+				     : "=A" (__tmp), "=c" (__ecx)	\
+				     : [op] "m" (paravirt_ops.__op),	\
+				       "a" ((u32)(arg1)),		\
+				       "d" ((u32)(arg2)),		\
+				       "1" ((u32)(arg3)),		\
+				       paravirt_type(PARAVIRT_PATCH(__op)), \
+				       paravirt_clobber(CLBR_ANY)	\
+				     : "memory", "cc");			\
+			__ret = (__rettype)__tmp;			\
+		} else {						\
+			unsigned long __tmp, __edx, __ecx;	\
+			asm volatile(paravirt_alt("call *%[op]")	\
+				     : "=a" (__tmp), "=d" (__edx), "=c" (__ecx) \
+				     : [op] "m" (paravirt_ops.__op),	\
+				       "0" ((u32)(arg1)),		\
+				       "1" ((u32)(arg2)),		\
+				       "2" ((u32)(arg3)),		\
+				       paravirt_type(PARAVIRT_PATCH(__op)), \
+				       paravirt_clobber(CLBR_ANY)	\
+				     : "memory", "cc");			\
+			__ret = (__rettype)__tmp;			\
+		}							\
+		__ret;							\
+	})
+#define PVOP_VCALL3(__op, arg1, arg2, arg3)				\
+	({								\
+		unsigned long __eax, __edx, __ecx;			\
+		asm volatile(paravirt_alt("call *%[op]")		\
+			     : "=a" (__eax), "=d" (__edx), "=c" (__ecx) \
+			     : [op] "m" (paravirt_ops.__op),		\
+			       "0" ((u32)(arg1)),			\
+			       "1" ((u32)(arg2)),			\
+			       "2" ((u32)(arg3)),			\
+			       paravirt_type(PARAVIRT_PATCH(__op)),	\
+			       paravirt_clobber(CLBR_ANY)		\
+			     : "memory", "cc");				\
+	})
+
+#define PVOP_CALL4(__rettype, __op, arg1, arg2, arg3, arg4)		\
+	({								\
+		__rettype __ret;					\
+		if (sizeof(__rettype) > sizeof(unsigned long)) {	\
+			unsigned long long __tmp;			\
+			unsigned long __ecx;				\
+			asm volatile("push %[_arg4]; "			\
+				     paravirt_alt("call *%[op]")	\
+				     "lea 4(%%esp),%%esp"		\
+				     : "=A" (__tmp), "=c" (__ecx)	\
+				     : [op] "m" (paravirt_ops.__op),	\
+				       "a" ((u32)(arg1)),		\
+				       "d" ((u32)(arg2)),		\
+				       "1" ((u32)(arg3)),		\
+				       [_arg4] "mr" ((u32)(arg4)),	\
+				       paravirt_type(PARAVIRT_PATCH(__op)), \
+				       paravirt_clobber(CLBR_ANY)	\
+				     : "memory", "cc",);		\
+			__ret = (__rettype)__tmp;			\
+		} else {						\
+			unsigned long __tmp, __edx, __ecx;		\
+			asm volatile("push %[_arg4]; "			\
+				     paravirt_alt("call *%[op]")	\
+				     "lea 4(%%esp),%%esp"		\
+				     : "=a" (__tmp), "=d" (__edx), "=c" (__ecx) \
+				     : [op] "m" (paravirt_ops.__op),	\
+				       "0" ((u32)(arg1)),		\
+				       "1" ((u32)(arg2)),		\
+				       "2" ((u32)(arg3)),		\
+				       [_arg4]"mr" ((u32)(arg4)),	\
+				       paravirt_type(PARAVIRT_PATCH(__op)), \
+				       paravirt_clobber(CLBR_ANY)	\
+				     : "memory", "cc");			\
+			__ret = (__rettype)__tmp;			\
+		}							\
+		__ret;							\
+	})
+#define PVOP_VCALL4(__op, arg1, arg2, arg3, arg4)			\
+	({								\
+		unsigned long __eax, __edx, __ecx;			\
+		asm volatile("push %[_arg4]; "				\
+			     paravirt_alt("call *%[op]")		\
+			     "lea 4(%%esp),%%esp"			\
+			     : "=a" (__eax), "=d" (__edx), "=c" (__ecx) \
+			     : [op] "m" (paravirt_ops.__op),		\
+			       "0" ((u32)(arg1)),			\
+			       "1" ((u32)(arg2)),			\
+			       "2" ((u32)(arg3)),			\
+			       [_arg4]"mr" ((u32)(arg4)),		\
+			       paravirt_type(PARAVIRT_PATCH(__op)),	\
+			       paravirt_clobber(CLBR_ANY)		\
+			     : "memory", "cc");				\
+	})
+
 struct thread_struct;
 struct Xgt_desc_struct;
 struct tss_struct;
@@ -112,14 +328,10 @@ struct paravirt_ops
 	void (*set_ldt)(const void *desc, unsigned entries);
 	unsigned long (*store_tr)(void);
 	void (*load_tls)(struct thread_struct *t, unsigned int cpu);
-	void (*write_ldt_entry)(void *dt, int entrynum,
-					 u32 low, u32 high);
-	void (*write_gdt_entry)(void *dt, int entrynum,
-					 u32 low, u32 high);
-	void (*write_idt_entry)(void *dt, int entrynum,
-					 u32 low, u32 high);
-	void (*load_esp0)(struct tss_struct *tss,
-				   struct thread_struct *thread);
+	void (*write_ldt_entry)(void *dt, int entrynum, u32 low, u32 high);
+	void (*write_gdt_entry)(void *dt, int entrynum, u32 low, u32 high);
+	void (*write_idt_entry)(void *dt, int entrynum, u32 low, u32 high);
+	void (*load_esp0)(struct tss_struct *tss, struct thread_struct *thread);
 
 	void (*set_iopl_mask)(unsigned mask);
 
@@ -362,27 +574,27 @@ static inline void slow_down_io(void) {
  */
 static inline void apic_write(unsigned long reg, unsigned long v)
 {
-	paravirt_ops.apic_write(reg,v);
+	PVOP_VCALL2(apic_write, reg, v);
 }
 
 static inline void apic_write_atomic(unsigned long reg, unsigned long v)
 {
-	paravirt_ops.apic_write_atomic(reg,v);
+	PVOP_VCALL2(apic_write_atomic, reg, v);
 }
 
 static inline unsigned long apic_read(unsigned long reg)
 {
-	return paravirt_ops.apic_read(reg);
+	return PVOP_CALL1(unsigned long, apic_read, reg);
 }
 
 static inline void setup_boot_clock(void)
 {
-	paravirt_ops.setup_boot_clock();
+	PVOP_VCALL0(setup_boot_clock);
 }
 
 static inline void setup_secondary_clock(void)
 {
-	paravirt_ops.setup_secondary_clock();
+	PVOP_VCALL0(setup_secondary_clock);
 }
 #endif
 
@@ -496,12 +708,12 @@ static inline void pmd_clear(pmd_t *pmdp
 #define PARAVIRT_LAZY_CPU  2
 
 #define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
-#define arch_enter_lazy_cpu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_CPU)
-#define arch_leave_lazy_cpu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_NONE)
+#define arch_enter_lazy_cpu_mode() PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_CPU)
+#define arch_leave_lazy_cpu_mode() PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_NONE)
 
 #define  __HAVE_ARCH_ENTER_LAZY_MMU_MODE
-#define arch_enter_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_MMU)
-#define arch_leave_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_NONE)
+#define arch_enter_lazy_mmu_mode() PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_MMU)
+#define arch_leave_lazy_mmu_mode() PVOP_VCALL1(set_lazy_mode, PARAVIRT_LAZY_NONE)
 
 void _paravirt_nop(void);
 #define paravirt_nop	((void *)_paravirt_nop)
_

Patches currently in -mm which might be from jeremy@goop.org are

xen-paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch
xen-paravirt_ops-add-common-patching-machinery.patch
xen-paravirt_ops-add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
xen-paravirt_ops-allocate-and-free-vmalloc-areas.patch
xen-paravirt_ops-add-nosegneg-capability-to-the-vsyscall-page-notes.patch
xen-paravirt_ops-add-xen-config-options.patch
xen-paravirt_ops-add-xen-interface-header-files.patch
xen-paravirt_ops-core-xen-implementation.patch
xen-paravirt_ops-use-the-hvc-console-infrastructure-for-xen-console.patch
xen-paravirt_ops-add-early-printk-support-via-hvc-console.patch
xen-paravirt_ops-add-xen-grant-table-support.patch
xen-paravirt_ops-add-the-xenbus-sysfs-and-virtual-device-hotplug-driver.patch
xen-paravirt_ops-add-xen-virtual-block-device-driver.patch
xen-paravirt_ops-add-the-xen-virtual-network-device-driver.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
