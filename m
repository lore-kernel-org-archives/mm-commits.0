From: akpm@linux-foundation.org
Subject: + xen-paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch added to -mm tree
Date: Thu, 01 Mar 2007 18:03:24 -0800
Message-ID: <200703020203.l2223O1H029575@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35012 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422770AbXCBCDi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 1 Mar 2007 21:03:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, anthony@codemonkey.ws, jeremy@xensource.com, rusty@rustcorp.com.au, zach@vmware.com


The patch titled
     xen-paravirt_ops: consistently wrap paravirt ops callsites to make them patchable
has been added to the -mm tree.  Its filename is
     xen-paravirt_ops-consistently-wrap-paravirt-ops-callsites-to-make-them-patchable.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 include/asm-i386/paravirt.h |  533 ++++++++++++++++++++++++++--------
 1 files changed, 420 insertions(+), 113 deletions(-)

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
@@ -110,14 +326,10 @@ struct paravirt_ops
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
 
@@ -194,151 +406,165 @@ struct paravirt_ops
 
 extern struct paravirt_ops paravirt_ops;
 
-#define paravirt_enabled() (paravirt_ops.paravirt_enabled)
+static inline int paravirt_enabled(void)
+{
+	return paravirt_ops.paravirt_enabled;
+}
 
 static inline void load_esp0(struct tss_struct *tss,
 			     struct thread_struct *thread)
 {
-	paravirt_ops.load_esp0(tss, thread);
+	PVOP_VCALL2(load_esp0, tss, thread);
 }
 
-#define ARCH_SETUP			paravirt_ops.arch_setup();
+#define ARCH_SETUP			PVOP_VCALL0(arch_setup);
 static inline unsigned long get_wallclock(void)
 {
-	return paravirt_ops.get_wallclock();
+	return PVOP_CALL0(unsigned long, get_wallclock);
 }
 
 static inline int set_wallclock(unsigned long nowtime)
 {
-	return paravirt_ops.set_wallclock(nowtime);
+	return PVOP_CALL1(int, set_wallclock, nowtime);
 }
 
 static inline void do_time_init(void)
 {
-	return paravirt_ops.time_init();
+	PVOP_VCALL0(time_init);
 }
 
 /* The paravirtualized CPUID instruction. */
 static inline void __cpuid(unsigned int *eax, unsigned int *ebx,
 			   unsigned int *ecx, unsigned int *edx)
 {
-	paravirt_ops.cpuid(eax, ebx, ecx, edx);
+	PVOP_VCALL4(cpuid, eax, ebx, ecx, edx);
 }
 
 /*
  * These special macros can be used to get or set a debugging register
  */
-#define get_debugreg(var, reg) var = paravirt_ops.get_debugreg(reg)
-#define set_debugreg(val, reg) paravirt_ops.set_debugreg(reg, val)
+#define get_debugreg(var, reg) var = PVOP_CALL1(unsigned long, get_debugreg, reg)
+#define set_debugreg(val, reg) PVOP_VCALL2(set_debugreg, reg, val)
 
-#define clts() paravirt_ops.clts()
+#define clts()		PVOP_VCALL0(clts)
 
-#define read_cr0() paravirt_ops.read_cr0()
-#define write_cr0(x) paravirt_ops.write_cr0(x)
+#define read_cr0()	PVOP_CALL0(unsigned long, read_cr0)
+#define write_cr0(x)	PVOP_VCALL1(write_cr0, x)
 
-#define read_cr2() paravirt_ops.read_cr2()
-#define write_cr2(x) paravirt_ops.write_cr2(x)
+#define read_cr2()	PVOP_CALL0(unsigned long, read_cr2)
+#define write_cr2(x)	PVOP_VCALL1(write_cr2, x)
 
-#define read_cr3() paravirt_ops.read_cr3()
-#define write_cr3(x) paravirt_ops.write_cr3(x)
+#define read_cr3()	PVOP_CALL0(unsigned long, read_cr3)
+#define write_cr3(x)	PVOP_VCALL1(write_cr3, x)
 
