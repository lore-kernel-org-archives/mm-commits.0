Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12952C181
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 00:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783298370; cv=none; b=Zoq46N3O0iLw7hjUEIo8Vq1H9NRQzeDgCcygtGG/K/U5H4jWlsC3PCzkkEKRsg2vSNEZAqoLpCkyzbvD8BoJwNa14QVjtJ+mxR6BGFQKyTU4Qx3WdCI0IkibAv0RXKiOEpfgWd261S+jeFYD/pDCKQ6h8AE7kc2hHXH96n8HZGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783298370; c=relaxed/simple;
	bh=h0RrlGC7F5fSZyZjK9BTOMYkgkQy3DJ7uqSEdFRR00w=;
	h=Date:To:From:Subject:Message-Id; b=WkuvCLEthi8dtAPiC1Qw4WdtH2DA7EHNV7RFAOdtXLOZpKd3V3jQeQyQRiRMcSmRQKNZvuEtyy3R79HbWpx8mIK1tg7k1Oo3XlACqawJoGe3lqySUFlHu+JLnZLmqAj06oBfDQcn0hcLf2nhRy6NcjhgcCu5ciXB03A7Anmoh5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ehgNt3vu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ehgNt3vu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587C21F000E9;
	Mon,  6 Jul 2026 00:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783298368;
	bh=w0sfTS/kgdET3kZkjLkJcNFm3Si3NNTdIScZ9CLGTNE=;
	h=Date:To:From:Subject;
	b=ehgNt3vuj3vAhgXJQPGk3Vik4uIsHUvc3Xypdk2oSj/Lwm7/1PRfxjotusX6vhb4n
	 YJxpUmwdXJvP+dhVIXKbTC/JHkwvUCHlkXNXXsYxxqsFVkOjM4ZGK6or/kWyAVDtil
	 k8N1CF4OpxzcdBJtFgnOxbpKHQ3RwxbZSSeUM3Q4=
Date: Sun, 05 Jul 2026 17:39:27 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,sj@kernel.org,richard.weiyang@gmail.com,ljs@kernel.org,lance.yang@linux.dev,klarasmodin@gmail.com,david@kernel.org,balbirs@nvidia.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-page_vma_mapped-fix-device-private-pmd-handling-fix.patch removed from -mm tree
Message-Id: <20260706003928.587C21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-page_vma_mapped-fix-device-private-pmd-handling-fix
has been removed from the -mm tree.  Its filename was
     mm-page_vma_mapped-fix-device-private-pmd-handling-fix.patch

This patch was dropped because it was folded into mm-page_vma_mapped-fix-device-private-pmd-handling.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_vma_mapped-fix-device-private-pmd-handling-fix
Date: Wed Jul  1 12:00:04 PM PDT 2026

fix Raspberry Pi 1 build, per David

Reported-by: Klara Modin <klarasmodin@gmail.com>
Tested-by: Klara Modin <klarasmodin@gmail.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: SeongJae Park <sj@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_vma_mapped.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/page_vma_mapped.c~mm-page_vma_mapped-fix-device-private-pmd-handling-fix
+++ a/mm/page_vma_mapped.c
@@ -243,8 +243,9 @@ restart:
 		 */
 		pmde = pmdp_get_lockless(pvmw->pmd);
 
-		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
-		    pmd_is_device_private_entry(pmde)) {
+		if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+		    (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde) ||
+		    pmd_is_device_private_entry(pmde))) {
 			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
 			pmde = *pvmw->pmd;
 			if (pmd_is_migration_entry(pmde)) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_vma_mapped-fix-device-private-pmd-handling.patch
mm-mincore-use-walk_page_range_vma-in-do_mincore-fix.patch
csky-implement-flush_cache_vmap-in-c.patch
mm-page_owner-add-print_mode-filter-fix.patch
mm-annotate-data-race-in-cpu_needs_drain-fix.patch
mm-zsmalloc-encode-class-index-in-obj-value-for-lockless-class-lookup-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix.patch
mm-zsmalloc-drop-pool-lock-from-zs_free-on-64-bit-systems-fix-fix.patch
mm-fix-assert_exclusive_bits-by-passing-memdesc_flags_t-by-pointer-fix.patch
mm-rmap-use-huge_ptep_get-in-try_to_migrate_one-checkpatch-fixes.patch
mm-mprotect-use-huge_ptep_get-for-hugetlb-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

