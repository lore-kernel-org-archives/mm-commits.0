Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C379C001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236992AbjHKXA3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237083AbjHKW7k (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 18:59:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A352B3A9C
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 15:59:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4180C6556B
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 22:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B02C433C7;
        Fri, 11 Aug 2023 22:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794769;
        bh=/BCtFdbRNW6uqBN+6Np9KCJyCVSQ4RcismzBUEv53Ug=;
        h=Date:To:From:Subject:From;
        b=ZIiB/bK9tgGiIpEwsKtbTU0fZ0IJX5Wei1vIFJYPQXnyk08IWFaZDe/f88RJSdnQ+
         jPmhQtVNHH6HzCQLXmeIsy5TDw6btm7XH2M4tbYKV0pC2LH4ni9R/WMX10vFrssbcA
         mQZpQuJH6Y4quzSmj3WZqdNft4UTNNGGg8mJuYwo=
Date:   Fri, 11 Aug 2023 15:59:29 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] rmap-pass-the-folio-to-__page_check_anon_rmap.patch removed from -mm tree
Message-Id: <20230811225929.94B02C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: rmap: pass the folio to __page_check_anon_rmap()
has been removed from the -mm tree.  Its filename was
     rmap-pass-the-folio-to-__page_check_anon_rmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: rmap: pass the folio to __page_check_anon_rmap()
Date: Thu, 6 Jul 2023 20:52:51 +0100

The lone caller already has the folio, so pass it in instead of deriving
it from the page again.

Link: https://lkml.kernel.org/r/20230706195251.2707542-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/rmap.c~rmap-pass-the-folio-to-__page_check_anon_rmap
+++ a/mm/rmap.c
@@ -1175,14 +1175,14 @@ out:
 
 /**
  * __page_check_anon_rmap - sanity check anonymous rmap addition
- * @page:	the page to add the mapping to
+ * @folio:	The folio containing @page.
+ * @page:	the page to check the mapping of
  * @vma:	the vm area in which the mapping is added
  * @address:	the user virtual address mapped
  */
-static void __page_check_anon_rmap(struct page *page,
+static void __page_check_anon_rmap(struct folio *folio, struct page *page,
 	struct vm_area_struct *vma, unsigned long address)
 {
-	struct folio *folio = page_folio(page);
 	/*
 	 * The page's anon-rmap details (mapping and index) are guaranteed to
 	 * be set up correctly at this point.
@@ -1262,7 +1262,7 @@ void page_add_anon_rmap(struct page *pag
 			__page_set_anon_rmap(folio, page, vma, address,
 					     !!(flags & RMAP_EXCLUSIVE));
 		else
-			__page_check_anon_rmap(page, vma, address);
+			__page_check_anon_rmap(folio, page, vma, address);
 	}
 
 	mlock_vma_folio(folio, vma, compound);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-drop-per-vma-lock-when-returning-vm_fault_retry-or-vm_fault_completed-fix.patch
zswap-make-zswap_store-take-a-folio.patch
memcg-convert-get_obj_cgroup_from_page-to-get_obj_cgroup_from_folio.patch
swap-remove-some-calls-to-compound_head-in-swap_readpage.patch
zswap-make-zswap_load-take-a-folio.patch
mm-improve-the-comment-in-isolate_migratepages_block.patch
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
ia64-implement-the-new-page-table-range-api-fix.patch
loongarch-implement-the-new-page-table-range-api.patch
m68k-implement-the-new-page-table-range-api.patch
microblaze-implement-the-new-page-table-range-api.patch
mips-implement-the-new-page-table-range-api.patch
nios2-implement-the-new-page-table-range-api.patch
openrisc-implement-the-new-page-table-range-api.patch
parisc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api.patch
powerpc-implement-the-new-page-table-range-api-fix.patch
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

