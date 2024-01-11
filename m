Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2056B56B80
	for <mm-commits@vger.kernel.org>; Thu, 11 Jan 2024 21:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A+7U5lrL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF69C433F1;
	Thu, 11 Jan 2024 21:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1705006984;
	bh=KIXRPbaUG96LzDg3haJh+ZCIWxfsF5WG6uo9RSK/hNY=;
	h=Date:To:From:Subject:From;
	b=A+7U5lrL3y/eaLl/NM/Q2nEkfDbo38nuhl5RWHwMthO3Fqvvieh1qQ3EAiaY5VN10
	 YSZgEniTmcxh/QsxvfhRcxq7fMbvGmbuYKBq2mOwa/hiUoIyN+l2X1dlgfB2znoBu1
	 fWIA5QL4G/g9QLlzUMQuO67RXkbDQy4It39uek6Q=
Date: Thu, 11 Jan 2024 13:03:04 -0800
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,usama.anjum@collabora.com,ryan.roberts@arm.com,peterx@redhat.com,Liam.Howlett@oracle.com,hughd@google.com,david@redhat.com,avagin@google.com,adobriyan@gmail.com,teawater@antgroup.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmuc-add_to_pagemap-remove-useless-parameter-addr.patch added to mm-unstable branch
Message-Id: <20240111210304.BEF69C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu.c: add_to_pagemap: remove useless parameter addr
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-task_mmuc-add_to_pagemap-remove-useless-parameter-addr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmuc-add_to_pagemap-remove-useless-parameter-addr.patch

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

fs-proc-task_mmuc-add_to_pagemap-remove-useless-parameter-addr.patch

