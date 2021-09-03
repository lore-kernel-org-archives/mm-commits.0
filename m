Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 745D4C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 557236113C
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 21:00:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350205AbhICVBk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 17:01:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350431AbhICVBc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 17:01:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A94CB610FD;
        Fri,  3 Sep 2021 21:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702832;
        bh=nYFqEWjvvombK2w/7qtE7oWX+PtXI/SyBTveaHR7G70=;
        h=Date:From:To:Subject:From;
        b=ZyFJKICXm98j0TWa9k00C5eAsOMzJ2jEnqCc+SUyqtPv+JymM1D+8qpQyvY0oFE0m
         CBnLdFyeiRFVdEp73ghmYZfIzbDA1L6kNKA1iBtUGvPfVDby4cjkIbQG/NZlV+290o
         aB4S1l9ZveQHrE6rZCk7LvPjaffZh557G38bIE5g=
Date:   Fri, 03 Sep 2021 14:00:31 -0700
From:   akpm@linux-foundation.org
To:     dan.j.williams@intel.com, dave.hansen@linux.intel.com,
        david@redhat.com, gthelen@google.com, kbusch@kernel.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@suse.de,
        rientjes@google.com, shy828301@gmail.com, weixugc@google.com,
        yang.shi@linux.alibaba.com, ying.huang@intel.com, ziy@nvidia.com
Subject:  [merged] mm-vmscan-add-page-demotion-counter.patch
 removed from -mm tree
Message-ID: <20210903210031.wnWjvW_Ch%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmscan: add page demotion counter
has been removed from the -mm tree.  Its filename was
     mm-vmscan-add-page-demotion-counter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linux.alibaba.com>
Subject: mm/vmscan: add page demotion counter

Account the number of demoted pages.

Add pgdemote_kswapd and pgdemote_direct VM counters showed in
/proc/vmstat.

[ daveh:
   - __count_vm_events() a bit, and made them look at the THP
     size directly rather than getting data from migrate_pages()
]

Link: https://lkml.kernel.org/r/20210721063926.3024591-5-ying.huang@intel.com
Link: https://lkml.kernel.org/r/20210715055145.195411-6-ying.huang@intel.com
Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Wei Xu <weixugc@google.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Greg Thelen <gthelen@google.com>
Cc: Keith Busch <kbusch@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vm_event_item.h |    2 ++
 mm/vmscan.c                   |    5 +++++
 mm/vmstat.c                   |    2 ++
 3 files changed, 9 insertions(+)

--- a/include/linux/vm_event_item.h~mm-vmscan-add-page-demotion-counter
+++ a/include/linux/vm_event_item.h
@@ -33,6 +33,8 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 		PGREUSE,
 		PGSTEAL_KSWAPD,
 		PGSTEAL_DIRECT,
+		PGDEMOTE_KSWAPD,
+		PGDEMOTE_DIRECT,
 		PGSCAN_KSWAPD,
 		PGSCAN_DIRECT,
 		PGSCAN_DIRECT_THROTTLE,
--- a/mm/vmscan.c~mm-vmscan-add-page-demotion-counter
+++ a/mm/vmscan.c
@@ -1318,6 +1318,11 @@ static unsigned int demote_page_list(str
 			    target_nid, MIGRATE_ASYNC, MR_DEMOTION,
 			    &nr_succeeded);
 
+	if (current_is_kswapd())
+		__count_vm_events(PGDEMOTE_KSWAPD, nr_succeeded);
+	else
+		__count_vm_events(PGDEMOTE_DIRECT, nr_succeeded);
+
 	return nr_succeeded;
 }
 
--- a/mm/vmstat.c~mm-vmscan-add-page-demotion-counter
+++ a/mm/vmstat.c
@@ -1217,6 +1217,8 @@ const char * const vmstat_text[] = {
 	"pgreuse",
 	"pgsteal_kswapd",
 	"pgsteal_direct",
+	"pgdemote_kswapd",
+	"pgdemote_direct",
 	"pgscan_kswapd",
 	"pgscan_direct",
 	"pgscan_direct_throttle",
_

Patches currently in -mm which might be from yang.shi@linux.alibaba.com are


