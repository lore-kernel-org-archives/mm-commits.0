Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0260F26D4CF;
	Tue, 19 Aug 2025 23:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755646610; cv=none; b=iPP+oepsj02Q9VGzeTZ2mW8y6NIyq7l9yU/QDnmUWWANpskRjFQmfmxB2aIQ1zcEjgCbwQdXibWpRNpmUH46s/nIcJlgkA7Nbn7eBoNLBoomJfi3gowdFkaohJs/2OMgHW4juiMk7bY5uOUzs1QdnYoQg/J7hHT5ikFRNSLzOPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755646610; c=relaxed/simple;
	bh=W6lVDmC7k3dfeJD9qTL49bv0YyyrNitpbUggrRAzdcI=;
	h=Date:To:From:Subject:Message-Id; b=jY1KDS9i6MZMsxeHVLcija3/83lfNje7+Q9RtQDftHDyGO5g1vilRjTzSVBq7yvVINNKMEL97i2AxOxJWblsDRQa7mQOOyi/BkXn9XFjzEJSJh8OtiKMRB9U+RB3z6OELXcOEquvKWMnRslc4Ufi/Z0SHdW0L9SLB3AgLpKnoJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fuaT30MM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fuaT30MM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C32C4CEF1;
	Tue, 19 Aug 2025 23:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755646609;
	bh=W6lVDmC7k3dfeJD9qTL49bv0YyyrNitpbUggrRAzdcI=;
	h=Date:To:From:Subject:From;
	b=fuaT30MMxZD7mLD8iK74CoRnHGc9hkq9CwTXRzA0agsTOhLcgfsYHiY7pQN/Twyb7
	 YGS3ufT1jFRyqPZtirT0SDQqZ/dYMzGccO7AEyqPxtrnB66O+bVxYfmP4hTzBv5l2W
	 WU4uoMBIWihswsTu1W5w3uyuIZQ9uWYmRXdYs8a4=
Date: Tue, 19 Aug 2025 16:36:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,xueshuai@linux.alibaba.com,wangkefeng.wang@huawei.com,stable@vger.kernel.org,osalvador@suse.de,nao.horiguchi@gmail.com,linmiaohe@huawei.com,jane.chu@oracle.com,david@redhat.com,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory-failure-fix-infinite-uce-for-vm_pfnmap-pfn.patch removed from -mm tree
Message-Id: <20250819233649.C4C32C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: fix infinite UCE for VM_PFNMAP pfn
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-fix-infinite-uce-for-vm_pfnmap-pfn.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/memory-failure: fix infinite UCE for VM_PFNMAP pfn
Date: Fri, 15 Aug 2025 15:32:09 +0800

When memory_failure() is called for a already hwpoisoned pfn,
kill_accessing_process() will be called to kill current task.  However, if
the vma of the accessing vaddr is VM_PFNMAP, walk_page_range() will skip
the vma in walk_page_test() and return 0.

Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes
with recovered clean pages"), kill_accessing_process() will return EFAULT.
For x86, the current task will be killed in kill_me_maybe().

However, after this commit, kill_accessing_process() simplies return 0,
that means UCE is handled properly, but it doesn't actually.  In such
case, the user task will trigger UCE infinitely.

To fix it, add .test_walk callback for hwpoison_walk_ops to scan all vmas.

Link: https://lkml.kernel.org/r/20250815073209.1984582-1-tujinjiang@huawei.com
Fixes: aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes with recovered clean pages")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/memory-failure.c~mm-memory-failure-fix-infinite-uce-for-vm_pfnmap-pfn
+++ a/mm/memory-failure.c
@@ -853,9 +853,17 @@ static int hwpoison_hugetlb_range(pte_t
 #define hwpoison_hugetlb_range	NULL
 #endif
 
+static int hwpoison_test_walk(unsigned long start, unsigned long end,
+			     struct mm_walk *walk)
+{
+	/* We also want to consider pages mapped into VM_PFNMAP. */
+	return 0;
+}
+
 static const struct mm_walk_ops hwpoison_walk_ops = {
 	.pmd_entry = hwpoison_pte_range,
 	.hugetlb_entry = hwpoison_hugetlb_range,
+	.test_walk = hwpoison_test_walk,
 	.walk_lock = PGWALK_RDLOCK,
 };
 
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch

