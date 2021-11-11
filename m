Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7809C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8F036103C
	for <mm-commits@archiver.kernel.org>; Thu, 11 Nov 2021 02:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbhKKCx1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Nov 2021 21:53:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:57182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234469AbhKKCxM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Nov 2021 21:53:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BDAE60F26;
        Thu, 11 Nov 2021 02:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636599024;
        bh=31OYtH3utx+QTb3aWFT8qsv2RV9wWOndPOuTSp1VF4g=;
        h=Date:From:To:Subject:From;
        b=HY0N+bmlOysZvgxPG+IbAfMkn6Rhn8JdY8dxiEORapTbPlKp6kMMBhYhMtUmnRhvZ
         BJxNR3hRiAdounQPjOReocnjUjXYg0qTn/caKmhDTzKnptNmM8H6Vh4MmX1nt1xyZq
         5ZLxkQAp4lmhyF6taKb5S5cRlLeSVxU4Ns551JFI=
Date:   Wed, 10 Nov 2021 18:50:24 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com
Subject:  [merged]
 mm-damon-remove-unnecessary-variable-initialization.patch removed from -mm
 tree
Message-ID: <20211111025024.queD9OMDj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: remove unnecessary variable initialization
has been removed from the -mm tree.  Its filename was
     mm-damon-remove-unnecessary-variable-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon: remove unnecessary variable initialization

Patch series "mm/damon: Fix some small bugs", v4.


This patch (of 2):

In 'damon_va_apply_three_regions', There is no need to set variable 'i' as
0

Link: https://lkml.kernel.org/r/b7df8d3dad0943a37e01f60c441b1968b2b20354.1634720326.git.xhao@linux.alibaba.com
Link: https://lkml.kernel.org/r/cover.1634720326.git.xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/vaddr.c~mm-damon-remove-unnecessary-variable-initialization
+++ a/mm/damon/vaddr.c
@@ -306,7 +306,7 @@ static void damon_va_apply_three_regions
 		struct damon_addr_range bregions[3])
 {
 	struct damon_region *r, *next;
-	unsigned int i = 0;
+	unsigned int i;
 
 	/* Remove regions which are not in the three big regions now */
 	damon_for_each_region_safe(r, next, t) {
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are


