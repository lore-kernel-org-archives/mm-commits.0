Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE6AECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiILDa6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiILD3S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:29:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC508286D8
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74D3EB8085E
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C64C433D7;
        Mon, 12 Sep 2022 03:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953340;
        bh=RZ/TiV/IYHI+sUfdfNhmT/5Pi24dqeKYrNfHywSCOmA=;
        h=Date:To:From:Subject:From;
        b=ptnvXxZ95uD6G4wWwerBBToEHqNSQLLCNgz7y/W69WkhGMx4vahvsvFg6dUyh6Bbs
         +p+WmCJWHwU1Z/k3+4uRCaA19EJ3u7P4+8YUXiXbCs3jslqPeiwIOB8hF1fGZVIIyG
         s8LgdpXwdH3V0vs8OoWJ58VTICAvz7Z0Rox+Ti/Q=
Date:   Sun, 11 Sep 2022 20:28:59 -0700
To:     mm-commits@vger.kernel.org, syoshida@redhat.com,
        pasha.tatashin@soleen.com, minchan@kernel.org, jhubbard@nvidia.com,
        jgg@nvidia.com, david@redhat.com, apopple@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes.patch removed from -mm tree
Message-Id: <20220912032900.28C64C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/gup.c: simplify and fix check_and_migrate_movable_pages() return codes
has been removed from the -mm tree.  Its filename was
     mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: mm/gup.c: simplify and fix check_and_migrate_movable_pages() return codes
Date: Fri, 29 Jul 2022 12:46:45 +1000

When pinning pages with FOLL_LONGTERM check_and_migrate_movable_pages() is
called to migrate pages out of zones which should not contain any longterm
pinned pages.

When migration succeeds all pages will have been unpinned so pinning needs
to be retried.  This is indicated by returning zero.  When all pages are
in the correct zone the number of pinned pages is returned.

However migration can also fail, in which case pages are unpinned and
-ENOMEM is returned.  However if the failure was due to not being unable
to isolate a page zero is returned.  This leads to indefinite looping in
__gup_longterm_locked().

Fix this by simplifying the return codes such that zero indicates all
pages were successfully pinned in the correct zone while errors indicate
either pages were migrated and pinning should be retried or that migration
has failed and therefore the pinning operation should fail.

[syoshida@redhat.com: fix return value for __gup_longterm_locked()]
  Link: https://lkml.kernel.org/r/20220821183547.950370-1-syoshida@redhat.com
[akpm@linux-foundation.org: fix code layout, per John]
[yshigeru@gmail.com: fix uninitialized return value on __gup_longterm_locked()]
  Link: https://lkml.kernel.org/r/20220827230037.78876-1-syoshida@redhat.com
Link: https://lkml.kernel.org/r/20220729024645.764366-1-apopple@nvidia.com
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   60 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 32 insertions(+), 28 deletions(-)

--- a/mm/gup.c~mm-gupc-simplify-and-fix-check_and_migrate_movable_pages-return-codes
+++ a/mm/gup.c
@@ -1927,16 +1927,16 @@ struct page *get_dump_page(unsigned long
 
 #ifdef CONFIG_MIGRATION
 /*
- * Check whether all pages are pinnable, if so return number of pages.  If some
- * pages are not pinnable, migrate them, and unpin all pages. Return zero if
- * pages were migrated, or if some pages were not successfully isolated.
- * Return negative error if migration fails.
+ * Check whether all pages are pinnable. If some pages are not pinnable migrate
+ * them and unpin all the pages. Returns -EAGAIN if pages were unpinned or zero
+ * if all pages are pinnable and in the right zone. Other errors indicate
+ * migration failure.
  */
 static long check_and_migrate_movable_pages(unsigned long nr_pages,
 					    struct page **pages,
 					    unsigned int gup_flags)
 {
-	unsigned long isolation_error_count = 0, i;
+	unsigned long i;
 	struct folio *prev_folio = NULL;
 	LIST_HEAD(movable_page_list);
 	bool drain_allow = true, coherent_pages = false;
@@ -1972,10 +1972,10 @@ static long check_and_migrate_movable_pa
 				unpin_user_page(&folio->page);
 			}
 
-			ret = migrate_device_coherent_page(&folio->page);
-			if (ret)
-				goto unpin_pages;
-
+			if (migrate_device_coherent_page(&folio->page)) {
+				ret = -EBUSY;
+				break;
+			}
 			continue;
 		}
 
