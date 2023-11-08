Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11417C4167B
	for <mm-commits@archiver.kernel.org>; Wed,  8 Nov 2023 21:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjKHVaI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Nov 2023 16:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbjKHVaE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Nov 2023 16:30:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B23362586
        for <mm-commits@vger.kernel.org>; Wed,  8 Nov 2023 13:30:02 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F434C433C7;
        Wed,  8 Nov 2023 21:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1699479002;
        bh=ndN8wmCwFt5PU5k42UKWoE00f6uwyEcyp9yvQqZ8Qx0=;
        h=Date:To:From:Subject:From;
        b=CNeyd/VcNbofe05eQODys97Mf+sA4hkW7HPVkpM0A4aePiXYtCMKLpwmN5TPolsWH
         sMdGHXmaVa5GKsns7I9kmoir+Kn3Xf0xc5g1R8OAgMfSvAy/dTlx3fKYid0pXrDULU
         JRh9jOJmvXcZK9VEXBJOWPeAog2mWUixAY3XPhGw=
Date:   Wed, 08 Nov 2023 13:30:01 -0800
To:     mm-commits@vger.kernel.org, sfrench@samba.org, dhowells@redhat.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-return-void-from-folio_start_writeback-and-related-functions.patch added to mm-unstable branch
Message-Id: <20231108213002.4F434C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: return void from folio_start_writeback() and related functions
has been added to the -mm mm-unstable branch.  Its filename is
     mm-return-void-from-folio_start_writeback-and-related-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-return-void-from-folio_start_writeback-and-related-functions.patch

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
Subject: mm: return void from folio_start_writeback() and related functions
Date: Wed, 8 Nov 2023 20:46:05 +0000

Nobody now checks the return value from any of these functions, so
add an assertion at the beginning of the function and return void.

Link: https://lkml.kernel.org/r/20231108204605.745109-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page-flags.h |    4 +-
 mm/folio-compat.c          |    4 +-
 mm/page-writeback.c        |   60 ++++++++++++++++-------------------
 3 files changed, 32 insertions(+), 36 deletions(-)

--- a/include/linux/page-flags.h~mm-return-void-from-folio_start_writeback-and-related-functions
+++ a/include/linux/page-flags.h
@@ -772,8 +772,8 @@ static __always_inline void SetPageUptod
 
 CLEARPAGEFLAG(Uptodate, uptodate, PF_NO_TAIL)
 
-bool __folio_start_writeback(struct folio *folio, bool keep_write);
-bool set_page_writeback(struct page *page);
+void __folio_start_writeback(struct folio *folio, bool keep_write);
+void set_page_writeback(struct page *page);
 
 #define folio_start_writeback(folio)			\
 	__folio_start_writeback(folio, false)
--- a/mm/folio-compat.c~mm-return-void-from-folio_start_writeback-and-related-functions
+++ a/mm/folio-compat.c
@@ -46,9 +46,9 @@ void mark_page_accessed(struct page *pag
 }
 EXPORT_SYMBOL(mark_page_accessed);
 
-bool set_page_writeback(struct page *page)
+void set_page_writeback(struct page *page)
 {
-	return folio_start_writeback(page_folio(page));
+	folio_start_writeback(page_folio(page));
 }
 EXPORT_SYMBOL(set_page_writeback);
 
--- a/mm/page-writeback.c~mm-return-void-from-folio_start_writeback-and-related-functions
+++ a/mm/page-writeback.c
@@ -2982,67 +2982,63 @@ bool __folio_end_writeback(struct folio
 	return ret;
 }
 
