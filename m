From: akpm@linux-foundation.org
Subject: + proc-environ-wrong-placing-of-ptrace_may_attach-check.patch added to -mm tree
Date: Tue, 29 May 2007 17:16:29 -0700
Message-ID: <200705300016.l4U0GTdF015159@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751511AbXE3ARJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 20:17:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru


The patch titled
     /proc/*/environ: wrong placing of ptrace_may_attach() check
has been added to the -mm tree.  Its filename is
     proc-environ-wrong-placing-of-ptrace_may_attach-check.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: /proc/*/environ: wrong placing of ptrace_may_attach() check
From: Alexey Dobriyan <adobriyan@sw.ru>

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

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

fix-vmic-compilation.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-cleanup.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
proc-environ-wrong-placing-of-ptrace_may_attach-check.patch
