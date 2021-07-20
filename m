Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 321D9C07E9B
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 22:47:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FC896101E
	for <mm-commits@archiver.kernel.org>; Tue, 20 Jul 2021 22:47:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhGTWGh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 20 Jul 2021 18:06:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229909AbhGTWGg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 20 Jul 2021 18:06:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1FED2608FE;
        Tue, 20 Jul 2021 22:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626821233;
        bh=9JeuQSmx1P4gPNs16W8cXfPX3PEYB0kZHaexOl0Ve+U=;
        h=Date:From:To:Subject:From;
        b=olC5Dk55mxUJhHmJ96KDlrClFM9cRDkRVvKjb7jvk4oMmrvkkmEPf5QjXsFPXlr3i
         15gNklwLDKFSFv6AcBKqVCTBfepYNchAsZVCVVCvbQwmawRJNObFc8pwpxBbPJdqMK
         nR5ceVrE1xTWw+v20c3RMYjqLBSDF/i3zYR98gtE=
Date:   Tue, 20 Jul 2021 15:47:12 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        feng.tang@intel.com
Subject:  +
 mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix-2.patch added to
 -mm tree
Message-ID: <20210720224712.UwPHu%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: fix compile warning for !CONFIG_NUMA build
has been added to the -mm tree.  Its filename is
     mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Feng Tang <feng.tang@intel.com>
Subject: mm/hugetlb: fix compile warning for !CONFIG_NUMA build

Stephen Rothwell reported the i386 build with CONFIG_NUMA=n will have a
warning:

mm/hugetlb.c: In function 'dequeue_huge_page_vma':
mm/hugetlb.c:1180:1: warning: label 'check_reserve' defined but not used [-Wunused-label]
 1180 | check_reserve:
       | ^~~~~~~~~~~~~

introduced by commit
    df178183cf05 ("mm/hugetlb: add support for mempolicy MPOL_PREFERRED_MANY")

Link: https://lkml.kernel.org/r/20210719084752.GA51285@shbuild999.sh.intel.com
Signed-off-by: Feng Tang <feng.tang@intel.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/hugetlb.c~mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix-2
+++ a/mm/hugetlb.c
@@ -1177,7 +1177,9 @@ static struct page *dequeue_huge_page_vm
 #endif
 	page = dequeue_huge_page_nodemask(h, gfp_mask, nid, nodemask);
 
+#ifdef CONFIG_NUMA
 check_reserve:
+#endif
 	if (page && !avoid_reserve && vma_has_reserves(vma, chg)) {
 		SetHPageRestoreReserve(page);
 		h->resv_huge_pages--;
_

Patches currently in -mm which might be from feng.tang@intel.com are

mm-memplicy-add-page-allocation-function-for-mpol_preferred_many-policy.patch
mm-hugetlb-add-support-for-mempolicy-mpol_preferred_many-fix-2.patch
mm-mempolicy-unify-the-create-func-for-bind-interleave-prefer-many-policies.patch

