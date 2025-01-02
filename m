Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D479DDC1;
	Thu,  2 Jan 2025 22:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735858273; cv=none; b=Mt1zEsKcJRtI+n3b9fp6lRXOLxQzkwt1eZUTf95tKvAoDB+cH/sXq7NHO6IAvWNBpZYfsCB7Uo8oexvzyzYIDHu44FF1FD9I96h3sH4iUks2bgJMWXm2dxnhsMZy1mKo6BfTv6bNrtSjJK7kj/mdC1emFn63sWH6IaWPQxTUbxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735858273; c=relaxed/simple;
	bh=z38s81y9cm1/CzpBNgO8ugNKLv4/6X6T6flzsxd4AGA=;
	h=Date:To:From:Subject:Message-Id; b=D7ilOvSApz4U5wIIfNrNh5v4QqITXHnQP7cf3FoeP3qpBp5VGUr+vKZKB+U52oJalhamC4Y2Cy8rGavsaSJEU8UacQO0oE32MdDU2aNbAMvc4Ku+ITZCkHrapjhDFOhU2ya5Mde/kTrKGmCHorRj6FoEDL1WHCZD/r9LEQ6q9yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sQNfb9Gv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sQNfb9Gv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B17C4CED0;
	Thu,  2 Jan 2025 22:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735858272;
	bh=z38s81y9cm1/CzpBNgO8ugNKLv4/6X6T6flzsxd4AGA=;
	h=Date:To:From:Subject:From;
	b=sQNfb9GvfPHxS7NqpsDVwIcbJfOXqHWi+CXl7hR9YbU+zjdYcvi5OZyJPOYv5fly9
	 vovfEfDPO74bLJ6HuB9IyT8vYJ0IZmOPEiDK39JWxBXid1LZCAFvsJRAmyf+q+sj3P
	 lKVPNKP1+09PFaL7gFTFSRL7LO/kC37a7QnWQp9Q=
Date: Thu, 02 Jan 2025 14:51:11 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,oleg@redhat.com,kees@kernel.org,john.ogness@linutronix.de,ebiederm@xmission.com,dylanbhatch@google.com,namcao@linutronix.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-do_task_stat-fix-esp-not-readable-during-coredump.patch added to mm-hotfixes-unstable branch
Message-Id: <20250102225112.82B17C4CED0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc: do_task_stat: fix ESP not readable during coredump
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-proc-do_task_stat-fix-esp-not-readable-during-coredump.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-do_task_stat-fix-esp-not-readable-during-coredump.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

fs-proc-do_task_stat-fix-esp-not-readable-during-coredump.patch
selftests-coredump-add-stackdump-test.patch