-#define read_cr4() paravirt_ops.read_cr4()
-#define read_cr4_safe(x) paravirt_ops.read_cr4_safe()
-#define write_cr4(x) paravirt_ops.write_cr4(x)
-
-#define raw_ptep_get_and_clear(xp)	(paravirt_ops.ptep_get_and_clear(xp))
+#define read_cr4()	PVOP_CALL0(unsigned long, read_cr4)
+#define read_cr4_safe(x) PVOP_CALL0(unsigned long, read_cr4_safe)
+#define write_cr4(x)	PVOP_VCALL1(write_cr4, x)
 
 static inline void raw_safe_halt(void)
 {
-	paravirt_ops.safe_halt();
+	PVOP_VCALL0(safe_halt);
 }
 
 static inline void halt(void)
 {
-	paravirt_ops.safe_halt();
+	PVOP_VCALL0(safe_halt);
 }
-#define wbinvd() paravirt_ops.wbinvd()
+#define wbinvd()	PVOP_VCALL0(wbinvd)
 
 #define get_kernel_rpl()  (paravirt_ops.kernel_rpl)
 
 #define rdmsr(msr,val1,val2) do {				\
 	int _err;						\
-	u64 _l = paravirt_ops.read_msr(msr,&_err);		\
+	u64 _l = PVOP_CALL2(u64, read_msr, msr, &_err);		\
 	val1 = (u32)_l;						\
 	val2 = _l >> 32;					\
 } while(0)
 
-#define wrmsr(msr,val1,val2) do {				\
-	u64 _l = ((u64)(val2) << 32) | (val1);			\
-	paravirt_ops.write_msr((msr), _l);			\
-} while(0)
+#define wrmsr(msr,val1,val2) PVOP_VCALL3(write_msr, msr, val1, val2)
 
 #define rdmsrl(msr,val) do {					\
 	int _err;						\
-	val = paravirt_ops.read_msr((msr),&_err);		\
+	val = PVOP_CALL2(u64, read_msr, msr, &_err);		\
 } while(0)
 
-#define wrmsrl(msr,val) (paravirt_ops.write_msr((msr),(val)))
-#define wrmsr_safe(msr,a,b) ({					\
-	u64 _l = ((u64)(b) << 32) | (a);			\
-	paravirt_ops.write_msr((msr),_l);			\
-})
+#define wrmsrl(msr,val)		PVOP_CALL3(int, write_msr, msr, val, 0)
+#define wrmsr_safe(msr,a,b)	PVOP_CALL3(int, write_msr, msr, a, b)
 
 /* rdmsr with exception handling */
 #define rdmsr_safe(msr,a,b) ({					\
 	int _err;						\
-	u64 _l = paravirt_ops.read_msr(msr,&_err);		\
+	u64 _l = PVOP_CALL2(u64, read_msr, msr, &_err);		\
 	(*a) = (u32)_l;						\
 	(*b) = _l >> 32;					\
 	_err; })
 
 #define rdtsc(low,high) do {					\
-	u64 _l = paravirt_ops.read_tsc();			\
+	u64 _l = PVOP_CALL0(u64, read_tsc);			\
 	low = (u32)_l;						\
 	high = _l >> 32;					\
 } while(0)
 
 #define rdtscl(low) do {					\
-	u64 _l = paravirt_ops.read_tsc();			\
+	u64 _l = PVOP_CALL0(u64, read_tsc);			\
 	low = (int)_l;						\
 } while(0)
 
-#define rdtscll(val) (val = paravirt_ops.read_tsc())
+#define rdtscll(val) (val = PVOP_CALL0(u64, read_tsc))
 
 #define write_tsc(val1,val2) wrmsr(0x10, val1, val2)
 
 #define rdpmc(counter,low,high) do {				\
-	u64 _l = paravirt_ops.read_pmc();			\
+	u64 _l = PVOP_CALL0(u64, read_pmc);			\
 	low = (u32)_l;						\
 	high = _l >> 32;					\
 } while(0)
 
-#define load_TR_desc() (paravirt_ops.load_tr_desc())
-#define load_gdt(dtr) (paravirt_ops.load_gdt(dtr))
-#define load_idt(dtr) (paravirt_ops.load_idt(dtr))
-#define set_ldt(addr, entries) (paravirt_ops.set_ldt((addr), (entries)))
-#define store_gdt(dtr) (paravirt_ops.store_gdt(dtr))
-#define store_idt(dtr) (paravirt_ops.store_idt(dtr))
-#define store_tr(tr) ((tr) = paravirt_ops.store_tr())
-#define load_TLS(t,cpu) (paravirt_ops.load_tls((t),(cpu)))
-#define write_ldt_entry(dt, entry, low, high)				\
-	(paravirt_ops.write_ldt_entry((dt), (entry), (low), (high)))
-#define write_gdt_entry(dt, entry, low, high)				\
-	(paravirt_ops.write_gdt_entry((dt), (entry), (low), (high)))
-#define write_idt_entry(dt, entry, low, high)				\
-	(paravirt_ops.write_idt_entry((dt), (entry), (low), (high)))
-#define set_iopl_mask(mask) (paravirt_ops.set_iopl_mask(mask))
-
-#define __pte(x)	paravirt_ops.make_pte(x)
-#define __pgd(x)	paravirt_ops.make_pgd(x)
-
-#define pte_val(x)	paravirt_ops.pte_val(x)
-#define pgd_val(x)	paravirt_ops.pgd_val(x)
-
-#ifdef CONFIG_X86_PAE
-#define __pmd(x)	paravirt_ops.make_pmd(x)
-#define pmd_val(x)	paravirt_ops.pmd_val(x)
-#endif
+static inline void load_TR_desc(void)
+{
+	PVOP_VCALL0(load_tr_desc);
+}
+static inline void load_gdt(const struct Xgt_desc_struct *dtr)
+{
+	PVOP_VCALL1(load_gdt, dtr);
+}
+static inline void load_idt(const struct Xgt_desc_struct *dtr)
+{
+	PVOP_VCALL1(load_idt, dtr);
+}
+static inline void set_ldt(const void *addr, unsigned entries)
+{
+	PVOP_VCALL2(set_ldt, addr, entries);
+}
+static inline void store_gdt(struct Xgt_desc_struct *dtr)
+{
+	PVOP_VCALL1(store_gdt, dtr);
+}
+static inline void store_idt(struct Xgt_desc_struct *dtr)
+{
+	PVOP_VCALL1(store_idt, dtr);
+}
+#define store_tr(tr)	((tr) = PVOP_CALL0(unsigned long, store_tr))
+static inline void load_TLS(struct thread_struct *t, unsigned cpu)
+{
+	PVOP_VCALL2(load_tls, t, cpu);
+}
+static inline void write_ldt_entry(void *dt, int entry, u32 low, u32 high)
+{
+	PVOP_VCALL4(write_ldt_entry, dt, entry, low, high);
+}
+static inline void write_gdt_entry(void *dt, int entry, u32 low, u32 high)
+{
+	PVOP_VCALL4(write_gdt_entry, dt, entry, low, high);
+}
+static inline void write_idt_entry(void *dt, int entry, u32 low, u32 high)
+{
+	PVOP_VCALL4(write_idt_entry, dt, entry, low, high);
+}
+static inline void set_iopl_mask(unsigned mask)
+{
+	PVOP_VCALL1(set_iopl_mask, mask);
+}
 
 /* The paravirtualized I/O functions */
 static inline void slow_down_io(void) {
@@ -356,27 +582,27 @@ static inline void slow_down_io(void) {
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
 
@@ -396,91 +622,172 @@ static inline void paravirt_pagetable_se
 static inline void startup_ipi_hook(int phys_apicid, unsigned long start_eip,
 				    unsigned long start_esp)
 {
-	return paravirt_ops.startup_ipi_hook(phys_apicid, start_eip, start_esp);
+	PVOP_VCALL3(startup_ipi_hook, phys_apicid, start_eip, start_esp);
 }
 #endif
 
 static inline void paravirt_activate_mm(struct mm_struct *prev,
 					struct mm_struct *next)
 {
-	paravirt_ops.activate_mm(prev, next);
+	PVOP_VCALL2(activate_mm, prev, next);
 }
 
 static inline void arch_dup_mmap(struct mm_struct *oldmm,
 				 struct mm_struct *mm)
 {
-	paravirt_ops.dup_mmap(oldmm, mm);
+	PVOP_VCALL2(dup_mmap, oldmm, mm);
 }
 
 static inline void arch_exit_mmap(struct mm_struct *mm)
 {
-	paravirt_ops.exit_mmap(mm);
+	PVOP_VCALL1(exit_mmap, mm);
 }
 
-#define __flush_tlb() paravirt_ops.flush_tlb_user()
-#define __flush_tlb_global() paravirt_ops.flush_tlb_kernel()
-#define __flush_tlb_single(addr) paravirt_ops.flush_tlb_single(addr)
+#define __flush_tlb()		PVOP_VCALL0(flush_tlb_user)
+#define __flush_tlb_global()	PVOP_VCALL0(flush_tlb_kernel)
+#define __flush_tlb_single(addr) PVOP_VCALL1(flush_tlb_single, addr)
 
-#define paravirt_alloc_pt(pfn) paravirt_ops.alloc_pt(pfn)
-#define paravirt_release_pt(pfn) paravirt_ops.release_pt(pfn)
+#define paravirt_alloc_pt(pfn)	PVOP_VCALL1(alloc_pt, pfn)
+#define paravirt_release_pt(pfn) PVOP_VCALL1(release_pt, pfn)
 
-#define paravirt_alloc_pd(pfn) paravirt_ops.alloc_pd(pfn)
+#define paravirt_alloc_pd(pfn)	PVOP_VCALL1(alloc_pd, pfn)
 #define paravirt_alloc_pd_clone(pfn, clonepfn, start, count) \
-	paravirt_ops.alloc_pd_clone(pfn, clonepfn, start, count)
-#define paravirt_release_pd(pfn) paravirt_ops.release_pd(pfn)
+	PVOP_VCALL4(alloc_pd_clone, pfn, clonepfn, start, count)
+#define paravirt_release_pd(pfn) PVOP_VCALL1(release_pd, pfn)
 
-static inline void set_pte(pte_t *ptep, pte_t pteval)
+static inline void pte_update(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
-	paravirt_ops.set_pte(ptep, pteval);
+	PVOP_VCALL3(pte_update, mm, addr, ptep);
 }
 
-static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep, pte_t pteval)
+static inline void pte_update_defer(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
-	paravirt_ops.set_pte_at(mm, addr, ptep, pteval);
+	PVOP_VCALL3(pte_update_defer, mm, addr, ptep);
 }
 
-static inline void set_pmd(pmd_t *pmdp, pmd_t pmdval)
+#ifdef CONFIG_X86_PAE
+static inline pte_t __pte(unsigned long long val)
 {
-	paravirt_ops.set_pmd(pmdp, pmdval);
+	unsigned long long ret = PVOP_CALL2(unsigned long long, make_pte, val, val >> 32);
+	return (pte_t) { ret, ret >> 32 };
 }
 
-static inline void pte_update(struct mm_struct *mm, u32 addr, pte_t *ptep)
+static inline pmd_t __pmd(unsigned long long val)
 {
-	paravirt_ops.pte_update(mm, addr, ptep);
+	return (pmd_t) { PVOP_CALL2(unsigned long long, make_pmd, val, val >> 32) };
 }
 
-static inline void pte_update_defer(struct mm_struct *mm, u32 addr, pte_t *ptep)
+static inline pgd_t __pgd(unsigned long long val)
 {
-	paravirt_ops.pte_update_defer(mm, addr, ptep);
+	return (pgd_t) { PVOP_CALL2(unsigned long long, make_pgd, val, val >> 32) };
+}
+
+static inline unsigned long long pte_val(pte_t x)
+{
+	return PVOP_CALL2(unsigned long long, pte_val, x.pte_low, x.pte_high);
+}
+
+static inline unsigned long long pmd_val(pmd_t x)
+{
+	return PVOP_CALL2(unsigned long long, pmd_val, x.pmd, x.pmd >> 32);
+}
+
+static inline unsigned long long pgd_val(pgd_t x)
+{
+	return PVOP_CALL2(unsigned long long, pgd_val, x.pgd, x.pgd >> 32);
+}
+
+static inline void set_pte(pte_t *ptep, pte_t pteval)
+{
+	PVOP_VCALL3(set_pte, ptep, pteval.pte_low, pteval.pte_high);
+}
+
+static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep, pte_t pteval)
+{
+	/* 5 arg words */
+	paravirt_ops.set_pte_at(mm, addr, ptep, pteval);
 }
 
-#ifdef CONFIG_X86_PAE
 static inline void set_pte_atomic(pte_t *ptep, pte_t pteval)
 {
-	paravirt_ops.set_pte_atomic(ptep, pteval);
+	PVOP_VCALL3(set_pte_atomic, ptep, pteval.pte_low, pteval.pte_high);
 }
 
-static inline void set_pte_present(struct mm_struct *mm, unsigned long addr, pte_t *ptep, pte_t pte)
+static inline void set_pte_present(struct mm_struct *mm, unsigned long addr,
+				   pte_t *ptep, pte_t pte)
 {
+	/* 5 arg words */
 	paravirt_ops.set_pte_present(mm, addr, ptep, pte);
 }
 
+static inline void set_pmd(pmd_t *pmdp, pmd_t pmdval)
+{
+	PVOP_VCALL3(set_pmd, pmdp, pmdval.pmd, pmdval.pmd >> 32);
+}
+
 static inline void set_pud(pud_t *pudp, pud_t pudval)
 {
-	paravirt_ops.set_pud(pudp, pudval);
+	PVOP_VCALL3(set_pud, pudp, pudval.pgd.pgd, pudval.pgd.pgd >> 32);
 }
 
 static inline void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
-	paravirt_ops.pte_clear(mm, addr, ptep);
+	PVOP_VCALL3(pte_clear, mm, addr, ptep);
 }
 
 static inline void pmd_clear(pmd_t *pmdp)
 {
-	paravirt_ops.pmd_clear(pmdp);
+	PVOP_VCALL1(pmd_clear, pmdp);
 }
