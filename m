Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C05DC43462
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:38:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D61561423
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:38:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbhEEBi5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:38:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231132AbhEEBi4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:38:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF587610A1;
        Wed,  5 May 2021 01:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178681;
        bh=EDYGXBVml3ijoK1GHb/3hAb2yROFDnC4wEUA56kwdAo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=b/9DHCrH0oJ6W63m3doYY5rLGxUHYH8xgeP6ta4A23SKuwdO4WOS0mU3js4MA+GRQ
         AHluVimnjnLMFO0Ejz7Q65LDdbXb+z3usc7o6LR8F3UB7TRIRzcrwdnnZZm2eoMVkg
         PU/TH/TYyQwtWgJwZe1feTYl1xn2o2FzCTulImeI=
Date:   Tue, 04 May 2021 18:38:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        hughd@google.com, linux-mm@kvack.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 099/143] mm: /proc/sys/vm/stat_refresh stop
 checking monotonic numa stats
Message-ID: <20210505013800.zDzXMpFCk%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
