Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0EA4C49ECA
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C964E22D0A
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 23:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgLOX7l (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:59:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:60868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727849AbgLOXZk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 15 Dec 2020 18:25:40 -0500
Date:   Tue, 15 Dec 2020 15:23:12 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608074592;
        bh=QFvhi54pZKTV8cCrh/Iog8+Rnrs0HBXJNNIsblryLBE=;
        h=From:To:Subject:From;
        b=DbdTdHwoC/W1tYhEOoA4GR+BLnqgCFZADsaig2GQgd9zIHyziaTfqOg0O3/ZA8dZZ
         FdVQE1ijJ2PBkwb5MJl4QMaVQtpEPgpRvhPorEvtV2QNcpbry75qbxGXvcFQQfjvk2
         klusMISyWN0toH+jg4heCO/6LSJQ5J4dCivXyNgw=
From:   akpm@linux-foundation.org
To:     mhocko@suse.com, mm-commits@vger.kernel.org, sh_def@163.com
Subject:  [merged]
 mm-oom_kill-change-comment-and-rename-is_dump_unreclaim_slabs.patch removed
 from -mm tree
Message-ID: <20201215232312.Jl8VTakYs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/oom_kill: change comment and rename is_dump_unreclaim_slabs()
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-change-comment-and-rename-is_dump_unreclaim_slabs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from sh_def@163.com are

fs-proc-make-pde_get-return-nothing.patch
acctc-use-elif-instead-of-end-and-elif.patch
mm-memcontrol-rewrite-mem_cgroup_page_lruvec.patch

