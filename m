Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9C03A380F
	for <mm-commits@vger.kernel.org>; Tue, 26 May 2026 20:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779827090; cv=none; b=ViZuTw/Wtr5VH0CD9YnIeANgSpOjyTK0jIYZan59w/cedCNw74hlD2Cl2mU+jfSP99xFP70zoaEw55odw5JPRBLpE7dXO0fCAd0sLbxz/wyo2UcxxaGBeflsJ/vUSxyFfZIi9jSh/IFb0QFLLovU69uds/P1db0Bf/wvyGrnO3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779827090; c=relaxed/simple;
	bh=6u125UhR5Gn4u9rBfEXo1J6MZevSSmN04Xr8a3VRj1o=;
	h=Date:To:From:Subject:Message-Id; b=njCvSIbj2AgkvaySIgKZddhqpEGAQMSxBNLje8NmdOBWwRl7w5Wih7pA+sEpttHos8KLXX5n+ktNcWKQ2LNXOddRTCgNtYJPc/7lLOAUj4LXdKn/FEkNbkJRtMCVLc+kWwbw7a0ierquEOttcoaYy5f3LNxleMEWMpYLSwgL6TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZVeqOUAM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZVeqOUAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7D41F000E9;
	Tue, 26 May 2026 20:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779827089;
	bh=0HsqSEdWEnmzgOgEfqGEdDZ076Qr/Zz4vdC5iTS8EaQ=;
	h=Date:To:From:Subject;
	b=ZVeqOUAMPO2Q9PBvIBJ2wKbA6GdkdvbEhb+Qr2NmCsCR7dTEpOUHYbEXHSYFuebJB
	 fEpigoEQaqItRfDyG9XIp39mbaZJNoiMP7+qqkL+fZv2y2p6wywfL9aLYWOnttxu9U
	 lhjPOv93zHBh/rdpyt/e5UeCjaFcbFq5J+7xtV00=
Date: Tue, 26 May 2026 13:24:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,rakie.kim@sk.com,matthew.brost@intel.com,kees@kernel.org,joshua.hahnjy@gmail.com,jannh@google.com,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,oleg@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-find_mm_struct-fix-race-between-security-checks-and-suid-exec.patch added to mm-new branch
Message-Id: <20260526202448.EF7D41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate: find_mm_struct: fix race between security checks and suid exec
has been added to the -mm mm-new branch.  Its filename is
     mm-migrate-find_mm_struct-fix-race-between-security-checks-and-suid-exec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-find_mm_struct-fix-race-between-security-checks-and-suid-exec.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
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

mm-migrate-find_mm_struct-fix-race-between-security-checks-and-suid-exec.patch

