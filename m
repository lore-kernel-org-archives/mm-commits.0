Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27118C77B75
	for <mm-commits@archiver.kernel.org>; Fri, 12 May 2023 22:50:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239808AbjELWut (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 12 May 2023 18:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbjELWus (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 12 May 2023 18:50:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2934A4C3D
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 15:50:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A43C965925
        for <mm-commits@vger.kernel.org>; Fri, 12 May 2023 22:50:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06361C433EF;
        Fri, 12 May 2023 22:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683931846;
        bh=dUzbaj6+JlIhu1k4oDZg1qKYNNDxbTrcuFmuzIi6hkI=;
        h=Date:To:From:Subject:From;
        b=MqAZhBcDhlFIYT2NouQgkry3gD49LJM8eBj35IoWJNw83xhdJ6x93yDyElB6cgPmO
         RzvPxfPJ6N2St+da/1zzxyEeb5EQWHNjoYUqF6IGgsefEoPiUR8pBHjiB2VvpU1a2b
         nggGyN9ICLQFM/SdmTK21jmhIEi0m6dU6qPv6qvk=
Date:   Fri, 12 May 2023 15:50:45 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        steven.sistare@oracle.com, khalid.aziz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-compaction-skip-all-non-migratable-pages-during-scan.patch added to mm-unstable branch
Message-Id: <20230512225046.06361C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, compaction: Skip all non-migratable pages during scan
has been added to the -mm mm-unstable branch.  Its filename is
     mm-compaction-skip-all-non-migratable-pages-during-scan.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-compaction-skip-all-non-migratable-pages-during-scan.patch

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
From: Khalid Aziz <khalid.aziz@oracle.com>
Subject: mm, compaction: Skip all non-migratable pages during scan
Date: Fri, 12 May 2023 13:00:00 -0600

Pages pinned in memory through extra refcounts can not be migrated. 
Currently as isolate_migratepages_block() scans pages for compaction, it
skips any pinned anonymous pages.  All non-migratable pages should be
skipped and not just the anonymous pinned pages.

This patch adds a check for extra refcounts on a page to determine if the
page can be migrated.  This was seen as a real issue on a customer
workload where a large number of pages were pinned by vfio on the host and
any attempts to allocate hugepages resulted in significant amount of cpu
time spent in either direct compaction or in kcompatd scanning vfio pinned
pages over and over again that can not be migrated.

Link: https://lkml.kernel.org/r/20230512190000.103737-1-khalid.aziz@oracle.com
Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
Suggested-by: Steve Sistare <steven.sistare@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

--- a/mm/compaction.c~mm-compaction-skip-all-non-migratable-pages-during-scan
+++ a/mm/compaction.c
@@ -765,6 +765,34 @@ static bool too_many_isolated(pg_data_t
 	return too_many;
 }
 
+/*
+ * Check if this base page should be skipped from isolation because
+ * it has extra refcounts that will prevent it from being migrated.
+ * This function is called for regular pages only, and not
+ * for THP or hugetlbfs pages. This code is inspired by similar code
+ * in migrate_vma_check_page(), can_split_folio() and
+ * folio_migrate_mapping()
+ */
+static inline bool page_has_extrarefs(struct page *page,
+					struct address_space *mapping)
+{
+	unsigned long extra_refs;
+
+	/* anonymous page can have extra ref from swap cache */
+	if (mapping)
+		extra_refs = 1 + PagePrivate(page);
+	else
+		extra_refs = PageSwapCache(page) ? 1 : 0;
+
+	/*
+	 * This is an admittedly racy check but good enough to determine
+	 * if a page is pinned and can not be migrated
+	 */
+	if ((page_ref_count(page) - extra_refs) > page_mapcount(page))
+		return true;
+	return false;
+}
+
 /**
  * isolate_migratepages_block() - isolate all migrate-able pages within
  *				  a single pageblock
@@ -1003,12 +1031,12 @@ isolate_migratepages_block(struct compac
 			goto isolate_fail;
 
 		/*
-		 * Migration will fail if an anonymous page is pinned in memory,
-		 * so avoid taking lru_lock and isolating it unnecessarily in an
-		 * admittedly racy check.
+		 * Migration will fail if a page has extra refcounts
+		 * preventing it from migrating, so avoid taking
+		 * lru_lock and isolating it unnecessarily
 		 */
 		mapping = page_mapping(page);
-		if (!mapping && (page_count(page) - 1) > total_mapcount(page))
+		if (page_has_extrarefs(page, mapping))
 			goto isolate_fail_put;
 
 		/*
_

Patches currently in -mm which might be from khalid.aziz@oracle.com are

mm-compaction-skip-all-non-migratable-pages-during-scan.patch

