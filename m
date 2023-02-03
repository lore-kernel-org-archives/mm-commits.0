Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 842CBC636D7
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbjBCGly (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:41:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbjBCGkl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:40:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF4A8F526
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B969861D99
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CAFFC433D2;
        Fri,  3 Feb 2023 06:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406256;
        bh=ktsjr+XKmkN1jiON9kx/r6AjuilVSOfDvOn2DBt+Z9k=;
        h=Date:To:From:Subject:From;
        b=hKxD56TqaSXReK/Vj2QcJKAQTPnmkoRkWuhVcvO/qQfZhm/BP6NXt1XULH75vOFr/
         dLzcRVg2Ad3YQJKn22yJVS9/wFuLWg+Gq53U4ah1N/mF8xIOJ297JbYm21lFAB40bk
         PdND+p6lE06KUnaFjz3SfGunYI0urNFBX7cbAC5Q=
Date:   Thu, 02 Feb 2023 22:37:35 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fs-convert-inode_attach_wb-to-take-a-folio.patch removed from -mm tree
Message-Id: <20230203063736.1CAFFC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/fs: convert inode_attach_wb() to take a folio
has been removed from the -mm tree.  Its filename was
     mm-fs-convert-inode_attach_wb-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/fs: convert inode_attach_wb() to take a folio
Date: Mon, 16 Jan 2023 19:25:06 +0000

Patch series "Writeback folio conversions".

Remove more calls to compound_head() by passing folios around instead of
pages.


This patch (of 2):

The only caller of inode_attach_wb() which doesn't pass NULL already has a
folio, so convert the whole call-chain to take folios.

Link: https://lkml.kernel.org/r/20230116192507.2146150-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230116192507.2146150-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/fs-writeback.c~mm-fs-convert-inode_attach_wb-to-take-a-folio
+++ a/fs/fs-writeback.c
@@ -237,7 +237,7 @@ void wb_wait_for_completion(struct wb_co
 static atomic_t isw_nr_in_flight = ATOMIC_INIT(0);
 static struct workqueue_struct *isw_wq;
 
-void __inode_attach_wb(struct inode *inode, struct page *page)
+void __inode_attach_wb(struct inode *inode, struct folio *folio)
 {
 	struct backing_dev_info *bdi = inode_to_bdi(inode);
 	struct bdi_writeback *wb = NULL;
@@ -245,8 +245,8 @@ void __inode_attach_wb(struct inode *ino
 	if (inode_cgwb_enabled(inode)) {
 		struct cgroup_subsys_state *memcg_css;
 
-		if (page) {
-			memcg_css = mem_cgroup_css_from_page(page);
+		if (folio) {
+			memcg_css = mem_cgroup_css_from_page(&folio->page);
 			wb = wb_get_create(bdi, memcg_css, GFP_ATOMIC);
 		} else {
 			/* must pin memcg_css, see wb_get_create() */
--- a/include/linux/writeback.h~mm-fs-convert-inode_attach_wb-to-take-a-folio
+++ a/include/linux/writeback.h
@@ -207,7 +207,7 @@ static inline void wait_on_inode(struct
 #include <linux/cgroup.h>
 #include <linux/bio.h>
 
-void __inode_attach_wb(struct inode *inode, struct page *page);
+void __inode_attach_wb(struct inode *inode, struct folio *folio);
 void wbc_attach_and_unlock_inode(struct writeback_control *wbc,
 				 struct inode *inode)
 	__releases(&inode->i_lock);
@@ -222,16 +222,16 @@ bool cleanup_offline_cgwb(struct bdi_wri
 /**
  * inode_attach_wb - associate an inode with its wb
  * @inode: inode of interest
- * @page: page being dirtied (may be NULL)
+ * @folio: folio being dirtied (may be NULL)
  *
  * If @inode doesn't have its wb, associate it with the wb matching the
- * memcg of @page or, if @page is NULL, %current.  May be called w/ or w/o
+ * memcg of @folio or, if @folio is NULL, %current.  May be called w/ or w/o
  * @inode->i_lock.
  */
-static inline void inode_attach_wb(struct inode *inode, struct page *page)
+static inline void inode_attach_wb(struct inode *inode, struct folio *folio)
 {
 	if (!inode->i_wb)
-		__inode_attach_wb(inode, page);
+		__inode_attach_wb(inode, folio);
 }
 
 /**
@@ -290,7 +290,7 @@ static inline void wbc_init_bio(struct w
 
 #else	/* CONFIG_CGROUP_WRITEBACK */
 
-static inline void inode_attach_wb(struct inode *inode, struct page *page)
+static inline void inode_attach_wb(struct inode *inode, struct folio *folio)
 {
 }
 
--- a/mm/page-writeback.c~mm-fs-convert-inode_attach_wb-to-take-a-folio
+++ a/mm/page-writeback.c
@@ -2652,7 +2652,7 @@ static void folio_account_dirtied(struct
 		struct bdi_writeback *wb;
 		long nr = folio_nr_pages(folio);
 
-		inode_attach_wb(inode, &folio->page);
+		inode_attach_wb(inode, folio);
 		wb = inode_to_wb(inode);
 
 		__lruvec_stat_mod_folio(folio, NR_FILE_DIRTY, nr);
_

Patches currently in -mm which might be from willy@infradead.org are


