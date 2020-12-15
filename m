Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A80D7C2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6ECD922473
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgLODHi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:07:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:33686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbgLODHc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:07:32 -0500
Date:   Mon, 14 Dec 2020 19:07:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001631;
        bh=AzQoitgxucaSr0i+7rj2ck6mdTgUJM+muCbk06JTJr0=;
        h=From:To:Subject:In-Reply-To:From;
        b=bvuYnEIWa8XNa53aeZxis2ctPmOy6C9taDJgEBbmjrKVHFjz8qExntWyo2/ZrNqlJ
         Gm5U6D558Gn4mO1Zs2SbPRssdtES+M26+1ifrz3/8NReAWBd6gfHemJd1BJYaWYmhP
         heljGH923VTfjIE1LPVVF/b2kv0mx74MvSTN0DXc=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 070/200] mm/memcg: remove incorrect comment
Message-ID: <20201215030710.aPdVZvaxM%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/memcg: remove incorrect comment

Swapcache readahead pages are charged before being used, so it is unlikely
that they will be migrated before charging.  Remove the incorrect comment.

Link: https://lkml.kernel.org/r/1605864930-49405-1-git-send-email-alex.shi@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/memcontrol.c~mm-memcg-remove-incorrect-comments
+++ a/mm/memcontrol.c
@@ -6903,7 +6903,6 @@ void mem_cgroup_migrate(struct page *old
 	if (newpage->mem_cgroup)
 		return;
 
-	/* Swapcache readahead pages can get replaced before being charged */
 	memcg = oldpage->mem_cgroup;
 	if (!memcg)
 		return;
_
