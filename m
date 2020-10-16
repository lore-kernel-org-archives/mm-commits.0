Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C9D6C433DF
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:06:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F58F20897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817609;
	bh=ryZoxQ7FFtPPTM8DF9p+Qpzlzm+pwrqWj6QeHU3F6NE=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=POHNkCTa4RjY84rF7oPcZYw4Z6bLcxGHsC3QjtnTWjKWdJsMPQsR5oZWnD6KoX6qG
	 qVXWeIlGpgrvlvUcZWaI/KsmLbgG+cn15c+w9mSdMKcLv39DUJ0e4nWzNRvkvuMoR0
	 Y+ki9cUWlfraes8CB1LtbpHsWi6YbPvoF9A/3ZGI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404483AbgJPDGs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:06:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:44896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404479AbgJPDGs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:06:48 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 087A22087D;
        Fri, 16 Oct 2020 03:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817607;
        bh=ryZoxQ7FFtPPTM8DF9p+Qpzlzm+pwrqWj6QeHU3F6NE=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=cqagU16dnYLhov49o7Se3WYRp7iP087gOWbO5MS31xZpsyqGh4VnHIxk5+k1e3t9T
         KKtbbvpQeRxrVbVZ2DgIdbpPE1YiSa4EoJcXoO5Z9KGjzcS5Yvij5vYxWgp0swUfsI
         +ETVTHp6UKKyjUbF8ibP5VncHLr03ITgmEtExn3Q=
Date:   Thu, 15 Oct 2020 20:06:46 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, aris@ruivo.org, cai@lca.pw,
        dave.hansen@intel.com, david@redhat.com, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.com, osalvador@suse.de,
        tony.luck@intel.com, torvalds@linux-foundation.org,
        zeil@yandex-team.ru
Subject:  [patch 043/156] mm,hwpoison-inject: don't pin for
 hwpoison_filter
Message-ID: <20201016030646.st-eupq3v%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm,hwpoison-inject: don't pin for hwpoison_filter

Another memory error injection interface debugfs:hwpoison/corrupt-pfn also
takes bogus refcount for hwpoison_filter().  It's justified because this
does a coarse filter, expecting that memory_failure() redoes the check for
sure.

Link: https://lkml.kernel.org/r/20200922135650.1634-4-osalvador@suse.de
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Oscar Salvador <osalvador@suse.de>
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
