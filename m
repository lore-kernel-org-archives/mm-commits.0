Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC6BC001DB
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbjHKXD5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236837AbjHKXCw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:02:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E8B4225
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91A5D62BDB
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E93FAC433C8;
        Fri, 11 Aug 2023 23:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794869;
        bh=oin8CA9FT6ruYNCmGlal+Jsc4CaYmKKgQILdG3sYoHw=;
        h=Date:To:From:Subject:From;
        b=sFNN/aw8xZItf9AXMBCCjW2Ygr8snEZyrAejY56kxMUQ/ro6Yf+EyspVyewbvx/pF
         TgdTiiA36b6/a0NYbwoY3lct2VVuSi6YINgaNp4VzriiYvKQhi8dvxSCLTekOS4Psa
         0eC0XFVpnclKu9wruOCXCr+f9rFGHbqVhwwyZ9mA=
Date:   Fri, 11 Aug 2023 16:01:08 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        trix@redhat.com, p.raghav@samsung.com, ndesaulniers@google.com,
        nathan@kernel.org, jack@suse.com, dsterba@suse.com,
        brauner@kernel.org, almaz.alexandrovich@paragon-software.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ntfs3-convert-ntfs_get_block_vbo-to-use-a-folio.patch removed from -mm tree
Message-Id: <20230811230108.E93FAC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ntfs3: convert ntfs_get_block_vbo() to use a folio
has been removed from the -mm tree.  Its filename was
     ntfs3-convert-ntfs_get_block_vbo-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ntfs3: convert ntfs_get_block_vbo() to use a folio
Date: Thu, 13 Jul 2023 04:55:10 +0100

Remove a user of set_bh_page().

Link: https://lkml.kernel.org/r/20230713035512.4139457-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Tom Rix <trix@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Jan Kara <jack@suse.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ntfs3/inode.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/ntfs3/inode.c~ntfs3-convert-ntfs_get_block_vbo-to-use-a-folio
+++ a/fs/ntfs3/inode.c
@@ -554,7 +554,7 @@ static noinline int ntfs_get_block_vbo(s
 	struct super_block *sb = inode->i_sb;
 	struct ntfs_sb_info *sbi = sb->s_fs_info;
 	struct ntfs_inode *ni = ntfs_i(inode);
-	struct page *page = bh->b_page;
+	struct folio *folio = bh->b_folio;
 	u8 cluster_bits = sbi->cluster_bits;
 	u32 block_size = sb->s_blocksize;
 	u64 bytes, lbo, valid;
@@ -569,7 +569,7 @@ static noinline int ntfs_get_block_vbo(s
 
 	if (is_resident(ni)) {
 		ni_lock(ni);
-		err = attr_data_read_resident(ni, page);
+		err = attr_data_read_resident(ni, &folio->page);
 		ni_unlock(ni);
 
 		if (!err)
@@ -642,17 +642,17 @@ static noinline int ntfs_get_block_vbo(s
 		 */
 		bytes = block_size;
 
-		if (page) {
+		if (folio) {
 			u32 voff = valid - vbo;
 
 			bh->b_size = block_size;
 			off = vbo & (PAGE_SIZE - 1);
-			set_bh_page(bh, page, off);
+			folio_set_bh(bh, folio, off);
 
 			err = bh_read(bh, 0);
 			if (err < 0)
 				goto out;
-			zero_user_segment(page, off + voff, off + block_size);
+			folio_zero_segment(folio, off + voff, off + block_size);
 		}
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

