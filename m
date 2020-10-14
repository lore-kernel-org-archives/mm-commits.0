Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C10C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2CA622248
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709229;
	bh=GYEkHazzs0zHzE295FoV0GDZBMee8SozUHIE3Shprlk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=qHJneCP07LcWRSKaT6hLZ9qFTdnjul57khPQs5n5bfHPbNfassexGPS5Os+ikZeL/
	 fUTVL9qEPQXeNipO+aVIwq96Cwk2NGh5JkTfcK08MtQDHdHtQ6+rerDAijueI3AzqL
	 Oga3UwbvSjYg9exVQeT+AE0Urq8ujFzB3HA1BACU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgJNVA2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:50750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725923AbgJNVA2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:00:28 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F33A2068E;
        Wed, 14 Oct 2020 21:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709227;
        bh=GYEkHazzs0zHzE295FoV0GDZBMee8SozUHIE3Shprlk=;
        h=Date:From:To:Subject:From;
        b=0zhvkBwmRtBEdsn4zrydRjtfTsA8xdhCiD24JQim0HaTFUwSO39btKZhm0Qyqb1i2
         ojhsFV2sbD4e/j3HEpGZzuX6Jv+QDhmHTcTz6rPj/VXKO4drhuX8fH0bd1YpsqZZGx
         qmlHcF8ufjIgO7G/7AfV98CTBrw151aad/5nPwt0=
Date:   Wed, 14 Oct 2020 14:00:27 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, linmiaohe@huawei.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-reword-obsolete-comment-of-mem_cgroup_unmark_under_oom.patch
 removed from -mm tree
Message-ID: <20201014210027.KmJXi9ePR%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: reword obsolete comment of mem_cgroup_unmark_under_oom()
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-reword-obsolete-comment-of-mem_cgroup_unmark_under_oom.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: memcontrol: reword obsolete comment of mem_cgroup_unmark_under_oom()

Since commit 79dfdaccd1d5 ("memcg: make oom_lock 0 and 1 based rather than
counter"), the mem_cgroup_unmark_under_oom() is added and the comment of
the mem_cgroup_oom_unlock() is moved here.  But this comment make no sense
here because mem_cgroup_oom_lock() does not operate on under_oom field. 
So we reword the comment as this would be helpful.  [Thanks Michal Hocko
for rewording this comment.]

Link: https://lkml.kernel.org/r/20200930095336.21323-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-reword-obsolete-comment-of-mem_cgroup_unmark_under_oom
+++ a/mm/memcontrol.c
@@ -1826,8 +1826,8 @@ static void mem_cgroup_unmark_under_oom(
 	struct mem_cgroup *iter;
 
 	/*
-	 * When a new child is created while the hierarchy is under oom,
-	 * mem_cgroup_oom_lock() may not be called. Watch for underflow.
+	 * Be careful about under_oom underflows becase a child memcg
+	 * could have been added after mem_cgroup_mark_under_oom.
 	 */
 	spin_lock(&memcg_oom_lock);
 	for_each_mem_cgroup_tree(iter, memcg)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-vmstat-use-helper-macro-abs.patch
mm-fix-some-broken-comments.patch
mm-use-helper-function-put_write_access.patch
percpu_counter-use-helper-macro-abs.patch
mm-migrate-avoid-possible-unnecessary-process-right-check-in-kernel_move_pages.patch

