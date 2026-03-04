Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44B937D121
	for <mm-commits@vger.kernel.org>; Wed,  4 Mar 2026 17:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772646303; cv=none; b=C8kwLPh5V6PF5vb+rYVWrk+6bUBgRH7WLSsLUqqiI6+wy9M2gV+NKZZBC89/XkNJoUkuUoraWHkJhMqRkxFtdwpqo7kK1ztcj8pNcgqGsZ1fWqOWtNDSZuQEGpx5ZJODlBNAPxx4yOpQKHPL6mXl/f7wqe/W2pjm032ohhlbEdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772646303; c=relaxed/simple;
	bh=y8f4p7vdBddw9qJFnt6UqoZ6IYDBpc+iBUmuyG+uckw=;
	h=Date:To:From:Subject:Message-Id; b=JxncDDK43DoekW4m+goFcZhqyGDy2w80Vboo/Tg2IC4yjOcRJQ51YbXmBhcxUoRrIAPn1ur5999H7HGYQhQvRFvfr1G8Te291Hm82ugJPyrDa5n2ncY4GJfetzhVbwL89A2UDi4AjAkSSkMGuEHytv1zNebnOA12UO9SJZe4dmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kF77eo3S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kF77eo3S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CE7C4CEF7;
	Wed,  4 Mar 2026 17:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772646303;
	bh=y8f4p7vdBddw9qJFnt6UqoZ6IYDBpc+iBUmuyG+uckw=;
	h=Date:To:From:Subject:From;
	b=kF77eo3SSAsdXGcaEXiD/jeJ8p7YhLdxFI1H0DgfT6IuLVHQ3Xci/9/2QXURk/O8M
	 PFNJrwltMyUfSnkGTBG1HNOMfjm3hvm+YOpvTXcZ47XdIIMDMXIpjRwSEpmdtIF6my
	 eA0+OJiVhQFyvNQGkjrW0+cHpCGSOsolzN/TiFGM=
Date: Wed, 04 Mar 2026 09:45:02 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,vishal.moola@gmail.com,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,re@w6rz.net,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@kernel.org,anshuman.khandual@arm.com,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-cma-move-put_page_testzero-out-of-vm_warn_on-in-cma_release.patch removed from -mm tree
Message-Id: <20260304174503.47CE7C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: move put_page_testzero() out of VM_WARN_ON in cma_release()
has been removed from the -mm tree.  Its filename was
     mm-cma-move-put_page_testzero-out-of-vm_warn_on-in-cma_release.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zi Yan <ziy@nvidia.com>
Subject: mm/cma: move put_page_testzero() out of VM_WARN_ON in cma_release()
Date: Tue, 24 Feb 2026 22:12:31 -0500

When CONFIG_DEBUG_VM is not set, VM_WARN_ON is a NOP.  Putting any
statement with side effect inside it is incorrect.  Collect all
!put_page_testzero() results and check the sum using WARN instead after
the loop.  It restores the same check in free_contig_range() before commit
e0c1326779cc ("mm: page_alloc: add alloc_contig_frozen_{range,pages}()"),
the commit prior to the Fixes one.

Link: https://lkml.kernel.org/r/20260225031231.2352011-1-ziy@nvidia.com
Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
Signed-off-by: Zi Yan <ziy@nvidia.com>
Reported-by: Ron Economos <re@w6rz.net>
Closes: https://lore.kernel.org/all/1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net/
Suggested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Debugged-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Ron Economos <re@w6rz.net>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/cma.c~mm-cma-move-put_page_testzero-out-of-vm_warn_on-in-cma_release
+++ a/mm/cma.c
@@ -1013,6 +1013,7 @@ bool cma_release(struct cma *cma, const
 		 unsigned long count)
 {
 	struct cma_memrange *cmr;
+	unsigned long ret = 0;
 	unsigned long i, pfn;
 
 	cmr = find_cma_memrange(cma, pages, count);
@@ -1021,7 +1022,9 @@ bool cma_release(struct cma *cma, const
 
 	pfn = page_to_pfn(pages);
 	for (i = 0; i < count; i++, pfn++)
-		VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
+		ret += !put_page_testzero(pfn_to_page(pfn));
+
+	WARN(ret, "%lu pages are still in use!\n", ret);
 
 	__cma_release_frozen(cma, cmr, pages, count);
 
_

Patches currently in -mm which might be from ziy@nvidia.com are


