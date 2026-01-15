Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653D32629D;
	Thu, 15 Jan 2026 01:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768440506; cv=none; b=n1/OkHEOX2MXe8YwvpM0PW37pyvKFoI4Bqjf9PTmvFhtJ2wndoq0+XUjKLiobVfNhJlWfCHc2Fw9cON3HCJoFDCWHBliKf1V+DnMwdccAhhB3TpQz58jX83cFvDm1VBDx66QcQKe4CwUdZXPAwiV/hHjIgVzM19VBOy9RWHUT5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768440506; c=relaxed/simple;
	bh=ba7mVTMZ+EY7lEEW5AM+qRtHnEa41sYHr9T8L4Vb3P0=;
	h=Date:To:From:Subject:Message-Id; b=T6Z0NuBujeJ2y6PgVjBBaRWE8MXl8atsh5iJ3Mfy85+JMTLjHtQWlUtyqhBTfz+qhNSmEy/Ohtcg4k2xIRyRl7YS50aQH2dvfZY/78pabl74Riou4YOsZLZF2aJR2RcEohJVHIz68uJ9kNsERAR9T+8vrUxvyhB8OnDcon6zCug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Zye1B6sY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Zye1B6sY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3B8C4CEF7;
	Thu, 15 Jan 2026 01:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768440506;
	bh=ba7mVTMZ+EY7lEEW5AM+qRtHnEa41sYHr9T8L4Vb3P0=;
	h=Date:To:From:Subject:From;
	b=Zye1B6sYCsjwcCU4M5QzXkQxI6Ih04J4qe8gLCvZPJcybv8Nv+34V5jXxyLzH0yKO
	 jwX6t8dIXY9IrNRHPZrCAEe3h5pRqMDiohnxWKOk4NnZ0/cakECVZprOZZnb+TXDTR
	 uZ/pCdgbxwp5dzC03PVeyys5y9VCZzimOHqgen10=
Date: Wed, 14 Jan 2026 17:28:25 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shikemeng@huaweicloud.com,nphamcs@gmail.com,kasong@tencent.com,chrisl@kernel.org,bhe@redhat.com,baohua@kernel.org,robin.kuo@mediatek.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + restore-swap_space-attr-aviod-krn-panic.patch added to mm-hotfixes-unstable branch
Message-Id: <20260115012826.1A3B8C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/swap: restore swap_space attr aviod kernel panic
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     restore-swap_space-attr-aviod-krn-panic.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/restore-swap_space-attr-aviod-krn-panic.patch

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
Subject: mm/swap: restore swap_space attr aviod kernel panic
Date: Thu, 15 Jan 2026 08:13:43 +0800

Restore swap_space attr to avoid kernel panic.

Commit 8b47299a411a ('mm, swap: mark swap address space ro and add context
debug check') made the swap address space __ro_after_init.  It may lead to
a kernel panic if arch_prepare_to_swap() returns a failure under heavy
memory pressure as follows:

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

Restore the swap address space to  __read_mostly to avoid the panic.

Link: https://lkml.kernel.org/r/20260115001405.3513440-1-robin.kuo@mediatek.com
Fixes: 8b47299a411a ("mm, swap: mark swap address space ro and add context debug check")
Signed-off-by: robin.kuo <robin.kuo@mediatek.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.h       |    2 +-
 mm/swap_state.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/mm/swap.h~restore-swap_space-attr-aviod-krn-panic
+++ a/mm/swap.h
@@ -198,7 +198,7 @@ int swap_writeout(struct folio *folio, s
 void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 
 /* linux/mm/swap_state.c */
-extern struct address_space swap_space __ro_after_init;
+extern struct address_space swap_space __read_mostly;
 static inline struct address_space *swap_address_space(swp_entry_t entry)
 {
 	return &swap_space;
--- a/mm/swap_state.c~restore-swap_space-attr-aviod-krn-panic
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

restore-swap_space-attr-aviod-krn-panic.patch

