Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BF9224B0E;
	Tue, 27 Jan 2026 02:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769482657; cv=none; b=Zu3mgC2gOZGpahIysVqH2qwWeW48/u6xzHged6Oa5zS0L7T7BtvPNNRS2GM5dBcpzu9LNgmQkAx3hYc2ptlAYJ9Ah/NYZ2eooVYZvm9ERZwfuur1ZFV1ovquGwDUTnKdavRU9UCaKi6K/mbyPtFSJ/X3U+e/cpGMWtpeBr+BIrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769482657; c=relaxed/simple;
	bh=XQZsnvYem02/73cZcNLs76CzPa0c046nVdZ9pRXlCp4=;
	h=Date:To:From:Subject:Message-Id; b=pFYMSqXMBaoEfL5eH1KeQMFMWMbxJ5L92IZ1jhd0elJMcIEeUG+si+LVId02CpXnZB+0f+9FF8Wo6/E36Sxm+h/0aWh/3i4n02Nba8dCW+7k1IWuPQY/BFNulnkunpkMmk2OnJ+yr3dder1Ujv3304acBxNwKDDBqDnsO9tgBrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Oa0AmJLM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Oa0AmJLM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38FB3C19421;
	Tue, 27 Jan 2026 02:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769482657;
	bh=XQZsnvYem02/73cZcNLs76CzPa0c046nVdZ9pRXlCp4=;
	h=Date:To:From:Subject:From;
	b=Oa0AmJLMDvQPx1TgpB+zKrgveqjwSHDDRUDy0FxHwM2HMl5YCrPtvWVtasgAs59Ms
	 7vhNvDc7YXX3mhSweWH+UNYno1XGVfit7uCIk6VWFGhHOvcHCFv6mWi32Mz39htSJs
	 NFlsMk+51E69Tw0RBenJMXaOls3dWab2qkHTtHiw=
Date: Mon, 26 Jan 2026 18:57:36 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shikemeng@huaweicloud.com,ryncsn@gmail.com,Qun-wei.Lin@mediatek.com,nphamcs@gmail.com,matthias.bgg@gmail.com,kasong@tencent.com,chrisl@kernel.org,chinwen.chang@mediatek.com,bhe@redhat.com,baohua@kernel.org,angelogioacchino.delregno@collabora.com,andrew.yang@mediatek.com,akpm@linux-foundation.org,robin.kuo@mediatek.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-swap-restore-swap_space-attr-aviod-krn-panic.patch removed from -mm tree
Message-Id: <20260127025737.38FB3C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm, swap: restore swap_space attr aviod kernel panic
has been removed from the -mm tree.  Its filename was
     mm-swap-restore-swap_space-attr-aviod-krn-panic.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "robin.kuo" <robin.kuo@mediatek.com>
Subject: mm, swap: restore swap_space attr aviod kernel panic
Date: Fri, 16 Jan 2026 14:25:00 +0800

commit 8b47299a411a ("mm, swap: mark swap address space ro and add context
debug check") made the swap address space read-only.  It may lead to
kernel panic if arch_prepare_to_swap returns a failure under heavy memory
pressure as follows,

el1_abort+0x40/0x64
el1h_64_sync_handler+0x48/0xcc
el1h_64_sync+0x84/0x88
errseq_set+0x4c/0xb8 (P)
__filemap_set_wb_err+0x20/0xd0
shrink_folio_list+0xc20/0x11cc
evict_folios+0x1520/0x1be4
try_to_shrink_lruvec+0x27c/0x3dc
shrink_one+0x9c/0x228
shrink_node+0xb3c/0xeac
do_try_to_free_pages+0x170/0x4f0
try_to_free_pages+0x334/0x534
__alloc_pages_direct_reclaim+0x90/0x158
__alloc_pages_slowpath+0x334/0x588
__alloc_frozen_pages_noprof+0x224/0x2fc
__folio_alloc_noprof+0x14/0x64
vma_alloc_zeroed_movable_folio+0x34/0x44
do_pte_missing+0xad4/0x1040
handle_mm_fault+0x4a4/0x790
do_page_fault+0x288/0x5f8
do_translation_fault+0x38/0x54
do_mem_abort+0x54/0xa8

Restore swap address space as not ro to avoid the panic.

Link: https://lkml.kernel.org/r/20260116062535.306453-2-robin.kuo@mediatek.com
Fixes: 8b47299a411a ("mm, swap: mark swap address space ro and add context debug check")
Signed-off-by: robin.kuo <robin.kuo@mediatek.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: andrew.yang <andrew.yang@mediatek.com>
Cc: AngeloGiaocchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chinwen Chang <chinwen.chang@mediatek.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Mathias Brugger <matthias.bgg@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Qun-wei Lin <Qun-wei.Lin@mediatek.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h       |    2 +-
 mm/swap_state.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/mm/swap.h~mm-swap-restore-swap_space-attr-aviod-krn-panic
+++ a/mm/swap.h
@@ -198,7 +198,7 @@ int swap_writeout(struct folio *folio, s
 void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 
 /* linux/mm/swap_state.c */
-extern struct address_space swap_space __ro_after_init;
+extern struct address_space swap_space __read_mostly;
 static inline struct address_space *swap_address_space(swp_entry_t entry)
 {
 	return &swap_space;
--- a/mm/swap_state.c~mm-swap-restore-swap_space-attr-aviod-krn-panic
+++ a/mm/swap_state.c
@@ -37,8 +37,7 @@ static const struct address_space_operat
 #endif
 };
 
-/* Set swap_space as read only as swap cache is handled by swap table */
-struct address_space swap_space __ro_after_init = {
+struct address_space swap_space __read_mostly = {
 	.a_ops = &swap_aops,
 };
 
_

Patches currently in -mm which might be from robin.kuo@mediatek.com are


