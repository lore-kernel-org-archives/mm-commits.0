Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39BE8C43461
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:38:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DECC611AB
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:38:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhEEBiz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:38:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231132AbhEEBiz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:38:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA4D2610A1;
        Wed,  5 May 2021 01:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178675;
        bh=O1P92AmCrr/KAm7r5tlKKsf26kXlE6tfG1HXivuuGQs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=bBpnrM15j6qerTu000V+xhn8jaVERfQPS2pB1hGCMNsIa/1ODFL0DCzwefJu+FGsY
         bzG6DrYKpJbY1sLqBhuex9bPgHvy2JC3PEP0e9elRcuwnjX/UKZwKqRCZWHJcdTTld
         PnjFbech1JZ2eY+0GsAluN+mkljA0TenI6CKwCsg=
Date:   Tue, 04 May 2021 18:37:54 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, guro@fb.com, hannes@cmpxchg.org,
        hughd@google.com, linux-mm@kvack.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vbabka@suse.cz
Subject:  [patch 097/143] mm: no more EINVAL from
 /proc/sys/vm/stat_refresh
Message-ID: <20210505013754.Udec-NlXE%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Subject: mm: no more EINVAL from /proc/sys/vm/stat_refresh

EINVAL was good for drawing the refresher's attention to a warning in
dmesg, but became very tiresome when running test suites scripted with
"set -e": an underflow from a bug in one feature would cause unrelated
tests much later to fail, just because their /proc/sys/vm/stat_refresh
touch failed with that error.  Stop doing that.

Link: https://lkml.kernel.org/r/alpine.LSU.2.11.2102251510410.13363@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/mm/vmstat.c~mm-no-more-einval-from-proc-sys-vm-stat_refresh
+++ a/mm/vmstat.c
@@ -1862,7 +1862,6 @@ int vmstat_refresh(struct ctl_table *tab
 		if (val < 0) {
 			pr_warn("%s: %s %ld\n",
 				__func__, zone_stat_name(i), val);
-			err = -EINVAL;
 		}
 	}
 #ifdef CONFIG_NUMA
@@ -1871,7 +1870,6 @@ int vmstat_refresh(struct ctl_table *tab
 		if (val < 0) {
 			pr_warn("%s: %s %ld\n",
 				__func__, numa_stat_name(i), val);
-			err = -EINVAL;
 		}
 	}
 #endif
@@ -1880,11 +1878,8 @@ int vmstat_refresh(struct ctl_table *tab
 		if (val < 0) {
 			pr_warn("%s: %s %ld\n",
 				__func__, node_stat_name(i), val);
-			err = -EINVAL;
 		}
 	}
-	if (err)
-		return err;
 	if (write)
 		*ppos += *lenp;
 	else
_
