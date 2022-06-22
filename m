Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F243BC433EF
	for <mm-commits@archiver.kernel.org>; Wed, 22 Jun 2022 18:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376728AbiFVStO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Jun 2022 14:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376845AbiFVStN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jun 2022 14:49:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1120B31911
        for <mm-commits@vger.kernel.org>; Wed, 22 Jun 2022 11:49:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9CDDB8208B
        for <mm-commits@vger.kernel.org>; Wed, 22 Jun 2022 18:49:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1603FC34114;
        Wed, 22 Jun 2022 18:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655923748;
        bh=nKQTC4NYSqBJFkdIIWZhz4/pHwcxKvl4I4Oyun0YE38=;
        h=Date:To:From:Subject:From;
        b=k1PJKEAlpjqcphL6n9TiG8dgPWt/UpAg66n4uIuAG/GqtxFkO9W3yT/JblJ6e1rml
         yk1AtCO2YOVQhUg83Jqgy5TjtcJr/P0QkrlwvWBpmKDr2IPJ0bg2t+ry8xLBb+f4HD
         M8OLudI/EqCWkX4bVWxIgHDJx6YZOiATRHote7Bk=
Date:   Wed, 22 Jun 2022 11:49:00 -0700
To:     mm-commits@vger.kernel.org, mike.kravetz@oracle.com,
        sfr@canb.auug.org.au, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-do-not-update-address-in-huge_pmd_unshare-fix.patch added to mm-unstable branch
Message-Id: <20220622184907.1603FC34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: hugetlb: fix an unused variable warning/error
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-do-not-update-address-in-huge_pmd_unshare-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-do-not-update-address-in-huge_pmd_unshare-fix.patch

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
@@ -6899,10 +6899,8 @@ unsigned long hugetlb_mask_last_page(str
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

hugetlb-do-not-update-address-in-huge_pmd_unshare-fix.patch

