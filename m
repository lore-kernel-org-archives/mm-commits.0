Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2998BC43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCD2B21775
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881388;
	bh=ec1p36WeY0vgSiprW/m08UJZjW0TIaandH40qJRFtIQ=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=DO/vMc7I1BP8nE1uL9Td6jbKzRaesnI+qp6BqMkqd9bFAH7tKY2d/2z/zm3wq+mj/
	 I0JpjTNhfYbJ9teGKGTbuzV7ts+Fvg337SXjTzOuMzNJYLXq2GLbxdXqxByanEpWTh
	 JGzpq4KWFEHA07ENZgO2Mzh2kTxiYMrVVWUHdzqA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391060AbgJPUts (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:49:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:38894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392725AbgJPUts (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:49:48 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE78621D41;
        Fri, 16 Oct 2020 20:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881387;
        bh=ec1p36WeY0vgSiprW/m08UJZjW0TIaandH40qJRFtIQ=;
        h=Date:From:To:Subject:From;
        b=qq0NdI4EWl86M0b306mv4CjSsNIRgQx7l166gZyGheG6eYAUGBUNq03j0MpY+JLri
         RFzZIGhIBH1a1k755ia7i0m8ZIIskMEiPhZRZiDYEb4YXjOw8HXtIxI1ZW00mvUeKK
         6640MSKtCJhCD8ddVfAfUCta/f9Ox7Yoa5EeFleM=
Date:   Fri, 16 Oct 2020 13:49:46 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        aris@ruivo.org, cai@lca.pw, dave.hansen@intel.com,
        david@redhat.com, mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.com, tony.luck@intel.com, zeil@yandex-team.ru
Subject:  [merged]
 mmhwpoison-double-check-page-count-in-__get_any_page.patch removed from -mm
 tree
Message-ID: <20201016204946.hBZZu8bnC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: double-check page count in __get_any_page()
has been removed from the -mm tree.  Its filename was
     mmhwpoison-double-check-page-count-in-__get_any_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


