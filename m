Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA632C2BB48
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B073E223E4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgLODHp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:07:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:35612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbgLODHm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:07:42 -0500
Date:   Mon, 14 Dec 2020 19:07:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001622;
        bh=wxVQ2UH9eixlyaUjvqZXoBu5EOjef72HoyPwMKPUTqI=;
        h=From:To:Subject:In-Reply-To:From;
        b=N0pj2kyuGa50fU3DOv5oyxL5mjn6lv2jBgXe+uPCDbf6wWfhybuqxqvrPm+bkI9I/
         kTeVs47jT6J1uHSFxI5PAZ/t9wRHey8PeDfpXN+EUF5YBvDM/SgUuxvCJRptlb0Ijd
         /oVK/Z2TWElI2F+DBM8Gud/ZjYQDwCdkvkpKGwIc=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        linux-mm@kvack.org, lukas.bulwahn@gmail.com, mhocko@suse.com,
        mm-commits@vger.kernel.org, natechancellor@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 067/200] mm: memcg: remove obsolete
 memcg_has_children()
Message-ID: <20201215030701.qGriOT4tw%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: mm: memcg: remove obsolete memcg_has_children()

Commit 2ef1bf118c40 ("mm: memcg: deprecate the non-hierarchical mode")
removed the only use of memcg_has_children() in
mem_cgroup_hierarchy_write() as part of the feature deprecation.

Hence, since then, make CC=clang W=1 warns:

  mm/memcontrol.c:3421:20:
    warning: unused function 'memcg_has_children' [-Wunused-function]

Simply remove this obsolete unused function.

Link: https://lkml.kernel.org/r/20201116055043.20886-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   13 -------------
 1 file changed, 13 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-remove-obsolete-memcg_has_children
+++ a/mm/memcontrol.c
@@ -3454,19 +3454,6 @@ unsigned long mem_cgroup_soft_limit_recl
 }
 
 /*
- * Test whether @memcg has children, dead or alive.
- */
-static inline bool memcg_has_children(struct mem_cgroup *memcg)
-{
-	bool ret;
-
-	rcu_read_lock();
-	ret = css_next_child(NULL, &memcg->css);
-	rcu_read_unlock();
-	return ret;
-}
-
-/*
  * Reclaims as many pages from the given memcg as possible.
  *
  * Caller is responsible for holding css reference for memcg.
_
