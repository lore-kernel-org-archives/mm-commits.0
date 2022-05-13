Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB4FAC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 13 May 2022 19:25:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383861AbiEMTZF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 13 May 2022 15:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383881AbiEMTXQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 May 2022 15:23:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EE32F008
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 12:22:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8442B831A7
        for <mm-commits@vger.kernel.org>; Fri, 13 May 2022 19:22:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9FEC34113;
        Fri, 13 May 2022 19:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652469735;
        bh=8VVmSKAHLNYTuHTVTNjtZzUrGrxdjLRkaoGG0tqGELg=;
        h=Date:To:From:Subject:From;
        b=BDyZ9mn2T3ANryF5NGhpIMppVtJYEY2iXsjaLZKsDU5ETthG2bToQF2BNimQvceyw
         yCval4sp5BzI6xZr2omnjyGzPG8Zuan1Eme8On2q948BDFynev6n2S7rhFP0npNCJ5
         FsPQv6ft1VCbqyfJpGhGgrSnJNyHBT2k8WqCc7IM=
Date:   Fri, 13 May 2022 12:22:15 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, markubo@amazon.de,
        abaci@linux.alibaba.com, jiapeng.chong@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-use-resource_size-function-on-resource-object.patch removed from -mm tree
Message-Id: <20220513192215.8D9FEC34113@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/reclaim: use resource_size function on resource object
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-use-resource_size-function-on-resource-object.patch

This patch was dropped because it was merged into the mm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: mm/damon/reclaim: use resource_size function on resource object

Fix the following coccicheck warnings:

./mm/damon/reclaim.c:241:30-33: WARNING: Suspicious code. resource_size is maybe missing with res.

Link: https://lkml.kernel.org/r/20220507032512.129598-1-jiapeng.chong@linux.alibaba.com
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: "Boehme, Markus" <markubo@amazon.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-use-resource_size-function-on-resource-object
+++ a/mm/damon/reclaim.c
@@ -238,7 +238,7 @@ static int walk_system_ram(struct resour
 {
 	struct damon_reclaim_ram_walk_arg *a = arg;
 
-	if (a->end - a->start < res->end - res->start) {
+	if (a->end - a->start < resource_size(res)) {
 		a->start = res->start;
 		a->end = res->end;
 	}
_

Patches currently in -mm which might be from jiapeng.chong@linux.alibaba.com are


