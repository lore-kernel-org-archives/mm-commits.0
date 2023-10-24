Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72A16C00A8F
	for <mm-commits@archiver.kernel.org>; Tue, 24 Oct 2023 15:04:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjJXPE4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 24 Oct 2023 11:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjJXPE4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 24 Oct 2023 11:04:56 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6960C93
        for <mm-commits@vger.kernel.org>; Tue, 24 Oct 2023 08:04:54 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2D1C433C8;
        Tue, 24 Oct 2023 15:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698159894;
        bh=6N2jyKu7DOnfxhgahlNoPjFJvY5GlRS9MGLfqS9ukWc=;
        h=Date:To:From:Subject:From;
        b=W5n0nc2oX+tPZ3rZWrord15CVrgFMGfFKGQm8DvLByHWegzMR8PIYQ+basZOf/OLx
         xmC6J2Fvgscf5saVAjI25PbZFgGFoR5fIhP63g3UcpcEn2CWTQ4AFSkjnzV9BbUFwl
         XqTRFfIuW5bYAdo0cAMcIcbA3mip/INVXlWwP15g=
Date:   Tue, 24 Oct 2023 08:04:53 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, shr@devkernel.io,
        lstoakes@gmail.com, fengwei.yin@intel.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mlock-avoid-folio_within_range-on-ksm-pages.patch added to mm-unstable branch
Message-Id: <20231024150453.EC2D1C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mlock: avoid folio_within_range() on KSM pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mlock-avoid-folio_within_range-on-ksm-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mlock-avoid-folio_within_range-on-ksm-pages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: mlock: avoid folio_within_range() on KSM pages
Date: Mon, 23 Oct 2023 23:38:41 -0700 (PDT)

Since commit dc68badcede4 ("mm: mlock: update mlock_pte_range to handle
large folio") I've just occasionally seen VM_WARN_ON_FOLIO(folio_test_ksm)
warnings from folio_within_range(), in a splurge after testing with KSM
hyperactive.

folio_referenced_one()'s use of folio_within_vma() is safe because it
checks folio_test_large() first; but allow_mlock_munlock() needs to do the
same to avoid those warnings (or check !folio_test_ksm() itself?  or move
either check into folio_within_range()?  hard to tell without more
examples of its use).

Link: https://lkml.kernel.org/r/23852f6a-5bfa-1ffd-30db-30c5560ad426@google.com
Fixes: dc68badcede4 ("mm: mlock: update mlock_pte_range to handle large folio")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Stefan Roesch <shr@devkernel.io>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/mlock.c~mm-mlock-avoid-folio_within_range-on-ksm-pages
+++ a/mm/mlock.c
@@ -346,6 +346,10 @@ static inline bool allow_mlock_munlock(s
 	if (!(vma->vm_flags & VM_LOCKED))
 		return true;
 
+	/* folio_within_range() cannot take KSM, but any small folio is OK */
+	if (!folio_test_large(folio))
+		return true;
+
 	/* folio not in range [start, end), skip mlock */
 	if (!folio_within_range(folio, vma, start, end))
 		return false;
_

Patches currently in -mm which might be from hughd@google.com are

hugetlbfs-drop-shared-numa-mempolicy-pretence.patch
kernfs-drop-shared-numa-mempolicy-hooks.patch
mempolicy-fix-migrate_pages2-syscall-return-nr_failed.patch
mempolicy-trivia-delete-those-ancient-pr_debugs.patch
mempolicy-trivia-slightly-more-consistent-naming.patch
mempolicy-trivia-use-pgoff_t-in-shared-mempolicy-tree.patch
mempolicy-mpol_shared_policy_init-without-pseudo-vma.patch
mempolicy-remove-confusing-mpol_mf_lazy-dead-code.patch
mm-add-page_rmappable_folio-wrapper.patch
mempolicy-alloc_pages_mpol-for-numa-policy-without-vma.patch
mempolicy-mmap_lock-is-not-needed-while-migrating-folios.patch
mempolicy-migration-attempt-to-match-interleave-nodes.patch
ext4-add-__gfp_nowarn-to-gfp_nowait-in-readahead.patch
mm-mlock-avoid-folio_within_range-on-ksm-pages.patch

