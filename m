Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580BE2FB2
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742189488; cv=none; b=Ko3iNxqzp5cQ29WZiLkKzp+t+Ldwhm4PPQfCLfyLts3TcX2LDammqsX33zD6Ohlj9+AItafehAJcFKGqvWb2hsUIwRhUdJ4THRCfXCTwOZpdYnJr9AeBEFOuUY5hmMGaqOn9pMA9yBPJafVGGpK5b7eX/PGY0L1YsODh5FjPddM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742189488; c=relaxed/simple;
	bh=RWtY11d6cDVhURquel0eYiK+6poCIJ0bqdafSYx/YUw=;
	h=Date:To:From:Subject:Message-Id; b=PFYJY3RU/JgVfeobaPanrRQtJgHddVo8KB5dsmZZMZ368ZWNklgMTdMjo3wydRuDEkKWa6TEXCWibisMnw288CJh7nOcTCawfbjOcB9pORyohXCrdSb+mSLzGURAx8d9ftMW6ZMGgH9IcMffCwz90+KbsqtdEpYUEMeVcTXBWqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pPNpHbWU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pPNpHbWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253DBC4CEEC;
	Mon, 17 Mar 2025 05:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742189488;
	bh=RWtY11d6cDVhURquel0eYiK+6poCIJ0bqdafSYx/YUw=;
	h=Date:To:From:Subject:From;
	b=pPNpHbWUW52XRLcvkJMvwkR9qt/XX4koanKCLD5oD/To6KAIeiH+67MDh6cUIfVmp
	 Th1jdpCR71GJs7SIefl/V4//W8GD8VEcKgc5z5T728/fcgB/wrm3e2eEU/LltJyUF+
	 LkWM1QVEl6z+bmwfrPzubJrqfWLW5sAnGR6AM7Ao=
Date: Sun, 16 Mar 2025 22:31:27 -0700
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,peterz@infradead.org,mingo@kernel.org,liam.howlett@oracle.com,kees@kernel.org,jannh@google.com,brauner@kernel.org,andrii@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] docsprocfs-document-proc-pid-access-permission-checks.patch removed from -mm tree
Message-Id: <20250317053128.253DBC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs,procfs: document /proc/PID/* access permission checks
has been removed from the -mm tree.  Its filename was
     docsprocfs-document-proc-pid-access-permission-checks.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


