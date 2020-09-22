Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F3E7C4727D
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:00:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFDCA23A61
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600794029;
	bh=QhwvVenPRXW6HlMUIjZbHVGb5J5V6NjkgctxxoliH2E=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=Q51GU+SPsQP+reP7Ki8uF2tIhjOYK3cB3/rYr6eUOEF7OSjWwds6RhXzWzJNBn6/2
	 Cx14lqftwPt+gQ8tdH9V0iU+7/XwRuvQAamaT4exG78HfexxRwTYAuocMUtt6/VEBb
	 3E1EaebWr3C+AZ/h/08G4AACbzrMFwgqnhx9UJVs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgIVRA3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 13:00:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbgIVRA3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 13:00:29 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E77972395B;
        Tue, 22 Sep 2020 17:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600794028;
        bh=QhwvVenPRXW6HlMUIjZbHVGb5J5V6NjkgctxxoliH2E=;
        h=Date:From:To:Subject:From;
        b=nfh2Wo54hzjMJeMhxKPeXi3vruuPMPGW07K3Wo4aueHuuYkYJtF6GHazXmGufWLcD
         DcaWSppBD9ZZhzI6/kKs0/8Rvh7vfgpLd5zVOScvl2Etg5KVHfUsg76KntwjZz6gbb
         AoXWRnhPNKVhrvw8nmkkfDK1kIZ0Xcjf/gEVXHTE=
Date:   Tue, 22 Sep 2020 10:00:27 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zeil@yandex-team.ru,
        tony.luck@intel.com, osalvador@suse.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, mhocko@kernel.org, david@redhat.com,
        dave.hansen@intel.com, cai@lca.pw, aris@ruivo.org,
        aneesh.kumar@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com,
        osalvador@suse.de
Subject:  +
 mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch added to -mm
 tree
Message-ID: <20200922170027.TEf7D%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: unify THP handling for hard and soft offline
has been added to the -mm tree.  Its filename is
     mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: unify THP handling for hard and soft offline

Place the THP's page handling in a helper and use it from both hard and
soft-offline machinery, so we get rid of some duplicated code.

Link: https://lkml.kernel.org/r/20200922135650.1634-8-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Aristeu Rozanski <aris@ruivo.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   48 +++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-unify-thp-handling-for-hard-and-soft-offline
+++ a/mm/memory-failure.c
@@ -1102,6 +1102,25 @@ static int identify_page_state(unsigned
 	return page_action(ps, p, pfn);
 }
 
+static int try_to_split_thp_page(struct page *page, const char *msg)
+{
+	lock_page(page);
+	if (!PageAnon(page) || unlikely(split_huge_page(page))) {
+		unsigned long pfn = page_to_pfn(page);
+
+		unlock_page(page);
+		if (!PageAnon(page))
+			pr_info("%s: %#lx: non anonymous thp\n", msg, pfn);
+		else
+			pr_info("%s: %#lx: thp split failed\n", msg, pfn);
+		put_page(page);
+		return -EBUSY;
+	}
+	unlock_page(page);
+
+	return 0;
+}
+
 static int memory_failure_hugetlb(unsigned long pfn, int flags)
 {
 	struct page *p = pfn_to_page(pfn);
@@ -1324,21 +1343,8 @@ int memory_failure(unsigned long pfn, in
 	}
 
 	if (PageTransHuge(hpage)) {
-		lock_page(p);
-		if (!PageAnon(p) || unlikely(split_huge_page(p))) {
-			unlock_page(p);
-			if (!PageAnon(p))
-				pr_err("Memory failure: %#lx: non anonymous thp\n",
-					pfn);
-			else
-				pr_err("Memory failure: %#lx: thp split failed\n",
-					pfn);
-			if (TestClearPageHWPoison(p))
-				num_poisoned_pages_dec();
-			put_page(p);
+		if (try_to_split_thp_page(p, "Memory Failure") < 0)
 			return -EBUSY;
-		}
-		unlock_page(p);
 		VM_BUG_ON_PAGE(!page_count(p), p);
 	}
 
@@ -1855,19 +1861,9 @@ static int soft_offline_in_use_page(stru
 	int mt;
 	struct page *hpage = compound_head(page);
 
-	if (!PageHuge(page) && PageTransHuge(hpage)) {
-		lock_page(page);
-		if (!PageAnon(page) || unlikely(split_huge_page(page))) {
-			unlock_page(page);
-			if (!PageAnon(page))
-				pr_info("soft offline: %#lx: non anonymous thp\n", page_to_pfn(page));
-			else
-				pr_info("soft offline: %#lx: thp split failed\n", page_to_pfn(page));
-			put_page(page);
+	if (!PageHuge(page) && PageTransHuge(hpage))
+		if (try_to_split_thp_page(page, "soft offline") < 0)
 			return -EBUSY;
-		}
-		unlock_page(page);
-	}
 
 	/*
 	 * Setting MIGRATE_ISOLATE here ensures that the page will be linked
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-unexport-get_hwpoison_page-and-make-it-static.patch
mmhwpoison-refactor-madvise_inject_error.patch
mmhwpoison-kill-put_hwpoison_page.patch
mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
mmhwpoison-rework-soft-offline-for-free-pages.patch
mmhwpoison-rework-soft-offline-for-in-use-pages.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
mmhwpoison-try-to-narrow-window-race-for-free-pages.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch
mmhwpoison-remove-stale-code.patch

