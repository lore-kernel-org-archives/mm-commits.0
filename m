Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8731386D6
	for <mm-commits@vger.kernel.org>; Tue, 16 Apr 2024 20:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713297632; cv=none; b=XGqVEkfISs6iDixW94M0h5jmO0qsijADgedG3g3br/XRde7Mx9iUoIqQcyoLsrT1J2O2hqkOxOHq/SJhuuCB0UO4cEh6yDUg8ePFuO9EaM73127xkFyeNON98QC6dXggsgB6znsEHUZcQoC3rpg6L2POGh8dmdPLi52ju6HT9gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713297632; c=relaxed/simple;
	bh=sYPtCqgOGFXrEh4M56x/6nqHVkG4GqMcuxwuag56Kt4=;
	h=Date:To:From:Subject:Message-Id; b=YeBnwT2H2EE61BxuDw+jMEORYns0LXAOKSs19h2GmV7zBv2cDRDl/eQMlOtysvT0OZKKEazSv3iDcm4ZoqXgzxnPPH2Hx1EHhQ/kbf5Xt65QOpbWPLVP0JL8+j6/MS0+GUwMXdxkZQ0SAbi++yDbtIyFDJ4NNUI+JnGGtaUaz7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q03uVa+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q03uVa+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0EBC113CE;
	Tue, 16 Apr 2024 20:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1713297632;
	bh=sYPtCqgOGFXrEh4M56x/6nqHVkG4GqMcuxwuag56Kt4=;
	h=Date:To:From:Subject:From;
	b=Q03uVa+TXNqxUOJsgQsaYWdhj48Za26q4pyNehB0VXWQS/LrRFfSeqImMBDEs5k/V
	 uwjdsJCzLFtN+kVC7itvpzJfm9MsUttfniPVGGe2T7vWu5Xxy3vhgITaOsYCdAoRoF
	 bdNM35TJ1Do4JY4Kh+y7fMTt1YmiQP6dBGQ0p/ro=
Date: Tue, 16 Apr 2024 13:00:31 -0700
To: mm-commits@vger.kernel.org,p.raghav@samsung.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + doc-split-bufferrst-out-of-api-summaryrst.patch added to mm-unstable branch
Message-Id: <20240416200032.1C0EBC113CE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: doc: split buffer.rst out of api-summary.rst
has been added to the -mm mm-unstable branch.  Its filename is
     doc-split-bufferrst-out-of-api-summaryrst.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/doc-split-bufferrst-out-of-api-summaryrst.patch

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
Subject: doc: split buffer.rst out of api-summary.rst
Date: Tue, 16 Apr 2024 04:17:52 +0100

Buffer heads are no longer a generic filesystem API but an optional
filesystem support library.  Make the documentation structure reflect
that, and include the fine documentation kept in buffer_head.h.  We could
give a better overview of what buffer heads are all about, but my
enthusiasm for documenting it is limited.

Link: https://lkml.kernel.org/r/20240416031754.4076917-9-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/api-summary.rst |    3 ---
 Documentation/filesystems/index.rst       |    1 +
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/Documentation/filesystems/api-summary.rst~doc-split-bufferrst-out-of-api-summaryrst
+++ a/Documentation/filesystems/api-summary.rst
@@ -56,9 +56,6 @@ Other Functions
 .. kernel-doc:: fs/namei.c
    :export:
 
-.. kernel-doc:: fs/buffer.c
-   :export:
-
 .. kernel-doc:: block/bio.c
    :export:
 
--- a/Documentation/filesystems/index.rst~doc-split-bufferrst-out-of-api-summaryrst
+++ a/Documentation/filesystems/index.rst
@@ -50,6 +50,7 @@ filesystem implementations.
 .. toctree::
    :maxdepth: 2
 
+   buffer
    journalling
    fscrypt
    fsverity
_

Patches currently in -mm which might be from willy@infradead.org are

