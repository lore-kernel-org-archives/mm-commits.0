Return-Path: <SRS0=f579=BK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D229EC433DF
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE7DC22B42
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596225966;
	bh=pk5H6W0Gm64L+g3SrlwDn5ysuDAR1x3lAZ/+72gGe4I=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=WlkQo4AeG3Qe9hqkZqiq4Kj7nFxquET21EHsYJ2Y5LnqXXlmnkUwcNSCSdk8QEknz
	 OMJI3eg1eXAD5aoNceZZC6gDwVxZLfQAXMOVnfODkBmj88//fbx3zGrxlVdG7cKfcH
	 W5Hhj1o/2YB2Wk2V3OJfbW5nA0/6P3XZq5FOJUYw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgGaUGG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Jul 2020 16:06:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgGaUGG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jul 2020 16:06:06 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74E7D208E4;
        Fri, 31 Jul 2020 20:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596225965;
        bh=pk5H6W0Gm64L+g3SrlwDn5ysuDAR1x3lAZ/+72gGe4I=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=kNF8o1soDigaiV/ZiLFU/JZ3boj68F5Cd2SmyqNZYQJnwQp0JU5bks20lmrKw45K0
         b7NFb0jZ9ZnRwY8EdJpeelf3OvyU8XaXtu9iS70B6EiGjuStbXRgls5ZY8yp4/Y4X3
         ClvT3bGC7uBG62PRR70dbAsrjf5tjNAkJFLwlizg=
Date:   Fri, 31 Jul 2020 13:06:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aneesh.kumar@linux.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        cai@lca.pw, dave.hansen@intel.com, david@redhat.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        naoya.horiguchi@nec.com, osalvador@suse.com, osalvador@suse.de,
        tony.luck@intel.com, zeil@yandex-team.ru
Subject:  +
 mmhwpoison-remove-flag-argument-from-soft-offline-functions.patch added to
 -mm tree
Message-ID: <20200731200603.t_QAtuvIn%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: remove flag argument from soft offline functions
has been added to the -mm tree.  Its filename is
     mmhwpoison-remove-flag-argument-from-soft-offline-functions.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-remove-flag-argument-from-soft-offline-functions.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-remove-flag-argument-from-soft-offline-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm,hwpoison: remove flag argument from soft offline functions

The argument @flag no longer affects the behavior of soft_offline_page()
and its variants, so let's remove them.

Link: http://lkml.kernel.org/r/20200731122112.11263-10-nao.horiguchi@gmail.com
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |    2 +-
 include/linux/mm.h    |    2 +-
 mm/madvise.c          |    2 +-
 mm/memory-failure.c   |   27 +++++++++++++--------------
 4 files changed, 16 insertions(+), 17 deletions(-)

--- a/drivers/base/memory.c~mmhwpoison-remove-flag-argument-from-soft-offline-functions
+++ a/drivers/base/memory.c
@@ -463,7 +463,7 @@ static ssize_t soft_offline_page_store(s
 	if (kstrtoull(buf, 0, &pfn) < 0)
 		return -EINVAL;
 	pfn >>= PAGE_SHIFT;
-	ret = soft_offline_page(pfn, 0);
+	ret = soft_offline_page(pfn);
 	return ret == 0 ? count : ret;
 }
 
--- a/include/linux/mm.h~mmhwpoison-remove-flag-argument-from-soft-offline-functions
+++ a/include/linux/mm.h
@@ -2986,7 +2986,7 @@ extern int sysctl_memory_failure_early_k
 extern int sysctl_memory_failure_recovery;
 extern void shake_page(struct page *p, int access);
 extern atomic_long_t num_poisoned_pages __read_mostly;
-extern int soft_offline_page(unsigned long pfn, int flags);
+extern int soft_offline_page(unsigned long pfn);
 
 
 /*
--- a/mm/madvise.c~mmhwpoison-remove-flag-argument-from-soft-offline-functions
+++ a/mm/madvise.c
@@ -908,7 +908,7 @@ static int madvise_inject_error(int beha
 		if (behavior == MADV_SOFT_OFFLINE) {
 			pr_info("Soft offlining pfn %#lx at process virtual address %#lx\n",
 				pfn, start);
-			ret = soft_offline_page(pfn, 0);
+			ret = soft_offline_page(pfn);
 		} else {
 			pr_info("Injecting memory failure for pfn %#lx at process virtual address %#lx\n",
 				pfn, start);
--- a/mm/memory-failure.c~mmhwpoison-remove-flag-argument-from-soft-offline-functions
+++ a/mm/memory-failure.c
@@ -1502,7 +1502,7 @@ static void memory_failure_work_func(str
 		if (!gotten)
 			break;
 		if (entry.flags & MF_SOFT_OFFLINE)
-			soft_offline_page(entry.pfn, entry.flags);
+			soft_offline_page(entry.pfn);
 		else
 			memory_failure(entry.pfn, entry.flags);
 	}
@@ -1648,7 +1648,7 @@ static struct page *new_page(struct page
  * that is not free, and 1 for any other page type.
  * For 1 the page is returned with increased page count, otherwise not.
  */
