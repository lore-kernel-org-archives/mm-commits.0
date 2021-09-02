Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23F08C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F21F60F12
	for <mm-commits@archiver.kernel.org>; Thu,  2 Sep 2021 21:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347958AbhIBV72 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347950AbhIBV71 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Sep 2021 17:59:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CE99603E9;
        Thu,  2 Sep 2021 21:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630619908;
        bh=bwjAOEhcBl9uf8kV2mHRr9g4TWPj9gCgdVMLy2n5CPk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=P3I4x52y2AB4ovdWvkcTVltz3cPvHtjraRz3GFLBKKwlJagO7gznnFG60df1WfWS0
         K4M47huchi2q7aXPVUed7xVH72upP6Se3914qWl4QMxz8H80O7uVlQ25iIh5kddoSt
         JPdPXiPZkLNX9XvzwBsA7nSh9VZtO1HXK8FNhTCA=
Date:   Thu, 02 Sep 2021 14:58:28 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linmiaohe@huawei.com,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        naoya.horiguchi@nec.com, torvalds@linux-foundation.org
Subject:  [patch 161/212] mm/hwpoison: fix some obsolete comments
Message-ID: <20210902215828.RhzEyZUQj%akpm@linux-foundation.org>
In-Reply-To: <20210902144820.78957dff93d7bea620d55a89@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hwpoison: fix some obsolete comments

Since commit cb731d6c62bb ("vmscan: per memory cgroup slab shrinkers"),
shrink_node_slabs is renamed to drop_slab_node.  And doit argument is
changed to forcekill since commit 6751ed65dc66 ("x86/mce: Fix
siginfo_t->si_addr value for non-recoverable memory faults").

Link: https://lkml.kernel.org/r/20210814105131.48814-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-fix-some-obsolete-comments
+++ a/mm/memory-failure.c
@@ -296,7 +296,7 @@ void shake_page(struct page *p, int acce
 	}
 
 	/*
-	 * Only call shrink_node_slabs here (which would also shrink
+	 * Only call drop_slab_node here (which would also shrink
 	 * other caches) if access is not potentially fatal.
 	 */
 	if (access)
@@ -391,8 +391,8 @@ static void add_to_kill(struct task_stru
 /*
  * Kill the processes that have been collected earlier.
  *
- * Only do anything when DOIT is set, otherwise just free the list
- * (this is used for clean pages which do not need killing)
+ * Only do anything when FORCEKILL is set, otherwise just free the
+ * list (this is used for clean pages which do not need killing)
  * Also when FAIL is set do a force kill because something went
  * wrong earlier.
  */
_
