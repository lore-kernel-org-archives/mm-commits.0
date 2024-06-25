Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD53913C682;
	Tue, 25 Jun 2024 03:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719287568; cv=none; b=tRahv9/SBU4rpv7pHhbvXmYAHBFPs9rNRrl2ErDBFOxCR8DA2+4X//sBL7ioi7wNCdCAZ/lr4M0NoOtM/+9eGevx5/Hzp/L/qffgq5r2yh5p2L4A+ZaRsuvGVzA+C8MI76UZuYF9Gkr2mdtub0mhAxsuEmlrMysWO+8FlgOoaB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719287568; c=relaxed/simple;
	bh=OA64S8S82S5odm3a5NBs5HrMIbSl8EQfQ0qr3dXhBl0=;
	h=Date:To:From:Subject:Message-Id; b=oM2DrQJqBVbFV3DNLmdRuBO+Rdb/q01DOCob2SxVq7cxoVBKxXnKFrCPbOMSpHka29pExlXn5yRWyihD1QYLrgI+JzswHoRIimpUXKY2W9nl0PSIedlf7iH9QJ/UuzOYCg3F6eYtMvz0csLF0y53FMJnlEWNcmiAx5Y3xCy0E+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q5Rw6A4A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q5Rw6A4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822DEC4AF0A;
	Tue, 25 Jun 2024 03:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719287568;
	bh=OA64S8S82S5odm3a5NBs5HrMIbSl8EQfQ0qr3dXhBl0=;
	h=Date:To:From:Subject:From;
	b=Q5Rw6A4AoqJHntS2McfTVRlnDpx4eGuDo9/aH+BTXtN6kC/RfOFB566+rvd5V/3Aq
	 zcZ8WR2TkTl8nN5R2qxf0po44v5DiYgYskyB6E1Y5+ZiTK9TtISJEH9vXeB4P9RYjq
	 ilqPgEeQpzoA0aAT2CtoXRdT4Fg5bPKOIhTCND1U=
Date: Mon, 24 Jun 2024 20:52:48 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,hughd@google.com,david@redhat.com,abrestic@rivosinc.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-memory-dont-require-head-page-for-do_set_pmd.patch removed from -mm tree
Message-Id: <20240625035248.822DEC4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: don't require head page for do_set_pmd()
has been removed from the -mm tree.  Its filename was
     mm-memory-dont-require-head-page-for-do_set_pmd.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Andrew Bresticker <abrestic@rivosinc.com>
Subject: mm/memory: don't require head page for do_set_pmd()
Date: Tue, 11 Jun 2024 08:32:16 -0700

The requirement that the head page be passed to do_set_pmd() was added in
commit ef37b2ea08ac ("mm/memory: page_add_file_rmap() ->
folio_add_file_rmap_[pte|pmd]()") and prevents pmd-mapping in the
finish_fault() and filemap_map_pages() paths if the page to be inserted is
anything but the head page for an otherwise suitable vma and pmd-sized
page.

Matthew said:

: We're going to stop using PMDs to map large folios unless the fault is
: within the first 4KiB of the PMD.  No idea how many workloads that
: affects, but it only needs to be backported as far as v6.8, so we may
: as well backport it.

Link: https://lkml.kernel.org/r/20240611153216.2794513-1-abrestic@rivosinc.com
Fixes: ef37b2ea08ac ("mm/memory: page_add_file_rmap() -> folio_add_file_rmap_[pte|pmd]()")
Signed-off-by: Andrew Bresticker <abrestic@rivosinc.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-dont-require-head-page-for-do_set_pmd
+++ a/mm/memory.c
@@ -4608,8 +4608,9 @@ vm_fault_t do_set_pmd(struct vm_fault *v
 	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
 		return ret;
 
-	if (page != &folio->page || folio_order(folio) != HPAGE_PMD_ORDER)
+	if (folio_order(folio) != HPAGE_PMD_ORDER)
 		return ret;
+	page = &folio->page;
 
 	/*
 	 * Just backoff if any subpage of a THP is corrupted otherwise
_

Patches currently in -mm which might be from abrestic@rivosinc.com are


