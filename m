Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3196C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F4302087D
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817654;
	bh=aT98i8k5VMat1KATyYmggdZe6+V54kX0aaVv24RkXoM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=IsQTefky6L6kNKTW/n68uv4ZVK+AE9n4gOV9eYcQKTX5rGb5rjf1hqwWRuFINTgRt
	 AqWqAVlUKiCz+wtf+Wy1UPghAnFqwDlWzRzzzKSkThSz+WuPjATOx+xdxOULM78kXu
	 V2R9D7ASkmqUzaTz/+P68T8DWxdG2zb1oXejk0ww=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732222AbgJPDHb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:07:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727382AbgJPDHb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:07:31 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3358120878;
        Fri, 16 Oct 2020 03:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817651;
        bh=aT98i8k5VMat1KATyYmggdZe6+V54kX0aaVv24RkXoM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=FlrznbFc0fhJXPGCXxVBoTAFkbeNdtXtoTAz1jLwldaMWz9axxuPrcHB4u1GjLG2I
         YWqTcdf0F/tREuNYZJafgyvLU8UxJC2jiSv3JY9k7cIIy4ToULxuW9ee8PMyFmTfnA
         xe4NzYy7rwYAGyYRKkLgdKUusI9whF9ZpiCEWzbQ=
Date:   Thu, 15 Oct 2020 20:07:29 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, aris@ruivo.org, cai@lca.pw,
        dave.hansen@intel.com, david@redhat.com, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.com, osalvador@suse.de,
        tony.luck@intel.com, torvalds@linux-foundation.org,
        zeil@yandex-team.ru
Subject:  [patch 054/156] mm,hwpoison: try to narrow window race
 for free pages
Message-ID: <20201016030729.gBMFCY0mH%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Oscar Salvador <osalvador@suse.de>
Subject: mm,hwpoison: try to narrow window race for free pages

Aristeu Rozanski reported that a customer test case started to report
-EBUSY after the hwpoison rework patchset.

There is a race window between spotting a free page and taking it off its
buddy freelist, so it might be that by the time we try to take it off, the
page has been already allocated.

This patch tries to handle such race window by trying to handle the new
type of page again if the page was allocated under us.

Link: https://lkml.kernel.org/r/20200922135650.1634-15-osalvador@suse.de
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Reported-by: Aristeu Rozanski <aris@ruivo.org>
Tested-by: Aristeu Rozanski <aris@ruivo.org>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
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

 mm/memory-failure.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/memory-failure.c~mmhwpoison-try-to-narrow-window-race-for-free-pages
+++ a/mm/memory-failure.c
@@ -1903,6 +1903,7 @@ int soft_offline_page(unsigned long pfn,
 {
 	int ret;
 	struct page *page;
+	bool try_again = true;
 
 	if (!pfn_valid(pfn))
 		return -ENXIO;
@@ -1918,6 +1919,7 @@ int soft_offline_page(unsigned long pfn,
 		return 0;
 	}
 
+retry:
 	get_online_mems();
 	ret = get_any_page(page, pfn, flags);
 	put_online_mems();
@@ -1925,7 +1927,10 @@ int soft_offline_page(unsigned long pfn,
 	if (ret > 0)
 		ret = soft_offline_in_use_page(page);
 	else if (ret == 0)
-		ret = soft_offline_free_page(page);
+		if (soft_offline_free_page(page) && try_again) {
+			try_again = false;
+			goto retry;
+		}
 
 	return ret;
 }
_
