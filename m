Return-Path: <SRS0=f579=BK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B77C433E0
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:06:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B3A722B42
	for <mm-commits@archiver.kernel.org>; Fri, 31 Jul 2020 20:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596225990;
	bh=kgCWI+ZZ8QdKJCbPKiI0RBzWsaMw1DStX3l7fKmRwKM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=dB4cmLbQLKeuG79wYVBhLl4z183cB3ha0ChxQPMQtFR9Bneepiu/+U7uKJ2gas+DJ
	 9LDWnHB/wzRNVSt6jmi6C9Fy6vDkSJ4kkq3jbERaRcji4HZRN1mYVwBXemaptho17w
	 vt5qgePasQFDakYOiG5VdEM+vx2eVD/bAmMAX8kA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgGaUG3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 31 Jul 2020 16:06:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgGaUG3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 31 Jul 2020 16:06:29 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1F93208E4;
        Fri, 31 Jul 2020 20:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596225988;
        bh=kgCWI+ZZ8QdKJCbPKiI0RBzWsaMw1DStX3l7fKmRwKM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YpYBSi/021Aa6IlegSH004pW1+b6pYRS7SLi+tPqIEGVwc03PrHEv4T4Pd8aFNaQO
         XpRIFalH3W7HJukLOQymwykNiq9C3qqKj3Z+2RTL4MZ6B4Z8VSMaqiSlNFFCWaSt9K
         1RohS5gzvPchJT/Fz5E4u5MKwePbN7t10Wz+GY/I=
Date:   Fri, 31 Jul 2020 13:06:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     aneesh.kumar@linux.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        cai@lca.pw, dave.hansen@intel.com, david@redhat.com,
        mhocko@suse.com, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        naoya.horiguchi@nec.com, osalvador@suse.com, osalvador@suse.de,
        tony.luck@intel.com, zeil@yandex-team.ru
Subject:  +
 mmhwpoison-double-check-page-count-in-__get_any_page.patch added to -mm
 tree
Message-ID: <20200731200627.WJ3eUIK13%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: double-check page count in __get_any_page()
has been added to the -mm tree.  Its filename is
     mmhwpoison-double-check-page-count-in-__get_any_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mmhwpoison-double-check-page-count-in-__get_any_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mmhwpoison-double-check-page-count-in-__get_any_page.patch

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

Link: http://lkml.kernel.org/r/20200731122112.11263-17-nao.horiguchi@gmail.com
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Reported-by: Qian Cai <cai@lca.pw>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/memory-failure.c~mmhwpoison-double-check-page-count-in-__get_any_page
+++ a/mm/memory-failure.c
@@ -1701,6 +1701,9 @@ static int __get_any_page(struct page *p
 		} else if (is_free_buddy_page(p)) {
 			pr_info("%s: %#lx free buddy page\n", __func__, pfn);
 			ret = 0;
+		} else if (page_count(p)) {
+			/* raced with allocation */
+			ret = -EBUSY;
 		} else {
 			pr_info("%s: %#lx: unknown zero refcount page type %lx\n",
 				__func__, pfn, p->flags);
@@ -1717,6 +1720,9 @@ static int get_any_page(struct page *pag
 {
 	int ret = __get_any_page(page, pfn);
 
+	if (ret == -EBUSY)
+		ret = __get_any_page(page, pfn);
+
 	if (ret == 1 && !PageHuge(page) &&
 	    !PageLRU(page) && !__PageMovable(page)) {
 		/*
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

