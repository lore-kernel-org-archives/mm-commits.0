Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE885C7EE21
	for <mm-commits@archiver.kernel.org>; Wed,  3 May 2023 02:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjECCSL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 May 2023 22:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjECCSK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 2 May 2023 22:18:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FC73C26
        for <mm-commits@vger.kernel.org>; Tue,  2 May 2023 19:18:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C8BC60B78
        for <mm-commits@vger.kernel.org>; Wed,  3 May 2023 02:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FCD6C433D2;
        Wed,  3 May 2023 02:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683080286;
        bh=I3OoJtOpq/DaWBtRrP1ELVAk1vWykpR/bSC6bvBZx3Y=;
        h=Date:To:From:Subject:From;
        b=VRfRuhoDlVDeObLYAY8+7GNvex6A1s80pNB96giDeyppuebVFpOFlLxwOeBuOT5fo
         fYobDm4yHNxByjAVgyv1h5R1aRwIBPcgvImFDbwPQLh8e+wfY3AnfC38F4DZ3xSBmw
         f17zFWTB2MLVkEOjh4x3HFqIoa6kJ165OxnqPEGY=
Date:   Tue, 02 May 2023 19:18:05 -0700
To:     mm-commits@vger.kernel.org, lstoakes@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings-fix.patch added to mm-unstable branch
Message-Id: <20230503021806.8FCD6C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings-fix
Date: Tue May  2 05:25:41 PM PDT 2023

move folio_fast_pin_allowed() inside #ifdef CONFIG_ARCH_HAS_PTE_SPECIAL to
avoid defined but not used warning

Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |  154 ++++++++++++++++++++++++++---------------------------
 1 file changed, 77 insertions(+), 77 deletions(-)

--- a/mm/gup.c~mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings-fix
+++ a/mm/gup.c
@@ -96,83 +96,6 @@ retry:
 	return folio;
 }
 
-/*
- * Used in the GUP-fast path to determine whether a pin is permitted for a
- * specific folio.
- *
- * This call assumes the caller has pinned the folio, that the lowest page table
- * level still points to this folio, and that interrupts have been disabled.
- *
- * Writing to pinned file-backed dirty tracked folios is inherently problematic
- * (see comment describing the writable_file_mapping_allowed() function). We
- * therefore try to avoid the most egregious case of a long-term mapping doing
- * so.
- *
- * This function cannot be as thorough as that one as the VMA is not available
- * in the fast path, so instead we whitelist known good cases and if in doubt,
- * fall back to the slow path.
- */
-static bool folio_fast_pin_allowed(struct folio *folio, unsigned int flags)
-{
-	struct address_space *mapping;
-	unsigned long mapping_flags;
-
-	/*
-	 * If we aren't pinning then no problematic write can occur. A long term
-	 * pin is the most egregious case so this is the one we disallow.
-	 */
-	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) !=
-	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
-		return true;
-
-	/* The folio is pinned, so we can safely access folio fields. */
-
-	/* Neither of these should be possible, but check to be sure. */
-	if (unlikely(folio_test_slab(folio) || folio_test_swapcache(folio)))
-		return false;
-
-	/* hugetlb mappings do not require dirty-tracking. */
-	if (folio_test_hugetlb(folio))
-		return true;
-
-	/*
-	 * GUP-fast disables IRQs. When IRQS are disabled, RCU grace periods
-	 * cannot proceed, which means no actions performed under RCU can
-	 * proceed either.
-	 *
-	 * inodes and thus their mappings are freed under RCU, which means the
-	 * mapping cannot be freed beneath us and thus we can safely dereference
-	 * it.
-	 */
-	lockdep_assert_irqs_disabled();
-
-	/*
-	 * However, there may be operations which _alter_ the mapping, so ensure
-	 * we read it once and only once.
-	 */
-	mapping = READ_ONCE(folio->mapping);
-
-	/*
-	 * The mapping may have been truncated, in any case we cannot determine
-	 * if this mapping is safe - fall back to slow path to determine how to
-	 * proceed.
-	 */
-	if (!mapping)
-		return false;
-
-	/* Anonymous folios are fine, other non-file backed cases are not. */
-	mapping_flags = (unsigned long)mapping & PAGE_MAPPING_FLAGS;
-	if (mapping_flags)
-		return mapping_flags == PAGE_MAPPING_ANON;
-
-	/*
-	 * At this point, we know the mapping is non-null and points to an
-	 * address_space object. The only remaining whitelisted file system is
-	 * shmem.
-	 */
-	return shmem_mapping(mapping);
-}
-
 /**
  * try_grab_folio() - Attempt to get or pin a folio.
  * @page:  pointer to page to be grabbed
@@ -2474,6 +2397,83 @@ static void __maybe_unused undo_dev_page
 
 #ifdef CONFIG_ARCH_HAS_PTE_SPECIAL
 /*
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
+	/* Neither of these should be possible, but check to be sure. */
+	if (unlikely(folio_test_slab(folio) || folio_test_swapcache(folio)))
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
+	/* Anonymous folios are fine, other non-file backed cases are not. */
+	mapping_flags = (unsigned long)mapping & PAGE_MAPPING_FLAGS;
+	if (mapping_flags)
+		return mapping_flags == PAGE_MAPPING_ANON;
+
+	/*
+	 * At this point, we know the mapping is non-null and points to an
+	 * address_space object. The only remaining whitelisted file system is
+	 * shmem.
+	 */
+	return shmem_mapping(mapping);
+}
+
+/*
  * Fast-gup relies on pte change detection to avoid concurrent pgtable
  * operations.
  *
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch
mm-gup-disallow-foll_longterm-gup-fast-writing-to-file-backed-mappings-fix.patch

