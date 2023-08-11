Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29629C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:03:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236873AbjHKXD5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235786AbjHKXCv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:02:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91820421F
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 324D36492D
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA2AC433C7;
        Fri, 11 Aug 2023 23:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794865;
        bh=RSIuj+FW5dSJi2TdZF1+EfU+fKD1hgfY9Ck2XZBBnFQ=;
        h=Date:To:From:Subject:From;
        b=esD/2BtDD2qxth3uDFlh+x0vt879HpWMPZb1K9zvn3djltWkQHUCTu+PAHOM0NPOK
         33z2s7I6d8jwFQFrsU4TaRZ2j5aE5iiBrejQny+7VFISlz1fjdzuw5euvmXAyeqtaL
         beU27UB8jcCesX2rugIaAW5m8/RjHPIsLzggPbkk=
Date:   Fri, 11 Aug 2023 16:01:05 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        trix@redhat.com, p.raghav@samsung.com, ndesaulniers@google.com,
        nathan@kernel.org, jack@suse.com, dsterba@suse.com,
        brauner@kernel.org, almaz.alexandrovich@paragon-software.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] affs-convert-affs_symlink_read_folio-to-use-the-folio.patch removed from -mm tree
Message-Id: <20230811230105.8CA2AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: affs: convert affs_symlink_read_folio() to use the folio
has been removed from the -mm tree.  Its filename was
     affs-convert-affs_symlink_read_folio-to-use-the-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: affs: convert affs_symlink_read_folio() to use the folio
Date: Thu, 13 Jul 2023 04:55:07 +0100

Remove use of the old page APIs.  That includes use of setting PageError
on error; simply not setting the uptodate flag is sufficient.

Link: https://lkml.kernel.org/r/20230713035512.4139457-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Sterba <dsterba@suse.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.com>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/symlink.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/fs/affs/symlink.c~affs-convert-affs_symlink_read_folio-to-use-the-folio
+++ a/fs/affs/symlink.c
@@ -13,10 +13,9 @@
 
 static int affs_symlink_read_folio(struct file *file, struct folio *folio)
 {
-	struct page *page = &folio->page;
 	struct buffer_head *bh;
-	struct inode *inode = page->mapping->host;
-	char *link = page_address(page);
+	struct inode *inode = folio->mapping->host;
+	char *link = folio_address(folio);
 	struct slink_front *lf;
 	int			 i, j;
 	char			 c;
@@ -58,12 +57,11 @@ static int affs_symlink_read_folio(struc
 	}
 	link[i] = '\0';
 	affs_brelse(bh);
-	SetPageUptodate(page);
-	unlock_page(page);
+	folio_mark_uptodate(folio);
+	folio_unlock(folio);
 	return 0;
 fail:
-	SetPageError(page);
-	unlock_page(page);
+	folio_unlock(folio);
 	return -EIO;
 }
 
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

