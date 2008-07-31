From: akpm@linux-foundation.org
Subject: + missing-symbol-prefix-on-vmlinuxldsh.patch added to -mm tree
Date: Wed, 30 Jul 2008 19:07:12 -0700
Message-ID: <200807310207.m6V27CcY030560@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44486 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861AbYGaCIH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 22:08:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ysato@users.sourceforge.jp, jeremy@goop.org


The patch titled
     Missing symbol prefix on vmlinux.lds.h
has been added to the -mm tree.  Its filename is
     missing-symbol-prefix-on-vmlinuxldsh.patch

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

Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
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
+	  	VMLINUX_SYMBOL(__tracedata_start) = .;			\
 		*(.tracedata)						\
-	  	__tracedata_end = .;					\
+	  	VMLINUX_SYMBOL(__tracedata_end) = .;			\
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

missing-symbol-prefix-on-vmlinuxldsh.patch

