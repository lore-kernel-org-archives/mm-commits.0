Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C52C4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357379AbiCYBfD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357395AbiCYBdu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F321BD8AB
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:32:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BE81608C1
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91846C340EC;
        Fri, 25 Mar 2022 01:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171936;
        bh=35QjWY0rLU2PXMIL4xavGY2ugIXBPtGd6DgvihJw3gE=;
        h=Date:To:From:Subject:From;
        b=G5u64+ncmaQkGWPyy54C7b0f0PmDc6ktp+97RZ+R0DepZu8ylKslHJST8+74am1VU
         4WXdQtERNyL1+UllOdg5LwM8q7mJdvo26ZSKvPFKja+4g68PBRekMGpdfFGFMGTcjq
         2VHb3SINKCSc6HSHcuygebE2eNTTlnOX5EqZKf4o=
Date:   Thu, 24 Mar 2022 18:32:15 -0700
To:     mm-commits@vger.kernel.org, rientjes@google.com, mhocko@suse.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-oom_kill-remove-unneeded-is_memcg_oom-check.patch removed from -mm tree
Message-Id: <20220325013216.91846C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill: remove unneeded is_memcg_oom check
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-remove-unneeded-is_memcg_oom-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/oom_kill: remove unneeded is_memcg_oom check

oom_cpuset_eligible() is always called when !is_memcg_oom().  Remove this
unnecessary check.

Link: https://lkml.kernel.org/r/20220224115933.20154-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/mm/oom_kill.c~mm-oom_kill-remove-unneeded-is_memcg_oom-check
+++ a/mm/oom_kill.c
@@ -93,9 +93,6 @@ static bool oom_cpuset_eligible(struct t
 	bool ret = false;
 	const nodemask_t *mask = oc->nodemask;
 
-	if (is_memcg_oom(oc))
-		return true;
-
 	rcu_read_lock();
 	for_each_thread(start, tsk) {
 		if (mask) {
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

