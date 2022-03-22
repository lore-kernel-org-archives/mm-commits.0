Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4422C43217
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:46:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236509AbiCVVrf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236532AbiCVVrd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:47:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CE015F8F0
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:46:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2EED3B81DB9
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2866C340EC;
        Tue, 22 Mar 2022 21:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985563;
        bh=L/2shDOh3xnUyMXVRhAr6pEdFIeqol9RjJVq2cMCBtQ=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=H0wzKb6jnOn1VRyAvw5n7VEQMVNrILzbRdZ5D8tTlPj4gw0y/9+JnjAuAu95gTE2Z
         wYqu5lwJBnCs7BCJnKaJmyS48xHflWTauGkX7h7El85is5UCy58HArWy7GxBatQ9uW
         6/XSblcr7BZuoXlGitx1rzZq1YM3WsW2o2IGcJ6k=
Date:   Tue, 22 Mar 2022 14:46:02 -0700
To:     rientjes@google.com, mhocko@suse.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 148/227] mm/oom_kill: remove unneeded is_memcg_oom check
Message-Id: <20220322214602.E2866C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
