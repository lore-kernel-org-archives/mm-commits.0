Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1E63D561
	for <mm-commits@vger.kernel.org>; Tue, 28 Jan 2025 00:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738024925; cv=none; b=CRZDd+AJkO/DfZUUiJNbBW/Wdr9Kc116EEazjUQxcTvK9qJJ05jSiwTfmrSWTK7PIzrOSAmSmR3qaJ/RgVBAJYhrUUh622jLnhmilQ3EONaX8wW9DBGxxE/XObEKU/R+hxQSHn/aR33+UzIPkMhyF4PeNuNQaNuBIQUck+LUY8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738024925; c=relaxed/simple;
	bh=ae0mT2EFmGlMQPct86345SqPFLkjA81rasHAYQe6AE0=;
	h=Date:To:From:Subject:Message-Id; b=elP3q/tpxD/ADDR4tSNno0D4JqfV8nud3y0qtTe5zaL7o8GjTdo5lBzCJI1CwDTAal6BbBZpqWvzozOh8IqssXuBIWmHBgQygDfMP29i0LkJEAejJTJZO7ImQYDZJaoc1VDWR4zUuPnvV08AtxmESHQeX7HCyt3WHHx9bAmiUog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0QjJXF9p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0QjJXF9p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0032FC4CED2;
	Tue, 28 Jan 2025 00:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738024925;
	bh=ae0mT2EFmGlMQPct86345SqPFLkjA81rasHAYQe6AE0=;
	h=Date:To:From:Subject:From;
	b=0QjJXF9p1vPZcVK5cN/oWy/dXR2id6pS4gujBDdY+8UwRQ70PHWMpbiGKw2kTOoEW
	 f/TPJvegNMLcUlg0dBOkAO1J4Llo3T5/2skp5TAkPfxPLj5Txp+9Gn90AaEBC295yS
	 /HiwC7NHhScsU+zXXg4vImMlX0wc01Iisvm2xMAU=
Date: Mon, 27 Jan 2025 16:42:03 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,peterz@infradead.org,mingo@kernel.org,liam.howlett@oracle.com,kees@kernel.org,jannh@google.com,brauner@kernel.org,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mmprocfs-allow-read-only-remote-mm-access-under-cap_perfmon.patch added to mm-nonmm-unstable branch
Message-Id: <20250128004205.0032FC4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm,procfs: allow read-only remote mm access under CAP_PERFMON
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     mmprocfs-allow-read-only-remote-mm-access-under-cap_perfmon.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmprocfs-allow-read-only-remote-mm-access-under-cap_perfmon.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Andrii Nakryiko <andrii@kernel.org>
Subject: mm,procfs: allow read-only remote mm access under CAP_PERFMON
Date: Mon, 27 Jan 2025 14:21:14 -0800

It's very common for various tracing and profiling toolis to need to
access /proc/PID/maps contents for stack symbolization needs to learn
which shared libraries are mapped in memory, at which file offset, etc. 
Currently, access to /proc/PID/maps requires CAP_SYS_PTRACE (unless we are
looking at data for our own process, which is a trivial case not too
relevant for profilers use cases).

Unfortunately, CAP_SYS_PTRACE implies way more than just ability to
discover memory layout of another process: it allows to fully control
arbitrary other processes.  This is problematic from security POV for
applications that only need read-only /proc/PID/maps (and other similar
read-only data) access, and in large production settings CAP_SYS_PTRACE is
frowned upon even for the system-wide profilers.

On the other hand, it's already possible to access similar kind of
information (and more) with just CAP_PERFMON capability.  E.g., setting up
PERF_RECORD_MMAP collection through perf_event_open() would give one
similar information to what /proc/PID/maps provides.

CAP_PERFMON, together with CAP_BPF, is already a very common combination
for system-wide profiling and observability application.  As such, it's
reasonable and convenient to be able to access /proc/PID/maps with
CAP_PERFMON capabilities instead of CAP_SYS_PTRACE.

For procfs, these permissions are checked through common mm_access()
helper, and so we augment that with cap_perfmon() check *only* if
requested mode is PTRACE_MODE_READ.  I.e., PTRACE_MODE_ATTACH wouldn't be
permitted by CAP_PERFMON.  So /proc/PID/mem, which uses
PTRACE_MODE_ATTACH, won't be permitted by CAP_PERFMON, but /proc/PID/maps,
/proc/PID/environ, and a bunch of other read-only contents will be
allowable under CAP_PERFMON.

Besides procfs itself, mm_access() is used by process_madvise() and
process_vm_{readv,writev}() syscalls.  The former one uses
PTRACE_MODE_READ to avoid leaking ASLR metadata, and as such CAP_PERFMON
seems like a meaningful allowable capability as well.

process_vm_{readv,writev} currently assume PTRACE_MODE_ATTACH level of
permissions (though for readv PTRACE_MODE_READ seems more reasonable, but
that's outside the scope of this change), and as such won't be affected by
this patch.

Link: https://lkml.kernel.org/r/20250127222114.1132392-1-andrii@kernel.org
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/kernel/fork.c~mmprocfs-allow-read-only-remote-mm-access-under-cap_perfmon
+++ a/kernel/fork.c
@@ -1559,6 +1559,17 @@ struct mm_struct *get_task_mm(struct tas
 }
 EXPORT_SYMBOL_GPL(get_task_mm);
 
+static bool may_access_mm(struct mm_struct *mm, struct task_struct *task, unsigned int mode)
+{
+	if (mm == current->mm)
+		return true;
+	if (ptrace_may_access(task, mode))
+		return true;
+	if ((mode & PTRACE_MODE_READ) && perfmon_capable())
+		return true;
+	return false;
+}
+
 struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
 {
 	struct mm_struct *mm;
@@ -1571,7 +1582,7 @@ struct mm_struct *mm_access(struct task_
 	mm = get_task_mm(task);
 	if (!mm) {
 		mm = ERR_PTR(-ESRCH);
-	} else if (mm != current->mm && !ptrace_may_access(task, mode)) {
+	} else if (!may_access_mm(mm, task, mode)) {
 		mmput(mm);
 		mm = ERR_PTR(-EACCES);
 	}
_

Patches currently in -mm which might be from andrii@kernel.org are

mmprocfs-allow-read-only-remote-mm-access-under-cap_perfmon.patch

