From: akpm@linux-foundation.org
Subject: - frv-unbreak-misalignment-handling-changes.patch removed from -mm tree
Date: Fri, 02 May 2008 12:41:47 -0700
Message-ID: <200805021941.m42Jfl8t011109@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757578AbYEBTmH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:42:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     frv: unbreak misalignment handling changes
has been removed from the -mm tree.  Its filename was
     frv-unbreak-misalignment-handling-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: frv: unbreak misalignment handling changes
From: David Howells <dhowells@redhat.com>

Fix a reference in a arch/frv/mm/Makefile to unaligned.c which has now been
deleted.

Also revert the change to the guard macro name in include/asm-frv/unaligned.h.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/frv/mm/Makefile        |    2 +-
 include/asm-frv/unaligned.h |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/frv/mm/Makefile~frv-unbreak-misalignment-handling-changes arch/frv/mm/Makefile
--- a/arch/frv/mm/Makefile~frv-unbreak-misalignment-handling-changes
+++ a/arch/frv/mm/Makefile
@@ -6,4 +6,4 @@ obj-y := init.o kmap.o
 
 obj-$(CONFIG_MMU) += \
 	pgalloc.o highmem.o fault.o extable.o cache-page.o tlb-flush.o tlb-miss.o \
-	mmu-context.o dma-alloc.o unaligned.o elf-fdpic.o
+	mmu-context.o dma-alloc.o elf-fdpic.o
diff -puN include/asm-frv/unaligned.h~frv-unbreak-misalignment-handling-changes include/asm-frv/unaligned.h
--- a/include/asm-frv/unaligned.h~frv-unbreak-misalignment-handling-changes
+++ a/include/asm-frv/unaligned.h
@@ -9,8 +9,8 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#ifndef _ASM_FRV_UNALIGNED_H
-#define _ASM_FRV_UNALIGNED_H
+#ifndef _ASM_UNALIGNED_H
+#define _ASM_UNALIGNED_H
 
 #include <linux/unaligned/le_byteshift.h>
 #include <linux/unaligned/be_byteshift.h>
@@ -19,4 +19,4 @@
 #define get_unaligned	__get_unaligned_be
 #define put_unaligned	__put_unaligned_be
 
-#endif /* _ASM_FRV_UNALIGNED_H */
+#endif /* _ASM_UNALIGNED_H */
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
git-unionfs.patch
mutex-subsystem-synchro-test-module.patch

