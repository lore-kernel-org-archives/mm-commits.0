Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD670314D35
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486592; cv=none; b=A3TJynOpR/SdU/QvC4Kr9RSO+ZEqLe14qjLVPGXzi9uFKSXk5sTQQEvbswHBAqRz8orJ7lh0s+vk3I8Ucdy1751bdnfs8Ifkvsw4fESlid43f8Tgx3tBed05Crr+uZrNA+0ak0yIt7fRLwn57E64+UCE+eKZBQtNP/UCM766O1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486592; c=relaxed/simple;
	bh=aFL3SgEhR+cvhlCWZk6W/rFRpUmufP44CLh/vZqPwdU=;
	h=Date:To:From:Subject:Message-Id; b=dcVLVsjS8EYjs42f6o36kwkYtFdbuccPLtNE2uK3FR82SpqgYJ/uF5vn9fEk5UMMCcuE1RUnKKFkn/5F7KLkDmGlR6T5+ycxZAs4eVDzR5wnRU3E98ACnvuxZHQg03VQATxc25ewpSPrDcAWTzFbwk6fuDIaN2Y0E4RYZDk6EzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GNlIWcFt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GNlIWcFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78558C116D0;
	Tue, 27 Jan 2026 04:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486592;
	bh=aFL3SgEhR+cvhlCWZk6W/rFRpUmufP44CLh/vZqPwdU=;
	h=Date:To:From:Subject:From;
	b=GNlIWcFt434EAeoOukk/EO9DlcrDlS1jIQF9HzscfPlZ7qIXNNgnYJA1EegQMHmkC
	 fNthdQeNnvVNnAg3mfDoJzXYokhW1GytxYLbLSLwMTmMGIgHQrtfOCY1x0BdlGCTZ3
	 ezoxcbtiJ2r2KSbbEKnjVL+C8N383iia+OvgEk1o=
Date: Mon, 26 Jan 2026 20:03:11 -0800
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,ryan.roberts@arm.com,npache@redhat.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,lianux.mm@gmail.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,Branden.Moore@amd.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,shivankg@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-retry-with-sync-writeback-for-madv_collapse.patch removed from -mm tree
Message-Id: <20260127040312.78558C116D0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: retry with sync writeback for MADV_COLLAPSE
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-retry-with-sync-writeback-for-madv_collapse.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shivank Garg <shivankg@amd.com>
Subject: mm/khugepaged: retry with sync writeback for MADV_COLLAPSE
Date: Sun, 18 Jan 2026 19:09:43 +0000

When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
text sections), the pages may still be dirty from recent writes. 
collapse_file() will trigger async writeback and fail with
SCAN_PAGE_DIRTY_OR_WRITEBACK (-EAGAIN).

MADV_COLLAPSE is a synchronous operation where userspace expects immediate
results.  If the collapse fails due to dirty pages, perform synchronous
writeback on the specific range and retry once.

This avoids spurious failures for freshly written executables while
avoiding unnecessary synchronous I/O for mappings that are already clean.

Link: https://lkml.kernel.org/r/20260118190939.8986-7-shivankg@amd.com
Signed-off-by: Shivank Garg <shivankg@amd.com>
Reported-by: Branden Moore <Branden.Moore@amd.com>
Closes: https://lore.kernel.org/all/4e26fe5e-7374-467c-a333-9dd48f85d7cc@amd.com
Fixes: 34488399fa08 ("mm/madvise: add file and shmem support to MADV_COLLAPSE")
Suggested-by: David Hildenbrand <david@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: wang lian <lianux.mm@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-retry-with-sync-writeback-for-madv_collapse
+++ a/mm/khugepaged.c
@@ -22,6 +22,7 @@
 #include <linux/dax.h>
 #include <linux/ksm.h>
 #include <linux/pgalloc.h>
+#include <linux/backing-dev.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -2788,7 +2789,9 @@ int madvise_collapse(struct vm_area_stru
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		int result = SCAN_FAIL;
+		bool triggered_wb = false;
 
+retry:
 		if (!mmap_locked) {
 			cond_resched();
 			mmap_read_lock(mm);
@@ -2809,8 +2812,20 @@ int madvise_collapse(struct vm_area_stru
 
 			mmap_read_unlock(mm);
 			mmap_locked = false;
+			*lock_dropped = true;
 			result = hpage_collapse_scan_file(mm, addr, file, pgoff,
 							  cc);
+
+			if (result == SCAN_PAGE_DIRTY_OR_WRITEBACK && !triggered_wb &&
+			    mapping_can_writeback(file->f_mapping)) {
+				loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
+				loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
+
+				filemap_write_and_wait_range(file->f_mapping, lstart, lend);
+				triggered_wb = true;
+				fput(file);
+				goto retry;
+			}
 			fput(file);
 		} else {
 			result = hpage_collapse_scan_pmd(mm, vma, addr,
_

Patches currently in -mm which might be from shivankg@amd.com are

mm-khugepaged-remove-unnecessary-goto-skip-label.patch
mm-khugepaged-change-collapse_pte_mapped_thp-to-return-void.patch
mm-khugepaged-use-enum-scan_result-for-result-variables-and-return-types.patch
mm-khugepaged-make-khugepaged_collapse_control-static.patch