-#endif
+
+static inline pte_t raw_ptep_get_and_clear(pte_t *p)
+{
+	unsigned long long val = PVOP_CALL1(unsigned long long, ptep_get_and_clear, p);
+	return (pte_t) { val, val >> 32 };
+}
+#else  /* !CONFIG_X86_PAE */
+static inline pte_t __pte(unsigned long val)
+{
+	return (pte_t) { PVOP_CALL1(unsigned long, make_pte, val) };
+}
+
+static inline pgd_t __pgd(unsigned long val)
+{
+	return (pgd_t) { PVOP_CALL1(unsigned long, make_pgd, val) };
+}
+
+static inline unsigned long pte_val(pte_t x)
+{
+	return PVOP_CALL1(unsigned long, pte_val, x.pte_low);
+}
+
+static inline unsigned long pgd_val(pgd_t x)
+{
+	return PVOP_CALL1(unsigned long, pgd_val, x.pgd);
+}
+
+static inline void set_pte(pte_t *ptep, pte_t pteval)
+{
+	PVOP_VCALL2(set_pte, ptep, pteval.pte_low);
+}
+
+static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep, pte_t pteval)
+{
+	PVOP_VCALL4(set_pte_at, mm, addr, ptep, pteval.pte_low);
+}
+
+static inline void set_pmd(pmd_t *pmdp, pmd_t pmdval)
+{
+	PVOP_VCALL2(set_pmd, pmdp, pmdval.pud.pgd.pgd);
+}
+
+static inline pte_t raw_ptep_get_and_clear(pte_t *p)
+{
+	return (pte_t) { PVOP_CALL1(unsigned long, ptep_get_and_clear, p) };
+}
+#endif	/* CONFIG_X86_PAE */
 
 /* Lazy mode for batching updates / context switch */
 #define PARAVIRT_LAZY_NONE 0
@@ -488,12 +795,12 @@ static inline void pmd_clear(pmd_t *pmdp
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

xen-paravirt_ops-fix-typo-in-sync_constant_test_bits-name.patch
xen-paravirt_ops-use-paravirt_nop-to-consistently-mark-no-op-operations.patch
xen-paravirt_ops-add-pagetable-accessors-to-pack-and-unpack-pagetable-entries.patch
xen-paravirt_ops-paravirt_ops-hooks-to-set-up-initial-pagetable.patch
xen-paravirt_ops-paravirt_ops-allocate-a-fixmap-slot.patch
xen-paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
xen-paravirt_ops-add-hooks-to-intercept-mm-creation-and-destruction.patch
xen-paravirt_ops-remove-have_arch_mm_lifetime-define-no-op-architecture-implementations.patch
xen-paravirt_ops-rename-struct-paravirt_patch-to-paravirt_patch_site-for-clarity.patch
xen-paravirt_ops-use-patch-site-ids-computed-from-offset-in-paravirt_ops-structure.patch
xen-paravirt_ops-fix-patch-site-clobbers-to-include-return-register.patch
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
