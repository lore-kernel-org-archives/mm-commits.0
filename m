Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BDFAC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F3992080C
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 21:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597266098;
	bh=XHcmwgLq8vSdoni7Jg5TLyaCgggGnvg1Y0Be4/2aXVM=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=V/3I3ijJKH79IHb/mfIzcA2Q0WZH0EamQwkUvBWVEfp3uvy4Axu4fZzssSGJtBG7H
	 67slQJ/7zY6KozSNnW0BaJqwut2n1q8Q7bhn1o/lB7gU3fn54ZV72XBG7Ylg+IU0Xn
	 oV213r2P4iHZcGAriiapl4DNCl0wt0N/HYF7a/ZQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726564AbgHLVBi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 12 Aug 2020 17:01:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726605AbgHLVBi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 12 Aug 2020 17:01:38 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BD15207F7;
        Wed, 12 Aug 2020 21:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597266097;
        bh=XHcmwgLq8vSdoni7Jg5TLyaCgggGnvg1Y0Be4/2aXVM=;
        h=Date:From:To:Subject:From;
        b=sLOBdDaykY6lFm/5yCwIoNU4esLxmnsNIpJdZwLVmTDFLXh11buSPXZvuThsaa0Gl
         dSkBUR9Km75o2I2S0EK3U7JvL5kGWIBfFUWO5jUy3LuoMRTJSLE1czUa5BjaY5zdDw
         EjVp2D/m8AZYrOvJV4k7wNKwLo0oGzLyKpFW0AqE=
Date:   Wed, 12 Aug 2020 14:01:37 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, natechancellor@gmail.com,
        nigupta@nvidia.com, sfr@canb.auug.org.au
Subject:  [merged] mm-proactive-compaction-fix.patch removed from
 -mm tree
Message-ID: <20200812210137.zLWec0bQV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix compile error due to COMPACTION_HPAGE_ORDER
has been removed from the -mm tree.  Its filename was
     mm-proactive-compaction-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Nitin Gupta <nigupta@nvidia.com>
Subject: mm: fix compile error due to COMPACTION_HPAGE_ORDER

Fix compile error when COMPACTION_HPAGE_ORDER is assigned to
HUGETLB_PAGE_ORDER.  The correct way to check if this constant is defined
is to check for CONFIG_HUGETLBFS.

Link: http://lkml.kernel.org/r/20200623064544.25766-1-nigupta@nvidia.com
Signed-off-by: Nitin Gupta <nigupta@nvidia.com>
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/compaction.c~mm-proactive-compaction-fix
+++ a/mm/compaction.c
@@ -62,7 +62,7 @@ static const int HPAGE_FRAG_CHECK_INTERV
  */
 #if defined CONFIG_TRANSPARENT_HUGEPAGE
 #define COMPACTION_HPAGE_ORDER	HPAGE_PMD_ORDER
-#elif defined HUGETLB_PAGE_ORDER
+#elif defined CONFIG_HUGETLBFS
 #define COMPACTION_HPAGE_ORDER	HUGETLB_PAGE_ORDER
 #else
 #define COMPACTION_HPAGE_ORDER	(PMD_SHIFT - PAGE_SHIFT)
_

Patches currently in -mm which might be from nigupta@nvidia.com are


