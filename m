Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFCD1C4363D
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:00:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82BEC23A34
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600794041;
	bh=iSMSqB+GWIh7ZpV1xDbeA/Vqh+G1QW/MiQi/XWqannY=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=pHB3j/SAkIChUwFVmcq998cyLytcAbj4ymjvZGjvjlIj6ysGMs+TZXmVoLpnt1PAJ
	 RjEqUMAFM+/yDlM+80WiYp/lNgRBCGob24kwbqsfsPUcPZOKmFVZak0TVOpP/mRbm0
	 1nKqIUh/spKFk8d5N7gy0Hw5PJWtd8+VkJymVFpA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgIVRAl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 13:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbgIVRAl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 13:00:41 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8A8A20888;
        Tue, 22 Sep 2020 17:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600794040;
        bh=iSMSqB+GWIh7ZpV1xDbeA/Vqh+G1QW/MiQi/XWqannY=;
        h=Date:From:To:Subject:From;
        b=vEoKvvlJnYsEJcBmB4Zdo9D0oL3S8dR4hNEVT5yhDB4mX0Uf+xCF8O1rExS+B+EHa
         7npQxFJgChQ4G8NL+KJgXBN0zRbiPAjdkyJE7Ijex2E0/WS5KCeHumEQUk2DWpIFds
         a5msm1xigB0U0UgmRrOSn7krFGJOkXQVCHIWHuTw=
Date:   Tue, 22 Sep 2020 10:00:39 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zeil@yandex-team.ru,
        tony.luck@intel.com, osalvador@suse.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, mhocko@kernel.org, david@redhat.com,
        dave.hansen@intel.com, cai@lca.pw, aris@ruivo.org,
        aneesh.kumar@linux.vnet.ibm.com, aneesh.kumar@linux.ibm.com,
        osalvador@suse.de
Subject:  +
 mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
 added to -mm tree
Message-ID: <20200922170039.hPGU8%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: return 0 if the page is already poisoned in soft-offline
has been added to the -mm tree.  Its filename is
     mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch

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

Link: https://lkml.kernel.org/r/20200922135650.1634-12-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Aristeu Rozanski <aris@ruivo.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c        |    5 -----
 mm/memory-failure.c |    4 ++--
 2 files changed, 2 insertions(+), 7 deletions(-)

--- a/mm/madvise.c~mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline
+++ a/mm/madvise.c
@@ -896,11 +896,6 @@ static int madvise_inject_error(int beha
 		 */
 		size = page_size(compound_head(page));
 
-		if (PageHWPoison(page)) {
-			put_page(page);
-			continue;
-		}
-
 		if (behavior == MADV_SOFT_OFFLINE) {
 			pr_info("Soft offlining pfn %#lx at process virtual address %#lx\n",
 				 pfn, start);
--- a/mm/memory-failure.c~mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline
+++ a/mm/memory-failure.c
@@ -1802,7 +1802,7 @@ static int __soft_offline_page(struct pa
 		unlock_page(page);
 		put_page(page);
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
-		return -EBUSY;
+		return 0;
 	}
 
 	if (!PageHuge(page))
@@ -1906,7 +1906,7 @@ int soft_offline_page(unsigned long pfn,
 		pr_info("soft offline: %#lx page already poisoned\n", pfn);
 		if (flags & MF_COUNT_INCREASED)
 			put_page(page);
-		return -EBUSY;
+		return 0;
 	}
 
 	get_online_mems();
_

Patches currently in -mm which might be from osalvador@suse.de are

mmhwpoison-unexport-get_hwpoison_page-and-make-it-static.patch
mmhwpoison-refactor-madvise_inject_error.patch
mmhwpoison-kill-put_hwpoison_page.patch
mmhwpoison-unify-thp-handling-for-hard-and-soft-offline.patch
mmhwpoison-rework-soft-offline-for-free-pages.patch
mmhwpoison-rework-soft-offline-for-in-use-pages.patch
mmhwpoison-refactor-soft_offline_huge_page-and-__soft_offline_page.patch
mmhwpoison-return-0-if-the-page-is-already-poisoned-in-soft-offline.patch
mmhwpoison-try-to-narrow-window-race-for-free-pages.patch
mmhwpoison-take-free-pages-off-the-buddy-freelists.patch
mmhwpoison-drain-pcplists-before-bailing-out-for-non-buddy-zero-refcount-page.patch
mmhwpoison-drop-unneeded-pcplist-draining.patch
mmhwpoison-remove-stale-code.patch

