Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A55E2C47082
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 00:46:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77E756124B
	for <mm-commits@archiver.kernel.org>; Tue,  1 Jun 2021 00:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbhFAAsL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 31 May 2021 20:48:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:40480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232356AbhFAAsK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 31 May 2021 20:48:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD1E96100A;
        Tue,  1 Jun 2021 00:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622508388;
        bh=9dlOqThAoCWzyGSoTlRFmcxCNJoEVe4tnf+rXTsWBI8=;
        h=Date:From:To:Subject:From;
        b=PCKH9sFDmVAvLxXn3LH9vM1V+7VRpoWkyswjpm7nzMcJ5RZzGS2Un9INnt0Y+ePDJ
         lrgCdwO3DLiqbCO6/gXsheFCZ26xX+CGqt5mn1FDV/lMwDdpI1GPqanOeDO7Js3v6+
         FknVIv4wKy5aaTHDGVLYkv+EEtVHxxe9I85PAbcE=
Date:   Mon, 31 May 2021 17:46:28 -0700
From:   akpm@linux-foundation.org
To:     bhe@redhat.com, liushixin2@huawei.com, mm-commits@vger.kernel.org,
        yangerkun@huawei.com
Subject:  + mm-page_alloc-fix-counting-of-managed_pages.patch added
 to -mm tree
Message-ID: <20210601004628.cWSY8p6Jh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: fix counting of managed_pages
has been added to the -mm tree.  Its filename is
     mm-page_alloc-fix-counting-of-managed_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-fix-counting-of-managed_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-fix-counting-of-managed_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Liu Shixin <liushixin2@huawei.com>
Subject: mm/page_alloc: fix counting of managed_pages

commit f63661566fad ("mm/page_alloc.c: clear out zone->lowmem_reserve[] if
the zone is empty") clears out zone->lowmem_reserve[] if zone is empty. 
But when zone is not empty and sysctl_lowmem_reserve_ratio[i] is set to
zero, zone_managed_pages(zone) is not counted in the managed_pages either.
This is inconsistent with the description of lowmem_reserve, so fix it.

Link: https://lkml.kernel.org/r/20210527125707.3760259-1-liushixin2@huawei.com
Fixes: f63661566fad ("mm/page_alloc.c: clear out zone->lowmem_reserve[] if the zone is empty")
Signed-off-by: Liu Shixin <liushixin2@huawei.com>
Reported-by: yangerkun <yangerkun@huawei.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-counting-of-managed_pages
+++ a/mm/page_alloc.c
@@ -8214,14 +8214,14 @@ static void setup_per_zone_lowmem_reserv
 			unsigned long managed_pages = 0;
 
 			for (j = i + 1; j < MAX_NR_ZONES; j++) {
-				if (clear) {
-					zone->lowmem_reserve[j] = 0;
-				} else {
-					struct zone *upper_zone = &pgdat->node_zones[j];
+				struct zone *upper_zone = &pgdat->node_zones[j];
+
+				managed_pages += zone_managed_pages(upper_zone);
 
-					managed_pages += zone_managed_pages(upper_zone);
+				if (clear)
+					zone->lowmem_reserve[j] = 0;
+				else
 					zone->lowmem_reserve[j] = managed_pages / ratio;
-				}
 			}
 		}
 	}
_

Patches currently in -mm which might be from liushixin2@huawei.com are

mm-page_alloc-fix-counting-of-managed_pages.patch
mm-debug_vm_pgtable-move-pmd-pud_huge_tests-out-of-config_transparent_hugepage.patch
mm-debug_vm_pgtable-remove-redundant-pfn_pmd-pte-and-fix-one-comment-mistake.patch

