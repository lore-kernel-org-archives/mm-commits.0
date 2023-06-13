Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB672EB64D7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Jun 2023 20:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbjFMUDe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Jun 2023 16:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbjFMUDd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Jun 2023 16:03:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A85CD
        for <mm-commits@vger.kernel.org>; Tue, 13 Jun 2023 13:03:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 875EC631EB
        for <mm-commits@vger.kernel.org>; Tue, 13 Jun 2023 20:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B23C433F0;
        Tue, 13 Jun 2023 20:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686686610;
        bh=Ep1So8+jFUAoSLh+Y0YYy+pTQc15/xPgEKYpkc4S2xw=;
        h=Date:To:From:Subject:From;
        b=kk7z41JjOyv/Xn7lBKgRTxMtP3RVd4unii+OJsJKu7JxVcWaQSXi2M+N4Mz0vWq+n
         hHQT25dv+Gi2bq8Yti1OCnJC1B5LZItCgJczw3Dz27ijYdIuDvLvxYwP+KA9Z0NfCU
         +jUuOXQuHv2AtrWtP9t9d3dNYr2dPcaNxabOD+SI=
Date:   Tue, 13 Jun 2023 13:03:30 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, minchan@kernel.org,
        iamjoonsoo.kim@lge.com, quic_yingangl@quicinc.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-cma-show-pfn-in-cma-page_onwer-with-hex-format.patch added to mm-unstable branch
Message-Id: <20230613200330.C3B23C433F0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner/cma: show pfn in cma/page_owner with hex format
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_owner-cma-show-pfn-in-cma-page_onwer-with-hex-format.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-cma-show-pfn-in-cma-page_onwer-with-hex-format.patch

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
From: Kassey Li <quic_yingangl@quicinc.com>
Subject: mm/page_owner/cma: show pfn in cma/page_owner with hex format
Date: Tue, 13 Jun 2023 17:25:33 +0800

cma: display pfn as well as pfn_to_page(pfn)

page_owner: display pfn in hex rather than decimal

Link: https://lkml.kernel.org/r/20230613092533.15449-1-quic_yingangl@quicinc.com
Signed-off-by: Kassey Li <quic_yingangl@quicinc.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c        |    4 ++--
 mm/page_owner.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/cma.c~mm-page_owner-cma-show-pfn-in-cma-page_onwer-with-hex-format
+++ a/mm/cma.c
@@ -483,8 +483,8 @@ struct page *cma_alloc(struct cma *cma,
 		if (ret != -EBUSY)
 			break;
 
-		pr_debug("%s(): memory range at %p is busy, retrying\n",
-			 __func__, pfn_to_page(pfn));
+		pr_debug("%s(): memory range at pfn 0x%lx %p is busy, retrying\n",
+			 __func__, pfn, pfn_to_page(pfn));
 
 		trace_cma_alloc_busy_retry(cma->name, pfn, pfn_to_page(pfn),
 					   count, align);
--- a/mm/page_owner.c~mm-page_owner-cma-show-pfn-in-cma-page_onwer-with-hex-format
+++ a/mm/page_owner.c
@@ -418,7 +418,7 @@ print_page_owner(char __user *buf, size_
 	pageblock_mt = get_pageblock_migratetype(page);
 	page_mt  = gfp_migratetype(page_owner->gfp_mask);
 	ret += scnprintf(kbuf + ret, count - ret,
-			"PFN %lu type %s Block %lu type %s Flags %pGp\n",
+			"PFN 0x%lx type %s Block %lu type %s Flags %pGp\n",
 			pfn,
 			migratetype_names[page_mt],
 			pfn >> pageblock_order,
_

Patches currently in -mm which might be from quic_yingangl@quicinc.com are

mm-page_owner-cma-show-pfn-in-cma-page_onwer-with-hex-format.patch

