From: akpm@linux-foundation.org
Subject: - remove-unneeded-test-of-task-in-dump_trace.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:09:56 -0700
Message-ID: <200707192009.l6JK9ueJ020620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33530 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752378AbXGSUPH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.juhl@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Remove unneeded test of 'task' in dump_trace()
has been removed from the -mm tree.  Its filename was
     remove-unneeded-test-of-task-in-dump_trace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove unneeded test of 'task' in dump_trace()
From: Jesper Juhl <jesper.juhl@gmail.com>

Remove unneeded test of task != NULL from
arch/i386/kernel/traps.c::dump_trace()

At the start of the function we have this test:
        if (!task)
                task = current;
so further down there's no need to test 'task'.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/traps.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/kernel/traps.c~remove-unneeded-test-of-task-in-dump_trace arch/i386/kernel/traps.c
--- a/arch/i386/kernel/traps.c~remove-unneeded-test-of-task-in-dump_trace
+++ a/arch/i386/kernel/traps.c
@@ -216,7 +216,7 @@ void dump_trace(struct task_struct *task
 	if (!stack) {
 		unsigned long dummy;
 		stack = &dummy;
-		if (task && task != current)
+		if (task != current)
 			stack = (unsigned long *)task->thread.esp;
 	}
 
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

origin.patch
fix-acpi_ev_pci_config_region_setup-to-avoid-memory-leak.patch
git-gfs2-nmw.patch
git-mtd.patch
git-xfs.patch
floppy-do-a-very-minimal-style-cleanup-of-the-floppy-driver.patch
floppy-remove-dead-commented-out-code-from-floppy-driver.patch
floppy-remove-register-keyword-use-from-floppy-driver.patch
