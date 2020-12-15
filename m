Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C576C4361B
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01A87224D4
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgLODOA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:14:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728095AbgLODNV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:13:21 -0500
Date:   Mon, 14 Dec 2020 19:12:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608001970;
        bh=0rW3v+8rHmp6sWNd9Az19b5Cuxhz1yKIMacjd//77Tc=;
        h=From:To:Subject:In-Reply-To:From;
        b=qgj0RBn2jFgG+sdnu+Ci43jQrXNiomSkw+25Nx18r9yoAisBByntvc2a35ujJj7dK
         o5j8gNT9jE/Ua69QCG9MhyvcqYIbRSjfKWg0FD28JsOJzndZpwSK3VyXPFKjdaD93E
         ++ZjGC++Yv7JwoenMzvZpRVJ6tjy9FgYpSbxUWCk=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org, mhocko@suse.com,
        mm-commits@vger.kernel.org, sh_def@163.com,
        torvalds@linux-foundation.org
Subject:  [patch 162/200] mm/oom_kill: change comment and rename
 is_dump_unreclaim_slabs()
Message-ID: <20201215031249.xd7Y7EU-N%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hui Su <sh_def@163.com>
Subject: mm/oom_kill: change comment and rename is_dump_unreclaim_slabs()

Change the comment of is_dump_unreclaim_slabs(), it just check whether
nr_unreclaimable slabs amount is greater than user memory, and explain why
we dump unreclaim slabs.

Rename it to should_dump_unreclaim_slab() maybe better.

Link: https://lkml.kernel.org/r/20201030182704.GA53949@rlk
Signed-off-by: Hui Su <sh_def@163.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/mm/oom_kill.c~mm-oom_kill-change-comment-and-rename-is_dump_unreclaim_slabs
+++ a/mm/oom_kill.c
@@ -170,11 +170,13 @@ static bool oom_unkillable_task(struct t
 	return false;
 }
 
-/*
- * Print out unreclaimble slabs info when unreclaimable slabs amount is greater
- * than all user memory (LRU pages)
- */
-static bool is_dump_unreclaim_slabs(void)
+/**
+ * Check whether unreclaimable slab amount is greater than
+ * all user memory(LRU pages).
+ * dump_unreclaimable_slab() could help in the case that
+ * oom due to too much unreclaimable slab used by kernel.
+*/
+static bool should_dump_unreclaim_slab(void)
 {
 	unsigned long nr_lru;
 
@@ -463,7 +465,7 @@ static void dump_header(struct oom_contr
 		mem_cgroup_print_oom_meminfo(oc->memcg);
 	else {
 		show_mem(SHOW_MEM_FILTER_NODES, oc->nodemask);
-		if (is_dump_unreclaim_slabs())
+		if (should_dump_unreclaim_slab())
 			dump_unreclaimable_slab();
 	}
 	if (sysctl_oom_dump_tasks)
_
