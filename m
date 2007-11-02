From: akpm@linux-foundation.org
Subject: + uml-implement-get_wchan-fix.patch added to -mm tree
Date: Fri, 02 Nov 2007 11:41:53 -0700
Message-ID: <200711021841.lA2Ifrkn005800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60473 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752720AbXKBSma (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Nov 2007 14:42:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdike@addtoit.com, jdike@linux.intel.com


The patch titled
     uml: get_wchan fixes
has been added to the -mm tree.  Its filename is
     uml-implement-get_wchan-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: uml: get_wchan fixes
From: Jeff Dike <jdike@addtoit.com>

The previous get_wchan patch needed some more work.  Joe Perches suggested the
use of bool where I was using a counter.  It also turned out not to work so
well on x86_64, so I changed the algorithm a bit.  Instead of skipping one
frame and looking for the next non-sched symbol, it now looks for at least one
scheduler frame, then returns the first symbol seen above that.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/process.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff -puN arch/um/kernel/process.c~uml-implement-get_wchan-fix arch/um/kernel/process.c
--- a/arch/um/kernel/process.c~uml-implement-get_wchan-fix
+++ a/arch/um/kernel/process.c
@@ -462,7 +462,8 @@ unsigned long arch_align_stack(unsigned 
 
 unsigned long get_wchan(struct task_struct *p)
 {
-	unsigned long stack_page, sp, ip, count = 0;
+	unsigned long stack_page, sp, ip;
+	bool seen_sched = 0;
 
 	if ((p == NULL) || (p == current) || (p->state == TASK_RUNNING))
 		return 0;
@@ -482,14 +483,11 @@ unsigned long get_wchan(struct task_stru
 
 	while (sp < stack_page + THREAD_SIZE) {
 		ip = *((unsigned long *) sp);
-		if (kernel_text_address(ip) && !in_sched_functions(ip)) {
-			/*
-			 * Skip one valid IP, which will be the low-level UML
-			 * context switcher.
-			 */
-			if (count++ == 1)
-				return ip;
-		}
+		if (in_sched_functions(ip))
+			/* Ignore everything until we're above the scheduler */
+			seen_sched = 1;
+		else if (kernel_text_address(ip) && seen_sched)
+			return ip;
 
 		sp += sizeof(unsigned long);
 	}
_

Patches currently in -mm which might be from jdike@addtoit.com are

uml-correctly-strip-kernel-defines-from-userspace-cflags.patch
git-kvm.patch
uml-fix-spurious-irq-testing.patch
uml-remove-last-include-of-libc-asm-pageh.patch
uml-fix-build-for-config_tcp.patch
uml-fix-build-for-config_printk.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
