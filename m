Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5128EC636CC
	for <mm-commits@archiver.kernel.org>; Mon, 13 Feb 2023 23:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbjBMX4G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Feb 2023 18:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbjBMXzi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Feb 2023 18:55:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05EB18B13
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 15:55:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 703E46135C
        for <mm-commits@vger.kernel.org>; Mon, 13 Feb 2023 23:55:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C34D8C4339C;
        Mon, 13 Feb 2023 23:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676332535;
        bh=6QyCBapI5k7An4oLUxXvGkZVyeKuYqPjX5zc9o0h+4Q=;
        h=Date:To:From:Subject:From;
        b=QlDJSgfOaHWEXg7nKZUL7meoLGxPdU5gDTf+9ayLpCXDno+SZv7c/7n6djgMxfr4b
         ObcrKJ52vXJ4ajt6ucTlnU+97wZXw/hxSq4W7dJY8MgHbn7d9/8F+b6I8G7exi8prB
         /U7UNJSg/mXlUyE4egaq3te/drR4P8bD9Oi2KXbc=
Date:   Mon, 13 Feb 2023 15:55:35 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate-add-folio_movable_ops.patch removed from -mm tree
Message-Id: <20230213235535.C34D8C4339C@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/migrate: add folio_movable_ops()
has been removed from the -mm tree.  Its filename was
     mm-migrate-add-folio_movable_ops.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: mm/migrate: add folio_movable_ops()
Date: Mon, 30 Jan 2023 13:43:50 -0800

folio_movable_ops() does the same as page_movable_ops() except uses folios
instead of pages.  This function will help make folio conversions in
migrate.c more readable.

Link: https://lkml.kernel.org/r/20230130214352.40538-3-vishal.moola@gmail.com
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/migrate.h~mm-migrate-add-folio_movable_ops
+++ a/include/linux/migrate.h
@@ -123,6 +123,15 @@ static inline bool folio_test_movable(st
 }
 
 static inline
+const struct movable_operations *folio_movable_ops(struct folio *folio)
+{
+	VM_BUG_ON(!__folio_test_movable(folio));
+
+	return (const struct movable_operations *)
+		((unsigned long)folio->mapping - PAGE_MAPPING_MOVABLE);
+}
+
+static inline
 const struct movable_operations *page_movable_ops(struct page *page)
 {
 	VM_BUG_ON(!__PageMovable(page));
--- a/mm/migrate.c~mm-migrate-add-folio_movable_ops
+++ a/mm/migrate.c
@@ -990,7 +990,7 @@ static int move_to_new_folio(struct foli
 			goto out;
 		}
 
-		mops = page_movable_ops(&src->page);
+		mops = folio_movable_ops(src);
 		rc = mops->migrate_page(&dst->page, &src->page, mode);
 		WARN_ON_ONCE(rc == MIGRATEPAGE_SUCCESS &&
 				!folio_test_isolated(src));
_

Patches currently in -mm which might be from vishal.moola@gmail.com are


