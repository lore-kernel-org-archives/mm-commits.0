Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7F69C3E8C5
	for <mm-commits@archiver.kernel.org>; Sat, 28 Nov 2020 02:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B258206DF
	for <mm-commits@archiver.kernel.org>; Sat, 28 Nov 2020 02:12:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PJixLnMm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730739AbgK1CMT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 Nov 2020 21:12:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:38556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731896AbgK1CIp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 27 Nov 2020 21:08:45 -0500
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A638A22245;
        Sat, 28 Nov 2020 02:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1606529325;
        bh=wHleIMXsNVx453TMJ0do5bDMTUW3sBBSlTvbO5/kM0c=;
        h=Date:From:To:Subject:From;
        b=PJixLnMmEpXBjdFClP70saENiDv2jnErkS2LYGMSxa+U1NfCff6BASpVMjEqGhFo5
         60fIscamgoeydWqlWtEAgBr5KtJSsr54FUh0c5dP8j1cCqtDRmKrAhilcPk4yCsvNs
         X6Praggl7M6Thhf1OZiHS16h2mqkPOdlhXsVoCFU=
Date:   Fri, 27 Nov 2020 18:08:44 -0800
From:   akpm@linux-foundation.org
To:     feng.tang@intel.com, hannes@cmpxchg.org,
        mm-commits@vger.kernel.org, rong.a.chen@intel.com,
        william.kucharski@oracle.com, willy@infradead.org,
        zhengjun.xing@linux.intel.com
Subject:  [merged]
 mm-fix-madvise-willneed-performance-problem.patch removed from -mm tree
Message-ID: <20201128020844.T6L13TwnD%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix madvise WILLNEED performance problem
has been removed from the -mm tree.  Its filename was
     mm-fix-madvise-willneed-performance-problem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: fix madvise WILLNEED performance problem

The calculation of the end page index was incorrect, leading to a
regression of 70% when running stress-ng.  With this fix, we instead
see a performance improvement of 3%.

Link: https://lkml.kernel.org/r/20201109134851.29692-1-willy@infradead.org
Fixes: e6e88712e43b ("mm: optimise madvise WILLNEED")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: kernel test robot <rong.a.chen@intel.com>
Tested-by: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: "Chen, Rong A" <rong.a.chen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/madvise.c~mm-fix-madvise-willneed-performance-problem
+++ a/mm/madvise.c
@@ -226,7 +226,7 @@ static void force_shm_swapin_readahead(s
 		struct address_space *mapping)
 {
 	XA_STATE(xas, &mapping->i_pages, linear_page_index(vma, start));
-	pgoff_t end_index = end / PAGE_SIZE;
+	pgoff_t end_index = linear_page_index(vma, end + PAGE_SIZE - 1);
 	struct page *page;
 
 	rcu_read_lock();
_

Patches currently in -mm which might be from willy@infradead.org are

sparc-fix-handling-of-page-table-constructor-failure.patch
mm-move-free_unref_page-to-mm-internalh.patch
mm-page-flags-fix-comment.patch
mm-page_alloc-add-__free_pages-documentation.patch
mm-support-thps-in-zero_user_segments.patch
mm-support-thps-in-zero_user_segments-fix.patch
mm-make-pagecache-tagged-lookups-return-only-head-pages.patch
mm-shmem-use-pagevec_lookup-in-shmem_unlock_mapping.patch
mm-swap-optimise-get_shadow_from_swap_cache.patch
mm-add-fgp_entry.patch
mm-filemap-rename-find_get_entry-to-mapping_get_entry.patch
mm-filemap-add-helper-for-finding-pages.patch
mm-filemap-add-helper-for-finding-pages-fix.patch
mm-filemap-add-mapping_seek_hole_data.patch
mm-filemap-add-mapping_seek_hole_data-fix.patch
iomap-use-mapping_seek_hole_data.patch
mm-add-and-use-find_lock_entries.patch
mm-add-and-use-find_lock_entries-fix.patch
mm-add-an-end-parameter-to-find_get_entries.patch
mm-add-an-end-parameter-to-pagevec_lookup_entries.patch
mm-remove-nr_entries-parameter-from-pagevec_lookup_entries.patch
mm-pass-pvec-directly-to-find_get_entries.patch
mm-remove-pagevec_lookup_entries.patch
mm-truncateshmem-handle-truncates-that-split-thps.patch
mm-truncateshmem-handle-truncates-that-split-thps-fix.patch
mm-filemap-return-only-head-pages-from-find_get_entries.patch

