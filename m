From: akpm@linux-foundation.org
Subject: - m68knommu-start-dump-from-exception-stack.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:04:24 -0700
Message-ID: <200707192004.l6JK4OvN019946@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57572 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761915AbXGSU0i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:26:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerg@snapgear.com, gerg@uclinux.org, phdm@macqel.be, mm-commits@vger.kernel.org


The patch titled
     m68knommu: start dump from exception stack
has been removed from the -mm tree.  Its filename was
     m68knommu-start-dump-from-exception-stack.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: m68knommu: start dump from exception stack
From: Greg Ungerer <gerg@snapgear.com>

In die_if_kernel() start the stack dump at the exception-time SP, not at the
SP with all the saved registers; the stack below exception-time sp contains
only exception-saved values and is already printed in details just before.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>
Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/kernel/traps.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/m68knommu/kernel/traps.c~m68knommu-start-dump-from-exception-stack arch/m68knommu/kernel/traps.c
--- a/arch/m68knommu/kernel/traps.c~m68knommu-start-dump-from-exception-stack
+++ a/arch/m68knommu/kernel/traps.c
@@ -80,7 +80,7 @@ void die_if_kernel(char *str, struct pt_
 
 	printk(KERN_EMERG "Process %s (pid: %d, stackpage=%08lx)\n",
 		current->comm, current->pid, PAGE_SIZE+(unsigned long)current);
-	show_stack(NULL, (unsigned long *)fp);
+	show_stack(NULL, (unsigned long *)(fp + 1));
 	add_taint(TAINT_DIE);
 	do_exit(SIGSEGV);
 }
_

Patches currently in -mm which might be from gerg@snapgear.com are

origin.patch
git-mtd.patch
