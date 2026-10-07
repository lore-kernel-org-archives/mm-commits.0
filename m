Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411872F8E8B
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334233; cv=none; b=fGMTKNyzWqUteo9bpVgPjVKIifTMNNzlo74vBa7FodLuBvO/f6xl6L9dfMwGkfz8yWw1W16Dx+JGB7jtPhtpyzoCOjgFJ06NiS724H2ioOxaGCv78MBwdm7lRQJmDBgM9xil3CXAULD7zfa2ES16mRDnjE9jN45LXXt1x6bHeMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334233; c=relaxed/simple;
	bh=ISo1V4H7SJPj14KEv7bp+VxDFIsV4z0Hck9CXDDPDzg=;
	h=Date:To:From:Subject:Message-Id; b=Tkvm0XpDTbqmVkYdVv0Dzhn8JhvGR6BqHLx3dYImr0W3d7IkJrdxtg8n7wZoTK8JrwYARGlx+T9UH9sgaH0+YDEtejrwy/BTijUAeve2mjjOtdXDKy/d7cyYTX1j60nLNTofy3BUZqAbVOG4jlXsdW3VFSgmjR7jljDsGrgAxwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ca6zuAG5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ca6zuAG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194B61F0089C;
	Wed,  7 Oct 2026 00:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334232;
	bh=Yx3pDX3soBLE2m6+ltqEHR8c502BxUmUbZvw6Y/tLuk=;
	h=Date:To:From:Subject;
	b=Ca6zuAG5d669oc/KwyIXeUJ6ymcxkzpkH2kYStR3u/d1+x21brs7KobQ3qE2Ai/MW
	 NLO/aq72/EKgkoBe1DlwGZmBcHYHyfHvx2SGhTGH7FIrJvbudMAMwenSXHlEDr25se
	 DJ9OscsXGSxfPvJYrTmf3IK7jofcTLny/TiTTqN4=
Date: Tue, 06 Oct 2026 17:50:31 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,ljs@kernel.org,hannes@cmpxchg.org,tz2294@columbia.edu,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_io-refer-to-folios-in-swap_writeout-comments.patch removed from -mm tree
Message-Id: <20261007005032.194B61F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_io: refer to folios in swap_writeout() comments
has been removed from the -mm tree.  Its filename was
     mm-page_io-refer-to-folios-in-swap_writeout-comments.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Tal Zussman <tz2294@columbia.edu>
Subject: mm/page_io: refer to folios in swap_writeout() comments
Date: Sat, 29 Aug 2026 15:09:04 -0400

swap_writeout() operates on folios, not pages.  Update its comments
accordingly.

Link: https://lore.kernel.org/20260829-b4-page_io-folios-v2-5-649728091117@columbia.edu
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---

 mm/page_io.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_io.c~mm-page_io-refer-to-folios-in-swap_writeout-comments
+++ a/mm/page_io.c
@@ -209,7 +209,7 @@ int swap_writeout(struct swap_io_ctx *ct
 		goto out_unlock;
 
 	/*
-	 * Arch code may have to preserve more data than just the page
+	 * Arch code may have to preserve more data than just the folio
 	 * contents, e.g. memory tags.
 	 */
 	ret = arch_prepare_to_swap(folio);
@@ -220,7 +220,7 @@ int swap_writeout(struct swap_io_ctx *ct
 
 	/*
 	 * Use the swap table zero mark to avoid doing IO for zero-filled
-	 * pages. The zero mark is protected by the cluster lock, which is
+	 * folios. The zero mark is protected by the cluster lock, which is
 	 * acquired internally by swap_zeromap_folio_set/clear.
 	 */
 	if (is_folio_zero_filled(folio)) {
_

Patches currently in -mm which might be from tz2294@columbia.edu are

mm-remove-pagewriteback.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry.patch
mm-swap-add-folio_swap_entry-and-folio_page_swap_entry-fix.patch
mm-huge_memory-add-a-comment-to-the-open-coded-swap-entry.patch
mm-rmap-use-folio_page_swap_entry-in-ttu_anon_swapbacked_folio.patch
mm-zswap-use-folio_swap_entry-in-zswap_store_page.patch
mm-swapfile-use-folio_page_swap_entry.patch
arm64-mte-make-mte_save_tags-and-mte_restore_tags-static.patch
arm64-mte-pass-the-swap-entry-to-mte_save_tags.patch
mm-swap-remove-page_swap_entry.patch
mm-memcontrol-take-a-const-folio-in-folio_memcg-and-friends.patch
mm-memcontrol-constify-obj_cgroup_memcg-and-friends.patch
mm-memcontrol-constify-the-lruvec-helpers.patch
mm-page_io-take-a-const-folio-in-bio_associate_blkg_from_folio.patch
mm-memcontrol-constify-the-mem_cgroup-accessors.patch
mm-page_counter-constify-page_counter_read-and-page_counter_margin.patch
mm-memcontrol-constify-the-reclaim-protection-helpers.patch
mm-memcontrol-constify-the-memcg-and-lruvec-stat-readers.patch
mm-memcontrol-constify-the-swap-accounting-helpers.patch
mm-memcontrol-constify-mem_cgroup_swappiness-and-mem_cgroup_get_max.patch
mm-memcontrol-constify-the-zswap-and-socket-pressure-helpers.patch
vmcore-convert-mmap_vmcore_fault-to-use-folios.patch

