Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11376C04A94
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:04:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235784AbjHKXD7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236977AbjHKXCw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:02:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D20D4227
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:01:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B08AD6526A
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C4CC433C7;
        Fri, 11 Aug 2023 23:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794870;
        bh=twUUnzwyi12nCFQQjmkFx1VHOd97Hszk4CebtDwyCc4=;
        h=Date:To:From:Subject:From;
        b=nmMjHHoZNJTviwx+nGgVNP6xtaVh7UsDqHNzSgxvfpJLecpWv4nB44ZJ879xXRnPE
         qEqDjbcEdZRxuZDvUQ3HVPraGYrVvCzH7bdaP7Ed+o0FI6YbGNxgA8rw/rfxwTPJBc
         plb438V1ErlEjEfaQZ26+pb/gzvA1i+pbWWl+KF8=
Date:   Fri, 11 Aug 2023 16:01:09 -0700
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk, tytso@mit.edu,
        trix@redhat.com, p.raghav@samsung.com, ndesaulniers@google.com,
        nathan@kernel.org, jack@suse.cz, dsterba@suse.com,
        brauner@kernel.org, almaz.alexandrovich@paragon-software.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] jbd2-use-a-folio-in-jbd2_journal_write_metadata_buffer.patch removed from -mm tree
Message-Id: <20230811230110.13C4CC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: jbd2: use a folio in jbd2_journal_write_metadata_buffer()
has been removed from the -mm tree.  Its filename was
     jbd2-use-a-folio-in-jbd2_journal_write_metadata_buffer.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: jbd2: use a folio in jbd2_journal_write_metadata_buffer()
Date: Thu, 13 Jul 2023 04:55:11 +0100

The primary goal here is removing the use of set_bh_page().  Take the
opportunity to switch from kmap_atomic() to kmap_local().  This simplifies
the function as the offset is already added to the pointer.

Link: https://lkml.kernel.org/r/20230713035512.4139457-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c |   35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

--- a/fs/jbd2/journal.c~jbd2-use-a-folio-in-jbd2_journal_write_metadata_buffer
+++ a/fs/jbd2/journal.c
@@ -341,7 +341,7 @@ int jbd2_journal_write_metadata_buffer(t
 	int do_escape = 0;
 	char *mapped_data;
 	struct buffer_head *new_bh;
-	struct page *new_page;
+	struct folio *new_folio;
 	unsigned int new_offset;
 	struct buffer_head *bh_in = jh2bh(jh_in);
 	journal_t *journal = transaction->t_journal;
@@ -370,14 +370,14 @@ repeat:
 	 */
 	if (jh_in->b_frozen_data) {
 		done_copy_out = 1;
-		new_page = virt_to_page(jh_in->b_frozen_data);
-		new_offset = offset_in_page(jh_in->b_frozen_data);
+		new_folio = virt_to_folio(jh_in->b_frozen_data);
+		new_offset = offset_in_folio(new_folio, jh_in->b_frozen_data);
 	} else {
-		new_page = jh2bh(jh_in)->b_page;
-		new_offset = offset_in_page(jh2bh(jh_in)->b_data);
+		new_folio = jh2bh(jh_in)->b_folio;
+		new_offset = offset_in_folio(new_folio, jh2bh(jh_in)->b_data);
 	}
 
-	mapped_data = kmap_atomic(new_page);
+	mapped_data = kmap_local_folio(new_folio, new_offset);
 	/*
 	 * Fire data frozen trigger if data already wasn't frozen.  Do this
 	 * before checking for escaping, as the trigger may modify the magic
@@ -385,18 +385,17 @@ repeat:
 	 * data in the buffer.
 	 */
 	if (!done_copy_out)
-		jbd2_buffer_frozen_trigger(jh_in, mapped_data + new_offset,
+		jbd2_buffer_frozen_trigger(jh_in, mapped_data,
 					   jh_in->b_triggers);
 
 	/*
 	 * Check for escaping
 	 */
-	if (*((__be32 *)(mapped_data + new_offset)) ==
-				cpu_to_be32(JBD2_MAGIC_NUMBER)) {
+	if (*((__be32 *)mapped_data) == cpu_to_be32(JBD2_MAGIC_NUMBER)) {
 		need_copy_out = 1;
 		do_escape = 1;
 	}
-	kunmap_atomic(mapped_data);
+	kunmap_local(mapped_data);
 
 	/*
 	 * Do we need to do a data copy?
@@ -417,12 +416,10 @@ repeat:
 		}
 
 		jh_in->b_frozen_data = tmp;
-		mapped_data = kmap_atomic(new_page);
-		memcpy(tmp, mapped_data + new_offset, bh_in->b_size);
-		kunmap_atomic(mapped_data);
+		memcpy_from_folio(tmp, new_folio, new_offset, bh_in->b_size);
 
-		new_page = virt_to_page(tmp);
-		new_offset = offset_in_page(tmp);
+		new_folio = virt_to_folio(tmp);
+		new_offset = offset_in_folio(new_folio, tmp);
 		done_copy_out = 1;
 
 		/*
@@ -438,12 +435,12 @@ repeat:
 	 * copying, we can finally do so.
 	 */
 	if (do_escape) {
-		mapped_data = kmap_atomic(new_page);
-		*((unsigned int *)(mapped_data + new_offset)) = 0;
-		kunmap_atomic(mapped_data);
+		mapped_data = kmap_local_folio(new_folio, new_offset);
+		*((unsigned int *)mapped_data) = 0;
+		kunmap_local(mapped_data);
 	}
 
-	set_bh_page(new_bh, new_page, new_offset);
+	folio_set_bh(new_bh, new_folio, new_offset);
 	new_bh->b_size = bh_in->b_size;
 	new_bh->b_bdev = journal->j_dev;
 	new_bh->b_blocknr = blocknr;
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

