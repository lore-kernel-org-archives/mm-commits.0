Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7136FC43457
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C03E2224D
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 20:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709121;
	bh=gnxOXfgItw/aDxsShjcFZG2HyzZq7Vm0XtRRzHbdHMg=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=pX6vXlQDWjoY9T7ePsC7YyYd9IO4lb9qvkg/+CYXDJkVZUr6fdWNeG4STTBkM4Uki
	 eFEt7VabJjJrmcCDr6FVAD35pbiT2BgXfAsz2PbFy5nUY9Hge4HAgeiIgJD00W6nZ/
	 eF1TEcSyRWkeLlVyhLaoBAkdE8noSpVXeC5dunes=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388341AbgJNU6k (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 16:58:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388163AbgJNU6k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 16:58:40 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9EA322076D;
        Wed, 14 Oct 2020 20:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709119;
        bh=gnxOXfgItw/aDxsShjcFZG2HyzZq7Vm0XtRRzHbdHMg=;
        h=Date:From:To:Subject:From;
        b=D/XAZouUv6xzRBpfwjdzX/j4Nv8tBKnM2wl3i8qxL2CfNI0dUK6vNr2P9uMIPDNoI
         Wo60Rq3bt/Xnv/UkrD3ttVsVakvsBRyody1prrZD1l16J7Ph54+UFMN6vu/1TO4DJN
         Lqd+eD46NaAnPH3L/SuheyshKMCsFIXt/4i+EjFY=
Date:   Wed, 14 Oct 2020 13:58:38 -0700
From:   akpm@linux-foundation.org
To:     jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, vbabka@suse.cz, willy@infradead.org
Subject:  [merged] mm-debug-do-not-dereference-i_ino-blindly.patch
 removed from -mm tree
Message-ID: <20201014205838.zNpLKbbdj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/debug.c: do not dereference i_ino blindly
has been removed from the -mm tree.  Its filename was
     mm-debug-do-not-dereference-i_ino-blindly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/debug.c: do not dereference i_ino blindly

__dump_page() checks i_dentry is fetchable and i_ino is earlier in the
struct than i_ino, so it ought to work fine, but it's possible that struct
randomisation has reordered i_ino after i_dentry and the pointer is just
wild enough that i_dentry is fetchable and i_ino isn't.

Also print the inode number if the dentry is invalid.

Link: https://lkml.kernel.org/r/20200819185710.28180-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/debug.c~mm-debug-do-not-dereference-i_ino-blindly
+++ a/mm/debug.c
@@ -120,6 +120,7 @@ void __dump_page(struct page *page, cons
 		struct hlist_node *dentry_first;
 		struct dentry *dentry_ptr;
 		struct dentry dentry;
+		unsigned long ino;
 
 		/*
 		 * mapping can be invalid pointer and we don't want to crash
@@ -136,21 +137,22 @@ void __dump_page(struct page *page, cons
 			goto out_mapping;
 		}
 
-		if (get_kernel_nofault(dentry_first, &host->i_dentry.first)) {
+		if (get_kernel_nofault(dentry_first, &host->i_dentry.first) ||
+		    get_kernel_nofault(ino, &host->i_ino)) {
 			pr_warn("aops:%ps with invalid host inode %px\n",
 					a_ops, host);
 			goto out_mapping;
 		}
 
 		if (!dentry_first) {
-			pr_warn("aops:%ps ino:%lx\n", a_ops, host->i_ino);
+			pr_warn("aops:%ps ino:%lx\n", a_ops, ino);
 			goto out_mapping;
 		}
 
 		dentry_ptr = container_of(dentry_first, struct dentry, d_u.d_alias);
 		if (get_kernel_nofault(dentry, dentry_ptr)) {
-			pr_warn("aops:%ps with invalid dentry %px\n", a_ops,
-					dentry_ptr);
+			pr_warn("aops:%ps ino:%lx with invalid dentry %px\n",
+					a_ops, ino, dentry_ptr);
 		} else {
 			/*
 			 * if dentry is corrupted, the %pd handler may still
@@ -158,7 +160,7 @@ void __dump_page(struct page *page, cons
 			 * corrupted struct page
 			 */
 			pr_warn("aops:%ps ino:%lx dentry name:\"%pd\"\n",
-					a_ops, host->i_ino, &dentry);
+					a_ops, ino, &dentry);
 		}
 	}
 out_mapping:
_

Patches currently in -mm which might be from willy@infradead.org are

xarray-add-xa_get_order.patch
xarray-add-xas_split.patch
xarray-add-xas_split-fix-2.patch
xarray-add-xas_split-fix-3patch.patch
mm-filemap-fix-storing-to-a-thp-shadow-entry.patch
mm-filemap-fix-page-cache-removal-for-arbitrary-sized-thps.patch
mm-memory-remove-page-fault-assumption-of-compound-page-size.patch
mm-memory-remove-page-fault-assumption-of-compound-page-size-fix.patch
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
mm-rename-page_order-to-buddy_order.patch
ramfs-fix-nommu-mmap-with-gaps-in-the-page-cache.patch
harden-autofs-ioctl-table.patch
mm-update-the-documentation-for-vfree.patch

