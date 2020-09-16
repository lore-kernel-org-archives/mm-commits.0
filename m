Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F38BCC43461
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 23:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 982502220B
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 23:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600300494;
	bh=63CQmrPNFQJR/BL6UU7W3Wxmd/a+V/1bhWeCj7zwnPg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=uJ9komovQ8sauL1CTaq2f4nO1bL07u5tnM0KNEutpRp6ajEycXab4+/V/cUFPuXFX
	 U1UqkgCCGOz1BKktNmso5hTCIFJ52v24Sq87LgH+uJ50Dbtcj3+EdawbSGo1K7UpZC
	 IVRS9hsrtEodU3Nhp4LAtVhTTJRyc0GLycS2PG9w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgIPXyy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Sep 2020 19:54:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:33032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgIPXyx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Sep 2020 19:54:53 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE9832072E;
        Wed, 16 Sep 2020 23:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600300492;
        bh=63CQmrPNFQJR/BL6UU7W3Wxmd/a+V/1bhWeCj7zwnPg=;
        h=Date:From:To:Subject:From;
        b=Eb4Kl9zSUDSFHm7n1CK7smxELSSWyK1jGS1eF572xXM9ucbRBHTrx5M3wH/iEXmFJ
         xwE47UJouD30eoUku1mwWF0UcfhHm/duWXWda/CCxeGccW8IbX2ofxiwCZV6jadF3d
         d7DyCw8y7zZU/lS0QO+4iyL4X9Zm9YJb6QVyKkiY=
Date:   Wed, 16 Sep 2020 16:54:51 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        songliubraving@fb.com, riel@surriel.com,
        kirill.shutemov@linux.intel.com, hughd@google.com,
        hch@infradead.org, hannes@cmpxchg.org, dchinner@redhat.com,
        willy@infradead.org
Subject:  +
 fs-do-not-update-nr_thps-for-mappings-which-support-thps.patch added to -mm
 tree
Message-ID: <20200916235451.qMr7q%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: do not update nr_thps for mappings which support THPs
has been added to the -mm tree.  Its filename is
     fs-do-not-update-nr_thps-for-mappings-which-support-thps.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-do-not-update-nr_thps-for-mappings-which-support-thps.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-do-not-update-nr_thps-for-mappings-which-support-thps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: fs: do not update nr_thps for mappings which support THPs

The nr_thps counter is to support THPs in the page cache when the
filesystem doesn't understand THPs.  Eventually it will be removed, but we
should still support filesystems which do not understand THPs yet.  Move
the nr_thp manipulation functions to filemap.h since they're page-cache
specific.

Link: https://lkml.kernel.org/r/20200916032717.22917-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h      |   27 ---------------------------
 include/linux/pagemap.h |   29 +++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 27 deletions(-)

--- a/include/linux/fs.h~fs-do-not-update-nr_thps-for-mappings-which-support-thps
+++ a/include/linux/fs.h
@@ -2703,33 +2703,6 @@ static inline errseq_t file_sample_sb_er
 	return errseq_sample(&file->f_path.dentry->d_sb->s_wb_err);
 }
 
-static inline int filemap_nr_thps(struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	return atomic_read(&mapping->nr_thps);
-#else
-	return 0;
-#endif
-}
-
-static inline void filemap_nr_thps_inc(struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	atomic_inc(&mapping->nr_thps);
-#else
-	WARN_ON_ONCE(1);
-#endif
-}
-
-static inline void filemap_nr_thps_dec(struct address_space *mapping)
-{
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	atomic_dec(&mapping->nr_thps);
-#else
-	WARN_ON_ONCE(1);
-#endif
-}
-
 extern int vfs_fsync_range(struct file *file, loff_t start, loff_t end,
 			   int datasync);
 extern int vfs_fsync(struct file *file, int datasync);
--- a/include/linux/pagemap.h~fs-do-not-update-nr_thps-for-mappings-which-support-thps
+++ a/include/linux/pagemap.h
@@ -125,6 +125,35 @@ static inline bool mapping_thp_support(s
 	return test_bit(AS_THP_SUPPORT, &mapping->flags);
 }
 
+static inline int filemap_nr_thps(struct address_space *mapping)
+{
+#ifdef CONFIG_READ_ONLY_THP_FOR_FS
+	return atomic_read(&mapping->nr_thps);
+#else
+	return 0;
+#endif
+}
+
+static inline void filemap_nr_thps_inc(struct address_space *mapping)
+{
+#ifdef CONFIG_READ_ONLY_THP_FOR_FS
+	if (!mapping_thp_support(mapping))
+		atomic_inc(&mapping->nr_thps);
+#else
+	WARN_ON_ONCE(1);
+#endif
+}
+
+static inline void filemap_nr_thps_dec(struct address_space *mapping)
+{
+#ifdef CONFIG_READ_ONLY_THP_FOR_FS
+	if (!mapping_thp_support(mapping))
+		atomic_dec(&mapping->nr_thps);
+#else
+	WARN_ON_ONCE(1);
+#endif
+}
+
 void release_pages(struct page **pages, int nr);
 
 /*
_

Patches currently in -mm which might be from willy@infradead.org are

mm-debug-do-not-dereference-i_ino-blindly.patch
mm-factor-find_get_incore_page-out-of-mincore_page.patch
mm-use-find_get_incore_page-in-memcontrol.patch
mm-optimise-madvise-willneed.patch
mm-optimise-madvise-willneed-fix.patch
proc-optimise-smaps-for-shmem-entries.patch
i915-use-find_lock_page-instead-of-find_lock_entry.patch
mm-convert-find_get_entry-to-return-the-head-page.patch
mm-convert-find_get_entry-to-return-the-head-page-fix.patch
mm-shmem-return-head-page-from-find_lock_entry.patch
mm-shmem-return-head-page-from-find_lock_entry-fix.patch
mm-add-find_lock_head.patch
mm-filemap-fix-filemap_map_pages-for-thp.patch
mm-account-pmd-tables-like-pte-tables.patch
mm-move-pagedoublemap-bit.patch
mm-simplify-pagedoublemap-with-pf_second-policy.patch
xarray-add-xa_get_order.patch
xarray-add-xas_split.patch
xarray-add-xas_split-fix-2.patch
mm-filemap-fix-storing-to-a-thp-shadow-entry.patch
mm-filemap-fix-page-cache-removal-for-arbitrary-sized-thps.patch
mm-memory-remove-page-fault-assumption-of-compound-page-size.patch
mm-page_owner-change-split_page_owner-to-take-a-count.patch
mm-huge_memory-fix-page_trans_huge_mapcount-assumption-of-thp-size.patch
mm-huge_memory-fix-can_split_huge_page-assumption-of-thp-size.patch
mm-rmap-fix-assumptions-of-thp-size.patch
mm-truncate-fix-truncation-for-pages-of-arbitrary-size.patch
mm-page-writeback-support-tail-pages-in-wait_for_stable_page.patch
mm-vmscan-allow-arbitrary-sized-pages-to-be-paged-out.patch
fs-add-a-filesystem-flag-for-thps.patch
fs-do-not-update-nr_thps-for-mappings-which-support-thps.patch
mm-readahead-add-define_readahead.patch
mm-readahead-make-page_cache_ra_unbounded-take-a-readahead_control.patch
mm-readahead-make-do_page_cache_ra-take-a-readahead_control.patch
mm-readahead-add-page_cache_sync_ra-and-page_cache_async_ra.patch
harden-autofs-ioctl-table.patch

