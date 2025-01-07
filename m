Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9783B155335;
	Tue,  7 Jan 2025 03:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736219691; cv=none; b=gJAKgGPjMeEsGuKVRvzTFVcmgrevOOt+eSE8mSXcH9k7q/j7KOjPU/XpqPIqv+gWvA8uhrHWDtJRcoge2bNKsfnvWef8G28zq2LgegneWwsk6PmMQhOf39ddRsH22VVF0aW5NXcICODODvoQnQO/AWpIQ8tmIgUg8O0g5UdT8h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736219691; c=relaxed/simple;
	bh=RO98V8POhNu7VyMppJsNJ+N6fP9eJhec/SH8B+lJkbg=;
	h=Date:To:From:Subject:Message-Id; b=cVCWd4XK+4hRZoAuN8Nkg7Alky+CjxDRQBCPdETdkU65OC/XYwV3aXhhdlt5XvsKkp8fg1QvRhT+86SeiDOKcq2p3jEn9gQJOl1F50YqJ2i9nX9QrNdBz9orqwCJsPAr7dbz7E6ZqQ52lYDY/09+I7rg9sdIsbETgF+L5xH5E1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cGEY4usn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cGEY4usn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B76BC4CED2;
	Tue,  7 Jan 2025 03:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736219691;
	bh=RO98V8POhNu7VyMppJsNJ+N6fP9eJhec/SH8B+lJkbg=;
	h=Date:To:From:Subject:From;
	b=cGEY4usnHdqHEbXu8njdiTDwRNehI7DojxiQIcz3y6DmTIkrcXpS6KHLj5mqoKyEx
	 ee6VGcOY1SqMeeFiDNYhbZWijkpvsPdJBiVDCqpGCNMowxdBR6RX73mLW8kgctBNDd
	 ae5STv1n/fDdB4U25dufLDwGAxcXHfR4MHz4bpgs=
Date: Mon, 06 Jan 2025 19:14:50 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,oleg@redhat.com,kees@kernel.org,john.ogness@linutronix.de,ebiederm@xmission.com,dylanbhatch@google.com,namcao@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] fs-proc-do_task_stat-fix-esp-not-readable-during-coredump.patch removed from -mm tree
Message-Id: <20250107031451.1B76BC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc: do_task_stat: fix ESP not readable during coredump
has been removed from the -mm tree.  Its filename was
     fs-proc-do_task_stat-fix-esp-not-readable-during-coredump.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nam Cao <namcao@linutronix.de>
Subject: fs/proc: do_task_stat: fix ESP not readable during coredump
Date: Thu, 2 Jan 2025 09:22:56 +0100

The field "eip" (instruction pointer) and "esp" (stack pointer) of a task
can be read from /proc/PID/stat.  These fields can be interesting for
coredump.

However, these fields were disabled by commit 0a1eb2d474ed ("fs/proc: Stop
reporting eip and esp in /proc/PID/stat"), because it is generally unsafe
to do so.  But it is safe for a coredumping process, and therefore
exceptions were made:

  - for a coredumping thread by commit fd7d56270b52 ("fs/proc: Report
    eip/esp in /prod/PID/stat for coredumping").

  - for all other threads in a coredumping process by commit cb8f381f1613
    ("fs/proc/array.c: allow reporting eip/esp for all coredumping
    threads").

The above two commits check the PF_DUMPCORE flag to determine a coredump
thread and the PF_EXITING flag for the other threads.

Unfortunately, commit 92307383082d ("coredump: Don't perform any cleanups
before dumping core") moved coredump to happen earlier and before
PF_EXITING is set.  Thus, checking PF_EXITING is no longer the correct way
to determine threads in a coredumping process.

Instead of PF_EXITING, use PF_POSTCOREDUMP to determine the other threads.

Checking of PF_EXITING was added for coredumping, so it probably can now
be removed.  But it doesn't hurt to keep.

Link: https://lkml.kernel.org/r/d89af63d478d6c64cc46a01420b46fd6eb147d6f.1735805772.git.namcao@linutronix.de
Fixes: 92307383082d ("coredump:  Don't perform any cleanups before dumping core")
Signed-off-by: Nam Cao <namcao@linutronix.de>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Kees Cook <kees@kernel.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Dylan Hatch <dylanbhatch@google.com>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/array.c~fs-proc-do_task_stat-fix-esp-not-readable-during-coredump
+++ a/fs/proc/array.c
@@ -500,7 +500,7 @@ static int do_task_stat(struct seq_file
 		 * a program is not able to use ptrace(2) in that case. It is
 		 * safe because the task has stopped executing permanently.
 		 */
-		if (permitted && (task->flags & (PF_EXITING|PF_DUMPCORE))) {
+		if (permitted && (task->flags & (PF_EXITING|PF_DUMPCORE|PF_POSTCOREDUMP))) {
 			if (try_get_task_stack(task)) {
 				eip = KSTK_EIP(task);
 				esp = KSTK_ESP(task);
_

Patches currently in -mm which might be from namcao@linutronix.de are


