Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0991225B693
	for <mm-commits@vger.kernel.org>; Wed, 26 Feb 2025 21:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740604479; cv=none; b=bnqVN11pl8AJ1PEEbeeD36vE5O0/RlGh9xmVj4Qbsq6+sRPltgPQIVv9uzqjAJuZCOG7NRkEY/chTNJJu2NxjRfGVFWqcCjdLBQBCfqOohCuPqIP/FCoCMupCIqEUTJql3lWWcyO//sPhiISgenqZ//lLLrqhOgqUeyHYtkRsBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740604479; c=relaxed/simple;
	bh=bUt0YtKt1gLpf+V7mr1IPliHEqHGGIjtRdLasBEpiXY=;
	h=Date:To:From:Subject:Message-Id; b=OVnLufR4TSZ4itpoVpPpjMfO2pn/CnIZQw5sCXKwQaSTxxJd/WGS9NMfuYdAcgpoaskPJgszqR5dbWY7IjEPpuT9gQF3PFw8vnCRTH48PSrmD1vG+CDWGhdgGLQCKzVPa5ZWtIRCNFIwbhjc/WmaiaTXiXMMBPnV0tZoKzBT9ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xcn/HUdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xcn/HUdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F19EC4CED6;
	Wed, 26 Feb 2025 21:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740604478;
	bh=bUt0YtKt1gLpf+V7mr1IPliHEqHGGIjtRdLasBEpiXY=;
	h=Date:To:From:Subject:From;
	b=xcn/HUdP7UkS5jCSCjVBEa/ott+6MTvQt1vcoU24VEW85IsjfuwYLs0UUDvM+ZAce
	 Q50dGVc2YhH/dlXgS+nrH2MpPorMmM3XtveVrp+sFBxmiqrCRDYmtzbhNxEy9eWH1G
	 eJ+PqvjtmErCe78xX8tgdqy44Oxww9KswWPj+i4I=
Date: Wed, 26 Feb 2025 13:14:37 -0800
To: mm-commits@vger.kernel.org,yuzhao@google.com,yang@os.amperecomputing.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,linmiaohe@huawei.com,kirill.shutemov@linux.intel.com,kasong@tencent.com,jhubbard@nvidia.com,hughd@google.com,david@redhat.com,baolin.wang@linux.alibaba.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-add-folio_split-to-debugfs-testing-interface.patch added to mm-unstable branch
Message-Id: <20250226211438.6F19EC4CED6@smtp.kernel.org>
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
Date: Wed, 26 Feb 2025 16:00:29 -0500

This allows to test folio_split() by specifying an additional in folio
page offset parameter to split_huge_page debugfs interface.

Link: https://lkml.kernel.org/r/20250226210032.2044041-7-ziy@nvidia.com
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
@@ -4312,7 +4312,8 @@ static inline bool vma_not_suitable_for_
 }
 
 static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
-				unsigned long vaddr_end, unsigned int new_order)
+				unsigned long vaddr_end, unsigned int new_order,
+				long in_folio_offset)
 {
 	int ret = 0;
 	struct task_struct *task;
@@ -4396,8 +4397,16 @@ static int split_huge_pages_pid(int pid,
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
 
@@ -4420,7 +4429,8 @@ out:
 }
 
 static int split_huge_pages_in_file(const char *file_path, pgoff_t off_start,
-				pgoff_t off_end, unsigned int new_order)
+				pgoff_t off_end, unsigned int new_order,
+				long in_folio_offset)
 {
 	struct filename *file;
 	struct file *candidate;
@@ -4469,8 +4479,15 @@ static int split_huge_pages_in_file(cons
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
@@ -4503,6 +4520,7 @@ static ssize_t split_huge_pages_write(st
 	int pid;
 	unsigned long vaddr_start, vaddr_end;
 	unsigned int new_order = 0;
+	long in_folio_offset = -1;
 
 	ret = mutex_lock_interruptible(&split_debug_mutex);
 	if (ret)
@@ -4531,30 +4549,33 @@ static ssize_t split_huge_pages_write(st
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
mm-shmem-use-xas_try_split-in-shmem_split_large_entry-fix.patch

