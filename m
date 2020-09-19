Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE079C43464
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:24:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC8C021D7F
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600475061;
	bh=4kGAcx1WQesEV/cufJgd25n3JDZmLSLz9nk+WG43mv8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=QcsLzdjCcaVPjJ828xz06+ii7paSoORGKJGnA735nyptU9PSx5gLdI2b82IKRkZ4a
	 LEnTQDMIDwQqZkpwo+OAfal1yHIbeBbdED1vghX9MSjfXm1uPMSmcay3IgEpybWuI5
	 PO8Beu2+W27yX1o98xBWgc1Qb5fW6/xEWq8AVXtA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgISAYV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 20:24:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISAYV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 20:24:21 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEA6421D43;
        Sat, 19 Sep 2020 00:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600475060;
        bh=4kGAcx1WQesEV/cufJgd25n3JDZmLSLz9nk+WG43mv8=;
        h=Date:From:To:Subject:From;
        b=JnArd973eR2ZPQapMyfZz2UxbJEpJuNgkD8uGnz9uxgwxO54XFJcaXEri69cxqMoo
         b0VHNUEi76oeiqDg4UeRPQVR0gCx/T9z8AEt3YBk4f5RN3kJdTMOTGAHLFhV8lcp55
         5tX/0ebMpyp/5Q0BdLqYPJ+R0OvVsJPpPYDws1rc=
Date:   Fri, 18 Sep 2020 17:24:19 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zeil@yandex-team.ru,
        tony.luck@intel.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, mhocko@kernel.org, david@redhat.com,
        dave.hansen@intel.com, cai@lca.pw, aneesh.kumar@linux.vnet.ibm.com,
        aneesh.kumar@linux.ibm.com, osalvador@suse.de
Subject:  [to-be-updated] mmhwpoison-kill-put_hwpoison_page.patch
 removed from -mm tree
Message-ID: <20200919002419.NMHj5%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: kill put_hwpoison_page
has been removed from the -mm tree.  Its filename was
     mmhwpoison-kill-put_hwpoison_page.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: kill put_hwpoison_page

After commit 4e41a30c6d50 ("mm: hwpoison: adjust for new thp
refcounting"), put_hwpoison_page got reduced to a put_page.  Let us just
use put_page instead.

Link: http://lkml.kernel.org/r/20200806184923.7007-6-nao.horiguchi@gmail.com
Signed-off-by: Oscar Salvador <osalvador@suse.de>
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

 include/linux/mm.h  |    1 -
 mm/memory-failure.c |   30 +++++++++++++++---------------
 2 files changed, 15 insertions(+), 16 deletions(-)

--- a/include/linux/mm.h~mmhwpoison-kill-put_hwpoison_page
+++ a/include/linux/mm.h
@@ -3015,7 +3015,6 @@ extern int memory_failure(unsigned long
 extern void memory_failure_queue(unsigned long pfn, int flags);
 extern void memory_failure_queue_kick(int cpu);
 extern int unpoison_memory(unsigned long pfn);
-#define put_hwpoison_page(page)	put_page(page)
 extern int sysctl_memory_failure_early_kill;
 extern int sysctl_memory_failure_recovery;
 extern void shake_page(struct page *p, int access);
--- a/mm/memory-failure.c~mmhwpoison-kill-put_hwpoison_page
+++ a/mm/memory-failure.c
@@ -1143,7 +1143,7 @@ static int memory_failure_hugetlb(unsign
 		pr_err("Memory failure: %#lx: just unpoisoned\n", pfn);
 		num_poisoned_pages_dec();
 		unlock_page(head);
-		put_hwpoison_page(head);
+		put_page(head);
 		return 0;
 	}
 
@@ -1335,7 +1335,7 @@ int memory_failure(unsigned long pfn, in
 					pfn);
 			if (TestClearPageHWPoison(p))
 				num_poisoned_pages_dec();
-			put_hwpoison_page(p);
+			put_page(p);
 			return -EBUSY;
 		}
 		unlock_page(p);
@@ -1388,14 +1388,14 @@ int memory_failure(unsigned long pfn, in
 		pr_err("Memory failure: %#lx: just unpoisoned\n", pfn);
 		num_poisoned_pages_dec();
 		unlock_page(p);
-		put_hwpoison_page(p);
+		put_page(p);
 		return 0;
 	}
 	if (hwpoison_filter(p)) {
 		if (TestClearPageHWPoison(p))
 			num_poisoned_pages_dec();
 		unlock_page(p);
-		put_hwpoison_page(p);
+		put_page(p);
 		return 0;
 	}
 
@@ -1629,9 +1629,9 @@ int unpoison_memory(unsigned long pfn)
 	}
 	unlock_page(page);
 
