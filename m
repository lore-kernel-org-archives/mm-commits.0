Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A67C43334
	for <mm-commits@archiver.kernel.org>; Sat,  2 Jul 2022 04:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbiGBEGQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 2 Jul 2022 00:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiGBEGP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 2 Jul 2022 00:06:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C332C106
        for <mm-commits@vger.kernel.org>; Fri,  1 Jul 2022 21:06:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A0D061D25
        for <mm-commits@vger.kernel.org>; Sat,  2 Jul 2022 04:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990A9C34114;
        Sat,  2 Jul 2022 04:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1656734772;
        bh=rhUhrUJv36dDI/a9W3VYcmknsHf9lFZtz3AO0VCK9SQ=;
        h=Date:To:From:Subject:From;
        b=LhcDiAI6eqbBYueY2+5IEHfL6nH53qNPUohD6bdaQ8pnP04ECk015roYm+bUMlvGm
         WXVOHsiifIKD9mVFqXF7e5f3YrsWdapTpGcJjWkrbDhkKSK8qkZbyamL6sJ5KqYC55
         Biv6lMS4VIvA3K6pNOVj9fDREm1ZaylDmUHjGa4w=
Date:   Fri, 01 Jul 2022 21:06:11 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, osalvador@suse.de, mike.kravetz@oracle.com,
        liushixin2@huawei.com, linmiaohe@huawei.com, david@redhat.com,
        naoya.horiguchi@nec.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-check-gigantic_page_runtime_supported-in-return_unused_surplus_pages.patch added to mm-unstable branch
Message-Id: <20220702040612.990A9C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: check gigantic_page_runtime_supported() in return_unused_surplus_pages()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-check-gigantic_page_runtime_supported-in-return_unused_surplus_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-check-gigantic_page_runtime_supported-in-return_unused_surplus_pages.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm/hugetlb: check gigantic_page_runtime_supported() in return_unused_surplus_pages()
Date: Thu, 30 Jun 2022 11:27:47 +0900

Patch series "mm, hwpoison: enable 1GB hugepage support", v3.


This patch (of 9):

I found a weird state of 1GB hugepage pool, caused by the following
procedure:

  - run a process reserving all free 1GB hugepages,
  - shrink free 1GB hugepage pool to zero (i.e. writing 0 to
    /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages), then
  - kill the reserving process.

, then all the hugepages are free *and* surplus at the same time.

  $ cat /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
  3
  $ cat /sys/kernel/mm/hugepages/hugepages-1048576kB/free_hugepages
  3
  $ cat /sys/kernel/mm/hugepages/hugepages-1048576kB/resv_hugepages
  0
  $ cat /sys/kernel/mm/hugepages/hugepages-1048576kB/surplus_hugepages
  3

This state is resolved by reserving and allocating the pages then freeing
them again, so this seems not to result in serious problem.  But it's a
little surprising (shrinking pool suddenly fails).

This behavior is caused by hstate_is_gigantic() check in
return_unused_surplus_pages().  This was introduced so long ago in 2008 by
commit aa888a74977a ("hugetlb: support larger than MAX_ORDER"), and at
that time the gigantic pages were not supposed to be allocated/freed at
run-time.  Now kernel can support runtime allocation/free, so let's check
gigantic_page_runtime_supported() together.

Link: https://lkml.kernel.org/r/20220630022755.3362349-1-naoya.horiguchi@linux.dev
Link: https://lkml.kernel.org/r/20220630022755.3362349-2-naoya.horiguchi@linux.dev
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-check-gigantic_page_runtime_supported-in-return_unused_surplus_pages
+++ a/mm/hugetlb.c
@@ -2432,8 +2432,7 @@ static void return_unused_surplus_pages(
 	/* Uncommit the reservation */
 	h->resv_huge_pages -= unused_resv_pages;
 
-	/* Cannot return gigantic pages currently */
-	if (hstate_is_gigantic(h))
+	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported())
 		goto out;
 
 	/*
@@ -3315,7 +3314,8 @@ static int set_max_huge_pages(struct hst
 	 * the user tries to allocate gigantic pages but let the user free the
 	 * boottime allocated gigantic pages.
 	 */
-	if (hstate_is_gigantic(h) && !IS_ENABLED(CONFIG_CONTIG_ALLOC)) {
+	if (hstate_is_gigantic(h) && (!IS_ENABLED(CONFIG_CONTIG_ALLOC) ||
+				      !gigantic_page_runtime_supported())) {
 		if (count > persistent_huge_pages(h)) {
 			spin_unlock_irq(&hugetlb_lock);
 			mutex_unlock(&h->resize_lock);
@@ -3364,6 +3364,19 @@ static int set_max_huge_pages(struct hst
 	}
 
 	/*
+	 * We can not decrease gigantic pool size if runtime modification
+	 * is not supported.
+	 */
+	if (hstate_is_gigantic(h) && !gigantic_page_runtime_supported()) {
+		if (count < persistent_huge_pages(h)) {
+			spin_unlock_irq(&hugetlb_lock);
+			mutex_unlock(&h->resize_lock);
+			NODEMASK_FREE(node_alloc_noretry);
+			return -EINVAL;
+		}
+	}
+
+	/*
 	 * Decrease the pool size
 	 * First return free pages to the buddy allocator (being careful
 	 * to keep enough around to satisfy reservations).  Then place
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mm-hugetlb-check-gigantic_page_runtime_supported-in-return_unused_surplus_pages.patch
mm-hugetlb-separate-path-for-hwpoison-entry-in-copy_hugetlb_page_range.patch
mm-hugetlb-make-pud_huge-and-follow_huge_pud-aware-of-non-present-pud-entry.patch
mm-hwpoison-hugetlb-support-saving-mechanism-of-raw-error-pages.patch
mm-hwpoison-make-unpoison-aware-of-raw-error-info-in-hwpoisoned-hugepage.patch
mm-hwpoison-set-pg_hwpoison-for-busy-hugetlb-pages.patch
mm-hwpoison-make-__page_handle_poison-returns-int.patch
mm-hwpoison-skip-raw-hwpoison-page-in-freeing-1gb-hugepage.patch
mm-hwpoison-enable-memory-error-handling-on-1gb-hugepage.patch

