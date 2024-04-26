Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7EC80BF5
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104114; cv=none; b=ZAbh4j/3FK2yz6EzG1aS5sDNusH/yK5vNhxP8nkZybQZynBk/dG48bWw4Q3iQaemN2YsmEKn896DwJ0vax+sYdxOfBB9mFU0w9hqch44GYQc/AsTMbD9ximS08+zLxYepqhOiBOyeyPZ7Q5dCAXf0em4eamIC8eUw70iU6f6ShY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104114; c=relaxed/simple;
	bh=TtWK/sEe7kUS67JcUHrJA2wxvnY/j+wknSq2A3CDj4Y=;
	h=Date:To:From:Subject:Message-Id; b=kC6C4s1wqMv/8rp0s0hSI8kr5c5KBSoGf/vP9lw3x2xR1D4qKaPXuR+llmOA/+KwFNY+L5jLgrrQDdImBPJqBKgyBA0RqBZBdgBlzlHEWXzPo6meNaMIe0xaxVgw8+41Tcqtcntg8bv0WkTtQxTNBtkFR6Q3/LMLm7Nul7UClHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YA+7XQuK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YA+7XQuK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73141C116B1;
	Fri, 26 Apr 2024 04:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104114;
	bh=TtWK/sEe7kUS67JcUHrJA2wxvnY/j+wknSq2A3CDj4Y=;
	h=Date:To:From:Subject:From;
	b=YA+7XQuKjLPWYbYmXfOSwwB/R6xLfO4l4WBC9X22DAbG5UWjp1tEXqoQ9XrKosIBl
	 sM+S0M6K8I91kwR7nhi5pPO2+lC80FwSOT1DPvFYJyQCAUjVPjU2Li/MRDzu92ElG+
	 3NAHRCE72vsrHDM5VS6DPXMwy4uRVWkdr+q7ndfg=
Date: Thu, 25 Apr 2024 21:01:53 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,linmiaohe@huawei.com,j.granados@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] memory-remove-the-now-superfluous-sentinel-element-from-ctl_table-array.patch removed from -mm tree
Message-Id: <20240426040154.73141C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: memory: remove the now superfluous sentinel element from ctl_table array
has been removed from the -mm tree.  Its filename was
     memory-remove-the-now-superfluous-sentinel-element-from-ctl_table-array.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Joel Granados <j.granados@samsung.com>
Subject: memory: remove the now superfluous sentinel element from ctl_table array
Date: Thu, 28 Mar 2024 16:57:48 +0100

This commit comes at the tail end of a greater effort to remove the empty
elements at the end of the ctl_table arrays (sentinels) which will reduce
the overall build time size of the kernel and run time memory bloat by ~64
bytes per sentinel (further information Link :
https://lore.kernel.org/all/ZO5Yx5JFogGi%2FcBo@bombadil.infradead.org/)

Remove sentinel from all files under mm/ that register a sysctl table.

Link: https://lkml.kernel.org/r/20240328-jag-sysctl_remset_misc-v1-1-47c1463b3af2@samsung.com
Signed-off-by: Joel Granados <j.granados@samsung.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c      |    1 -
 mm/hugetlb.c         |    1 -
 mm/hugetlb_vmemmap.c |    1 -
 mm/memory-failure.c  |    1 -
 mm/oom_kill.c        |    1 -
 mm/page-writeback.c  |    1 -
 mm/page_alloc.c      |    1 -
 7 files changed, 7 deletions(-)

--- a/mm/compaction.c~memory-remove-the-now-superfluous-sentinel-element-from-ctl_table-array
+++ a/mm/compaction.c
@@ -3350,7 +3350,6 @@ static struct ctl_table vm_compaction[]
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
-	{ }
 };
 
 static int __init kcompactd_init(void)
--- a/mm/hugetlb.c~memory-remove-the-now-superfluous-sentinel-element-from-ctl_table-array
+++ a/mm/hugetlb.c
@@ -5029,7 +5029,6 @@ static struct ctl_table hugetlb_table[]
 		.mode		= 0644,
 		.proc_handler	= hugetlb_overcommit_handler,
 	},
-	{ }
 };
 
 static void hugetlb_sysctl_init(void)
--- a/mm/hugetlb_vmemmap.c~memory-remove-the-now-superfluous-sentinel-element-from-ctl_table-array
+++ a/mm/hugetlb_vmemmap.c
@@ -679,7 +679,6 @@ static struct ctl_table hugetlb_vmemmap_
 		.mode		= 0644,
 		.proc_handler	= proc_dobool,
 	},
-	{ }
 };
 
 static int __init hugetlb_vmemmap_init(void)
--- a/mm/memory-failure.c~memory-remove-the-now-superfluous-sentinel-element-from-ctl_table-array
+++ a/mm/memory-failure.c
@@ -141,7 +141,6 @@ static struct ctl_table memory_failure_t
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},
-	{ }
 };
 
 /*
--- a/mm/oom_kill.c~memory-remove-the-now-superfluous-sentinel-element-from-ctl_table-array
+++ a/mm/oom_kill.c
@@ -724,7 +724,6 @@ static struct ctl_table vm_oom_kill_tabl
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
-	{}
 };
 #endif
 
--- a/mm/page_alloc.c~memory-remove-the-now-superfluous-sentinel-element-from-ctl_table-array
+++ a/mm/page_alloc.c
@@ -6288,7 +6288,6 @@ static struct ctl_table page_alloc_sysct
 		.extra2		= SYSCTL_ONE_HUNDRED,
 	},
 #endif
-	{}
 };
 
 void __init page_alloc_sysctl_init(void)
--- a/mm/page-writeback.c~memory-remove-the-now-superfluous-sentinel-element-from-ctl_table-array
+++ a/mm/page-writeback.c
@@ -2291,7 +2291,6 @@ static struct ctl_table vm_page_writebac
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_jiffies,
 	},
-	{}
 };
 #endif
 
_

Patches currently in -mm which might be from j.granados@samsung.com are

initrd-remove-the-now-superfluous-sentinel-element-from-ctl_table-array.patch
ipc-remove-the-now-superfluous-sentinel-element-from-ctl_table-array.patch

