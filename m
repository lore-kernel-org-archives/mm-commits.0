Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586612F7456
	for <mm-commits@vger.kernel.org>; Mon, 24 Nov 2025 23:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025840; cv=none; b=UHPSsI85hJFR3Cba+usplvvzalMSWQ/wW3NNpnMkTb9Ivm+ABgi+f5Mk64naOf6A+ppTItJ7UH1U6hQlaXJLp4FdDYnz/i+Uq4aG8jbEHpCvyv1S13ce1hTGMoUNVMJYMc08wPCiu6/a3dxmM7uDebR87VyIExLKangYro21SJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025840; c=relaxed/simple;
	bh=+f6NSd/9eka5lXqmiQquvhnT8ilJes3qLAWD9z5plFo=;
	h=Date:To:From:Subject:Message-Id; b=hcmKvfADngB+U/1cFv0GpKC2HRIIl692APzBieHvZ9nY1ZXck3MqHfZwkFiL6mG5JocX0JJQXZrV5ETW1VbFuTyxTRNlfhG05eIHCIk6RnQ+5nUqYoCRsaMvh4t8M9BkPj9OYJmLNbUmS9jDGH9pnHi4ugEvPLrRB2OiuOuaa/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TfX1TXkD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TfX1TXkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADA2C4CEF1;
	Mon, 24 Nov 2025 23:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764025839;
	bh=+f6NSd/9eka5lXqmiQquvhnT8ilJes3qLAWD9z5plFo=;
	h=Date:To:From:Subject:From;
	b=TfX1TXkDROOb+aky4dbWZrANq4uAVcOrTdKEbXJ/AH1vEpcByFlQu3wyHhoGNH9Yq
	 M9EfNSFVG7c9B3TqoIkZFQtGRYRN3F6teYNQBd3OuVuLOpXu6ZeLYd65UglPdw6xyD
	 GxdFD8aA5+sAZmtbKN6vlHAGfPQHzgcaTbSSs6yw=
Date: Mon, 24 Nov 2025 15:10:39 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,rostedt@goodmis.org,npache@redhat.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,richard.weiyang@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-khugepaged-remove-redundant-clearing-of-struct-collapse_control.patch removed from -mm tree
Message-Id: <20251124231039.CADA2C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: remove redundant clearing of struct collapse_control
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-remove-redundant-clearing-of-struct-collapse_control.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/khugepaged: remove redundant clearing of struct collapse_control
Date: Fri, 14 Nov 2025 03:00:26 +0000

Patch series "unify PMD scan results and remove redundant cleanup", v2.

This small series addresses two minor cleanup opportunities in the
hugepage collapse logic.

The initial motivation arose during a code review of madvise_collapse(),
where it was noted that the function was missing a handler for
SCAN_PMD_NONE.  This oversight exposed the inconsistent handling of
SCAN_PMD_NULL and SCAN_PMD_NONE.

Since both scan results are functionally identical (they indicate the
absence of a PTE table), the primary patch unifies them into a single,
clearer identifier, SCAN_NO_PTE_TABLE.

The series also takes the opportunity to remove a redundant clearing of
the struct collapse_control.


This patch (of 3):

The structure struct collapse_control is being unnecessarily cleared twice
during the huge page collapse process.

Both hpage_collapse_scan_file() and hpage_collapse_scan_pmd() currently
perform a clear operation on this structure.

Remove the redundant clear operation.

Link: https://lkml.kernel.org/r/20251114030028.7035-1-richard.weiyang@gmail.com
Link: https://lkml.kernel.org/r/20251114030028.7035-2-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Nico Pache <npache@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/khugepaged.c~mm-khugepaged-remove-redundant-clearing-of-struct-collapse_control
+++ a/mm/khugepaged.c
@@ -2803,8 +2803,6 @@ int madvise_collapse(struct vm_area_stru
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
 		}
 		mmap_assert_locked(mm);
-		memset(cc->node_load, 0, sizeof(cc->node_load));
-		nodes_clear(cc->alloc_nmask);
 		if (!vma_is_anonymous(vma)) {
 			struct file *file = get_file(vma->vm_file);
 			pgoff_t pgoff = linear_page_index(vma, addr);
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are


