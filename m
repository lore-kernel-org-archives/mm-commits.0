Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C2516C687
	for <mm-commits@vger.kernel.org>; Mon,  4 Nov 2024 04:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730696379; cv=none; b=GmqtGv9CMYJbHvSNGe6h/kUZtQ+l/QKm7dEF6OxOqS6I2VKgohB8TyXcxzDa9MvrEkVSpU2FB8Y/pyApFBF/gvCpaeQLmhHT8bdbfyDwX4Hp0edEyHBoGUVBHlKW2ajjOY+2JBlSm2PI6DZXThkttXw2Oiweg/+VNtPAGw5LHVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730696379; c=relaxed/simple;
	bh=FFAHobb5cLSClOChN3RjXXLWoGYrnzZhuP7Oqv2eduI=;
	h=Date:To:From:Subject:Message-Id; b=DwU/KAbGfUsbqv87E+YFjywaSsDAQwolcVX/mZa6JjSUjwK+scVyzyS23lGcna0RUAj60BUaA/boeDmaPtXzQvP0jubmU0pjMwXwUK1VgVVVkQt/21FJ2wY0/tA/EZZ9mlz58WmUn7T+7q0u19d+4HeZDrQorn/5A8GfUOMaDCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vEPM+9BC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vEPM+9BC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC12C4CECE;
	Mon,  4 Nov 2024 04:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730696377;
	bh=FFAHobb5cLSClOChN3RjXXLWoGYrnzZhuP7Oqv2eduI=;
	h=Date:To:From:Subject:From;
	b=vEPM+9BC0WLHfDqCZLSevFJb50b6CafgZKmKCXx3+oOpu1FAnrVjY6eug7hzJGQcH
	 QKiesTHukbBm+Qhql+AKy7zdMFCfTEVJILZDw2WvNfYPsHkqRgdvwhbQ5q+aaQ5I3x
	 fE1zqMT9Q47bnEd0JpS7BrhVgNswoityz/GrwLaU=
Date: Sun, 03 Nov 2024 20:59:37 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,richard.weiyang@gmail.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,jannh@google.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch removed from -mm tree
Message-Id: <20241104045937.CAC12C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-vma-the-pgoff-is-correct-if-can_merge_right-fix
has been removed from the -mm tree.  Its filename was
     mm-vma-the-pgoff-is-correct-if-can_merge_right-fix.patch

This patch was dropped because it was folded into mm-vma-the-pgoff-is-correct-if-can_merge_right.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vma-the-pgoff-is-correct-if-can_merge_right-fix
Date: Fri Oct 25 07:39:41 PM PDT 2024

remove now-unused local

mm/vma.c: In function 'vma_merge_new_range':
mm/vma.c:965:23: error: unused variable 'start' [-Werror=unused-variable]
  965 |         unsigned long start = vmg->start;
      |                       ^~~~~
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vma.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vma.c~mm-vma-the-pgoff-is-correct-if-can_merge_right-fix
+++ a/mm/vma.c
@@ -962,7 +962,6 @@ struct vm_area_struct *vma_merge_new_ran
 {
 	struct vm_area_struct *prev = vmg->prev;
 	struct vm_area_struct *next = vmg->next;
-	unsigned long start = vmg->start;
 	unsigned long end = vmg->end;
 	bool can_merge_left, can_merge_right;
 	bool just_expand = vmg->merge_flags & VMG_FLAG_JUST_EXPAND;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-keep-track-of-free-highatomic-fix.patch
mm-refactor-arch_calc_vm_flag_bits-and-arm64-mte-handling-fix.patch
mm-fix-__wp_page_copy_user-fallback-path-for-remote-mm-fix.patch
mm-memoryc-remove-stray-newline-at-top-of-file.patch
mm-vma-the-pgoff-is-correct-if-can_merge_right.patch
memcg-workingset-remove-folio_memcg_rcu-usage-fix.patch
bootmem-stop-using-page-index-fix.patch
vma-detect-infinite-loop-in-vma-tree-fix.patch
maple_tree-add-a-test-checking-storing-null-fix.patch
fs-proc-kcorec-fix-coccinelle-reported-error-instances-fix.patch

