Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 768CCC4363A
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3242F208E4
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816230;
	bh=NaomuDiN5gINp7ZzbHCGzRnks6cUuE24UcKN3Lt0A1o=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=exZYujL/4AwOim0o1smchkUUd0+mi562y0+iiQfVarOsjTAr3J5dtcDzXtkWMzg5p
	 ZEuek53y6ihpIh/W7MWj0IgA7HjabusFzxEGN7q4ohMwyZdkuYMcaZ3EXVEcr+QW8m
	 jl4CK9uoGeC34eNUZe/Ogqcp63dk3kZBIGwCgQAw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393828AbgJPCnt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:43:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393825AbgJPCnt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:43:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAA282145D;
        Fri, 16 Oct 2020 02:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816228;
        bh=NaomuDiN5gINp7ZzbHCGzRnks6cUuE24UcKN3Lt0A1o=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=eLIBff/T474Fm2H0K6I+OJWv1k9X/Y3PEw5eJQivDRfzMPM+oMLustXJh7+lWKay2
         jXp4VE1Ib35dRhFooB1VqTuRXrHfn1/96+VLwkV1pI7/BThE9/bGgQSvP4v48K+VYN
         yCV8VE0doDidGGbJPY+ywLShnXDUXYZueGnD0e34=
Date:   Thu, 15 Oct 2020 19:43:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, aris@ruivo.org, cai@lca.pw,
        dave.hansen@intel.com, david@redhat.com, linux-mm@kvack.org,
        mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.com, osalvador@suse.de, tony.luck@intel.com,
        torvalds@linux-foundation.org, zeil@yandex-team.ru
Subject:  [patch 047/156] mm,hwpoison: unify THP handling for hard
 and soft offline
Message-ID: <20201016024347.cXCVXGEuG%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: unify THP handling for hard and soft offline

Place the THP's page handling in a helper and use it from both hard and
soft-offline machinery, so we get rid of some duplicated code.

Link: https://lkml.kernel.org/r/20200922135650.1634-8-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Aristeu Rozanski <aris@ruivo.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
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
