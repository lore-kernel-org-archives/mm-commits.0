Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64C66C77B7C
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 20:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbjEEUa6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 16:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbjEEUa4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 16:30:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD3E449C
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 13:30:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8454D61539
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 20:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FEFC433D2;
        Fri,  5 May 2023 20:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683318653;
        bh=DkcgVMjh7CXgIXS56USS+yT0OG0cdX5JoRkCPjoG7+M=;
        h=Date:To:From:Subject:From;
        b=05nLaAzdr4AceEnYrhZ1WXNOsKzzRFSA/iiB0Q10Go0kYLlPUasJgP0wReLEau1uS
         5uNa2SDQsmm6iMgiV6lZ20qVY7b4UqtFV70Q3BVCmtufW3OxAmV067fKYOkx6Scq90
         7OGO3ByspVgMzrcKuTq8oackR36SM6NV6dDJ31xo=
Date:   Fri, 05 May 2023 13:30:53 -0700
To:     mm-commits@vger.kernel.org, peterz@infradead.org,
        mpenttil@redhat.com, kirill@shutemov.name, jhubbard@nvidia.com,
        jgg@nvidia.com, jack@suse.cz, david@redhat.com, lstoakes@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings.patch added to mm-unstable branch
Message-Id: <20230505203053.D8FEFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: disallow FOLL_LONGTERM GUP-fast writing to file-backed mappings
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings.patch

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
From: Lorenzo Stoakes <lstoakes@gmail.com>
Subject: mm/gup: disallow FOLL_LONGTERM GUP-fast writing to file-backed mappings
Date: Thu, 4 May 2023 22:27:53 +0100

Writing to file-backed dirty-tracked mappings via GUP is inherently broken
as we cannot rule out folios being cleaned and then a GUP user writing to
them again and possibly marking them dirty unexpectedly.

This is especially egregious for long-term mappings (as indicated by the
use of the FOLL_LONGTERM flag), so we disallow this case in GUP-fast as we
have already done in the slow path.

We have access to less information in the fast path as we cannot examine
the VMA containing the mapping, however we can determine whether the folio
is anonymous or belonging to a whitelisted filesystem - specifically
hugetlb and shmem mappings.

We take special care to ensure that both the folio and mapping are safe to
access when performing these checks and document folio_fast_pin_allowed()
accordingly.

It's important to note that there are no APIs allowing users to specify
FOLL_FAST_ONLY for a PUP-fast let alone with FOLL_LONGTERM, so we can
always rely on the fact that if we fail to pin on the fast path, the code
will fall back to the slow path which can perform the more thorough check.

Link: https://lkml.kernel.org/r/a27d39b87ded7f3dad5fd4181edb106393660453.1683235180.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Kirill A . Shutemov <kirill@shutemov.name>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |  101 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

--- a/mm/gup.c~mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings
+++ a/mm/gup.c
@@ -18,6 +18,7 @@
 #include <linux/migrate.h>
 #include <linux/mm_inline.h>
 #include <linux/sched/mm.h>
+#include <linux/shmem_fs.h>
 
 #include <asm/mmu_context.h>
 #include <asm/tlbflush.h>
@@ -2379,6 +2380,82 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
  */
 #ifdef CONFIG_HAVE_FAST_GUP
 
