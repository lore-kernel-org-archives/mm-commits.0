Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463CE14D70E
	for <mm-commits@vger.kernel.org>; Wed, 19 Feb 2025 01:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927437; cv=none; b=VejZNkTa4SZAo/LsSDjsFHNf4Z2jKW1NhT5MeQqP26unyzd5RDy0bcJ9b1eERPqJu4a4CIOIOWuWxRGVQ2YfcaDla7CY0BMgv+sAnO0crMbvRswwr1fPSwUa7Dg9F3Q5WvGLu+X47Ti+5LEElK6nrLphkwQ8zpDMkz7RW1t3Vkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927437; c=relaxed/simple;
	bh=L99G/d1CmKIF4d94r1Aj75hsG1bJ8CPIYJvstSV8k1c=;
	h=Date:To:From:Subject:Message-Id; b=LcmcT48dRHholTMQrNECRqvujahjMeOVfWHd/dkkiyeXoWlfKWRp6iK/+3dQMpI5UIMfiIlUIznO1w4Bus0A8GSLwuB/kPjTSfjh1Uay+T5jxkzb0Nqw6BEL6r+ObfEXcqCgnr2EKmU9fbieJYE9PTkleIVyv8RmYujU9jJ2eQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=O4XpebkJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="O4XpebkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18A3AC4CEE7;
	Wed, 19 Feb 2025 01:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739927437;
	bh=L99G/d1CmKIF4d94r1Aj75hsG1bJ8CPIYJvstSV8k1c=;
	h=Date:To:From:Subject:From;
	b=O4XpebkJ+aCC91UWwFbf40/xc/8lqj3M5o0lu3SgtUxbNM3pGiMaw5xdMgVG56+OO
	 wOsVe+59Xs0fkqUP3FT+mZttYSlcK0k5VPz8FSLvOP9U5WMzakJUJl9YJypoNFJnYB
	 +tJhfPrHZmHO0r98Glp7/ZIqcUXiuSqhZPNgsqRY=
Date: Tue, 18 Feb 2025 17:10:36 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,kasong@tencent.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch added to mm-unstable branch
Message-Id: <20250219011037.18A3AC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: add folio_split() to debugfs testing interface
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch

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
From: Zi Yan <ziy@nvidia.com>
Subject: mm/huge_memory: add folio_split() to debugfs testing interface
Date: Tue, 18 Feb 2025 18:50:10 -0500

This allows to test folio_split() by specifying an additional in folio
page offset parameter to split_huge_page debugfs interface.

Link: https://lkml.kernel.org/r/20250218235012.1542225-7-ziy@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Kirill A. Shuemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   47 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 13 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-add-folio_split-to-debugfs-testing-interface
+++ a/mm/huge_memory.c
@@ -4313,7 +4313,8 @@ static inline bool vma_not_suitable_for_
 }
 
 static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
