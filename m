From: akpm@linux-foundation.org
Subject: - asm-futexh-should-include-linux-uaccessh.patch removed from -mm tree
Date: Thu, 01 May 2008 02:32:29 -0700
Message-ID: <200805010932.m419WT14030992@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757568AbYEAJdL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:33:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, benh@kernel.crashing.org, davem@davemloft.net, jdike@linux.intel.com, kyle@mcmartin.ca, lethal@linux-sh.org, mingo@elte.hu, paulus@samba.org, ralf@linux-mips.orgt


The patch titled
     asm-*/futex.h should include linux/uaccess.h
has been removed from the -mm tree.  Its filename was
     asm-futexh-should-include-linux-uaccessh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: asm-*/futex.h should include linux/uaccess.h
From: Jeff Dike <jdike@addtoit.com>

Lots of asm-*/futex.h call pagefault_enable and pagefault_disable, which
are declared in linux/uaccess.h, without including linux/uaccess.h.

They all include asm/uaccess.h, so this patch replaces asm/uaccess.h
with linux/uaccess.h.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/futex.h |    2 +-
 include/asm-ia64/futex.h    |    2 +-
 include/asm-mips/futex.h    |    2 +-
 include/asm-parisc/futex.h  |    2 +-
 include/asm-powerpc/futex.h |    2 +-
 include/asm-sh/futex.h      |    2 +-
 include/asm-sparc64/futex.h |    2 +-
 include/asm-x86/futex.h     |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff -puN include/asm-generic/futex.h~asm-futexh-should-include-linux-uaccessh include/asm-generic/futex.h
--- a/include/asm-generic/futex.h~asm-futexh-should-include-linux-uaccessh
+++ a/include/asm-generic/futex.h
@@ -4,8 +4,8 @@
 #ifdef __KERNEL__
 
 #include <linux/futex.h>
+#include <linux/uaccess.h>
 #include <asm/errno.h>
-#include <asm/uaccess.h>
 
 static inline int
 futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
diff -puN include/asm-ia64/futex.h~asm-futexh-should-include-linux-uaccessh include/asm-ia64/futex.h
--- a/include/asm-ia64/futex.h~asm-futexh-should-include-linux-uaccessh
+++ a/include/asm-ia64/futex.h
@@ -2,9 +2,9 @@
 #define _ASM_FUTEX_H
 
 #include <linux/futex.h>
+#include <linux/uaccess.h>
 #include <asm/errno.h>
 #include <asm/system.h>
-#include <asm/uaccess.h>
 
 #define __futex_atomic_op1(insn, ret, oldval, uaddr, oparg) \
 do {									\
diff -puN include/asm-mips/futex.h~asm-futexh-should-include-linux-uaccessh include/asm-mips/futex.h
--- a/include/asm-mips/futex.h~asm-futexh-should-include-linux-uaccessh
+++ a/include/asm-mips/futex.h
@@ -11,9 +11,9 @@
 #ifdef __KERNEL__
 
 #include <linux/futex.h>
+#include <linux/uaccess.h>
 #include <asm/barrier.h>
 #include <asm/errno.h>
-#include <asm/uaccess.h>
 #include <asm/war.h>
 
 #define __futex_atomic_op(insn, ret, oldval, uaddr, oparg)		\
diff -puN include/asm-parisc/futex.h~asm-futexh-should-include-linux-uaccessh include/asm-parisc/futex.h
--- a/include/asm-parisc/futex.h~asm-futexh-should-include-linux-uaccessh
+++ a/include/asm-parisc/futex.h
@@ -4,8 +4,8 @@
 #ifdef __KERNEL__
 
 #include <linux/futex.h>
+#include <linux/uaccess.h>
 #include <asm/errno.h>
-#include <asm/uaccess.h>
 
 static inline int
 futex_atomic_op_inuser (int encoded_op, int __user *uaddr)
diff -puN include/asm-powerpc/futex.h~asm-futexh-should-include-linux-uaccessh include/asm-powerpc/futex.h
--- a/include/asm-powerpc/futex.h~asm-futexh-should-include-linux-uaccessh
+++ a/include/asm-powerpc/futex.h
@@ -4,9 +4,9 @@
 #ifdef __KERNEL__
 
 #include <linux/futex.h>
+#include <linux/uaccess.h>
 #include <asm/errno.h>
 #include <asm/synch.h>
-#include <asm/uaccess.h>
 #include <asm/asm-compat.h>
 
 #define __futex_atomic_op(insn, ret, oldval, uaddr, oparg) \
diff -puN include/asm-sh/futex.h~asm-futexh-should-include-linux-uaccessh include/asm-sh/futex.h
--- a/include/asm-sh/futex.h~asm-futexh-should-include-linux-uaccessh
+++ a/include/asm-sh/futex.h
@@ -4,8 +4,8 @@
 #ifdef __KERNEL__
 
 #include <linux/futex.h>
+#include <linux/uaccess.h>
 #include <asm/errno.h>
-#include <asm/uaccess.h>
 
 /* XXX: UP variants, fix for SH-4A and SMP.. */
 #include <asm/futex-irq.h>
diff -puN include/asm-sparc64/futex.h~asm-futexh-should-include-linux-uaccessh include/asm-sparc64/futex.h
--- a/include/asm-sparc64/futex.h~asm-futexh-should-include-linux-uaccessh
+++ a/include/asm-sparc64/futex.h
@@ -2,9 +2,9 @@
 #define _SPARC64_FUTEX_H
 
 #include <linux/futex.h>
+#include <linux/uaccess.h>
 #include <asm/errno.h>
 #include <asm/system.h>
-#include <asm/uaccess.h>
 
 #define __futex_cas_op(insn, ret, oldval, uaddr, oparg)	\
 	__asm__ __volatile__(				\
diff -puN include/asm-x86/futex.h~asm-futexh-should-include-linux-uaccessh include/asm-x86/futex.h
--- a/include/asm-x86/futex.h~asm-futexh-should-include-linux-uaccessh
+++ a/include/asm-x86/futex.h
@@ -4,12 +4,12 @@
 #ifdef __KERNEL__
 
 #include <linux/futex.h>
+#include <linux/uaccess.h>
 
 #include <asm/asm.h>
 #include <asm/errno.h>
 #include <asm/processor.h>
 #include <asm/system.h>
-#include <asm/uaccess.h>
 
 #define __futex_atomic_op1(insn, ret, oldval, uaddr, oparg)	\
 	asm volatile("1:\t" insn "\n"				\
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
rename-div64_64-to-div64_u64.patch
git-kvm.patch

