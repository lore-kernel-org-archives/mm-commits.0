Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFBDEC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D3D861402
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhEHWuq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:50:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229577AbhEHWup (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:50:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 888786100C;
        Sat,  8 May 2021 22:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514183;
        bh=7o1xGQKxexCI2eZ1UAdrSZaxddtbOSBJS04cbXEaaAc=;
        h=Date:From:To:Subject:From;
        b=rRCE4h3xr5u7BuI46Egfx1FkS3o55G+wJScuUWaA5m2CVYzAFELBOUPO1CYlINlIG
         b4L+vXY/gPH3gfYroZYozAwrLs/VQQUTZIiXMSdn663tlzP/JA+5y2zvxM309Te0nP
         88rSosL0TkEqPd1jFsC1HGDYARiNOp8t05Rmsy8I=
Date:   Sat, 08 May 2021 15:49:43 -0700
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, hughd@google.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  [merged]
 mm-no-more-einval-from-proc-sys-vm-stat_refresh.patch removed from -mm tree
Message-ID: <20210508224943.ozrhyMvfd%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: no more EINVAL from /proc/sys/vm/stat_refresh
has been removed from the -mm tree.  Its filename was
     mm-no-more-einval-from-proc-sys-vm-stat_refresh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


