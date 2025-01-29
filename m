Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA99DDD2
	for <mm-commits@vger.kernel.org>; Wed, 29 Jan 2025 02:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738117091; cv=none; b=MaWg3N6B+tQ2mmUdRtiN1npXM2gdutexq8G+Zn9Lou3B2VrBHKF2H6znrZRQVhH65fS5/BuH2WP2WlHXxw8w+3HZfJuSdQhSbijOLWu2O2wDXmVKh3akKVq8WeQgjwzwS7nUTlhgNhVvkH0UZKIKmbawiIdQwPgA7qojHjxFktw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738117091; c=relaxed/simple;
	bh=Gp8dPa5gF58Asz/6K/+eo0nkRHNkFK7iqtUzJtXEhNI=;
	h=Date:To:From:Subject:Message-Id; b=JBryFKicmyPg49RS1PMSFDIj7Y5FiCcSrKbwHBIg1DsZtdpQCwN+uCX2tFDmUdCYfWlorp3CIYGYDFfHY8gqssM2d+PbjNc+KGVdNtiYxoVfWxZcnh1ZX8lxitAhihY7TmiouOv1VitJN1/X4BGfhgVDi5UD6Ww122QzHQg5gHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=epGl5nua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="epGl5nua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18524C4CED3;
	Wed, 29 Jan 2025 02:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738117091;
	bh=Gp8dPa5gF58Asz/6K/+eo0nkRHNkFK7iqtUzJtXEhNI=;
	h=Date:To:From:Subject:From;
	b=epGl5nuaKLhKakdYULp3XjuMAkyvqweMEzHdzzCeP48rhNa+4PtPKvCaNa8y1UzAF
	 gAeUmv+YRfM4VRmMrScOlp39d5/HPurU88XO4cNoeIZinWXM/XsyeoKNLV86boi9Np
	 Kue+auKEzmUZHh0/m9F5I6p/RhHCJnM7/YiQaEJg=
Date: Tue, 28 Jan 2025 18:18:10 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@kernel.org,liam.howlett@oracle.com,kees@kernel.org,jannh@google.com,brauner@kernel.org,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docsprocfs-document-proc-pid-access-permission-checks.patch added to mm-nonmm-unstable branch
Message-Id: <20250129021811.18524C4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: docs,procfs: document /proc/PID/* access permission checks
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     docsprocfs-document-proc-pid-access-permission-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docsprocfs-document-proc-pid-access-permission-checks.patch

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
Subject: docs,procfs: document /proc/PID/* access permission checks
Date: Tue, 28 Jan 2025 16:17:47 -0800

Add a paragraph explaining what sort of capabilities a process would need
to read procfs data for some other process.  Also mention that reading
data for its own process doesn't require any extra permissions.

Link: https://lkml.kernel.org/r/20250129001747.759990-1-andrii@kernel.org
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.rst |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/Documentation/filesystems/proc.rst~docsprocfs-document-proc-pid-access-permission-checks
+++ a/Documentation/filesystems/proc.rst
@@ -128,6 +128,16 @@ process running on the system, which is
 The link  'self'  points to  the process reading the file system. Each process
 subdirectory has the entries listed in Table 1-1.
 
+A process can read its own information from /proc/PID/* with no extra
+permissions. When reading /proc/PID/* information for other processes, reading
+process is required to have either CAP_SYS_PTRACE capability with
+PTRACE_MODE_READ access permissions, or, alternatively, CAP_PERFMON
+capability. This applies to all read-only information like `maps`, `environ`,
+`pagemap`, etc. The only exception is `mem` file due to its read-write nature,
+which requires CAP_SYS_PTRACE capabilities with more elevated
+PTRACE_MODE_ATTACH permissions; CAP_PERFMON capability does not grant access
+to /proc/PID/mem for other processes.
+
 Note that an open file descriptor to /proc/<pid> or to any of its
 contained files or subdirectories does not prevent <pid> being reused
 for some other process in the event that <pid> exits. Operations on
_

Patches currently in -mm which might be from andrii@kernel.org are

mmprocfs-allow-read-only-remote-mm-access-under-cap_perfmon.patch
docsprocfs-document-proc-pid-access-permission-checks.patch

