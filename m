Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29156C77B7A
	for <mm-commits@archiver.kernel.org>; Fri,  2 Jun 2023 18:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237071AbjFBSpI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 2 Jun 2023 14:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237082AbjFBSpD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 2 Jun 2023 14:45:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603E91B1
        for <mm-commits@vger.kernel.org>; Fri,  2 Jun 2023 11:45:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD5546528F
        for <mm-commits@vger.kernel.org>; Fri,  2 Jun 2023 18:45:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133BDC433D2;
        Fri,  2 Jun 2023 18:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685731500;
        bh=uyeldwP6Qy7nWxBBX8u+t9FfMEM+Mb/zA5qwzdBLGk0=;
        h=Date:To:From:Subject:From;
        b=bAgLw3rNmEyXmNNRktUNXaxb3bDM75W3ahDS412HcnG/ljk6Py/Kas+aHiu7dDg4a
         ytdlbiCyFwPpbaJwt4TMI3OZBBrFqjd8RcBsM2DOvNBM2OzYuNAqijdYbg2Gf7yxS2
         0RJnq9/N64ZnnsF1epguQEWR0ZzVgJfQ37vLe+Ro=
Date:   Fri, 02 Jun 2023 11:44:59 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, mhocko@suse.com,
        frederic@kernel.org, cl@linux.com, atomlin@atomlin.com,
        mtosatti@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + vmstat-allow_direct_reclaim-should-use-zone_page_state_snapshot.patch added to mm-unstable branch
Message-Id: <20230602184500.133BDC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: vmstat: allow_direct_reclaim should use zone_page_state_snapshot
has been added to the -mm mm-unstable branch.  Its filename is
     vmstat-allow_direct_reclaim-should-use-zone_page_state_snapshot.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/vmstat-allow_direct_reclaim-should-use-zone_page_state_snapshot.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Marcelo Tosatti <mtosatti@redhat.com>
Subject: vmstat: allow_direct_reclaim should use zone_page_state_snapshot
Date: Tue, 30 May 2023 11:52:35 -0300

A customer provided evidence indicating that a process
was stalled in direct reclaim:

 - The process was trapped in throttle_direct_reclaim().
   The function wait_event_killable() was called to wait condition
   allow_direct_reclaim(pgdat) for current node to be true.
   The allow_direct_reclaim(pgdat) examined the number of free pages
   on the node by zone_page_state() which just returns value in
   zone->vm_stat[NR_FREE_PAGES].

 - On node #1, zone->vm_stat[NR_FREE_PAGES] was 0.
   However, the freelist on this node was not empty.

 - This inconsistent of vmstat value was caused by percpu vmstat on
   nohz_full cpus. Every increment/decrement of vmstat is performed
   on percpu vmstat counter at first, then pooled diffs are cumulated
   to the zone's vmstat counter in timely manner. However, on nohz_full
   cpus (in case of this customer's system, 48 of 52 cpus) these pooled
   diffs were not cumulated once the cpu had no event on it so that
   the cpu started sleeping infinitely.
   I checked percpu vmstat and found there were total 69 counts not
   cumulated to the zone's vmstat counter yet.

 - In this situation, kswapd did not help the trapped process.
   In pgdat_balanced(), zone_wakermark_ok_safe() examined the number
   of free pages on the node by zone_page_state_snapshot() which
   checks pending counts on percpu vmstat.
   Therefore kswapd could know there were 69 free pages correctly.
   Since zone->_watermark = {8, 20, 32}, kswapd did not work because
   69 was greater than 32 as high watermark.

Change allow_direct_reclaim to use zone_page_state_snapshot, which
allows a more precise version of the vmstat counters to be used.

allow_direct_reclaim will only be called from try_to_free_pages,
which is not a hot path.

Testing: Due to difficulties accessing the system, it has not been
possible for the reproducer to test the patch (however its
clear from available data and analysis that it should fix it).

Link: https://lkml.kernel.org/r/20230530145335.677325196@redhat.com
Reviewed-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~vmstat-allow_direct_reclaim-should-use-zone_page_state_snapshot
+++ a/mm/vmscan.c
@@ -6918,7 +6918,7 @@ static bool allow_direct_reclaim(pg_data
 			continue;
 
 		pfmemalloc_reserve += min_wmark_pages(zone);
-		free_pages += zone_page_state(zone, NR_FREE_PAGES);
+		free_pages += zone_page_state_snapshot(zone, NR_FREE_PAGES);
 	}
 
 	/* If there are no reserves (unexpected config) then do not throttle */
_

Patches currently in -mm which might be from mtosatti@redhat.com are

vmstat-allow_direct_reclaim-should-use-zone_page_state_snapshot.patch

