Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0275A25A620
	for <mm-commits@vger.kernel.org>; Sun, 26 Jan 2025 04:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737866582; cv=none; b=arwV0GtvQdW4JCjJE3Ew3sVRZHCghNdzuKDDsyDB86tlCIzDqqsop7vhYXzB7/EDPsaffg7rSn7tuitVvAin8Xt/CLHNPd23Sqe2cxmcfcjrInGugDeWnB686UYBbHvUx+HrvT0C9vXIQXcUVAfoQkqQp8tD82osoD2eSvODYbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737866582; c=relaxed/simple;
	bh=IjuL9JuMWqmd9hYvSJVpnmJ97e1vDVDyfBVIbppeRK8=;
	h=Date:To:From:Subject:Message-Id; b=X+n8KaTiIsg1PEj6+k+pIjcEHuCm3LhCWYueE6CE8l7nl43JAnUrGoUgjUBYXv/Bdh3fGiN5Q5NoEq/ZFzmcU8lBBD00Bo4nkT5wuH+U5VWT/OT1pTVySrFPRec5JJ6qJOBzoUXYpPHGZxy3Gz3lp66eEpX5siuHQ4bGgujRdqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y88MCUop; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y88MCUop"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4301AC4CED3;
	Sun, 26 Jan 2025 04:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737866581;
	bh=IjuL9JuMWqmd9hYvSJVpnmJ97e1vDVDyfBVIbppeRK8=;
	h=Date:To:From:Subject:From;
	b=Y88MCUopcUUVU6TwDWBVa3EIq4TfG86OLFd0VYaV9JaV2akXgo04MZP5YL7YReZlW
	 BYcb9ktxqSvvljdvGAc44oacwEaOGq0cDUx4iWZ4kap7Ku/gLxvpj2qpZYqDJE+ExW
	 JBfkSZNSUwKwd+Ecbrhuz5I+jEwhJcEH8Zz+hB2Y=
Date: Sat, 25 Jan 2025 20:43:00 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,kevin.brodsky@arm.com,hca@linux.ibm.com,gerald.schaefer@linux.ibm.com,agordeev@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] s390-mm-add-missing-ctor-dtor-on-page-table-upgrade.patch removed from -mm tree
Message-Id: <20250126044301.4301AC4CED3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: s390/mm: add missing ctor/dtor on page table upgrade
has been removed from the -mm tree.  Its filename was
     s390-mm-add-missing-ctor-dtor-on-page-table-upgrade.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alexander Gordeev <agordeev@linux.ibm.com>
Subject: s390/mm: add missing ctor/dtor on page table upgrade
Date: Thu, 23 Jan 2025 17:03:49 +0100

Commit 78966b550289 ("s390: pgtable: add statistics for PUD and P4D level
page table") misses the call to pagetable_p4d_ctor() against a newly
allocated P4D table in crst_table_upgrade();

Commit 68c601de75d8 ("mm: introduce ctor/dtor at PGD level") misses the
call to pagetable_pgd_ctor() against a newly allocated PGD and the call to
pagetable_dtor() against a newly allocated P4D that is about to be freed
on crst_table_upgrade() PGD upgrade fail path.

The missed constructors and destructor break (at least) the page table
accounting when a process memory space is upgraded.

Link: https://lkml.kernel.org/r/20250123160349.200154-1-agordeev@linux.ibm.com
Fixes: 78966b550289 ("s390: pgtable: add statistics for PUD and P4D level page table")
Fixes: 68c601de75d8 ("mm: introduce ctor/dtor at PGD level")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Reported-by: Heiko Carstens <hca@linux.ibm.com>
Closes: https://lore.kernel.org/all/20250122074954.8685-A-hca@linux.ibm.com/
Suggested-by: Heiko Carstens <hca@linux.ibm.com>
Reviewed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/mm/pgalloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/s390/mm/pgalloc.c~s390-mm-add-missing-ctor-dtor-on-page-table-upgrade
+++ a/arch/s390/mm/pgalloc.c
@@ -88,12 +88,14 @@ int crst_table_upgrade(struct mm_struct
 		if (unlikely(!p4d))
 			goto err_p4d;
 		crst_table_init(p4d, _REGION2_ENTRY_EMPTY);
+		pagetable_p4d_ctor(virt_to_ptdesc(p4d));
 	}
 	if (end > _REGION1_SIZE) {
 		pgd = crst_table_alloc(mm);
 		if (unlikely(!pgd))
 			goto err_pgd;
 		crst_table_init(pgd, _REGION1_ENTRY_EMPTY);
+		pagetable_pgd_ctor(virt_to_ptdesc(pgd));
 	}
 
 	spin_lock_bh(&mm->page_table_lock);
@@ -130,6 +132,7 @@ int crst_table_upgrade(struct mm_struct
 	return 0;
 
 err_pgd:
+	pagetable_dtor(virt_to_ptdesc(p4d));
 	crst_table_free(mm, p4d);
 err_p4d:
 	return -ENOMEM;
_

Patches currently in -mm which might be from agordeev@linux.ibm.com are


