Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C67EC05027
	for <mm-commits@archiver.kernel.org>; Thu, 26 Jan 2023 22:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbjAZW4c (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 Jan 2023 17:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232830AbjAZW4b (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jan 2023 17:56:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEC56185
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 14:56:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC54C6191F
        for <mm-commits@vger.kernel.org>; Thu, 26 Jan 2023 22:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425ECC433EF;
        Thu, 26 Jan 2023 22:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674773789;
        bh=v7xOUf31dA/7KsuomfdgWTCQG3HvRCZMgjfUS73oz8A=;
        h=Date:To:From:Subject:From;
        b=yNGNlw4X3ar99mi7mC66UV2mEkPUEH2th6zYPE5R1WnT/Az507l7LCixQfMUJvfMT
         NpzdBcI0gSmz0sQ946JDbI54D3fXSJBhVKax5DWyxJyVrnkrCD4IQ/m+Tqbs6J8ddQ
         rz/q09P0rLt5GbdAih3KBFrTDswxLxF1SOwo6UTw=
Date:   Thu, 26 Jan 2023 14:56:28 -0800
To:     mm-commits@vger.kernel.org, ira.weiny@intel.com,
        fmdefrancesco@gmail.com, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-memcpy_from_file_folio.patch added to mm-unstable branch
Message-Id: <20230126225629.425ECC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add memcpy_from_file_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-memcpy_from_file_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-memcpy_from_file_folio.patch

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
Subject: mm: add memcpy_from_file_folio()
Date: Thu, 26 Jan 2023 20:15:52 +0000

This is the equivalent of memcpy_from_page().  It differs in that it takes
the position in a file instead of offset in a folio, it accepts the total
number of bytes to be copied (instead of the number of bytes to be copied
from this folio) and it returns how many bytes were copied from the folio,
rather than making the caller calculate that and then checking if the
caller got it right.

Link: https://lkml.kernel.org/r/20230126201552.1681588-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem.h    |   29 +++++++++++++++++++++++++++++
 include/linux/page-flags.h |    1 +
 2 files changed, 30 insertions(+)

--- a/include/linux/highmem.h~mm-add-memcpy_from_file_folio
+++ a/include/linux/highmem.h
@@ -414,6 +414,35 @@ static inline void memzero_page(struct p
 }
 
 /**
+ * memcpy_from_file_folio - Copy some bytes from a file folio.
+ * @to: The destination buffer.
+ * @folio: The folio to copy from.
+ * @pos: The position in the file.
+ * @len: The maximum number of bytes to copy.
+ *
+ * Copy up to @len bytes from this folio.  This may be limited by PAGE_SIZE
+ * if the folio comes from HIGHMEM, and by the size of the folio.
+ *
+ * Return: The number of bytes copied from the folio.
+ */
+static inline size_t memcpy_from_file_folio(char *to, struct folio *folio,
+		loff_t pos, size_t len)
+{
+	size_t offset = offset_in_folio(folio, pos);
+	char *from = kmap_local_folio(folio, offset);
+
+	if (folio_test_highmem(folio))
+		len = min(len, PAGE_SIZE - offset);
+	else
+		len = min(len, folio_size(folio) - offset);
+
+	memcpy(to, from, len);
+	kunmap_local(from);
+
+	return len;
+}
+
+/**
  * folio_zero_segments() - Zero two byte ranges in a folio.
  * @folio: The folio to write to.
  * @start1: The first byte to zero.
--- a/include/linux/page-flags.h~mm-add-memcpy_from_file_folio
+++ a/include/linux/page-flags.h
@@ -531,6 +531,7 @@ PAGEFLAG(Readahead, readahead, PF_NO_COM
  * available at this point.
  */
 #define PageHighMem(__p) is_highmem_idx(page_zonenum(__p))
+#define folio_test_highmem(__f)	is_highmem_idx(folio_zonenum(__f))
 #else
 PAGEFLAG_FALSE(HighMem, highmem)
 #endif
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-folio_pincount_ptr-and-head_compound_pincount.patch
mm-convert-head_subpages_mapcount-into-folio_nr_pages_mapped.patch
doc-clarify-refcount-section-by-referring-to-folios-pages.patch
mm-convert-total_compound_mapcount-to-folio_total_mapcount.patch
mm-convert-page_remove_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_anon_rmap-to-use-a-folio-internally.patch
mm-convert-page_add_file_rmap-to-use-a-folio-internally.patch
mm-add-folio_add_new_anon_rmap.patch
mm-add-folio_add_new_anon_rmap-fix-2.patch
page_alloc-use-folio-fields-directly.patch
mm-use-a-folio-in-hugepage_add_anon_rmap-and-hugepage_add_new_anon_rmap.patch
mm-use-entire_mapcount-in-__page_dup_rmap.patch
mm-debug-remove-call-to-head_compound_mapcount.patch
hugetlb-remove-uses-of-folio_mapcount_ptr.patch
mm-convert-page_mapcount-to-use-folio_entire_mapcount.patch
mm-remove-head_compound_mapcount-and-_ptr-functions.patch
mm-reimplement-compound_order.patch
mm-reimplement-compound_nr.patch
mm-reimplement-compound_nr-fix.patch
mm-convert-set_compound_page_dtor-and-set_compound_order-to-folios.patch
mm-convert-is_transparent_hugepage-to-use-a-folio.patch
mm-convert-destroy_large_folio-to-use-folio_dtor.patch
hugetlb-remove-uses-of-compound_dtor-and-compound_nr.patch
mm-remove-first-tail-page-members-from-struct-page.patch
doc-correct-struct-folio-kernel-doc.patch
mm-move-page-deferred_list-to-folio-_deferred_list.patch
mm-huge_memory-remove-page_deferred_list.patch
mm-huge_memory-convert-get_deferred_split_queue-to-take-a-folio.patch
mm-convert-deferred_split_huge_page-to-deferred_split_folio.patch
shmem-convert-shmem_write_end-to-use-a-folio.patch
mm-add-vma_alloc_zeroed_movable_folio.patch
mm-convert-do_anonymous_page-to-use-a-folio.patch
mm-convert-wp_page_copy-to-use-folios.patch
mm-use-a-folio-in-copy_pte_range.patch
mm-use-a-folio-in-copy_present_pte.patch
mm-fs-convert-inode_attach_wb-to-take-a-folio.patch
mm-convert-mem_cgroup_css_from_page-to-mem_cgroup_css_from_folio.patch
mm-remove-page_evictable.patch
mm-remove-mlock_vma_page.patch
mm-remove-munlock_vma_page.patch
mm-clean-up-mlock_page-munlock_page-references-in-comments.patch
rmap-add-folio-parameter-to-__page_set_anon_rmap.patch
filemap-convert-filemap_map_pmd-to-take-a-folio.patch
filemap-convert-filemap_range_has_page-to-use-a-folio.patch
readahead-convert-readahead_expand-to-use-a-folio.patch
mm-add-memcpy_from_file_folio.patch

