Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3337327700D
	for <mm-commits@vger.kernel.org>; Fri, 16 Jan 2026 23:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768606701; cv=none; b=JeAC7Rq2UbWlxXwlm0gxdu+X8Hzh1VIhJ1i1pVarw+1QL4p82BtzavxWVnp8M+MUKDCJDAiqVlSNTG/+NGUr+Jjlmi4fGbvUm8U58XUZG3cnfE7yB1sGXTjWDMx+94nZLt2XnMPnaNJ6rH0wg8/sGFDUw3AX5Mz8ATjLeBrYvgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768606701; c=relaxed/simple;
	bh=ocUq05FeBAmV6RKLtaRdwNH1ufCxCQDLiEvjW47uvyM=;
	h=Date:To:From:Subject:Message-Id; b=bC1LPq3IsfdwodHi6yZlrKjxN7W4NPbO8CrOC0BG6PNsJY6mk7kyUZvckjeWGYcaOJMde/tQXOpQXkvAm3CK35MH0xMqeJ+J4Om+4eCgaRfqvPzDNBgxi4fzzW9o2HUw4uuR8MPZTcTxmXJwNX4y3wV5TBSFW2zDt5dUwCH+NBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=M8Lnet7R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="M8Lnet7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A648AC116C6;
	Fri, 16 Jan 2026 23:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768606700;
	bh=ocUq05FeBAmV6RKLtaRdwNH1ufCxCQDLiEvjW47uvyM=;
	h=Date:To:From:Subject:From;
	b=M8Lnet7Rs5dSPSvOuHACybNvXyvpqO6dJVEop1AKyQ4GfYtwhujwXbS53nxTYETnD
	 Z9z32qmdxyDXKGYVtlMMvs2cE/mds3atDoDMpqJj9j5yekumvrIryzkRakKV6sixyj
	 19mdUsJ2LIJzIvjEmB2CBmTcZcuOqGmDLHBFcqec=
Date: Fri, 16 Jan 2026 15:38:20 -0800
To: mm-commits@vger.kernel.org,shikemeng@huaweicloud.com,ryncsn@gmail.com,Qun-wei.Lin@mediatek.com,nphamcs@gmail.com,matthias.bgg@gmail.com,kasong@tencent.com,chrisl@kernel.org,chinwen.chang@mediatek.com,bhe@redhat.com,baohua@kernel.org,angelogioacchino.delregno@collabora.com,andrew.yang@mediatek.com,robin.kuo@mediatek.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-restore-swap_space-attr-aviod-krn-panic.patch added to mm-hotfixes-unstable branch
Message-Id: <20260116233820.A648AC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm, swap: restore swap_space attr aviod kernel panic
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-swap-restore-swap_space-attr-aviod-krn-panic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-restore-swap_space-attr-aviod-krn-panic.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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

mm-swap-restore-swap_space-attr-aviod-krn-panic.patch

