Return-Path: <SRS0=zz/k=DX=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A320C433E7
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FE1520897
	for <mm-commits@archiver.kernel.org>; Fri, 16 Oct 2020 03:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602817606;
	bh=k5SLklW+kk5AvaIrFuTMjVOQ3SuM6ppRXxxvqH827WQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=tSEFaucVl+t3H3PeHEjENTafjGtFBztfwMR487edweUPnypEkDigKtFqYOJC5yVZU
	 KznIm2IyuPwj8w0SmZwFoXa5a/hmT3OTUEDBUaFrM4bK9ZWSWRz8iusVqxsdBik/YO
	 60ElI85Uki8pc2pqTieAFRfaGP4VpoGZK6PK3+44=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404482AbgJPDGp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Oct 2020 23:06:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:44848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404479AbgJPDGo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Oct 2020 23:06:44 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7706A20878;
        Fri, 16 Oct 2020 03:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602817604;
        bh=k5SLklW+kk5AvaIrFuTMjVOQ3SuM6ppRXxxvqH827WQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=c7rULXcwzK6n3t3Um7vhcsnQv70hA5KDiz9ggKZhpTKd0RuXbZcoC8ZAr9IO0JhGN
         dHNfH72g43dyrTOTky8o6Acpctjb904+Ial4vEwGX7n5TtbzylekK94PoppyQvZ0XD
         shofA7V66RICF6H3tFEnjf0ivOpLM87Yt5T6nIUc=
Date:   Thu, 15 Oct 2020 20:06:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, aneesh.kumar@linux.ibm.com,
        aneesh.kumar@linux.vnet.ibm.com, aris@ruivo.org, cai@lca.pw,
        dave.hansen@intel.com, david@redhat.com, mhocko@kernel.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, osalvador@suse.com, osalvador@suse.de,
        tony.luck@intel.com, torvalds@linux-foundation.org,
        zeil@yandex-team.ru
Subject:  [patch 042/156] mm, hwpoison: remove recalculating hpage
Message-ID: <20201016030642.QQQSCG-Ax%akpm@linux-foundation.org>
In-Reply-To: <20201015194043.84cda0c1d6ca2a6847f2384a@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: mm, hwpoison: remove recalculating hpage

hpage is never used after try_to_split_thp_page() in memory_failure(), so
we don't have to update hpage.  So let's not recalculate/use hpage.

Link: https://lkml.kernel.org/r/20200922135650.1634-3-osalvador@suse.de
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Aristeu Rozanski <aris@ruivo.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-remove-recalculating-hpage
+++ a/mm/memory-failure.c
@@ -1341,7 +1341,6 @@ int memory_failure(unsigned long pfn, in
 		}
 		unlock_page(p);
 		VM_BUG_ON_PAGE(!page_count(p), p);
-		hpage = compound_head(p);
 	}
 
 	/*
@@ -1413,11 +1412,8 @@ int memory_failure(unsigned long pfn, in
 	/*
 	 * Now take care of user space mappings.
 	 * Abort on fail: __delete_from_page_cache() assumes unmapped page.
-	 *
-	 * When the raw error page is thp tail page, hpage points to the raw
-	 * page after thp split.
 	 */
-	if (!hwpoison_user_mappings(p, pfn, flags, &hpage)) {
+	if (!hwpoison_user_mappings(p, pfn, flags, &p)) {
 		action_result(pfn, MF_MSG_UNMAP_FAILED, MF_IGNORED);
 		res = -EBUSY;
 		goto out;
_
