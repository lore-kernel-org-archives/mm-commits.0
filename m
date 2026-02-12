Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4782A2BE02A
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 21:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770933113; cv=none; b=dx2w2yL3gJBFyo1sQwL4gWiKRrjYJ7AKasOEBQGUwb+3FOMR/XpgpjAl8bQZWz/1cJwoUQSHo5PnapYVSADmX2yJ0DM2DsqTkCDaF2vlW8qt1coGnzP68JJ1Wuj1Le/YVzkKaq1WJpSVOkqxf8K++Vp9OcQVzT7OFLjvFnVF1zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770933113; c=relaxed/simple;
	bh=T2dHbWZTamyuChDkbfqYUd0Ji8IxsS7KiLPFibGTtEU=;
	h=Date:To:From:Subject:Message-Id; b=KcltKUKm1mUY3h8jj77erV+s8ZnnY7VurTicZiCBPfLh8I8ButcSN7n+/Af0O/wxpPkQVs3G/S2uKRUh6c904UJmTLmi2GfQ2p3NgoWxWL0tFTKUWVa2VxjuWmN/loz5fwUtS/p3BSn5yKKZ6p6CtVLkPRcsF/V6R3ntQ+DFuzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iml+iAcy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iml+iAcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37A0C4CEF7;
	Thu, 12 Feb 2026 21:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770933112;
	bh=T2dHbWZTamyuChDkbfqYUd0Ji8IxsS7KiLPFibGTtEU=;
	h=Date:To:From:Subject:From;
	b=iml+iAcysz+gUHcY8WUaP3+GkwXCf9Y8A8hY6q1IUiTtUHlYor2jyjY31E3US+M+I
	 Wf/zWFV6x+nemZjykDDaWp8OXaFT7sjeLhjUQ2orlnlnoCTa2fA6j9DqnOHh04XQeH
	 qSrNUfgkv0k45fy4ZnJKYoWrudlYIErKQnFnFhuo=
Date: Thu, 12 Feb 2026 13:51:57 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ynorov@nvidia.com,vbabka@suse.cz,surenb@google.com,pfalcato@suse.de,oliver.sang@intel.com,liam.howlett@oracle.com,jgg@nvidia.com,jarkko@kernel.org,dlemoal@kernel.org,djwong@kernel.org,dev.jain@arm.com,david@kernel.org,clm@fb.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,lorenzo.stoakes@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] tools-testing-vma-separate-out-vma_internalh-into-logical-headers-fix.patch removed from -mm tree
Message-Id: <20260212215152.C37A0C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: tools-testing-vma-separate-out-vma_internalh-into-logical-headers-fix
has been removed from the -mm tree.  Its filename was
     tools-testing-vma-separate-out-vma_internalh-into-logical-headers-fix.patch

This patch was dropped because it was folded into tools-testing-vma-separate-out-vma_internalh-into-logical-headers.patch

------------------------------------------------------
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: tools-testing-vma-separate-out-vma_internalh-into-logical-headers-fix
Date: Tue, 27 Jan 2026 10:02:00 +0000

avoid a duplicate struct define

Link: https://lkml.kernel.org/r/1e032732-61c3-485c-9aa7-6a09016fefc1@lucifer.local
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202601271308.b8d3fcb6-lkp@intel.com
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yury Norov <ynorov@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/vma/include/dup.h |   12 ------------
 1 file changed, 12 deletions(-)

--- a/tools/testing/vma/include/dup.h~tools-testing-vma-separate-out-vma_internalh-into-logical-headers-fix
+++ a/tools/testing/vma/include/dup.h
@@ -1327,15 +1327,3 @@ static inline void vma_set_file(struct v
 	swap(vma->vm_file, file);
 	fput(file);
 }
-
-struct unmap_desc {
-	struct  ma_state *mas;        /* the maple state point to the first vma */
-	struct vm_area_struct *first; /* The first vma */
-	unsigned long pg_start;       /* The first pagetable address to free (floor) */
-	unsigned long pg_end;         /* The last pagetable address to free (ceiling) */
-	unsigned long vma_start;      /* The min vma address */
-	unsigned long vma_end;        /* The max vma address */
-	unsigned long tree_end;       /* Maximum for the vma tree search */
-	unsigned long tree_reset;     /* Where to reset the vma tree walk */
-	bool mm_wr_locked;            /* If the mmap write lock is held */
-};
_

Patches currently in -mm which might be from lorenzo.stoakes@oracle.com are

mm-vma-remove-__private-sparse-decoration-from-vma_flags_t.patch
mm-rename-vma_flag_test-set_atomic-to-vma_test-set_atomic_flag.patch
mm-add-mk_vma_flags-bitmap-flag-macro-helper.patch
tools-bitmap-add-missing-bitmap_.patch
mm-add-basic-vma-flag-operation-helper-functions.patch
mm-update-hugetlbfs-to-use-vma-flags-on-mmap_prepare.patch
mm-update-secretmem-to-use-vma-flags-on-mmap_prepare.patch
mm-update-shmem__file_-functions-to-use-vma_flags_t.patch
mm-update-all-remaining-mmap_prepare-users-to-use-vma_flags_t.patch
mm-make-vm_area_desc-utilise-vma_flags_t-only.patch
tools-testing-vma-separate-vma-userland-tests-into-separate-files.patch
tools-testing-vma-separate-out-vma_internalh-into-logical-headers.patch
tools-testing-vma-add-vma-userland-tests-for-vma-flag-functions.patch

