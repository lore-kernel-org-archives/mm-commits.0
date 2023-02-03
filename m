Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D4DC64EC3
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:41:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232054AbjBCGlz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:41:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbjBCGks (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:40:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448148FB44
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:37:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 97ADDCE2EA3
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B04C433EF;
        Fri,  3 Feb 2023 06:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675406257;
        bh=H/vJiedTxoIO8Guds2OPrhGYmvjYntxO7k+CFpNo1z4=;
        h=Date:To:From:Subject:From;
        b=PmUhYGx/udaT7wXguoOxc4Ba2F7cV031K30kVlfWGYeKHjppETuGLZJDiDVYDzB2k
         hAhP7lLUfTQvZvI3LVNHJ6jCVzjhnKtc1SWDy5YmN+a6VfCvku0fNfpV7nQYiy22mC
         bbn31bHJnaNbP4p6lQk8Lpe3GmudkulAuaioByag=
Date:   Thu, 02 Feb 2023 22:37:36 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-convert-mem_cgroup_css_from_page-to-mem_cgroup_css_from_folio.patch removed from -mm tree
Message-Id: <20230203063737.09B04C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: convert mem_cgroup_css_from_page() to mem_cgroup_css_from_folio()
has been removed from the -mm tree.  Its filename was
     mm-convert-mem_cgroup_css_from_page-to-mem_cgroup_css_from_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm: convert mem_cgroup_css_from_page() to mem_cgroup_css_from_folio()
Date: Mon, 16 Jan 2023 19:25:07 +0000

Only one caller doesn't have a folio, so move the page_folio() call to
that one caller from mem_cgroup_css_from_folio().

Link: https://lkml.kernel.org/r/20230116192507.2146150-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/fs-writeback.c~mm-convert-mem_cgroup_css_from_page-to-mem_cgroup_css_from_folio
+++ a/fs/fs-writeback.c
@@ -246,7 +246,7 @@ void __inode_attach_wb(struct inode *ino
 		struct cgroup_subsys_state *memcg_css;
 
 		if (folio) {
-			memcg_css = mem_cgroup_css_from_page(&folio->page);
+			memcg_css = mem_cgroup_css_from_folio(folio);
 			wb = wb_get_create(bdi, memcg_css, GFP_ATOMIC);
 		} else {
 			/* must pin memcg_css, see wb_get_create() */
@@ -859,6 +859,7 @@ EXPORT_SYMBOL_GPL(wbc_detach_inode);
 void wbc_account_cgroup_owner(struct writeback_control *wbc, struct page *page,
 			      size_t bytes)
 {
+	struct folio *folio;
 	struct cgroup_subsys_state *css;
 	int id;
 
@@ -871,7 +872,8 @@ void wbc_account_cgroup_owner(struct wri
 	if (!wbc->wb || wbc->no_cgroup_owner)
 		return;
 
-	css = mem_cgroup_css_from_page(page);
+	folio = page_folio(page);
+	css = mem_cgroup_css_from_folio(folio);
 	/* dead cgroups shouldn't contribute to inode ownership arbitration */
 	if (!(css->flags & CSS_ONLINE))
 		return;
--- a/include/linux/memcontrol.h~mm-convert-mem_cgroup_css_from_page-to-mem_cgroup_css_from_folio
+++ a/include/linux/memcontrol.h
@@ -890,7 +890,7 @@ static inline bool mm_match_cgroup(struc
 	return match;
 }
 
-struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page);
+struct cgroup_subsys_state *mem_cgroup_css_from_folio(struct folio *folio);
 ino_t page_cgroup_ino(struct page *page);
 
 static inline bool mem_cgroup_online(struct mem_cgroup *memcg)
--- a/mm/memcontrol.c~mm-convert-mem_cgroup_css_from_page-to-mem_cgroup_css_from_folio
+++ a/mm/memcontrol.c
@@ -350,21 +350,19 @@ EXPORT_SYMBOL(memcg_kmem_enabled_key);
 #endif
 
 /**
- * mem_cgroup_css_from_page - css of the memcg associated with a page
- * @page: page of interest
+ * mem_cgroup_css_from_folio - css of the memcg associated with a folio
+ * @folio: folio of interest
  *
  * If memcg is bound to the default hierarchy, css of the memcg associated
- * with @page is returned.  The returned css remains associated with @page
+ * with @folio is returned.  The returned css remains associated with @folio
  * until it is released.
  *
  * If memcg is bound to a traditional hierarchy, the css of root_mem_cgroup
  * is returned.
  */
-struct cgroup_subsys_state *mem_cgroup_css_from_page(struct page *page)
+struct cgroup_subsys_state *mem_cgroup_css_from_folio(struct folio *folio)
 {
-	struct mem_cgroup *memcg;
-
-	memcg = page_memcg(page);
+	struct mem_cgroup *memcg = folio_memcg(folio);
 
 	if (!memcg || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		memcg = root_mem_cgroup;
_

Patches currently in -mm which might be from willy@infradead.org are


