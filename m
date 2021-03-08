Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 725DCC433DB
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 23:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E06E6521F
	for <mm-commits@archiver.kernel.org>; Mon,  8 Mar 2021 23:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbhCHXKk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 8 Mar 2021 18:10:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:34620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230342AbhCHXKC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Mar 2021 18:10:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD1C164FFD;
        Mon,  8 Mar 2021 23:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615245002;
        bh=nCpvzP5HaItK3wKq/eMufVKMVSR7hi2D+cmMUV9YHQo=;
        h=Date:From:To:Subject:From;
        b=aYbRAgX/NpX3OMd8IEhZ9txw/4HG3gyIUHnGbGgIuDv/0OsBbPsvkAENPocVAk4Oi
         1L0Q1ZBrv/Ijx2fh/Q7OEC3kGLY3Hyt8whEDTuNreoLQA4Lep+kYjrtzd58MZFa0Wp
         Dc4kw5RXZ6/ezsRVIxIXL2SbtE9Ic87PIwFoDdfA=
Date:   Mon, 08 Mar 2021 15:10:01 -0800
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.vnet.ibm.com, hughd@google.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.de, tony.luck@intel.com,
        willy@infradead.org
Subject:  + mm-hwpoison-enable-error-handling-on-shmem-thp.patch
 added to -mm tree
Message-ID: <20210308231001.Y5cUzgTzf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hwpoison: enable error handling on shmem thp
has been added to the -mm tree.  Its filename is
     mm-hwpoison-enable-error-handling-on-shmem-thp.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hwpoison-enable-error-handling-on-shmem-thp.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hwpoison-enable-error-handling-on-shmem-thp.patch

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
Subject: mm, hwpoison: enable error handling on shmem thp

Currently hwpoison code checks PageAnon() for thp and refuses to handle
errors on non-anonymous thps (just for historical reason).  We now support
non-anonymou thp like shmem one, so this patch suggests to enable to
handle shmem thps.  Fortunately, we already have can_split_huge_page() to
check if a give thp is splittable, so this patch relies on it.

Link: https://lkml.kernel.org/r/20210209062128.453814-1-nao.horiguchi@gmail.com
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   34 +++++++++-------------------------
 1 file changed, 9 insertions(+), 25 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-enable-error-handling-on-shmem-thp
+++ a/mm/memory-failure.c
@@ -959,20 +959,6 @@ static int __get_hwpoison_page(struct pa
 {
 	struct page *head = compound_head(page);
 
-	if (!PageHuge(head) && PageTransHuge(head)) {
-		/*
-		 * Non anonymous thp exists only in allocation/free time. We
-		 * can't handle such a case correctly, so let's give it up.
-		 * This should be better than triggering BUG_ON when kernel
-		 * tries to touch the "partially handled" page.
-		 */
-		if (!PageAnon(head)) {
-			pr_err("Memory failure: %#lx: non anonymous thp\n",
-				page_to_pfn(page));
-			return 0;
-		}
-	}
-
 	if (get_page_unless_zero(head)) {
 		if (head == compound_head(page))
 			return 1;
@@ -1200,21 +1186,19 @@ static int identify_page_state(unsigned
 
 static int try_to_split_thp_page(struct page *page, const char *msg)
 {
-	lock_page(page);
-	if (!PageAnon(page) || unlikely(split_huge_page(page))) {
-		unsigned long pfn = page_to_pfn(page);
+	struct page *head;
 
+	lock_page(page);
+	head = compound_head(page);
+	if (PageTransHuge(head) && can_split_huge_page(head, NULL) &&
+	    !split_huge_page(page)) {
 		unlock_page(page);
-		if (!PageAnon(page))
-			pr_info("%s: %#lx: non anonymous thp\n", msg, pfn);
-		else
-			pr_info("%s: %#lx: thp split failed\n", msg, pfn);
-		put_page(page);
-		return -EBUSY;
+		return 0;
 	}
+	pr_info("%s: %#lx: thp split failed\n", msg, page_to_pfn(page));
 	unlock_page(page);
-
-	return 0;
+	put_page(page);
+	return -EBUSY;
 }
 
 static int memory_failure_hugetlb(unsigned long pfn, int flags)
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-hwpoison-do-not-lock-page-again-when-me_huge_page-successfully-recovers.patch
mm-hwpoison-enable-error-handling-on-shmem-thp.patch

