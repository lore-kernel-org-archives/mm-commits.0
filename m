Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE6BC5DF62
	for <mm-commits@archiver.kernel.org>; Tue, 25 Jan 2022 23:33:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234817AbiAYXcw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 25 Jan 2022 18:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234893AbiAYXcn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 25 Jan 2022 18:32:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FFCCC06161C
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 15:32:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0D1D60BBC
        for <mm-commits@vger.kernel.org>; Tue, 25 Jan 2022 23:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD200C340E0;
        Tue, 25 Jan 2022 23:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643153562;
        bh=pefV28/w6S748UER4LJwfP6hNXaCvLRXzDYMamBwB7g=;
        h=Date:From:To:Subject:From;
        b=R26f96j1SkCwDMPySGQ4PRrV7UnpbUtcu0gpGB2lzfHafddtq8W8IEaWnT9XDtltJ
         NYDCM8+E7L4OrIjwrAQ6Py+OANyi+Dd1GLiBPGftpPPKluadQg/dkPcRo+4cx5CfOn
         6AL5279mnRNPY/TCaa1Hu2xEmuz/a441u3mhjcLM=
Date:   Tue, 25 Jan 2022 15:32:41 -0800
From:   akpm@linux-foundation.org
To:     aquini@redhat.com, david@redhat.com, linmiaohe@huawei.com,
        mm-commits@vger.kernel.org, mst@redhat.com,
        songmuchun@bytedance.com
Subject:  +
 mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch
 added to -mm tree
Message-ID: <20220125233241.Kt8aG9J6V%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/balloon_compaction: make balloon page compaction callbacks static
has been added to the -mm tree.  Its filename is
     mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/balloon_compaction: make balloon page compaction callbacks static

Since commit b1123ea6d3b3 ("mm: balloon: use general non-lru movable page
feature"), these functions are called via balloon_aops callbacks.  They're
not called directly outside this file.  So make them static and clean up
the relevant code.

Link: https://lkml.kernel.org/r/20220125132221.2220-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/balloon_compaction.h |   22 ----------------------
 mm/balloon_compaction.c            |    6 +++---
 2 files changed, 3 insertions(+), 25 deletions(-)

--- a/include/linux/balloon_compaction.h~mm-balloon_compaction-make-balloon-page-compaction-callbacks-static
+++ a/include/linux/balloon_compaction.h
@@ -80,12 +80,6 @@ static inline void balloon_devinfo_init(
 
 #ifdef CONFIG_BALLOON_COMPACTION
 extern const struct address_space_operations balloon_aops;
-extern bool balloon_page_isolate(struct page *page,
-				isolate_mode_t mode);
-extern void balloon_page_putback(struct page *page);
-extern int balloon_page_migrate(struct address_space *mapping,
-				struct page *newpage,
-				struct page *page, enum migrate_mode mode);
 
 /*
  * balloon_page_insert - insert a page into the balloon's page list and make
@@ -155,22 +149,6 @@ static inline void balloon_page_delete(s
 	list_del(&page->lru);
 }
 
-static inline bool balloon_page_isolate(struct page *page)
-{
-	return false;
-}
-
-static inline void balloon_page_putback(struct page *page)
-{
-	return;
-}
-
-static inline int balloon_page_migrate(struct page *newpage,
-				struct page *page, enum migrate_mode mode)
-{
-	return 0;
-}
-
 static inline gfp_t balloon_mapping_gfp_mask(void)
 {
 	return GFP_HIGHUSER;
--- a/mm/balloon_compaction.c~mm-balloon_compaction-make-balloon-page-compaction-callbacks-static
+++ a/mm/balloon_compaction.c
@@ -203,7 +203,7 @@ EXPORT_SYMBOL_GPL(balloon_page_dequeue);
 
 #ifdef CONFIG_BALLOON_COMPACTION
 
-bool balloon_page_isolate(struct page *page, isolate_mode_t mode)
+static bool balloon_page_isolate(struct page *page, isolate_mode_t mode)
 
 {
 	struct balloon_dev_info *b_dev_info = balloon_page_device(page);
@@ -217,7 +217,7 @@ bool balloon_page_isolate(struct page *p
 	return true;
 }
 
-void balloon_page_putback(struct page *page)
+static void balloon_page_putback(struct page *page)
 {
 	struct balloon_dev_info *b_dev_info = balloon_page_device(page);
 	unsigned long flags;
@@ -230,7 +230,7 @@ void balloon_page_putback(struct page *p
 
 
 /* move_to_new_page() counterpart for a ballooned page */
-int balloon_page_migrate(struct address_space *mapping,
+static int balloon_page_migrate(struct address_space *mapping,
 		struct page *newpage, struct page *page,
 		enum migrate_mode mode)
 {
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmalloc-remove-unneeded-function-forward-declaration.patch
mm-balloon_compaction-make-balloon-page-compaction-callbacks-static.patch