-static int __get_any_page(struct page *p, unsigned long pfn, int flags)
+static int __get_any_page(struct page *p, unsigned long pfn)
 {
 	int ret;
 
@@ -1675,9 +1675,9 @@ static int __get_any_page(struct page *p
 	return ret;
 }
 
-static int get_any_page(struct page *page, unsigned long pfn, int flags)
+static int get_any_page(struct page *page, unsigned long pfn)
 {
-	int ret = __get_any_page(page, pfn, flags);
+	int ret = __get_any_page(page, pfn);
 
 	if (ret == 1 && !PageHuge(page) &&
 	    !PageLRU(page) && !__PageMovable(page)) {
@@ -1690,7 +1690,7 @@ static int get_any_page(struct page *pag
 		/*
 		 * Did it turn free?
 		 */
-		ret = __get_any_page(page, pfn, 0);
+		ret = __get_any_page(page, pfn);
 		if (ret == 1 && !PageLRU(page)) {
 			/* Drop page reference which is from __get_any_page() */
 			put_page(page);
@@ -1702,7 +1702,7 @@ static int get_any_page(struct page *pag
 	return ret;
 }
 
-static int soft_offline_huge_page(struct page *page, int flags)
+static int soft_offline_huge_page(struct page *page)
 {
 	int ret;
 	unsigned long pfn = page_to_pfn(page);
@@ -1761,7 +1761,7 @@ static int soft_offline_huge_page(struct
 	return ret;
 }
 
-static int __soft_offline_page(struct page *page, int flags)
+static int __soft_offline_page(struct page *page)
 {
 	int ret;
 	unsigned long pfn = page_to_pfn(page);
@@ -1841,7 +1841,7 @@ static int __soft_offline_page(struct pa
 	return ret;
 }
 
-static int soft_offline_in_use_page(struct page *page, int flags)
+static int soft_offline_in_use_page(struct page *page)
 {
 	int ret;
 	int mt;
@@ -1871,9 +1871,9 @@ static int soft_offline_in_use_page(stru
 	mt = get_pageblock_migratetype(page);
 	set_pageblock_migratetype(page, MIGRATE_ISOLATE);
 	if (PageHuge(page))
-		ret = soft_offline_huge_page(page, flags);
+		ret = soft_offline_huge_page(page);
 	else
-		ret = __soft_offline_page(page, flags);
+		ret = __soft_offline_page(page);
 	set_pageblock_migratetype(page, mt);
 	return ret;
 }
@@ -1894,7 +1894,6 @@ static int soft_offline_free_page(struct
 /**
  * soft_offline_page - Soft offline a page.
  * @pfn: pfn to soft-offline
- * @flags: flags. Same as memory_failure().
  *
  * Returns 0 on success, otherwise negated errno.
  *
@@ -1913,7 +1912,7 @@ static int soft_offline_free_page(struct
  * This is not a 100% solution for all memory, but tries to be
  * ``good enough'' for the majority of memory.
  */
-int soft_offline_page(unsigned long pfn, int flags)
+int soft_offline_page(unsigned long pfn)
 {
 	int ret;
 	struct page *page;
@@ -1931,11 +1930,11 @@ int soft_offline_page(unsigned long pfn,
 	}
 
 	get_online_mems();
-	ret = get_any_page(page, pfn, flags);
+	ret = get_any_page(page, pfn);
 	put_online_mems();
 
 	if (ret > 0)
-		ret = soft_offline_in_use_page(page, flags);
+		ret = soft_offline_in_use_page(page);
 	else if (ret == 0)
 		ret = soft_offline_free_page(page);
 
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mmhwpoison-cleanup-unused-pagehuge-check.patch
mm-hwpoison-remove-recalculating-hpage.patch
mmmadvise-call-soft_offline_page-without-mf_count_increased.patch
mmhwpoison-inject-dont-pin-for-hwpoison_filter.patch
mmhwpoison-remove-mf_count_increased.patch
mmhwpoison-remove-flag-argument-from-soft-offline-functions.patch
mmhwpoison-introduce-mf_msg_unsplit_thp.patch
mmhwpoison-double-check-page-count-in-__get_any_page.patch

