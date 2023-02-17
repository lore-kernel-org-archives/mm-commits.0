Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3C36C636D4
	for <mm-commits@archiver.kernel.org>; Fri, 17 Feb 2023 04:45:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjBQEpt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Feb 2023 23:45:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjBQEox (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Feb 2023 23:44:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7DD2518C9
        for <mm-commits@vger.kernel.org>; Thu, 16 Feb 2023 20:44:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82EEBB829C0
        for <mm-commits@vger.kernel.org>; Fri, 17 Feb 2023 04:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35401C433D2;
        Fri, 17 Feb 2023 04:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1676609086;
        bh=l91OHPVg9pRHb6y+9Z62wtDSm19GEoqcJcJHBUth3aw=;
        h=Date:To:From:Subject:From;
        b=1tKvAXa6DvYF3dDaJ6Z/rqoMQXUghYl7JfFokZMda/ETfwtGMtN6Ro7d1zPkia72z
         tjTOtBx2kTq59HFOqCmRmEzn7Pv8MdmaUYSsq9Pr17nt5GT1dIPhEJlWF2Z7L0IhNg
         9g0mWJEcMSB2Pgtc/CYaA/u3V7lz6WtMHmfS3quU=
Date:   Thu, 16 Feb 2023 20:44:45 -0800
To:     mm-commits@vger.kernel.org, ziy@nvidia.com, xhao@linux.alibaba.com,
        willy@infradead.org, shy828301@gmail.com, osalvador@suse.de,
        minchan@kernel.org, mike.kravetz@oracle.com, bharata@amd.com,
        baolin.wang@linux.alibaba.com, apopple@nvidia.com,
        42.hyeyoo@gmail.com, ying.huang@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] migrate_pages-move-migrate_folio_unmap.patch removed from -mm tree
Message-Id: <20230217044446.35401C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: migrate_pages: move migrate_folio_unmap()
has been removed from the -mm tree.  Its filename was
     migrate_pages-move-migrate_folio_unmap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: migrate_pages: move migrate_folio_unmap()
Date: Mon, 13 Feb 2023 20:34:41 +0800

Just move the position of the functions.  There's no any functionality
change.  This is to make it easier to review the next patch via putting
code near its position in the next patch.

Link: https://lkml.kernel.org/r/20230213123444.155149-7-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Bharata B Rao <bharata@amd.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Xin Hao <xhao@linux.alibaba.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/migrate.c~migrate_pages-move-migrate_folio_unmap
+++ a/mm/migrate.c
@@ -1236,6 +1236,56 @@ out:
 	return rc;
 }
 
+/* Obtain the lock on page, remove all ptes. */
+static int migrate_folio_unmap(new_page_t get_new_page, free_page_t put_new_page,
+			       unsigned long private, struct folio *src,
+			       struct folio **dstp, int force, bool avoid_force_lock,
+			       enum migrate_mode mode, enum migrate_reason reason,
+			       struct list_head *ret)
+{
+	struct folio *dst;
+	int rc = MIGRATEPAGE_UNMAP;
+	struct page *newpage = NULL;
+
+	if (!thp_migration_supported() && folio_test_transhuge(src))
+		return -ENOSYS;
+
+	if (folio_ref_count(src) == 1) {
+		/* Folio was freed from under us. So we are done. */
+		folio_clear_active(src);
+		folio_clear_unevictable(src);
+		/* free_pages_prepare() will clear PG_isolated. */
+		list_del(&src->lru);
+		migrate_folio_done(src, reason);
+		return MIGRATEPAGE_SUCCESS;
+	}
+
+	newpage = get_new_page(&src->page, private);
+	if (!newpage)
+		return -ENOMEM;
+	dst = page_folio(newpage);
+	*dstp = dst;
+
+	dst->private = NULL;
+	rc = __migrate_folio_unmap(src, dst, force, avoid_force_lock, mode);
+	if (rc == MIGRATEPAGE_UNMAP)
+		return rc;
+
+	/*
+	 * A folio that has not been unmapped will be restored to
+	 * right list unless we want to retry.
+	 */
+	if (rc != -EAGAIN && rc != -EDEADLOCK)
+		list_move_tail(&src->lru, ret);
+
+	if (put_new_page)
+		put_new_page(&dst->page, private);
+	else
+		folio_put(dst);
+
+	return rc;
+}
+
 static int __migrate_folio_move(struct folio *src, struct folio *dst,
 				enum migrate_mode mode)
 {
@@ -1294,56 +1344,6 @@ out_unlock_both:
 		folio_put(dst);
 
 	return rc;
-}
-
-/* Obtain the lock on page, remove all ptes. */
-static int migrate_folio_unmap(new_page_t get_new_page, free_page_t put_new_page,
-			       unsigned long private, struct folio *src,
-			       struct folio **dstp, int force, bool avoid_force_lock,
-			       enum migrate_mode mode, enum migrate_reason reason,
-			       struct list_head *ret)
-{
-	struct folio *dst;
-	int rc = MIGRATEPAGE_UNMAP;
-	struct page *newpage = NULL;
-
-	if (!thp_migration_supported() && folio_test_transhuge(src))
-		return -ENOSYS;
-
-	if (folio_ref_count(src) == 1) {
-		/* Folio was freed from under us. So we are done. */
-		folio_clear_active(src);
-		folio_clear_unevictable(src);
-		/* free_pages_prepare() will clear PG_isolated. */
-		list_del(&src->lru);
-		migrate_folio_done(src, reason);
-		return MIGRATEPAGE_SUCCESS;
-	}
-
-	newpage = get_new_page(&src->page, private);
-	if (!newpage)
-		return -ENOMEM;
-	dst = page_folio(newpage);
-	*dstp = dst;
-
-	dst->private = NULL;
-	rc = __migrate_folio_unmap(src, dst, force, avoid_force_lock, mode);
-	if (rc == MIGRATEPAGE_UNMAP)
-		return rc;
-
-	/*
-	 * A folio that has not been unmapped will be restored to
-	 * right list unless we want to retry.
-	 */
-	if (rc != -EAGAIN && rc != -EDEADLOCK)
-		list_move_tail(&src->lru, ret);
-
-	if (put_new_page)
-		put_new_page(&dst->page, private);
-	else
-		folio_put(dst);
-
-	return rc;
 }
 
 /* Migrate the folio to the newly allocated folio in dst. */
_

Patches currently in -mm which might be from ying.huang@intel.com are


