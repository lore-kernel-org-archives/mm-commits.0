Return-Path: <SRS0=iiPm=C7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98F36C4363D
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:00:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 594E223A74
	for <mm-commits@archiver.kernel.org>; Tue, 22 Sep 2020 17:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600794049;
	bh=pVfv9xta0VH59cQlARtYquOYfUa7QlbrT5qCdMm7ad8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=K8CJWAO16VNqIgMFqIwdV2f/5G7/6j5lkZFLJNAl9adeIkVaHfBCEbAdqxQ9zUUCG
	 Bbe10KAYZQIwbWlHxYUd2sX179U4X+Si8subCAnZcXSH9eSJubQFAInDyaZzoJ1h7z
	 6UTkKt419IaMESaXElnKkKZ64TEDiHcjEhybHfQ8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgIVRAt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Sep 2020 13:00:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726607AbgIVRAs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Sep 2020 13:00:48 -0400
Received: from X1 (unknown [216.241.194.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7536423A1B;
        Tue, 22 Sep 2020 17:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600794048;
        bh=pVfv9xta0VH59cQlARtYquOYfUa7QlbrT5qCdMm7ad8=;
        h=Date:From:To:Subject:From;
        b=APet6MbX2xGUmAX+cURS57C1Zj797ZucmIZinzHGiStT4/X/D0eb19AmFYmqqZtx+
         LbxQNtZAqUQ3fW4f/U3vjiK3Us3nlXOBzKdX86vVR2pmrM/SQUHiG2QDVpeVjPNBUl
         0A5ILaxP7YVT4vT8KOdhlDTTxCvUU67rRX6Q+Zq4=
Date:   Tue, 22 Sep 2020 10:00:46 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zeil@yandex-team.ru,
        tony.luck@intel.com, osalvador@suse.com, mike.kravetz@oracle.com,
        mhocko@kernel.org, david@redhat.com, dave.hansen@intel.com,
        cai@lca.pw, aris@ruivo.org, aneesh.kumar@linux.vnet.ibm.com,
        aneesh.kumar@linux.ibm.com, naoya.horiguchi@nec.com
Subject:  +
 mmhwpoison-double-check-page-count-in-__get_any_page.patch added to -mm tree
Message-ID: <20200922170046.drVh6%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: double-check page count in __get_any_page()
has been added to the -mm tree.  Its filename is
     mmhwpoison-double-check-page-count-in-__get_any_page.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-double-check-page-count-in-__get_any_page.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-double-check-page-count-in-__get_any_page.patch

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
Subject: mm,hwpoison: double-check page count in __get_any_page()

Soft offlining could fail with EIO due to the race condition with hugepage
migration.  This issuse became visible due to the change by previous patch
that makes soft offline handler take page refcount by its own.  We have no
way to directly pin zero refcount page, and the page considered as a zero
refcount page could be allocated just after the first check.

This patch adds the second check to find the race and gives us chance to
handle it more reliably.

Link: https://lkml.kernel.org/r/20200922135650.1634-14-osalvador@suse.de
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: Qian Cai <cai@lca.pw>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Aristeu Rozanski <aris@ruivo.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memory-failure.c~mmhwpoison-double-check-page-count-in-__get_any_page
+++ a/mm/memory-failure.c
@@ -1707,6 +1707,9 @@ static int __get_any_page(struct page *p
 		} else if (is_free_buddy_page(p)) {
 			pr_info("%s: %#lx free buddy page\n", __func__, pfn);
 			ret = 0;
+		} else if (page_count(p)) {
+			/* raced with allocation */
+			ret = -EBUSY;
 		} else {
 			pr_info("%s: %#lx: unknown zero refcount page type %lx\n",
 				__func__, pfn, p->flags);
@@ -1723,6 +1726,9 @@ static int get_any_page(struct page *pag
 {
 	int ret = __get_any_page(page, pfn, flags);
 
+	if (ret == -EBUSY)
+		ret = __get_any_page(page, pfn, flags);
+
 	if (ret == 1 && !PageHuge(page) &&
 	    !PageLRU(page) && !__PageMovable(page)) {
 		/*
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mmhwpoison-cleanup-unused-pagehuge-check.patch
mm-hwpoison-remove-recalculating-hpage.patch
mmhwpoison-inject-dont-pin-for-hwpoison_filter.patch
mmhwpoison-introduce-mf_msg_unsplit_thp.patch
mmhwpoison-double-check-page-count-in-__get_any_page.patch

