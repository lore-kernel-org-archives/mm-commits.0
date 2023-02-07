Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A850CC61DA4
	for <mm-commits@archiver.kernel.org>; Tue,  7 Feb 2023 01:04:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjBGBEQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Feb 2023 20:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjBGBEM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2023 20:04:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF2432E5D
        for <mm-commits@vger.kernel.org>; Mon,  6 Feb 2023 17:04:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 929EEB81690
        for <mm-commits@vger.kernel.org>; Tue,  7 Feb 2023 01:04:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34435C433EF;
        Tue,  7 Feb 2023 01:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675731848;
        bh=SeCtzKXH3utykFIOxQLOg53JWS7iOu9r0tMOv7satWc=;
        h=Date:To:From:Subject:From;
        b=GbSnaT9USKhN8hm0eJ41NvJyFrv1MByPf8KI+oEZvRyl1ZmvAFz4/JwLiYEwN6xAr
         9YgfuVgTdxG7+sQVOx7mjmNMUyAmW/4zMYJp+CG7DacAanJy67CrktvNGg3ngqPYgJ
         GmPapPHPZ8R3tRRdz1VfGoAg9kRK85okfwzZTDKM=
Date:   Mon, 06 Feb 2023 17:04:07 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, surenb@google.com,
        shakeelb@google.com, rientjes@google.com,
        quic_pkondeti@quicinc.com, quic_charante@quicinc.com,
        mhocko@suse.com, markhemm@googlemail.com, hughd@google.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-add-shmem_read_folio-and-shmem_read_folio_gfp.patch added to mm-unstable branch
Message-Id: <20230207010408.34435C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: add shmem_read_folio() and shmem_read_folio_gfp()
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-add-shmem_read_folio-and-shmem_read_folio_gfp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-add-shmem_read_folio-and-shmem_read_folio_gfp.patch

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
Subject: shmem: add shmem_read_folio() and shmem_read_folio_gfp()
Date: Mon, 6 Feb 2023 16:25:20 +0000

These are the folio replacements for shmem_read_mapping_page() and
shmem_read_mapping_page_gfp().

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
@@ -4341,18 +4340,27 @@ struct page *shmem_read_mapping_page_gfp
 		return ERR_PTR(error);
 
 	folio_unlock(folio);
-	page = folio_file_page(folio, index);
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
+	struct page *page = folio_file_page(folio, index);
+
 	if (PageHWPoison(page)) {
 		folio_put(folio);
 		return ERR_PTR(-EIO);
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

mm-add-memcpy_from_file_folio.patch
filemap-add-mapping_read_folio_gfp.patch
shmem-add-shmem_read_folio-and-shmem_read_folio_gfp.patch
shmem-fix-w=1-build-warnings-with-config_shmem=n.patch

