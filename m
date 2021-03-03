Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F27DC43331
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5175964F34
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245517AbhCDA7E (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:59:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:60150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346977AbhCDARF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:17:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E286E64F25;
        Wed,  3 Mar 2021 23:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614814711;
        bh=EwEqcLxt8IuUOStIHZhvRQDsfrcPtPBHU+9Lq5+25Vg=;
        h=Date:From:To:Subject:From;
        b=jEy676JNlb6MQUDbCJStUOmUus4mv6meoh0wTnPe69zaUmdxsMTPRH7teVvWT5wb3
         GSOAKQOKtlkZVA5MkfV+zGph4n42S19r0QHLUDSPhQTSfqt4181YbAY+WaVV8tqFcM
         ZHLLfeBZzTV2637veZdXpFU3FzI8JPLiWAb6mp7c=
Date:   Wed, 03 Mar 2021 15:38:30 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, hughd@google.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  + mm-no-more-einval-from-proc-sys-vm-stat_refresh.patch
 added to -mm tree
Message-ID: <20210303233830.-XapGhhcE%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: no more EINVAL from /proc/sys/vm/stat_refresh
has been added to the -mm tree.  Its filename is
     mm-no-more-einval-from-proc-sys-vm-stat_refresh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-no-more-einval-from-proc-sys-vm-stat_refresh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-no-more-einval-from-proc-sys-vm-stat_refresh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from hughd@google.com are

mm-restore-node-stat-checking-in-proc-sys-vm-stat_refresh.patch
mm-no-more-einval-from-proc-sys-vm-stat_refresh.patch
mm-proc-sys-vm-stat_refresh-skip-checking-known-negative-stats.patch
mm-proc-sys-vm-stat_refresh-stop-checking-monotonic-numa-stats.patch

