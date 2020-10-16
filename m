Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9176EC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C04A2087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 02:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602816226;
	bh=2/DyiSe1T9wjjgEyPlLATbt+W+ETT2ZfeBVRNp7csUQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=fqCTeWkNUviOnkwKzP0LYc6XulsecwpnJG9fR2Dj7Bc0RhZlgV2q2BMfYlhv08fGZ
	 wERHWdKIHYpN1lnH6EwXeo0gcNj0/8Nfjn2BXwxd8SFXK7zeBXVep9+XSJhaDsNWRC
	 GjBsZBB6IIQzTPvBleQeLO+PPVGqMUrCoNmcCiu0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393827AbgJPCnq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 22:43:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:59170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732984AbgJPCnp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 22:43:45 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEE0C208C7;
        Fri, 16 Oct 2020 02:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602816224;
        bh=2/DyiSe1T9wjjgEyPlLATbt+W+ETT2ZfeBVRNp7csUQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=sEzGAwXrnP/XJTDRJLBASG4iTCOhFAR37uucdT4UmZs/hK29oFMoLA21MsouEQOiw
         729e0XCfcTEHPu7UBSdmJ3RSrmzQm2RZIDk8ySfmp36hrpu3yCUjy7oE6q7tI/M0Bw
         pEgciLor6D2PaykMd5ZMXmAys1M9km8JlgOwuDG4=
Date:   Thu, 15 Oct 2020 19:43:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, aris@ruivo.org, cai@lca.pw,
        dave.hansen@intel.com, david@redhat.com, linux-mm@kvack.org,
        mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.com, osalvador@suse.de, tony.luck@intel.com,
        torvalds@linux-foundation.org, zeil@yandex-team.ru
Subject:  [patch 046/156] mm,hwpoison: kill put_hwpoison_page
Message-ID: <20201016024343.DA8PFosum%akpm@linux-foundation.org>
In-Reply-To: <20201015192732.f448da14e9854c7cb7299956@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: kill put_hwpoison_page

After commit 4e41a30c6d50 ("mm: hwpoison: adjust for new thp
refcounting"), put_hwpoison_page got reduced to a put_page.  Let us just
use put_page instead.

Link: https://lkml.kernel.org/r/20200922135650.1634-7-osalvador@suse.de
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

 include/linux/mm.h  |    1 -
 mm/memory-failure.c |   30 +++++++++++++++---------------
 2 files changed, 15 insertions(+), 16 deletions(-)

--- a/include/linux/mm.h~mmhwpoison-kill-put_hwpoison_page
+++ a/include/linux/mm.h
@@ -3025,7 +3025,6 @@ extern int memory_failure(unsigned long
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