mm-always-initialise-folio-_deferred_list.patch
mm-create-folio_flag_false-and-folio_type_ops-macros.patch
mm-remove-folio_prep_large_rmappable.patch
mm-support-page_mapcount-on-page_has_type-pages.patch
mm-turn-folio_test_hugetlb-into-a-pagetype.patch
mm-turn-folio_test_hugetlb-into-a-pagetype-fix.patch
mm-remove-a-call-to-compound_head-from-is_page_hwpoison.patch
mm-free-up-pg_slab.patch
mm-free-up-pg_slab-fix.patch
mm-improve-dumping-of-mapcount-and-page_type.patch
hugetlb-remove-mention-of-destructors.patch
sh-remove-use-of-pg_arch_1-on-individual-pages.patch
xtensa-remove-uses-of-pg_arch_1-on-individual-pages.patch
mm-make-page_ext_get-take-a-const-argument.patch
mm-make-folio_test_idle-and-folio_test_young-take-a-const-argument.patch
mm-make-is_free_buddy_page-take-a-const-argument.patch
mm-make-page_mapped-take-a-const-argument.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio.patch
mm-convert-arch_clear_hugepage_flags-to-take-a-folio-fix.patch
slub-remove-use-of-page-flags.patch
remove-references-to-page-flags-in-documentation.patch
proc-rewrite-stable_page_flags.patch
proc-rewrite-stable_page_flags-fix.patch
proc-rewrite-stable_page_flags-fix-2.patch
sparc-use-is_huge_zero_pmd.patch
mm-add-is_huge_zero_folio.patch
mm-add-pmd_folio.patch
mm-convert-migrate_vma_collect_pmd-to-use-a-folio.patch
mm-convert-huge_zero_page-to-huge_zero_folio.patch
mm-convert-do_huge_pmd_anonymous_page-to-huge_zero_folio.patch
dax-use-huge_zero_folio.patch
mm-rename-mm_put_huge_zero_page-to-mm_put_huge_zero_folio.patch
mm-use-rwsem-assertion-macros-for-mmap_lock.patch
filemap-remove-__set_page_dirty.patch
mm-correct-page_mapped_in_vma-for-large-folios.patch
mm-remove-vma_address.patch
mm-rename-vma_pgoff_address-back-to-vma_address.patch
khugepaged-inline-hpage_collapse_alloc_folio.patch
khugepaged-convert-alloc_charge_hpage-to-alloc_charge_folio.patch
khugepaged-remove-hpage-from-collapse_huge_page.patch
khugepaged-pass-a-folio-to-__collapse_huge_page_copy.patch
khugepaged-remove-hpage-from-collapse_file.patch
khugepaged-use-a-folio-throughout-collapse_file.patch
khugepaged-use-a-folio-throughout-collapse_file-fix.patch
khugepaged-use-a-folio-throughout-hpage_collapse_scan_file.patch
proc-convert-clear_refs_pte_range-to-use-a-folio.patch
proc-convert-smaps_account-to-use-a-folio.patch
mm-remove-page_idle-and-page_young-wrappers.patch
mm-generate-page_idle_flag-definitions.patch
proc-convert-gather_stats-to-use-a-folio.patch
proc-convert-smaps_page_accumulate-to-use-a-folio.patch
proc-pass-a-folio-to-smaps_page_accumulate.patch
proc-convert-smaps_pmd_entry-to-use-a-folio.patch
mm-remove-struct-page-from-get_shadow_from_swap_cache.patch
hugetlb-convert-alloc_buddy_hugetlb_folio-to-use-a-folio.patch
mm-convert-pagecache_isize_extended-to-use-a-folio.patch
mm-free-non-hugetlb-large-folios-in-a-batch.patch
mm-combine-free_the_page-and-free_unref_page.patch
mm-inline-destroy_large_folio-into-__folio_put_large.patch
mm-combine-__folio_put_small-__folio_put_large-and-__folio_put.patch
mm-convert-free_zone_device_page-to-free_zone_device_folio.patch
doc-improve-the-description-of-__folio_mark_dirty.patch
buffer-add-kernel-doc-for-block_dirty_folio.patch
buffer-add-kernel-doc-for-try_to_free_buffers.patch
buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch
buffer-add-kernel-doc-for-brelse-and-__brelse.patch
buffer-add-kernel-doc-for-bforget-and-__bforget.patch
buffer-improve-bdev_getblk-documentation.patch
doc-split-bufferrst-out-of-api-summaryrst.patch

