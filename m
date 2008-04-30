From: akpm@linux-foundation.org
Subject: + frv-unbreak-misalignment-handling-changes.patch added to -mm tree
Date: Wed, 30 Apr 2008 05:04:16 -0700
Message-ID: <200804301204.m3UC4Gxg012410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759659AbYD3MEh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 08:04:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, harvey.harrison@gmail.com


The patch titled
     frv: unbreak misalignment handling changes
has been added to the -mm tree.  Its filename is
     frv-unbreak-misalignment-handling-changes.patch

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
alloc_uid-cleanup.patch
frv-unbreak-misalignment-handling-changes.patch
git-unionfs.patch
rename-div64_64-to-div64_u64.patch
mutex-subsystem-synchro-test-module.patch

