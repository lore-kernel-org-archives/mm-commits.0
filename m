Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB3B15687C
	for <mm-commits@vger.kernel.org>; Thu,  5 Sep 2024 21:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725571814; cv=none; b=Nk55yqaFk9fpflu+qhg+5YzMkxoYTBjL3hQZygSojDANjmT50pTmEpl34/JX+hEFR9bZmWmvEAtAz5f/K1XMu3uWdpUc5A4Tgw3QFOoBBfTM2A2rTAs/20QfuTna2GCtmPmddbqrm5bLGt6afPOXouI+RcDEYurlbnUD8Xrwi+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725571814; c=relaxed/simple;
	bh=f8srotTYggUd1JFfLwwkBA03hELCwJZOsAzBLGLN/8g=;
	h=Date:To:From:Subject:Message-Id; b=ZLtau2UVK0wh7EdELKuHcX+Wqv9PNR7yWmI2SCsXWJIvHohvkA+IriFZ2jXpD/nqd5v9PwwUI0wG0w3BALsq5NxNFNQQ8NB4jhwgZspRwm+Ng7xXZkfvKrHBAYbcNUFulIUapareHKAIMQJlhrjnvsmgnxtPIPQ0STOdff+ol4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GEQHPo4s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GEQHPo4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B02C4CEC3;
	Thu,  5 Sep 2024 21:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725571813;
	bh=f8srotTYggUd1JFfLwwkBA03hELCwJZOsAzBLGLN/8g=;
	h=Date:To:From:Subject:From;
	b=GEQHPo4skRG9EwB29OQzoT2F6t3vK5GHrIw8cRLx0K6TeTrmgTXgbm3nTL2ds4LaA
	 GN98j4FPzDeI1q8eEvTnr+Tl4uqJoH575030tE8SaIwSYqZnwTooj6F9esdrpgvjag
	 T+D2bc7zn5PoUn7r8ErtyJZzW2UWNb372KfOq3O0=
Date: Thu, 05 Sep 2024 14:30:13 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-simplify-split_huge_pages_pid.patch added to mm-unstable branch
Message-Id: <20240905213013.C4B02C4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: thp: simplify split_huge_pages_pid()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-thp-simplify-split_huge_pages_pid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-thp-simplify-split_huge_pages_pid.patch

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
Subject: mm: thp: simplify split_huge_pages_pid()
Date: Thu, 5 Sep 2024 23:30:28 +0800

The helper find_get_task_by_vpid() can totally replace the task_struct
find logic in split_huge_pages_pid(), so use it to simplify the code. 
Also delete the needless comments for the helper function name already
explains what it's doing here.

Link: https://lkml.kernel.org/r/20240905153028.1205128-1-sunnanyong@huawei.com
Signed-off-by: Nanyong Sun <sunnanyong@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/huge_memory.c~mm-thp-simplify-split_huge_pages_pid
+++ a/mm/huge_memory.c
@@ -3863,16 +3863,11 @@ static int split_huge_pages_pid(int pid,
 	vaddr_start &= PAGE_MASK;
 	vaddr_end &= PAGE_MASK;
 
-	/* Find the task_struct from pid */
-	rcu_read_lock();
-	task = find_task_by_vpid(pid);
+	task = find_get_task_by_vpid(pid);
 	if (!task) {
-		rcu_read_unlock();
 		ret = -ESRCH;
 		goto out;
 	}
-	get_task_struct(task);
-	rcu_read_unlock();
 
 	/* Find the mm_struct */
 	mm = get_task_mm(task);
_

Patches currently in -mm which might be from sunnanyong@huawei.com are

mm-migrate-simplify-find_mm_struct.patch
mm-thp-simplify-split_huge_pages_pid.patch

