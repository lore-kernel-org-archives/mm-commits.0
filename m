Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5914821FF3F
	for <mm-commits@vger.kernel.org>; Sun, 13 Jul 2025 23:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752450110; cv=none; b=uAEn479cCzCM82LYLpRZhvZ1y1YdDu7CCoq5vOaiGQQl66Mh5HdbIflKmcQ0Xsbn1k6gCKpGXVdTSoLdMaXS8yuH10BjqrBYPQd1g/mwHLea2wdjlaI+Hmes4q2Yuqrn6RZW6lSd77HKC3nvmwUmorTBwfFpEyKXNpr3/tjbgI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752450110; c=relaxed/simple;
	bh=JIuWbZ2ohnP8f68Nx++cPBxx6iUA88Zkcxa+7eF8nDk=;
	h=Date:To:From:Subject:Message-Id; b=CPyIuMfDPj8ZQuotSPuiOBmWvD59Z9ZZUdJ9/4G9YJi0mTLM404txHmdjm1VWCtilr5FUmUgjlg0e0Pbf4Hy9Cq/6e4vKjno4RPNOYDQx1WjZdFctesexL4L6EQKCMc0L/k6WNqie+0l9xIYI5iI5PBwN3FUxmrxnQYjIVe7OcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yeEMtHNo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yeEMtHNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F535C4CEE3;
	Sun, 13 Jul 2025 23:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752450110;
	bh=JIuWbZ2ohnP8f68Nx++cPBxx6iUA88Zkcxa+7eF8nDk=;
	h=Date:To:From:Subject:From;
	b=yeEMtHNoIYPp18R2xpnLAOcdWMczofJibtL6/ulsY+KtTJih+51Xc+JikcFxo5PMn
	 71meii950FFyAFo6PxZrZzH287TikRh9IZtB2Zx9L9Pi5Niucn5HYyOEeOT8WiIuRB
	 VyIGQJD8xwbA7wT0Qo1zIm1jik4soV2Ctejma4+o=
Date: Sun, 13 Jul 2025 16:41:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ryan.roberts@arm.com,osalvador@suse.de,npache@redhat.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,anshuman.khandual@arm.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] khugepaged-reduce-race-probability-between-migration-and-khugepaged.patch removed from -mm tree
Message-Id: <20250713234150.2F535C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: khugepaged: reduce race probability between migration and khugepaged
has been removed from the -mm tree.  Its filename was
     khugepaged-reduce-race-probability-between-migration-and-khugepaged.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Dev Jain <dev.jain@arm.com>
Subject: khugepaged: reduce race probability between migration and khugepaged
Date: Fri, 4 Jul 2025 09:34:17 +0530

Suppose a folio is under migration, and khugepaged is also trying to
collapse it.  collapse_pte_mapped_thp() will retrieve the folio from the
page cache via filemap_lock_folio(), thus taking a reference on the folio
and sleeping on the folio lock, since the lock is held by the migration
path.  Migration will then fail in __folio_migrate_mapping ->
folio_ref_freeze.  Reduce the probability of such a race happening
(leading to migration failure) by bailing out if we detect a PMD is marked
with a migration entry.

This fixes the migration-shared-anon-thp testcase failure on Apple M3.

Note that, this is not a "fix" since it only reduces the chance of
interference of khugepaged with migration, wherein both the kernel
functionalities are deemed "best-effort".

Link: https://lkml.kernel.org/r/20250704040417.63826-1-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/khugepaged.c~khugepaged-reduce-race-probability-between-migration-and-khugepaged
+++ a/mm/khugepaged.c
@@ -941,6 +941,14 @@ static inline int check_pmd_state(pmd_t
 
 	if (pmd_none(pmde))
 		return SCAN_PMD_NONE;
+
+	/*
+	 * The folio may be under migration when khugepaged is trying to
+	 * collapse it. Migration success or failure will eventually end
+	 * up with a present PMD mapping a folio again.
+	 */
+	if (is_pmd_migration_entry(pmde))
+		return SCAN_PMD_MAPPED;
 	if (!pmd_present(pmde))
 		return SCAN_PMD_NULL;
 	if (pmd_trans_huge(pmde))
_

Patches currently in -mm which might be from dev.jain@arm.com are


