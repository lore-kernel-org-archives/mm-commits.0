Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E11D2FB2
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189482; cv=none; b=KC7Th49nuNNNyKFhVpU9zWbgOJbsNXRdcEpkqa6pYV0W06huAtuxfY3RM2GQonzQjd0idtKYeGZvL0n0HbHtXKpcITtcT+Ma1MXdjQ5F0YbEVjRpROl399KmTntsBzmiV93Xl+L1nFIsWH0uX2TbXehkN3Api4nVAERiV98XbNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189482; c=relaxed/simple;
	bh=By0ze7L9SkrJl7CKSWwYJyD9u54XtcbiwV469hfFB8Q=;
	h=Date:To:From:Subject:Message-Id; b=b58LvdLHBEAk2hGQHA0JasAQQ0fP9WM712h0jwIwnOBHzdIPOfF1TSOaGgtO0Jxrp8dPmK+dK8quIfNk5RFrNaKQ2rmXVaXo5j+mxHdGIBpEe3Bmbe+KFyFm4pMZ97GcovdtoqfYa31CaOcvn70kWhSZiYC0EEruHYY2cQntEig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WuaN7cGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WuaN7cGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0111C4CEEC;
	Mon, 17 Mar 2025 05:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189482;
	bh=By0ze7L9SkrJl7CKSWwYJyD9u54XtcbiwV469hfFB8Q=;
	h=Date:To:From:Subject:From;
	b=WuaN7cGGTPIrsSXpbKOZ5/+HHNoi0Yx2BzYmwAKbIaIb0q13GutbPnRzl1UXhl9iQ
	 qlCM7zNQPvqlsUPaQp3Ua0Rj9KQ+GB+PcyEA4pUGNdWghoQ53DhtE4t4eORoCn80xX
	 LtP8yjrT6PaQKGYcB6ZTyopXuGxBaOt/L9mR/uC8=
Date: Sun, 16 Mar 2025 22:31:21 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,peterz@infradead.org,mingo@kernel.org,liam.howlett@oracle.com,kees@kernel.org,jannh@google.com,brauner@kernel.org,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] mmprocfs-allow-read-only-remote-mm-access-under-cap_perfmon.patch removed from -mm tree
Message-Id: <20250317053121.F0111C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm,procfs: allow read-only remote mm access under CAP_PERFMON
has been removed from the -mm tree.  Its filename was
     mmprocfs-allow-read-only-remote-mm-access-under-cap_perfmon.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
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


