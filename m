Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974322D7DE9
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334239; cv=none; b=Rb6Jzejv1g6MV6sj/Xm3BlyRyxlokq5k0E2+WQ866AVc8MRcgNDI/hNz/v+tWlrJLR8FWJ3rN9izY/5Y4VlmMKzIQPrqaUfTFWWlnoU0e6mfv8rc8j+mEmXlxCZZnONEd2MWSAODrDYKd7ntj1HNFWoqh5CRNlVmXpdsO8EF+CY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334239; c=relaxed/simple;
	bh=nD6kwX1cnoDbT6EEzptrKZSJU0Vb8o1X82lUMBUcFUU=;
	h=Date:To:From:Subject:Message-Id; b=eK7NUKJ9t+ZSXfw3bigwGNWdI32SuLSgbhLmOJeUq2ExLoUUGpbCQFYF3bskm5B0OuAuPevitJiY841wwsheHMkXNkpne6Jxmsld7JJAb6JhpNW0DhxZVOmAakSgVqJoBi9S7mwgXnl8pxxTrIHwV35dITmJgpuDBSrrIpjIJ/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0Xj9BmZ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0Xj9BmZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC711F0089C;
	Wed,  7 Oct 2026 00:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334238;
	bh=S2SsCS+syy13oGk/II+rqPcJBvAONaufkGwPvFBZrDI=;
	h=Date:To:From:Subject;
	b=0Xj9BmZ1gzyORsLsLDNqtdcx6wJVzwEZeRSkeYtigJz7fdGP1QugwrUzTYUsYvo2F
	 BJxpQOrKGIFtq02rUJTJtK6rgEntTIZmV4Oyn71ClqdJVP/3ffZKHnKljopo5rHYZ6
	 kAUfhQlKYzLi7hD5f8aOH64mvv3tcqleVkfod7xs=
Date: Tue, 06 Oct 2026 17:50:38 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,thnkslprpt@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-return-enomem-for-page-table-allocation-failure-in-insert_pages.patch removed from -mm tree
Message-Id: <20261007005038.6EC711F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: return -ENOMEM for page-table allocation failure in insert_pages()
has been removed from the -mm tree.  Its filename was
     mm-memory-return-enomem-for-page-table-allocation-failure-in-insert_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Avi Weiss <thnkslprpt@gmail.com>
Subject: mm/memory: return -ENOMEM for page-table allocation failure in insert_pages()
Date: Sat, 29 Aug 2026 20:11:13 +0300

walk_to_pmd() returns NULL only when p4d_alloc(), pud_alloc(), or
pmd_alloc() fails.  These are page-table allocation failures, but
insert_pages() currently reports them as -EFAULT.

Return -ENOMEM instead, consistent with the subsequent pte_alloc() failure
and with the single-page insert_page() path, which reports failure of the
same page-table allocation chain as -ENOMEM.

Address and range validation failures in vm_insert_pages() continue to
return -EFAULT.  Keep the later -EFAULT return for pte_offset_map_lock(),
which is not an allocation failure.

Link: https://lore.kernel.org/9d990c3ed43608e674d4b12a8c221a09fd200f49.1788022178.git.thnkslprpt@gmail.com
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-return-enomem-for-page-table-allocation-failure-in-insert_pages
+++ a/mm/memory.c
@@ -2569,7 +2569,7 @@ static int insert_pages(struct vm_area_s
 more:
 	pmd = walk_to_pmd(mm, addr);
 	if (!pmd) {
-		err = -EFAULT;
+		err = -ENOMEM;
 		goto out;
 	}
 
_

Patches currently in -mm which might be from thnkslprpt@gmail.com are


