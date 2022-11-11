Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 979EFC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 11 Nov 2022 23:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiKKXKq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Nov 2022 18:10:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiKKXKq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Nov 2022 18:10:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B36563CC7
        for <mm-commits@vger.kernel.org>; Fri, 11 Nov 2022 15:10:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D822AB8282E
        for <mm-commits@vger.kernel.org>; Fri, 11 Nov 2022 23:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78584C433C1;
        Fri, 11 Nov 2022 23:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668208242;
        bh=C97IMgEzwt2yj9wAKW0sqncmDcmblVIqbWHMK++Y5KA=;
        h=Date:To:From:Subject:From;
        b=WiC8xhdzZnIVzFBMbJ+cDwJ9KES3PWVkszkt5eLyPvmd1bOIjSWxPYyFTLcSrx7J+
         DLup07eBLHj1iHLLsyLb6RQAb9kE/dFGVx83I8Ljo5yePGtpYgCmxuXYDP21V9njKo
         j/2+UjMgJUW4+enKIHYgIwngSYm7opa9r72989u0=
Date:   Fri, 11 Nov 2022 15:10:41 -0800
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        joao.m.martins@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v4.patch added to mm-unstable branch
Message-Id: <20221111231042.78584C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v4
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v4.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v4.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Joao Martins <joao.m.martins@oracle.com>
Subject: mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v4
Date: Thu, 10 Nov 2022 12:12:14 +0000

add smp_wmb() to ensure page contents are visible prior to PTE write

Link: https://lkml.kernel.org/r/20221110121214.6297-1-joao.m.martins@oracle.com
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v4
+++ a/mm/hugetlb_vmemmap.c
@@ -246,6 +246,13 @@ static void vmemmap_remap_pte(pte_t *pte
 	if (unlikely(addr == walk->reuse_addr)) {
 		pgprot = PAGE_KERNEL;
 		list_del(&walk->reuse_page->lru);
+
+		/*
+		 * Makes sure that preceding stores to the page contents from
+		 * vmemmap_remap_free() become visible before the set_pte_at()
+		 * write.
+		 */
+		smp_wmb();
 	}
 
 	entry = mk_pte(walk->reuse_page, pgprot);
_

Patches currently in -mm which might be from joao.m.martins@oracle.com are

mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page.patch
mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v3.patch
mm-hugetlb_vmemmap-remap-head-page-to-newly-allocated-page-v4.patch

