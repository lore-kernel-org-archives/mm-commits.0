Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A22E1A3026
	for <mm-commits@vger.kernel.org>; Thu,  5 Sep 2024 21:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725571771; cv=none; b=E30SfjTNsGk7EG7g6ImxNlnHi8jIJGLNsisFzwxcygj1FtrC7xo6meTs8iOz+s6neujOBJsOBWFdc76fpA59GSDQ4Ycq1OoB9F3gHgb0DWGaR9/jKEXI2kNDt5/VvmMwwfgCAaBIUYkaq+NsUuLI9p2eRCeUqLywWWgs0Hpld4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725571771; c=relaxed/simple;
	bh=FPUH7ea6iMBXTg50od3Dek6U0ZXtkKDHgXKPZUsMZw8=;
	h=Date:To:From:Subject:Message-Id; b=lZcQj8HJ1QapPZkfxPrK3h68PKINjtZzsXRwgcw1zevDZbLOWjYqINPSr4jBXS7ttB5yr5zIobJ1oauwdQiHO/r+9UE+82oS+hpFmnN9nSTjaZa5jLORAXQ9JuIEyb1KFF6SrTPvG0rKhnq9fopDO9M2UrhkihQdr5ZmCS3IPI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y+0Nkdju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y+0Nkdju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B4FC4CEC4;
	Thu,  5 Sep 2024 21:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725571770;
	bh=FPUH7ea6iMBXTg50od3Dek6U0ZXtkKDHgXKPZUsMZw8=;
	h=Date:To:From:Subject:From;
	b=Y+0NkdjuQ/8UrAdWpVq4VM9QG14FVRYVviXPejOvfQO19S1rPwcfM4oZo45WY6w63
	 IMnNsGD5e+tofZ42ScGYYEC+Yu2fXW21dnfvpnh71bYyHkUCOHN5CJCPAyx4iYS7gH
	 jC9GA2FKygNpff/zfv0tltoucbQZp7XvThA+ZXiA=
Date: Thu, 05 Sep 2024 14:29:29 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate-simplify-find_mm_struct.patch added to mm-unstable branch
Message-Id: <20240905212930.A9B4FC4CEC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: migrate: simplify find_mm_struct()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate-simplify-find_mm_struct.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate-simplify-find_mm_struct.patch

This patch will later appear in the mm-unstable branch at
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
From: Nanyong Sun <sunnanyong@huawei.com>
Subject: mm: migrate: simplify find_mm_struct()
Date: Thu, 5 Sep 2024 23:31:18 +0800

Use find_get_task_by_vpid() to replace the task_struct find logic in
find_mm_struct(), note that this patch move the ptrace_may_access() call
out from rcu_read_lock() scope, this is ok because it actually does not
need it, find_get_task_by_vpid() already get the pid and task safely,
ptrace_may_access() can use the task safely, like what
sched_core_share_pid() similarly do.

Link: https://lkml.kernel.org/r/20240905153118.1205173-1-sunnanyong@huawei.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/migrate.c~mm-migrate-simplify-find_mm_struct
+++ a/mm/migrate.c
@@ -2505,25 +2505,19 @@ static struct mm_struct *find_mm_struct(
 		return current->mm;
 	}
 
-	/* Find the mm_struct */
-	rcu_read_lock();
-	task = find_task_by_vpid(pid);
+	task = find_get_task_by_vpid(pid);
 	if (!task) {
-		rcu_read_unlock();
 		return ERR_PTR(-ESRCH);
 	}
-	get_task_struct(task);
 
 	/*
 	 * Check if this process has the right to modify the specified
 	 * process. Use the regular "ptrace_may_access()" checks.
 	 */
 	if (!ptrace_may_access(task, PTRACE_MODE_READ_REALCREDS)) {
-		rcu_read_unlock();
 		mm = ERR_PTR(-EPERM);
 		goto out;
 	}
-	rcu_read_unlock();
 
 	mm = ERR_PTR(security_task_movememory(task));
 	if (IS_ERR(mm))
_

Patches currently in -mm which might be from sunnanyong@huawei.com are

mm-migrate-simplify-find_mm_struct.patch

