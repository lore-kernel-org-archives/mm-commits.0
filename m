Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E157C61DA4
	for <mm-commits@archiver.kernel.org>; Thu, 16 Feb 2023 22:47:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjBPWrd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Feb 2023 17:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjBPWrc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2023 17:47:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B98A746D4A
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 14:47:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 773DEB8289D
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 22:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD5FC433D2;
        Thu, 16 Feb 2023 22:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676587649;
        bh=xyDfR4F4f2XljwnNjPUNmBiYUEpFNSWES8Mg4o0v+vA=;
        h=Date:To:From:Subject:From;
        b=RyR1uOqJw5Fap7fJem5/wS7odUERFAPbuskqY8RpsUSQmcyruRJHtDh+XbJq4ikhV
         geeSENkGG9A6QHeet2fKW4m5NVs9ZpLocRpZ5Kw51VahJEZNXRAz4wI27WFGW2ax+r
         XjEhXIs3m36Dv0d+KdxKZajqhA9eyoVq35V6sIgA=
Date:   Thu, 16 Feb 2023 14:47:28 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + include-linux-migrateh-remove-unneeded-externs.patch added to mm-unstable branch
Message-Id: <20230216224729.0DD5FC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/migrate.h: remove unneeded externs
has been added to the -mm mm-unstable branch.  Its filename is
     include-linux-migrateh-remove-unneeded-externs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/include-linux-migrateh-remove-unneeded-externs.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: include/linux/migrate.h: remove unneeded externs
Date: Thu Feb 16 02:44:24 PM PST 2023

As suggested by Matthew.

Suggested-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/migrate.h~include-linux-migrateh-remove-unneeded-externs
+++ a/include/linux/migrate.h
@@ -62,16 +62,16 @@ extern const char *migrate_reason_names[
 
 #ifdef CONFIG_MIGRATION
 
-extern void putback_movable_pages(struct list_head *l);
+void putback_movable_pages(struct list_head *l);
 int migrate_folio_extra(struct address_space *mapping, struct folio *dst,
 		struct folio *src, enum migrate_mode mode, int extra_count);
 int migrate_folio(struct address_space *mapping, struct folio *dst,
 		struct folio *src, enum migrate_mode mode);
-extern int migrate_pages(struct list_head *l, new_page_t new, free_page_t free,
-		unsigned long private, enum migrate_mode mode, int reason,
-		unsigned int *ret_succeeded);
-extern struct page *alloc_migration_target(struct page *page, unsigned long private);
-extern bool isolate_movable_page(struct page *page, isolate_mode_t mode);
+int migrate_pages(struct list_head *l, new_page_t new, free_page_t free,
+		  unsigned long private, enum migrate_mode mode, int reason,
+		  unsigned int *ret_succeeded);
+struct page *alloc_migration_target(struct page *page, unsigned long private);
+bool isolate_movable_page(struct page *page, isolate_mode_t mode);
 
 int migrate_huge_page_move_mapping(struct address_space *mapping,
 		struct folio *dst, struct folio *src);
@@ -142,8 +142,8 @@ const struct movable_operations *page_mo
 }
 
 #ifdef CONFIG_NUMA_BALANCING
-extern int migrate_misplaced_page(struct page *page,
-				  struct vm_area_struct *vma, int node);
+int migrate_misplaced_page(struct page *page, struct vm_area_struct *vma,
+			   int node);
 #else
 static inline int migrate_misplaced_page(struct page *page,
 					 struct vm_area_struct *vma, int node)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-move-documentation-comments-to-stackdepoth-fix.patch
mm-hugetlb-change-to-return-bool-for-isolate_hugetlb-fix.patch
mm-change-to-return-bool-for-isolate_movable_page-fix.patch
include-linux-migrateh-remove-unneeded-externs.patch

