Return-Path: <SRS0=oQto=CZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FF42C43461
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 23:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC1312072E
	for <mm-commits@archiver.kernel.org>; Wed, 16 Sep 2020 23:54:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600300490;
	bh=IlQhzdW3uN/hfLbOnmBrF7fdVz0yqRo3xyRS013Ecng=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=YNDMxfEAbYTL7ehfyUON+SuJaMNutDJOBuHOhXscjqt8AYVEmkQyIUOmuNaBqSidz
	 4FzaQezWMuzhb6qOhtgNdaMjnTnZ18h02EbrDWV+ALUAa09Wkccwb4QXT9rZcd+1DT
	 /0Z0rgL9C4wejdWyRQ99MpQeGNj6zfrj0XmDFBYM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgIPXyu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 16 Sep 2020 19:54:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:32966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726409AbgIPXyt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 16 Sep 2020 19:54:49 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 595C32065C;
        Wed, 16 Sep 2020 23:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600300488;
        bh=IlQhzdW3uN/hfLbOnmBrF7fdVz0yqRo3xyRS013Ecng=;
        h=Date:From:To:Subject:From;
        b=nGgRI6tLOMHxUCAwmOKj0uBgViipd+kBMHQDbJ/Z0ecAkwpxSaLIRyRosiEI9HRVt
         ceYERAgTH2CYuSD6jPy243s40pWrF6Dj89OzUXK1UB9PVQjC7bAVmqdl7GKEXTViEP
         P6/QzMqXCXpDZXd+s8yg/ejwe21hklKw033HQ544=
Date:   Wed, 16 Sep 2020 16:54:47 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, viro@zeniv.linux.org.uk,
        songliubraving@fb.com, riel@surriel.com,
        kirill.shutemov@linux.intel.com, hughd@google.com,
        hch@infradead.org, hannes@cmpxchg.org, dchinner@redhat.com,
        willy@infradead.org
Subject:  + fs-add-a-filesystem-flag-for-thps.patch added to -mm tree
Message-ID: <20200916235447.GiTD_%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs: add a filesystem flag for THPs
has been added to the -mm tree.  Its filename is
     fs-add-a-filesystem-flag-for-thps.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/fs-add-a-filesystem-flag-for-thps.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/fs-add-a-filesystem-flag-for-thps.patch

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
Subject: fs: add a filesystem flag for THPs

The page cache needs to know whether the filesystem supports THPs so that
it doesn't send THPs to filesystems which can't handle them.  Dave Chinner
points out that getting from the page mapping to the filesystem type is
too many steps (mapping->host->i_sb->s_type->fs_flags) so cache that
information in the address space flags.

Link: https://lkml.kernel.org/r/20200916032717.22917-1-willy@infradead.org
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

 fs/inode.c              |    2 ++
 include/linux/fs.h      |    1 +
 include/linux/pagemap.h |    6 ++++++
 mm/shmem.c              |    2 +-
 4 files changed, 10 insertions(+), 1 deletion(-)

--- a/fs/inode.c~fs-add-a-filesystem-flag-for-thps
+++ a/fs/inode.c
@@ -181,6 +181,8 @@ int inode_init_always(struct super_block
 	mapping->a_ops = &empty_aops;
 	mapping->host = inode;
 	mapping->flags = 0;
+	if (sb->s_type->fs_flags & FS_THP_SUPPORT)
+		__set_bit(AS_THP_SUPPORT, &mapping->flags);
 	mapping->wb_err = 0;
 	atomic_set(&mapping->i_mmap_writable, 0);
 #ifdef CONFIG_READ_ONLY_THP_FOR_FS
--- a/include/linux/fs.h~fs-add-a-filesystem-flag-for-thps
+++ a/include/linux/fs.h
@@ -2219,6 +2219,7 @@ struct file_system_type {
 #define FS_HAS_SUBTYPE		4
 #define FS_USERNS_MOUNT		8	/* Can be mounted by userns root */
 #define FS_DISALLOW_NOTIFY_PERM	16	/* Disable fanotify permission events */
+#define FS_THP_SUPPORT		8192	/* Remove once all fs converted */
 #define FS_RENAME_DOES_D_MOVE	32768	/* FS will handle d_move() during rename() internally. */
 	int (*init_fs_context)(struct fs_context *);
 	const struct fs_parameter_spec *parameters;
--- a/include/linux/pagemap.h~fs-add-a-filesystem-flag-for-thps
+++ a/include/linux/pagemap.h
@@ -29,6 +29,7 @@ enum mapping_flags {
 	AS_EXITING	= 4, 	/* final truncate in progress */
 	/* writeback related tags are not used */
 	AS_NO_WRITEBACK_TAGS = 5,
+	AS_THP_SUPPORT = 6,	/* THPs supported */
 };
 
 /**
@@ -119,6 +120,11 @@ static inline void mapping_set_gfp_mask(
 	m->gfp_mask = mask;
 }
 
+static inline bool mapping_thp_support(struct address_space *mapping)
+{
+	return test_bit(AS_THP_SUPPORT, &mapping->flags);
+}
+
 void release_pages(struct page **pages, int nr);
 
 /*
--- a/mm/shmem.c~fs-add-a-filesystem-flag-for-thps
+++ a/mm/shmem.c
@@ -3983,7 +3983,7 @@ static struct file_system_type shmem_fs_
 	.parameters	= shmem_fs_parameters,
 #endif
 	.kill_sb	= kill_litter_super,
-	.fs_flags	= FS_USERNS_MOUNT,
+	.fs_flags	= FS_USERNS_MOUNT | FS_THP_SUPPORT,
 };
 
 int __init shmem_init(void)
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

