Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D123C7DF0
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439222; cv=none; b=t33y8DAhoDxUdrc1oXuW9bPT5kbr9gr195v9GMTpxFfQXBU3nMv87GZwgAHMBVRlTQsu7JypVt+bWby7Z1PcpC+NpdCongGtE6pLo0T8kPTgk7eSlRnGgwGv6Nwpz//yORsE6gQVfN/naxIxrs+CKi4w1URczLnxfmbDTmikNZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439222; c=relaxed/simple;
	bh=WRgivHX92hwrjsvWk2P0AJ32LnFoT+vfYaO5HlMQhY0=;
	h=Date:To:From:Subject:Message-Id; b=PHI1z/voU5AmzFj+4eL/7GJQ9JJda2/k6cfZiMS1GAfcI8TdocxG19UQKUuJWnGiEhcOF+RR7ilkYR/HDcxNOjTlUUL0XojPB0kA9teJ7ZXx52l8eqwNg4FrcR0JKtXSzbrIfJ6D4jU1SR3hb3tUCTgPObmzaE/duOtV2tFcKEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QZ94TStk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QZ94TStk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2F11F00898;
	Tue,  2 Jun 2026 22:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439221;
	bh=FfX3x6cwPtfy3X3kfMuDeH5T0Y54PGmmXpyEX/eBhlA=;
	h=Date:To:From:Subject;
	b=QZ94TStkYyhQHkAC1OuV+5mNbykJS93F92aTbg8lLqyceIYnfUkM3gu9Qqy8sBA0i
	 hBI0+zGKh3SuR7Wu1RZXkhNhIY6+MODXeO+gLt3OOAAk4ItiEFZrmjdocDsuTNIul8
	 1Nx+1qpqkhqq0o4+JsAs0ikwjl6H6mID+IVvOtHI=
Date: Tue, 02 Jun 2026 15:27:01 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,kees@kernel.org,joshua.hahnjy@gmail.com,jannh@google.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-find_mm_struct-fix-race-between-security-checks-and-suid-exec.patch removed from -mm tree
Message-Id: <20260602222701.8E2F11F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate: find_mm_struct: fix race between security checks and suid exec
has been removed from the -mm tree.  Its filename was
     mm-migrate-find_mm_struct-fix-race-between-security-checks-and-suid-exec.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mm/migrate: find_mm_struct: fix race between security checks and suid exec
Date: Tue, 26 May 2026 16:42:11 +0200

The target task can execute a setuid binary between ptrace_may_access()
and get_task_mm().  Protect this critical section with exec_update_lock.

I don't think cpuset_mems_allowed(task) should be called under
exec_update_lock, but this patch just tries to add the minimal fix.

Perhaps we can later add a common helper which can be used by
find_mm_struct() and kernel_migrate_pages().

Link: https://lore.kernel.org/ahWxQ3JxdR5ff2qf@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/mm/migrate.c~mm-migrate-find_mm_struct-fix-race-between-security-checks-and-suid-exec
+++ a/mm/migrate.c
@@ -2555,24 +2555,29 @@ static struct mm_struct *find_mm_struct(
 	}
 
 	task = find_get_task_by_vpid(pid);
-	if (!task) {
+	if (!task)
 		return ERR_PTR(-ESRCH);
-	}
 
+	if (down_read_killable(&task->signal->exec_update_lock)) {
+		mm = ERR_PTR(-EINTR);
+		goto out;
+	}
 	/*
 	 * Check if this process has the right to modify the specified
 	 * process. Use the regular "ptrace_may_access()" checks.
 	 */
 	if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS)) {
 		mm = ERR_PTR(-EPERM);
-		goto out;
+		goto unlock;
 	}
 
 	mm = ERR_PTR(security_task_movememory(task));
 	if (IS_ERR(mm))
-		goto out;
+		goto unlock;
 	*mem_nodes = cpuset_mems_allowed(task);
 	mm = get_task_mm(task);
+unlock:
+	up_read(&task->signal->exec_update_lock);
 out:
 	put_task_struct(task);
 	if (!mm)
_

Patches currently in -mm which might be from oleg@redhat.com are