-				unsigned long vaddr_end, unsigned int new_order)
+				unsigned long vaddr_end, unsigned int new_order,
+				long in_folio_offset)
 {
 	int ret = 0;
 	struct task_struct *task;
@@ -4397,8 +4398,16 @@ static int split_huge_pages_pid(int pid,
 		if (!folio_test_anon(folio) && folio->mapping != mapping)
 			goto unlock;
 
-		if (!split_folio_to_order(folio, target_order))
-			split++;
+		if (in_folio_offset < 0 ||
+		    in_folio_offset >= folio_nr_pages(folio)) {
+			if (!split_folio_to_order(folio, target_order))
+				split++;
+		} else {
+			struct page *split_at = folio_page(folio,
+							   in_folio_offset);
+			if (!folio_split(folio, target_order, split_at, NULL))
+				split++;
+		}
 
 unlock:
 
@@ -4421,7 +4430,8 @@ out:
 }
 
 static int split_huge_pages_in_file(const char *file_path, pgoff_t off_start,
-				pgoff_t off_end, unsigned int new_order)
+				pgoff_t off_end, unsigned int new_order,
+				long in_folio_offset)
 {
 	struct filename *file;
 	struct file *candidate;
@@ -4470,8 +4480,15 @@ static int split_huge_pages_in_file(cons
 		if (folio->mapping != mapping)
 			goto unlock;
 
-		if (!split_folio_to_order(folio, target_order))
-			split++;
+		if (in_folio_offset < 0 || in_folio_offset >= nr_pages) {
+			if (!split_folio_to_order(folio, target_order))
+				split++;
+		} else {
+			struct page *split_at = folio_page(folio,
+							   in_folio_offset);
+			if (!folio_split(folio, target_order, split_at, NULL))
+				split++;
+		}
 
 unlock:
 		folio_unlock(folio);
@@ -4504,6 +4521,7 @@ static ssize_t split_huge_pages_write(st
 	int pid;
 	unsigned long vaddr_start, vaddr_end;
 	unsigned int new_order = 0;
+	long in_folio_offset = -1;
 
 	ret = mutex_lock_interruptible(&split_debug_mutex);
 	if (ret)
@@ -4532,30 +4550,33 @@ static ssize_t split_huge_pages_write(st
 			goto out;
 		}
 
-		ret = sscanf(tok_buf, "0x%lx,0x%lx,%d", &off_start,
-			    &off_end, &new_order);
-		if (ret != 2 && ret != 3) {
+		ret = sscanf(tok_buf, "0x%lx,0x%lx,%d,%ld", &off_start, &off_end,
+				&new_order, &in_folio_offset);
+		if (ret != 2 && ret != 3 && ret != 4) {
 			ret = -EINVAL;
 			goto out;
 		}
-		ret = split_huge_pages_in_file(file_path, off_start, off_end, new_order);
+		ret = split_huge_pages_in_file(file_path, off_start, off_end,
+				new_order, in_folio_offset);
 		if (!ret)
 			ret = input_len;
 
 		goto out;
 	}
 
-	ret = sscanf(input_buf, "%d,0x%lx,0x%lx,%d", &pid, &vaddr_start, &vaddr_end, &new_order);
+	ret = sscanf(input_buf, "%d,0x%lx,0x%lx,%d,%ld", &pid, &vaddr_start,
+			&vaddr_end, &new_order, &in_folio_offset);
 	if (ret == 1 && pid == 1) {
 		split_huge_pages_all();
 		ret = strlen(input_buf);
 		goto out;
-	} else if (ret != 3 && ret != 4) {
+	} else if (ret != 3 && ret != 4 && ret != 5) {
 		ret = -EINVAL;
 		goto out;
 	}
 
-	ret = split_huge_pages_pid(pid, vaddr_start, vaddr_end, new_order);
+	ret = split_huge_pages_pid(pid, vaddr_start, vaddr_end, new_order,
+			in_folio_offset);
 	if (!ret)
 		ret = strlen(input_buf);
 out:
_

Patches currently in -mm which might be from ziy@nvidia.com are

selftests-mm-make-file-backed-thp-split-work-by-writing-pmd-size-data.patch
mm-huge_memory-allow-split-shmem-large-folio-to-any-lower-order.patch
selftests-mm-test-splitting-file-backed-thp-to-any-lower-order.patch
xarray-add-xas_try_split-to-split-a-multi-index-entry.patch
mm-huge_memory-add-two-new-not-yet-used-functions-for-folio_split.patch
mm-huge_memory-move-folio-split-common-code-to-__folio_split.patch
mm-huge_memory-add-buddy-allocator-like-non-uniform-folio_split.patch
mm-huge_memory-remove-the-old-unused-__split_huge_page.patch
mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch
mm-truncate-use-buddy-allocator-like-folio-split-for-truncate-operation.patch
selftests-mm-add-tests-for-folio_split-buddy-allocator-like-split.patch
mm-filemap-use-xas_try_split-in-__filemap_add_folio.patch
mm-shmem-use-xas_try_split-in-shmem_split_large_entry.patch

