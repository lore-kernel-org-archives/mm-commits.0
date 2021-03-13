Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09FB2C4360C
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 05:08:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB3F764FF5
	for <mm-commits@archiver.kernel.org>; Sat, 13 Mar 2021 05:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbhCMFIO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 13 Mar 2021 00:08:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:42102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231938AbhCMFIE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 13 Mar 2021 00:08:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F9CD64E41;
        Sat, 13 Mar 2021 05:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615612084;
        bh=Wi6CK4S8qvNeM9MEPQ16Q3IB5iWStis3UQzR38APEZ4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=GO4xTX9nZPWszKYY/jdgqGY6VVU9eqUt4fB2ZuaoWU0a9B7+qz/90YFy5Hjm83vf+
         sC978aGhRiU6JIrrDOwPJ9oHcocWh824Kg8TYIqOccZd8hpWR5CAqDQ3KJyuoBs9Nw
         to00u+a0Zg8MG4UEG4EsgFvhiitHY/Xq2zfPeJPs=
Date:   Fri, 12 Mar 2021 21:08:03 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 18/29] include/linux/sched/mm.h: use
 rcu_dereference in in_vfork()
Message-ID: <20210313050803.CFTW-ffYI%akpm@linux-foundation.org>
In-Reply-To: <20210312210632.9b7d62973d72a56fb13c7a03@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: include/linux/sched/mm.h: use rcu_dereference in in_vfork()

Fix a sparse warning by using rcu_dereference().  Technically this is a
bug and a sufficiently aggressive compiler could reload the `real_parent'
pointer outside the protection of the rcu lock (and access freed memory),
but I think it's pretty unlikely to happen.

Link: https://lkml.kernel.org/r/20210221194207.1351703-1-willy@infradead.org
Fixes: b18dc5f291c0 ("mm, oom: skip vforked tasks from being selected")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/sched/mm.h~mm-use-rcu_dereference-in-in_vfork
+++ a/include/linux/sched/mm.h
@@ -140,7 +140,8 @@ static inline bool in_vfork(struct task_
 	 * another oom-unkillable task does this it should blame itself.
 	 */
 	rcu_read_lock();
-	ret = tsk->vfork_done && tsk->real_parent->mm == tsk->mm;
+	ret = tsk->vfork_done &&
+			rcu_dereference(tsk->real_parent)->mm == tsk->mm;
 	rcu_read_unlock();
 
 	return ret;
_