-bool __folio_start_writeback(struct folio *folio, bool keep_write)
+void __folio_start_writeback(struct folio *folio, bool keep_write)
 {
 	long nr = folio_nr_pages(folio);
 	struct address_space *mapping = folio_mapping(folio);
-	bool ret;
 	int access_ret;
 
+	VM_BUG_ON_FOLIO(folio_test_writeback(folio), folio);
+
 	folio_memcg_lock(folio);
 	if (mapping && mapping_use_writeback_tags(mapping)) {
 		XA_STATE(xas, &mapping->i_pages, folio_index(folio));
 		struct inode *inode = mapping->host;
 		struct backing_dev_info *bdi = inode_to_bdi(inode);
 		unsigned long flags;
+		bool on_wblist;
 
 		xas_lock_irqsave(&xas, flags);
 		xas_load(&xas);
-		ret = folio_test_set_writeback(folio);
-		if (!ret) {
-			bool on_wblist;
-
-			on_wblist = mapping_tagged(mapping,
-						   PAGECACHE_TAG_WRITEBACK);
-
-			xas_set_mark(&xas, PAGECACHE_TAG_WRITEBACK);
-			if (bdi->capabilities & BDI_CAP_WRITEBACK_ACCT) {
-				struct bdi_writeback *wb = inode_to_wb(inode);
-
-				wb_stat_mod(wb, WB_WRITEBACK, nr);
-				if (!on_wblist)
-					wb_inode_writeback_start(wb);
-			}
-
-			/*
-			 * We can come through here when swapping
-			 * anonymous folios, so we don't necessarily
-			 * have an inode to track for sync.
-			 */
-			if (mapping->host && !on_wblist)
-				sb_mark_inode_writeback(mapping->host);
+		folio_test_set_writeback(folio);
+
+		on_wblist = mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK);
+
+		xas_set_mark(&xas, PAGECACHE_TAG_WRITEBACK);
+		if (bdi->capabilities & BDI_CAP_WRITEBACK_ACCT) {
+			struct bdi_writeback *wb = inode_to_wb(inode);
+
+			wb_stat_mod(wb, WB_WRITEBACK, nr);
+			if (!on_wblist)
+				wb_inode_writeback_start(wb);
 		}
+
+		/*
+		 * We can come through here when swapping anonymous
+		 * folios, so we don't necessarily have an inode to
+		 * track for sync.
+		 */
+		if (mapping->host && !on_wblist)
+			sb_mark_inode_writeback(mapping->host);
 		if (!folio_test_dirty(folio))
 			xas_clear_mark(&xas, PAGECACHE_TAG_DIRTY);
 		if (!keep_write)
 			xas_clear_mark(&xas, PAGECACHE_TAG_TOWRITE);
 		xas_unlock_irqrestore(&xas, flags);
 	} else {
-		ret = folio_test_set_writeback(folio);
-	}
-	if (!ret) {
-		lruvec_stat_mod_folio(folio, NR_WRITEBACK, nr);
-		zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
+		folio_test_set_writeback(folio);
 	}
+
+	lruvec_stat_mod_folio(folio, NR_WRITEBACK, nr);
+	zone_stat_mod_folio(folio, NR_ZONE_WRITE_PENDING, nr);
 	folio_memcg_unlock(folio);
+
 	access_ret = arch_make_folio_accessible(folio);
 	/*
 	 * If writeback has been triggered on a page that cannot be made
 	 * accessible, it is too late to recover here.
 	 */
 	VM_BUG_ON_FOLIO(access_ret != 0, folio);
-
-	return ret;
 }
 EXPORT_SYMBOL(__folio_start_writeback);
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-mapping_evict_folio-the-preferred-way-to-evict-clean-folios.patch
mm-convert-__do_fault-to-use-a-folio.patch
mm-use-mapping_evict_folio-in-truncate_error_page.patch
mm-convert-soft_offline_in_use_page-to-use-a-folio.patch
mm-convert-isolate_page-to-mf_isolate_folio.patch
mm-remove-invalidate_inode_page.patch
mm-remove-test_set_page_writeback.patch
afs-do-not-test-the-return-value-of-folio_start_writeback.patch
smb-do-not-test-the-return-value-of-folio_start_writeback.patch
mm-return-void-from-folio_start_writeback-and-related-functions.patch

