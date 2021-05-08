Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9B98C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5E0661402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhEHWuw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:50:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhEHWuv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:50:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9DD456101D;
        Sat,  8 May 2021 22:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514189;
        bh=WUhkeT9PHUbFZhGIOdEymdtkkWf3VT43Fw1Sdk0hKNA=;
        h=Date:From:To:Subject:From;
        b=ZQMvsOzWG3WnjJR0JqS/jEfzmelQN33K7S0BTVvYICqsfRk/Avq4InacF3MJRSQeo
         /pDTvjj7TBLWpX42ExaJClr4gseCAZjX/dsOdjd+BHMjUt0Gq4KOHgdVwiBZZvGn+d
         VAv3NPcDPRr9Zf2OX1TjCi1oBOa0Fgz3cEs/jZKU=
Date:   Sat, 08 May 2021 15:49:49 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, hughd@google.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 mm-proc-sys-vm-stat_refresh-stop-checking-monotonic-numa-stats.patch
 removed from -mm tree
Message-ID: <20210508224949.7exp93FE0%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: /proc/sys/vm/stat_refresh stop checking monotonic numa stats
has been removed from the -mm tree.  Its filename was
     mm-proc-sys-vm-stat_refresh-stop-checking-monotonic-numa-stats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: /proc/sys/vm/stat_refresh stop checking monotonic numa stats

All of the VM NUMA stats are event counts, incremented never decremented:
it is not very useful for vmstat_refresh() to check them throughout their
first aeon, then warn on them throughout their next.

Link: https://lkml.kernel.org/r/alpine.LSU.2.11.2102251514110.13363@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/mm/vmstat.c~mm-proc-sys-vm-stat_refresh-stop-checking-monotonic-numa-stats
+++ a/mm/vmstat.c
@@ -1872,15 +1872,6 @@ int vmstat_refresh(struct ctl_table *tab
 				__func__, zone_stat_name(i), val);
 		}
 	}
-#ifdef CONFIG_NUMA
-	for (i = 0; i < NR_VM_NUMA_STAT_ITEMS; i++) {
-		val = atomic_long_read(&vm_numa_stat[i]);
-		if (val < 0) {
-			pr_warn("%s: %s %ld\n",
-				__func__, numa_stat_name(i), val);
-		}
-	}
-#endif
 	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
 		/*
 		 * Skip checking stats known to go negative occasionally.
_

Patches currently in -mm which might be from hughd@google.com are


