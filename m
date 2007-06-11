From: akpm@linux-foundation.org
Subject: + remove-unneeded-test-of-task-in-dump_trace.patch added to -mm tree
Date: Mon, 11 Jun 2007 12:56:37 -0700
Message-ID: <200706111956.l5BJubb3027820@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46976 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755050AbXFKT4p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 Jun 2007 15:56:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jesper.juhl@gmail.com


The patch titled
     Remove unneeded test of 'task' in dump_trace()
has been added to the -mm tree.  Its filename is
     remove-unneeded-test-of-task-in-dump_trace.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -148,7 +148,7 @@ void dump_trace(struct task_struct *task
 	if (!stack) {
 		unsigned long dummy;
 		stack = &dummy;
-		if (task && task != current)
+		if (task != current)
 			stack = (unsigned long *)task->thread.esp;
 	}
 
_

Patches currently in -mm which might be from jesper.juhl@gmail.com are

remove-unneeded-test-of-task-in-dump_trace.patch
volatile-considered-harmful-take-3.patch
submitchecklist-update-fix-spelling-error.patch
