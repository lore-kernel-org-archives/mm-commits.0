Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C358EBA53
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560082; cv=none; b=CTqppfhpoFjPQv14vx5vomcqlTAa+w4J0sV6Lm3szP1dXa56DvFSpOQZmLs8x9SPD9EtAo0sy0bSLh+RRKZplng34XvVAmQf4uuNAXyrvEgfc/tDt/VevFXarO/KJBBWFNM1+2BAh5iCD5zXyaDpfNVZW7JDB46sVBkidDJDjPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560082; c=relaxed/simple;
	bh=3FI+YNWZx90BAo+kSgJ5ycQ57Q2jYD03nW7IOFwK6/8=;
	h=Date:To:From:Subject:Message-Id; b=PewvTA07dGjYHTkwDAjVWnUa8X57hXN8Qv0VSNN7GkbEor7Ro69/sCVqqP1udSQl1BwcW+1nq7BaxNpiMKQDa7bJ217zuZCi5mxAL+m5gefrBUqQ00K/7dpe2EB4EHwwUFMJFhnOBsw70r/fH25Ra3S8MZIczDpBV3UqCsGv1EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OgwigXAa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OgwigXAa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979C3C433C7;
	Thu, 22 Feb 2024 00:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560082;
	bh=3FI+YNWZx90BAo+kSgJ5ycQ57Q2jYD03nW7IOFwK6/8=;
	h=Date:To:From:Subject:From;
	b=OgwigXAasQpWO9PdUUTpIDM8E1pn4PWFN1ROMj1WUjDySIxvwAU97c0dF0FE/+2nh
	 cQX5FYl+o2FslRa1AYcTHTlnU0WT73I5bryIXtOQDciwyb+9BijMWM3AycHkOQOo7s
	 y3t2Ba8uyVDO60GgF3yGWrlw7AA+GvGHXhBnD87g=
Date: Wed, 21 Feb 2024 16:01:22 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,usama.anjum@collabora.com,ryan.roberts@arm.com,peterx@redhat.com,Liam.Howlett@oracle.com,hughd@google.com,david@redhat.com,avagin@google.com,adobriyan@gmail.com,teawater@antgroup.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-proc-task_mmuc-add_to_pagemap-remove-useless-parameter-addr.patch removed from -mm tree
Message-Id: <20240222000122.979C3C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: fs/proc/task_mmu.c: add_to_pagemap: remove useless parameter addr
has been removed from the -mm tree.  Its filename was
     fs-proc-task_mmuc-add_to_pagemap-remove-useless-parameter-addr.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hui Zhu <teawater@antgroup.com>
Subject: fs/proc/task_mmu.c: add_to_pagemap: remove useless parameter addr
Date: Thu, 11 Jan 2024 08:45:33 +0000

Function parameter addr of add_to_pagemap() is useless.  Remove it.

Link: https://lkml.kernel.org/r/20240111084533.40038-1-teawaterz@linux.alibaba.com
Signed-off-by: Hui Zhu <teawater@antgroup.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrei Vagin <avagin@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmuc-add_to_pagemap-remove-useless-parameter-addr
+++ a/fs/proc/task_mmu.c
@@ -1352,8 +1352,7 @@ static inline pagemap_entry_t make_pme(u
 	return (pagemap_entry_t) { .pme = (frame & PM_PFRAME_MASK) | flags };
 }
 
-static int add_to_pagemap(unsigned long addr, pagemap_entry_t *pme,
-			  struct pagemapread *pm)
+static int add_to_pagemap(pagemap_entry_t *pme, struct pagemapread *pm)
 {
 	pm->buffer[pm->pos++] = *pme;
 	if (pm->pos >= pm->len)
@@ -1380,7 +1379,7 @@ static int pagemap_pte_hole(unsigned lon
 			hole_end = end;
 
 		for (; addr < hole_end; addr += PAGE_SIZE) {
-			err = add_to_pagemap(addr, &pme, pm);
+			err = add_to_pagemap(&pme, pm);
 			if (err)
 				goto out;
 		}
@@ -1392,7 +1391,7 @@ static int pagemap_pte_hole(unsigned lon
 		if (vma->vm_flags & VM_SOFTDIRTY)
 			pme = make_pme(0, PM_SOFT_DIRTY);
 		for (; addr < min(end, vma->vm_end); addr += PAGE_SIZE) {
-			err = add_to_pagemap(addr, &pme, pm);
+			err = add_to_pagemap(&pme, pm);
 			if (err)
 				goto out;
 		}
@@ -1519,7 +1518,7 @@ static int pagemap_pmd_range(pmd_t *pmdp
 		for (; addr != end; addr += PAGE_SIZE) {
 			pagemap_entry_t pme = make_pme(frame, flags);
 
-			err = add_to_pagemap(addr, &pme, pm);
+			err = add_to_pagemap(&pme, pm);
 			if (err)
 				break;
 			if (pm->show_pfn) {
@@ -1547,7 +1546,7 @@ static int pagemap_pmd_range(pmd_t *pmdp
 		pagemap_entry_t pme;
 
 		pme = pte_to_pagemap_entry(pm, vma, addr, ptep_get(pte));
-		err = add_to_pagemap(addr, &pme, pm);
+		err = add_to_pagemap(&pme, pm);
 		if (err)
 			break;
 	}
@@ -1597,7 +1596,7 @@ static int pagemap_hugetlb_range(pte_t *
 	for (; addr != end; addr += PAGE_SIZE) {
 		pagemap_entry_t pme = make_pme(frame, flags);
 
-		err = add_to_pagemap(addr, &pme, pm);
+		err = add_to_pagemap(&pme, pm);
 		if (err)
 			return err;
 		if (pm->show_pfn && (flags & PM_PRESENT))
_

Patches currently in -mm which might be from teawater@antgroup.com are


