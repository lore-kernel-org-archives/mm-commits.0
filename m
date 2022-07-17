Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 896CDC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 17 Jul 2022 23:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiGQX2o (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 17 Jul 2022 19:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiGQX2n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 17 Jul 2022 19:28:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E0912608
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 16:28:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 552EEB80E4C
        for <mm-commits@vger.kernel.org>; Sun, 17 Jul 2022 23:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58E2C341C0;
        Sun, 17 Jul 2022 23:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1658100520;
        bh=lJO9Z2vZS0+RMxj9t3DWBTLCnVpLQqKV2EhtNHxyOq0=;
        h=Date:To:From:Subject:From;
        b=diX7WwZP9mSrQTKtdPLJzHwUOKt2dLu9CmPBlYC6jQX7oC0PAlTf1H5LOppuPWDgn
         12BzLzx/pgvh7WfzaLxqYU+s0Hhh2cj5qP/7NowbtbbdUqR2JLHFsfd7bVuThp7XD7
         5RMqwHQgJbwTyBZ2MlC70M3AHqigQV2L/K615oJc=
Date:   Sun, 17 Jul 2022 16:28:39 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        sfr@canb.auug.org.au, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] hugetlb-do-not-update-address-in-huge_pmd_unshare-fix.patch removed from -mm tree
Message-Id: <20220717232839.E58E2C341C0@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlb: fix an unused variable warning/error
has been removed from the -mm tree.  Its filename was
     hugetlb-do-not-update-address-in-huge_pmd_unshare-fix.patch

This patch was dropped because it was folded into hugetlb-do-not-update-address-in-huge_pmd_unshare.patch

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: hugetlb: fix an unused variable warning/error
Date: Wed, 22 Jun 2022 17:04:46 +1000

Link: https://lkml.kernel.org/r/20220622171117.70850960@canb.auug.org.au
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/hugetlb.c~hugetlb-do-not-update-address-in-huge_pmd_unshare-fix
+++ a/mm/hugetlb.c
@@ -6894,10 +6894,8 @@ unsigned long hugetlb_mask_last_page(str
 /* See description above.  Architectures can provide their own version. */
 __weak unsigned long hugetlb_mask_last_page(struct hstate *h)
 {
-	unsigned long hp_size = huge_page_size(h);
-
 #ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
-	if (hp_size == PMD_SIZE)
+	if (huge_page_size(h) == PMD_SIZE)
 		return PUD_SIZE - PMD_SIZE;
 #endif
 	return 0UL;
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

hugetlb-do-not-update-address-in-huge_pmd_unshare.patch

