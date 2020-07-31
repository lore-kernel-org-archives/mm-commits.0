Return-Path: <SRS0=f579=BK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8BC1C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:06:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E986208E4
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596225962;
	bh=ah1ryF73KeEAkRs49WewMk4kp0PZ9iVYtvU9y4K+rr8=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=NGjhjOb+pR6dIM58szuKtC2EiZ3DCYBO92cxMsuX2k3qWGO741bVxnFDBTaU+j8JS
	 AqwuF1ppsbUCEaFGodhDeTk72QEKsYcMylh4/avEvDR0Cm2VFEKGFeDnM8lBp7/F0L
	 kECI4v5wg6GS7rDjCwzJoYkQjhFf4S7OiSlUsUoM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgGaUGC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Jul 2020 16:06:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgGaUGC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jul 2020 16:06:02 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1FE322B43;
        Fri, 31 Jul 2020 20:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596225961;
        bh=ah1ryF73KeEAkRs49WewMk4kp0PZ9iVYtvU9y4K+rr8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=VyTTe0z2AnFsF6edlxvmzNfFPFMNE7h+4AdAFYxMHS889HheXjTSyEGYJNuFlWR6D
         Neu+8D/5Cfb3Y+LKmR6LVu27qIczDcZzxgOmqQiHn9q8+zveN/wbxxi1ciX7PW4VjY
         zYyIXQbW1pT2TP11bGmZTHicqPIhkNXtKu2pkFpU=
Date:   Fri, 31 Jul 2020 13:06:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aneesh.kumar@linux.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        cai@lca.pw, dave.hansen@intel.com, david@redhat.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        naoya.horiguchi@nec.com, osalvador@suse.com, osalvador@suse.de,
        tony.luck@intel.com, zeil@yandex-team.ru
Subject:  + mmhwpoison-remove-mf_count_increased.patch added to -mm
 tree
Message-ID: <20200731200600.BFUdCRSxL%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: remove MF_COUNT_INCREASED
has been added to the -mm tree.  Its filename is
     mmhwpoison-remove-mf_count_increased.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-remove-mf_count_increased.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-remove-mf_count_increased.patch

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
Subject: mm,hwpoison: remove MF_COUNT_INCREASED

Now there's no user of MF_COUNT_INCREASED, so we can safely remove it from
all calling points.

Link: http://lkml.kernel.org/r/20200731122112.11263-9-nao.horiguchi@gmail.com
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

 include/linux/mm.h  |    7 +++----
 mm/memory-failure.c |   14 +++-----------
 2 files changed, 6 insertions(+), 15 deletions(-)

--- a/include/linux/mm.h~mmhwpoison-remove-mf_count_increased
+++ a/include/linux/mm.h
@@ -2974,10 +2974,9 @@ void register_page_bootmem_memmap(unsign
 				  unsigned long nr_pages);
 
 enum mf_flags {
-	MF_COUNT_INCREASED = 1 << 0,
-	MF_ACTION_REQUIRED = 1 << 1,
-	MF_MUST_KILL = 1 << 2,
-	MF_SOFT_OFFLINE = 1 << 3,
+	MF_ACTION_REQUIRED = 1 << 0,
+	MF_MUST_KILL = 1 << 1,
+	MF_SOFT_OFFLINE = 1 << 2,
 };
 extern int memory_failure(unsigned long pfn, int flags);
 extern void memory_failure_queue(unsigned long pfn, int flags);
--- a/mm/memory-failure.c~mmhwpoison-remove-mf_count_increased
+++ a/mm/memory-failure.c
@@ -1118,7 +1118,7 @@ static int memory_failure_hugetlb(unsign
 
 	num_poisoned_pages_inc();
 
-	if (!(flags & MF_COUNT_INCREASED) && !get_hwpoison_page(p)) {
+	if (!get_hwpoison_page(p)) {
 		/*
 		 * Check "filter hit" and "race with other subpage."
 		 */
@@ -1314,7 +1314,7 @@ int memory_failure(unsigned long pfn, in
 	 * In fact it's dangerous to directly bump up page count from 0,
 	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
 	 */
-	if (!(flags & MF_COUNT_INCREASED) && !get_hwpoison_page(p)) {
+	if (!get_hwpoison_page(p)) {
 		if (is_free_buddy_page(p)) {
 			action_result(pfn, MF_MSG_BUDDY, MF_DELAYED);
 			return 0;
@@ -1354,10 +1354,7 @@ int memory_failure(unsigned long pfn, in
 	shake_page(p, 0);
 	/* shake_page could have turned it free. */
 	if (!PageLRU(p) && is_free_buddy_page(p)) {
-		if (flags & MF_COUNT_INCREASED)
-			action_result(pfn, MF_MSG_BUDDY, MF_DELAYED);
-		else
-			action_result(pfn, MF_MSG_BUDDY_2ND, MF_DELAYED);
+		action_result(pfn, MF_MSG_BUDDY_2ND, MF_DELAYED);
 		return 0;
 	}
 
@@ -1655,9 +1652,6 @@ static int __get_any_page(struct page *p
 {
 	int ret;
 
-	if (flags & MF_COUNT_INCREASED)
-		return 1;
-
 	/*
 	 * When the target page is a free hugepage, just remove it
 	 * from free hugepage list.
@@ -1933,8 +1927,6 @@ int soft_offline_page(unsigned long pfn,
 
 	if (PageHWPoison(page)) {
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
-		if (flags & MF_COUNT_INCREASED)
-			put_page(page);
 		return -EBUSY;
 	}
 
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

