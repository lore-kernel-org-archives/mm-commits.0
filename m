Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F212C433DF
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 01:07:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96E2621744
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 01:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596762430;
	bh=RzIZf5Oy9FiCbIql0TptJJGV8uR17aqZrxqfrgvBPms=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=SZM2YlDUNPRoj47ancuhdtEGq96s/Iq5RaQ+PrENOCxowE3uXOiORTk1LhVdx96Q6
	 SLk3Stz2TPVJLF0vvqcKXcEM+nrUMtcXn7K6hlKBNxU+u+uCFGSXTGZvQ98Y8KJTbE
	 4BhoGQpQHcV8oMTWjz49fxMdNdkUzyP4jdu6FRsQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgHGBHK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 Aug 2020 21:07:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:40212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbgHGBHJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 Aug 2020 21:07:09 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 123922177B;
        Fri,  7 Aug 2020 01:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596762428;
        bh=RzIZf5Oy9FiCbIql0TptJJGV8uR17aqZrxqfrgvBPms=;
        h=Date:From:To:Subject:From;
        b=pEUPw76iItEF1rE6Zz+p7uyvbO/3JeBw+4TaSqPgXE04uWswfo/bhpxrVE29sy/n0
         C0XrNNKSYrXKe9gGvjxBDIxpDgR5TdXtdK5pHdZ4ZmR9fjMJGV937Kk9LzK3n5Jf8t
         IqQhIF0R5FqnMoUIW8XexOFZ1fNdml7jovyKE4lc=
Date:   Thu, 06 Aug 2020 18:07:07 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        cai@lca.pw, dave.hansen@intel.com, david@redhat.com,
        mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.com, osalvador@suse.de, tony.luck@intel.com,
        zeil@yandex-team.ru
Subject:  +
 mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch added to -mm
 tree
Message-ID: <20200807010707.O7o403QD2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: unify THP handling for hard and soft offline
has been added to the -mm tree.  Its filename is
     mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch

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

Link: http://lkml.kernel.org/r/20200806184923.7007-7-nao.horiguchi@gmail.com
Signed-off-by: Oscar Salvador <osalvador@suse.com>
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   48 +++++++++++++++++++-----------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

--- a/mm/memory-failure.c~mmhwpoison-unify-thp-handling-for-hard-and-soft-offline
+++ a/mm/memory-failure.c
@@ -1103,6 +1103,25 @@ static int identify_page_state(unsigned
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
@@ -1325,21 +1344,8 @@ int memory_failure(unsigned long pfn, in
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
 
@@ -1853,19 +1859,9 @@ static int soft_offline_in_use_page(stru
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

mmhwpoison-un-export-get_hwpoison_page-and-make-it-static.patch
mmhwpoison-kill-put_hwpoison_page.patch
mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
mmhwpoison-rework-soft-offline-for-free-pages.patch
mmhwpoison-rework-soft-offline-for-in-use-pages.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch

