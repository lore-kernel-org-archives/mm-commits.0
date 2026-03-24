Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8294A35F185
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774386963; cv=none; b=TgAxcW0bvayEtYTHgmD7HNUoHhfEo+8YKiYHkMW9TINKAILwyIlNloKyJ/ZksS0FoI+j8Tk5INdIQ9p9W4ZoGvGkQEuQtEtmKpjfdbPZJsteJIhe5nmsaBJlzvYuPA/IN+vtpSKKlI1QnChCus4i7teag3HlUJ+Zf0wmrS6MzU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774386963; c=relaxed/simple;
	bh=d/ILLw9LYPEZB8tHUTVZRLl8ntMejCeOUN9/vD3TB5c=;
	h=Date:To:From:Subject:Message-Id; b=ZoLy4kZJttWtwCe6QSxMZis/18U6cKF9hJmk4WAZGGbw9Z4G5EON5WXl7fLGBhjKvBRuIMS64VpCZ68McbyFkulhmeBMCAhc0jUojvmnIWG0zx/C1x4+7y3ASmeiXpWkQQvDucecqX991bo+uGa5zWJmFG8r4dDoUDrvXZb4AK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=atl4Kq3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="atl4Kq3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC26C19424;
	Tue, 24 Mar 2026 21:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774386962;
	bh=d/ILLw9LYPEZB8tHUTVZRLl8ntMejCeOUN9/vD3TB5c=;
	h=Date:To:From:Subject:From;
	b=atl4Kq3i2BFa8A4TExN2+T+3dNqQOhbhBtfln81xymY+4458LOMzvkNaVMPqGOsc4
	 v0J0bg3GOk2VxYTuhY7C2/FDTNsdCrsniJLw1kK72oe11/Q27rDnfqeCwYXdex0n1h
	 rOUYe8nTrz93P4cmOuiRHjKKvPey4/pb1zLarVww=
Date: Tue, 24 Mar 2026 14:16:02 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,david@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] hugetlb-update-vmemmap_deduprst-fix.patch removed from -mm tree
Message-Id: <20260324211602.BBC26C19424@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: update vmemmap_dedup.rst
has been removed from the -mm tree.  Its filename was
     hugetlb-update-vmemmap_deduprst-fix.patch

This patch was dropped because it was folded into hugetlb-update-vmemmap_deduprst.patch

------------------------------------------------------
From: Kiryl Shutsemau <kas@kernel.org>
Subject: hugetlb: update vmemmap_dedup.rst
Date: Mon, 2 Mar 2026 10:56:28 +0000

Update the documentation regarding vmemmap optimization for hugetlb to
reflect the changes in how the kernel maps the tail pages.

Fake heads no longer exist. Remove their description.

Link: https://lkml.kernel.org/r/20260302105630.303492-1-kas@kernel.org
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/vmemmap_dedup.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/mm/vmemmap_dedup.rst~hugetlb-update-vmemmap_deduprst-fix
+++ a/Documentation/mm/vmemmap_dedup.rst
@@ -128,8 +128,8 @@ The first page of ``struct page`` (page
 contains the 4 ``struct page`` necessary to describe the HugeTLB. The remaining
 pages of ``struct page`` (page 1 to page 7) are tail pages.
 
-The optimization is only applied when the size of the struct page is a power-of-2
-In this case, all tail pages of the same order are identical. See
+The optimization is only applied when the size of the struct page is a power
+of 2. In this case, all tail pages of the same order are identical. See
 compound_head(). This allows us to remap the tail pages of the vmemmap to a
 shared, read-only page. The head page is also remapped to a new page. This
 allows the original vmemmap pages to be freed.
@@ -143,7 +143,7 @@ Here is how things look after remapping:
  |           |                     |     1     | ------┐
  |           |                     +-----------+       |
  |           |                     |     2     | ------┼        +----------------------------+
- |           |                     +-----------+       |        | A single, per-node page    |
+ |           |                     +-----------+       |        | A single, per-zone page    |
  |           |                     |     3     | ------┼------> | frame shared among all     |
  |           |                     +-----------+       |        | hugepages of the same size |
  |           |                     |     4     | ------┼        +----------------------------+
_

Patches currently in -mm which might be from kas@kernel.org are

mm-move-max_folio_order-definition-to-mmzoneh.patch
mm-change-the-interface-of-prep_compound_tail.patch
mm-rename-the-compound_head-field-in-the-struct-page-to-compound_info.patch
mm-move-set-clear_compound_head-next-to-compound_head.patch
riscv-mm-align-vmemmap-to-maximal-folio-size.patch
loongarch-mm-align-vmemmap-to-maximal-folio-size.patch
mm-rework-compound_head-for-power-of-2-sizeofstruct-page.patch
mm-sparse-check-memmap-alignment-for-compound_info_has_mask.patch
mm-hugetlb-defer-vmemmap-population-for-bootmem-hugepages.patch
mm-hugetlb-refactor-code-around-vmemmap_walk.patch
x86-vdso-undefine-config_hugetlb_page_optimize_vmemmap-for-vdso32.patch
mm-hugetlb-remove-fake-head-pages.patch
mm-drop-fake-head-checks.patch
hugetlb-remove-vmemmap_synchronize_rcu.patch
mm-hugetlb-remove-hugetlb_optimize_vmemmap_key-static-key.patch
mm-remove-the-branch-from-compound_head.patch
hugetlb-update-vmemmap_deduprst.patch
mm-slab-use-compound_head-in-page_slab.patch

