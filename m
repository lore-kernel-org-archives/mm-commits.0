From: akpm@linux-foundation.org
Subject: - proc-environ-wrong-placing-of-ptrace_may_attach-check.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:55:07 -0700
Message-ID: <200707162055.l6GKt7O4001885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47591 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753468AbXGPVGy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:06:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     /proc/*/environ: wrong placing of ptrace_may_attach() check
has been removed from the -mm tree.  Its filename was
     proc-environ-wrong-placing-of-ptrace_may_attach-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: /proc/*/environ: wrong placing of ptrace_may_attach() check
From: Alexey Dobriyan <adobriyan@sw.ru>

It's a bit dopey-looking and can permit a task to cause a pagefault in an mm
which it doesn't have permission to read from.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN fs/proc/base.c~proc-environ-wrong-placing-of-ptrace_may_attach-check fs/proc/base.c
--- a/fs/proc/base.c~proc-environ-wrong-placing-of-ptrace_may_attach-check
+++ a/fs/proc/base.c
@@ -204,12 +204,17 @@ static int proc_pid_environ(struct task_
 	int res = 0;
 	struct mm_struct *mm = get_task_mm(task);
 	if (mm) {
-		unsigned int len = mm->env_end - mm->env_start;
+		unsigned int len;
+
+		res = -ESRCH;
+		if (!ptrace_may_attach(task))
+			goto out;
+
+		len  = mm->env_end - mm->env_start;
 		if (len > PAGE_SIZE)
 			len = PAGE_SIZE;
 		res = access_process_vm(task, mm->env_start, buffer, len, 0);
-		if (!ptrace_may_attach(task))
-			res = -ESRCH;
+out:
 		mmput(mm);
 	}
 	return res;
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
fix-sparse-false-positives-re-bug_onptr.patch