@@ -1987,7 +1987,7 @@ static long check_and_migrate_movable_pa
 		if (folio_test_hugetlb(folio)) {
 			if (isolate_hugetlb(&folio->page,
 						&movable_page_list))
-				isolation_error_count++;
+				ret = -EBUSY;
 			continue;
 		}
 
@@ -1997,7 +1997,7 @@ static long check_and_migrate_movable_pa
 		}
 
 		if (folio_isolate_lru(folio)) {
-			isolation_error_count++;
+			ret = -EBUSY;
 			continue;
 		}
 		list_add_tail(&folio->lru, &movable_page_list);
@@ -2006,19 +2006,18 @@ static long check_and_migrate_movable_pa
 				    folio_nr_pages(folio));
 	}
 
-	if (!list_empty(&movable_page_list) || isolation_error_count ||
-	    coherent_pages)
-		goto unpin_pages;
-
 	/*
 	 * If list is empty, and no isolation errors, means that all pages are
-	 * in the correct zone.
+	 * in the correct zone. If there were device coherent pages some pages
+	 * have been unpinned.
 	 */
-	return nr_pages;
+	if (list_empty(&movable_page_list) && !ret && !coherent_pages)
+		return 0;
 
-unpin_pages:
 	/*
-	 * pages[i] might be NULL if any device coherent pages were found.
+	 * Unpin all pages. If device coherent pages were found
+	 * migrate_device_coherent_page() will have dropped the pin and set
+	 * pages[i] == NULL.
 	 */
 	for (i = 0; i < nr_pages; i++) {
 		if (!pages[i])
@@ -2045,14 +2044,15 @@ unpin_pages:
 
 	if (ret && !list_empty(&movable_page_list))
 		putback_movable_pages(&movable_page_list);
-	return ret;
+
+	return ret ? ret : -EAGAIN;
 }
 #else
 static long check_and_migrate_movable_pages(unsigned long nr_pages,
 					    struct page **pages,
 					    unsigned int gup_flags)
 {
-	return nr_pages;
+	return 0;
 }
 #endif /* CONFIG_MIGRATION */
 
@@ -2068,22 +2068,26 @@ static long __gup_longterm_locked(struct
 				  unsigned int gup_flags)
 {
 	unsigned int flags;
-	long rc;
+	long rc, nr_pinned_pages;
 
 	if (!(gup_flags & FOLL_LONGTERM))
 		return __get_user_pages_locked(mm, start, nr_pages, pages, vmas,
 					       NULL, gup_flags);
 	flags = memalloc_pin_save();
 	do {
-		rc = __get_user_pages_locked(mm, start, nr_pages, pages, vmas,
-					     NULL, gup_flags);
-		if (rc <= 0)
+		nr_pinned_pages = __get_user_pages_locked(mm, start, nr_pages,
+							  pages, vmas, NULL,
+							  gup_flags);
+		if (nr_pinned_pages <= 0) {
+			rc = nr_pinned_pages;
 			break;
-		rc = check_and_migrate_movable_pages(rc, pages, gup_flags);
-	} while (!rc);
+		}
+		rc = check_and_migrate_movable_pages(nr_pinned_pages, pages,
+						     gup_flags);
+	} while (rc == -EAGAIN);
 	memalloc_pin_restore(flags);
 
-	return rc;
+	return rc ? rc : nr_pinned_pages;
 }
 
 static bool is_valid_gup_flags(unsigned int gup_flags)
_

Patches currently in -mm which might be from apopple@nvidia.com are

selftests-hmm-tests-add-test-for-dirty-bits.patch

