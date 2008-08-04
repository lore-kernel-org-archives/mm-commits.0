From: akpm@linux-foundation.org
Subject: - missing-symbol-prefix-on-vmlinuxldsh.patch removed from -mm tree
Date: Mon, 04 Aug 2008 13:05:54 -0700
Message-ID: <200808042005.m74K5shH027630@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756953AbYHDUGM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 16:06:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ysato@users.sourceforge.jp, jeremy@goop.org, vapier.adi@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Missing symbol prefix on vmlinux.lds.h
has been removed from the -mm tree.  Its filename was
     missing-symbol-prefix-on-vmlinuxldsh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Missing symbol prefix on vmlinux.lds.h
From: Yoshinori Sato <ysato@users.sourceforge.jp>

ARCH=h8300:

init/main.c:781: undefined reference to `___early_initcall_end'

Same problem have
__start___bug_table
__stop___bug_table
__tracedata_start
__tracedata_end
__per_cpu_start
__per_cpu_end

When defining a symbol in vmlinux.lds, use the VMLINUX_SYMBOL macro. 
VMLINUX_SYMBOL adds a prefix charactor.

You can't just use straight symbol names in common header files as they
dont take into consideration weird arch-specific ABI conventions.  in the
case of Blackfin/h8300, the ABI dictates that any C-visible symbols have
an underscore prefixed to them.  Thus all symbols in vmlinux.lds.h need to
be wrapped in VMLINUX_SYMBOL() so that each arch can put hide this magic
in their own files.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Mike Frysinger" <vapier.adi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/vmlinux.lds.h |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN include/asm-generic/vmlinux.lds.h~missing-symbol-prefix-on-vmlinuxldsh include/asm-generic/vmlinux.lds.h
--- a/include/asm-generic/vmlinux.lds.h~missing-symbol-prefix-on-vmlinuxldsh
+++ a/include/asm-generic/vmlinux.lds.h
@@ -333,9 +333,9 @@
 #define BUG_TABLE							\
 	. = ALIGN(8);							\
 	__bug_table : AT(ADDR(__bug_table) - LOAD_OFFSET) {		\
-		__start___bug_table = .;				\
+		VMLINUX_SYMBOL(__start___bug_table) = .;		\
 		*(__bug_table)						\
-		__stop___bug_table = .;					\
+		VMLINUX_SYMBOL(__stop___bug_table) = .;			\
 	}
 #else
 #define BUG_TABLE
@@ -345,9 +345,9 @@
 #define TRACEDATA							\
 	. = ALIGN(4);							\
 	.tracedata : AT(ADDR(.tracedata) - LOAD_OFFSET) {		\
-	  	__tracedata_start = .;					\
+		VMLINUX_SYMBOL(__tracedata_start) = .;			\
 		*(.tracedata)						\
-	  	__tracedata_end = .;					\
+		VMLINUX_SYMBOL(__tracedata_end) = .;			\
 	}
 #else
 #define TRACEDATA
@@ -362,7 +362,7 @@
 
 #define INITCALLS							\
 	*(.initcallearly.init)						\
-	__early_initcall_end = .;					\
+	VMLINUX_SYMBOL(__early_initcall_end) = .;			\
   	*(.initcall0.init)						\
   	*(.initcall0s.init)						\
   	*(.initcall1.init)						\
@@ -383,9 +383,9 @@
 
 #define PERCPU(align)							\
 	. = ALIGN(align);						\
-	__per_cpu_start = .;						\
+	VMLINUX_SYMBOL(__per_cpu_start) = .;				\
 	.data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {		\
 		*(.data.percpu)						\
 		*(.data.percpu.shared_aligned)				\
 	}								\
-	__per_cpu_end = .;
+	VMLINUX_SYMBOL(__per_cpu_end) = .;
_

Patches currently in -mm which might be from ysato@users.sourceforge.jp are

origin.patch

