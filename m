From: akpm@linux-foundation.org
Subject: + x86_64-arch_pick_mmap_layout-fixlet.patch added to -mm tree
Date: Mon, 02 Jul 2007 21:49:24 -0700
Message-ID: <200707030449.l634nOrI032408@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37416 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751177AbXGCEup (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 00:50:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, ak@suse.de


The patch titled
     x86_64: arch_pick_mmap_layout() fixlet
has been added to the -mm tree.  Its filename is
     x86_64-arch_pick_mmap_layout-fixlet.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: arch_pick_mmap_layout() fixlet
From: Alexey Dobriyan <adobriyan@sw.ru>

sparse now warns about
arch/x86_64/mm/mmap.c:15:3: warning: returning void-valued expression

Generated code looks correct: there is jump to the end of
arch_pick_mmap_layout() after ia32_pick_mmap_layout(), but this should be
fixed regardless.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/mmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN arch/x86_64/mm/mmap.c~x86_64-arch_pick_mmap_layout-fixlet arch/x86_64/mm/mmap.c
--- a/arch/x86_64/mm/mmap.c~x86_64-arch_pick_mmap_layout-fixlet
+++ a/arch/x86_64/mm/mmap.c
@@ -11,8 +11,10 @@
 void arch_pick_mmap_layout(struct mm_struct *mm)
 {
 #ifdef CONFIG_IA32_EMULATION
-	if (current_thread_info()->flags & _TIF_IA32)
-		return ia32_pick_mmap_layout(mm);
+	if (current_thread_info()->flags & _TIF_IA32) {
+		ia32_pick_mmap_layout(mm);
+		return;
+	}
 #endif
 	mm->mmap_base = TASK_UNMAPPED_BASE;
 	if (current->flags & PF_RANDOMIZE) {
_

Patches currently in -mm which might be from adobriyan@sw.ru are

x86_64-arch_pick_mmap_layout-fixlet.patch
make-proc-slabinfo-use-seq_list_xxx-helpers-fix.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-cleanup.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
proc-environ-wrong-placing-of-ptrace_may_attach-check.patch
mutex_unlock-later-in-seq_lseek.patch
seq_file-more-atomicity-in-traverse.patch
