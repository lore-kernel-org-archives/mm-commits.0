Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E994C352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiLAAAZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiLAAAR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:00:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3171E58034
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD13061E6C
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC333C43470;
        Thu,  1 Dec 2022 00:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669852816;
        bh=k7LMKkqlTRN6wl4qKaDGk3L/D/SVKrKd0Mq/TLsO6Uo=;
        h=Date:To:From:Subject:From;
        b=1fluR74cSZXlobC4hqu/F57PlPSWHKncxaiD1Mvc1gPAKPNaXMiG6iIGb8WnpCXDO
         Wsj6s6gtrk8EgqoMRmOcvwySTMVceElRLuN00JhdQi7uYP/e9g5mkR/RAT2AHlMdhY
         +Z+JPV/h4E8tvErL9CkyeSZKxaxfglM2pOLedesw=
Date:   Wed, 30 Nov 2022 16:00:15 -0800
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        songmuchun@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-remove-redundant-list_del.patch removed from -mm tree
Message-Id: <20221201000015.EC333C43470@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: remove redundant list_del()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-remove-redundant-list_del.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: hugetlb_vmemmap: remove redundant list_del()
Date: Thu, 27 Oct 2022 11:36:41 +0800

The ->lru field will be assigned to a new value in __free_page().  So it
is unnecessary to delete it from the @list.  Just remove it to simplify
the code.

Link: https://lkml.kernel.org/r/20221027033641.66709-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-remove-redundant-list_del
+++ a/mm/hugetlb_vmemmap.c
@@ -232,10 +232,8 @@ static void free_vmemmap_page_list(struc
 {
 	struct page *page, *next;
 
-	list_for_each_entry_safe(page, next, list, lru) {
-		list_del(&page->lru);
+	list_for_each_entry_safe(page, next, list, lru)
 		free_vmemmap_page(page);
-	}
 }
 
 static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


