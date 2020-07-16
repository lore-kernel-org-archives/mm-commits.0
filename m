Return-Path: <SRS0=YRC/=A3=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE9B6C433DF
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 21:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A29B4207DD
	for <mm-commits@archiver.kernel.org>; Thu, 16 Jul 2020 21:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594935954;
	bh=oFVQ+bJLEs6MvC4TCi+4dujRvCcG+MrXQ7OzpcrdzJI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=XKTcVt6BNyJ4llfpWX42wfgOxw3OX0Du7HsWV+fUkvncFtJg2eiPsmU7bSkBufySC
	 eGDPRUlr+ghGb/tviP5b7rw7NQpHMK7pH2EOMSSVEhSLrerv52RmekZwbOzCKn7erj
	 SkNBDsnvfuhQCdrAY8GCmAAjMViwVDjDx5mW+vbk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgGPVpy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jul 2020 17:45:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbgGPVpy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Jul 2020 17:45:54 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3F3320809;
        Thu, 16 Jul 2020 21:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594935953;
        bh=oFVQ+bJLEs6MvC4TCi+4dujRvCcG+MrXQ7OzpcrdzJI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YrYb2arR4KmQvTrzpvz2tzMrXNkOM/1dNz/c3EY/qGIAHkjofkK7a4UifztVbayN6
         pqVF9zs40cDcvEQvPVRnxnBpqF8pVeUM4/k/IX4te7xNvOByJpGnSGZEsruvOXE/tI
         fG7yNpxWbXbyYnj/mMmvfjsUz9OBrojuxunJpiQE=
Date:   Thu, 16 Jul 2020 14:45:52 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aneesh.kumar@linux.vnet.ibm.com, dave.hansen@intel.com,
        david@redhat.com, mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        naoya.horiguchi@nec.com, osalvador@suse.com, tony.luck@intel.com,
        zeil@yandex-team.ru
Subject:  +
 mmmadvise-call-soft_offline_page-without-mf_count_increased.patch added to
 -mm tree
Message-ID: <20200716214552.nkyXHoqas%akpm@linux-foundation.org>
In-Reply-To: <20200703151445.b6a0cfee402c7c5c4651f1b1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,madvise: call soft_offline_page() without MF_COUNT_INCREASED
has been added to the -mm tree.  Its filename is
     mmmadvise-call-soft_offline_page-without-mf_count_increased.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmmadvise-call-soft_offline_page-without-mf_count_increased.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmmadvise-call-soft_offline_page-without-mf_count_increased.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: mm,madvise: call soft_offline_page() without MF_COUNT_INCREASED

The call to get_user_pages_fast is only to get the pointer to a struct
page of a given address, pinning it is memory-poisoning handler's job, so
drop the refcount grabbed by get_user_pages_fast

Link: http://lkml.kernel.org/r/20200716123810.25292-4-osalvador@suse.de
Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Oscar Salvador <osalvador@suse.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/mm/madvise.c~mmmadvise-call-soft_offline_page-without-mf_count_increased
+++ a/mm/madvise.c
@@ -893,16 +893,24 @@ static int madvise_inject_error(int beha
 		 */
 		size = page_size(compound_head(page));
 
-		if (PageHWPoison(page)) {
-			put_page(page);
+		/*
+		 * The get_user_pages_fast() is just to get the pfn of the
+		 * given address, and the refcount has nothing to do with
+		 * what we try to test, so it should be released immediately.
+		 * This is racy but it's intended because the real hardware
+		 * errors could happen at any moment and memory error handlers
+		 * must properly handle the race.
+		 */
+		put_page(page);
+
+		if (PageHWPoison(page))
 			continue;
-		}
 
 		if (behavior == MADV_SOFT_OFFLINE) {
 			pr_info("Soft offlining pfn %#lx at process virtual address %#lx\n",
 					pfn, start);
 
-			ret = soft_offline_page(pfn, MF_COUNT_INCREASED);
+			ret = soft_offline_page(pfn, 0);
 			if (ret)
 				return ret;
 			continue;
@@ -910,14 +918,6 @@ static int madvise_inject_error(int beha
 
 		pr_info("Injecting memory failure for pfn %#lx at process virtual address %#lx\n",
 				pfn, start);
-
-		/*
-		 * Drop the page reference taken by get_user_pages_fast(). In
-		 * the absence of MF_COUNT_INCREASED the memory_failure()
-		 * routine is responsible for pinning the page to prevent it
-		 * from being released back to the page allocator.
-		 */
-		put_page(page);
 		ret = memory_failure(pfn, 0);
 		if (ret)
 			return ret;
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mmhwpoison-cleanup-unused-pagehuge-check.patch
mmmadvise-call-soft_offline_page-without-mf_count_increased.patch
mmhwpoison-inject-dont-pin-for-hwpoison_filter.patch
mmhwpoison-remove-mf_count_increased.patch
mmhwpoison-remove-flag-argument-from-soft-offline-functions.patch

