Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29455C43457
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:49:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC4E421775
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 20:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602881364;
	bh=7PvYKUxUkdZbabG0rGtF6EWVm/JL4KQ9bBz3BAu1/pc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=akSr7zBV6JDLPFD2NHBG/DtFl2hXbR0iC+gcrbmCNBrO7PkN03iQESzzXgde9jvVy
	 gQUz0w+Ojt2EdyVWsVsEVvqmSP85Zu7gMwPw6REIijq704hCqRFOZpUtQHOzGc00wO
	 mIt6VHyHJuhfjHuloDhrrxz6VEqFOcQcDfWM4S0s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391395AbgJPUtY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 16 Oct 2020 16:49:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:38468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391060AbgJPUtY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 16 Oct 2020 16:49:24 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D59B6218AC;
        Fri, 16 Oct 2020 20:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602881363;
        bh=7PvYKUxUkdZbabG0rGtF6EWVm/JL4KQ9bBz3BAu1/pc=;
        h=Date:From:To:Subject:From;
        b=01eWQizPPLesTEJIyGEIvl452br0kHwLQg/pc8Gcp5BKfmYUuXnYEI5SgbkYwjrio
         d1acv1okB1M33ouWxnj1sRyCGNVRLys6foPqUt8mGjuCnP+/QxonGS4bjoBi52WhAL
         lIEMO60CRfAdoBXv/Ef+1J18eFK4stzwczaMKX0Y=
Date:   Fri, 16 Oct 2020 13:49:22 -0700
From:   akpm@linux-foundation.org
To:     aneesh.kumar@linux.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        aris@ruivo.org, cai@lca.pw, dave.hansen@intel.com,
        david@redhat.com, mhocko@kernel.org, mike.kravetz@oracle.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.com, osalvador@suse.de, tony.luck@intel.com,
        zeil@yandex-team.ru
Subject:  [merged]
 mmhwpoison-unexport-get_hwpoison_page-and-make-it-static.patch removed from
 -mm tree
Message-ID: <20201016204922.CyQiBGd9a%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison: unexport get_hwpoison_page and make it static
has been removed from the -mm tree.  Its filename was
     mmhwpoison-unexport-get_hwpoison_page-and-make-it-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: unexport get_hwpoison_page and make it static

Since get_hwpoison_page is only used in memory-failure code now, let us
un-export it and make it private to that code.

Link: https://lkml.kernel.org/r/20200922135650.1634-5-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Aristeu Rozanski <aris@ruivo.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    1 -
 mm/memory-failure.c |    3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/mm.h~mmhwpoison-unexport-get_hwpoison_page-and-make-it-static
+++ a/include/linux/mm.h
@@ -3025,7 +3025,6 @@ extern int memory_failure(unsigned long
 extern void memory_failure_queue(unsigned long pfn, int flags);
 extern void memory_failure_queue_kick(int cpu);
 extern int unpoison_memory(unsigned long pfn);
-extern int get_hwpoison_page(struct page *page);
 #define put_hwpoison_page(page)	put_page(page)
 extern int sysctl_memory_failure_early_kill;
 extern int sysctl_memory_failure_recovery;
--- a/mm/memory-failure.c~mmhwpoison-unexport-get_hwpoison_page-and-make-it-static
+++ a/mm/memory-failure.c
@@ -924,7 +924,7 @@ static int page_action(struct page_state
  * Return: return 0 if failed to grab the refcount, otherwise true (some
  * non-zero value.)
  */
-int get_hwpoison_page(struct page *page)
+static int get_hwpoison_page(struct page *page)
 {
 	struct page *head = compound_head(page);
 
@@ -953,7 +953,6 @@ int get_hwpoison_page(struct page *page)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(get_hwpoison_page);
 
 /*
  * Do all that is necessary to remove user space mappings. Unmap
_

Patches currently in -mm which might be from osalvador@suse.de are


