Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F3AC15501
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E551F64EBD
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344279AbhCDA7K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:59:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346687AbhCDARF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:17:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1C8964F2D;
        Wed,  3 Mar 2021 23:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614814716;
        bh=992XVy0LG71AslI0ImNT/kYoNhbUQsKDB4OsWgt0Kx0=;
        h=Date:From:To:Subject:From;
        b=emroZZtDCHA19Xm2IYMHigsHImD5NQkPbFZ6aCZxHIJqS2kmS9RBr/duSiTP0feeD
         H3/yoPf8WU2KgCp23nvZVyZtQ2wyVJ7cVSy9D+CKieKhav+ChfbaAnDKafrWl3FsWS
         BmtkkTCgLs7whcxeRM/H1TzJcLiUutzeDYar81uA=
Date:   Wed, 03 Mar 2021 15:38:35 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, hughd@google.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  +
 mm-proc-sys-vm-stat_refresh-stop-checking-monotonic-numa-stats.patch added
 to -mm tree
Message-ID: <20210303233835.2-2WlxIvM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: /proc/sys/vm/stat_refresh stop checking monotonic numa stats
has been added to the -mm tree.  Its filename is
     mm-proc-sys-vm-stat_refresh-stop-checking-monotonic-numa-stats.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-proc-sys-vm-stat_refresh-stop-checking-monotonic-numa-stats.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-proc-sys-vm-stat_refresh-stop-checking-monotonic-numa-stats.patch

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

mm-restore-node-stat-checking-in-proc-sys-vm-stat_refresh.patch
mm-no-more-einval-from-proc-sys-vm-stat_refresh.patch
mm-proc-sys-vm-stat_refresh-skip-checking-known-negative-stats.patch
mm-proc-sys-vm-stat_refresh-stop-checking-monotonic-numa-stats.patch