-	put_hwpoison_page(page);
+	put_page(page);
 	if (freeit && !(pfn == my_zero_pfn(0) && page_count(p) == 1))
-		put_hwpoison_page(page);
+		put_page(page);
 
 	return 0;
 }
@@ -1692,7 +1692,7 @@ static int get_any_page(struct page *pag
 		/*
 		 * Try to free it.
 		 */
-		put_hwpoison_page(page);
+		put_page(page);
 		shake_page(page, 1);
 
 		/*
@@ -1701,7 +1701,7 @@ static int get_any_page(struct page *pag
 		ret = __get_any_page(page, pfn, 0);
 		if (ret == 1 && !PageLRU(page)) {
 			/* Drop page reference which is from __get_any_page() */
-			put_hwpoison_page(page);
+			put_page(page);
 			pr_info("soft_offline: %#lx: unknown non LRU page type %lx (%pGp)\n",
 				pfn, page->flags, &page->flags);
 			return -EIO;
@@ -1724,7 +1724,7 @@ static int soft_offline_huge_page(struct
 	lock_page(hpage);
 	if (PageHWPoison(hpage)) {
 		unlock_page(hpage);
-		put_hwpoison_page(hpage);
+		put_page(hpage);
 		pr_info("soft offline: %#lx hugepage already poisoned\n", pfn);
 		return -EBUSY;
 	}
@@ -1735,7 +1735,7 @@ static int soft_offline_huge_page(struct
 	 * get_any_page() and isolate_huge_page() takes a refcount each,
 	 * so need to drop one here.
 	 */
-	put_hwpoison_page(hpage);
+	put_page(hpage);
 	if (!ret) {
 		pr_info("soft offline: %#lx hugepage failed to isolate\n", pfn);
 		return -EBUSY;
@@ -1784,7 +1784,7 @@ static int __soft_offline_page(struct pa
 	wait_on_page_writeback(page);
 	if (PageHWPoison(page)) {
 		unlock_page(page);
-		put_hwpoison_page(page);
+		put_page(page);
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
 		return -EBUSY;
 	}
@@ -1799,7 +1799,7 @@ static int __soft_offline_page(struct pa
 	 * would need to fix isolation locking first.
 	 */
 	if (ret == 1) {
-		put_hwpoison_page(page);
+		put_page(page);
 		pr_info("soft_offline: %#lx: invalidated\n", pfn);
 		SetPageHWPoison(page);
 		num_poisoned_pages_inc();
@@ -1819,7 +1819,7 @@ static int __soft_offline_page(struct pa
 	 * Drop page reference which is came from get_any_page()
 	 * successful isolate_lru_page() already took another one.
 	 */
-	put_hwpoison_page(page);
+	put_page(page);
 	if (!ret) {
 		LIST_HEAD(pagelist);
 		/*
@@ -1863,7 +1863,7 @@ static int soft_offline_in_use_page(stru
 				pr_info("soft offline: %#lx: non anonymous thp\n", page_to_pfn(page));
 			else
 				pr_info("soft offline: %#lx: thp split failed\n", page_to_pfn(page));
-			put_hwpoison_page(page);
+			put_page(page);
 			return -EBUSY;
 		}
 		unlock_page(page);
@@ -1936,7 +1936,7 @@ int soft_offline_page(unsigned long pfn,
 	if (PageHWPoison(page)) {
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
 		if (flags & MF_COUNT_INCREASED)
-			put_hwpoison_page(page);
+			put_page(page);
 		return -EBUSY;
 	}
 
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
mmhwpoison-rework-soft-offline-for-free-pages.patch
mmhwpoison-rework-soft-offline-for-in-use-pages.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
mmhwpoison-refactor-madvise_inject_error.patch
mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch
mmhwpoison-remove-stale-code.patch

