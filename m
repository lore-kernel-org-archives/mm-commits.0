Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F00C64EC7
	for <mm-commits@archiver.kernel.org>; Mon, 20 Feb 2023 20:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbjBTUrU (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Feb 2023 15:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231923AbjBTUrH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Feb 2023 15:47:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB817E0
        for <mm-commits@vger.kernel.org>; Mon, 20 Feb 2023 12:47:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54A0060F17
        for <mm-commits@vger.kernel.org>; Mon, 20 Feb 2023 20:47:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96BEC433EF;
        Mon, 20 Feb 2023 20:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676926025;
        bh=LhdV3LcBym2QcUYwyzZg5vKLpsoT0fKE9SqgcQEkwbU=;
        h=Date:To:From:Subject:From;
        b=NP/nweg3yrtXPtRa6pmCJLsfyMf7ytfxJnES9Te5H5dN2evqGSvQG+Ocsn5JOUlzs
         HxT2h2kDgc70YKVOEyzVz3V8jsrCx4830akB713RqG/wX6oc+kDSZYvov6yU/IusxP
         tsnGg8CGcp2lbUUTeZGpPDiYLATYC5yJZfDLlwT0=
Date:   Mon, 20 Feb 2023 12:47:05 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] include-linux-migrateh-remove-unneeded-externs.patch removed from -mm tree
Message-Id: <20230220204705.A96BEC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: include/linux/migrate.h: remove unneeded externs
has been removed from the -mm tree.  Its filename was
     include-linux-migrateh-remove-unneeded-externs.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


