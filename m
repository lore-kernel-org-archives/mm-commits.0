Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C77718EFC0
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925307; cv=none; b=GRtvvDAVmtO/FkndEcBxmqC7mnJlsTbMyg+GqpmgX8tQdmsY8rEVotUYvezE1AnaoNMHf+LABbguStRBzJUNOfjRs/YkmvyLEBwMyPaFsZ1NxvARGebzW06QmpNuifOv6yfGZX8zUzLBDoav6TQrG5gj3dheF1tfkPn/hwKZaYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925307; c=relaxed/simple;
	bh=olqLoFiQhXccildSV6rlam6HtCs2wX+amP7lCujtS88=;
	h=Date:To:From:Subject:Message-Id; b=g0h2c9xE7r/H+IIez/dBoN27XtRBqzYdRsHnARq//cmPI/injDXZerxx513CpxQOCqzFdOBcDD34yLb5nibzFI5iajwaoM2TlfP7eBumo70NdCjrJ3Yrhwe8dAFsr4KKeVXZ55pHCsi1PUZkNnFoTXnnBJVIUbktHEcNTsrm/N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jkiRCagy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jkiRCagy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA795C4CEC5;
	Mon,  9 Sep 2024 23:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925307;
	bh=olqLoFiQhXccildSV6rlam6HtCs2wX+amP7lCujtS88=;
	h=Date:To:From:Subject:From;
	b=jkiRCagyPcjyq3gnSiB7LcEXnBg66QElxS486nEZuUIqX6S8s8zOUz63ZUSg2FW7v
	 74Awrqhnfb8qdW0DAXxqBAHC71e7vDZnisbZ9fnECx8k82b6Cptaxwqf8PNMiD142L
	 Myck2dXdMAzlYnrb9VoFLd5YzlBl5u4pn+6jr4xw=
Date: Mon, 09 Sep 2024 16:41:46 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,sunnanyong@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-thp-simplify-split_huge_pages_pid.patch removed from -mm tree
Message-Id: <20240909234146.EA795C4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: thp: simplify split_huge_pages_pid()
has been removed from the -mm tree.  Its filename was
     mm-thp-simplify-split_huge_pages_pid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3819,16 +3819,11 @@ static int split_huge_pages_pid(int pid,
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


