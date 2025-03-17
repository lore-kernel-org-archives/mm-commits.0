Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E76217F55
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188482; cv=none; b=Em+w79sYDFDp15+T5fStlX/BDFnfOtYZ186itf8F2CDf7ZWxJ1rNGJjTpAHndawimpnZCndQDSoxjg3YTzB15CKgTA7vSUGUHRw1lLu/evvXYFsom0FokSF2bKcWu/0rYePtZABfaSRR0O4nPOVLhUsEERh1WFU//x8zdCvWjLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188482; c=relaxed/simple;
	bh=1aAilbQk/yIaEbPsEGO5oXj0X5R3pWVldEwBVEXIbUA=;
	h=Date:To:From:Subject:Message-Id; b=cVx9k/BEbiW5P/PKZzVm+cdgsYqpSHpxfdHhrhI5f7vHUZKbITxNLVxI9mwY+elJafObvtwm/dokyBVojYTH5Nj2zYwFTnFZlMz28wpFMbqDFAXoE3nSASP1XsJKn9lKdJMAd07NPtQXwVuCLWoqFLEnlA/qP3p8jGEpptBQXQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OGN5n4yt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OGN5n4yt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C52AC4CEEC;
	Mon, 17 Mar 2025 05:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188482;
	bh=1aAilbQk/yIaEbPsEGO5oXj0X5R3pWVldEwBVEXIbUA=;
	h=Date:To:From:Subject:From;
	b=OGN5n4ytjAvJrkuSPq3KD/P/eFRZSuer3lv7GehSoMIh4k9WBKQXgw9r4+jaFegFs
	 8N6GCYJZURSbxpBycb1k3hO3gZ3XeJdLaoYHWvkrpvXzBSsBjrDMsmDdbTfEYbCcrm
	 XnlH0x4JBOF6A5Hx9s7gdayytqdOcw9myzwnAp5U=
Date: Sun, 16 Mar 2025 22:14:41 -0700
To: mm-commits@vger.kernel.org,jglisse@redhat.com,jgg@nvidia.com,apopple@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-remove-pageanonexclusive-sanity-check-in-restore_exclusive_pte.patch removed from -mm tree
Message-Id: <20250317051442.6C52AC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory: remove PageAnonExclusive sanity-check in restore_exclusive_pte()
has been removed from the -mm tree.  Its filename was
     mm-memory-remove-pageanonexclusive-sanity-check-in-restore_exclusive_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/memory: remove PageAnonExclusive sanity-check in restore_exclusive_pte()
Date: Wed, 26 Feb 2025 14:22:54 +0100

In commit b832a354d787 ("mm/memory: page_add_anon_rmap() ->
folio_add_anon_rmap_pte()") we accidentally changed the sanity check to
essentially ignore anonymous folio by mis-placing the "!" ...  but we
really always only get anonymous folios in restore_exclusive_pte().

However, in the meantime we removed the separate "writable
device-exclusive entries" and always detect if the PTE can be writable
using can_change_pte_writable() -- which also consults PageAnonExclusive.

So let's just get rid of this sanity check completely.

Link: https://lkml.kernel.org/r/20250226132257.2826043-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/memory.c~mm-memory-remove-pageanonexclusive-sanity-check-in-restore_exclusive_pte
+++ a/mm/memory.c
@@ -738,9 +738,6 @@ static void restore_exclusive_pte(struct
 			pte = pte_mkdirty(pte);
 		pte = pte_mkwrite(pte, vma);
 	}
-
-	VM_BUG_ON_FOLIO(pte_write(pte) && (!folio_test_anon(folio) &&
-					   PageAnonExclusive(page)), folio);
 	set_pte_at(vma->vm_mm, address, ptep, pte);
 
 	/*
_

Patches currently in -mm which might be from david@redhat.com are

mm-factor-out-large-folio-handling-from-folio_order-into-folio_large_order.patch
mm-factor-out-large-folio-handling-from-folio_nr_pages-into-folio_large_nr_pages.patch
mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page.patch
mm-let-_folio_nr_pages-overlay-memcg_data-in-first-tail-page-fix.patch
mm-move-hugetlb-specific-things-in-folio-to-page.patch
mm-move-_pincount-in-folio-to-page-on-32bit.patch
mm-move-_entire_mapcount-in-folio-to-page-on-32bit.patch
mm-rmap-pass-dst_vma-to-folio_dup_file_rmap_pte-and-friends.patch
mm-rmap-pass-vma-to-__folio_add_rmap.patch
mm-rmap-abstract-large-mapcount-operations-for-large-folios-hugetlb.patch
bit_spinlock-__always_inline-unlock-functions.patch
mm-rmap-use-folio_large_nr_pages-in-add-remove-functions.patch
mm-rmap-basic-mm-owner-tracking-for-large-folios-hugetlb.patch
mm-copy-on-write-cow-reuse-support-for-pte-mapped-thp.patch
mm-convert-folio_likely_mapped_shared-to-folio_maybe_mapped_shared.patch
mm-config_no_page_mapcount-to-prepare-for-not-maintain-per-page-mapcounts-in-large-folios.patch
fs-proc-page-remove-per-page-mapcount-dependency-for-proc-kpagecount-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-pm_mmap_exclusive-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-mapmax-config_no_page_mapcount.patch
fs-proc-task_mmu-remove-per-page-mapcount-dependency-for-smaps-smaps_rollup-config_no_page_mapcount.patch
mm-stop-maintaining-the-per-page-mapcount-of-large-folios-config_no_page_mapcount.patch

