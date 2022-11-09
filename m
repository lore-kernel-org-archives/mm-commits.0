Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92529C433FE
	for <mm-commits@archiver.kernel.org>; Wed,  9 Nov 2022 01:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiKIBlx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Nov 2022 20:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbiKIBkJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 8 Nov 2022 20:40:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A1468283
        for <mm-commits@vger.kernel.org>; Tue,  8 Nov 2022 17:39:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A494061803
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 01:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B895C433D7;
        Wed,  9 Nov 2022 01:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1667957967;
        bh=o0HGlg93Rq0YY0jFq6SoCgZFZXIYwx23aHV8MMI0yRw=;
        h=Date:To:From:Subject:From;
        b=QddvNlj8rrLE9SkLh2LPqvizeQTVVQXKif1u27u14Jvw6ZiGcUdnUfGyXqJy8cFJu
         /ku4TlDr5L/FzelYlygxNH+8gMlL/2CzGfujvknK453P/PLk9jjfnLba/IkvXTrvp1
         wndxtSkYGY3jtwy+4HyW/znsp07fkvisSFI5TyyM=
Date:   Tue, 08 Nov 2022 17:39:26 -0800
To:     mm-commits@vger.kernel.org, peterx@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] revert-mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in.patch removed from -mm tree
Message-Id: <20221109013927.0B895C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Revert "mm/uffd: fix warning without PTE_MARKER_UFFD_WP compiled in"
has been removed from the -mm tree.  Its filename was
     revert-mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: Revert "mm/uffd: fix warning without PTE_MARKER_UFFD_WP compiled in"
Date: Mon, 24 Oct 2022 15:33:36 -0400

With " mm/uffd: Fix vma check on userfault for wp" to fix the
registration, we'll be safe to remove the macro hacks now.

Link: https://lkml.kernel.org/r/20221024193336.1233616-3-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c  |    4 ----
 mm/memory.c   |    2 --
 mm/mprotect.c |    2 --
 3 files changed, 8 deletions(-)

--- a/mm/hugetlb.c~revert-mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in
+++ a/mm/hugetlb.c
@@ -5114,7 +5114,6 @@ static void __unmap_hugepage_range(struc
 		 * unmapped and its refcount is dropped, so just clear pte here.
 		 */
 		if (unlikely(!pte_present(pte))) {
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
 			/*
 			 * If the pte was wr-protected by uffd-wp in any of the
 			 * swap forms, meanwhile the caller does not want to
@@ -5126,7 +5125,6 @@ static void __unmap_hugepage_range(struc
 				set_huge_pte_at(mm, address, ptep,
 						make_pte_marker(PTE_MARKER_UFFD_WP));
 			else
-#endif
 				huge_pte_clear(mm, address, ptep, sz);
 			spin_unlock(ptl);
 			continue;
@@ -5155,13 +5153,11 @@ static void __unmap_hugepage_range(struc
 		tlb_remove_huge_tlb_entry(h, tlb, ptep, address);
 		if (huge_pte_dirty(pte))
 			set_page_dirty(page);
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
 		/* Leave a uffd-wp pte marker if needed */
 		if (huge_pte_uffd_wp(pte) &&
 		    !(zap_flags & ZAP_FLAG_DROP_MARKER))
 			set_huge_pte_at(mm, address, ptep,
 					make_pte_marker(PTE_MARKER_UFFD_WP));
-#endif
 		hugetlb_count_sub(pages_per_huge_page(h), mm);
 		page_remove_rmap(page, vma, true);
 
--- a/mm/memory.c~revert-mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in
+++ a/mm/memory.c
@@ -1393,12 +1393,10 @@ zap_install_uffd_wp_if_needed(struct vm_
 			      unsigned long addr, pte_t *pte,
 			      struct zap_details *details, pte_t pteval)
 {
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
 	if (zap_drop_file_uffd_wp(details))
 		return;
 
 	pte_install_uffd_wp_if_needed(vma, addr, pte, pteval);
-#endif
 }
 
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
--- a/mm/mprotect.c~revert-mm-uffd-fix-warning-without-pte_marker_uffd_wp-compiled-in
+++ a/mm/mprotect.c
@@ -267,7 +267,6 @@ static unsigned long change_pte_range(st
 		} else {
 			/* It must be an none page, or what else?.. */
 			WARN_ON_ONCE(!pte_none(oldpte));
-#ifdef CONFIG_PTE_MARKER_UFFD_WP
 			if (unlikely(uffd_wp && !vma_is_anonymous(vma))) {
 				/*
 				 * For file-backed mem, we need to be able to
@@ -279,7 +278,6 @@ static unsigned long change_pte_range(st
 					   make_pte_marker(PTE_MARKER_UFFD_WP));
 				pages++;
 			}
-#endif
 		}
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 	arch_leave_lazy_mmu_mode();
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-always-compile-in-pte-markers.patch
mm-use-pte-markers-for-swap-errors.patch

