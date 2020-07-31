Return-Path: <SRS0=f579=BK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE3BC433E0
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:06:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 009F422B43
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596225983;
	bh=qgJ0K4wnDmfPv/wyfGo4HFJYigN7x+CmQ3xpGIx2aU0=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Ukcc9EIpwVahE1CxqOc/duUhkJM4hAXq0nLFQNyEO+Nbd7FlIhr+F7fADFAPtDE3O
	 cqVDId9uSwdUH+XOU/iveG4r4IGGRYUbfjknIjC1HEacezkKCbR/9dm2/VLi4MYXl4
	 jJpLGnbfuHJtyDgz5+F0m3N86boRxBynAtlQ+Jx4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbgGaUGW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Jul 2020 16:06:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:47458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbgGaUGW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jul 2020 16:06:22 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D03122B42;
        Fri, 31 Jul 2020 20:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596225981;
        bh=qgJ0K4wnDmfPv/wyfGo4HFJYigN7x+CmQ3xpGIx2aU0=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=M2Jh7hiDtalGRpBq2NlWT1lqy+gcdeDLMLS1zZgeypy+VdMcqsb0Jw5yTu7D0JKL9
         z+25NgjlJHg2OK43tQC9DsdX18vFbvuG8DiEPZK52prJzM1wTcIhHwUwOlC20ypw8O
         zaB6K7KlsO1fDO3qzf+kq2zHWa/vwa2+dRvUumMo=
Date:   Fri, 31 Jul 2020 13:06:20 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aneesh.kumar@linux.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        cai@lca.pw, dave.hansen@intel.com, david@redhat.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        naoya.horiguchi@nec.com, osalvador@suse.com, osalvador@suse.de,
        tony.luck@intel.com, zeil@yandex-team.ru
Subject:  +
 mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
 added to -mm tree
Message-ID: <20200731200620.GLOa4Udo7%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: return 0 if the page is already poisoned in soft-offline
has been added to the -mm tree.  Its filename is
     mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch

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
Subject: mm,hwpoison: return 0 if the page is already poisoned in soft-offline

Currently, there is an inconsistency when calling soft-offline from
different paths on a page that is already poisoned.

1) madvise:

        madvise_inject_error skips any poisoned page and continues
        the loop.
        If that was the only page to madvise, it returns 0.

2) /sys/devices/system/memory/:

        When calling soft_offline_page_store()->soft_offline_page(),
        we return -EBUSY in case the page is already poisoned.
        This is inconsistent with a) the above example and b)
        memory_failure, where we return 0 if the page was poisoned.

Fix this by dropping the PageHWPoison() check in madvise_inject_error, and
let soft_offline_page return 0 if it finds the page already poisoned.

Please, note that this represents a user-api change, since now the return
error when calling soft_offline_page_store()->soft_offline_page() will be
different.

Link: http://lkml.kernel.org/r/20200731122112.11263-15-nao.horiguchi@gmail.com
Signed-off-by: Oscar Salvador <osalvador@suse.com>
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c        |    3 ---
 mm/memory-failure.c |    4 ++--
 2 files changed, 2 insertions(+), 5 deletions(-)

--- a/mm/madvise.c~mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline
+++ a/mm/madvise.c
@@ -902,9 +902,6 @@ static int madvise_inject_error(int beha
 		 */
 		put_page(page);
 
-		if (PageHWPoison(page))
-			continue;
-
 		if (behavior == MADV_SOFT_OFFLINE) {
 			pr_info("Soft offlining pfn %#lx at process virtual address %#lx\n",
 				pfn, start);
--- a/mm/memory-failure.c~mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline
+++ a/mm/memory-failure.c
@@ -1796,7 +1796,7 @@ static int __soft_offline_page(struct pa
 		unlock_page(page);
 		put_page(page);
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
-		return -EBUSY;
+		return 0;
 	}
 
 	if (!PageHuge(page))
@@ -1895,7 +1895,7 @@ int soft_offline_page(unsigned long pfn)
 
 	if (PageHWPoison(page)) {
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
-		return -EBUSY;
+		return 0;
 	}
 
 	get_online_mems();
_

Patches currently in -mm which might be from osalvador@suse.de are

mmmadvise-refactor-madvise_inject_error.patch
mmhwpoison-un-export-get_hwpoison_page-and-make-it-static.patch
mmhwpoison-kill-put_hwpoison_page.patch
mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
mmhwpoison-rework-soft-offline-for-free-pages.patch
mmhwpoison-rework-soft-offline-for-in-use-pages.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch

