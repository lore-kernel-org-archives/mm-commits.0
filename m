Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D56EEB64DA
	for <mm-commits@archiver.kernel.org>; Mon, 10 Jul 2023 23:29:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbjGJX3j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 10 Jul 2023 19:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjGJX3g (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Jul 2023 19:29:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B6F98
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 16:29:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E23F61267
        for <mm-commits@vger.kernel.org>; Mon, 10 Jul 2023 23:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873E7C433C7;
        Mon, 10 Jul 2023 23:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1689031774;
        bh=LUOFZLknSMR2xr6NkqRoSO3zNMCkUwdfGrSnCzzucbk=;
        h=Date:To:From:Subject:From;
        b=TA21T22oWzjxnRemdg/bVN9AX6dl+ck/Nrx42+TTU72Td4JG+yMZqrMxdzWCbMJHQ
         bwy1xHYSJ4EuVQmHebSkhWOzhZxgdjAaqzmRs+/KB+2V3X0671pGlku3DUDqeyoCq8
         IgqKnivGSOdLKSNKF1Ak7z3r4eW57evVCPPr5pa4=
Date:   Mon, 10 Jul 2023 16:29:33 -0700
To:     mm-commits@vger.kernel.org, rppt@kernel.org,
        anshuman.khandual@arm.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-folio_flush_mapping.patch added to mm-unstable branch
Message-Id: <20230710232934.873E7C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add folio_flush_mapping()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-folio_flush_mapping.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-folio_flush_mapping.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: add folio_flush_mapping()
Date: Mon, 10 Jul 2023 21:43:05 +0100

This is the folio equivalent of page_mapping_file(), but rename it to make
it clear that it's very different from page_file_mapping(). 
Theoretically, there's nothing flush-only about it, but there are no other
users today, and I doubt there will be; it's almost always more useful to
know the swapfile's mapping or the swapcache's mapping.

Link: https://lkml.kernel.org/r/20230710204339.3554919-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/include/linux/pagemap.h~mm-add-folio_flush_mapping
+++ a/include/linux/pagemap.h
@@ -389,6 +389,26 @@ static inline struct address_space *foli
 	return folio->mapping;
 }
 
+/**
+ * folio_flush_mapping - Find the file mapping this folio belongs to.
+ * @folio: The folio.
+ *
+ * For folios which are in the page cache, return the mapping that this
+ * page belongs to.  Anonymous folios return NULL, even if they're in
+ * the swap cache.  Other kinds of folio also return NULL.
+ *
+ * This is ONLY used by architecture cache flushing code.  If you aren't
+ * writing cache flushing code, you want either folio_mapping() or
+ * folio_file_mapping().
+ */
+static inline struct address_space *folio_flush_mapping(struct folio *folio)
+{
+	if (unlikely(folio_test_swapcache(folio)))
+		return NULL;
+
+	return folio_mapping(folio);
+}
+
 static inline struct address_space *page_file_mapping(struct page *page)
 {
 	return folio_file_mapping(page_folio(page));
@@ -399,11 +419,7 @@ static inline struct address_space *page
  */
 static inline struct address_space *page_mapping_file(struct page *page)
 {
-	struct folio *folio = page_folio(page);
-
-	if (unlikely(folio_test_swapcache(folio)))
-		return NULL;
-	return folio_mapping(folio);
+	return folio_flush_mapping(page_folio(page));
 }
 
 /**
_

Patches currently in -mm which might be from willy@infradead.org are

rmap-pass-the-folio-to-__page_check_anon_rmap.patch
minmax-add-in_range-macro.patch
mm-convert-page_table_check_pte_set-to-page_table_check_ptes_set.patch
mm-add-generic-flush_icache_pages-and-documentation.patch
mm-add-folio_flush_mapping.patch
mm-remove-arch_implements_flush_dcache_folio.patch
mm-add-default-definition-of-set_ptes.patch
alpha-implement-the-new-page-table-range-api.patch
arc-implement-the-new-page-table-range-api.patch
arm-implement-the-new-page-table-range-api.patch
arm64-implement-the-new-page-table-range-api.patch
csky-implement-the-new-page-table-range-api.patch
hexagon-implement-the-new-page-table-range-api.patch
ia64-implement-the-new-page-table-range-api.patch
loongarch-implement-the-new-page-table-range-api.patch
m68k-implement-the-new-page-table-range-api.patch
microblaze-implement-the-new-page-table-range-api.patch
mips-implement-the-new-page-table-range-api.patch
nios2-implement-the-new-page-table-range-api.patch
openrisc-implement-the-new-page-table-range-api.patch
parisc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api.patch
riscv-implement-the-new-page-table-range-api.patch
s390-implement-the-new-page-table-range-api.patch
sh-implement-the-new-page-table-range-api.patch
sparc32-implement-the-new-page-table-range-api.patch
sparc64-implement-the-new-page-table-range-api.patch
um-implement-the-new-page-table-range-api.patch
x86-implement-the-new-page-table-range-api.patch
xtensa-implement-the-new-page-table-range-api.patch
mm-remove-page_mapping_file.patch
mm-rationalise-flush_icache_pages-and-flush_icache_page.patch
mm-tidy-up-set_ptes-definition.patch
mm-use-flush_icache_pages-in-do_set_pmd.patch
mm-call-update_mmu_cache_range-in-more-page-fault-handling-paths.patch

