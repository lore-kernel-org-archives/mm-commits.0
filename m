Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F5A8C433DF
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:00:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3196720829
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597194007;
	bh=KPQa57okO8ZK+EnxdWSjJ++KwOIZwd0OJEPdxINkkD8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Y4VxIEup9Q6zXonJ09mVZEihe5wKj/l58TaezZBlWeTR1TUmLafVa+0QJJBjAIlqa
	 rVq25DXr5hNUVSjTq7ceb2ngct3veUWDxbpJWXB/rvk9MnSJlBLyeXw4qUxMlNM421
	 +LZe707tqdtprqg2iUqhUagp6bQ4whcAEaf1RfnA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgHLBAG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:00:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726333AbgHLBAG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:00:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9543C207DA;
        Wed, 12 Aug 2020 01:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597194006;
        bh=KPQa57okO8ZK+EnxdWSjJ++KwOIZwd0OJEPdxINkkD8=;
        h=Date:From:To:Subject:From;
        b=Sviy9xK/7XeYZQq4O2Ddf48OIO+GLNEWuyoi/N9ad6IQMhy8bC4SfQSAYUDP54bNJ
         WSwA4SKHYeKGGHqeqa2T2mU8zh77x3vkeJPBjw8zapyDiszj8PfzVw1iu/vscHgXs+
         cQGtKvGARucdUc+5rjDNF8gYPtdMkZyufzlH0WNo=
Date:   Tue, 11 Aug 2020 18:00:05 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        daniel.m.jordan@oracle.com, hughd@google.com, jhubbard@nvidia.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        willy@infradead.org, ziy@nvidia.com
Subject:  [folded-merged]
 mm-vmstat-add-events-for-thp-migration-without-split-fix.patch removed from
 -mm tree
Message-ID: <20200812010005.xQwm_wnWI%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-vmstat-add-events-for-thp-migration-without-split-fix
has been removed from the -mm tree.  Its filename was
     mm-vmstat-add-events-for-thp-migration-without-split-fix.patch

This patch was dropped because it was folded into mm-vmstat-add-events-for-thp-migration-without-split.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-vmstat-add-events-for-thp-migration-without-split-fix

s/hpage_nr_pages/thp_nr_pages/ due to "mm: replace hpage_nr_pages with
thp_nr_pages".

Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/migrate.c~mm-vmstat-add-events-for-thp-migration-without-split-fix
+++ a/mm/migrate.c
@@ -1429,7 +1429,7 @@ int migrate_pages(struct list_head *from
 	struct page *page;
 	struct page *page2;
 	int swapwrite = current->flags & PF_SWAPWRITE;
-	int rc, thp_nr_pages;
+	int rc, thp_n_pages;
 
 	if (!swapwrite)
 		current->flags |= PF_SWAPWRITE;
@@ -1446,7 +1446,7 @@ retry:
 			 * during migration.
 			 */
 			is_thp = PageTransHuge(page);
-			thp_nr_pages = hpage_nr_pages(page);
+			thp_n_pages = thp_nr_pages(page);
 			cond_resched();
 
 			if (PageHuge(page))
@@ -1483,7 +1483,7 @@ retry:
 				}
 				if (is_thp) {
 					nr_thp_failed++;
-					nr_failed += thp_nr_pages;
+					nr_failed += thp_n_pages;
 					goto out;
 				}
 				nr_failed++;
@@ -1498,7 +1498,7 @@ retry:
 			case MIGRATEPAGE_SUCCESS:
 				if (is_thp) {
 					nr_thp_succeeded++;
-					nr_succeeded += thp_nr_pages;
+					nr_succeeded += thp_n_pages;
 					break;
 				}
 				nr_succeeded++;
@@ -1512,7 +1512,7 @@ retry:
 				 */
 				if (is_thp) {
 					nr_thp_failed++;
-					nr_failed += thp_nr_pages;
+					nr_failed += thp_n_pages;
 					break;
 				}
 				nr_failed++;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-vmstat-add-events-for-thp-migration-without-split.patch
mm-migrate-clear-__gfp_reclaim-to-make-the-migration-callback-consistent-with-regular-thp-allocations-fix.patch
mm-migrate-make-a-standard-migration-target-allocation-function-fix.patch
mm.patch
mm-vmstat-fix-proc-sys-vm-stat_refresh-generating-false-warnings-fix-2.patch
mm-madvise-introduce-process_madvise-syscall-an-external-memory-hinting-api-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

