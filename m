From: akpm@linux-foundation.org
Subject: - paravirt_ops-clean-up-paravirt-patchable-wrappers.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:30:24 -0700
Message-ID: <200704132330.l3DNUOoU012735@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60673 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161224AbXDMXae (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:30:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy@goop.org, jeremy@xensource.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     paravirt_ops: clean up paravirt patchable wrappers
has been removed from the -mm tree.  Its filename was
     paravirt_ops-clean-up-paravirt-patchable-wrappers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: paravirt_ops: clean up paravirt patchable wrappers
From: Jeremy Fitzhardinge <jeremy@goop.org>

Replace all the open-coded macros for generating calls with a pair of more
general macros (__PVOP_CALL/VCALL), and redefine all the PVOP_V?CALL[0-4]
in terms of them.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/paravirt.h |  248 ++++++++--------------------------
 1 file changed, 60 insertions(+), 188 deletions(-)

diff -puN include/asm-i386/paravirt.h~paravirt_ops-clean-up-paravirt-patchable-wrappers include/asm-i386/paravirt.h
--- a/include/asm-i386/paravirt.h~paravirt_ops-clean-up-paravirt-patchable-wrappers
+++ a/include/asm-i386/paravirt.h
@@ -312,211 +312,81 @@ extern struct paravirt_ops paravirt_ops;
  * means that all uses must be wrapped in inline functions.  This also
  * makes sure the incoming and outgoing types are always correct.
  */
-#define PVOP_CALL0(__rettype, __op)					\
-	({								\
-		__rettype __ret;					\
-		if (sizeof(__rettype) > sizeof(unsigned long)) {	\
-			unsigned long long __tmp;			\
-			unsigned long __ecx;				\
-			asm volatile(paravirt_alt(PARAVIRT_CALL)	\
-				     : "=A" (__tmp), "=c" (__ecx)	\
-				     : paravirt_type(__op),		\
-				       paravirt_clobber(CLBR_ANY)	\
-				     : "memory", "cc");			\
-			__ret = (__rettype)__tmp;			\
-		} else {						\
-			unsigned long __tmp, __edx, __ecx;		\
-			asm volatile(paravirt_alt(PARAVIRT_CALL)	\
-				     : "=a" (__tmp), "=d" (__edx),	\
-				       "=c" (__ecx)			\
-				     : paravirt_type(__op),		\
-				       paravirt_clobber(CLBR_ANY)	\
-				     : "memory", "cc");			\
-			__ret = (__rettype)__tmp;			\
-		}							\
-		__ret;							\
-	})
-#define PVOP_VCALL0(__op)						\
+#define __PVOP_CALL(rettype, op, pre, post, ...)			\
 	({								\
+		rettype __ret;						\
 		unsigned long __eax, __edx, __ecx;			\
-		asm volatile(paravirt_alt(PARAVIRT_CALL)		\
-			     : "=a" (__eax), "=d" (__edx), "=c" (__ecx) \
-			     : paravirt_type(__op),			\
-			       paravirt_clobber(CLBR_ANY)		\
-			     : "memory", "cc");				\
-	})
-
-#define PVOP_CALL1(__rettype, __op, arg1)				\
-	({								\
-		__rettype __ret;					\
-		if (sizeof(__rettype) > sizeof(unsigned long)) {	\
-			unsigned long long __tmp;			\
-			unsigned long __ecx;				\
-			asm volatile(paravirt_alt(PARAVIRT_CALL)	\
-				     : "=A" (__tmp), "=c" (__ecx)	\
-				     : "a" ((u32)(arg1)),		\
-				       paravirt_type(__op),		\
-				       paravirt_clobber(CLBR_ANY)	\
-				     : "memory", "cc");			\
-			__ret = (__rettype)__tmp;			\
-		} else {						\
-			unsigned long __tmp, __edx, __ecx;		\
-			asm volatile(paravirt_alt(PARAVIRT_CALL)	\
-				     : "=a" (__tmp), "=d" (__edx),	\
-				       "=c" (__ecx)			\
-				     : "0" ((u32)(arg1)),		\
-				       paravirt_type(__op),		\
-				       paravirt_clobber(CLBR_ANY)	\
-				     : "memory", "cc");			\
-			__ret = (__rettype)__tmp;			\
-		}							\
-		__ret;							\
-	})
-#define PVOP_VCALL1(__op, arg1)						\
-	({								\
-		unsigned long __eax, __edx, __ecx;			\
-		asm volatile(paravirt_alt(PARAVIRT_CALL)		\
-			     : "=a" (__eax), "=d" (__edx), "=c" (__ecx) \
-			     : "0" ((u32)(arg1)),			\
-			       paravirt_type(__op),			\
-			       paravirt_clobber(CLBR_ANY)		\
-			     : "memory", "cc");				\
-	})
-
-#define PVOP_CALL2(__rettype, __op, arg1, arg2)				\
-	({								\
-		__rettype __ret;					\
-		if (sizeof(__rettype) > sizeof(unsigned long)) {	\
-			unsigned long long __tmp;			\
-			unsigned long __ecx;				\
-			asm volatile(paravirt_alt(PARAVIRT_CALL)	\
-				     : "=A" (__tmp), "=c" (__ecx)	\
-				     : "a" ((u32)(arg1)),		\
-				       "d" ((u32)(arg2)),		\
-				       paravirt_type(__op),		\
-				       paravirt_clobber(CLBR_ANY)	\
-				     : "memory", "cc");			\
-			__ret = (__rettype)__tmp;			\
-		} else {						\
-			unsigned long __tmp, __edx, __ecx;		\
-			asm volatile(paravirt_alt(PARAVIRT_CALL)	\
-				     : "=a" (__tmp), "=d" (__edx),	\
-				       "=c" (__ecx)			\
-				     : "0" ((u32)(arg1)),		\
-				       "1" ((u32)(arg2)),		\
-				       paravirt_type(__op),		\
-				       paravirt_clobber(CLBR_ANY)	\
-				     : "memory", "cc");			\
-			__ret = (__rettype)__tmp;			\
-		}							\
-		__ret;							\
-	})
-#define PVOP_VCALL2(__op, arg1, arg2)					\
-	({								\
-		unsigned long __eax, __edx, __ecx;			\
-		asm volatile(paravirt_alt(PARAVIRT_CALL)		\
-			     : "=a" (__eax), "=d" (__edx), "=c" (__ecx) \
-			     : "0" ((u32)(arg1)),			\
-			       "1" ((u32)(arg2)),			\
-			       paravirt_type(__op),			\
-			       paravirt_clobber(CLBR_ANY)		\
-			     : "memory", "cc");				\
-	})
-
-#define PVOP_CALL3(__rettype, __op, arg1, arg2, arg3)			\
-	({								\
-		__rettype __ret;					\
-		if (sizeof(__rettype) > sizeof(unsigned long)) {	\
-			unsigned long long __tmp;			\
-			unsigned long __ecx;				\
-			asm volatile(paravirt_alt(PARAVIRT_CALL)	\
-				     : "=A" (__tmp), "=c" (__ecx)	\
-				     : "a" ((u32)(arg1)),		\
-				       "d" ((u32)(arg2)),		\
-				       "1" ((u32)(arg3)),		\
-				       paravirt_type(__op),		\
-				       paravirt_clobber(CLBR_ANY)	\
-				     : "memory", "cc");			\
-			__ret = (__rettype)__tmp;			\
-		} else {						\
-			unsigned long __tmp, __edx, __ecx;	\
-			asm volatile(paravirt_alt(PARAVIRT_CALL)	\
-				     : "=a" (__tmp), "=d" (__edx),	\
+		if (sizeof(rettype) > sizeof(unsigned long)) {		\
+			asm volatile(pre				\
+				     paravirt_alt(PARAVIRT_CALL)	\
+				     post				\
+				     : "=a" (__eax), "=d" (__edx),	\
 				       "=c" (__ecx)			\
-				     : "0" ((u32)(arg1)),		\
-				       "1" ((u32)(arg2)),		\
-				       "2" ((u32)(arg3)),		\
-				       paravirt_type(__op),		\
-				       paravirt_clobber(CLBR_ANY)	\
+				     : paravirt_type(op),		\
+				       paravirt_clobber(CLBR_ANY),	\
+				       ##__VA_ARGS__			\
 				     : "memory", "cc");			\
-			__ret = (__rettype)__tmp;			\
-		}							\
-		__ret;							\
-	})
-#define PVOP_VCALL3(__op, arg1, arg2, arg3)				\
-	({								\
-		unsigned long __eax, __edx, __ecx;			\
-		asm volatile(paravirt_alt(PARAVIRT_CALL)		\
-			     : "=a" (__eax), "=d" (__edx), "=c" (__ecx) \
-			     : "0" ((u32)(arg1)),			\
-			       "1" ((u32)(arg2)),			\
-			       "2" ((u32)(arg3)),			\
-			       paravirt_type(__op),			\
-			       paravirt_clobber(CLBR_ANY)		\
-			     : "memory", "cc");				\
-	})
-
-#define PVOP_CALL4(__rettype, __op, arg1, arg2, arg3, arg4)		\
-	({								\
-		__rettype __ret;					\
-		if (sizeof(__rettype) > sizeof(unsigned long)) {	\
-			unsigned long long __tmp;			\
-			unsigned long __ecx;				\
-			asm volatile("push %[_arg4]; "			\
-				     paravirt_alt(PARAVIRT_CALL)	\
-				     "lea 4(%%esp),%%esp"		\
-				     : "=A" (__tmp), "=c" (__ecx)	\
-				     : "a" ((u32)(arg1)),		\
-				       "d" ((u32)(arg2)),		\
-				       "1" ((u32)(arg3)),		\
-				       [_arg4] "mr" ((u32)(arg4)),	\
-				       paravirt_type(__op),		\
-				       paravirt_clobber(CLBR_ANY)	\
-				     : "memory", "cc",);		\
-			__ret = (__rettype)__tmp;			\
+			__ret = (rettype)((((u64)__edx) << 32) | __eax); \
 		} else {						\
-			unsigned long __tmp, __edx, __ecx;		\
-			asm volatile("push %[_arg4]; "			\
+			asm volatile(pre				\
 				     paravirt_alt(PARAVIRT_CALL)	\
-				     "lea 4(%%esp),%%esp"		\
-				     : "=a" (__tmp), "=d" (__edx), "=c" (__ecx) \
-				     : "0" ((u32)(arg1)),		\
-				       "1" ((u32)(arg2)),		\
-				       "2" ((u32)(arg3)),		\
-				       [_arg4]"mr" ((u32)(arg4)),	\
-				       paravirt_type(__op),		\
-				       paravirt_clobber(CLBR_ANY)	\
+				     post				\
+				     : "=a" (__eax), "=d" (__edx),	\
+				       "=c" (__ecx)			\
+				     : paravirt_type(op),		\
+				       paravirt_clobber(CLBR_ANY),	\
+				       ##__VA_ARGS__			\
 				     : "memory", "cc");			\
-			__ret = (__rettype)__tmp;			\
+			__ret = (rettype)__eax;				\
 		}							\
 		__ret;							\
 	})
-#define PVOP_VCALL4(__op, arg1, arg2, arg3, arg4)			\
+#define __PVOP_VCALL(op, pre, post, ...)				\
 	({								\
 		unsigned long __eax, __edx, __ecx;			\
-		asm volatile("push %[_arg4]; "				\
+		asm volatile(pre					\
 			     paravirt_alt(PARAVIRT_CALL)		\
-			     "lea 4(%%esp),%%esp"			\
+			     post					\
 			     : "=a" (__eax), "=d" (__edx), "=c" (__ecx) \
-			     : "0" ((u32)(arg1)),			\
-			       "1" ((u32)(arg2)),			\
-			       "2" ((u32)(arg3)),			\
-			       [_arg4]"mr" ((u32)(arg4)),		\
-			       paravirt_type(__op),			\
-			       paravirt_clobber(CLBR_ANY)		\
+			     : paravirt_type(op),			\
+			       paravirt_clobber(CLBR_ANY),		\
+			       ##__VA_ARGS__				\
 			     : "memory", "cc");				\
 	})
 
+#define PVOP_CALL0(rettype, op)						\
+	__PVOP_CALL(rettype, op, "", "")
+#define PVOP_VCALL0(op)							\
+	__PVOP_VCALL(op, "", "")
+
+#define PVOP_CALL1(rettype, op, arg1)					\
+	__PVOP_CALL(rettype, op, "", "", "0" ((u32)(arg1)))
+#define PVOP_VCALL1(op, arg1)						\
+	__PVOP_VCALL(op, "", "", "0" ((u32)(arg1)))
+
+#define PVOP_CALL2(rettype, op, arg1, arg2)				\
+	__PVOP_CALL(rettype, op, "", "", "0" ((u32)(arg1)), "1" ((u32)(arg2)))
+#define PVOP_VCALL2(op, arg1, arg2)					\
+	__PVOP_VCALL(op, "", "", "0" ((u32)(arg1)), "1" ((u32)(arg2)))
+
+#define PVOP_CALL3(rettype, op, arg1, arg2, arg3)			\
+	__PVOP_CALL(rettype, op, "", "", "0" ((u32)(arg1)),		\
+		    "1"((u32)(arg2)), "2"((u32)(arg3)))
+#define PVOP_VCALL3(op, arg1, arg2, arg3)				\
+	__PVOP_VCALL(op, "", "", "0" ((u32)(arg1)), "1"((u32)(arg2)),	\
+		     "2"((u32)(arg3)))
+
+#define PVOP_CALL4(rettype, op, arg1, arg2, arg3, arg4)			\
+	__PVOP_CALL(rettype, op,					\
+		    "push %[_arg4];", "lea 4(%%esp),%%esp;",		\
+		    "0" ((u32)(arg1)), "1" ((u32)(arg2)),		\
+		    "2" ((u32)(arg3)), [_arg4] "mr" ((u32)(arg4)))
+#define PVOP_VCALL4(op, arg1, arg2, arg3, arg4)				\
+	__PVOP_VCALL(op,						\
+		    "push %[_arg4];", "lea 4(%%esp),%%esp;",		\
+		    "0" ((u32)(arg1)), "1" ((u32)(arg2)),		\
+		    "2" ((u32)(arg3)), [_arg4] "mr" ((u32)(arg4)))
+
 static inline int paravirt_enabled(void)
 {
 	return paravirt_ops.paravirt_enabled;
@@ -1119,6 +989,8 @@ static inline unsigned long __raw_local_
 
 /* Make sure as little as possible of this mess escapes. */
 #undef PARAVIRT_CALL
+#undef __PVOP_CALL
+#undef __PVOP_VCALL
 #undef PVOP_VCALL0
 #undef PVOP_CALL0
 #undef PVOP_VCALL1
_

Patches currently in -mm which might be from jeremy@goop.org are

origin.patch
revert-proper-fix-for-highmem-kmap_atomic-functions-for-vmi-for-2621.patch
revert-x86_64-mm-account-for-module-percpu-space-separately-from-kernel-percpu.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others.patch
rename-the-parainstructions-symbols-to-be-consistent-with-the-others-fix.patch
allow-boot-time-disable-of-paravirt_ops-patching.patch
x86-clean-up-identify_cpu-update.patch
i386-map-enough-initial-memory-to-create-lowmem-mappings.patch
mm-only-i386-for-debugging-make-the-initial-page-table-setup-less-forgiving.patch
maps2-uninline-some-functions-in-the-page-walker.patch
maps2-eliminate-the-pmd_walker-struct-in-the-page-walker.patch
maps2-remove-vma-from-args-in-the-page-walker.patch
maps2-propagate-errors-from-callback-in-page-walker.patch
maps2-add-callbacks-for-each-level-to-page-walker.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-simplify-interdependence-of-proc-pid-maps-and-smaps.patch
maps2-move-clear_refs-code-to-task_mmuc.patch
maps2-regroup-task_mmu-by-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embedded.patch
maps2-make-proc-pid-clear_refs-option-under-config_embedded.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-add-proc-kpagemap-interface.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
ignore-stolen-time-in-the-softlockup-watchdog.patch
add-touch_all_softlockup_watchdogs.patch
clean-up-elf-note-generation.patch
deflate-stack-usage-in-lib-inflatec.patch
