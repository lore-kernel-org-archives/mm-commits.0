Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48AB7C636D3
	for <mm-commits@archiver.kernel.org>; Fri, 10 Feb 2023 00:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbjBJA4g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 9 Feb 2023 19:56:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbjBJAzM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2023 19:55:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288A57430C
        for <mm-commits@vger.kernel.org>; Thu,  9 Feb 2023 16:54:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B80E961BF3
        for <mm-commits@vger.kernel.org>; Fri, 10 Feb 2023 00:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205EDC433D2;
        Fri, 10 Feb 2023 00:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675990453;
        bh=0HAApHhmsDygzQIBiCRaUVjmTmBC1YPocu/4muT6trg=;
        h=Date:To:From:Subject:From;
        b=MYE9X32SxfDyQfRMwtEqkbXl86exwaOyzYUoEXDWW16xoDlJ1cmVcqDIb+7x4k6OD
         tGBMv1Ad+lghNRShNB7aqkA62DF/WVynlDYY6APrn7hT9WrEg3+cRkIt7PEQuiDB8m
         AL69FtUL+XGaBdqnyDBWWgNkjRlCO4Dq55HAXjJU=
Date:   Thu, 09 Feb 2023 16:54:12 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, surenb@google.com,
        shakeelb@google.com, rientjes@google.com,
        quic_pkondeti@quicinc.com, quic_charante@quicinc.com,
        mhocko@suse.com, markhemm@googlemail.com, hughd@google.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-add-shmem_read_folio-and-shmem_read_folio_gfp.patch removed from -mm tree
Message-Id: <20230210005413.205EDC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: add shmem_read_folio() and shmem_read_folio_gfp()
has been removed from the -mm tree.  Its filename was
     shmem-add-shmem_read_folio-and-shmem_read_folio_gfp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: shmem: add shmem_read_folio() and shmem_read_folio_gfp()
Date: Mon, 6 Feb 2023 16:25:20 +0000

These are the folio replacements for shmem_read_mapping_page() and
shmem_read_mapping_page_gfp().

[akpm@linux-foundation.org: fix shmem_read_mapping_page_gfp(), per Matthew]
  Link: https://lkml.kernel.org/r/Y+QdJTuzxeBYejw2@casper.infradead.org
Link: https://lkml.kernel.org/r/20230206162520.4029022-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mark Hemment <markhemm@googlemail.com>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/shmem_fs.h |    8 ++++++++
 mm/shmem.c               |   36 ++++++++++++++++++++++++------------
 2 files changed, 32 insertions(+), 12 deletions(-)

--- a/include/linux/shmem_fs.h~shmem-add-shmem_read_folio-and-shmem_read_folio_gfp
+++ a/include/linux/shmem_fs.h
@@ -109,6 +109,14 @@ enum sgp_type {
 
 int shmem_get_folio(struct inode *inode, pgoff_t index, struct folio **foliop,
 		enum sgp_type sgp);
+struct folio *shmem_read_folio_gfp(struct address_space *mapping,
+		pgoff_t index, gfp_t gfp);
+
+static inline struct folio *shmem_read_folio(struct address_space *mapping,
+		pgoff_t index)
+{
+	return shmem_read_folio_gfp(mapping, index, mapping_gfp_mask(mapping));
+}
 
 static inline struct page *shmem_read_mapping_page(
 				struct address_space *mapping, pgoff_t index)
--- a/mm/shmem.c~shmem-add-shmem_read_folio-and-shmem_read_folio_gfp
+++ a/mm/shmem.c
@@ -4311,9 +4311,9 @@ int shmem_zero_setup(struct vm_area_stru
 }
 
 /**
- * shmem_read_mapping_page_gfp - read into page cache, using specified page allocation flags.
- * @mapping:	the page's address_space
- * @index:	the page index
+ * shmem_read_folio_gfp - read into page cache, using specified page allocation flags.
+ * @mapping:	the folio's address_space
+ * @index:	the folio index
  * @gfp:	the page allocator flags to use if allocating
  *
  * This behaves as a tmpfs "read_cache_page_gfp(mapping, index, gfp)",
@@ -4325,13 +4325,12 @@ int shmem_zero_setup(struct vm_area_stru
  * i915_gem_object_get_pages_gtt() mixes __GFP_NORETRY | __GFP_NOWARN in
  * with the mapping_gfp_mask(), to avoid OOMing the machine unnecessarily.
  */
-struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
-					 pgoff_t index, gfp_t gfp)
+struct folio *shmem_read_folio_gfp(struct address_space *mapping,
+		pgoff_t index, gfp_t gfp)
 {
 #ifdef CONFIG_SHMEM
 	struct inode *inode = mapping->host;
 	struct folio *folio;
-	struct page *page;
 	int error;
 
 	BUG_ON(!shmem_mapping(mapping));
@@ -4341,6 +4340,25 @@ struct page *shmem_read_mapping_page_gfp
 		return ERR_PTR(error);
 
 	folio_unlock(folio);
+	return folio;
+#else
+	/*
+	 * The tiny !SHMEM case uses ramfs without swap
+	 */
+	return mapping_read_folio_gfp(mapping, index, gfp);
+#endif
+}
+EXPORT_SYMBOL_GPL(shmem_read_folio_gfp);
+
+struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
+					 pgoff_t index, gfp_t gfp)
+{
+	struct folio *folio = shmem_read_folio_gfp(mapping, index, gfp);
+	struct page *page;
+
+	if (IS_ERR(folio))
+		return &folio->page;
+
 	page = folio_file_page(folio, index);
 	if (PageHWPoison(page)) {
 		folio_put(folio);
@@ -4348,11 +4366,5 @@ struct page *shmem_read_mapping_page_gfp
 	}
 
 	return page;
-#else
-	/*
-	 * The tiny !SHMEM case uses ramfs without swap
-	 */
-	return read_cache_page_gfp(mapping, index, gfp);
-#endif
 }
 EXPORT_SYMBOL_GPL(shmem_read_mapping_page_gfp);
_

Patches currently in -mm which might be from willy@infradead.org are


