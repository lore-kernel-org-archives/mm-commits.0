Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C764CC15502
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A12A64EDF
	for <mm-commits@archiver.kernel.org>; Thu,  4 Mar 2021 00:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344010AbhCDA7G (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:59:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:60152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346721AbhCDARF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Mar 2021 19:17:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C4D164F27;
        Wed,  3 Mar 2021 23:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614814708;
        bh=tVskCxQSqq+/X8oh+LhWKyD1QElcnCRmRviW0F1R8I4=;
        h=Date:From:To:Subject:From;
        b=YNaKI22yOaDeV7jzlZlNeAnUY8wYEzZbQvKcepIvyNMQIsTsIVTBnybiMJZ94K3yI
         e7i/05UHAGxC++hjoC8IMQ5pEsOZjHy+n3NyCO8sQDzMFNVbniAHKujIhVLK3l3ZFX
         V/My/XhcWEZH30nv8hVWxMD7VTR8JNrvFPRaUnA8=
Date:   Wed, 03 Mar 2021 15:38:27 -0800
From:   akpm@linux-foundation.org
To:     guro@fb.com, hannes@cmpxchg.org, hughd@google.com,
        mhocko@kernel.org, mm-commits@vger.kernel.org, vbabka@suse.cz
Subject:  +
 mm-restore-node-stat-checking-in-proc-sys-vm-stat_refresh.patch added to
 -mm tree
Message-ID: <20210303233827.vLzOeAKAx%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: restore node stat checking in /proc/sys/vm/stat_refresh
has been added to the -mm tree.  Its filename is
     mm-restore-node-stat-checking-in-proc-sys-vm-stat_refresh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-restore-node-stat-checking-in-proc-sys-vm-stat_refresh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-restore-node-stat-checking-in-proc-sys-vm-stat_refresh.patch

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
Subject: mm: restore node stat checking in /proc/sys/vm/stat_refresh

v4.7 52b6f46bc163 ("mm: /proc/sys/vm/stat_refresh to force vmstat update")
introduced vmstat_refresh(), with its vmstat underflow checking; then v4.8
75ef71840539 ("mm, vmstat: add infrastructure for per-node vmstats") split
NR_VM_NODE_STAT_ITEMS out of NR_VM_ZONE_STAT_ITEMS without updating
vmstat_refresh(): so it has been missing out much of the vmstat underflow
checking ever since.  Reinstate it.  Thanks to Roman Gushchin
<guro@fb.com> for tangentially pointing this out.

Link: https://lkml.kernel.org/r/alpine.LSU.2.11.2102251502240.13363@eggly.anvils
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/vmstat.c~mm-restore-node-stat-checking-in-proc-sys-vm-stat_refresh
+++ a/mm/vmstat.c
@@ -1875,6 +1875,14 @@ int vmstat_refresh(struct ctl_table *tab
 		}
 	}
 #endif
+	for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
+		val = atomic_long_read(&vm_node_stat[i]);
+		if (val < 0) {
+			pr_warn("%s: %s %ld\n",
+				__func__, node_stat_name(i), val);
+			err = -EINVAL;
+		}
+	}
 	if (err)
 		return err;
 	if (write)
_

Patches currently in -mm which might be from hughd@google.com are

mm-restore-node-stat-checking-in-proc-sys-vm-stat_refresh.patch
mm-no-more-einval-from-proc-sys-vm-stat_refresh.patch
mm-proc-sys-vm-stat_refresh-skip-checking-known-negative-stats.patch
mm-proc-sys-vm-stat_refresh-stop-checking-monotonic-numa-stats.patch

