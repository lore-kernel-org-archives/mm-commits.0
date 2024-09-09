Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B69918E05C
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925306; cv=none; b=k+l0hTs7uVForsF8fGvx3s/c+nKarjV5ekEyYj2BU5ILOA9aw+WSi4MfDhaxnUSo7joVWQZbbHHeHpEyWHnTDHsvqoVE5wLECzPQzU9z9eSq8KaMUefpSbVaWV9cxrrmFJVhA+GpWkcJf0fQtqMFe7KpdTf7EedMLhxsDPmMbYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925306; c=relaxed/simple;
	bh=YUfQlfBI2ZXcvKhxxg4+YL5oC31iCpHKPhkAOSXD94I=;
	h=Date:To:From:Subject:Message-Id; b=X+6MUAipgY4sUabYiSLmJIVEuBhkWMSJ98O+vc6bW1jnrNXtbUL5rprAf1v3W48Cklw88mmRacGdH0G9Et0QDVTpjV15kuHKSBndC7PM1E2NOduABIn8HaQCEnNZSqW6hviifK5WmnA5WMwQlGxgIeE0aoAfb9nzE9uTfa0yVco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iGuOEoZu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iGuOEoZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E794EC4CEC5;
	Mon,  9 Sep 2024 23:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925306;
	bh=YUfQlfBI2ZXcvKhxxg4+YL5oC31iCpHKPhkAOSXD94I=;
	h=Date:To:From:Subject:From;
	b=iGuOEoZuOGdpYoANEHRBOVa213PPkueFXXIaoA+IoAml0vMaO6hmWhQaC0LkOMBmY
	 NiOdV6aSTNn9QwKJRQEryQ4nnUrxXJRsdCEfBYvqP0a8VDMhEofOaKg9EEruSetC19
	 KslV8aYpOmj5tpzdIs+fjh6y39NMENtdAiwHaCns=
Date: Mon, 09 Sep 2024 16:41:45 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-simplify-find_mm_struct.patch removed from -mm tree
Message-Id: <20240909234145.E794EC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: migrate: simplify find_mm_struct()
has been removed from the -mm tree.  Its filename was
     mm-migrate-simplify-find_mm_struct.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


