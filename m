Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AECB1CAA9E
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274654; cv=none; b=m8f4u9MVtKMH1E85G3rgWq4n2H3Gmi/WYXcn/3MPorBcx1RDBIDYhm/yVAhOm8AOsAGcYIrru6nkE6Dnwb7kfUpjU063D7k9fDUXoXJeNfC6Lzt+Ej7ewZC6FV7T2KxbmwIMoBImUdClr9kehBIrR/F7UaHtBq+YhjylGM0ViWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274654; c=relaxed/simple;
	bh=vbOBJ09pk00zWMVZM2kvD/54USzIkQGjH6pRCGvmUr0=;
	h=Date:To:From:Subject:Message-Id; b=dXcKdxkxlWrTrDxkBeu2gfddIJgnyAHD9h5V/PfgTTJQpZdosnLT6YiZ0uHtpXW2/40GZuhLAJ394IPgKglPZejeQAVJx75aw4+tWYGWlFGU8f93aKDgUlWZ4fIWXlF562VGokn2HWhszqKkGrx5g3/5HB7sRbFdzbb2SJoxL+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=USTmJoCx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="USTmJoCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65070C4CEDD;
	Tue, 18 Mar 2025 05:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274654;
	bh=vbOBJ09pk00zWMVZM2kvD/54USzIkQGjH6pRCGvmUr0=;
	h=Date:To:From:Subject:From;
	b=USTmJoCx11WwzH8sUkCxFeYTtYNFSp0Di9lQ6qy22sxNbsLbNfgewBG6NFOTcUeSh
	 FNNIqZopyZdQlI/xhBd4jhPbej+bCV08ewRRotX0qyTMMVhaZD/SILwpEHPILl/Dgq
	 iFe8ukwjXfG8T1P+epQXeZuD/Zv9Ar9lMHcJFIKY=
Date: Mon, 17 Mar 2025 22:10:53 -0700
To: mm-commits@vger.kernel.org,yazen.ghannam@amd.com,tony.luck@intel.com,tianruidong@linux.alibaba.com,tglx@linutronix.de,peterz@infradead.org,nao.horiguchi@gmail.com,mingo@redhat.com,linmiaohe@huawei.com,jpoimboe@kernel.org,Jonathan.Cameron@huawei.com,jarkko@kernel.org,jane.chu@oracle.com,hpa@zytor.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,baolin.wang@linux.alibaba.com,xueshuai@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-enhance-comments-for-return-value-of-memory_failure.patch removed from -mm tree
Message-Id: <20250318051054.65070C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: memory-failure: enhance comments for return value of memory_failure()
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-enhance-comments-for-return-value-of-memory_failure.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shuai Xue <xueshuai@linux.alibaba.com>
Subject: mm: memory-failure: enhance comments for return value of memory_failure()
Date: Wed, 12 Mar 2025 19:28:52 +0800

The comments for the return value of memory_failure are not complete,
supplement the comments.

Link: https://lkml.kernel.org/r/20250312112852.82415-4-xueshuai@linux.alibaba.com
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Yazen Ghannam <yazen.ghannam@amd.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Tested-by: Tony Luck <tony.luck@intel.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ruidong Tian <tianruidong@linux.alibaba.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-enhance-comments-for-return-value-of-memory_failure
+++ a/mm/memory-failure.c
@@ -2215,9 +2215,13 @@ static void kill_procs_now(struct page *
  * Must run in process context (e.g. a work queue) with interrupts
  * enabled and no spinlocks held.
  *
- * Return: 0 for successfully handled the memory error,
- *         -EOPNOTSUPP for hwpoison_filter() filtered the error event,
- *         < 0(except -EOPNOTSUPP) on failure.
+ * Return:
+ *   0             - success,
+ *   -ENXIO        - memory not managed by the kernel
+ *   -EOPNOTSUPP   - hwpoison_filter() filtered the error event,
+ *   -EHWPOISON    - the page was already poisoned, potentially
+ *                   kill process,
+ *   other negative values - failure.
  */
 int memory_failure(unsigned long pfn, int flags)
 {
_

Patches currently in -mm which might be from xueshuai@linux.alibaba.com are


