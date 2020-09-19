Return-Path: <SRS0=2Wpt=C4=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAAE1C43465
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:24:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7561F21D7F
	for <mm-commits@archiver.kernel.org>; Sat, 19 Sep 2020 00:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1600475055;
	bh=iwyZvB2mfVR2vRfVmMSZIIuaK/AXkdGa43xoeE6T4w4=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=X0x3gR0U/z4rBirDnlVO9TrXwoNWd+w7mZ6g7D6xAGd2fbCv/OznCe/l+C0e76kEL
	 qirn0Xr3r4aQp0izQG3Vb4CmNHOA0+3OrhQ7TsG2ZZlK93A6qv7JPM3FBnqORPegWP
	 0Z4ck4hvlyIPmYzkwDsg+/ZA2z/70mCtjLnaomec=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbgISAYP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 18 Sep 2020 20:24:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgISAYP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 18 Sep 2020 20:24:15 -0400
Received: from X1 (unknown [67.22.170.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EAB221D43;
        Sat, 19 Sep 2020 00:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600475054;
        bh=iwyZvB2mfVR2vRfVmMSZIIuaK/AXkdGa43xoeE6T4w4=;
        h=Date:From:To:Subject:From;
        b=lEY6AB030b/5pbrlUCcq7cyFz7RbytRD9yj/BM8idvaBxrt3obNjdLz4bmwv6K8Rq
         3iqztIeQq8s4m3uYRrlNZP/B76irdZdgeCURAR0SwyAAvRtHgaW4RVgBH/nkKWh7WZ
         GF+N5XG3mPPIBMiS7uD65g1wOMsqK3C5E6ZtsTjU=
Date:   Fri, 18 Sep 2020 17:24:13 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zeil@yandex-team.ru,
        tony.luck@intel.com, osalvador@suse.com, mike.kravetz@oracle.com,
        mhocko@kernel.org, david@redhat.com, dave.hansen@intel.com,
        cai@lca.pw, aneesh.kumar@linux.vnet.ibm.com,
        aneesh.kumar@linux.ibm.com, naoya.horiguchi@nec.com
Subject:  [to-be-updated]
 mmhwpoison-inject-dont-pin-for-hwpoison_filter.patch removed from -mm tree
Message-ID: <20200919002413.EDR-a%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,hwpoison-inject: don't pin for hwpoison_filter
has been removed from the -mm tree.  Its filename was
     mmhwpoison-inject-dont-pin-for-hwpoison_filter.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm,hwpoison-inject: don't pin for hwpoison_filter

Another memory error injection interface debugfs:hwpoison/corrupt-pfn also
takes bogus refcount for hwpoison_filter().  It's justified because this
does a coarse filter, expecting that memory_failure() redoes the check for
sure.

Link: http://lkml.kernel.org/r/20200806184923.7007-4-nao.horiguchi@gmail.com
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Oscar Salvador <osalvador@suse.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hwpoison-inject.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

--- a/mm/hwpoison-inject.c~mmhwpoison-inject-dont-pin-for-hwpoison_filter
+++ a/mm/hwpoison-inject.c
@@ -26,11 +26,6 @@ static int hwpoison_inject(void *data, u
 
 	p = pfn_to_page(pfn);
 	hpage = compound_head(p);
-	/*
-	 * This implies unable to support free buddy pages.
-	 */
-	if (!get_hwpoison_page(p))
-		return 0;
 
 	if (!hwpoison_filter_enable)
 		goto inject;
@@ -40,23 +35,20 @@ static int hwpoison_inject(void *data, u
 	 * This implies unable to support non-LRU pages.
 	 */
 	if (!PageLRU(hpage) && !PageHuge(p))
-		goto put_out;
+		return 0;
 
 	/*
-	 * do a racy check with elevated page count, to make sure PG_hwpoison
-	 * will only be set for the targeted owner (or on a free page).
+	 * do a racy check to make sure PG_hwpoison will only be set for
+	 * the targeted owner (or on a free page).
 	 * memory_failure() will redo the check reliably inside page lock.
 	 */
 	err = hwpoison_filter(hpage);
 	if (err)
-		goto put_out;
+		return 0;
 
 inject:
 	pr_info("Injecting memory failure at pfn %#lx\n", pfn);
-	return memory_failure(pfn, MF_COUNT_INCREASED);
-put_out:
-	put_hwpoison_page(p);
-	return 0;
+	return memory_failure(pfn, 0);
 }
 
 static int hwpoison_unpoison(void *data, u64 val)
_

Patches currently in -mm which might be from naoya.horiguchi@nec.com are

mmhwpoison-introduce-mf_msg_unsplit_thp.patch
mmhwpoison-double-check-page-count-in-__get_any_page.patch