+/*
+ * Used in the GUP-fast path to determine whether a pin is permitted for a
+ * specific folio.
+ *
+ * This call assumes the caller has pinned the folio, that the lowest page table
+ * level still points to this folio, and that interrupts have been disabled.
+ *
+ * Writing to pinned file-backed dirty tracked folios is inherently problematic
+ * (see comment describing the writable_file_mapping_allowed() function). We
+ * therefore try to avoid the most egregious case of a long-term mapping doing
+ * so.
+ *
+ * This function cannot be as thorough as that one as the VMA is not available
+ * in the fast path, so instead we whitelist known good cases and if in doubt,
+ * fall back to the slow path.
+ */
+static bool folio_fast_pin_allowed(struct folio *folio, unsigned int flags)
+{
+	struct address_space *mapping;
+	unsigned long mapping_flags;
+
+	/*
+	 * If we aren't pinning then no problematic write can occur. A long term
+	 * pin is the most egregious case so this is the one we disallow.
+	 */
+	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) !=
+	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
+		return true;
+
+	/* The folio is pinned, so we can safely access folio fields. */
+
+	if (WARN_ON_ONCE(folio_test_slab(folio)))
+		return false;
+
+	/* hugetlb mappings do not require dirty-tracking. */
+	if (folio_test_hugetlb(folio))
+		return true;
+
+	/*
+	 * GUP-fast disables IRQs. When IRQS are disabled, RCU grace periods
+	 * cannot proceed, which means no actions performed under RCU can
+	 * proceed either.
+	 *
+	 * inodes and thus their mappings are freed under RCU, which means the
+	 * mapping cannot be freed beneath us and thus we can safely dereference
+	 * it.
+	 */
+	lockdep_assert_irqs_disabled();
+
+	/*
+	 * However, there may be operations which _alter_ the mapping, so ensure
+	 * we read it once and only once.
+	 */
+	mapping = READ_ONCE(folio->mapping);
+
+	/*
+	 * The mapping may have been truncated, in any case we cannot determine
+	 * if this mapping is safe - fall back to slow path to determine how to
+	 * proceed.
+	 */
+	if (!mapping)
+		return false;
+
+	/* Anonymous folios pose no problem. */
+	mapping_flags = (unsigned long)mapping & PAGE_MAPPING_FLAGS;
+	if (mapping_flags)
+		return mapping_flags & PAGE_MAPPING_ANON;
+
+	/*
+	 * At this point, we know the mapping is non-null and points to an
+	 * address_space object. The only remaining whitelisted file system is
+	 * shmem.
+	 */
+	return shmem_mapping(mapping);
+}
+
 static void __maybe_unused undo_dev_pagemap(int *nr, int nr_start,
 					    unsigned int flags,
 					    struct page **pages)
@@ -2464,6 +2541,11 @@ static int gup_pte_range(pmd_t pmd, pmd_
 			goto pte_unmap;
 		}
 
+		if (!folio_fast_pin_allowed(folio, flags)) {
+			gup_put_folio(folio, 1, flags);
+			goto pte_unmap;
+		}
+
 		if (!pte_write(pte) && gup_must_unshare(NULL, flags, page)) {
 			gup_put_folio(folio, 1, flags);
 			goto pte_unmap;
@@ -2656,6 +2738,11 @@ static int gup_hugepte(pte_t *ptep, unsi
 		return 0;
 	}
 
+	if (!folio_fast_pin_allowed(folio, flags)) {
+		gup_put_folio(folio, refs, flags);
+		return 0;
+	}
+
 	if (!pte_write(pte) && gup_must_unshare(NULL, flags, &folio->page)) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
@@ -2722,6 +2809,10 @@ static int gup_huge_pmd(pmd_t orig, pmd_
 		return 0;
 	}
 
+	if (!folio_fast_pin_allowed(folio, flags)) {
+		gup_put_folio(folio, refs, flags);
+		return 0;
+	}
 	if (!pmd_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
@@ -2762,6 +2853,11 @@ static int gup_huge_pud(pud_t orig, pud_
 		return 0;
 	}
 
+	if (!folio_fast_pin_allowed(folio, flags)) {
+		gup_put_folio(folio, refs, flags);
+		return 0;
+	}
+
 	if (!pud_write(orig) && gup_must_unshare(NULL, flags, &folio->page)) {
 		gup_put_folio(folio, refs, flags);
 		return 0;
@@ -2796,6 +2892,11 @@ static int gup_huge_pgd(pgd_t orig, pgd_
 		gup_put_folio(folio, refs, flags);
 		return 0;
 	}
+
+	if (!folio_fast_pin_allowed(folio, flags)) {
+		gup_put_folio(folio, refs, flags);
+		return 0;
+	}
 
 	*nr += refs;
 	folio_set_referenced(folio);
_

Patches currently in -mm which might be from lstoakes@gmail.com are

mm-mmap-vma_merge-always-check-invariants.patch
mm-mmap-separate-writenotify-and-dirty-tracking-logic.patch
mm-gup-disallow-foll_longterm-gup-nonfast-writing-to-file-backed-mappings.patch
mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings.patch

