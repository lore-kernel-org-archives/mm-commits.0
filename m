Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27892C43219
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357446AbiCYBg0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241345AbiCYBfr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2CE2F028
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:33:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2CADC60A66
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E22C340EC;
        Fri, 25 Mar 2022 01:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172018;
        bh=JttruxBnFjqKUmvGmoBFKfB3Bl80bWsWttNr4kLSMvM=;
        h=Date:To:From:Subject:From;
        b=Qwgwn65iEYsRfVEX2fn1sMNA7SEWvO1YKyN7CmRJ96i/l/bIO7g5kkfTMqSPUDcRf
         Y9eedBJ2S4LDBkHCXDRrLOLJavqPImKmndmgPtBsbI56FBD3AM53/6UA2NydikpSwi
         3Sp1lb/0QTDgkF+GVMbvbssbipPV5/TYzwX7CH3g=
Date:   Thu, 24 Mar 2022 18:33:37 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, xhao@linux.alibaba.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-damon-sysfs-remove-repeat-container_of-in-damon_sysfs_kdamond_release.patch removed from -mm tree
Message-Id: <20220325013338.89E22C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/sysfs: remove repeat container_of() in damon_sysfs_kdamond_release()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-remove-repeat-container_of-in-damon_sysfs_kdamond_release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xin Hao <xhao@linux.alibaba.com>
Subject: mm/damon/sysfs: remove repeat container_of() in damon_sysfs_kdamond_release()

In damon_sysfs_kdamond_release(), we have use container_of() to get
"kdamond" pointer, so there no need to get it once again.

Link: https://lkml.kernel.org/r/20220303075314.22502-1-xhao@linux.alibaba.com
Signed-off-by: Xin Hao <xhao@linux.alibaba.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-remove-repeat-container_of-in-damon_sysfs_kdamond_release
+++ a/mm/damon/sysfs.c
@@ -2345,7 +2345,7 @@ static void damon_sysfs_kdamond_release(
 
 	if (kdamond->damon_ctx)
 		damon_destroy_ctx(kdamond->damon_ctx);
-	kfree(container_of(kobj, struct damon_sysfs_kdamond, kobj));
+	kfree(kdamond);
 }
 
 static struct kobj_attribute damon_sysfs_kdamond_state_attr =
_

Patches currently in -mm which might be from xhao@linux.alibaba.com are


