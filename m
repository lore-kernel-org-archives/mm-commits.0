From: akpm@linux-foundation.org
Subject: - uml-dont-kill-pid-0.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:37:42 -0800
Message-ID: <200802052237.m15MbNdW012848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55120 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760840AbYBEWlX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:41:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: don't kill pid 0
has been removed from the -mm tree.  Its filename was
     uml-dont-kill-pid-0.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: uml: don't kill pid 0
From: Jeff Dike <jdike@addtoit.com>

A bit of defensive programming - during development, it ocassionally
happens that a call to init_new_context is missed, resulting in
context holding a host pid of zero.  When that address space is torn
down, destroy_context does a kill(0), which instantly kills the whole
UML without any errors whatsoever.

This patch add a check for pids less than 2, to also catch 1 and
negative pids.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/kernel/skas/mmu.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN arch/um/kernel/skas/mmu.c~uml-dont-kill-pid-0 arch/um/kernel/skas/mmu.c
--- a/arch/um/kernel/skas/mmu.c~uml-dont-kill-pid-0
+++ a/arch/um/kernel/skas/mmu.c
@@ -164,8 +164,20 @@ void destroy_context(struct mm_struct *m
 
 	if (proc_mm)
 		os_close_file(mmu->id.u.mm_fd);
-	else
+	else {
+		/*
+		 * If init_new_context wasn't called, this will be
+		 * zero, resulting in a kill(0), which will result in the
+		 * whole UML suddenly dying.  Also, cover negative and
+		 * 1 cases, since they shouldn't happen either.
+		 */
+		if (mmu->id.u.pid < 2) {
+			printk(KERN_ERR "corrupt mm_context - pid = %d\n",
+			       mmu->id.u.pid);
+			return;
+		}
 		os_kill_ptraced_process(mmu->id.u.pid, 1);
+	}
 
 	if (skas_needs_stub)
 		free_page(mmu->id.stack);
_

Patches currently in -mm which might be from jdike@addtoit.com are

origin.patch
git-kvm.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-uml-re-remove-accidentally-restored-code.patch
random-add-async-notification-support-to-dev-random.patch
mount-options-fix-hostfs.patch
